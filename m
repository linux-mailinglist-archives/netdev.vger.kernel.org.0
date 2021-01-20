Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D948F2FD13B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbhATNSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 08:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732665AbhATNI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:08:28 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A213C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:07:48 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id n2so29516436iom.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TxVlKu1fTmmCpX79Lm0VHrpC5j04Mcyz1Kh6xWJDeqo=;
        b=J1YZxyHV2scGRU7022bnASDjf5zU28bwzCuezhWalOeXKl4ayTLsUok6SRLnNDJSg5
         Y1B6qIzL6cdTZPUcadl6OGtiA+BpTnpFfwMtw/iTjtI8BDpAiDHX5/NhFRHEHKBMQDfz
         G04raxx8XqxUzrrORUO6/mLzUW8adETQCbCfOviT4/z8slA6Jp6KyZ5XhEWCIL3RhPyi
         v+NE/OOvRzzgBNBu75VKWvbiyKNO8HGLIqQRDFC5va+0di2TtJUEpuahSuWcWsuQxyTM
         FyEiuhYG7w1bGRTCKNA9Nvr30BH5dNq89obTwc8BI/EU1iXC+6OcQkOhWRbgEKWx5p1p
         Wunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TxVlKu1fTmmCpX79Lm0VHrpC5j04Mcyz1Kh6xWJDeqo=;
        b=mEl6swHWXPgQ5OIXUS75EKm8TUideyt4+K94cIWNHmPBMieO6D3Y7N3mK/30lUyUn3
         xDjhH4QmlfZ65dIcIJs6FPWaJ5AVKs3BjF2f7mUAFfWZZzla08GwXLnSj+dJAJF+VlDx
         eLWV+pcoy5G9MOgcp5ga/ii2q1Tz/tbpTbqaPWrElC8UYE3ZH7VmHbV77xqNQobp82uQ
         OCc1df4juOv9LGcerENlY7chYmgnmHh5MlAGcRHOYFLDmpqMEPgsdTbmfuGDslBDAMHe
         YdI462useM1JDJhrVx31QH38OPmmCtRIm8eBiGii72nIkV5cUjNtBoAr6y72ITAEb3fe
         9t9A==
X-Gm-Message-State: AOAM532yvpTuFIkGVGtI+lvncyIdgFOiSy/fFdxql0jQY/Z6tsh3Pp88
        UGVNVYKzMDzKaqoO3zmcE1EFw0pjV1s+fjOgo+8XvU6tQ+Y=
X-Google-Smtp-Source: ABdhPJxHPhZ9TlTjpGTKFjBUKrRX241UEm6YS/DL50CgsqyeWkdAjprwTxKAUeZKGELEOmwi28nllQz+iClJLL8dCTU=
X-Received: by 2002:a5d:8a02:: with SMTP id w2mr6955472iod.157.1611148067266;
 Wed, 20 Jan 2021 05:07:47 -0800 (PST)
MIME-Version: 1.0
References: <20210118055920.82516-1-kuniyu@amazon.co.jp> <20210119171745.6840e3a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119171745.6840e3a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Jan 2021 14:07:35 +0100
Message-ID: <CANn89iLF4SA_En=sLzEdXByA=m93+EoWKngSZtb4SfeE=8uO9A@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Fix potential use-after-free due to double kfree().
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Ricardo Dias <rdias@singlestore.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 2:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 18 Jan 2021 14:59:20 +0900 Kuniyuki Iwashima wrote:
> > Receiving ACK with a valid SYN cookie, cookie_v4_check() allocates struct
> > request_sock and then can allocate inet_rsk(req)->ireq_opt. After that,
> > tcp_v4_syn_recv_sock() allocates struct sock and copies ireq_opt to
> > inet_sk(sk)->inet_opt. Normally, tcp_v4_syn_recv_sock() inserts the full
> > socket into ehash and sets NULL to ireq_opt. Otherwise,
> > tcp_v4_syn_recv_sock() has to reset inet_opt by NULL and free the full
> > socket.
> >
> > The commit 01770a1661657 ("tcp: fix race condition when creating child
> > sockets from syncookies") added a new path, in which more than one cores
> > create full sockets for the same SYN cookie. Currently, the core which
> > loses the race frees the full socket without resetting inet_opt, resulting
> > in that both sock_put() and reqsk_put() call kfree() for the same memory:
> >
> >   sock_put
> >     sk_free
> >       __sk_free
> >         sk_destruct
> >           __sk_destruct
> >             sk->sk_destruct/inet_sock_destruct
> >               kfree(rcu_dereference_protected(inet->inet_opt, 1));
> >
> >   reqsk_put
> >     reqsk_free
> >       __reqsk_free
> >         req->rsk_ops->destructor/tcp_v4_reqsk_destructor
> >           kfree(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1));
> >
> > Calling kmalloc() between the double kfree() can lead to use-after-free, so
> > this patch fixes it by setting NULL to inet_opt before sock_put().
> >
> > As a side note, this kind of issue does not happen for IPv6. This is
> > because tcp_v6_syn_recv_sock() clones both ipv6_opt and pktopts which
> > correspond to ireq_opt in IPv4.
> >
> > Fixes: 01770a166165 ("tcp: fix race condition when creating child sockets from syncookies")
> > CC: Ricardo Dias <rdias@singlestore.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
>
> Ricardo, Eric, any reason this was written this way?

Well, I guess that was a plain bug.

IPv4 options are not used often I think.

Reviewed-by: Eric Dumazet <edumazet@google.com>
