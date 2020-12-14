Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7282D9769
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437879AbgLNLdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438097AbgLNLd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:33:27 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9706EC0613CF;
        Mon, 14 Dec 2020 03:33:12 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id bj5so8495227plb.4;
        Mon, 14 Dec 2020 03:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBVb1jFsASJsSe1NamAzmoDRIpXSvh9pGjIhBirNzcs=;
        b=rUi3Hif5kqB6uaX65vcQbFiwebqVisYGNBSM3aOrP0M4916+XGWoYTKTHAR1NdLzEP
         FhGLlcGuh7PW3EVUEz5Wz0Dr9fdkD/eFrPc1IU8usY8/27oLkf3iBnXGsqVUAZL1uhMg
         icn+6NaVLQIqKrLXEi0ALtwpJseWozdiP2+naNY2XZDKXkp4QNwsdJ4aZXhf+7/LZJhA
         CAXcz+1iVvKixpV8BDolDvnBbf+gxG2LEvhgslv448vwj334k8PdTw64Nvo0+Yj+8emr
         OIDDIRWnWfrCBMb2crD5TgEhwDOU/EBFzFJRf8QFs6UG1Q9WXUvCvfjue46UnyLYnCA1
         WELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBVb1jFsASJsSe1NamAzmoDRIpXSvh9pGjIhBirNzcs=;
        b=tGY2fOIBIrXUUaGTSi8czdV8lqnf3jTpQl0kzIjSjPJz85oETxawqUe3AZFgyVC7cl
         bv6Zv+tYyNxoO7gmp/ICv8zQxaa57s0ZG7NsB0elPTGodugo8ulBIZVurfvjC4pFDh56
         V0HHKpw9L9mkXCW0vAkwvSXTKv6+uIqHB6JEB5cCRa6seeN0/ENtSpBavmi6ZkGtFNFI
         nDROkZVEEDbKNxMs6CJ7WJ1fM4FphIBmGolEwEiiu0vVky4W0pVrxUuBbZZ66WFy0fIt
         TI1gavS/j0H3qkzDfGLjwa21j2V1IDTdUmnUTmtvLoTn8Jr1bd8KYj/gOTtx6qeJkmFE
         bz2A==
X-Gm-Message-State: AOAM530BWsJ2rhQ3RbkZ+cYwN6QdZknXLdioCkQ2nBJOvMGdtvr3L1sH
        a0TQnebH4pb6cv72ufkuZwmdyFChsD1L8KhW3wo=
X-Google-Smtp-Source: ABdhPJwg0wBuACxKcbYs8D8YRpfl1IIQE8IcYWD3KgotbchtPjvyYooSvnNFYKq+0ga/3DF2KD0AEOJDXlwBBXy5/8w=
X-Received: by 2002:a17:902:d38b:b029:db:e003:3ff0 with SMTP id
 e11-20020a170902d38bb02900dbe0033ff0mr18317583pld.7.1607945591970; Mon, 14
 Dec 2020 03:33:11 -0800 (PST)
MIME-Version: 1.0
References: <20201214085127.3960-1-magnus.karlsson@gmail.com> <20201214110957.GA11487@ranger.igk.intel.com>
In-Reply-To: <20201214110957.GA11487@ranger.igk.intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 14 Dec 2020 12:33:01 +0100
Message-ID: <CAJ8uoz1khf8mQCRxCmAFu7q+HasAsaP0tG_5x38=NQq+BAUbAg@mail.gmail.com>
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

On Mon, Dec 14, 2020 at 12:19 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Mon, Dec 14, 2020 at 09:51:27AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a possible memory leak when a bind of an AF_XDP socket fails. When
> > the fill and completion rings are created, they are tied to the
> > socket. But when the buffer pool is later created at bind time, the
> > ownership of these two rings are transferred to the buffer pool as
> > they might be shared between sockets (and the buffer pool cannot be
> > created until we know what we are binding to). So, before the buffer
> > pool is created, these two rings are cleaned up with the socket, and
> > after they have been transferred they are cleaned up together with
> > the buffer pool.
> >
> > The problem is that ownership was transferred before it was absolutely
> > certain that the buffer pool could be created and initialized
> > correctly and when one of these errors occurred, the fill and
> > completion rings did neither belong to the socket nor the pool and
> > where therefore leaked. Solve this by moving the ownership transfer
> > to the point where the buffer pool has been completely set up and
> > there is no way it can fail.
> >
> > Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Reported-by: syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
> > ---
> >  net/xdp/xsk.c           | 4 ++++
> >  net/xdp/xsk_buff_pool.c | 2 --
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 62504471fd20..189cfbbcccc0 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -772,6 +772,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >               }
> >       }
> >
> > +     /* FQ and CQ are now owned by the buffer pool and cleaned up with it. */
> > +     xs->fq_tmp = NULL;
> > +     xs->cq_tmp = NULL;
> > +
> >       xs->dev = dev;
> >       xs->zc = xs->umem->zc;
> >       xs->queue_id = qid;
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index d5adeee9d5d9..46c2ae7d91d1 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -75,8 +75,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
> >
> >       pool->fq = xs->fq_tmp;
> >       pool->cq = xs->cq_tmp;
> > -     xs->fq_tmp = NULL;
> > -     xs->cq_tmp = NULL;
>
> Given this change, are there any circumstances that we could hit
> xsk_release with xs->{f,c}q_tmp != NULL ?

Yes, if the user has not registered any fill or completion ring and
the socket is torn down.

> >
> >       for (i = 0; i < pool->free_heads_cnt; i++) {
> >               xskb = &pool->heads[i];
> >
> > base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
> > --
> > 2.29.0
> >
