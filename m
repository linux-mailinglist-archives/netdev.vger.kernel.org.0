Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6620A454
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406981AbgFYR45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:56:57 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:60440 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405512AbgFYR45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 13:56:57 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id 832D1200E2DC;
        Thu, 25 Jun 2020 19:56:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 832D1200E2DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593107802;
        bh=tP6vfPud6JkTtCNw0WCLhQqgKT74NJjbmp3KAZ8vlOg=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=FvOYqJ4NLHYhbXpFyRViwvc4FHqL59+nQcJVklHhD6xWQIhGNNtbQulTzyPug3Och
         QnGImJ4PFDoA9b1cfj7Wyew3Z6xSQhGTtFjMNPv2o8ebTEmq9F8sH6kS42XNU5D8bd
         7eBIhoMUSzGLXzqQYls3r6cPz1dKnugds4KpuWPZQPaOxQ2TN226EdLLhdW88Lp9aF
         iIVdBN+wdAxbcFUUPEFx6ITMP6CGKpt1lSpg0ROM0xXhLq1DHO5WznsypYeTvVFJ3Q
         Mafz6iiSN2QVtNtBsldarpvOcQg6E6PrUt7rlbAdXcQJFCcOL7rP+mRo5DgMClCefJ
         Z8eny7QiWx2LA==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 79B58129EB1E;
        Thu, 25 Jun 2020 19:56:42 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dNPMmfrAuuiu; Thu, 25 Jun 2020 19:56:42 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 61909129E7CC;
        Thu, 25 Jun 2020 19:56:42 +0200 (CEST)
Date:   Thu, 25 Jun 2020 19:56:42 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Tom Herbert <tom@herbertland.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <1597014330.36579162.1593107802322.JavaMail.zimbra@uliege.be>
In-Reply-To: <CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com>
References: <20200624192310.16923-1-justin.iurman@uliege.be> <20200624192310.16923-3-justin.iurman@uliege.be> <CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] ipv6: IOAM tunnel decapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.129.49.166]
X-Mailer: Zimbra 8.8.15_GA_3901 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3895)
Thread-Topic: ipv6: IOAM tunnel decapsulation
Thread-Index: f2aFup7KwYMSMhI24VJ0j2/2xdVdSA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Implement the IOAM egress behavior.
>>
>> According to RFC 8200:
>> "Extension headers (except for the Hop-by-Hop Options header) are not
>>  processed, inserted, or deleted by any node along a packet's delivery
>>  path, until the packet reaches the node (or each of the set of nodes,
>>  in the case of multicast) identified in the Destination Address field
>>  of the IPv6 header."
>>
>> Therefore, an ingress node (an IOAM domain border) must encapsulate an
>> incoming IPv6 packet with another similar IPv6 header that will contain
>> IOAM data while it traverses the domain. When leaving, the egress node,
>> another IOAM domain border which is also the tunnel destination, must
>> decapsulate the packet.
> 
> This is just IP in IP encapsulation that happens to be terminated at
> an egress node of the IOAM domain. The fact that it's IOAM isn't
> germaine, this IP in IP is done in a variety of ways. We should be
> using the normal protocol handler for NEXTHDR_IPV6  instead of special
> case code.

Agree. The reason for this special case code is that I was not aware of a more elegant solution.

Justin

>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>> ---
>>  include/linux/ipv6.h |  1 +
>>  net/ipv6/ip6_input.c | 22 ++++++++++++++++++++++
>>  2 files changed, 23 insertions(+)
>>
>> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
>> index 2cb445a8fc9e..5312a718bc7a 100644
>> --- a/include/linux/ipv6.h
>> +++ b/include/linux/ipv6.h
>> @@ -138,6 +138,7 @@ struct inet6_skb_parm {
>>  #define IP6SKB_HOPBYHOP        32
>>  #define IP6SKB_L3SLAVE         64
>>  #define IP6SKB_JUMBOGRAM      128
>> +#define IP6SKB_IOAM           256
>>  };
>>
>>  #if defined(CONFIG_NET_L3_MASTER_DEV)
>> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
>> index e96304d8a4a7..8cf75cc5e806 100644
>> --- a/net/ipv6/ip6_input.c
>> +++ b/net/ipv6/ip6_input.c
>> @@ -361,9 +361,11 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff
>> *));
>>  void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
>>                               bool have_final)
>>  {
>> +       struct inet6_skb_parm *opt = IP6CB(skb);
>>         const struct inet6_protocol *ipprot;
>>         struct inet6_dev *idev;
>>         unsigned int nhoff;
>> +       u8 hop_limit;
>>         bool raw;
>>
>>         /*
>> @@ -450,6 +452,25 @@ void ip6_protocol_deliver_rcu(struct net *net, struct
>> sk_buff *skb, int nexthdr,
>>         } else {
>>                 if (!raw) {
>>                         if (xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
>> +                               /* IOAM Tunnel Decapsulation
>> +                                * Packet is going to re-enter the stack
>> +                                */
>> +                               if (nexthdr == NEXTHDR_IPV6 &&
>> +                                   (opt->flags & IP6SKB_IOAM)) {
>> +                                       hop_limit = ipv6_hdr(skb)->hop_limit;
>> +
>> +                                       skb_reset_network_header(skb);
>> +                                       skb_reset_transport_header(skb);
>> +                                       skb->encapsulation = 0;
>> +
>> +                                       ipv6_hdr(skb)->hop_limit = hop_limit;
>> +                                       __skb_tunnel_rx(skb, skb->dev,
>> +                                                       dev_net(skb->dev));
>> +
>> +                                       netif_rx(skb);
>> +                                       goto out;
>> +                               }
>> +
>>                                 __IP6_INC_STATS(net, idev,
>>                                                 IPSTATS_MIB_INUNKNOWNPROTOS);
>>                                 icmpv6_send(skb, ICMPV6_PARAMPROB,
>> @@ -461,6 +482,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct
>> sk_buff *skb, int nexthdr,
>>                         consume_skb(skb);
>>                 }
>>         }
>> +out:
>>         return;
>>
>>  discard:
>> --
>> 2.17.1
