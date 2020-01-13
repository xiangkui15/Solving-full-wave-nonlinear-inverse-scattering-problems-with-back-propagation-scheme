function net = add_block_convt_test(net, opts, id, h, w, in, out, upsample, crop,batchOn,ReluOn)
% --------------------------------------------------------------------
% crop=[2 3 2 3];
info = vl_simplenn_display(net) ;
fc = (h == info.dataSize(1,end) && w == info.dataSize(2,end)) ;
if fc
    name = 'fc' ;
else
    name = 'convt' ;
end
convOpts = {'CudnnWorkspaceLimit', opts.cudnnWorkspaceLimit} ;
net.layers{end+1} = struct('type', 'convt', 'name', sprintf('%s%s', name, id), ...
    'weights', {{init_weight_test(opts, h, w, out, in, 'single'), zeros(out, 1, 'single')}}, ...
    'upsample', upsample, ...
    'crop', crop, ...
    'learningRate', [1 2], ...
    'weightDecay', [opts.weightDecay 0], ...
    'opts', {convOpts}) ;
if (opts.batchNormalization)&&batchOn
    net.layers{end+1} = struct('type', 'bnorm', 'name', sprintf('bn%s',id), ...
        'weights', {{ones(out, 1, 'single'), zeros(out, 1, 'single'), zeros(out, 2, 'single')}}, ...
        'learningRate', [2 1 0.05], ...
        'weightDecay', [0 0]) ;
end
if ReluOn
net.layers{end+1} = struct('type', 'relu', 'name', sprintf('relu%s',id)) ;
end