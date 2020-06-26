Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C09620A9E6
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgFZAs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgFZAs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:48:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32447C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:48:56 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id cy7so5647220edb.5
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HvfaIlqGMo4LzixLcxPQErGaf+kB+CwopPGbquM8cWU=;
        b=KfPK2LqRfHk02KdcVZBu287AuylKbexQq8titByzMiehfr3Nbi8BlxTaOr0K3kV/Cd
         jTygaGJatxcEcgEcAo0/46Z89GM1jC9O07aKL4sIEURWc1q57sGyLCPARyfhLW9QCcq9
         YAB6P5j4iVZWNJDaEIUgv/hqb2z2o+/g0n3CJosA+KceNHHL40h5tpGG1kXSdDMpffmH
         7hKfxgCbHbTO1x8XohW/7ciZYznSIgaPOeS5saj1NOBQJmhpCBLVh96lH//Yy34V7PD4
         OgxlPrSjxSvKTU82wYjcJ+ol+0bPfXtZUcVlRjW5B8AQXjYfG4RK2jPUzNXynD1Vcvap
         5jQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HvfaIlqGMo4LzixLcxPQErGaf+kB+CwopPGbquM8cWU=;
        b=NMiqzFpziHrqW2DkRF16VajoV7TQYdIhy1evBx7W4Mmw0pw631CVX7+UUjN3W0ROxm
         iH6wlQBRi+/yiQcD8jkHirYboaQGyyNvNlunIMAas5zHp9u6L0V+wMMBCYJzW1nPrglq
         JvZsX5qM+YkH3SDB4mkWNrTh19udV6nRq7pEh726MZcPvMefD49rZFYATlsSNnELrkEm
         LbaEO1FTyL7ucuvWlP/Ou2DKJopabIt+dEgbXnD41wOp0TZT9Y3Ipk8qTHsmHxVZj/i6
         ixoL2uZApVW8V2VHdLhdsFpUfPVebhnJymqyfVvrCuxeGAuSPf8H+M2yUWp8QdBGaYwu
         Q5xg==
X-Gm-Message-State: AOAM532oyJJet0RyM+2wVMS2zlZUxuJAOijYXQahvPEHUzSm9ckFJz9v
        RDXwnbIepy+bhwV8r0ZR57kyI1A8pB42aa4CsxSmFg==
X-Google-Smtp-Source: ABdhPJwIoQJ84VKFOOsc2ZNyMlQ8RrawbUZ7qtIH8Z1TLUQF0X2pSVWE6EoCMz9HV/KXTCb7GVwBiNzuUSBbT4bydio=
X-Received: by 2002:a05:6402:144a:: with SMTP id d10mr875217edx.35.1593132534519;
 Thu, 25 Jun 2020 17:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be>
 <20200624192310.16923-3-justin.iurman@uliege.be> <CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com>
 <1597014330.36579162.1593107802322.JavaMail.zimbra@uliege.be>
In-Reply-To: <1597014330.36579162.1593107802322.JavaMail.zimbra@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Thu, 25 Jun 2020 17:48:43 -0700
Message-ID: <CALx6S37wpA5Mc7jdUk8_sR_fJTc-zRpvY8VkDV=NoWdvDhKfpg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] ipv6: IOAM tunnel decapsulation
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 10:56 AM Justin Iurman <justin.iurman@uliege.be> wrote:
>
> >> Implement the IOAM egress behavior.
> >>
> >> According to RFC 8200:
> >> "Extension headers (except for the Hop-by-Hop Options header) are not
> >>  processed, inserted, or deleted by any node along a packet's delivery
> >>  path, until the packet reaches the node (or each of the set of nodes,
> >>  in the case of multicast) identified in the Destination Address field
> >>  of the IPv6 header."
> >>
> >> Therefore, an ingress node (an IOAM domain border) must encapsulate an
> >> incoming IPv6 packet with another similar IPv6 header that will contain
> >> IOAM data while it traverses the domain. When leaving, the egress node,
> >> another IOAM domain border which is also the tunnel destination, must
> >> decapsulate the packet.
> >
> > This is just IP in IP encapsulation that happens to be terminated at
> > an egress node of the IOAM domain. The fact that it's IOAM isn't
> > germaine, this IP in IP is done in a variety of ways. We should be
> > using the normal protocol handler for NEXTHDR_IPV6  instead of special
> > case code.
>
> Agree. The reason for this special case code is that I was not aware of a more elegant solution.
>
The current implementation might not be what you're looking for since
ip6ip6 wants a tunnel configured. What we really want is more like
anonymous decapsulation, that is just decap the ip6ip6 packet and
resubmit the packet into the stack (this is what you patch is doing).
The idea has been kicked around before, especially in the use case
where we're tunneling across a domain and there could be hundreds of
such tunnels to some device. I think it's generally okay to do this,
although someone might raise security concerns since it sort of
obfuscates the "real packet". Probably makes sense to have a sysctl to
enable this and probably could default to on. Of course, if we do this
the next question is should we also implement anonymous decapsulation
for 44,64,46 tunnels.

Tom

> Justin
>
> >> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> >> ---
> >>  include/linux/ipv6.h |  1 +
> >>  net/ipv6/ip6_input.c | 22 ++++++++++++++++++++++
> >>  2 files changed, 23 insertions(+)
> >>
> >> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> >> index 2cb445a8fc9e..5312a718bc7a 100644
> >> --- a/include/linux/ipv6.h
> >> +++ b/include/linux/ipv6.h
> >> @@ -138,6 +138,7 @@ struct inet6_skb_parm {
> >>  #define IP6SKB_HOPBYHOP        32
> >>  #define IP6SKB_L3SLAVE         64
> >>  #define IP6SKB_JUMBOGRAM      128
> >> +#define IP6SKB_IOAM           256
> >>  };
> >>
> >>  #if defined(CONFIG_NET_L3_MASTER_DEV)
> >> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> >> index e96304d8a4a7..8cf75cc5e806 100644
> >> --- a/net/ipv6/ip6_input.c
> >> +++ b/net/ipv6/ip6_input.c
> >> @@ -361,9 +361,11 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff
> >> *));
> >>  void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
> >>                               bool have_final)
> >>  {
> >> +       struct inet6_skb_parm *opt = IP6CB(skb);
> >>         const struct inet6_protocol *ipprot;
> >>         struct inet6_dev *idev;
> >>         unsigned int nhoff;
> >> +       u8 hop_limit;
> >>         bool raw;
> >>
> >>         /*
> >> @@ -450,6 +452,25 @@ void ip6_protocol_deliver_rcu(struct net *net, struct
> >> sk_buff *skb, int nexthdr,
> >>         } else {
> >>                 if (!raw) {
> >>                         if (xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
> >> +                               /* IOAM Tunnel Decapsulation
> >> +                                * Packet is going to re-enter the stack
> >> +                                */
> >> +                               if (nexthdr == NEXTHDR_IPV6 &&
> >> +                                   (opt->flags & IP6SKB_IOAM)) {
> >> +                                       hop_limit = ipv6_hdr(skb)->hop_limit;
> >> +
> >> +                                       skb_reset_network_header(skb);
> >> +                                       skb_reset_transport_header(skb);
> >> +                                       skb->encapsulation = 0;
> >> +
> >> +                                       ipv6_hdr(skb)->hop_limit = hop_limit;
> >> +                                       __skb_tunnel_rx(skb, skb->dev,
> >> +                                                       dev_net(skb->dev));
> >> +
> >> +                                       netif_rx(skb);
> >> +                                       goto out;
> >> +                               }
> >> +
> >>                                 __IP6_INC_STATS(net, idev,
> >>                                                 IPSTATS_MIB_INUNKNOWNPROTOS);
> >>                                 icmpv6_send(skb, ICMPV6_PARAMPROB,
> >> @@ -461,6 +482,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct
> >> sk_buff *skb, int nexthdr,
> >>                         consume_skb(skb);
> >>                 }
> >>         }
> >> +out:
> >>         return;
> >>
> >>  discard:
> >> --
> >> 2.17.1
