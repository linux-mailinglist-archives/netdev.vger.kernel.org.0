Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861222059F9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbgFWRvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:51:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732549AbgFWRvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592934678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n9KsB5aXXDm57lub/PiCY+bnNmFIx6U7IgYf+nU+2no=;
        b=fm27fkNbS0ffI3/W2WDr3HzNJNBjyEKeIfN/yJC/jfpwKkE0nsiJ2bidfdxK/o5aai/bne
        eig6LXe1/QfamU5lPtJwae1NfjqfdKpvQAKhqcKi8sOiA7LPU/LjcoufiIOL9B43ZZeg0/
        ZntpQ30RfUAU0NpjS2FaOOVK0ntOp2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-HKK-cXm1OMSVv7OPGMRm4A-1; Tue, 23 Jun 2020 13:51:14 -0400
X-MC-Unique: HKK-cXm1OMSVv7OPGMRm4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 175991B2C99A;
        Tue, 23 Jun 2020 17:51:13 +0000 (UTC)
Received: from ovpn-114-234.ams2.redhat.com (ovpn-114-234.ams2.redhat.com [10.36.114.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4518710013C0;
        Tue, 23 Jun 2020 17:51:11 +0000 (UTC)
Message-ID: <35e27a36d4a57e203420dc742e1d2ac18d0951b7.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 2/2] ipv6: fib6: avoid indirect calls from
 fib6_rule_lookup
From:   Paolo Abeni <pabeni@redhat.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luigi Rizzo <lrizzo@google.com>
Date:   Tue, 23 Jun 2020 19:51:10 +0200
In-Reply-To: <20200623164232.175846-2-brianvv@google.com>
References: <20200623164232.175846-1-brianvv@google.com>
         <20200623164232.175846-2-brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-23 at 09:42 -0700, Brian Vazquez wrote:
> It was reported that a considerable amount of cycles were spent on the
> expensive indirect calls on fib6_rule_lookup. This patch introduces an
> inline helper called pol_route_func that uses the indirect_call_wrappers
> to avoid the indirect calls.
> 
> This patch saves around 50ns per call.
> 
> Performance was measured on the receiver by checking the amount of
> syncookies that server was able to generate under a synflood load.
> 
> Traffic was generated using trafgen[1] which was pushing around 1Mpps on
> a single queue. Receiver was using only one rx queue which help to
> create a bottle neck and make the experiment rx-bounded.
> 
> These are the syncookies generated over 10s from the different runs:
> 
> Whithout the patch:
> TcpExtSyncookiesSent            3553749            0.0
> TcpExtSyncookiesSent            3550895            0.0
> TcpExtSyncookiesSent            3553845            0.0
> TcpExtSyncookiesSent            3541050            0.0
> TcpExtSyncookiesSent            3539921            0.0
> TcpExtSyncookiesSent            3557659            0.0
> TcpExtSyncookiesSent            3526812            0.0
> TcpExtSyncookiesSent            3536121            0.0
> TcpExtSyncookiesSent            3529963            0.0
> TcpExtSyncookiesSent            3536319            0.0
> 
> With the patch:
> TcpExtSyncookiesSent            3611786            0.0
> TcpExtSyncookiesSent            3596682            0.0
> TcpExtSyncookiesSent            3606878            0.0
> TcpExtSyncookiesSent            3599564            0.0
> TcpExtSyncookiesSent            3601304            0.0
> TcpExtSyncookiesSent            3609249            0.0
> TcpExtSyncookiesSent            3617437            0.0
> TcpExtSyncookiesSent            3608765            0.0
> TcpExtSyncookiesSent            3620205            0.0
> TcpExtSyncookiesSent            3601895            0.0
> 
> Without the patch the average is 354263 pkt/s or 2822 ns/pkt and with
> the patch the average is 360738 pkt/s or 2772 ns/pkt which gives an
> estimate of 50 ns per packet.
> 
> [1] http://netsniff-ng.org/
> 
> Changelog since v1:
>  - Change ordering in the ICW (Paolo Abeni)
> 
> Cc: Luigi Rizzo <lrizzo@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  include/net/ip6_fib.h | 36 ++++++++++++++++++++++++++++++++++++
>  net/ipv6/fib6_rules.c |  9 ++++++---
>  net/ipv6/ip6_fib.c    |  3 ++-
>  net/ipv6/route.c      |  8 ++++----
>  4 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> index 3f615a29766e..cc8356fd927f 100644
> --- a/include/net/ip6_fib.h
> +++ b/include/net/ip6_fib.h
> @@ -19,6 +19,7 @@
>  #include <net/netlink.h>
>  #include <net/inetpeer.h>
>  #include <net/fib_notifier.h>
> +#include <linux/indirect_call_wrapper.h>
>  
>  #ifdef CONFIG_IPV6_MULTIPLE_TABLES
>  #define FIB6_TABLE_HASHSZ 256
> @@ -552,6 +553,41 @@ struct bpf_iter__ipv6_route {
>  };
>  #endif
>  
> +INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_output(struct net *net,
> +					     struct fib6_table *table,
> +					     struct flowi6 *fl6,
> +					     const struct sk_buff *skb,
> +					     int flags));
> +INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_input(struct net *net,
> +					     struct fib6_table *table,
> +					     struct flowi6 *fl6,
> +					     const struct sk_buff *skb,
> +					     int flags));
> +INDIRECT_CALLABLE_DECLARE(struct rt6_info *__ip6_route_redirect(struct net *net,
> +					     struct fib6_table *table,
> +					     struct flowi6 *fl6,
> +					     const struct sk_buff *skb,
> +					     int flags));
> +INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_lookup(struct net *net,
> +					     struct fib6_table *table,
> +					     struct flowi6 *fl6,
> +					     const struct sk_buff *skb,
> +					     int flags));
> +static inline struct rt6_info *pol_lookup_func(pol_lookup_t lookup,
> +						struct net *net,
> +						struct fib6_table *table,
> +						struct flowi6 *fl6,
> +						const struct sk_buff *skb,
> +						int flags)
> +{
> +	return INDIRECT_CALL_4(lookup,
> +			       ip6_pol_route_output,
> +			       ip6_pol_route_input,
> +			       ip6_pol_route_lookup,
> +			       __ip6_route_redirect,
> +			       net, table, fl6, skb, flags);
> +}
> +
>  #ifdef CONFIG_IPV6_MULTIPLE_TABLES
>  static inline bool fib6_has_custom_rules(const struct net *net)
>  {
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index fafe556d21e0..6053ef851555 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -111,11 +111,13 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
>  	} else {
>  		struct rt6_info *rt;
>  
> -		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> +		rt = pol_lookup_func(lookup,
> +			     net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
>  		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
>  			return &rt->dst;
>  		ip6_rt_put_flags(rt, flags);
> -		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> +		rt = pol_lookup_func(lookup,
> +			     net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
>  		if (rt->dst.error != -EAGAIN)
>  			return &rt->dst;
>  		ip6_rt_put_flags(rt, flags);
> @@ -226,7 +228,8 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
>  		goto out;
>  	}
>  
> -	rt = lookup(net, table, flp6, arg->lookup_data, flags);
> +	rt = pol_lookup_func(lookup,
> +			     net, table, flp6, arg->lookup_data, flags);
>  	if (rt != net->ipv6.ip6_null_entry) {
>  		err = fib6_rule_saddr(net, rule, flags, flp6,
>  				      ip6_dst_idev(&rt->dst)->dev);
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 49ee89bbcba0..25a90f3f705c 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -314,7 +314,8 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
>  {
>  	struct rt6_info *rt;
>  
> -	rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> +	rt = pol_lookup_func(lookup,
> +			net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
>  	if (rt->dst.error == -EAGAIN) {
>  		ip6_rt_put_flags(rt, flags);
>  		rt = net->ipv6.ip6_null_entry;
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 82cbb46a2a4f..5852039ca9cf 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1207,7 +1207,7 @@ static struct rt6_info *ip6_create_rt_rcu(const struct fib6_result *res)
>  	return nrt;
>  }
>  
> -static struct rt6_info *ip6_pol_route_lookup(struct net *net,
> +INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_lookup(struct net *net,
>  					     struct fib6_table *table,
>  					     struct flowi6 *fl6,
>  					     const struct sk_buff *skb,
> @@ -2274,7 +2274,7 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
>  }
>  EXPORT_SYMBOL_GPL(ip6_pol_route);
>  
> -static struct rt6_info *ip6_pol_route_input(struct net *net,
> +INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_input(struct net *net,
>  					    struct fib6_table *table,
>  					    struct flowi6 *fl6,
>  					    const struct sk_buff *skb,
> @@ -2465,7 +2465,7 @@ void ip6_route_input(struct sk_buff *skb)
>  						      &fl6, skb, flags));
>  }
>  
> -static struct rt6_info *ip6_pol_route_output(struct net *net,
> +INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_output(struct net *net,
>  					     struct fib6_table *table,
>  					     struct flowi6 *fl6,
>  					     const struct sk_buff *skb,
> @@ -2912,7 +2912,7 @@ struct ip6rd_flowi {
>  	struct in6_addr gateway;
>  };
>  
> -static struct rt6_info *__ip6_route_redirect(struct net *net,
> +INDIRECT_CALLABLE_SCOPE struct rt6_info *__ip6_route_redirect(struct net *net,
>  					     struct fib6_table *table,
>  					     struct flowi6 *fl6,
>  					     const struct sk_buff *skb,

Acked-by: Paolo Abeni <pabeni@redhat.com>

