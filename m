Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41F546DB35
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhLHSkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbhLHSkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:40:13 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAB6C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 10:36:40 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u17so5675995wrt.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 10:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0+rXB86aFkwl9Mj9Z68XUBOs2BykcOpI2LL6j3CD7iM=;
        b=WFp03K/NCpULOhPTEam133kUVHO38hQwzuotITVTEXdAfkywLDueeHJ33QJwPlsF8G
         9O8Q8aBvsiM+j4Om9nqkm25wUua3PI01sBjg+emYYDj1kp59P8BNn9JpZZ2B23gHQ1tI
         zbLUd1enhRcn9e/UIXqMgVL0zSIK8iBFaB1YjC1l9jPVPfJlcqSf0yKa0+RK4rrW7kKz
         Nzc1lMiPvrkKOVmZ79ACK92HpQ++AIoGi0zqtq2u9BWoB/yVGIIXQVwElCF3HD9Nvpkg
         m/FvBhvRdDUHvJHMcS2PzCJBgVjDzBuEcH5lvr18RmmAA3lx3q71OQjw2zkV4FF+un7b
         oblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0+rXB86aFkwl9Mj9Z68XUBOs2BykcOpI2LL6j3CD7iM=;
        b=TIv/RgmfYqY7E4pLschZFfYtYLY7CqJ/lBf1OPxW1ED58sF8koWGvXRFHOqTRdXhMj
         bcIT+n0lfRcV7m9GorRRiFBQKzquyJbr2HVuuVO2PEOWnzL1QFs22/VCYQuOpBlOeLDu
         3XkbRUsmz/08uNF/8zS/qnbB+yanfXF7nx6vgPDOeQFN6Xrll/sBa6OcNQr71nnbJ4LW
         M04CXrn6jwALa7MLe1FwR8HPnnLiRzMstE68KyhEcBk9Pjm9me3YoTqeU26P+hbtRFvG
         1kvcJwFsgV6A0fdUS3Ovt6gzbXPfnbJP96UuTTSdYIx6tKr5VcUKr81J39iktYdpXJ7b
         HeeQ==
X-Gm-Message-State: AOAM533VXdvAbQO7EdK8hYBHm1de0w2ZCrtrDH8en7YMaPeY7o96vUQZ
        +fdwPtMVkBmyN2zt29cGnBojqe+KRHHuDQ8a0B6i5JwaxQC/WQ==
X-Google-Smtp-Source: ABdhPJym1j8HgqGJbjQK/MLMnN4vJ5DNAlOrjB0ujE4Wo4gpk+hNpiMOdYqTKRxsF7x/SIpnjyrXp3X8IyZ63JxjQ80=
X-Received: by 2002:adf:9b95:: with SMTP id d21mr440650wrc.527.1638988599045;
 Wed, 08 Dec 2021 10:36:39 -0800 (PST)
MIME-Version: 1.0
References: <20211206165329.1049835-1-eric.dumazet@gmail.com> <ded3d280-efcd-810e-c29c-7296f97cb181@gmail.com>
In-Reply-To: <ded3d280-efcd-810e-c29c-7296f97cb181@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Dec 2021 10:36:25 -0800
Message-ID: <CANn89iLcHVUW1jHjWesL+Esi-tE3OJNEv5h=riuZq3jA1n+jhw@mail.gmail.com>
Subject: Re: [PATCH net] net, neigh: clear whole pneigh_entry at alloc time
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 7:54 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/6/21 9:53 AM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Commit 2c611ad97a82 ("net, neigh: Extend neigh->flags to 32 bit
> > to allow for extensions") enables a new KMSAM warning [1]
> >
> > I think the bug is actually older, because the following intruction
> > only occurred if ndm->ndm_flags had NTF_PROXY set.
> >
> >       pn->flags = ndm->ndm_flags;
> >
> > Let's clear all pneigh_entry fields at alloc time.
> >
>
> All of the fields - except the new flags field - are initialized after
> the alloc. Why do you think the bug is older?

Because the flags field was added earlier, in the commit I pointed in Fixes: tag

For some reason, syzbot found the issue only after Roopa patch went in.
But we need to backport to older versions I think, or risk a kernel-info-leak

>
> ...
>
> > Fixes: 62dd93181aaa ("[IPV6] NDISC: Set per-entry is_router flag in Proxy NA.")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Roopa Prabhu <roopa@nvidia.com>
> > ---
> >  net/core/neighbour.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 72ba027c34cfea6f38a9e78927c35048ebfe7a7f..dda12fbd177ba6ad2798ea2b07733fa3f03441ab 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -763,11 +763,10 @@ struct pneigh_entry * pneigh_lookup(struct neigh_table *tbl,
> >
> >       ASSERT_RTNL();
> >
> > -     n = kmalloc(sizeof(*n) + key_len, GFP_KERNEL);
> > +     n = kzalloc(sizeof(*n) + key_len, GFP_KERNEL);
> >       if (!n)
> >               goto out;
> >
> > -     n->protocol = 0;
> >       write_pnet(&n->net, net);
> >       memcpy(n->key, pkey, key_len);
> >       n->dev = dev;
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
