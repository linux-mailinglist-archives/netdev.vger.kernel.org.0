Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488AC460524
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 08:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356819AbhK1HiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 02:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhK1HgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 02:36:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682FAC061756
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 23:33:07 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC6C760F60
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 07:33:05 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E8160273;
        Sun, 28 Nov 2021 07:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638084785;
        bh=VFHDk015X7N3symkTjAiMqR/Gw+8Cscs9M0ebYapJxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KC1WaBaexPQUm4dJE/ywbvQjnQGK3g3bAqO8y5V/OrblY4Gtvjv5yWVbmMQ56Lb7y
         AqYZh9Pn4eM/wRf+5PN2Kf+z/5RCeg/6SrdCoKHXdON1rRzJ8AUsv03TYPHtGZshqi
         ohXSMm0xYmxmDRZSLsjaC1knMuaFg/RPxZjcLdZnDwDLYNKxpUicPzsbSl73L5ymRi
         A6u7co38k05V+NnkB7w7QQn/kqmLJeSOFi0UXSCmE9lwJF6HM0yyK8jm4jSa36NrLw
         aSU3DUM2imQWokIVKTDpTQNuKykSBAusSeY0y+jwhMEHmsw+7lX9kAwG/7j+yYE+ds
         /9J3HeqlQO3Tw==
Date:   Sun, 28 Nov 2021 09:33:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <YaMwrajs8D5OJ3yS@unreal>
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125165146.21298-1-lschlesinger@drivenets.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 06:51:46PM +0200, Lahav Schlesinger wrote:
> Under large scale, some routers are required to support tens of thousands
> of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> vrfs, etc).
> At times such routers are required to delete massive amounts of devices
> at once, such as when a factory reset is performed on the router (causing
> a deletion of all devices), or when a configuration is restored after an
> upgrade, or as a request from an operator.
> 
> Currently there are 2 means of deleting devices using Netlink:
> 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> or by name using IFLA_IFNAME)
> 2. Delete all device that belong to a group (using IFLA_GROUP)
> 
> Deletion of devices one-by-one has poor performance on large scale of
> devices compared to "group deletion":
> After all device are handled, netdev_run_todo() is called which
> calls rcu_barrier() to finish any outstanding RCU callbacks that were
> registered during the deletion of the device, then wait until the
> refcount of all the devices is 0, then perform final cleanups.
> 
> However, calling rcu_barrier() is a very costly operation, each call
> taking in the order of 10s of milliseconds.
> 
> When deleting a large number of device one-by-one, rcu_barrier()
> will be called for each device being deleted.
> As an example, following benchmark deletes 10K loopback devices,
> all of which are UP and with only IPv6 LLA being configured:
> 
> 1. Deleting one-by-one using 1 thread : 243 seconds
> 2. Deleting one-by-one using 10 thread: 70 seconds
> 3. Deleting one-by-one using 50 thread: 54 seconds
> 4. Deleting all using "group deletion": 30 seconds
> 
> Note that even though the deletion logic takes place under the rtnl
> lock, since the call to rcu_barrier() is outside the lock we gain
> some improvements.
> 
> But, while "group deletion" is the fastest, it is not suited for
> deleting large number of arbitrary devices which are unknown a head of
> time. Furthermore, moving large number of devices to a group is also a
> costly operation.
> 
> This patch adds support for passing an arbitrary list of ifindex of
> devices to delete with a new IFLA_IFINDEX_LIST attribute.
> This gives a more fine-grained control over which devices to delete,
> while still resulting in rcu_barrier() being called only once.
> Indeed, the timings of using this new API to delete 10K devices is
> the same as using the existing "group" deletion.
> 
> The size constraints on the attribute means the API can delete at most
> 16382 devices in a single request.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
> v2 -> v3
>  - Rename 'ifindex_list' to 'ifindices', and pass it as int*
>  - Clamp 'ops' variable in second loop.
> 
> v1 -> v2
>  - Unset 'len' of IFLA_IFINDEX_LIST in policy.
>  - Use __dev_get_by_index() instead of n^2 loop.
>  - Return -ENODEV if any ifindex is not present.
>  - Saved devices in an array.
>  - Fix formatting.
> 
>  include/uapi/linux/if_link.h |  1 +
>  net/core/rtnetlink.c         | 50 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index eebd3894fe89..f950bf6ed025 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -348,6 +348,7 @@ enum {
>  	IFLA_PARENT_DEV_NAME,
>  	IFLA_PARENT_DEV_BUS_NAME,
>  
> +	IFLA_IFINDEX_LIST,
>  	__IFLA_MAX
>  };
>  
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index fd030e02f16d..49d1a3954a01 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
>  	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
>  	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
> +	[IFLA_IFINDEX_LIST]	= { .type = NLA_BINARY },
>  };
>  
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> @@ -3050,6 +3051,52 @@ static int rtnl_group_dellink(const struct net *net, int group)
>  	return 0;
>  }
>  
> +static int rtnl_list_dellink(struct net *net, int *ifindices, int size)
> +{
> +	const int num_devices = size / sizeof(int);
> +	struct net_device **dev_list;
> +	LIST_HEAD(list_kill);
> +	int i, ret;
> +
> +	if (size <= 0 || size % sizeof(int))
> +		return -EINVAL;
> +
> +	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> +	if (!dev_list)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < num_devices; i++) {
> +		const struct rtnl_link_ops *ops;
> +		struct net_device *dev;
> +
> +		ret = -ENODEV;
> +		dev = __dev_get_by_index(net, ifindices[i]);
> +		if (!dev)
> +			goto out_free;
> +
> +		ret = -EOPNOTSUPP;
> +		ops = dev->rtnl_link_ops;
> +		if (!ops || !ops->dellink)
> +			goto out_free;

I'm just curious, how does user know that specific device doesn't
have ->delink implementation? It is important to know because you
are failing whole batch deletion. At least for single delink, users
have chance to skip "failed" one and continue.

Thanks

> +
> +		dev_list[i] = dev;
> +	}
> +
> +	for (i = 0; i < num_devices; i++) {
> +		struct net_device *dev = dev_list[i];
> +
> +		dev->rtnl_link_ops->dellink(dev, &list_kill);
> +	}
> +
> +	unregister_netdevice_many(&list_kill);
> +
> +	ret = 0;
> +
> +out_free:
> +	kfree(dev_list);
> +	return ret;
> +}
> +
>  int rtnl_delete_link(struct net_device *dev)
>  {
>  	const struct rtnl_link_ops *ops;
> @@ -3102,6 +3149,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  				   tb[IFLA_ALT_IFNAME], NULL);
>  	else if (tb[IFLA_GROUP])
>  		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
> +	else if (tb[IFLA_IFINDEX_LIST])
> +		err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
> +					nla_len(tb[IFLA_IFINDEX_LIST]));
>  	else
>  		goto out;
>  
> -- 
> 2.25.1
> 
