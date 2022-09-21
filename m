Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672BB5BFE8E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiIUNBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiIUNBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:01:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7928E446
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A973B8240A
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682C9C433D6;
        Wed, 21 Sep 2022 13:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663765284;
        bh=Zb1hnUt2ycJOAYWqZWfh1rL3cth7AQcjku1VRK7HuT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=isAWFVHf8QP14my5wvy2eBmavmPeGOXhL52MuVo6Sz4ZAH5h7pRvKh9NHfjTiZ/gF
         /IDUYqNdDEqdrFd921AoYTpunKMiFu0iuJBq7egx2EB8kJ9zp4PIVQKOmfdX7/jTEN
         NJdzRHEeOi+26AfGy12UTMeNFOHzHb0w5IWQDnkyCdd05kiYNWXEWaCPVW+JZHkunx
         X6QFHrtmPrEiT941lnQsKFTskEi7m7BrMZfKA+LW2Vlpxs/jhM6H0BeMbho78z9lO5
         k7N/SKzbJZgWxtmQ+cSCI9OP5XPxe8PT9iYzO7tF9sxBCEry8a5q6D9FkMqDQdVRC7
         bxGmsdM3INDRg==
Date:   Wed, 21 Sep 2022 06:01:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set}link
Message-ID: <20220921060123.1236276d@kernel.org>
In-Reply-To: <20220921030721.280528-1-liuhangbin@gmail.com>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 11:07:21 +0800 Hangbin Liu wrote:
> Netlink messages are used for communicating between user and kernel space.
> When user space configures the kernel with netlink messages, it can set the
> NLM_F_ECHO flag to request the kernel to send the applied configuration back
> to the caller. This allows user space to retrieve configuration information
> that are filled by the kernel (either because these parameters can only be
> set by the kernel or because user space let the kernel choose a default
> value).
> 
> This patch handles NLM_F_ECHO flag and send link info back after
> rtnl_{new, set}link.
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> 
> In this patch I use rtnl_unicast to send the nlmsg directly. But we can
> also pass "struct nlmsghdr *nlh" to rtnl_newlink_create() and
> do_setlink(), then call rtnl_notify to send the nlmsg. I'm not sure
> which way is better, any comments?
> 
> For iproute2 patch, please see
> https://patchwork.kernel.org/project/netdevbpf/patch/20220916033428.400131-2-liuhangbin@gmail.com/

I feel like the justification for the change is lacking.

I'm biased [and frankly it takes a lot of self-restraint for me not 
to say how I _really_ feel about netlink msg flags ;)] but IMO the
message flags fall squarely into the "this is magic which was never
properly implemented" bucket.

What makes this flag better than just issuing a GET command form user
space?

The flag was never checked on input and is not implemented by 99% of
netlink families and commands.

I'd love to hear what others think. IMO we should declare a moratorium
on any use of netlink flags and fixed fields, push netlink towards
being a simple conduit for TLVs.

> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 74864dc46a7e..b65bd9ed8b0d 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2645,13 +2645,38 @@ static int do_set_proto_down(struct net_device *dev,
>  	return 0;
>  }
>  
> +static int rtnl_echo_link_info(struct net_device *dev, u32 pid, u32 seq,
> +			       u32 ext_filter_mask, int tgt_netnsid)
> +{
> +	struct sk_buff *skb;
> +	int err;
> +
> +	skb = nlmsg_new(if_nlmsg_size(dev, ext_filter_mask), GFP_KERNEL);
> +	if (!skb)
> +		return -ENOBUFS;
> +
> +	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev), RTM_NEWLINK, pid, seq,
> +			       0, 0, ext_filter_mask, 0, NULL, 0,
> +			       tgt_netnsid, GFP_KERNEL);
> +	if (err < 0) {
> +		/* -EMSGSIZE implies BUG in if_nlmsg_size */
> +		WARN_ON(err == -EMSGSIZE);
> +		kfree_skb(skb);
> +	} else {
> +		err = rtnl_unicast(skb, dev_net(dev), pid);
> +	}
> +
> +	return err;
> +}
> +
>  #define DO_SETLINK_MODIFIED	0x01
>  /* notify flag means notify + modified. */
>  #define DO_SETLINK_NOTIFY	0x03
>  static int do_setlink(const struct sk_buff *skb,
>  		      struct net_device *dev, struct ifinfomsg *ifm,
>  		      struct netlink_ext_ack *extack,
> -		      struct nlattr **tb, int status)
> +		      struct nlattr **tb, int status,
> +		      u16 nlmsg_flags, u32 nlmsg_seq)
>  {
>  	const struct net_device_ops *ops = dev->netdev_ops;
>  	char ifname[IFNAMSIZ];
> @@ -3009,6 +3034,21 @@ static int do_setlink(const struct sk_buff *skb,
>  		}
>  	}
>  
> +	if (nlmsg_flags & NLM_F_ECHO) {
> +		u32 ext_filter_mask = 0;
> +		int tgt_netnsid = -1;
> +
> +		if (tb[IFLA_TARGET_NETNSID])
> +			tgt_netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
> +
> +		if (tb[IFLA_EXT_MASK])
> +			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
> +
> +		rtnl_echo_link_info(dev, NETLINK_CB(skb).portid,
> +				    nlmsg_seq, ext_filter_mask,
> +				    tgt_netnsid);
> +	}
> +
>  errout:
>  	if (status & DO_SETLINK_MODIFIED) {
>  		if ((status & DO_SETLINK_NOTIFY) == DO_SETLINK_NOTIFY)
> @@ -3069,7 +3109,9 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		goto errout;
>  	}
>  
> -	err = do_setlink(skb, dev, ifm, extack, tb, 0);
> +	err = do_setlink(skb, dev, ifm, extack, tb, 0,
> +			 nlh->nlmsg_flags, nlh->nlmsg_seq);
> +
>  errout:
>  	return err;
>  }
> @@ -3293,14 +3335,15 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
>  		struct net *net, int group,
>  		struct ifinfomsg *ifm,
>  		struct netlink_ext_ack *extack,
> -		struct nlattr **tb)
> +		struct nlattr **tb, u16 nlmsg_flags, u32 nlmsg_seq)
>  {
>  	struct net_device *dev, *aux;
>  	int err;
>  
>  	for_each_netdev_safe(net, dev, aux) {
>  		if (dev->group == group) {
> -			err = do_setlink(skb, dev, ifm, extack, tb, 0);
> +			err = do_setlink(skb, dev, ifm, extack, tb, 0,
> +					 nlmsg_flags, nlmsg_seq);
>  			if (err < 0)
>  				return err;
>  		}
> @@ -3312,13 +3355,15 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
>  static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
>  			       const struct rtnl_link_ops *ops,
>  			       struct nlattr **tb, struct nlattr **data,
> -			       struct netlink_ext_ack *extack)
> +			       struct netlink_ext_ack *extack,
> +			       u16 nlmsg_flags, u32 nlmsg_seq)
>  {
>  	unsigned char name_assign_type = NET_NAME_USER;
>  	struct net *net = sock_net(skb->sk);
>  	struct net *dest_net, *link_net;
>  	struct net_device *dev;
>  	char ifname[IFNAMSIZ];
> +	int netnsid = -1;
>  	int err;
>  
>  	if (!ops->alloc && !ops->setup)
> @@ -3336,9 +3381,9 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
>  		return PTR_ERR(dest_net);
>  
>  	if (tb[IFLA_LINK_NETNSID]) {
> -		int id = nla_get_s32(tb[IFLA_LINK_NETNSID]);
> +		netnsid = nla_get_s32(tb[IFLA_LINK_NETNSID]);
>  
> -		link_net = get_net_ns_by_id(dest_net, id);
> +		link_net = get_net_ns_by_id(dest_net, netnsid);
>  		if (!link_net) {
>  			NL_SET_ERR_MSG(extack, "Unknown network namespace id");
>  			err =  -EINVAL;
> @@ -3382,6 +3427,17 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
>  		if (err)
>  			goto out_unregister;
>  	}
> +
> +	if (nlmsg_flags & NLM_F_ECHO) {
> +		u32 ext_filter_mask = 0;
> +
> +		if (tb[IFLA_EXT_MASK])
> +			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
> +
> +		rtnl_echo_link_info(dev, NETLINK_CB(skb).portid, nlmsg_seq,
> +				    ext_filter_mask, netnsid);
> +	}
> +
>  out:
>  	if (link_net)
>  		put_net(link_net);
> @@ -3544,7 +3600,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			status |= DO_SETLINK_NOTIFY;
>  		}
>  
> -		return do_setlink(skb, dev, ifm, extack, tb, status);
> +		return do_setlink(skb, dev, ifm, extack, tb, status,
> +				  nlh->nlmsg_flags, nlh->nlmsg_seq);
>  	}
>  
>  	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
> @@ -3556,7 +3613,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		if (tb[IFLA_GROUP])
>  			return rtnl_group_changelink(skb, net,
>  						nla_get_u32(tb[IFLA_GROUP]),
> -						ifm, extack, tb);
> +						ifm, extack, tb,
> +						nlh->nlmsg_flags, nlh->nlmsg_seq);
>  		return -ENODEV;
>  	}
>  
> @@ -3578,7 +3636,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		return -EOPNOTSUPP;
>  	}
>  
> -	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
> +	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack,
> +				   nlh->nlmsg_flags, nlh->nlmsg_seq);
>  }
>  
>  static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,

