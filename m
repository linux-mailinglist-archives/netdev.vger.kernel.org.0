Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA7D3C3BD6
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 13:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhGKL3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 07:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbhGKL3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 07:29:15 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD26C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 04:26:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id he13so27248435ejc.11
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 04:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qoVu0W7XXI8a1fHKwalOQACiP8NsTY1mMeTjXyzhW88=;
        b=HRDpkCBfNsTaL8XNKDq0lwigrpKFEnAkoYmQLH5B3lLQ2WSMwq7Qquuvq/8vDmXfNu
         O8b9bTMDcGnv05m8VRIlWC1d9zeG+YYDvYiY6qrQf1PXZwUVjMgzTeMIU59sX/JpleCY
         shwjpYhckfcb50RnT7jS4BiTyRcmbaohfpcss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qoVu0W7XXI8a1fHKwalOQACiP8NsTY1mMeTjXyzhW88=;
        b=FkBm4pfonRVrX/olyoDRZTTxol94bUHruwlKOcLDfZuuWU6Fn7sW2voOXuQyyDZ4pc
         dtBtJdm/GlPqviouprUsjOl3ZWU24hFOPUVnMLsQdPP0rKKjdqaZE6jI+vruPlGJJBem
         BJ9r1hpSxZpvWAshjbew6oUZVUDJZpjGk/LxOTAF3AM31nGf/BwRB3ksNlmbZq3/xf64
         ZNckLncwN0fm/5w2B7pAQOQRfLv9SRnTtkLOt+pa6kLQrVdi0WLl/Gij64tqNdk1p12j
         2XFLxYeCMqXQbf1WVJ27ct6SyfEcDAIUnr6gpSq/fNgZ0dRi63wjxNS2hKimjJcVnOh8
         lP2g==
X-Gm-Message-State: AOAM531K3JgdsjV7rW6+QZqtUjXGUCSBTJZhEpka88lqDAXn4ZZLQ0pq
        x8sNGV6G55BimxLrQ6p+yL+6/i4YfdwPQ8ZzU/ehqw==
X-Google-Smtp-Source: ABdhPJyTc6nA6CT2fr2il/bKY8PyVpbWqQCeLS7ZMcsfMyWy2WSBWLVZKaErLlIlffv98FTqHEumVJCWNyWAeFZ/VoM=
X-Received: by 2002:a17:906:4c90:: with SMTP id q16mr46899157eju.149.1626002786853;
 Sun, 11 Jul 2021 04:26:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210711111546.3695-1-alexander.mikhalitsyn@virtuozzo.com> <54821a00-0dd1-da72-0445-63af284eb8b3@nvidia.com>
In-Reply-To: <54821a00-0dd1-da72-0445-63af284eb8b3@nvidia.com>
From:   Alexander Mihalicyn <alexander@mihalicyn.com>
Date:   Sun, 11 Jul 2021 14:26:16 +0300
Message-ID: <CAJqdLrqVr5hay7vDgDkQhw0PUkqzYysEvOvLPvd=7BH=ygC0sg@mail.gmail.com>
Subject: Re: [PATCH iproute2] libnetlink: check error handler is present
 before a call
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 2:18 PM Roi Dayan <roid@nvidia.com> wrote:
>
>
>
> On 2021-07-11 2:15 PM, Alexander Mikhalitsyn wrote:
> > Fix nullptr dereference of errhndlr from rtnl_dump_filter_arg
> > struct in rtnl_dump_done and rtnl_dump_error functions.
> >
> > Fixes: 459ce6e3d792 ("ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped")
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: Roi Dayan <roid@nvidia.com>
> > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > Reported-by: Roi Dayan <roid@nvidia.com>
> > Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> > ---
> >   lib/libnetlink.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> > index e9b8c3bd..d068dbe2 100644
> > --- a/lib/libnetlink.c
> > +++ b/lib/libnetlink.c
> > @@ -686,7 +686,7 @@ static int rtnl_dump_done(struct nlmsghdr *h,
> >       if (len < 0) {
> >               errno = -len;
> >
> > -             if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_DONE_NLERR)
> > +             if (a->errhndlr && (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_DONE_NLERR))
> >                       return 0;
> >
> >               /* check for any messages returned from kernel */
> > @@ -729,7 +729,7 @@ static int rtnl_dump_error(const struct rtnl_handle *rth,
> >                    errno == EOPNOTSUPP))
> >                       return -1;
> >
> > -             if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_ERROR_NLERR)
> > +             if (a->errhndlr && (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_ERROR_NLERR))
> >                       return 0;
> >
> >               if (!(rth->flags & RTNL_HANDLE_F_SUPPRESS_NLERR))
> >
>
> that was quick. was about to send the exact same patch :)
> so tested as well. thanks!

hah ;)

Thanks for reporting and sorry that I've introduced the issue that
affected you.

>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
>

Thanks,
Alex
