Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D83F3FBB89
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhH3SPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238150AbhH3SPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 14:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A65F460E98;
        Mon, 30 Aug 2021 18:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630347257;
        bh=2YmyvACxA5CW5EC1ENt7kH+extPZ+HyxavPOt831e6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uqyJ3hUzKKMsdRB7WmL3ChnKjsGUforM3qa3LWcn8AhgFymCfco7BuGqt+La06m08
         fYNsepgSSJjumLUlxUIUouBeQU16p+VBLHRS1wFMkxd/og1T5ssLa8VOMD3HMSlORd
         MCSSxoQ3j3fNQUVkAE1eFw7L81w+xFaIXPjMBZXfXUMHuyoESuwefW2Q3iaU7sDk0Z
         xdmbBSnEiaheVNKAkVlKA97afha1U8wlKHRgCBbCtKIToogpMRSLOgzm2qw90DcvQX
         sYJLF6w5V9xswvnCSPQ9UPXOwmusGfr30z9zqQ8Em6uzKicUPNgNlAPcwiD/BANIke
         C8A4eTf4igbfA==
Date:   Mon, 30 Aug 2021 11:14:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC v3 net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Message-ID: <20210830111416.34a8362d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210829173934.3683561-2-maciej.machnikowski@intel.com>
References: <20210829173934.3683561-1-maciej.machnikowski@intel.com>
        <20210829173934.3683561-2-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Aug 2021 19:39:33 +0200 Maciej Machnikowski wrote:
> This patch series introduces basic interface for reading the Ethernet
> Equipment Clock (EEC) state on a SyncE capable device. This state gives
> information about the source of the syntonization signal and the state
> of EEC. This interface is required to implement Synchronization Status
> Messaging on upper layers.
> 
> Initial implementation returns:
>  - SyncE EEC state
>  - Source of signal driving SyncE EEC (SyncE, GNSS, PTP or External)
>  - Current index of the pin driving the EEC to track multiple recovered
>    clock paths
> 
> SyncE EEC state read needs to be implemented as ndo_get_eec_state
> function.
> 
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6fd3a4d42668..afb4b6d513b2 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1344,6 +1344,8 @@ struct netdev_net_notifier {
>   *	The caller must be under RCU read context.
>   * int (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx, struct net_device_path *path);
>   *     Get the forwarding path to reach the real device from the HW destination address
> + * int (*ndo_get_synce_state)(struct net_device *dev, struct if_eec_state_msg *state)
> + *	Get state of physical layer frequency syntonization (SyncE)
>   */
>  struct net_device_ops {
>  	int			(*ndo_init)(struct net_device *dev);
> @@ -1563,6 +1565,10 @@ struct net_device_ops {
>  	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
>  	int                     (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx,
>                                                           struct net_device_path *path);
> +	int			(*ndo_get_eec_state)(struct net_device *dev,
> +						     enum if_eec_state *state,
> +						     enum if_eec_src *src,
> +						     u8 *pin_idx);

Why not pass all the args as a struct? That way we won't have to modify
all drivers when new argument is needed.

Please also pass the extack pointer to the drivers.

>  /**
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index eebd3894fe89..4622bf3f937b 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -1273,4 +1273,47 @@ enum {
>  
>  #define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
>  
> +/* SyncE section */
> +
> +enum if_eec_state {
> +	IF_EEC_STATE_INVALID = 0,
> +	IF_EEC_STATE_FREERUN,
> +	IF_EEC_STATE_LOCKACQ,
> +	IF_EEC_STATE_LOCKREC,
> +	IF_EEC_STATE_LOCKED,
> +	IF_EEC_STATE_HOLDOVER,
> +	IF_EEC_STATE_OPEN_LOOP,
> +	__IF_EEC_STATE_MAX,
> +};
> +
> +#define IF_EEC_STATE_MAX (__IF_EEC_STATE_MAX - 1)
> +
> +enum if_eec_src {
> +	IF_EEC_SRC_INVALID = 0,
> +	IF_EEC_SRC_UNKNOWN,
> +	IF_EEC_SRC_SYNCE,
> +	IF_EEC_SRC_GNSS,
> +	IF_EEC_SRC_PTP,
> +	IF_EEC_SRC_EXT,
> +	__IF_EEC_SRC_MAX,
> +};
> +
> +#define IF_EEC_PIN_UNKNOWN	0xFF
> +
> +struct if_eec_state_msg {
> +	__u32 ifindex;
> +	__u8 state;
> +	__u8 src;
> +	__u8 pin;
> +	__u8 pad;
> +};

Please break this structure up into individual attributes.

This way you won't have to expose the special PIN_UNKNOWN value to user
space (skip the invalid attrs instead).

> +enum {
> +	IFLA_EEC_UNSPEC,
> +	IFLA_EEC_STATE,
> +	__IFLA_EEC_MAX,
> +};
> +
> +#define IFLA_EEC_MAX (__IFLA_EEC_MAX - 1)
> +
>  #endif /* _UAPI_LINUX_IF_LINK_H */

> +static int rtnl_fill_eec_state(struct sk_buff *msg, struct net_device *dev,
> +			       u32 portid, u32 seq, struct netlink_callback *cb,
> +			       int flags)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct if_eec_state_msg *state;
> +	struct nlmsghdr *nlh;
> +
> +	ASSERT_RTNL();
> +
> +	nlh = nlmsg_put(msg, portid, seq, RTM_GETEECSTATE,
> +			sizeof(*state), flags);
> +	if (!nlh)
> +		return -EMSGSIZE;
> +
> +	state = nlmsg_data(nlh);
> +
> +	if (ops->ndo_get_eec_state) {

Check this early and return, primary code path of the function should
not be indented.

> +		enum if_eec_state sync_state;
> +		enum if_eec_src src;
> +		int err;
> +		u8 pin;
> +
> +		err = ops->ndo_get_eec_state(dev, &sync_state, &src, &pin);
> +		if (err)
> +			return err;
> +
> +		memset(state, 0, sizeof(*state));
> +
> +		state->ifindex = dev->ifindex;
> +		state->state = (u8)sync_state;
> +		state->pin = pin;
> +		state->src = (u8)src;
> +
> +		return 0;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int rtnl_eec_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct if_eec_state_msg *state;
> +	struct net_device *dev = NULL;

No need to init dev.

> +	struct sk_buff *nskb;
> +	int err;
> +
> +	state = nlmsg_data(nlh);
> +	if (state->ifindex > 0)
> +		dev = __dev_get_by_index(net, state->ifindex);
> +	else
> +		return -EINVAL;
> +
> +	nskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!nskb)
> +		return -ENOBUFS;
> +
> +	if (!dev)
> +		return -ENODEV;

Why is this _after_ the nskb allocation? Looks like a leak.

> +	err = rtnl_fill_eec_state(nskb, dev, NETLINK_CB(skb).portid,
> +				  nlh->nlmsg_seq, NULL, nlh->nlmsg_flags);
> +	if (err < 0)
> +		kfree_skb(nskb);
> +	else
> +		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
> +
> +	return err;
> +}

