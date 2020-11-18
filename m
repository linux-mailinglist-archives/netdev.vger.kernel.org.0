Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C2A2B8573
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKRUVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKRUVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:21:19 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD0DC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:21:19 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id n129so3458917iod.5
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hRoLxTeUD+o4bj2RdqrtLw9e90PHLdDCUZ4TPCzLN58=;
        b=Zy0Lc1mf9e6GBb4vI7VwOhpdWd6oIjoy9SSAPccdEmXtoXE9HDLV2eJl/Qlj5KnFeh
         oss/SmEhVbwRxhtzjSb+qaWC6cdP5xECAGlvHP6ghKrrjXgDD8UexfVpKkAKOrCHRLyr
         P0wFde1MUA8sebPvE8259NiYetLPGCizJ4csWbyqTkgZ60H3wISR7d08mH1GY9Wf7RyK
         cMVvaAVLVO/6FHMLj2EE1bpxoDVRtjlmWrDFz0z+wc/cLZG0JFN4HdPoIbp5gcBFtSzB
         AK24gzyRZ2mJUFevEKyeETANzXxSk2mIjMakzhsLcorY+agpKhw64ZM4+u2+Mt3YLMqH
         gflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRoLxTeUD+o4bj2RdqrtLw9e90PHLdDCUZ4TPCzLN58=;
        b=kB+X/ruzS48t17RU07I4qzDk0uYJcbNGJ4c52pUn+lAYMn2CKIH+2Q+aslxNp8ISTv
         +YOL0Z1BYbDeOBak+mABT98TfLff6goUO1gLWeqs24AuFxfzcf+H39DcNN3+qZRJqvyp
         Za8G98scWKX8WUopYdR1WkZc88f+1IuQfqopsaAk9+aVzSSG6t5/2YvvSDUzvJP6JWWZ
         qKTLVQxWcnJCAoxr6CLKKB66dSxXlPdLUC0Vl/BACcIMhp25cYVljuaGjeAwAHTU0Pmv
         bAvOzNEoX5Q7NebW9O1P1tiiUBSuh4QwBjEVHcAE4L1Wk1O79IrFvVbKnjG+uMHiJcmO
         lqpQ==
X-Gm-Message-State: AOAM530NEMjldI1vVxc8CybCL8JdWTiXqsD4MJyHNTXSxDxobne+aQ0o
        XLgAyhM+UzFGTfFdD6+cF+h/WY0OGZCYhk+dsIV0Yw==
X-Google-Smtp-Source: ABdhPJxafRBWz9GLb5l3sD56AyroBnLPEVAsSjdtJIq0uDsulS9AqE73ZX5q1AAtzGPd3pgImLQXb9kwDSNp27dhglA=
X-Received: by 2002:a02:6948:: with SMTP id e69mr10374795jac.6.1605730878141;
 Wed, 18 Nov 2020 12:21:18 -0800 (PST)
MIME-Version: 1.0
References: <20201117203355.389661-1-saeedm@nvidia.com> <20201117203355.389661-2-saeedm@nvidia.com>
 <20201118112207.2b8bea44@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CANn89iJ=430ri_x_NbfnV2jrP3S0nWK+VUWf0WgrCVBz2oLNfA@mail.gmail.com> <20201118121422.512ced1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118121422.512ced1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 18 Nov 2020 21:21:06 +0100
Message-ID: <CANn89iL2p33Z4LDUOb-6YOw+AiNiOhNWOjAu1+_N8_3aKDCFVQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: Call skb destructor on NAPI_GRO_FREE_STOLEN_HEAD
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 9:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 18 Nov 2020 21:02:29 +0100 Eric Dumazet wrote:
> > On Wed, Nov 18, 2020 at 8:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 17 Nov 2020 12:33:55 -0800 Saeed Mahameed wrote:
> > > > From: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > >
> > > > All GRO flows except one call skb->destructor, however, GRO_MERGED_FREE
> > > > doesn't do it in case of NAPI_GRO_FREE_STOLEN_HEAD. For better
> > > > consistency and to add resiliency against the drivers that may pass SKBs
> > > > with a destructor, this patch changes napi_skb_free_stolen_head to use
> > > > skb_release_head_state, which should perform all the needed cleanups,
> > > > including a call to the destructor. This way the code of GRO_MERGED_FREE
> > > > becomes similar to kfree_skb_partial.
> > > >
> > > > Fixes: e44699d2c280 ("net: handle NAPI_GRO_FREE_STOLEN_HEAD case also in napi_frags_finish()")
> > > > Fixes: d7e8883cfcf4 ("net: make GRO aware of skb->head_frag")
> > > > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > >
> > > CC Eric for GRO expertise.
> >
> > Thanks for CCing me.
> >
> > Since when drivers can pass funny skbs with destructors ???
> >
> > Can we please stop adding more cycles to _already_ expensive GRO ?
>
> I don't think they do that today much (save for the ktls optimization
> in mlx5 Maxim is fixing separately). But I believe the idea of early
> demux in XDP had been floated in the past.
>
> If we don't want that to happen we should document it (stating the
> obvious).

This is a patch targeting the net tree, with Fixes: tag pretending
this is an old bug.

How can we possibly merge two skbs if they have destructors ?

We do not make sure it is even possible.

Many destructors track skb->truesize against a socket wmem_alloc or rmem_alloc,
this stuff can not possibly work, unless stronger checks in GRO, since
GRO changes skb->truesize
without checking skb->destructor.

If skb has a destructor, just bypass GRO completely, this is the only
thing we can do.
This would be quite unfortunate to add such a check "just because
someone tries to fool us"

diff --git a/net/core/dev.c b/net/core/dev.c
index 4bfdcd6b20e8836e2884c51c6ce349ed54130bfa..76f0a627b6a1ee02339a724ecb6e4dbade80501b
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5920,7 +5920,7 @@ static enum gro_result dev_gro_receive(struct
napi_struct *napi, struct sk_buff
        int same_flow;
        int grow;

-       if (netif_elide_gro(skb->dev))
+       if (netif_elide_gro(skb->dev) || skb->destructor)
                goto normal;

        gro_head = gro_list_prepare(napi, skb);
