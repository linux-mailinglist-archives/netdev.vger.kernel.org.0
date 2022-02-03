Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40D14A8C54
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353726AbiBCTRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344163AbiBCTRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:17:36 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E9FC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:17:36 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id p5so11854916ybd.13
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=px9jALMoc37tL16p1clmPIeD0iTztl/oz3EzlwB9ju8=;
        b=Q6ua6rquWlWKw2tUPeGKwHpxdrGMQ1WLiQTCiPg/yUc6Xuueiz8faWAIPk3PbFoBta
         BgBDy0MiDgXBGcrc0lmhZicAlpHkwEHWp1ZeAsicnBxOzzH6Bj0M5BLJVJZHZgMpm2dH
         wO4evg7Ht/8Zg++jtPVTqXtMrraYSYzY0EMY/YCTmMkZsk2I3KpjwYCVuiXZDpM50IXH
         pzUA8WyRCB4tzmZR09Lm6kyfOzxwmD7yXyZUzObaEQwHIlYl7YUqw+v1qka/FLcNGeBT
         yhFotdBSPvSoZ+dkSXaSz5RhJqxdtZSSeVsr3ToKOUghf62yTJTt0Fz4bacIFn4yxIcw
         i/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=px9jALMoc37tL16p1clmPIeD0iTztl/oz3EzlwB9ju8=;
        b=XBb3xd1XauwLNrbH6RDFFPyENHTQspB8fq5ewxx2gYPtqrA+mk7tj87qAQlcRM9le9
         ou0qJvJnkxSkk5oZCwQFGJftqUP4kLR8os7wC4z1fIff5MAxlIov3c7tO4j1Nb6eVR3y
         bSAUeeHv2DqLOv0LnrOAbKXxc1neUu5HybEEhlB9/SV+A2AB8AUenbWpJMVB4yLW34dd
         N1bXy7w++Jz2ZGI2ZM6G5DYPCXkRvDVOAjRDB5Wld4hhCXqHTsLumHmOP5/9jKncgNEo
         jXocqsO6vfe28PIKofb/55P3FCWkpKO0QrgzeQ6s1hbZJMtyqi7UlwYww4eCL7X8eS0I
         JQ7w==
X-Gm-Message-State: AOAM531nqLtHUh3qZvC3Ctn6h8yv/W60AzSwWac8X7vMdFqz1LJ9OzAY
        mKG3GWuFI12MD4QePmlR0CPqeVHAtwiC004lq5dpWA==
X-Google-Smtp-Source: ABdhPJwvlDpcPuiBvyh7swWP8S9NYaHRbb5gU5Zv7iMwJVgzU3U9sHfZ6/eQXAnCJaROefHdjnl0lhsc5pDCjpRTJUM=
X-Received: by 2002:a25:3444:: with SMTP id b65mr38503011yba.5.1643915855455;
 Thu, 03 Feb 2022 11:17:35 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
In-Reply-To: <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 11:17:24 -0800
Message-ID: <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 10:53 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
>
> Rather than having to perform all of these checkes would it maybe make
> sense to add SKB_GSO_JUMBOGRAM as a gso_type flag? Then it would make
> it easier for drivers to indicate if they support the new offload or
> not.

Yes, this could be an option.

>
> An added bonus is that it would probably make it easier to do something
> like a GSO_PARTIAL for this since then it would just be a matter of
> flagging it, stripping the extra hop-by-hop header, and chopping it
> into gso_max_size chunks.
>
> > +}
> > +
> >  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
> >  {
> >       /* If forwarding is enabled, RA are not accepted unless the special
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 0118f0afaa4fce8da167ddf39de4c9f3880ca05b..53f17c7392311e7123628fcab4617efc169905a1 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3959,8 +3959,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> >       skb_frag_t *frag = skb_shinfo(head_skb)->frags;
> >       unsigned int mss = skb_shinfo(head_skb)->gso_size;
> >       unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
> > +     int hophdr_len = sizeof(struct hop_jumbo_hdr);
> >       struct sk_buff *frag_skb = head_skb;
> > -     unsigned int offset = doffset;
> > +     unsigned int offset;
> >       unsigned int tnl_hlen = skb_tnl_header_len(head_skb);
> >       unsigned int partial_segs = 0;
> >       unsigned int headroom;
> > @@ -3968,6 +3969,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> >       __be16 proto;
> >       bool csum, sg;
> >       int nfrags = skb_shinfo(head_skb)->nr_frags;
> > +     struct ipv6hdr *h6;
> >       int err = -ENOMEM;
> >       int i = 0;
> >       int pos;
> > @@ -3992,6 +3994,23 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> >       }
> >
> >       __skb_push(head_skb, doffset);
> > +
> > +     if (ipv6_has_hopopt_jumbo(head_skb)) {
> > +             /* remove the HBH header.
> > +              * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> > +              */
> > +             memmove(head_skb->data + hophdr_len,
> > +                     head_skb->data,
> > +                     ETH_HLEN + sizeof(struct ipv6hdr));
> > +             head_skb->data += hophdr_len;
> > +             head_skb->len -= hophdr_len;
> > +             head_skb->network_header += hophdr_len;
> > +             head_skb->mac_header += hophdr_len;
> > +             doffset -= hophdr_len;
> > +             h6 = (struct ipv6hdr *)(head_skb->data + ETH_HLEN);
> > +             h6->nexthdr = IPPROTO_TCP;
> > +     }
>
> Does it really make the most sense to be doing this here, or should
> this be a part of the IPv6 processing? It seems like of asymmetric when
> compared with the change in the next patch to add the header in GRO.
>

Not sure what you mean. We do have to strip the header here, I do not
see where else to make this ?

> > +     offset = doffset;
> >       proto = skb_network_protocol(head_skb, NULL);
> >       if (unlikely(!proto))
> >               return ERR_PTR(-EINVAL);
>
>
