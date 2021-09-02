Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B9D3FF58B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbhIBVSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245379AbhIBVSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:18:12 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B379C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 14:17:13 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a25so7544831ejv.6
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 14:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bHUd3W9mfhuvKsKVkBJRuBBshvAOjt/+w796pAZ6mQ4=;
        b=f/dz9NziCmLnRZEMOviuZDwknj3K3WhM9TBUxhi08mYLDGFMClDi0iASMACANXl7UC
         qXLoxQAmDxDjbyybvgs5Hg0yc1wqrG3uqsiAwxOwPiYUc++a9YLz+3HRVs0BTg6XGPkv
         xOgSUrVxaXP+b5anhYd096bOm2H8wCWgna7BCWausotDTKy8yAY4MlCM7LffCVcze4/b
         zs2LS80gXl8Mbmlc5xYz0988w72iWAo1p8YqDcH2JifuJ8jyIxP23WZ5WFgpam9GBDES
         AN7vhsL7O8iEtGr6WzI6HNAhVakQQGCXkPxICf3s1CfGjeYBSLhrRfU80c41LaqxnUNJ
         vymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHUd3W9mfhuvKsKVkBJRuBBshvAOjt/+w796pAZ6mQ4=;
        b=Or9OXUcf00tuPwBt5bXzmzP+SX4yehXcGVjhr9ED9AKWAwomykO4Bfa615k5vtFCV0
         A8bUoibxNmlz/RRIjdXd4JzTamuMdqLAr8SHHZyoeaT0ph9byywRlKVTopA3W7SNbewo
         96IIPdq7r37X4cVNFvgIbl+bj9O2oc30sbmYMxkKfbH5eKsZORnAM3V2m9WuCy7Lc4Zo
         43GPy/8sOkwpiUmhq+QtnB6VWn69tozKo9sRbxmrBoH3nrhU5cBZQ5p7/K6hKoAdoGO+
         MrQpuQNIJdkBSEn8s1mY8f0fl92iZyskcCTaWwTfk7yYgo/5HgJ04eBzElJ/xJ0MYBvv
         1IuA==
X-Gm-Message-State: AOAM530wsTEgfSQ5CYonnq3HrfokLgRHAoJmP0/uDyTYAD30ZYnAZsBx
        GzWhIEkyq6WZLQ4AQiwQbbm8I/u8SRz5wDRJm2kZhomi
X-Google-Smtp-Source: ABdhPJxI4cLvfrTqu3YxljSt++sNKu1xrFLCE2IgBozbLbnytu39usmW82iDdmBKwMPZVNPTJdVNhZLiEALcdKAO+tU=
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr191018ejb.139.1630617431565;
 Thu, 02 Sep 2021 14:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
In-Reply-To: <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 2 Sep 2021 14:17:00 -0700
Message-ID: <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 1:30 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Sep 2, 2021 at 4:25 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, Sep 2, 2021 at 12:38 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > Only test integrity of csum_start if checksum offload is configured.
> > >
> > > With checksum offload and GRE tunnel checksum, gre_build_header will
> > > cheaply build the GRE checksum using local checksum offload. This
> > > depends on inner packet csum offload, and thus that csum_start points
> > > behind GRE. But validate this condition only with checksum offload.
> > >
> > > Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> > > Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > ---
> > >  net/ipv4/ip_gre.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > > index 177d26d8fb9c..09311992a617 100644
> > > --- a/net/ipv4/ip_gre.c
> > > +++ b/net/ipv4/ip_gre.c
> > > @@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
> > >
> > >  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
> > >  {
> > > -       if (csum && skb_checksum_start(skb) < skb->data)
> > > +       /* Local checksum offload requires csum offload of the inner packet */
> > > +       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> > > +           skb_checksum_start(skb) < skb->data)
> > >                 return -EINVAL;
> > > +
> > >         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
> > >  }
>
> Thanks for taking a look.
>
> > So a few minor nits.
> >
> > First I think we need this for both v4 and v6 since it looks like this
> > code is reproduced for net/ipv6/ip6_gre.c.
>
> I sent a separate patch for v6. Perhaps should have made it a series
> to make this more clear.

Yeah, that was part of the reason I assumed the ipv6 patch was overlooked.

> > Second I don't know if we even need to bother including the "csum"
> > portion of the lookup since that technically is just telling us if the
> > GRE tunnel is requesting a checksum or not and I am not sure that
> > applies to the fact that the inner L4 header is going to be what is
> > requesting the checksum offload most likely.
>
> This test introduced in the original patch specifically protects the
> GRE tunnel checksum calculation using lco_csum. The regular inner
> packet path likely is already robust (as similar bug reports would be
> more likely for that more common case).

I was just thinking in terms of shaving off some extra comparisons. I
suppose it depends on if this is being inlined or not. If it is being
inlined there are at least 2 cases where the if statement would be
dropped since csum is explicitly false. My thought was that by just
jumping straight to the skb->ip_summed check we can drop the lookup
for csum since it would be implied by the fact that skb->ip_summed is
being checked. It would create a broader check, but at the same time
it would reduce the number of comparisons in the call.

> > Also maybe this should be triggering a WARN_ON_ONCE if we hit this as
> > the path triggering this should be fixed rather than us silently
> > dropping frames. We should be figuring out what cases are resulting in
> > us getting CHECKSUM_PARTIAL without skb_checksum_start being set.
>
> We already know that bad packets can enter the kernel and trigger
> this, using packet sockets and virtio_net_hdr. Unfortunately, this
> *is* the fix.

It sounds almost like we need a CHECKSUM_DODGY to go along with the
SKB_GSO_DODGY in order to resolve these kinds of issues.

So essentially we have a source that we know can give us bad packets.
We really should be performing some sort of validation on these much
earlier in order to clean them up so that we don't have to add this
sort of exception handling code all over the Tx path.
