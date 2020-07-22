Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8214D229FFD
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgGVTSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:18:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:24713 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgGVTSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 15:18:20 -0400
IronPort-SDR: 28df/czH63vY01Idh2AnAdQYQKcqhw0nxdOHYTGBHKSRBlK2yNFRK0ma+kI8rhx9ecmCLacy87
 x++7R8OYOQaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="168549343"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="168549343"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 12:18:20 -0700
IronPort-SDR: iHlPcRjVTLW3toZUI+mwfsaQl9EhxVDinVg6F6LIc27rHlddMLyK044IdAOCdeVnzXh9o8zc/e
 +7HoQjDLPJmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="432484813"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 22 Jul 2020 12:18:17 -0700
Date:   Wed, 22 Jul 2020 21:13:20 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, dsahern@gmail.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 3/9] bpf, xdp: extract common XDP program
 attachment logic
Message-ID: <20200722191320.GC8874@ranger.igk.intel.com>
References: <20200722064603.3350758-1-andriin@fb.com>
 <20200722064603.3350758-4-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722064603.3350758-4-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 11:45:56PM -0700, Andrii Nakryiko wrote:
> Further refactor XDP attachment code. dev_change_xdp_fd() is split into two
> parts: getting bpf_progs from FDs and attachment logic, working with
> bpf_progs. This makes attachment  logic a bit more straightforward and
> prepares code for bpf_xdp_link inclusion, which will share the common logic.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  net/core/dev.c | 165 +++++++++++++++++++++++++++----------------------
>  1 file changed, 91 insertions(+), 74 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7e753e248cef..abf573b2dcf4 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8815,111 +8815,128 @@ static void dev_xdp_uninstall(struct net_device *dev)
>  	}
>  }
>  
> -/**
> - *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
> - *	@dev: device
> - *	@extack: netlink extended ack
> - *	@fd: new program fd or negative value to clear
> - *	@expected_fd: old program fd that userspace expects to replace or clear
> - *	@flags: xdp-related flags
> - *
> - *	Set or clear a bpf program for a device
> - */
> -int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
> -		      int fd, int expected_fd, u32 flags)
> +static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack,
> +			  struct bpf_prog *new_prog, struct bpf_prog *old_prog,
> +			  u32 flags)
>  {
> -	const struct net_device_ops *ops = dev->netdev_ops;
> -	enum bpf_xdp_mode mode = dev_xdp_mode(flags);
> -	bool offload = mode == XDP_MODE_HW;
> -	u32 prog_id, expected_id = 0;
> -	struct bpf_prog *prog;
> +	struct bpf_prog *cur_prog;
> +	enum bpf_xdp_mode mode;
>  	bpf_op_t bpf_op;
>  	int err;
>  
>  	ASSERT_RTNL();

couldn't we rely on caller's rtnl assertion? dev_change_xdp_fd() already
has one.

>  
> -	bpf_op = dev_xdp_bpf_op(dev, mode);
> -	if (!bpf_op) {
> -		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
> -		return -EOPNOTSUPP;
> +	/* just one XDP mode bit should be set, zero defaults to SKB mode */
> +	if (hweight32(flags & XDP_FLAGS_MODES) > 1) {
> +		NL_SET_ERR_MSG(extack, "Only one XDP mode flag can be set");
> +		return -EINVAL;
> +	}
> +	/* old_prog != NULL implies XDP_FLAGS_REPLACE is set */
> +	if (old_prog && !(flags & XDP_FLAGS_REPLACE)) {
> +		NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not specified");
> +		return -EINVAL;
>  	}
>  
> -	prog_id = dev_xdp_prog_id(dev, mode);
> -	if (flags & XDP_FLAGS_REPLACE) {
> -		if (expected_fd >= 0) {
> -			prog = bpf_prog_get_type_dev(expected_fd,
> -						     BPF_PROG_TYPE_XDP,
> -						     bpf_op == ops->ndo_bpf);
> -			if (IS_ERR(prog))
> -				return PTR_ERR(prog);
> -			expected_id = prog->aux->id;
> -			bpf_prog_put(prog);
> -		}
> -
> -		if (prog_id != expected_id) {
> -			NL_SET_ERR_MSG(extack, "Active program does not match expected");
> -			return -EEXIST;
> -		}
> +	mode = dev_xdp_mode(flags);
> +	cur_prog = dev_xdp_prog(dev, mode);
> +	if ((flags & XDP_FLAGS_REPLACE) && cur_prog != old_prog) {
> +		NL_SET_ERR_MSG(extack, "Active program does not match expected");
> +		return -EEXIST;
>  	}
> -	if (fd >= 0) {
> +	if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
> +		NL_SET_ERR_MSG(extack, "XDP program already attached");
> +		return -EBUSY;
> +	}
> +
> +	if (new_prog) {
> +		bool offload = mode == XDP_MODE_HW;
>  		enum bpf_xdp_mode other_mode = mode == XDP_MODE_SKB
>  					       ? XDP_MODE_DRV : XDP_MODE_SKB;
>  
> -		if (!offload && dev_xdp_prog_id(dev, other_mode)) {
> +		if (!offload && dev_xdp_prog(dev, other_mode)) {
>  			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
>  			return -EEXIST;
>  		}
> -
> -		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
> -			NL_SET_ERR_MSG(extack, "XDP program already attached");
> -			return -EBUSY;
> -		}
> -
> -		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
> -					     bpf_op == ops->ndo_bpf);
> -		if (IS_ERR(prog))
> -			return PTR_ERR(prog);
> -
> -		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
> +		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
>  			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
> -			bpf_prog_put(prog);
>  			return -EINVAL;
>  		}
> -
> -		if (prog->expected_attach_type == BPF_XDP_DEVMAP) {
> +		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
>  			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
> -			bpf_prog_put(prog);
>  			return -EINVAL;
>  		}
> -
> -		if (prog->expected_attach_type == BPF_XDP_CPUMAP) {
> -			NL_SET_ERR_MSG(extack,
> -				       "BPF_XDP_CPUMAP programs can not be attached to a device");
> -			bpf_prog_put(prog);
> +		if (new_prog->expected_attach_type == BPF_XDP_CPUMAP) {
> +			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");

bpf_prog_put() missing?

>  			return -EINVAL;
>  		}
> +	}
>  
> -		/* prog->aux->id may be 0 for orphaned device-bound progs */
> -		if (prog->aux->id && prog->aux->id == prog_id) {
> -			bpf_prog_put(prog);
> -			return 0;
> +	/* don't call drivers if the effective program didn't change */
> +	if (new_prog != cur_prog) {
> +		bpf_op = dev_xdp_bpf_op(dev, mode);
> +		if (!bpf_op) {
> +			NL_SET_ERR_MSG(extack, "Underlying driver does not support XDP in native mode");
> +			return -EOPNOTSUPP;
>  		}
> -	} else {
> -		if (!prog_id)
> -			return 0;
> -		prog = NULL;
> -	}
>  
> -	err = dev_xdp_install(dev, mode, bpf_op, extack, flags, prog);
> -	if (err < 0 && prog) {
> -		bpf_prog_put(prog);
> -		return err;
> +		err = dev_xdp_install(dev, mode, bpf_op, extack, flags, new_prog);
> +		if (err)
> +			return err;
>  	}
> -	dev_xdp_set_prog(dev, mode, prog);
> +
> +	dev_xdp_set_prog(dev, mode, new_prog);
> +	if (cur_prog)
> +		bpf_prog_put(cur_prog);
>  
>  	return 0;
>  }
>  
> +/**
> + *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
> + *	@dev: device
> + *	@extack: netlink extended ack
> + *	@fd: new program fd or negative value to clear
> + *	@expected_fd: old program fd that userspace expects to replace or clear
> + *	@flags: xdp-related flags
> + *
> + *	Set or clear a bpf program for a device
> + */
> +int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
> +		      int fd, int expected_fd, u32 flags)
> +{
> +	enum bpf_xdp_mode mode = dev_xdp_mode(flags);
> +	struct bpf_prog *new_prog = NULL, *old_prog = NULL;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (fd >= 0) {
> +		new_prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
> +						 mode != XDP_MODE_SKB);
> +		if (IS_ERR(new_prog))
> +			return PTR_ERR(new_prog);
> +	}
> +
> +	if (expected_fd >= 0) {
> +		old_prog = bpf_prog_get_type_dev(expected_fd, BPF_PROG_TYPE_XDP,
> +						 mode != XDP_MODE_SKB);
> +		if (IS_ERR(old_prog)) {
> +			err = PTR_ERR(old_prog);
> +			old_prog = NULL;
> +			goto err_out;
> +		}
> +	}
> +
> +	err = dev_xdp_attach(dev, extack, new_prog, old_prog, flags);
> +
> +err_out:
> +	if (err && new_prog)
> +		bpf_prog_put(new_prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +	return err;
> +}
> +
>  /**
>   *	dev_new_index	-	allocate an ifindex
>   *	@net: the applicable net namespace
> -- 
> 2.24.1
> 
