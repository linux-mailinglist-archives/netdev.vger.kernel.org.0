Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9708E7EE
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbfHOJRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:17:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34279 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731089AbfHOJRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:17:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so859866wrn.1
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 02:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9S1Fl2pCCtOhtdw8xvtiYq606p0vdg/15a2bhEpk7PQ=;
        b=BRk7jAs5X88e09hrMxEnVgz10hV/2AKHV2GlQERJAeP5K594b7mzPeWH+PrTJtufrE
         cKaiERYImkkwPOK0XixGD/eYZrcjupXvlrEC3vS1KAEfPvwdjh0ipJ5A+G6hGgLxTXt2
         oyJkcXFzOJP3txFz9QbLnwIda48pJ0GDodI1vpkYISfJYDKiG/u15xOAo6cNTxwTu+bV
         QWKs4bgH37ghxBwETCE7vZopswxRSrp8tUFgfxQORoccAcA6//Ao/iSxVUVggt/Y5p+c
         yaW3mEsXiw2m/hTA1UdqdqcH/X3SDzwfAwLAH2dSIsTQ0HaF3JlQum80zy3/kb7nnXt1
         /3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9S1Fl2pCCtOhtdw8xvtiYq606p0vdg/15a2bhEpk7PQ=;
        b=C52lhX6FBUyXznY2oea2rk+5EgfKcdAhNNYNCZz2zR+q3aP47BZcX5tJYITnsOgm0a
         sa4o0MdJJFy/5kyH7p9tpjzwWbsKcNl+Rs1dzwDXE5PG32B8qTJ6IPkqPIVtffCzS9yE
         O//uoO657/zZ+IB0EWc+vwpePXB7i7JztUFKfcs4Ifych1SX3Vi+EzHE1LC4nNW9KNN7
         3v/Sg1vkyWXCiCkFhVkLWXMM4GNE/KeZxwv1WDAu4uJk7z19jIMIrWkBE4pMt14VUT24
         uecTWoM7MAFfW6HemR/G2SzQT/Y7eDFwuhYEEhSySxJpbeOz8XLHXJ3I/HceGcdVDTy4
         VeZA==
X-Gm-Message-State: APjAAAUUeeumxo5mjq20EvgOdXMWVCmctx0PZgJRJhMnCvoY6LSTrDU1
        3AS3GYuccUz0DXKf30otlb8=
X-Google-Smtp-Source: APXvYqzRmLWUpa+tnZkUFcC8sQ07cc3uuvIIVNGKgge9t3tpJia1Opx5u10HqU2NVOVHeTx8JC8MWQ==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr4361080wro.31.1565860620729;
        Thu, 15 Aug 2019 02:17:00 -0700 (PDT)
Received: from [192.168.8.147] (178.161.185.81.rev.sfr.net. [81.185.161.178])
        by smtp.gmail.com with ESMTPSA id x13sm817240wmj.12.2019.08.15.02.16.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:16:59 -0700 (PDT)
Subject: Re: [PATCH net] tunnel: fix dev null pointer dereference when send
 pkg larger than mtu in collect_md mode
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cb5b5d82-1239-34a9-23f5-1894a2ec92a2@gmail.com>
Date:   Thu, 15 Aug 2019 11:16:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190815060904.19426-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/19 8:09 AM, Hangbin Liu wrote:
> When we send a packet larger than PMTU, we need to reply with
> icmp_send(ICMP_FRAG_NEEDED) or icmpv6_send(ICMPV6_PKT_TOOBIG).
> 
> But in collect_md mode, kernel will crash while accessing the dst dev
> as __metadata_dst_init() init dst->dev to NULL by default. Here is what
> the code path looks like, for GRE:
> 
> - ip6gre_tunnel_xmit
>   - ip6gre_xmit_ipv4
>     - __gre6_xmit
>       - ip6_tnl_xmit
>         - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
>     - icmp_send
>       - net = dev_net(rt->dst.dev); <-- here
>   - ip6gre_xmit_ipv6
>     - __gre6_xmit
>       - ip6_tnl_xmit
>         - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
>     - icmpv6_send
>       ...
>       - decode_session4
>         - oif = skb_dst(skb)->dev->ifindex; <-- here
>       - decode_session6
>         - oif = skb_dst(skb)->dev->ifindex; <-- here
> 
> Fix it by updating the dst dev if not set.
> 
> The reproducer is easy:
> 
> ovs-vsctl add-br br0
> ip link set br0 up
> ovs-vsctl add-port br0 gre0 -- \
> 	  set interface gre0 type=gre options:remote_ip=$dst_addr
> ip link set gre0 up
> ip addr add ${local_gre6}/64 dev br0
> ping6 $remote_gre6 -s 1500
> 
> Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
> Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnels")
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv4/ip_tunnel.c  |  3 +++
>  net/ipv6/ip6_tunnel.c | 13 +++++++++----
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 38c02bb62e2c..c6713c7287df 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -597,6 +597,9 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
>  		goto tx_error;
>  	}
>  
> +	if (skb_dst(skb) && !skb_dst(skb)->dev)
> +		skb_dst(skb)->dev = rt->dst.dev;
> +


IMO this looks wrong.
This dst seems shared. 
Once set, we will reuse the same dev ?

If intended, why not doing this in __metadata_dst_init() instead of in the fast path ?

>  	if (key->tun_flags & TUNNEL_DONT_FRAGMENT)
>  		df = htons(IP_DF);
>  	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph, tunnel_hlen,
