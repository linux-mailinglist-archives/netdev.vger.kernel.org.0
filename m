Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C4D3B4FBA
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFZRVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 13:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhFZRVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 13:21:09 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0ABC061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 10:18:45 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id q10so15503527oij.5
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 10:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=15MBu3z9GHz9QsbjScXnHA1X583+EmE4IK+PpSCo+IA=;
        b=HeLsJT0ALfoUeXUeGbGXwBnGLylhANcbLOdhfU9mWNM1PyDWdrdEq4bDJEvNyLLk3t
         /ErooPZrLfqI4H822K+0v5zb7NbH0GmI30n0HPYmoAj34GQZ0Ju3rdIBf9GNk2ef+s3b
         cSKtaf9qz2t7a1QR89Mg42eijOk0SAmBV8/rNMfkUvKlC9LuJ13Lx9QXeuvYMftlv9fu
         VGc9fhl+c33f16E57sc+YCL3wXoerLLb/mKNr49dTkH72xG7bYPguzEe/Glqu8uajJEr
         ZrLcy2AEGAxj22SCiEtEXoC+K1rIiUVLyOLPmM2nt8v50Gw/1m49Jo4e4Q8kJQuNz+2E
         jbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=15MBu3z9GHz9QsbjScXnHA1X583+EmE4IK+PpSCo+IA=;
        b=lnUDBU2hjc+O1VoD/eRqSh2qq2AXnsGZFQIErpLohvrNi7UAZzBHWuJdiN9X/gJOL8
         cHcyKDTAbxAfXCi3njGQmd9lSHJZWodoPaLV4P2RvxrJFOSVIhRLI9AMzHg6rUpuDJD4
         4SGyDHx71jpcBnWmccF8LwTgIc2g2/gmxQzroCuK9F+vfniYSod+agE/GEWdyhmO+TSF
         TeV2jB4I1qEIy52YYGj47AzXHfS79rDaPJpQzSxb85xGWD5Ib0KA4BLKAF6ZwX9uX3DQ
         saWy0P2TLwaX6CdUdzEsSF1DMfw1KszCO5cukNFM3XOvA/9FDDbngTP6sd/k/ZqunL/E
         vF2A==
X-Gm-Message-State: AOAM533Kdc4AvPylh3ioX4uwfMTs6PQ/tcDweqA0Axjw1NwX3CqYaL+q
        mvlCXUMDD+GuDCJawVgVeBA=
X-Google-Smtp-Source: ABdhPJw0keLDlUipH6ekaV0HBb+25gtv52NYI4RCilKI9OIfmC9r32hnnJcH29fQa3f5spOG5SH2fQ==
X-Received: by 2002:aca:3286:: with SMTP id y128mr56156oiy.115.1624727925081;
        Sat, 26 Jun 2021 10:18:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id f12sm2075548ooh.38.2021.06.26.10.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 10:18:44 -0700 (PDT)
Subject: Re: [PATCH net v2] net: lwtunnel: handle MTU calculation in forwading
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210625162139.9067-1-vfedorenko@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <afc66439-d288-c2ea-f129-c9833d8a4d89@gmail.com>
Date:   Sat, 26 Jun 2021 11:18:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625162139.9067-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ added Roopa's nvidia address ]

On 6/25/21 10:21 AM, Vadim Fedorenko wrote:
> Commit 14972cbd34ff ("net: lwtunnel: Handle fragmentation") moved
> fragmentation logic away from lwtunnel by carry encap headroom and
> use it in output MTU calculation. But the forwarding part was not
> covered and created difference in MTU for output and forwarding and
> further to silent drops on ipv4 forwarding path. Fix it by taking
> into account lwtunnel encap headroom.
> 
> The same commit also introduced difference in how to treat RTAX_MTU
> in IPv4 and IPv6 where latter explicitly removes lwtunnel encap
> headroom from route MTU. Make IPv4 version do the same.
> 
> Fixes: 14972cbd34ff ("net: lwtunnel: Handle fragmentation")
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  include/net/ip.h        | 12 ++++++++----
>  include/net/ip6_route.h | 16 ++++++++++++----
>  net/ipv4/route.c        |  3 ++-
>  3 files changed, 22 insertions(+), 9 deletions(-)
> 


I think this is the right approach - tunnel overhead should always be
considered for the mtu. Did you run the pmtu.sh selftests to make sure
those still work?

Reviewed-by: David Ahern <dsahern@kernel.org>


> diff --git a/include/net/ip.h b/include/net/ip.h
> index e20874059f82..d9683bef8684 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -31,6 +31,7 @@
>  #include <net/flow.h>
>  #include <net/flow_dissector.h>
>  #include <net/netns/hash.h>
> +#include <net/lwtunnel.h>
>  
>  #define IPV4_MAX_PMTU		65535U		/* RFC 2675, Section 5.1 */
>  #define IPV4_MIN_MTU		68			/* RFC 791 */
> @@ -445,22 +446,25 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>  
>  	/* 'forwarding = true' case should always honour route mtu */
>  	mtu = dst_metric_raw(dst, RTAX_MTU);
> -	if (mtu)
> -		return mtu;
> +	if (!mtu)
> +		mtu = min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
>  
> -	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
> +	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
>  }
>  
>  static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
>  					  const struct sk_buff *skb)
>  {
> +	unsigned int mtu;
> +
>  	if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
>  		bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
>  
>  		return ip_dst_mtu_maybe_forward(skb_dst(skb), forwarding);
>  	}
>  
> -	return min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
> +	mtu = min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
> +	return mtu - lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
>  }
>  
>  struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index f51a118bfce8..f14149df5a65 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -265,11 +265,18 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
>  
>  static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
>  {
> +	int mtu;
> +
>  	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
>  				inet6_sk(skb->sk) : NULL;
>  
> -	return (np && np->pmtudisc >= IPV6_PMTUDISC_PROBE) ?
> -	       skb_dst(skb)->dev->mtu : dst_mtu(skb_dst(skb));
> +	if (np && np->pmtudisc >= IPV6_PMTUDISC_PROBE) {
> +		mtu = READ_ONCE(skb_dst(skb)->dev->mtu);
> +		mtu -= lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
> +	} else
> +		mtu = dst_mtu(skb_dst(skb));
> +
> +	return mtu;
>  }
>  
>  static inline bool ip6_sk_accept_pmtu(const struct sock *sk)
> @@ -317,7 +324,7 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
>  	if (dst_metric_locked(dst, RTAX_MTU)) {
>  		mtu = dst_metric_raw(dst, RTAX_MTU);
>  		if (mtu)
> -			return mtu;
> +			goto out;
>  	}
>  
>  	mtu = IPV6_MIN_MTU;
> @@ -327,7 +334,8 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
>  		mtu = idev->cnf.mtu6;
>  	rcu_read_unlock();
>  
> -	return mtu;
> +out:
> +	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
>  }
>  
>  u32 ip6_mtu_from_fib6(const struct fib6_result *res,
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 6a36ac98476f..78d1e5afc452 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1306,7 +1306,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
>  		mtu = dst_metric_raw(dst, RTAX_MTU);
>  
>  	if (mtu)
> -		return mtu;
> +		goto out;
>  
>  	mtu = READ_ONCE(dst->dev->mtu);
>  
> @@ -1315,6 +1315,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
>  			mtu = 576;
>  	}
>  
> +out:
>  	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
>  
>  	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
> 

