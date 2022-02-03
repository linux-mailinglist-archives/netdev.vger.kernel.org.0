Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4A04A8800
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351964AbiBCPsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238679AbiBCPsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:48:23 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51D6C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 07:48:22 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id j2so10421018ybu.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 07:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UVzqaqgkSoj7sVc6+k+5dfvjZA0TUTvOPaIl30PC7sQ=;
        b=Je7IE+dayqcx8QVAC7r9ae39i6+47icBRT+unITntLhb08Ppcp2RCXBdRG5szo//Xh
         1g83NrL+Sy4wNkNxtvhQEVgxKsfOtB00VvaW2tndLLyefZplt0dU+/evsJvAB+7rLj0F
         HocRmRNuK1N6W2ATKxaJn1Yf0Zid+3Hqsrp6mjrS5JwjH9FqDS0RDBI4ZXGBPkhZSuwX
         2sms1KgDtCxsSj9wVC3ax0zh7wnRpR8TODLfrMWmF0Dx8qvyWZl/LoSob54ae/hurmfr
         wzQqIpTJWpD6kQDMcpzYRNAM6D9mF62cTk94sAqSghLNKKCSJXLyzj6QRpR//Xrr+zN/
         P8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UVzqaqgkSoj7sVc6+k+5dfvjZA0TUTvOPaIl30PC7sQ=;
        b=Tx80PQuixgqRe+BZhj+VIIxtljmWWKUoED0+jL9x5t/1/L05ye5bNbiw3C0wQ3RV53
         tReWbYcmoB2OpTd7tSAdryaSJlHeTpzy1/nYgwWOUAU7oJNJlBZ2vuC8fGkBc8PFRynC
         xLO5O+Zdg22xfX3SSswajK6YUsHAEEegnjDly0B27WV5ZbXIiVxs0ODQtvBf56s27vlJ
         yfhaMPKgPa4tWD+nWQvTqnDOW/3uFA+GKiUDGWmMT1MF5WTW/gS1j72cbBBpMWbbxHMO
         ed1jzDSUV0fQ9NH4B2v/OYHR6zfc6sTzAReFhYhhpk2GsAkd0ClvFlnmj/w15YD8w43k
         rs7A==
X-Gm-Message-State: AOAM5310zSSTOvcyjVtiNGZfapY/yUqw05BePe2MsShTwVSq2ItODp9X
        Wrciq8nhCFndHp+fvOo/ETSEFXHh+LxBEZQ5wAIkTbgGrZREfCdK2Rg=
X-Google-Smtp-Source: ABdhPJzxLN2yF1cRcQ7zGV3qH+KDubVu5CkD4KcJ90tcOn8I5OpSlWt+1p4cmGO5qGkM84+pnfEvhwl6TEgQ6wuNNXg=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr47710315ybb.156.1643903301653;
 Thu, 03 Feb 2022 07:48:21 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-7-eric.dumazet@gmail.com> <99e23f620a798d6cfb9c9b20fb37ba6ba8137a05.camel@redhat.com>
In-Reply-To: <99e23f620a798d6cfb9c9b20fb37ba6ba8137a05.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 07:48:10 -0800
Message-ID: <CANn89i+ZN=Gvn93pCaF=f4Q5X9vyzS24CpevtWpaD0Zjb7OGHg@mail.gmail.com>
Subject: Re: [PATCH net-next 06/15] ipv6/gro: insert temporary HBH/jumbo header
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 1:20 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
> > BIG TCP ipv6 packets (bigger than 64K).
> >
> > This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
> > so that resulting packet can go through IPv6/TCP stacks.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  net/ipv6/ip6_offload.c | 32 ++++++++++++++++++++++++++++++--
> >  1 file changed, 30 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> > index d37a79a8554e92a1dcaa6fd023cafe2114841ece..dac6f60436e167a3d979fef02f25fc039c6ed37d 100644
> > --- a/net/ipv6/ip6_offload.c
> > +++ b/net/ipv6/ip6_offload.c
> > @@ -318,15 +318,43 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
> >  INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
> >  {
> >       const struct net_offload *ops;
> > -     struct ipv6hdr *iph = (struct ipv6hdr *)(skb->data + nhoff);
> > +     struct ipv6hdr *iph;
> >       int err = -ENOSYS;
> > +     u32 payload_len;
> >
> >       if (skb->encapsulation) {
> >               skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
> >               skb_set_inner_network_header(skb, nhoff);
> >       }
> >
> > -     iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
> > +     payload_len = skb->len - nhoff - sizeof(*iph);
> > +     if (unlikely(payload_len > IPV6_MAXPLEN)) {
> > +             struct hop_jumbo_hdr *hop_jumbo;
> > +             int hoplen = sizeof(*hop_jumbo);
> > +
> > +             /* Move network header left */
> > +             memmove(skb_mac_header(skb) - hoplen, skb_mac_header(skb),
> > +                     skb->transport_header - skb->mac_header);
>
> I was wondering if we should check for enough headroom and what about
> TCP over UDP tunnel, then I read the next patch ;)

The check about headroom is provided in the following patch (ipv6: add
GRO_IPV6_MAX_SIZE),
which allows GRO stack to build packets bigger than 64KB,
if drivers provided enough headroom (8 bytes).
They usually provide NET_SKB_PAD (64 bytes or more)

Before the next patch, this code is dead.

Also current patch set does not cook BIG TCP packets for tunneled traffic
(look at skb_gro_receive() changes in following patch)


>
> I think a comment here referring to the constraint enforced by
> skb_gro_receive() could help, or perhaps squashing the 2 patches?!?

Well no, we spent time making small patches to ease review, and these patches
have different authors anyway.

>
> Thanks!
>
> Paolo
>
