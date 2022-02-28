Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49134C73C7
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbiB1Rhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiB1RhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283578AE55
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B54FF6135F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CDC340F1;
        Mon, 28 Feb 2022 17:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646069520;
        bh=nscIhoMCIrWSEjCMbVYZPkMlqtq/hOxarJoH9RtfQvM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VgYoSCJL+tbdiGcgmGe/aEKpueqg55gBuren28PENnlC0sz4zYB7HqSH41q5EXrPD
         /6v/TR72fV3J4U80gtUuznq15bsNMMH/j319AizNK48krRbmcV8dO2r+aQe+MBTO57
         J77YBS6nj+d8idQgs+/tLl5nFXPQDlsZ1yEK+6+4qgFNIAMdbETKvGBBo8ugsehTpi
         bOHCcOMlZ41W9QX2XQwRJomYX9z6Qk9tydzefuloWfVHptJGI9fSLJCs3ds3mk/ngS
         lJjEltoT8pOdDIOsHL0lcUuY5FJMkJwmFpGznglFa+3QFkq0wlhgRQwXYT3pDWFJ8T
         1mq8UNzkBHfZg==
Message-ID: <922b4932-fcd5-d362-4679-6689046560c7@kernel.org>
Date:   Mon, 28 Feb 2022 10:31:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net] ipv4: fix route lookups when handling ICMP redirects
 and PMTU updates
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/22 10:16 AM, Guillaume Nault wrote:
> Fixes: d3a25c980fc2 ("ipv4: Fix nexthop exception hash computation.")

That does not seem related to tos in the flow struct at all.


> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index f33ad1f383b6..d5d058de3664 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -499,6 +499,15 @@ void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
>  }
>  EXPORT_SYMBOL(__ip_select_ident);
>  
> +static void ip_rt_fix_tos(struct flowi4 *fl4)

make this a static inline in include/net/flow.h and update
flowi4_init_output and flowi4_update_output to use it. That should cover
a few of the cases below leaving just  ...

> +{
> +	__u8 tos = RT_FL_TOS(fl4);
> +
> +	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
> +	fl4->flowi4_scope = tos & RTO_ONLINK ?
> +			    RT_SCOPE_LINK : RT_SCOPE_UNIVERSE;
> +}
> +
>  static void __build_flow_key(const struct net *net, struct flowi4 *fl4,
>  			     const struct sock *sk,
>  			     const struct iphdr *iph,
> @@ -824,6 +833,7 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
>  	rt = (struct rtable *) dst;
>  
>  	__build_flow_key(net, &fl4, sk, iph, oif, tos, prot, mark, 0);
> +	ip_rt_fix_tos(&fl4);
>  	__ip_do_redirect(rt, skb, &fl4, true);
>  }
>  
> @@ -1048,6 +1058,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
>  	struct flowi4 fl4;
>  
>  	ip_rt_build_flow_key(&fl4, sk, skb);
> +	ip_rt_fix_tos(&fl4);
>  
>  	/* Don't make lookup fail for bridged encapsulations */
>  	if (skb && netif_is_any_bridge_port(skb->dev))
> @@ -1122,6 +1133,8 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
>  			goto out;
>  
>  		new = true;
> +	} else {
> +		ip_rt_fix_tos(&fl4);
>  	}
>  
>  	__ip_rt_update_pmtu((struct rtable *)xfrm_dst_path(&rt->dst), &fl4, mtu);
> @@ -2603,7 +2616,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
>  struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
>  					const struct sk_buff *skb)
>  {
> -	__u8 tos = RT_FL_TOS(fl4);
>  	struct fib_result res = {
>  		.type		= RTN_UNSPEC,
>  		.fi		= NULL,
> @@ -2613,9 +2625,7 @@ struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
>  	struct rtable *rth;
>  
>  	fl4->flowi4_iif = LOOPBACK_IFINDEX;
> -	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
> -	fl4->flowi4_scope = ((tos & RTO_ONLINK) ?
> -			 RT_SCOPE_LINK : RT_SCOPE_UNIVERSE);
> +	ip_rt_fix_tos(fl4);

... this one to call the new helper.

>  
>  	rcu_read_lock();
>  	rth = ip_route_output_key_hash_rcu(net, fl4, &res, skb);

