Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65C243865E
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 04:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhJXCoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 22:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhJXCoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 22:44:02 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A5EC061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 19:41:42 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id c28so7175004qtv.11
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 19:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HS7Xz9JbXx1vEGCcYNCKZ37pGlnCEW9ma4hOljJDXVQ=;
        b=DiDjj3vne5wyM4tm2kGUC3PBW/fSaKpPtpeRf+wweDzpTtqZ0D4bDqKtLy2KehSz0B
         PwnDeDHax9OU4A7MlWC9Ni4fwBepsDZOsMIPysgKHbcJNiK+rBBrNrCWoum7n9k5CTYZ
         3aWRn+mJAc52Haeh9l68H7JSVvk8uqmWss/64Tt2S+hudqHWu+DZcLgcXeC7vUYdDGsC
         EQlhpdTzXRwTSgXPZgXrbmMtkTwj/1xrQF68GPVE34EX4HpXmrz9K79acKt6Kz/phr12
         xhWXYBijDBiRvnKSCsNup3INnln/s0uF+FeDm+JeaWH3z5K2e2BYVBmQRaWSKcwSNqfc
         E/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HS7Xz9JbXx1vEGCcYNCKZ37pGlnCEW9ma4hOljJDXVQ=;
        b=gh2SasAQVWa/xmbnM1nC+1wFyT09kuX9VL554HWd9soJkQnrxptLNhEnpaPnIqsjwg
         cwCIBReyyn0wjR4OZbMT9ME9RyGTLNh6nTTXq2oCbGVQ9GcXkLxLt/AjqmVvnviEnDj0
         +zlmz09kjLmkKeMse7zQVQlC+l7TeJiwr1BtGEVXr7FN4oULlzKsi09lXqDeDtYxvBwF
         UGxNlGEJInKT5m9xvSElfrgxCZiDPrPlj5L4MBH9ZKIVpu4vTpNXB04igsPY1hk7vCi2
         KjMYuQEruuhHdJldNGAKnhNk9YPNsVl1ZLdTpe1xdFa9/flsX/vyNuOFOt7oGphRyY/O
         MAOA==
X-Gm-Message-State: AOAM532l7hyjWuhgSO+SwrPH1rv/RIXtBiqlAKEguxa98WGBH/Ah7Xz3
        kPIZEj2/vGst7ukukf8jRph2i/HL6SOCfaFxk7n/dGFP
X-Google-Smtp-Source: ABdhPJx7GwjEeapuKUbDMxBn/rPtpY92rJKOA8aDgdJi2FlI0atDXgpe8Y9SR8SiL4gWWvod9ht20kmqI5puTVcL7H0=
X-Received: by 2002:a05:622a:3c9:: with SMTP id k9mr9474106qtx.170.1635043302030;
 Sat, 23 Oct 2021 19:41:42 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSdqS2gpdoXcyo3URn5A=yYCuW55b=grFkmiMbX2hzXcfg@mail.gmail.com>
 <20211023232608.1095185-1-cyril.strejc@skoda.cz>
In-Reply-To: <20211023232608.1095185-1-cyril.strejc@skoda.cz>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 23 Oct 2021 22:41:06 -0400
Message-ID: <CAF=yD-K_-i1wCaRg4VqocMqL9m7OrcCy3AXVn4d8k7yXg6yz5g@mail.gmail.com>
Subject: Re: [PATCH] net: multicast: calculate csum of looped-back and
 forwarded packets
To:     Cyril Strejc <cyril.strejc@skoda.cz>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 23, 2021 at 7:26 PM Cyril Strejc <cyril.strejc@skoda.cz> wrote:
>
> On 10/22/21 9:08 PM, Willem de Bruijn wrote:
> >> We could fix this as follows:
> >>
> >> 1. Not set CHECKSUM_UNNECESSARY in dev_loopback_xmit(), because it
> >>    is just not true.
> >
> > I think this is the right approach. The receive path has to be able to
> > handle packets looped from the transmit path with CHECKSUM_PARTIAL
> > set.
>
> As You clarified, the receive path handles CHECKSUM_PARTIAL.
>
> There is a problem with CHECKSUM_NONE -- the case when TX checksum
> offload is not supported by a NIC. Kernel does not set
> CHECKSUM_UNNECESSARY with a correct value of csum_level when a packet
> is being prepared for transmission, but just set the CHECKSUM_NONE.
>
> >> 2. I assume, the original idea behind setting CHECKSUM_UNNECESSARY in
> >>    dev_loopback_xmit() is to prevent checksum validation of looped-back
> >>    local multicast packets. We can adjust
> >>    __skb_checksum_validate_needed() to handle this as the special case.
> >>
> >> Signed-off-by: Cyril Strejc <cyril.strejc@skoda.cz>
> >> ---
> >>  include/linux/skbuff.h | 4 +++-
> >>  net/core/dev.c         | 1 -
> >>  2 files changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >> index 841e2f0f5240..95aa0014c3d6 100644
> >> --- a/include/linux/skbuff.h
> >> +++ b/include/linux/skbuff.h
> >> @@ -4048,7 +4048,9 @@ static inline bool __skb_checksum_validate_needed(struct sk_buff *skb,
> >>                                                   bool zero_okay,
> >>                                                   __sum16 check)
> >>  {
> >> -       if (skb_csum_unnecessary(skb) || (zero_okay && !check)) {
> >> +       if (skb_csum_unnecessary(skb) ||
> >> +           (zero_okay && !check) ||
> >> +           skb->pkt_type == PACKET_LOOPBACK) {
> >
> > This should not be needed, as skb_csum_unnecessary already handles
> > CHECKSUM_PARTIAL?
> >
>
> Still we need some solution for the CHECKSUM_NONE case which triggers
> checksum validation.
>
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index 7ee9fecd3aff..ba4a0994d97b 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -3906,7 +3906,6 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
> >>         skb_reset_mac_header(skb);
> >>         __skb_pull(skb, skb_network_offset(skb));
> >>         skb->pkt_type = PACKET_LOOPBACK;
> >> -       skb->ip_summed = CHECKSUM_UNNECESSARY;
> >>         WARN_ON(!skb_dst(skb));
> >>         skb_dst_force(skb);
> >>         netif_rx_ni(skb);
> >> --
> >> 2.25.1
> >>
> >
>
> Alternatively, we could solve the CHECKSUM_NONE case by a simple,
> practical and historical compatible "TX->RX translation" of ip_summed
> in dev_loopback_xmit(), which keeps CHECKSUM_PARTIAL and leaves
> __skb_checksum_validate_needed() as is:
>
>         if (skb->ip_summed == CHECKSUM_NONE)
>                 skb->ip_summed = CHECKSUM_UNNECESSARY;
>
> or:
>         if (skb->ip_summed != CHECKSUM_PARTIAL)
>                 skb->ip_summed = CHECKSUM_UNNECESSARY;

Based on the idea that these packets are fully checksummed, so even if
they loop to the tx path again with ip_summed CHECKSUM_UNNECESSARY,
they will not cause the bug that you originally reported?

Yes, that looks like a nice solution.

I wonder what the behavior is for unicast packets. As it makes sense
for the two to work the same. For instance, packets traveling over
veth_xmit to a local socket. Their ip_summed is not adjusted as far as
I know. If created with CHECKSUM_NONE, these will then incur an
unnecessary checksum validation, too. Such packets are built, e.g.,
for udp sockets with corking. They could benefit from a similar
solution. Not suggesting for this patch, to be clear.
