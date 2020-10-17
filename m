Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5BB291044
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 08:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437262AbgJQG4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 02:56:10 -0400
Received: from novek.ru ([213.148.174.62]:55490 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437243AbgJQG4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 02:56:08 -0400
X-Greylist: delayed 4200 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Oct 2020 02:56:08 EDT
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1A6BA50123E;
        Sat, 17 Oct 2020 04:01:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1A6BA50123E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1602896493; bh=BJdRR6co79KShnGoJtL9UJV9mKc3HETBFAyrJE5bG0U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Eau5Lqd/B+mWEAIPDja9stWJ44dzhHpbW0OEZ3m/9GiJracvqSEA6ou9ZW0M4eP3F
         2RIM9GnCe0uyIMdajyVyhJVY3STuTcyOsEBTETkNo8wpU7v81ds8WSWqiroNsiapj6
         R6br1JRVnQn3oRWckBWrQcbShghcpguUdrLv+uGo=
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     Network Development <netdev@vger.kernel.org>
References: <20201016111156.26927-1-ovov@yandex-team.ru>
 <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <22adf1a4-9b8d-0502-a677-a812490e0f63@novek.ru>
Date:   Sat, 17 Oct 2020 01:59:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.10.2020 18:55, Willem de Bruijn wrote:
> On Fri, Oct 16, 2020 at 7:14 AM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>> ip6_tnl_encap assigns to proto transport protocol which
>> encapsulates inner packet, but we must pass to set_inner_ipproto
>> protocol of that inner packet.
>>
>> Calling set_inner_ipproto after ip6_tnl_encap might break gso.
>> For example, in case of encapsulating ipv6 packet in fou6 packet, inner_ipproto
>> would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead to
>> incorrect calling sequence of gso functions:
>> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> udp6_ufo_fragment
>> instead of:
>> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> ip6ip6_gso_segment
>>
>> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support") moved
> the call from ip6_tnl_encap's caller to inside ip6_tnl_encap.
>
> It makes sense that that likely broke this behavior for UDP (L4) tunnels.
>
> But it was moved on purpose to avoid setting the inner protocol to
> IPPROTO_MPLS. That needs to use skb->inner_protocol to further
> segment.
>
> I suspect we need to set this before or after conditionally to avoid
> breaking that use case.
I hope it could be fixed with something like this:

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a0217e5..87368b0 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1121,6 +1121,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device 
*dev, __u8 dsfield,
         bool use_cache = false;
         u8 hop_limit;
         int err = -1;
+       __u8 pproto = proto;

         if (t->parms.collect_md) {
                 hop_limit = skb_tunnel_info(skb)->key.ttl;
@@ -1280,7 +1281,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device 
*dev, __u8 dsfield,
                 ipv6_push_frag_opts(skb, &opt.ops, &proto);
         }

-       skb_set_inner_ipproto(skb, proto);
+       skb_set_inner_ipproto(skb, pproto == IPPROTO_MPLS ? proto : pproto);

         skb_push(skb, sizeof(struct ipv6hdr));
         skb_reset_network_header(skb);

