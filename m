Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322F9306303
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344391AbhA0SIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344385AbhA0SIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:08:44 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19885C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:08:04 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id a1so2715407ilr.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VJZP8MOLyoKM/GkUK5rpElN/cwuUFmfUf42GSpkbWeQ=;
        b=G6K4nAYUowzQBptAwFLHdUeTSXDxQ54VE64+B+o9EdF/N5hAzv+6VdaAacC5LrLzb+
         1p4I+J1M/Q237uxVzWEVqbLdTkuGkqsSIrrq2fUZmO5VF1TV0/0FwS5l8+Q6BI24YMXZ
         IB4eQ4Y6RAE74hDHDgP6G32hhr7Z9FwsAAQ+UrGp17wZcO0mIo/1JFOx4utQz5ej7B3U
         o6cgbOyVy5urVnvQ6jdrgqnfPMslVoUIGCskY2o1dTTWvg435vsn27i78SRQv5g7sIs+
         P4ikxGlSxL/Abi47SRFOHxu7OtF2NzdotAjMNCStlIWnvgvFk6NpUbgXn+ecbrWDjZ6q
         siWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VJZP8MOLyoKM/GkUK5rpElN/cwuUFmfUf42GSpkbWeQ=;
        b=E8Nmbg15o/F1KJNDY+Kk2h/Rj6wcdyDxdVhkPEn2/ERcY5AINRi7sOc0eI6YGDu9HC
         GwkKjNZQ0SJ++CZ1Au0MwCSVfnY8sCwWKguNwry6JrAwoUtBHd8L9jisbHUOqcYrZHtH
         oDo5/T5d3YtKwjSB+GK3A6v+InhdPCCW0j6sXqAVNHoOLfonXqWDEXsPXaErdiKRu852
         rFEiIPztO38Kp3D5SGpaGhVhozdrgozGzGLqV9GLEumPomqQfeSGR5hzfvtbL5TXZbs5
         YPc9j8LaJJQsu/uHyaF+4XJskAbV5ReQTYy1YtblbZBL9Vbg+0893lpWnQg8qfvmxylb
         gShw==
X-Gm-Message-State: AOAM530vExfkHawK73lAyIWFHaweXsJJV5KCLTYxHPijvilhbzFqJug7
        iUyAZXFZlaQcEghn3jcLbcvBFk3E5Z8Ucn9zOp9aMQ==
X-Google-Smtp-Source: ABdhPJzC9lYPz+Lqd8LcNrgNBl2oGP/wu1nAmMTtnYN30J2sfLPhZZjv/sVt7DtK0HyIBNL8eEWW2tmRrKj+HgQsdyQ=
X-Received: by 2002:a05:6e02:1d0e:: with SMTP id i14mr9422982ila.69.1611770883172;
 Wed, 27 Jan 2021 10:08:03 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iKE0GFK1UzQvqYxKKy8E4Qcc57=JFFWCGmtpfgWRhpOpA@mail.gmail.com>
 <20210127175611.62871-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210127175611.62871-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jan 2021 19:07:51 +0100
Message-ID: <CANn89iJbtbMJ1gC2e8P7v+rB+EON=Y-i0B2mQ5kGQOqJMk=G=A@mail.gmail.com>
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

On Wed, Jan 27, 2021 at 6:56 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Wed, 27 Jan 2021 18:34:35 +0100
> > On Wed, Jan 27, 2021 at 6:32 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Wed, 27 Jan 2021 18:05:24 +0100
> > > > On Wed, Jan 27, 2021 at 5:52 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > >
> > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > Date:   Wed, 27 Jan 2021 15:54:32 +0100
> > > > > > On Wed, Jan 27, 2021 at 1:50 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > > > >
> > > > > > > The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> > > > > > > sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> > > > > > > it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> > > > > > > the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). However,
> > > > > > > the original commit had already put sk_tx_queue_clear() in sk_prot_alloc():
> > > > > > > the callee of sk_alloc() and sk_clone_lock(). Thus sk_tx_queue_clear() is
> > > > > > > called twice in each path currently.
> > > > > >
> > > > > > Are you sure ?
> > > > > >
> > > > > > I do not clearly see the sk_tx_queue_clear() call from the cloning part.
> > > > > >
> > > > > > Please elaborate.
> > > > >
> > > > > If sk is not NULL in sk_prot_alloc(), sk_tx_queue_clear() is called [1].
> > > > > Also the callers of sk_prot_alloc() are only sk_alloc() and sk_clone_lock().
> > > > > If they finally return not NULL pointer, sk_tx_queue_clear() is called in
> > > > > each function [2][3].
> > > > >
> > > > > In the cloning part, sock_copy() is called after sk_prot_alloc(), but
> > > > > skc_tx_queue_mapping is defined between skc_dontcopy_begin and
> > > > > skc_dontcopy_end in struct sock_common [4]. So, sock_copy() does not
> > > > > overwrite skc_tx_queue_mapping, and thus we can initialize it in
> > > > > sk_prot_alloc().
> > > >
> > > > That is a lot of assumptions.
> > > >
> > > > What guarantees do we have that skc_tx_queue_mapping will never be
> > > > moved out of this section ?
> > > > AFAIK it was there by accident, for cache locality reasons, that might
> > > > change in the future as we add more stuff in socket.
> > > >
> > > > I feel this optimization is risky for future changes, for a code path
> > > > that is spending thousands of cycles anyway.
> > >
> > > If someone try to move skc_tx_queue_mapping out of the section, should
> > > they take care about where it is used ?
>
> I'm sorry if it might be misleading, I would like to mean someone/they is
> the author of a patch to move skc_tx_queue_mapping.
>
>
> > Certainly not. You hide some knowledge, without a comment or some runtime check.
>
> It was my bad, I should have written about sock_copy() in the changelog.

I think you also want to add some compile time check.

BUILD_BUG_ON( skc_tx_queue_mapping is in the no copy area)

Because maintainers do not remember changelogs in their mind.


>
>
> > You can not ask us (maintainers) to remember thousands of tricks.
>
> I'll keep this in mind.
>
>
> > >
> > > But I agree that we should not write error-prone code.
> > >
> > > Currently, sk_tx_queue_clear() is the only initialization code in
> > > sk_prot_alloc(). So, does it make sense to remove sk_tx_queue_clear() in
> > > sk_prot_alloc() so that it does only allocation and other fields are
> > > initialized in each caller ?
>
> Can I ask what you think about this ?

Yes, this would be fine.

>
>
> > > > >
> > > > > [1] sk_prot_alloc
> > > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1693
> > > > >
> > > > > [2] sk_alloc
> > > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1762
> > > > >
> > > > > [3] sk_clone_lock
> > > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1986
> > > > >
> > > > > [4] struct sock_common
> > > > > https://github.com/torvalds/linux/blob/master/include/net/sock.h#L218-L240
> > > > >
> > > > >
> > > > > > In any case, this seems to be a candidate for net-next, this is not
> > > > > > fixing a bug,
> > > > > > this would be an optimization at most, and potentially adding a bug.
> > > > > >
> > > > > > So if you resend this patch, you can mention the old commit in the changelog,
> > > > > > but do not add a dubious Fixes: tag
> > > > >
> > > > > I see.
> > > > >
> > > > > I will remove the tag and resend this as a net-next candidate.
> > > > >
> > > > > Thank you,
> > > > > Kuniyuki
> > > > >
> > > > >
> > > > > > >
> > > > > > > This patch removes the redundant calls of sk_tx_queue_clear() in sk_alloc()
> > > > > > > and sk_clone_lock().
> > > > > > >
> > > > > > > Fixes: 41b14fb8724d ("net: Do not clear the sock TX queue in sk_set_socket()")
> > > > > > > CC: Tariq Toukan <tariqt@mellanox.com>
> > > > > > > CC: Boris Pismenny <borisp@mellanox.com>
> > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > > > Reviewed-by: Amit Shah <aams@amazon.de>
> > > > > > > ---
> > > > > > >  net/core/sock.c | 2 --
> > > > > > >  1 file changed, 2 deletions(-)
> > > > > > >
> > > > > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > > > > index bbcd4b97eddd..5c665ee14159 100644
> > > > > > > --- a/net/core/sock.c
> > > > > > > +++ b/net/core/sock.c
> > > > > > > @@ -1759,7 +1759,6 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
> > > > > > >                 cgroup_sk_alloc(&sk->sk_cgrp_data);
> > > > > > >                 sock_update_classid(&sk->sk_cgrp_data);
> > > > > > >                 sock_update_netprioidx(&sk->sk_cgrp_data);
> > > > > > > -               sk_tx_queue_clear(sk);
> > > > > > >         }
> > > > > > >
> > > > > > >         return sk;
> > > > > > > @@ -1983,7 +1982,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
> > > > > > >                  */
> > > > > > >                 sk_refcnt_debug_inc(newsk);
> > > > > > >                 sk_set_socket(newsk, NULL);
> > > > > > > -               sk_tx_queue_clear(newsk);
> > > > > > >                 RCU_INIT_POINTER(newsk->sk_wq, NULL);
> > > > > > >
> > > > > > >                 if (newsk->sk_prot->sockets_allocated)
> > > > > > > --
> > > > > > > 2.17.2 (Apple Git-113)
> > > > > > >
