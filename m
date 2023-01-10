Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADC4664066
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjAJMZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238440AbjAJMY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:24:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293611159;
        Tue, 10 Jan 2023 04:22:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07396166E;
        Tue, 10 Jan 2023 12:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EC4C433EF;
        Tue, 10 Jan 2023 12:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673353372;
        bh=Bag6ooRcxkpBShQa75AJN0XqDvxoimbaU3KZAnl8lPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bZJ11DHWCBoSZdoti9s/FNEvmnWf1J5xQbkZy6gvf0soDXmRWsh1lVcufxHsMcIsO
         fHwQaiC2wHSc0mtuP/fZhdc8uKiPdUJcSIVhwuLQUdeRRL5Z/EjddhDPsbxxpECfsk
         YFOc22XBG1XRBtGpmNfW+6OjO4NMOJWAEwTFdBQ/D+f8gBnG1K0FKUQJjhCHIxLKju
         7qINU6VbFDKxcOBKgc9UP6M+2xh9j/5z21AR5Xb/2alzslZ8PuXRhoqX0b6MpxDwn8
         vpf1F/OSDDx2iyP1Y/J9WTP4bfDdh5f2iYyKs7t+l/ulgiGI+oPe/MRZmtISvxbTYt
         bNr2ORBNuUC7A==
Date:   Tue, 10 Jan 2023 14:22:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Ying Hsu <yinghsu@chromium.org>, linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix possible deadlock in
 rfcomm_sk_state_change
Message-ID: <Y71Yl8obzOWO/c+p@unreal>
References: <20230103111221.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
 <Y7UiDn3Gi5YdNIoC@unreal>
 <Y7dqKnQe8UUeQ/CD@x130>
 <Y7qXIZNsju8dCzqu@unreal>
 <Y70q4ZsdQNP9GIbF@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y70q4ZsdQNP9GIbF@x130>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 01:07:45AM -0800, Saeed Mahameed wrote:
> On 08 Jan 12:12, Leon Romanovsky wrote:
> > On Thu, Jan 05, 2023 at 04:24:10PM -0800, Saeed Mahameed wrote:
> > > On 04 Jan 08:51, Leon Romanovsky wrote:
> > > > On Tue, Jan 03, 2023 at 11:12:46AM +0000, Ying Hsu wrote:
> > > > > There's a possible deadlock when two processes are connecting
> > > > > and closing concurrently:
> > > > >   + CPU0: __rfcomm_dlc_close locks rfcomm and then calls
> > > > >   rfcomm_sk_state_change which locks the sock.
> > > > >   + CPU1: rfcomm_sock_connect locks the socket and then calls
> > > > >   rfcomm_dlc_open which locks rfcomm.
> > > > >
> > > > > Here's the call trace:
> > > > >
> > > > > -> #2 (&d->lock){+.+.}-{3:3}:
> > > > >        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> > > > >        __mutex_lock0x12f/0x1360 kernel/locking/mutex.c:747
> > > > >        __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
> > > > >        rfcomm_dlc_close+1e9/0x240 net/bluetooth/rfcomm/core.c:520
> > > > >        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> > > > >        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> > > > >        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> > > > >        __sock_release+0xcd/0x280 net/socket.c:650
> > > > >        sock_close+0x1c/0x20 net/socket.c:1365
> > > > >        __fput+0x27c/0xa90 fs/file_table.c:320
> > > > >        task_work_run+0x16f/0x270 kernel/task_work.c:179
> > > > >        exit_task_work include/linux/task_work.h:38 [inline]
> > > > >        do_exit+0xaa8/0x2950 kernel/exit.c:867
> > > > >        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> > > > >        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> > > > >        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> > > > >        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > > > >        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> > > > >        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> > > > >        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> > > > >        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> > > > >        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > >
> > > > > -> #1 (rfcomm_mutex){+.+.}-{3:3}:
> > > > >        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> > > > >        __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
> > > > >        rfcomm_dlc_open+0x93/0xa80 net/bluetooth/rfcomm/core.c:425
> > > > >        rfcomm_sock_connect+0x329/0x450 net/bluetooth/rfcomm/sock.c:413
> > > > >        __sys_connect_file+0x153/0x1a0 net/socket.c:1976
> > > > >        __sys_connect+0x165/0x1a0 net/socket.c:1993
> > > > >        __do_sys_connect net/socket.c:2003 [inline]
> > > > >        __se_sys_connect net/socket.c:2000 [inline]
> > > > >        __x64_sys_connect+0x73/0xb0 net/socket.c:2000
> > > > >        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > > > >        do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> > > > >        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > >
> > > > > -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
> > > > >        check_prev_add kernel/locking/lockdep.c:3097 [inline]
> > > > >        check_prevs_add kernel/locking/lockdep.c:3216 [inline]
> > > > >        validate_chain kernel/locking/lockdep.c:3831 [inline]
> > > > >        __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
> > > > >        lock_acquire kernel/locking/lockdep.c:5668 [inline]
> > > > >        lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
> > > > >        lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
> > > > >        lock_sock include/net/sock.h:1725 [inline]
> > > > >        rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
> > > > >        __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
> > > > >        rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
> > > > >        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> > > > >        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> > > > >        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> > > > >        __sock_release+0xcd/0x280 net/socket.c:650
> > > > >        sock_close+0x1c/0x20 net/socket.c:1365
> > > > >        __fput+0x27c/0xa90 fs/file_table.c:320
> > > > >        task_work_run+0x16f/0x270 kernel/task_work.c:179
> > > > >        exit_task_work include/linux/task_work.h:38 [inline]
> > > > >        do_exit+0xaa8/0x2950 kernel/exit.c:867
> > > > >        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> > > > >        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> > > > >        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> > > > >        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > > > >        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> > > > >        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> > > > >        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> > > > >        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> > > > >        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > >
> > > > > Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> > > > > ---
> > > > > This commit has been tested with a C reproducer on qemu-x86_64.
> > > > >
> > > > >  net/bluetooth/rfcomm/sock.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> > > > > index 21e24da4847f..29f9a88a3dc8 100644
> > > > > --- a/net/bluetooth/rfcomm/sock.c
> > > > > +++ b/net/bluetooth/rfcomm/sock.c
> > > > > @@ -410,8 +410,10 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
> > > > >  	d->sec_level = rfcomm_pi(sk)->sec_level;
> > > > >  	d->role_switch = rfcomm_pi(sk)->role_switch;
> > > > >
> > > > > +	release_sock(sk);
> > > > >  	err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
> > > >                                           ^^^^
> > > > Are you sure that "sk" still exists here after you called to release_sock(sk)?
> > > > What prevents from use-after-free here?
> > > >
> > > 
> > > sk must be valid to be locked in first place.
> > 
> > It is, but after it is released it won't.
> > 
> 
> the code is symmetric: you hold the sk lock then do your thing and then
> release it.
> 
> if you claim that sk can be freed by another process after you released it,
> then due to symmetry it also can be freed before you locked it, unless

So we can extend your logic and say what the lock_sock() in the beginning of
rfcomm_sock_connect() is not needed too.

Thanks
