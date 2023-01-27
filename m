Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B209F67DE5A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjA0HPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjA0HPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:15:48 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527FE3A868
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:15:46 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id d30so6756501lfv.8
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lzMXxBzaqznr1iMAiOVyXfP+DLxctfJ5Ed0jNarhFCU=;
        b=UfuzXwhvAZ5Vxzs/Dpwm47dbTHDDKSfO9HcCY4LcG9++7c7V5MZPVP4XXs06h+FYvw
         5m89PtB4pYtq3iOF/NxGHsNWmH6tYAou+fuXb34lUUwRTct+ahEK1aLfpyZkaaVeTB/x
         yaNHZKyiWqoOJWoq6q4AXUjFI8VFlIxI+3owGarVuGwUaWQYRVcnj++vCrGAX3mNk3te
         Gh1gA9UVUlbucI6BzEVnc3cL4QDE5X3N7bAVotwNn/6Agt+PAvOHP+lhRs6I8rJFzzt1
         rhzEVDeL39b7ZKBHJzx1BRLDr+hT1QrO9s/5c1rSLOto2lCMnH54GBJepcelJ4+FDBHF
         2NaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lzMXxBzaqznr1iMAiOVyXfP+DLxctfJ5Ed0jNarhFCU=;
        b=P9CNpgYr7Ser864V1WB793+zN4abD1aFVBhguYLsrzVWcpHni1Igd/BwBO+zvLQ2m9
         jAIh+Og/8IRUrBa/81EuekpyachOhGQYI5LDnx2GufJbNs1sh/Be3T3s3XBNijfqEEFA
         mOIWL2o4GmEHYGmPQ3ZIdz7ryFR4SebrtdNV6kEXiIrlH1436cwEwUxIVDYgj6q5JNKQ
         Jwc1St0b6VC66/uQn0WOWB4klHFDzZ3sfWErRrgL6Tao2LmnxgBCvuHp83VfqMQfNCdn
         eHmWja+F7gzvko6zbdYY2LAWhThYsxxpMAPSsD6Bg6UjSM57qrjxCs9YED40vYXOeqp2
         x0uQ==
X-Gm-Message-State: AFqh2kr1TWpEisurQqnrzwJRZo886LB7JWpFQq1yqbUuq/q9ud7rpTyn
        40xQhXjScfrLavkYS/N53Hm2oZSdAx3P1kRHdlcnNw==
X-Google-Smtp-Source: AMrXdXsuKvg45IooFOPXenej4+MSeOh2TOQluPgy+XTKCH2B4MPcaWOHd6S9NQ38hdryd1H8ABTeDswW8NBicC7esSU=
X-Received: by 2002:a19:f602:0:b0:4ca:f757:6c91 with SMTP id
 x2-20020a19f602000000b004caf7576c91mr1901716lfe.92.1674803744683; Thu, 26 Jan
 2023 23:15:44 -0800 (PST)
MIME-Version: 1.0
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain> <20230126151317.73d67045@kernel.org>
In-Reply-To: <20230126151317.73d67045@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 27 Jan 2023 09:15:08 +0200
Message-ID: <CAC_iWjL00vkiW1FJOEL1xchE3DiioirbAzgi8S1GSV0M1c=egQ@mail.gmail.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, nbd@nbd.name,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        lorenzo@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Alexander!

On Fri, 27 Jan 2023 at 01:13, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 26 Jan 2023 11:06:59 -0800 Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > GSO should not merge page pool recycled frames with standard reference
> > counted frames. Traditionally this didn't occur, at least not often.
> > However as we start looking at adding support for wireless adapters there
> > becomes the potential to mix the two due to A-MSDU repartitioning frames in
> > the receive path. There are possibly other places where this may have
> > occurred however I suspect they must be few and far between as we have not
> > seen this issue until now.
> >
> > Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> > Reported-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
>
> Exciting investigation!
> Felix, out of curiosity - the impact of loosing GRO on performance is
> not significant enough to care?  We could possibly try to switch to
> using the frag list if we can't merge into frags safely.
>
> > diff --git a/net/core/gro.c b/net/core/gro.c
> > index 506f83d715f8..4bac7ea6e025 100644
> > --- a/net/core/gro.c
> > +++ b/net/core/gro.c
> > @@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> >       struct sk_buff *lp;
> >       int segs;
> >
> > +     /* Do not splice page pool based packets w/ non-page pool
> > +      * packets. This can result in reference count issues as page
> > +      * pool pages will not decrement the reference count and will
> > +      * instead be immediately returned to the pool or have frag
> > +      * count decremented.
> > +      */
> > +     if (p->pp_recycle != skb->pp_recycle)
> > +             return -ETOOMANYREFS;
> >
> >       /* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
> >       gro_max_size = READ_ONCE(p->dev->gro_max_size);
> >
> >
> >
>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
