Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF05E2D982E
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 13:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439250AbgLNMmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 07:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407536AbgLNMmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 07:42:00 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A71C0613D6;
        Mon, 14 Dec 2020 04:41:20 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id w124so15820785oia.6;
        Mon, 14 Dec 2020 04:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m2RkTas+mrztpo0nvrh9n3aa0mWUkynQJjOL8sthHrw=;
        b=GLSYa2r5q6IYpYf8oKScxiLuKWd75f/k4L5vu/XDxaGawTjPdkA2Yoa2ciNTk+v0C/
         rEXLrDfHDcxp4P3IbinvSAiUjkcC8D2MKuoLHIpY/9tQRL47s6GiWPd4EC4eGdCnY8zT
         ZK+bw4/qmmeF4h4feNyloz5qTPkJKeu2tGGGH3OJ0fb6YmsDN7a/KmOCsWrrpSkFXYYA
         1KJZgj26gYTM2VQfS7gM/gNzXQgwhJ69LnQwuMAYcpySwBBRdr0INVgNnHHSjzshOGQd
         1fj3pOhuD+IXKbyKuOTSap6mfzclXuNyXm/VeBatwlxQxMgcij8Krn6v6AgvZWxvftmB
         6qsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m2RkTas+mrztpo0nvrh9n3aa0mWUkynQJjOL8sthHrw=;
        b=GqcYYwb2qGZ84kEmCUT3SD0bF7dcW5jyBTM0ijh3eySFliM5aSbYZHluPYoj2GN8jX
         i+ZSpbrtuWnQix+fGeGaWJBn8k8Lk7MpItYB1EaCDyP4SoJ/mZIXc5of4D7K9e1AcPQF
         5c4NdemyANX/S6b6gJRspg1GOjAdBUraQVW9fWqRku2eZB2r0+RrEHq6x1GCGn4Tk8Nn
         v1t13t2nSJpp64RVJ5CQAbKWkVpoQnba2yGJwSWOsWDit4PXoEYZRVDz0KDoF1nAD3NN
         zNIJfMftvxVSWbf/du0BGdDcWJc0QJ0bWyXJAh+h2ZLG8a851lA0drUbGv29V2T+TOxV
         lZqw==
X-Gm-Message-State: AOAM533UFwMyDV6+6HN4Jhs081OeOIlXYw1OoDmRxw8fM2cUgbR6vo0L
        5btjzeoSoUOqY5PY4Xns0j/TKNc+c6MBfqIfIbZdOhecpup4WgQl
X-Google-Smtp-Source: ABdhPJxFOW5VJfyzwz2FBd7/y8Sk12CHl6mL5R3UzZlcIyHjyoch3OUBX9bPtu4G5w/rfHeJZHBJaXjt7xkrt4bssi0=
X-Received: by 2002:a17:90a:fcc:: with SMTP id 70mr24362585pjz.168.1607949217359;
 Mon, 14 Dec 2020 04:33:37 -0800 (PST)
MIME-Version: 1.0
References: <20201214085127.3960-1-magnus.karlsson@gmail.com>
 <20201214110957.GA11487@ranger.igk.intel.com> <CAJ8uoz1khf8mQCRxCmAFu7q+HasAsaP0tG_5x38=NQq+BAUbAg@mail.gmail.com>
In-Reply-To: <CAJ8uoz1khf8mQCRxCmAFu7q+HasAsaP0tG_5x38=NQq+BAUbAg@mail.gmail.com>
From:   "magnus.karlsson" <magnus.karlsson@gmail.com>
Date:   Mon, 14 Dec 2020 13:33:26 +0100
Message-ID: <CAJ8uoz0Mhmc7oW=T54p-bE-fa=m6YR69UVuVFhFWgATDVk1U_g@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix memory leak for failed bind
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:33 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Mon, Dec 14, 2020 at 12:19 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Mon, Dec 14, 2020 at 09:51:27AM +0100, Magnus Karlsson wrote:
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Fix a possible memory leak when a bind of an AF_XDP socket fails. When
> > > the fill and completion rings are created, they are tied to the
> > > socket. But when the buffer pool is later created at bind time, the
> > > ownership of these two rings are transferred to the buffer pool as
> > > they might be shared between sockets (and the buffer pool cannot be
> > > created until we know what we are binding to). So, before the buffer
> > > pool is created, these two rings are cleaned up with the socket, and
> > > after they have been transferred they are cleaned up together with
> > > the buffer pool.
> > >
> > > The problem is that ownership was transferred before it was absolutely
> > > certain that the buffer pool could be created and initialized
> > > correctly and when one of these errors occurred, the fill and
> > > completion rings did neither belong to the socket nor the pool and
> > > where therefore leaked. Solve this by moving the ownership transfer
> > > to the point where the buffer pool has been completely set up and
> > > there is no way it can fail.
> > >
> > > Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > Reported-by: syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
> > > ---
> > >  net/xdp/xsk.c           | 4 ++++
> > >  net/xdp/xsk_buff_pool.c | 2 --
> > >  2 files changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index 62504471fd20..189cfbbcccc0 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -772,6 +772,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> > >               }
> > >       }
> > >
> > > +     /* FQ and CQ are now owned by the buffer pool and cleaned up with it. */
> > > +     xs->fq_tmp = NULL;
> > > +     xs->cq_tmp = NULL;
> > > +
> > >       xs->dev = dev;
> > >       xs->zc = xs->umem->zc;
> > >       xs->queue_id = qid;
> > > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > > index d5adeee9d5d9..46c2ae7d91d1 100644
> > > --- a/net/xdp/xsk_buff_pool.c
> > > +++ b/net/xdp/xsk_buff_pool.c
> > > @@ -75,8 +75,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
> > >
> > >       pool->fq = xs->fq_tmp;
> > >       pool->cq = xs->cq_tmp;
> > > -     xs->fq_tmp = NULL;
> > > -     xs->cq_tmp = NULL;
> >
> > Given this change, are there any circumstances that we could hit
> > xsk_release with xs->{f,c}q_tmp != NULL ?
>
> Yes, if the user has not registered any fill or completion ring and
> the socket is torn down.

Sorry Maciej. I answered the inverse of your question, i.e. == NULL.
For != NULL answer:

Yes, this is possible if the user registers a fill ring and/or
completion ring but does not bind and then closes the socket.

> > >
> > >       for (i = 0; i < pool->free_heads_cnt; i++) {
> > >               xskb = &pool->heads[i];
> > >
> > > base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
> > > --
> > > 2.29.0
> > >
