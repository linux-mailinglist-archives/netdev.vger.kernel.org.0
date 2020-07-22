Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B427D229B66
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbgGVPcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:32:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:20478 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbgGVPcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 11:32:06 -0400
IronPort-SDR: lrPJHnHgX3wBEJFb1qnJvzd7taIUYGd6eNFGZcWmZW8dk7Ng0bwhj+uQWPS1yNNpxYKGQvP340
 vgUgfacnaHGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="148289015"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="148289015"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 08:31:03 -0700
IronPort-SDR: oXsRbOc/W0WM3chKQ/W2dXxHsiViERRhZdRl2mtIDWBbteQwNUaFIqYQb1STaDghyYkB9FqaOM
 A5VzSSLYCJfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="270777877"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jul 2020 08:31:00 -0700
Date:   Wed, 22 Jul 2020 17:26:04 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, dsahern@gmail.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 2/9] bpf, xdp: maintain info on attached XDP
 BPF programs in net_device
Message-ID: <20200722152604.GA8874@ranger.igk.intel.com>
References: <20200722064603.3350758-1-andriin@fb.com>
 <20200722064603.3350758-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722064603.3350758-3-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 11:45:55PM -0700, Andrii Nakryiko wrote:
> Instead of delegating to drivers, maintain information about which BPF
> programs are attached in which XDP modes (generic/skb, driver, or hardware)
> locally in net_device. This effectively obsoletes XDP_QUERY_PROG command.
> 
> Such re-organization simplifies existing code already. But it also allows to
> further add bpf_link-based XDP attachments without drivers having to know
> about any of this at all, which seems like a good setup.
> XDP_SETUP_PROG/XDP_SETUP_PROG_HW are just low-level commands to driver to
> install/uninstall active BPF program. All the higher-level concerns about
> prog/link interaction will be contained within generic driver-agnostic logic.
> 
> All the XDP_QUERY_PROG calls to driver in dev_xdp_uninstall() were removed.
> It's not clear for me why dev_xdp_uninstall() were passing previous prog_flags
> when resetting installed programs. That seems unnecessary, plus most drivers
> don't populate prog_flags anyways. Having XDP_SETUP_PROG vs XDP_SETUP_PROG_HW
> should be enough of an indicator of what is required of driver to correctly
> reset active BPF program. dev_xdp_uninstall() is also generalized as an
> iteration over all three supported mode.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/netdevice.h |  17 +++-
>  net/core/dev.c            | 158 +++++++++++++++++++++-----------------
>  net/core/rtnetlink.c      |   5 +-
>  3 files changed, 105 insertions(+), 75 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ac2cd3f49aba..cad44b40c776 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -889,6 +889,17 @@ struct netlink_ext_ack;
>  struct xdp_umem;
>  struct xdp_dev_bulk_queue;
>  
> +enum bpf_xdp_mode {
> +	XDP_MODE_SKB = 0,
> +	XDP_MODE_DRV = 1,
> +	XDP_MODE_HW = 2,
> +	__MAX_XDP_MODE
> +};
> +
> +struct bpf_xdp_entity {
> +	struct bpf_prog *prog;
> +};
> +
>  struct netdev_bpf {
>  	enum bpf_netdev_command command;
>  	union {
> @@ -2142,6 +2153,9 @@ struct net_device {
>  #endif
>  	const struct udp_tunnel_nic_info	*udp_tunnel_nic_info;
>  	struct udp_tunnel_nic	*udp_tunnel_nic;
> +
> +	/* protected by rtnl_lock */
> +	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
>  
> @@ -3817,8 +3831,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
>  typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
>  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  		      int fd, int expected_fd, u32 flags);
> -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
> -		    enum bpf_netdev_command cmd);
> +u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
>  int xdp_umem_query(struct net_device *dev, u16 queue_id);
>  
>  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b820527f0a8d..7e753e248cef 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8716,84 +8716,103 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
>  }
>  EXPORT_SYMBOL(dev_change_proto_down_generic);
>  
> -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
> -		    enum bpf_netdev_command cmd)
> +static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
>  {
> -	struct netdev_bpf xdp;
> +	if (flags & XDP_FLAGS_HW_MODE)
> +		return XDP_MODE_HW;
> +	if (flags & XDP_FLAGS_DRV_MODE)
> +		return XDP_MODE_DRV;
> +	return XDP_MODE_SKB;
> +}
>  
> -	if (!bpf_op)
> -		return 0;
> +static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
> +{
> +	switch (mode) {
> +	case XDP_MODE_SKB:
> +		return generic_xdp_install;
> +	case XDP_MODE_DRV:
> +	case XDP_MODE_HW:
> +		return dev->netdev_ops->ndo_bpf;
> +	default:
> +		return NULL;
> +	};
> +}
>  
> -	memset(&xdp, 0, sizeof(xdp));
> -	xdp.command = cmd;
> +static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
> +				     enum bpf_xdp_mode mode)
> +{
> +	return dev->xdp_state[mode].prog;
> +}
> +
> +u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
> +{
> +	struct bpf_prog *prog = dev_xdp_prog(dev, mode);
>  
> -	/* Query must always succeed. */
> -	WARN_ON(bpf_op(dev, &xdp) < 0 && cmd == XDP_QUERY_PROG);
> +	return prog ? prog->aux->id : 0;
> +}
>  
> -	return xdp.prog_id;
> +static void dev_xdp_set_prog(struct net_device *dev, enum bpf_xdp_mode mode,
> +			     struct bpf_prog *prog)
> +{
> +	dev->xdp_state[mode].prog = prog;
>  }
>  
> -static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
> -			   struct netlink_ext_ack *extack, u32 flags,
> -			   struct bpf_prog *prog)
> +static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
> +			   bpf_op_t bpf_op, struct netlink_ext_ack *extack,
> +			   u32 flags, struct bpf_prog *prog)
>  {
> -	bool non_hw = !(flags & XDP_FLAGS_HW_MODE);
> -	struct bpf_prog *prev_prog = NULL;
>  	struct netdev_bpf xdp;
>  	int err;
>  
> -	if (non_hw) {
> -		prev_prog = bpf_prog_by_id(__dev_xdp_query(dev, bpf_op,
> -							   XDP_QUERY_PROG));
> -		if (IS_ERR(prev_prog))
> -			prev_prog = NULL;
> -	}
> -
>  	memset(&xdp, 0, sizeof(xdp));
> -	if (flags & XDP_FLAGS_HW_MODE)
> -		xdp.command = XDP_SETUP_PROG_HW;
> -	else
> -		xdp.command = XDP_SETUP_PROG;
> +	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
>  	xdp.extack = extack;
>  	xdp.flags = flags;
>  	xdp.prog = prog;
>  
> +	/* Drivers assume refcnt is already incremented (i.e, prog pointer is
> +	 * "moved" into driver), so they don't increment it on their own, but
> +	 * they do decrement refcnt when program is detached or replaced.
> +	 * Given net_device also owns link/prog, we need to bump refcnt here
> +	 * to prevent drivers from underflowing it.
> +	 */
> +	if (prog)
> +		bpf_prog_inc(prog);
>  	err = bpf_op(dev, &xdp);
> -	if (!err && non_hw)
> -		bpf_prog_change_xdp(prev_prog, prog);
> +	if (err) {
> +		if (prog)
> +			bpf_prog_put(prog);
> +		return err;
> +	}
>  
> -	if (prev_prog)
> -		bpf_prog_put(prev_prog);
> +	if (mode != XDP_MODE_HW)
> +		bpf_prog_change_xdp(dev_xdp_prog(dev, mode), prog);
>  
> -	return err;
> +	return 0;
>  }
>  
>  static void dev_xdp_uninstall(struct net_device *dev)
>  {
> -	struct netdev_bpf xdp;
> -	bpf_op_t ndo_bpf;
> +	struct bpf_prog *prog;
> +	enum bpf_xdp_mode mode;
> +	bpf_op_t bpf_op;
>  
> -	/* Remove generic XDP */
> -	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
> +	ASSERT_RTNL();
>  
> -	/* Remove from the driver */
> -	ndo_bpf = dev->netdev_ops->ndo_bpf;
> -	if (!ndo_bpf)
> -		return;
> +	for (mode = XDP_MODE_SKB; mode < __MAX_XDP_MODE; mode++) {
> +		prog = dev_xdp_prog(dev, mode);
> +		if (!prog)
> +			continue;
>  
> -	memset(&xdp, 0, sizeof(xdp));
> -	xdp.command = XDP_QUERY_PROG;
> -	WARN_ON(ndo_bpf(dev, &xdp));
> -	if (xdp.prog_id)
> -		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
> -					NULL));
> +		bpf_op = dev_xdp_bpf_op(dev, mode);
> +		if (!bpf_op)
> +			continue;

could we assume that we are iterating over the defined XDP modes so bpf_op
will always be a valid function pointer so that we could use directly
dev_xdp_bpf_op() in dev_xdp_install() ?

Just a nit, however current state is probably less error-prone when in
future we might be introducing new XDP mode.

>  
> -	/* Remove HW offload */
> -	memset(&xdp, 0, sizeof(xdp));
> -	xdp.command = XDP_QUERY_PROG_HW;
> -	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
> -		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
> -					NULL));
> +		WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
> +
> +		bpf_prog_put(prog);
> +		dev_xdp_set_prog(dev, mode, NULL);
> +	}
>  }
>  
>  /**
> @@ -8810,29 +8829,22 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  		      int fd, int expected_fd, u32 flags)
>  {
>  	const struct net_device_ops *ops = dev->netdev_ops;
> -	enum bpf_netdev_command query;
> +	enum bpf_xdp_mode mode = dev_xdp_mode(flags);
> +	bool offload = mode == XDP_MODE_HW;
>  	u32 prog_id, expected_id = 0;
> -	bpf_op_t bpf_op, bpf_chk;
>  	struct bpf_prog *prog;
> -	bool offload;
> +	bpf_op_t bpf_op;
>  	int err;
>  
>  	ASSERT_RTNL();
>  
> -	offload = flags & XDP_FLAGS_HW_MODE;
> -	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
> -
> -	bpf_op = bpf_chk = ops->ndo_bpf;
> -	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
> +	bpf_op = dev_xdp_bpf_op(dev, mode);
> +	if (!bpf_op) {
>  		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
>  		return -EOPNOTSUPP;
>  	}

Seems that we won't ever hit this case with this patch?
If flags are not drv/hw, then dev_xdp_mode() will always spit out the
XDP_MODE_SKB which then passed to dev_xdp_bpf_op() will in turn give the
generic_xdp_install().

I think this check was against the situation where user wanted to go with
native mode but underlying HW was not supporting it, right?

So right now we will always be silently going with generic XDP?

I haven't followed previous revisions so I might be missing something.

> -	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
> -		bpf_op = generic_xdp_install;
> -	if (bpf_op == bpf_chk)
> -		bpf_chk = generic_xdp_install;
>  
> -	prog_id = __dev_xdp_query(dev, bpf_op, query);
> +	prog_id = dev_xdp_prog_id(dev, mode);
>  	if (flags & XDP_FLAGS_REPLACE) {
>  		if (expected_fd >= 0) {
>  			prog = bpf_prog_get_type_dev(expected_fd,
> @@ -8850,8 +8862,11 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  		}
>  	}
>  	if (fd >= 0) {
> -		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
> -			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
> +		enum bpf_xdp_mode other_mode = mode == XDP_MODE_SKB
> +					       ? XDP_MODE_DRV : XDP_MODE_SKB;
> +
> +		if (!offload && dev_xdp_prog_id(dev, other_mode)) {
> +			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
>  			return -EEXIST;
>  		}
>  
> @@ -8866,7 +8881,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  			return PTR_ERR(prog);
>  
>  		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
> -			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
> +			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
>  			bpf_prog_put(prog);
>  			return -EINVAL;
>  		}
> @@ -8895,11 +8910,14 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  		prog = NULL;
>  	}
>  
> -	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
> -	if (err < 0 && prog)
> +	err = dev_xdp_install(dev, mode, bpf_op, extack, flags, prog);
> +	if (err < 0 && prog) {
>  		bpf_prog_put(prog);
> +		return err;
> +	}
> +	dev_xdp_set_prog(dev, mode, prog);
>  
> -	return err;
> +	return 0;
>  }
>  
>  /**
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 9aedc15736ad..754fdfafacb0 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1416,13 +1416,12 @@ static u32 rtnl_xdp_prog_skb(struct net_device *dev)
>  
>  static u32 rtnl_xdp_prog_drv(struct net_device *dev)
>  {
> -	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf, XDP_QUERY_PROG);
> +	return dev_xdp_prog_id(dev, XDP_MODE_DRV);
>  }
>  
>  static u32 rtnl_xdp_prog_hw(struct net_device *dev)
>  {
> -	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
> -			       XDP_QUERY_PROG_HW);
> +	return dev_xdp_prog_id(dev, XDP_MODE_HW);
>  }
>  
>  static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *dev,
> -- 
> 2.24.1
> 
