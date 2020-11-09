Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE462AC4F6
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbgKIT3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKIT3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 14:29:09 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3198C0613CF;
        Mon,  9 Nov 2020 11:29:07 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id s8so2923056wrw.10;
        Mon, 09 Nov 2020 11:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m6LxZ8aRrjGXNDFB2Tn/gXhpm/LDD8SKjkVf58nA1TY=;
        b=B8cmZ4Yud/sp/VaPzSBFxk1DQp2ub8gpkUGRKHkTDyg5kSl3+bEvEpS0TSVDppKbPS
         Kp3bCSt49YWyr1dJMfWfX1Fwli26Hz60oLLvb3j518q8zOHy7kiSV7dO1Tnqfl/rhW4/
         M6vvPJ/hpZj+UmL+JtYRZi96mSft+3JfdTYNdVVl0zHP3fdy989fxI074vCzHtz2EB9w
         Pg3e1GTwUgMx8FQmrei5MW3+2l6H6dTQFBeWclIaZjpNu0e5p8deVG6rxZGF1oPHscvS
         rWO5RjjD6mYrXM6ZwSMZlOTUsruZSJpkY6LDvQ+n5tJ/pfr3WGu4LXRrENsjfFFsQymz
         NwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m6LxZ8aRrjGXNDFB2Tn/gXhpm/LDD8SKjkVf58nA1TY=;
        b=pfavbwSoIqOxiIkKUV8W6+jf70HY4Oo1gdIxvaRqEdmkysSAEfAlyggqFflokIQ3Mh
         Vk0R8700tHM8XLD+cUK5/wFbD87ZtZqRbYmfJHMi/QxGCKTV3lkq4QqBBmmvgycKCx1e
         kBLP+Ll1THn6GIb5ca3pgrho0Zq5Shx9Hkdma1MrZ2H8Qr5bObmZHurHrkJ9pPED+BHy
         TUb+ltaKfKomzpI6rgAW3G+pd9NshMB4TV/TTI/pb8Jp0l/RHbOVlahI7sib+uLxEIS/
         Ji+g65hBaCBLag8H4vedjyTxAucNoPaxUwX5clB+Prh6Q9qxPsi4mJeJ7m/6cOvO0GyQ
         k/Pw==
X-Gm-Message-State: AOAM53380bVFLzWQuTu5IxA0DNpLPrWZkkWPnS5zlr5slHQEsS6PYZB/
        1FP4fGgvVIqlovPOi8HIUIMqFdZlGt8=
X-Google-Smtp-Source: ABdhPJzTwG/lHfIHnIoiZlxEJdgkQikDIZR5xabq8vsJjPZFoT+QvHLcBzfTJPiprwc5NOwpI9p9qw==
X-Received: by 2002:adf:f085:: with SMTP id n5mr19624887wro.293.1604950146185;
        Mon, 09 Nov 2020 11:29:06 -0800 (PST)
Received: from [192.168.8.114] ([37.170.31.34])
        by smtp.gmail.com with ESMTPSA id u6sm408969wmj.40.2020.11.09.11.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 11:29:05 -0800 (PST)
Subject: Re: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
To:     Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch>
 <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com>
 <Nc6hn1Qaui1C7hTlHl8CdsNV00CdlHtyjQYv36ZYA@cp4-web-040.plabs.ch>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0a7af3fb-d1c4-bedf-4931-5f22f0481491@gmail.com>
Date:   Mon, 9 Nov 2020 20:29:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <Nc6hn1Qaui1C7hTlHl8CdsNV00CdlHtyjQYv36ZYA@cp4-web-040.plabs.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/20 7:26 PM, Alexander Lobakin wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 9 Nov 2020 18:37:36 +0100
> 
>> On 11/9/20 5:56 PM, Alexander Lobakin wrote:
>>> While testing UDP GSO fraglists forwarding through driver that uses
>>> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
>>> iperf packets:
>>>
.
>>>
>>> Since v1 [1]:
>>>  - added a NULL pointer check for "uh" as suggested by Willem.
>>>
>>> [1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch
>>>
>>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>> ---
>>>  net/ipv4/udp_offload.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>>> index e67a66fbf27b..7f6bd221880a 100644
>>> --- a/net/ipv4/udp_offload.c
>>> +++ b/net/ipv4/udp_offload.c
>>> @@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>>>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>>>  					       struct sk_buff *skb)
>>>  {
>>> -	struct udphdr *uh = udp_hdr(skb);
>>> +	struct udphdr *uh = udp_gro_udphdr(skb);
>>>  	struct sk_buff *pp = NULL;
>>>  	struct udphdr *uh2;
>>>  	struct sk_buff *p;
>>>  	unsigned int ulen;
>>>  	int ret = 0;
>>>
>>> +	if (unlikely(!uh)) {
>>
>> How uh could be NULL here ?
>>
>> My understanding is that udp_gro_receive() is called
>> only after udp4_gro_receive() or udp6_gro_receive()
>> validated that udp_gro_udphdr(skb) was not NULL.
> 
> Right, but only after udp{4,6}_lib_lookup_skb() in certain cases.
> I don't know for sure if their logic can actually edit skb->data,
> so it's better to check from my point of view.

Not really. This would send a wrong signal to readers of this code.

I do not think these functions can mess with GRO internals.

This would be a nightmare, GRO is already way too complex.

In fact these functions should use a const qualifier
for their " struct sk_buff *skb" argument to prevent future bugs.

I will test and submit this patch :

diff --git a/include/net/ip.h b/include/net/ip.h
index 2d6b985d11ccaa75827b3a15ac3f898d7a193242..e20874059f826eb0f9e899aed556bfbc9c9d71e8 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -99,7 +99,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 #define PKTINFO_SKB_CB(skb) ((struct in_pktinfo *)((skb)->cb))
 
 /* return enslaved device index if relevant */
-static inline int inet_sdif(struct sk_buff *skb)
+static inline int inet_sdif(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
        if (skb && ipv4_l3mdev_skb(IPCB(skb)->flags))
diff --git a/include/net/udp.h b/include/net/udp.h
index 295d52a73598277dc5071536f777d1a87e7df1d1..877832bed4713a011a514a2f6f522728c8c89e20 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -164,7 +164,7 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
        UDP_SKB_CB(skb)->cscov -= sizeof(struct udphdr);
 }
 
-typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
+typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 sport,
                                     __be16 dport);
 
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_head *,
@@ -313,7 +313,7 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
                               __be32 daddr, __be16 dport, int dif, int sdif,
                               struct udp_table *tbl, struct sk_buff *skb);
-struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
                                 __be16 sport, __be16 dport);
 struct sock *udp6_lib_lookup(struct net *net,
                             const struct in6_addr *saddr, __be16 sport,
@@ -324,7 +324,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
                               const struct in6_addr *daddr, __be16 dport,
                               int dif, int sdif, struct udp_table *tbl,
                               struct sk_buff *skb);
-struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
                                 __be16 sport, __be16 dport);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23d1a01741d335ce45f25fe70a4e00698c7..8b8dadfea6c9854e6bfaa0fabcb774db39976da3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -541,7 +541,7 @@ static inline struct sock *__udp4_lib_lookup_skb(struct sk_buff *skb,
                                 inet_sdif(skb), udptable, skb);
 }
 
-struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
                                 __be16 sport, __be16 dport)
 {
        const struct iphdr *iph = ip_hdr(skb);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691359b9c49ccb56a11f79e3658b1a76700d..adfe9ca6f516612b5aad6d6c654c7da1dd56a50e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -276,7 +276,7 @@ static struct sock *__udp6_lib_lookup_skb(struct sk_buff *skb,
                                 inet6_sdif(skb), udptable, skb);
 }
 
-struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
                                 __be16 sport, __be16 dport)
 {
        const struct ipv6hdr *iph = ipv6_hdr(skb);
