Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D033E665066
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 01:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbjAKAeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 19:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbjAKAeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 19:34:18 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D7F52C6B;
        Tue, 10 Jan 2023 16:34:17 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e13so14464861ljn.0;
        Tue, 10 Jan 2023 16:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BiXsVfvb8HVN56162ty5XjhFUQGSHMoyOVr1HHJ2pGw=;
        b=V1fExYDc6wqHuuNyLXu+t0tS9sLGUjaEqjQiw2g+h+rfZMLrm5aWk7mSvXD+sd+dHU
         uhW7L3fstHRNLHBFR7Udm4LDH75uHbUIoW9Ff0nd5YKWmhcjawGV5q26SO8jdBkRexs9
         tPw//0U0HvSJDr5ed9tboFESFBPxmTwgkEhuMdzLwj6Sf9YBT4LR7XqavtkCIMFOUIbd
         IsUWkILvxEx65V0089obTb5j/Vg3fX/Z/ehi4pWp6c39jI3cjH4sXdRjetortglz9wWB
         XeeWxgyoJ28RIpDPR3HJPpQGcY6J6nPCHtLcAMZaB8hevc0c9wEAfGgptViPB003efeu
         FQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BiXsVfvb8HVN56162ty5XjhFUQGSHMoyOVr1HHJ2pGw=;
        b=ziNh8liW7TdKYurt+OwAudeYSRGBNVHI+ktf/yG2yNxnmBjVZopZ6HA0skvb9pVrS+
         qWf73Xz6AtSRNOZODFwdJLNinXZlI7gH4/RyS8BtePIWpnCi0yYLslkTWrR7h3OD4eLK
         dUguf+3uDWwqs82q94w3dJSOc4t+MZcWEJQvC0rQrVYJKUB1Yx5yB5QeS0Vq+YYCitkj
         8Jh+h25c9sFsn4qpJxdS4SVwmPRc1OFxHT2RI5VUGm7yTkGPTEZTiLCFujckq3UjyN8G
         v5zX2yBzWC80G+nX5prrHrO5NUHE2LcM7dYN8009TRrUQns2BcqPNc2l9oIegoDORHqg
         VlpQ==
X-Gm-Message-State: AFqh2krRkjFfN2ttwO8lP1M8tsR7NSqwkFokkYNqaSVP4WA7+PUljG7s
        qV/oDllPSmBYlhGExnkCYP/sdpM3XoIgQkIMFQs=
X-Google-Smtp-Source: AMrXdXvtiN2lHyB2fnpWicGg7K3Kr3jXZ+3PJ+n8hK9cirbKRY72nc2p0B85QoSt/vF2mTCWHvoUt6z98izbPAnDUlE=
X-Received: by 2002:a2e:a98f:0:b0:27f:b76d:492f with SMTP id
 x15-20020a2ea98f000000b0027fb76d492fmr4575548ljq.293.1673397255374; Tue, 10
 Jan 2023 16:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20230103111221.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
 <Y7UiDn3Gi5YdNIoC@unreal> <Y7dqKnQe8UUeQ/CD@x130> <Y7qXIZNsju8dCzqu@unreal> <Y70q4ZsdQNP9GIbF@x130>
In-Reply-To: <Y70q4ZsdQNP9GIbF@x130>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 10 Jan 2023 16:34:03 -0800
Message-ID: <CABBYNZ+idTkc1HtQxHm5zyT2ztUJQW2U4i5vaDs477zt_5_-XA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, Ying Hsu <yinghsu@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

On Tue, Jan 10, 2023 at 1:07 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On 08 Jan 12:12, Leon Romanovsky wrote:
> >On Thu, Jan 05, 2023 at 04:24:10PM -0800, Saeed Mahameed wrote:
> >> On 04 Jan 08:51, Leon Romanovsky wrote:
> >> > On Tue, Jan 03, 2023 at 11:12:46AM +0000, Ying Hsu wrote:
> >> > > There's a possible deadlock when two processes are connecting
> >> > > and closing concurrently:
> >> > >   + CPU0: __rfcomm_dlc_close locks rfcomm and then calls
> >> > >   rfcomm_sk_state_change which locks the sock.
> >> > >   + CPU1: rfcomm_sock_connect locks the socket and then calls
> >> > >   rfcomm_dlc_open which locks rfcomm.
> >> > >
> >> > > Here's the call trace:
> >> > >
> >> > > -> #2 (&d->lock){+.+.}-{3:3}:
> >> > >        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> >> > >        __mutex_lock0x12f/0x1360 kernel/locking/mutex.c:747
> >> > >        __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
> >> > >        rfcomm_dlc_close+1e9/0x240 net/bluetooth/rfcomm/core.c:520
> >> > >        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> >> > >        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> >> > >        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> >> > >        __sock_release+0xcd/0x280 net/socket.c:650
> >> > >        sock_close+0x1c/0x20 net/socket.c:1365
> >> > >        __fput+0x27c/0xa90 fs/file_table.c:320
> >> > >        task_work_run+0x16f/0x270 kernel/task_work.c:179
> >> > >        exit_task_work include/linux/task_work.h:38 [inline]
> >> > >        do_exit+0xaa8/0x2950 kernel/exit.c:867
> >> > >        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> >> > >        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> >> > >        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> >> > >        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> >> > >        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> >> > >        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> >> > >        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> >> > >        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> >> > >        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> > >
> >> > > -> #1 (rfcomm_mutex){+.+.}-{3:3}:
> >> > >        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> >> > >        __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
> >> > >        rfcomm_dlc_open+0x93/0xa80 net/bluetooth/rfcomm/core.c:425
> >> > >        rfcomm_sock_connect+0x329/0x450 net/bluetooth/rfcomm/sock.c:413
> >> > >        __sys_connect_file+0x153/0x1a0 net/socket.c:1976
> >> > >        __sys_connect+0x165/0x1a0 net/socket.c:1993
> >> > >        __do_sys_connect net/socket.c:2003 [inline]
> >> > >        __se_sys_connect net/socket.c:2000 [inline]
> >> > >        __x64_sys_connect+0x73/0xb0 net/socket.c:2000
> >> > >        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >> > >        do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >> > >        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> > >
> >> > > -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
> >> > >        check_prev_add kernel/locking/lockdep.c:3097 [inline]
> >> > >        check_prevs_add kernel/locking/lockdep.c:3216 [inline]
> >> > >        validate_chain kernel/locking/lockdep.c:3831 [inline]
> >> > >        __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
> >> > >        lock_acquire kernel/locking/lockdep.c:5668 [inline]
> >> > >        lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
> >> > >        lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
> >> > >        lock_sock include/net/sock.h:1725 [inline]
> >> > >        rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
> >> > >        __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
> >> > >        rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
> >> > >        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> >> > >        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> >> > >        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> >> > >        __sock_release+0xcd/0x280 net/socket.c:650
> >> > >        sock_close+0x1c/0x20 net/socket.c:1365
> >> > >        __fput+0x27c/0xa90 fs/file_table.c:320
> >> > >        task_work_run+0x16f/0x270 kernel/task_work.c:179
> >> > >        exit_task_work include/linux/task_work.h:38 [inline]
> >> > >        do_exit+0xaa8/0x2950 kernel/exit.c:867
> >> > >        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> >> > >        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> >> > >        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> >> > >        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> >> > >        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> >> > >        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> >> > >        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> >> > >        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> >> > >        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> > >
> >> > > Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> >> > > ---
> >> > > This commit has been tested with a C reproducer on qemu-x86_64.
> >> > >
> >> > >  net/bluetooth/rfcomm/sock.c | 2 ++
> >> > >  1 file changed, 2 insertions(+)
> >> > >
> >> > > diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> >> > > index 21e24da4847f..29f9a88a3dc8 100644
> >> > > --- a/net/bluetooth/rfcomm/sock.c
> >> > > +++ b/net/bluetooth/rfcomm/sock.c
> >> > > @@ -410,8 +410,10 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
> >> > >          d->sec_level = rfcomm_pi(sk)->sec_level;
> >> > >          d->role_switch = rfcomm_pi(sk)->role_switch;
> >> > >
> >> > > +        release_sock(sk);
> >> > >          err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
> >> >                                           ^^^^
> >> > Are you sure that "sk" still exists here after you called to release_sock(sk)?
> >> > What prevents from use-after-free here?
> >> >
> >>
> >> sk must be valid to be locked in first place.
> >
> >It is, but after it is released it won't.
> >
>
> the code is symmetric:
> you hold the sk lock then do your thing and then release it.
>
> if you claim that sk can be freed by another process after you released it,
> then due to symmetry it also can be freed before you locked it, unless

Apart to cases where the socket fd is passed over to other process the
sk is not shared between process, what most likely we want the
sock_lock is for preventing different threads to perform different
operation simultaneously which most likely would cause unexpected
results (e.g. thread 1 calls connect, thread 2 calls close), which is
why most, if not all, proto_ops implementation do call sock_lock as
soon as possible.

> >> release_sock() has mutex unlock semantics so it doesn't free anything..
> >
> >What do you mean?
> >
> >I see a lot of magic release calls.
> >
> >  3481 void release_sock(struct sock *sk)
> >  3482 {
> >  3483         spin_lock_bh(&sk->sk_lock.slock);
> >  3484         if (sk->sk_backlog.tail)
> >  3485                 __release_sock(sk);
> >  3486
> >  3487         /* Warning : release_cb() might need to release sk ownership,
> >  3488          * ie call sock_release_ownership(sk) before us.
> >  3489          */
> >  3490         if (sk->sk_prot->release_cb)
> >  3491                 sk->sk_prot->release_cb(sk);
> >  3492
> >  3493         sock_release_ownership(sk);
> >  3494         if (waitqueue_active(&sk->sk_lock.wq))
> >  3495                 wake_up(&sk->sk_lock.wq);
>           sk must b  still valid here :), so there was no free to sk object

The sk may be valid but it could wakeup another thread pending on
sock_lock which would then do shutdown/close so the next time this
thread attempts to perform sock_lock the state could have been
changed.

> >  3496         spin_unlock_bh(&sk->sk_lock.slock);
> >  3497 }
> >  3498 EXPORT_SYMBOL(release_sock);
> >
> >Thanks
>


-- 
Luiz Augusto von Dentz
