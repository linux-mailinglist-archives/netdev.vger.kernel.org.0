Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CFB2BAAE5
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKTNQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgKTNQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:16:06 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640D5C0613CF;
        Fri, 20 Nov 2020 05:16:04 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id o25so10376905oie.5;
        Fri, 20 Nov 2020 05:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lThzCHoktjdU4sEbsjVX5ynavCnSH8JYInFV4OwVryI=;
        b=g5ito57gAaYibGZ8OWYILuSdyeDxSWRyheXD/l8np6x+jAz5zHBI/Oh83GLJGmdgTM
         BbEdQO1oTp9sVjREU6Bj/FUiXk8Ch9EHJ7dMLoHM7N1TQ6hc/NG27aXNZ/II/LnwCeGZ
         6Z8J47AjlAUgfokCcZ8ghc+rzfB9X4vohHM/EfC9NLkOADXk7ex6naFTTHd0mYVz/5a+
         xicqXl5AmpSLzduYV8uzAumyqRyCIIA5K3G9irmZf4epPjfD1fHHna+HY7B2cqsckdPu
         8wcQeUSE9tBDiwG32BMF1p/hQ9fSBPv0nnnLzxrNGOaszYM/vx/GvofEIvGxhE0ipX4z
         XLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lThzCHoktjdU4sEbsjVX5ynavCnSH8JYInFV4OwVryI=;
        b=BGb96GBs2y7UxfFmTSIWBg4Mm65Fdv4EYfYFjZ6Sn2M1XUvsES3Y+quMUzYqRiGN/x
         TA6lK/6Rg8uz9x2B1wMoTuBe1ohZRx5Gjnquwgbb4L82oi6JheIZkBWk/WiLJbkRC0a1
         aha5b9iGtCKd5rTd7WsGUC78xID4O4bRr/ob71jdI0XZ9lPloNifgjTEUbr9/dkM2hpT
         Di6bqkjCNZzsHO+fP3/5zE38POgtcS26sgLd7tHR/XVt+G0olcWfNDcWiplPKH0Tw9eb
         fopuM1iKQh6UW4ncLc2MA0e/XK1D6Pdrimxy7tLU1eR5+MVxME7p1wesaMO8VvN6RUz4
         rFAQ==
X-Gm-Message-State: AOAM531wLTEdV/J2XgNJES4kRmClxFlPQVoLCGTzOaNrcoQJrawoskd4
        P5xCMG6TbVaPZkkEATl5xHQCBEKxsR5bSsrMaOY=
X-Google-Smtp-Source: ABdhPJwJsWF/kJEwpn6yOv+a+vHVOMI7w4SAZEMCfWZ06QnBcyCegkJNwvfiJXjLWXtTQhSRWeDGqcQeHkyKEiKUdbg=
X-Received: by 2002:a05:6808:494:: with SMTP id z20mr5999490oid.10.1605878163678;
 Fri, 20 Nov 2020 05:16:03 -0800 (PST)
MIME-Version: 1.0
References: <160571331409.2801246.11527010115263068327.stgit@firesoul>
 <160571337537.2801246.15228178384451037535.stgit@firesoul> <20201120092638.14e09025@carbon>
In-Reply-To: <20201120092638.14e09025@carbon>
From:   Carlo Carraro <colrack@gmail.com>
Date:   Fri, 20 Nov 2020 14:15:52 +0100
Message-ID: <CAMdLmZmfr=fe+g+LGpgjRcsw_VfL5rmO3dSeo=WAouczse5BZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V6 2/7] bpf: fix bpf_fib_lookup helper MTU check
 for SKB ctx
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

I report here the issue with the previous patch.
The code is now checking against params->tot_len but then it is still
using is_skb_forwardable.
Consider this case where I shrink the packet:
skb->len == 1520
dev->mtu == 1500
params->tot_len == 1480
So the incoming pkt has len 1520, and the out interface has mtu 1500.
In this case fragmentation is not needed because params->tot_len < dev->mtu.
However the code calls is_skb_forwardable and may return false because
skb->len > dev->mtu, resulting in BPF_FIB_LKUP_RET_FRAG_NEEDED.
What I propose is using params->tot_len only if provided, without
falling back to use is_skb_forwardable when provided.
Something like this:

if (params->tot_len > 0) {
  if (params->tot_len > mtu)
    rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
} else if (!is_skb_forwardable(dev, skb)) {
  rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
}

However, doing so we are skipping more relaxed MTU checks inside
is_skb_forwardable, so I'm not sure about this.
Please comment

Il giorno ven 20 nov 2020 alle ore 09:26 Jesper Dangaard Brouer
<brouer@redhat.com> ha scritto:
>
> On Wed, 18 Nov 2020 16:29:35 +0100
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> > BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
> > bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
> > by adjusting fib_params 'tot_len' with the packet length plus the
> > expected encap size. (Just like the bpf_check_mtu helper supports). He
> > discovered that for SKB ctx the param->tot_len was not used, instead
> > skb->len was used (via MTU check in is_skb_forwardable()).
> >
> > Fix this by using fib_params 'tot_len' for MTU check.  If not provided
> > (e.g. zero) then keep existing behaviour intact.
>
> Carlo pointed out (in slack) that the logic is not correctly
> implemented in this patch.
>
> I will send a V7.
>
>
> > Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
> > Reported-by: Carlo Carraro <colrack@gmail.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  net/core/filter.c |   12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 1ee97fdeea64..ae1fe8e6069a 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5567,10 +5567,20 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
> >
> >       if (!rc) {
> >               struct net_device *dev;
> > +             u32 mtu;
> >
> >               dev = dev_get_by_index_rcu(net, params->ifindex);
> > -             if (!is_skb_forwardable(dev, skb))
> > +             mtu = dev->mtu;
> > +
> > +             /* Using tot_len for L3 MTU check if provided by user. Notice at
> > +              * this TC cls_bpf level skb->len contains L2 size, but
> > +              * is_skb_forwardable takes that into account.
> > +              */
> > +             if (params->tot_len > mtu) {
> >                       rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> > +             } else if (!is_skb_forwardable(dev, skb)) {
> > +                     rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> > +             }
> >       }
> >
> >       return rc;
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
