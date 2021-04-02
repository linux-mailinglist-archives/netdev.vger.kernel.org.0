Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD92335275B
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 10:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhDBIUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 04:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234133AbhDBIUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 04:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A3F61105;
        Fri,  2 Apr 2021 08:20:17 +0000 (UTC)
Date:   Fri, 2 Apr 2021 10:20:14 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: Re: [PATCH net-next] net: Allow to specify ifindex when device is
 moved to another namespace
Message-ID: <20210402082014.y6efckcpx3y7heo6@wittgenstein>
References: <20210402073622.1260310-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210402073622.1260310-1-avagin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 12:36:22AM -0700, Andrei Vagin wrote:
> Currently, we can specify ifindex on link creation. This change allows
> to specify ifindex when a device is moved to another network namespace.
> 
> CRIU users want to restore containers with pre-created network devices.
> A user will provide network devices and instructions where they have to
> be restored, then CRIU will restore network namespaces and move devices
> into them. The problem is that devices have to be restored with the same
> indexes that they have before C/R.
> 
> Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> ---

Thank you for doing this! This will really help a lot of people with
using CRIU's network dump+restore capabilities.

It might be worth to point out that the ifindex of a netdev can already
change during netns change in case there's already a netdev with the
same infindex in the target netns. So we're not introducing completely
new behavior.
In fact, whether or not ifindex clashes happen can actually be
controlled by the target netns. It could force ifindex changes by
creating and deleting dummy netns devices. That method isn't really
feasible to change to a specific ifindex though. Not just because the
target netns would need to be told to what ifindex to cycle to and if
it's a lot of netdevs with large holes between their ifindeces it
becomes difficult but also because we have a lot of users with
infindeces up in the 1.000s or 10.000s on hosts that start a lot of
containers rapidly. So cycling through infindeces via dummy netns
devices is super costly.

>  drivers/net/hyperv/netvsc_drv.c |  2 +-
>  include/linux/netdevice.h       |  3 ++-
>  net/core/dev.c                  | 24 +++++++++++++++++-------
>  net/core/rtnetlink.c            | 14 ++++++++++----
>  net/ieee802154/core.c           |  4 ++--
>  net/wireless/core.c             |  4 ++--
>  6 files changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 15f262b70489..0f72748217a3 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2368,7 +2368,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
>  	 */
>  	if (!net_eq(dev_net(ndev), dev_net(vf_netdev))) {
>  		ret = dev_change_net_namespace(vf_netdev,
> -					       dev_net(ndev), "eth%d");
> +					       dev_net(ndev), "eth%d", 0);
>  		if (ret)
>  			netdev_err(vf_netdev,
>  				   "could not move to same namespace as %s: %d\n",
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 87a5d186faff..cab59db40a52 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3923,7 +3923,8 @@ void __dev_notify_flags(struct net_device *, unsigned int old_flags,
>  int dev_change_name(struct net_device *, const char *);
>  int dev_set_alias(struct net_device *, const char *, size_t);
>  int dev_get_alias(const struct net_device *, char *, size_t);
> -int dev_change_net_namespace(struct net_device *, struct net *, const char *);
> +int dev_change_net_namespace(struct net_device *dev, struct net *net,
> +			     const char *pat, int new_ifindex);
>  int __dev_set_mtu(struct net_device *, int);
>  int dev_validate_mtu(struct net_device *dev, int mtu,
>  		     struct netlink_ext_ack *extack);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0f72ff5d34ba..c296ee642e39 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -11001,6 +11001,8 @@ EXPORT_SYMBOL(unregister_netdev);
>   *	@net: network namespace
>   *	@pat: If not NULL name pattern to try if the current device name
>   *	      is already taken in the destination network namespace.
> + *	@new_ifindex: If not zero, specifies device index in the target
> + *	              namespace.
>   *
>   *	This function shuts down a device interface and moves it
>   *	to a new network namespace. On success 0 is returned, on
> @@ -11009,10 +11011,11 @@ EXPORT_SYMBOL(unregister_netdev);
>   *	Callers must hold the rtnl semaphore.
>   */
>  
> -int dev_change_net_namespace(struct net_device *dev, struct net *net, const char *pat)
> +int dev_change_net_namespace(struct net_device *dev, struct net *net,
> +			     const char *pat, int new_ifindex)
>  {
>  	struct net *net_old = dev_net(dev);
> -	int err, new_nsid, new_ifindex;
> +	int err, new_nsid;
>  
>  	ASSERT_RTNL();
>  
> @@ -11043,6 +11046,11 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
>  			goto out;
>  	}
>  
> +	/* Check that new_ifindex isn't used yet. */
> +	err = -EBUSY;
> +	if (new_ifindex && __dev_get_by_index(net, new_ifindex))
> +		goto out;

Should this maybe verify that the new_inindex isn't negative and reject
it right away? (Maybe also right where we first retrieve it?) Otherwise
__dev_get_by_index() might pointlessly walk the whole netdev list for
thet network namespace.

> +
>  	/*
>  	 * And now a mini version of register_netdevice unregister_netdevice.
>  	 */
> @@ -11070,10 +11078,12 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
>  
>  	new_nsid = peernet2id_alloc(dev_net(dev), net, GFP_KERNEL);
>  	/* If there is an ifindex conflict assign a new one */
> -	if (__dev_get_by_index(net, dev->ifindex))
> -		new_ifindex = dev_new_index(net);
> -	else
> -		new_ifindex = dev->ifindex;
> +	if (!new_ifindex) {
> +		if (__dev_get_by_index(net, dev->ifindex))
> +			new_ifindex = dev_new_index(net);
> +		else
> +			new_ifindex = dev->ifindex;
> +	}
>  
>  	rtmsg_ifinfo_newnet(RTM_DELLINK, dev, ~0U, GFP_KERNEL, &new_nsid,
>  			    new_ifindex);
> @@ -11382,7 +11392,7 @@ static void __net_exit default_device_exit(struct net *net)
>  		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
>  		if (__dev_get_by_name(&init_net, fb_name))
>  			snprintf(fb_name, IFNAMSIZ, "dev%%d");
> -		err = dev_change_net_namespace(dev, &init_net, fb_name);
> +		err = dev_change_net_namespace(dev, &init_net, fb_name, 0);
>  		if (err) {
>  			pr_emerg("%s: failed to move %s to init_net: %d\n",
>  				 __func__, dev->name, err);
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1bdcb33fb561..9508d3a0a28f 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2603,14 +2603,20 @@ static int do_setlink(const struct sk_buff *skb,
>  		return err;
>  
>  	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
> -		struct net *net = rtnl_link_get_net_capable(skb, dev_net(dev),
> -							    tb, CAP_NET_ADMIN);
> +		int new_ifindex = -1;
> +		struct net *net;
> +
> +		net = rtnl_link_get_net_capable(skb, dev_net(dev),
> +						tb, CAP_NET_ADMIN);
>  		if (IS_ERR(net)) {
>  			err = PTR_ERR(net);
>  			goto errout;
>  		}
>  
> -		err = dev_change_net_namespace(dev, net, ifname);
> +		if (tb[IFLA_NEW_IFINDEX])
> +			new_ifindex = nla_get_s32(tb[IFLA_NEW_IFINDEX]);
> +
> +		err = dev_change_net_namespace(dev, net, ifname, new_ifindex);
>  		put_net(net);
>  		if (err)
>  			goto errout;
> @@ -3452,7 +3458,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	if (err < 0)
>  		goto out_unregister;
>  	if (link_net) {
> -		err = dev_change_net_namespace(dev, dest_net, ifname);
> +		err = dev_change_net_namespace(dev, dest_net, ifname, 0);
>  		if (err < 0)
>  			goto out_unregister;
>  	}
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index de259b5170ab..ec3068937fc3 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -205,7 +205,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>  		if (!wpan_dev->netdev)
>  			continue;
>  		wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
> -		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
> +		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d", 0);
>  		if (err)
>  			break;
>  		wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
> @@ -222,7 +222,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>  				continue;
>  			wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
>  			err = dev_change_net_namespace(wpan_dev->netdev, net,
> -						       "wpan%d");
> +						       "wpan%d", 0);
>  			WARN_ON(err);
>  			wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
>  		}
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index a2785379df6e..fabb677b7d58 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -165,7 +165,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>  		if (!wdev->netdev)
>  			continue;
>  		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
> -		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
> +		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d", 0);
>  		if (err)
>  			break;
>  		wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
> @@ -182,7 +182,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>  				continue;
>  			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
>  			err = dev_change_net_namespace(wdev->netdev, net,
> -							"wlan%d");
> +							"wlan%d", 0);
>  			WARN_ON(err);
>  			wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
>  		}
> -- 
> 2.29.2
> 
