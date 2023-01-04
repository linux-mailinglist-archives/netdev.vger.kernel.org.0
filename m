Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2212465DFE6
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbjADWWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbjADWVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 17:21:53 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E84342600;
        Wed,  4 Jan 2023 14:21:43 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j17so43039716lfr.3;
        Wed, 04 Jan 2023 14:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zS4jIgttPjdUhbCGJt5R7vixRsFgTExBXPa62NdH9To=;
        b=kyAaa8T49nuCcj+Ed3b/1eNxBpOf69N7dbzOW96Y7f7rNYaV3+6cYSnx2n0b3r3RmX
         oxuUKvFkmSES+c+fV9kOwsgGhefMWEYhqLHo5WQNQILzam3433kpSFDkWf2EKgfuLS3n
         DNjD/Hvf4pvjsxfIkqVuTElxykILEqLIQM9EGV5TyIFFgG1mUcyxEZ5rxY2K/1rLSHtT
         ZyYZel35i/+wcuT74HUvFC0tasHlfzn4R98Xsn+iEAdpgR/Eww//poNkI+FmTdhxKvlP
         LPwkhPOYUzxZgyDRTIcsqQBZvYR+7vHIXLsBD9dRCia4iim9OldAf+w7yXgUnsXuUKxA
         3DAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zS4jIgttPjdUhbCGJt5R7vixRsFgTExBXPa62NdH9To=;
        b=aVDx0l6gvdlDNQ3lZcrQx4uTrdHsIaMprllWVvfoM7cnaKCqt/zKUchtlf7RhXkhj1
         h1rPXMsxa9BLOYml1jUhKk2ZANU6+skVetVo4OI9FrA+//WzX24TN1Nkj+IUzDW3l1/Q
         OKebqAMXwNU52HqZVsMl/a+izbQP86EbdMMPEr6OZvVw9jAwLBZiIkYB55S2RQogOBu1
         0o/rfUXX07STKi8IjzZ3BYR6JigAxOmccSoZW4MbH8+eKqAKm/kI++raiUAKtiEy4l1L
         fzvF8pYUO0+81XDKgTY645V+dXPfdeAzqJDXu7jsHYq4/f1eARVhHazJiRGor2M77cfT
         M/Xg==
X-Gm-Message-State: AFqh2krry43bYARR3E1IAF+rDPQfQOoTYMdlJiFfAK9NYKHuoFd9ulzk
        +siOOAtaJBBNl8glzKVWjzydMi/JXCorMUFnL3I=
X-Google-Smtp-Source: AMrXdXvticf4UQYxlPAwok2rNeBZBmlG+UMosc3ysNBfJc0tpDVZ70h2990Q33vmktGo/xmH6Q8tEd1QME6y4ilqeTQ=
X-Received: by 2002:a05:6512:2821:b0:4b5:5da1:5224 with SMTP id
 cf33-20020a056512282100b004b55da15224mr2100381lfb.106.1672870901453; Wed, 04
 Jan 2023 14:21:41 -0800 (PST)
MIME-Version: 1.0
References: <20230104150642.v2.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
In-Reply-To: <20230104150642.v2.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 4 Jan 2023 14:21:29 -0800
Message-ID: <CABBYNZL9FiZjRYJE_h4n2kf9LKv_5XF3Fd=bz=cU4bTcDR-QHQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
To:     Ying Hsu <yinghsu@chromium.org>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        leon@kernel.org, chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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

Hi Ying,

On Wed, Jan 4, 2023 at 7:07 AM Ying Hsu <yinghsu@chromium.org> wrote:
>
> There's a possible deadlock when two processes are connecting
> and closing a RFCOMM socket concurrently. Here's the call trace:

Are you sure it is 2 different processes? Usually that would mean 2
different sockets (sk) then so they wouldn't share the same lock, so
this sounds more like 2 different threads, perhaps it is worth
creating a testing case in our rfcomm-tester so we are able to detect
this sort of thing in the future.

> -> #2 (&d->lock){+.+.}-{3:3}:
>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>        __mutex_lock0x12f/0x1360 kernel/locking/mutex.c:747
>        __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
>        rfcomm_dlc_close+1e9/0x240 net/bluetooth/rfcomm/core.c:520
>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
>        __sock_release+0xcd/0x280 net/socket.c:650
>        sock_close+0x1c/0x20 net/socket.c:1365
>        __fput+0x27c/0xa90 fs/file_table.c:320
>        task_work_run+0x16f/0x270 kernel/task_work.c:179
>        exit_task_work include/linux/task_work.h:38 [inline]
>        do_exit+0xaa8/0x2950 kernel/exit.c:867
>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> -> #1 (rfcomm_mutex){+.+.}-{3:3}:
>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>        __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
>        rfcomm_dlc_open+0x93/0xa80 net/bluetooth/rfcomm/core.c:425
>        rfcomm_sock_connect+0x329/0x450 net/bluetooth/rfcomm/sock.c:413
>        __sys_connect_file+0x153/0x1a0 net/socket.c:1976
>        __sys_connect+0x165/0x1a0 net/socket.c:1993
>        __do_sys_connect net/socket.c:2003 [inline]
>        __se_sys_connect net/socket.c:2000 [inline]
>        __x64_sys_connect+0x73/0xb0 net/socket.c:2000
>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>        do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3097 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3216 [inline]
>        validate_chain kernel/locking/lockdep.c:3831 [inline]
>        __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
>        lock_acquire kernel/locking/lockdep.c:5668 [inline]
>        lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>        lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
>        lock_sock include/net/sock.h:1725 [inline]
>        rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
>        __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
>        rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
>        __sock_release+0xcd/0x280 net/socket.c:650
>        sock_close+0x1c/0x20 net/socket.c:1365
>        __fput+0x27c/0xa90 fs/file_table.c:320
>        task_work_run+0x16f/0x270 kernel/task_work.c:179
>        exit_task_work include/linux/task_work.h:38 [inline]
>        do_exit+0xaa8/0x2950 kernel/exit.c:867
>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> ---
> This commit has been tested with a C reproducer on qemu-x86_64
> and a ChromeOS device.
>
> Changes in v2:
> - Fix potential use-after-free in rfc_comm_sock_connect.
>
>  net/bluetooth/rfcomm/sock.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> index 21e24da4847f..4397e14ff560 100644
> --- a/net/bluetooth/rfcomm/sock.c
> +++ b/net/bluetooth/rfcomm/sock.c
> @@ -391,6 +391,7 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
>             addr->sa_family != AF_BLUETOOTH)
>                 return -EINVAL;
>
> +       sock_hold(sk);
>         lock_sock(sk);
>
>         if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
> @@ -410,14 +411,18 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
>         d->sec_level = rfcomm_pi(sk)->sec_level;
>         d->role_switch = rfcomm_pi(sk)->role_switch;
>
> +       /* Drop sock lock to avoid potential deadlock with the RFCOMM lock */
> +       release_sock(sk);
>         err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
>                               sa->rc_channel);
> -       if (!err)
> +       lock_sock(sk);
> +       if (!err && !sock_flag(sk, SOCK_ZAPPED))
>                 err = bt_sock_wait_state(sk, BT_CONNECTED,
>                                 sock_sndtimeo(sk, flags & O_NONBLOCK));
>
>  done:
>         release_sock(sk);
> +       sock_put(sk);
>         return err;
>  }

This sounds like a great solution to hold the reference and then
checking if the socket has been zapped when attempting to lock_sock,
so Ive been thinking on generalize this into something like
bt_sock_connect(sock, addr, alen, callback) so we make sure the
callback is done while holding a reference but with the socket
unlocked since typically the underline procedure only needs to access
the pi(sk) information without changing it e.g. rfcomm_dlc_open,
anyway Im fine if you don't want to pursue doing it right now but I'm
afraid these type of locking problem is no restricted to RFCOMM only.

> --
> 2.39.0.314.g84b9a713c41-goog
>


-- 
Luiz Augusto von Dentz
