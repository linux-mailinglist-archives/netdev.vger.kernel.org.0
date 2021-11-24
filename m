Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8AD45B2F2
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbhKXEE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240896AbhKXEE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:04:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC84601FF;
        Wed, 24 Nov 2021 04:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637726478;
        bh=Zk7UyXBkwoX9k+aDIsCocpz7I6ELjG6FyrQ1YtluOp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NZIyoW6RBmxzdxvyPJOI/EQQZxhicCsEZ/vuDWA6WOLlx2yeG+//25tPHqiCGpJuM
         WgHXDk5uyoEkDrg/G+rViArlZ3J85Zycbc05+ukKFU/FjdOielJJFQ87NDN4tmcoZp
         4nu7nmB81y8zi2FyiQ0mE86SZnQI1ncjkR53deAP/CnpSy5VBGBPaid+UNOce2KCHy
         zFe/+x6gW0PtyYE3uO7cCF4O8iyelVecvQ+CElnPZICNqCN6oNipfsB36eFUNG0BLJ
         Ht90UNTbA6rQI7HoDHr8cxx+xxr5b+A/rX9rnb3qwp1PxKEAV+PTJk67Dfb2BzJgp4
         IzPo41YLnuokw==
Date:   Tue, 23 Nov 2021 20:01:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] rtnetlink: Support fine-grained netdevice bulk
 deletion
Message-ID: <20211123200117.1c944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123123900.27425-1-lschlesinger@drivenets.com>
References: <20211123123900.27425-1-lschlesinger@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 14:39:00 +0200 Lahav Schlesinger wrote:
> Currently there are 2 means of deleting a netdevice using Netlink:
> 1. Deleting a single netdevice (either by ifindex using
> ifinfomsg::ifi_index, or by name using IFLA_IFNAME)
> 2. Delete all netdevice that belong to a group (using IFLA_GROUP)
> 
> After all netdevice are handled, netdev_run_todo() is called, which
> calls rcu_barrier() to finish any outstanding RCU callbacks that were
> registered during the deletion of the netdevice, then wait until the
> refcount of all the devices is 0 and perform final cleanups.
> 
> However, calling rcu_barrier() is a very costly operation, which takes
> in the order of ~10ms.
> 
> When deleting a large number of netdevice one-by-one, rcu_barrier()
> will be called for each netdevice being deleted, causing the whole
> operation taking a long time.
> 
> Following results are from benchmarking deleting 10K loopback devices,
> all of which are UP and with only IPv6 LLA being configured:

What's the use case for this?

> 1. Deleting one-by-one using 1 thread : 243 seconds
> 2. Deleting one-by-one using 10 thread: 70 seconds
> 3. Deleting one-by-one using 50 thread: 54 seconds
> 4. Deleting all using "group deletion": 30 seconds
>
> Note that even though the deletion logic takes place under the rtnl
> lock, since the call to rcu_barrier() is outside the lock we gain
> improvements.
> 
> Since "group deletion" calls rcu_barrier() only once, it is indeed the
> fastest.
> However, "group deletion" is too crude as means of deleting large number
> of devices
> 
> This patch adds support for passing an arbitrary list of ifindex of
> netdevices to delete. This gives a more fine-grained control over
> which devices to delete, while still resulting in only one rcu_barrier()
> being called.
> Indeed, the timings of using this new API to delete 10K netdevices is
> the same as using the existing "group" deletion.
> 
> The size constraints on the list means the API can delete at most 16382
> netdevices in a single request.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
>  include/uapi/linux/if_link.h |  1 +
>  net/core/rtnetlink.c         | 46 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
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
> index fd030e02f16d..150587b4b1a4 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
>  	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
>  	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
> +	[IFLA_IFINDEX_LIST] 	= { .type = NLA_BINARY, .len = 65535 },

Can't we leave len unset if we don't have an upper bound?

>  };
>  
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> @@ -3050,6 +3051,49 @@ static int rtnl_group_dellink(const struct net *net, int group)
>  	return 0;
>  }
>  
> +static int rtnl_list_dellink(struct net *net, void *dev_list, int size)
> +{
> +	int i;
> +	struct net_device *dev, *aux;
> +	LIST_HEAD(list_kill);
> +	bool found = false;
> +
> +	if (size < 0 || size % sizeof(int))
> +		return -EINVAL;
> +
> +	for_each_netdev(net, dev) {
> +		for (i = 0; i < size/sizeof(int); ++i) {

__dev_get_by_index() should be much faster than this n^2 loop.

> +			if (dev->ifindex == ((int*)dev_list)[i]) {

please run checkpatch --strict on the submission

> +				const struct rtnl_link_ops *ops;
> +
> +				found = true;
> +				ops = dev->rtnl_link_ops;
> +				if (!ops || !ops->dellink)
> +					return -EOPNOTSUPP;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (!found)
> +		return -ENODEV;

Why is it okay to miss some of the ifindexes?

> +	for_each_netdev_safe(net, dev, aux) {
> +		for (i = 0; i < size/sizeof(int); ++i) {

Can you not save the references while doing the previous loop?

> +			if (dev->ifindex == ((int*)dev_list)[i]) {
> +				const struct rtnl_link_ops *ops;
> +
> +				ops = dev->rtnl_link_ops;
> +				ops->dellink(dev, &list_kill);
> +				break;
> +			}
> +		}
> +	}
> +	unregister_netdevice_many(&list_kill);
> +
> +	return 0;
> +}
> +
>  int rtnl_delete_link(struct net_device *dev)
>  {
>  	const struct rtnl_link_ops *ops;
> @@ -3102,6 +3146,8 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  				   tb[IFLA_ALT_IFNAME], NULL);
>  	else if (tb[IFLA_GROUP])
>  		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
> +	else if (tb[IFLA_IFINDEX_LIST])
> +		err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]), nla_len(tb[IFLA_IFINDEX_LIST]));

Maybe we can allow multiple IFLA_IFINDEX instead?

>  	else
>  		goto out;
>  

