Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E287F22EBB8
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgG0MIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:08:12 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:60696 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgG0MIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595851691; x=1627387691;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=x9Mmx/+WgfUJ4Ik4QvhAdZK1NaIxdI9Z4mqgEiBMN1k=;
  b=GYJUKpGmSMll+EGXTByKQJbJhfPDKNfJCPnXOLmt4wk8cKr66ofX2Z4s
   uvy6BKN5kPWT3uKk1zeye5YCQ+l6IDHdEs871JyH0M0n2LIHOSHfjlC1f
   WdBU2sbwSIn0I2C+mvMePKRWhK4UOjihoEqvT3o7EBJV7Xi1KeY1l7ihY
   U=;
IronPort-SDR: DwpNeIOJDHJbSo8lBOSYLKNR9r27TBuSYWigIv6hGnwluR1cp4SUCwwrREiDT8AvObK3BUxI7O
 dTbvXD6dB0tw==
X-IronPort-AV: E=Sophos;i="5.75,402,1589241600"; 
   d="scan'208";a="44256233"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 27 Jul 2020 12:08:09 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id D09EDA17D2;
        Mon, 27 Jul 2020 12:08:07 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:07:49 +0000
Received: from ua97a68a4e7db56.ant.amazon.com.amazon.com (10.43.161.203) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:07:30 +0000
References: <20200722064603.3350758-1-andriin@fb.com> <20200722064603.3350758-4-andriin@fb.com>
User-agent: mu4e 1.4.10; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>,
        <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 3/9] bpf, xdp: extract common XDP program attachment logic
In-Reply-To: <20200722064603.3350758-4-andriin@fb.com>
Date:   Mon, 27 Jul 2020 15:07:25 +0300
Message-ID: <pj41zla6zl88le.fsf@ua97a68a4e7db56.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D08UWC003.ant.amazon.com (10.43.162.21) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrii Nakryiko <andriin@fb.com> writes:

> Further refactor XDP attachment code. dev_change_xdp_fd() is 
> split into two
> parts: getting bpf_progs from FDs and attachment logic, working 
> with
> bpf_progs. This makes attachment  logic a bit more 
> straightforward and
> prepares code for bpf_xdp_link inclusion, which will share the 
> common logic.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  net/core/dev.c | 165 
>  +++++++++++++++++++++++++++----------------------
>  1 file changed, 91 insertions(+), 74 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7e753e248cef..abf573b2dcf4 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8815,111 +8815,128 @@ static void dev_xdp_uninstall(struct 
> net_device *dev)
>  	}
>  }
>  
> -/**
> - *	dev_change_xdp_fd - set or clear a bpf program for a 
> device rx path
> - *	@dev: device
> - *	@extack: netlink extended ack
> - *	@fd: new program fd or negative value to clear
> - *	@expected_fd: old program fd that userspace expects to 
> replace or clear
> - *	@flags: xdp-related flags
> - *
> - *	Set or clear a bpf program for a device
> - */
> -int dev_change_xdp_fd(struct net_device *dev, struct 
> netlink_ext_ack *extack,
> -		      int fd, int expected_fd, u32 flags)
> +static int dev_xdp_attach(struct net_device *dev, struct 
> netlink_ext_ack *extack,
> +			  struct bpf_prog *new_prog, struct 
> bpf_prog *old_prog,
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
>  
> -	bpf_op = dev_xdp_bpf_op(dev, mode);
> -	if (!bpf_op) {
> -		NL_SET_ERR_MSG(extack, "underlying driver does not 
> support XDP in native mode");
> -		return -EOPNOTSUPP;
> +	/* just one XDP mode bit should be set, zero defaults to 
> SKB mode */
> +	if (hweight32(flags & XDP_FLAGS_MODES) > 1) {

Not sure if it's more efficient but running
    if ((flags & XDP) & ((flags & XDP) - 1) != 0)

returns whether a number is a multiple of 2.
Should be equivalent to what you checked with hweight32. It is 
less readable though. Just thought I'd throw that in.
Taken from 
https://graphics.stanford.edu/~seander/bithacks.html#DetermineIfPowerOf2

> +		NL_SET_ERR_MSG(extack, "Only one XDP mode flag can 
> be set");
> +		return -EINVAL;
> +	}
> +	/* old_prog != NULL implies XDP_FLAGS_REPLACE is set */
> +	if (old_prog && !(flags & XDP_FLAGS_REPLACE)) {
> +		NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not 
> specified");
> +		return -EINVAL;
>  	}
>  
> -	prog_id = dev_xdp_prog_id(dev, mode);
> -	if (flags & XDP_FLAGS_REPLACE) {
> -		if (expected_fd >= 0) {
> -			prog = bpf_prog_get_type_dev(expected_fd,
> - 
> BPF_PROG_TYPE_XDP,
> -						     bpf_op == 
> ops->ndo_bpf);
> -			if (IS_ERR(prog))
> -				return PTR_ERR(prog);
> -			expected_id = prog->aux->id;
> -			bpf_prog_put(prog);
> -		}
> -
> -		if (prog_id != expected_id) {
> -			NL_SET_ERR_MSG(extack, "Active program 
> does not match expected");
> -			return -EEXIST;
> -		}
> +	mode = dev_xdp_mode(flags);
> +	cur_prog = dev_xdp_prog(dev, mode);
> +	if ((flags & XDP_FLAGS_REPLACE) && cur_prog != old_prog) {
> +		NL_SET_ERR_MSG(extack, "Active program does not 
> match expected");
> +		return -EEXIST;
>  	}
> -	if (fd >= 0) {
> +	if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
> +		NL_SET_ERR_MSG(extack, "XDP program already 
> attached");
> +		return -EBUSY;
> +	}
> +
> +	if (new_prog) {
> +		bool offload = mode == XDP_MODE_HW;
>  		enum bpf_xdp_mode other_mode = mode == 
>  XDP_MODE_SKB
>  					       ? XDP_MODE_DRV : 
>  XDP_MODE_SKB;
>  
> -		if (!offload && dev_xdp_prog_id(dev, other_mode)) 
> {
> +		if (!offload && dev_xdp_prog(dev, other_mode)) {
>  			NL_SET_ERR_MSG(extack, "Native and generic 
>  XDP can't be active at the same time");
>  			return -EEXIST;
>  		}
> -
> -		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && 
> prog_id) {
> -			NL_SET_ERR_MSG(extack, "XDP program 
> already attached");
> -			return -EBUSY;
> -		}
> -
> -		prog = bpf_prog_get_type_dev(fd, 
> BPF_PROG_TYPE_XDP,
> -					     bpf_op == 
> ops->ndo_bpf);
> -		if (IS_ERR(prog))
> -			return PTR_ERR(prog);
> -
> -		if (!offload && bpf_prog_is_dev_bound(prog->aux)) 
> {
> +		if (!offload && 
> bpf_prog_is_dev_bound(new_prog->aux)) {
>  			NL_SET_ERR_MSG(extack, "Using device-bound 
>  program without HW_MODE flag is not supported");
> -			bpf_prog_put(prog);
>  			return -EINVAL;
>  		}
> -
> -		if (prog->expected_attach_type == BPF_XDP_DEVMAP) 
> {
> +		if (new_prog->expected_attach_type == 
> BPF_XDP_DEVMAP) {
>  			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP 
>  programs can not be attached to a device");
> -			bpf_prog_put(prog);
>  			return -EINVAL;
>  		}
> -
> -		if (prog->expected_attach_type == BPF_XDP_CPUMAP) 
> {
> -			NL_SET_ERR_MSG(extack,
> -				       "BPF_XDP_CPUMAP programs 
> can not be attached to a device");
> -			bpf_prog_put(prog);
> +		if (new_prog->expected_attach_type == 
> BPF_XDP_CPUMAP) {
> +			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP 
> programs can not be attached to a device");
>  			return -EINVAL;
>  		}
> +	}
>  
> -		/* prog->aux->id may be 0 for orphaned 
> device-bound progs */
> -		if (prog->aux->id && prog->aux->id == prog_id) {
> -			bpf_prog_put(prog);
> -			return 0;
> +	/* don't call drivers if the effective program didn't 
> change */
> +	if (new_prog != cur_prog) {
> +		bpf_op = dev_xdp_bpf_op(dev, mode);
> +		if (!bpf_op) {
> +			NL_SET_ERR_MSG(extack, "Underlying driver 
> does not support XDP in native mode");
> +			return -EOPNOTSUPP;
>  		}
> -	} else {
> -		if (!prog_id)
> -			return 0;
> -		prog = NULL;
> -	}
>  
> -	err = dev_xdp_install(dev, mode, bpf_op, extack, flags, 
> prog);
> -	if (err < 0 && prog) {
> -		bpf_prog_put(prog);
> -		return err;
> +		err = dev_xdp_install(dev, mode, bpf_op, extack, 
> flags, new_prog);
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
> + *	dev_change_xdp_fd - set or clear a bpf program for a 
> device rx path
> + *	@dev: device
> + *	@extack: netlink extended ack
> + *	@fd: new program fd or negative value to clear
> + *	@expected_fd: old program fd that userspace expects to 
> replace or clear
> + *	@flags: xdp-related flags
> + *
> + *	Set or clear a bpf program for a device
> + */
> +int dev_change_xdp_fd(struct net_device *dev, struct 
> netlink_ext_ack *extack,
> +		      int fd, int expected_fd, u32 flags)
> +{
> +	enum bpf_xdp_mode mode = dev_xdp_mode(flags);
> +	struct bpf_prog *new_prog = NULL, *old_prog = NULL;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (fd >= 0) {
> +		new_prog = bpf_prog_get_type_dev(fd, 
> BPF_PROG_TYPE_XDP,
> +						 mode != 
> XDP_MODE_SKB);
> +		if (IS_ERR(new_prog))
> +			return PTR_ERR(new_prog);
> +	}
> +
> +	if (expected_fd >= 0) {
> +		old_prog = bpf_prog_get_type_dev(expected_fd, 
> BPF_PROG_TYPE_XDP,
> +						 mode != 
> XDP_MODE_SKB);
> +		if (IS_ERR(old_prog)) {
> +			err = PTR_ERR(old_prog);
> +			old_prog = NULL;
> +			goto err_out;
> +		}
> +	}
> +
> +	err = dev_xdp_attach(dev, extack, new_prog, old_prog, 
> flags);
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

