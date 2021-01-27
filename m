Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DDB306229
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344013AbhA0Rg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344009AbhA0Rff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:35:35 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471E6C0613ED
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:34:48 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u8so2649970ior.13
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oW5mp8XPI8J87KFQ43usYsmmtjjAtdQhi+BnJucpFYE=;
        b=uUsfaWlv6TVs5zs6K/oE+oT9TTqRp8a5YCvVhkjEfazYsFU11U/46r4y4Hmodxicg5
         T9WuFX9SwaWcOuJJGCSvXWwraipDzlJwp8TL84Gv5M0G+l4Y3Yt5+oy9NxXWnXN0rxXI
         I1NxSjpnSji1P+xBMqhi+amm7WjbuGPndYHorAWpGhAyXVRws6N0EmsG45EXJLoVRs9n
         EkDQBNf3/XF+R7g4kI813x0r3f/qDZAfWvTemxyOfyhcyGBlwPYWFxp0U1ZLyLy8pqTG
         3MxgHvhNdiJaWVzANwE1RVWLx1uphH43/we08wn4ZC7F4vArPIw8bellaO9nEXlsyCYq
         7cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oW5mp8XPI8J87KFQ43usYsmmtjjAtdQhi+BnJucpFYE=;
        b=kEVfLGHBMbQerDwaPWlblklbkKlRrPZb3e3kLSlrexBfc8QZ+/6elf4LOcfUVUh12H
         vSqOgUgZUucltZ4JJ5WlNOdVjdedvWgo4jfY3i/2QXMxSDrQBmAx/g+Q7czuFZqMVW7O
         VDVLUx9Y0JzT5Lfx072ZAbwARio+tf1m/W14U3PG5w5UvJ8+DrzKL8Wtoyx2ginESNaT
         64VQIqUK9Vn+KN/q/cbwxSJG/3CeqwhGy0bsgNU8CfsRiIPRNzzxca40lszwnuzqB9Iw
         3AhrCTJZAx5WDrjjKQ/JVoyleKFdtm6CH4DWt/3hJIBiG2QygMblr00WH1DNydj/uOdb
         FISA==
X-Gm-Message-State: AOAM5337qOpVZFGFKzULsCeasf1hKF46qzPEiC4Hsx0Sc9itXYyzC2Mk
        SMHNBdMfWvhkxvyyJACNv3ZxXJumfhGHLVqL/OwQxQ==
X-Google-Smtp-Source: ABdhPJxtIonezTwyuOb3+abTlRlG2xus/TYXqhbMOoc+/bBSA0vwRyHQNz2I8V/qUMIJPn/cLo5xklKergbaeX/dl1g=
X-Received: by 2002:a6b:1d1:: with SMTP id 200mr8413965iob.195.1611768887340;
 Wed, 27 Jan 2021 09:34:47 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iK2cd6rRFfNL-vp_Dy4xvtuk_5vA-xg=MbbWb-ybzHheg@mail.gmail.com>
 <20210127173145.58887-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210127173145.58887-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jan 2021 18:34:35 +0100
Message-ID: <CANn89iKE0GFK1UzQvqYxKKy8E4Qcc57=JFFWCGmtpfgWRhpOpA@mail.gmail.com>
Subject: Re: [PATCH net] net: Remove redundant calls of sk_tx_queue_clear().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Amit Shah <aams@amazon.de>, Boris Pismenny <borisp@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 6:32 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Wed, 27 Jan 2021 18:05:24 +0100
> > On Wed, Jan 27, 2021 at 5:52 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Wed, 27 Jan 2021 15:54:32 +0100
> > > > On Wed, Jan 27, 2021 at 1:50 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > >
> > > > > The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> > > > > sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> > > > > it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> > > > > the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). However,
> > > > > the original commit had already put sk_tx_queue_clear() in sk_prot_alloc():
> > > > > the callee of sk_alloc() and sk_clone_lock(). Thus sk_tx_queue_clear() is
> > > > > called twice in each path currently.
> > > >
> > > > Are you sure ?
> > > >
> > > > I do not clearly see the sk_tx_queue_clear() call from the cloning part.
> > > >
> > > > Please elaborate.
> > >
> > > If sk is not NULL in sk_prot_alloc(), sk_tx_queue_clear() is called [1].
> > > Also the callers of sk_prot_alloc() are only sk_alloc() and sk_clone_lock().
> > > If they finally return not NULL pointer, sk_tx_queue_clear() is called in
> > > each function [2][3].
> > >
> > > In the cloning part, sock_copy() is called after sk_prot_alloc(), but
> > > skc_tx_queue_mapping is defined between skc_dontcopy_begin and
> > > skc_dontcopy_end in struct sock_common [4]. So, sock_copy() does not
> > > overwrite skc_tx_queue_mapping, and thus we can initialize it in
> > > sk_prot_alloc().
> >
> > That is a lot of assumptions.
> >
> > What guarantees do we have that skc_tx_queue_mapping will never be
> > moved out of this section ?
> > AFAIK it was there by accident, for cache locality reasons, that might
> > change in the future as we add more stuff in socket.
> >
> > I feel this optimization is risky for future changes, for a code path
> > that is spending thousands of cycles anyway.
>
> If someone try to move skc_tx_queue_mapping out of the section, should
> they take care about where it is used ?

Certainly not. You hide some knowledge, without a comment or some runtime check.

You can not ask us (maintainers) to remember thousands of tricks.

>
> But I agree that we should not write error-prone code.
>
> Currently, sk_tx_queue_clear() is the only initialization code in
> sk_prot_alloc(). So, does it make sense to remove sk_tx_queue_clear() in
> sk_prot_alloc() so that it does only allocation and other fields are
> initialized in each caller ?
>
>
> > >
> > > [1] sk_prot_alloc
> > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1693
> > >
> > > [2] sk_alloc
> > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1762
> > >
> > > [3] sk_clone_lock
> > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1986
> > >
> > > [4] struct sock_common
> > > https://github.com/torvalds/linux/blob/master/include/net/sock.h#L218-L240
> > >
> > >
> > > > In any case, this seems to be a candidate for net-next, this is not
> > > > fixing a bug,
> > > > this would be an optimization at most, and potentially adding a bug.
> > > >
> > > > So if you resend this patch, you can mention the old commit in the changelog,
> > > > but do not add a dubious Fixes: tag
> > >
> > > I see.
> > >
> > > I will remove the tag and resend this as a net-next candidate.
> > >
> > > Thank you,
> > > Kuniyuki
> > >
> > >
> > > > >
> > > > > This patch removes the redundant calls of sk_tx_queue_clear() in sk_alloc()
> > > > > and sk_clone_lock().
> > > > >
> > > > > Fixes: 41b14fb8724d ("net: Do not clear the sock TX queue in sk_set_socket()")
> > > > > CC: Tariq Toukan <tariqt@mellanox.com>
> > > > > CC: Boris Pismenny <borisp@mellanox.com>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > Reviewed-by: Amit Shah <aams@amazon.de>
> > > > > ---
> > > > >  net/core/sock.c | 2 --
> > > > >  1 file changed, 2 deletions(-)
> > > > >
> > > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > > index bbcd4b97eddd..5c665ee14159 100644
> > > > > --- a/net/core/sock.c
> > > > > +++ b/net/core/sock.c
> > > > > @@ -1759,7 +1759,6 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
> > > > >                 cgroup_sk_alloc(&sk->sk_cgrp_data);
> > > > >                 sock_update_classid(&sk->sk_cgrp_data);
> > > > >                 sock_update_netprioidx(&sk->sk_cgrp_data);
> > > > > -               sk_tx_queue_clear(sk);
> > > > >         }
> > > > >
> > > > >         return sk;
> > > > > @@ -1983,7 +1982,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
> > > > >                  */
> > > > >                 sk_refcnt_debug_inc(newsk);
> > > > >                 sk_set_socket(newsk, NULL);
> > > > > -               sk_tx_queue_clear(newsk);
> > > > >                 RCU_INIT_POINTER(newsk->sk_wq, NULL);
> > > > >
> > > > >                 if (newsk->sk_prot->sockets_allocated)
> > > > > --
> > > > > 2.17.2 (Apple Git-113)
> > > > >
