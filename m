Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA433D5F6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404900AbfFKS6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:58:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404245AbfFKS6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:58:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 023901525A431;
        Tue, 11 Jun 2019 11:58:04 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:58:04 -0700 (PDT)
Message-Id: <20190611.115804.258818890043739947.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH net v2] vrf: Increment Icmp6InMsgs on the original
 netdev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610143250.18796-1-ssuryaextr@gmail.com>
References: <20190610143250.18796-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 11:58:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Mon, 10 Jun 2019 10:32:50 -0400

> Get the ingress interface and increment ICMP counters based on that
> instead of skb->dev when the the dev is a VRF device.
> 
> This is a follow up on the following message:
> https://www.spinics.net/lists/netdev/msg560268.html
> 
> v2: Avoid changing skb->dev since it has unintended effect for local
>     delivery (David Ahern).
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

David, please review.

Thanks.

> ---
>  include/net/addrconf.h | 16 ++++++++++++++++
>  net/ipv6/icmp.c        | 17 +++++++++++------
>  net/ipv6/reassembly.c  |  4 ++--
>  3 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index 269ec27385e9..2e36e29f9f54 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -356,6 +356,22 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
>  	return rcu_dereference_rtnl(dev->ip6_ptr);
>  }
>  
> +/**
> + * __in6_dev_stats_get - get inet6_dev pointer for stats
> + * @dev: network device
> + * @skb: skb for original incoming interface if neeeded
> + *
> + * Caller must hold rcu_read_lock or RTNL, because this function
> + * does not take a reference on the inet6_dev.
> + */
> +static inline struct inet6_dev *__in6_dev_stats_get(const struct net_device *dev,
> +						    const struct sk_buff *skb)
> +{
> +	if (netif_is_l3_master(dev))
> +		dev = dev_get_by_index_rcu(dev_net(dev), inet6_iif(skb));
> +	return __in6_dev_get(dev);
> +}
> +
>  /**
>   * __in6_dev_get_safely - get inet6_dev pointer from netdevice
>   * @dev: network device
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index 802faa2fcc0e..f54191cd1d7b 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -398,23 +398,28 @@ static struct dst_entry *icmpv6_route_lookup(struct net *net,
>  	return ERR_PTR(err);
>  }
>  
> -static int icmp6_iif(const struct sk_buff *skb)
> +static struct net_device *icmp6_dev(const struct sk_buff *skb)
>  {
> -	int iif = skb->dev->ifindex;
> +	struct net_device *dev = skb->dev;
>  
>  	/* for local traffic to local address, skb dev is the loopback
>  	 * device. Check if there is a dst attached to the skb and if so
>  	 * get the real device index. Same is needed for replies to a link
>  	 * local address on a device enslaved to an L3 master device
>  	 */
> -	if (unlikely(iif == LOOPBACK_IFINDEX || netif_is_l3_master(skb->dev))) {
> +	if (unlikely(dev->ifindex == LOOPBACK_IFINDEX || netif_is_l3_master(skb->dev))) {
>  		const struct rt6_info *rt6 = skb_rt6_info(skb);
>  
>  		if (rt6)
> -			iif = rt6->rt6i_idev->dev->ifindex;
> +			dev = rt6->rt6i_idev->dev;
>  	}
>  
> -	return iif;
> +	return dev;
> +}
> +
> +static int icmp6_iif(const struct sk_buff *skb)
> +{
> +	return icmp6_dev(skb)->ifindex;
>  }
>  
>  /*
> @@ -801,7 +806,7 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
>  static int icmpv6_rcv(struct sk_buff *skb)
>  {
>  	struct net *net = dev_net(skb->dev);
> -	struct net_device *dev = skb->dev;
> +	struct net_device *dev = icmp6_dev(skb);
>  	struct inet6_dev *idev = __in6_dev_get(dev);
>  	const struct in6_addr *saddr, *daddr;
>  	struct icmp6hdr *hdr;
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index 1a832f5e190b..e219e669ac11 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -302,7 +302,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
>  			   skb_network_header_len(skb));
>  
>  	rcu_read_lock();
> -	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMOKS);
> +	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMOKS);
>  	rcu_read_unlock();
>  	fq->q.rb_fragments = RB_ROOT;
>  	fq->q.fragments_tail = NULL;
> @@ -316,7 +316,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
>  	net_dbg_ratelimited("ip6_frag_reasm: no memory for reassembly\n");
>  out_fail:
>  	rcu_read_lock();
> -	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
> +	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMFAILS);
>  	rcu_read_unlock();
>  	inet_frag_kill(&fq->q);
>  	return -1;
> -- 
> 2.17.1
> 
