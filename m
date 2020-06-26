Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C16220AE6E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgFZIbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:31:49 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:44088 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFZIbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:31:48 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id 874B0200F80A;
        Fri, 26 Jun 2020 10:31:34 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 874B0200F80A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593160294;
        bh=q9Y0oCmThAKodg6+qiHI6+CGPNPzfe115rcE+6w4KHg=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=akNjcNuTJdfV0jaFrUrCZT8UDUAaXufFQix6shdvI9yabt39KJIhIaEZEoTOAQpMh
         Q/mY8v6Ycp1RLctJO5YG2pXKde36p3VqqivfcBfA1T4U7Mz4pvIHIknbVYEduXcvgG
         pNIDD73x+v2qiKsHDaH3OKO5t/MBQFRi1DTniEh6VsphE//7ZiG/e/JMjK0i9TPSRe
         +IbS6I0igiWzCb/SDYBuZ7nrL0ngmBQXg9d3ABWel4h3mzOiBghTCFQdGGwecGe6vX
         PF9Efkw0TDnbklfEis1Cy2Ty7xCIwxEMJu42dJskpRDdA7BP0LVImKcWkLMSHY3VQQ
         qlZUcP1izpPSA==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 7FDD3129EC60;
        Fri, 26 Jun 2020 10:31:34 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YUKY9Pdc3oIh; Fri, 26 Jun 2020 10:31:34 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 68B73129EC29;
        Fri, 26 Jun 2020 10:31:34 +0200 (CEST)
Date:   Fri, 26 Jun 2020 10:31:34 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Tom Herbert <tom@herbertland.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <998893232.37051625.1593160294302.JavaMail.zimbra@uliege.be>
In-Reply-To: <CALx6S37wpA5Mc7jdUk8_sR_fJTc-zRpvY8VkDV=NoWdvDhKfpg@mail.gmail.com>
References: <20200624192310.16923-1-justin.iurman@uliege.be> <20200624192310.16923-3-justin.iurman@uliege.be> <CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com> <1597014330.36579162.1593107802322.JavaMail.zimbra@uliege.be> <CALx6S37wpA5Mc7jdUk8_sR_fJTc-zRpvY8VkDV=NoWdvDhKfpg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] ipv6: IOAM tunnel decapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.129.49.166]
X-Mailer: Zimbra 8.8.15_GA_3901 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3895)
Thread-Topic: ipv6: IOAM tunnel decapsulation
Thread-Index: dzRfPHulJJrHCK2jCB0jqUu7PuAR1g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom,

>> >> Implement the IOAM egress behavior.
>> >>
>> >> According to RFC 8200:
>> >> "Extension headers (except for the Hop-by-Hop Options header) are not
>> >>  processed, inserted, or deleted by any node along a packet's delivery
>> >>  path, until the packet reaches the node (or each of the set of nodes,
>> >>  in the case of multicast) identified in the Destination Address field
>> >>  of the IPv6 header."
>> >>
>> >> Therefore, an ingress node (an IOAM domain border) must encapsulate an
>> >> incoming IPv6 packet with another similar IPv6 header that will contain
>> >> IOAM data while it traverses the domain. When leaving, the egress node,
>> >> another IOAM domain border which is also the tunnel destination, must
>> >> decapsulate the packet.
>> >
>> > This is just IP in IP encapsulation that happens to be terminated at
>> > an egress node of the IOAM domain. The fact that it's IOAM isn't
>> > germaine, this IP in IP is done in a variety of ways. We should be
>> > using the normal protocol handler for NEXTHDR_IPV6  instead of special
>> > case code.
>>
>> Agree. The reason for this special case code is that I was not aware of a more
>> elegant solution.
>>
> The current implementation might not be what you're looking for since
> ip6ip6 wants a tunnel configured. What we really want is more like
> anonymous decapsulation, that is just decap the ip6ip6 packet and
> resubmit the packet into the stack (this is what you patch is doing).
> The idea has been kicked around before, especially in the use case
> where we're tunneling across a domain and there could be hundreds of
> such tunnels to some device. I think it's generally okay to do this,
> although someone might raise security concerns since it sort of
> obfuscates the "real packet". Probably makes sense to have a sysctl to

Indeed. However, in this precise case for IOAM, you don't have security issues since you would only decap if an IOAM HBH is found in the outer header, which is only valid if the node is part of the IOAM domain (IOAM is enabled on its ingress interface). But, for a more generic case, I agree for the sysctl solution.

> enable this and probably could default to on. Of course, if we do this
> the next question is should we also implement anonymous decapsulation
> for 44,64,46 tunnels.

Interesting question. I'd say that we should only do it if there is at least a use case that is (or will be) part of the kernel.

Justin

> Tom
> 
>> Justin
>>
>> >> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>> >> ---
>> >>  include/linux/ipv6.h |  1 +
>> >>  net/ipv6/ip6_input.c | 22 ++++++++++++++++++++++
>> >>  2 files changed, 23 insertions(+)
>> >>
>> >> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
>> >> index 2cb445a8fc9e..5312a718bc7a 100644
>> >> --- a/include/linux/ipv6.h
>> >> +++ b/include/linux/ipv6.h
>> >> @@ -138,6 +138,7 @@ struct inet6_skb_parm {
>> >>  #define IP6SKB_HOPBYHOP        32
>> >>  #define IP6SKB_L3SLAVE         64
>> >>  #define IP6SKB_JUMBOGRAM      128
>> >> +#define IP6SKB_IOAM           256
>> >>  };
>> >>
>> >>  #if defined(CONFIG_NET_L3_MASTER_DEV)
>> >> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
>> >> index e96304d8a4a7..8cf75cc5e806 100644
>> >> --- a/net/ipv6/ip6_input.c
>> >> +++ b/net/ipv6/ip6_input.c
>> >> @@ -361,9 +361,11 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff
>> >> *));
>> >>  void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
>> >>                               bool have_final)
>> >>  {
>> >> +       struct inet6_skb_parm *opt = IP6CB(skb);
>> >>         const struct inet6_protocol *ipprot;
>> >>         struct inet6_dev *idev;
>> >>         unsigned int nhoff;
>> >> +       u8 hop_limit;
>> >>         bool raw;
>> >>
>> >>         /*
>> >> @@ -450,6 +452,25 @@ void ip6_protocol_deliver_rcu(struct net *net, struct
>> >> sk_buff *skb, int nexthdr,
>> >>         } else {
>> >>                 if (!raw) {
>> >>                         if (xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
>> >> +                               /* IOAM Tunnel Decapsulation
>> >> +                                * Packet is going to re-enter the stack
>> >> +                                */
>> >> +                               if (nexthdr == NEXTHDR_IPV6 &&
>> >> +                                   (opt->flags & IP6SKB_IOAM)) {
>> >> +                                       hop_limit = ipv6_hdr(skb)->hop_limit;
>> >> +
>> >> +                                       skb_reset_network_header(skb);
>> >> +                                       skb_reset_transport_header(skb);
>> >> +                                       skb->encapsulation = 0;
>> >> +
>> >> +                                       ipv6_hdr(skb)->hop_limit = hop_limit;
>> >> +                                       __skb_tunnel_rx(skb, skb->dev,
>> >> +                                                       dev_net(skb->dev));
>> >> +
>> >> +                                       netif_rx(skb);
>> >> +                                       goto out;
>> >> +                               }
>> >> +
>> >>                                 __IP6_INC_STATS(net, idev,
>> >>                                                 IPSTATS_MIB_INUNKNOWNPROTOS);
>> >>                                 icmpv6_send(skb, ICMPV6_PARAMPROB,
>> >> @@ -461,6 +482,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct
>> >> sk_buff *skb, int nexthdr,
>> >>                         consume_skb(skb);
>> >>                 }
>> >>         }
>> >> +out:
>> >>         return;
>> >>
>> >>  discard:
>> >> --
> > >> 2.17.1
