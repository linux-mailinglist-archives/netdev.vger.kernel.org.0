Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEE765BEBA
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 12:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbjACLM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 06:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbjACLMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 06:12:54 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8707D5FC8
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 03:12:53 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z7so14616848pfq.13
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 03:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zV1fKa5X+fJOsn4eYW6XzdvCXBtHTAKTAI3MhIsCmO4=;
        b=SGzEEFR+GoTUobK0+7F9Kmyzh1nbOZpcTxLxEGTAPc5W/w0fxNKhwo1nh6zq/xemqV
         ZGZ88mIku/BfHh17O2Wgn6emQ2eBVdJ7cGebWAzFiwJ/o4ao/6HOwZOhOU1B0b+ZVck9
         37oxkqjsaL9GRNItnkGyo48OeswFAI+ihuNgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zV1fKa5X+fJOsn4eYW6XzdvCXBtHTAKTAI3MhIsCmO4=;
        b=2+NLixzT1CSjFHOXEhIhbfIJOoxjHK61XUkwoKeSZug9wsCQK9WONjNjGK5s/S4q/A
         ltSmL3Riyl5hK0IvKrUiYVK9xjNL2rWfzOiN3oFnz/g19vGju+YsAbKCW74mdatjKZid
         Wr2h7Boh0MnFlnuanC5poevLiEJmwWxCxBcyKcjOUuWv9cFygua59usz7R91RoWFZqQy
         PZq0iq+FtjW/YTub5fqkK15kC5GEsBw66dwQHcrUsb28REXRjjSh1JHnHmPDntlH8JwZ
         kXAx0If6+0mtDuZ9FVdK6QMjEEMxi6A6Jsmw67y/X1E8x4Yh3fSe3nGYWr7T3O6j4Ulg
         08fg==
X-Gm-Message-State: AFqh2koL8oziZ5laGQ7tfRpSZRTMPbJWRxgf+IbYc6MSQyfS2W1PvGKT
        Pkb/cy1wejFeEbcXTYptVTcWahUXrBTZ2PTW
X-Google-Smtp-Source: AMrXdXvsFr/twvKjLq5UpMvFhw7+7+tn3FPr9WEIq3WQJd/RgAMu6NwsTl3OZzqe1dl8lc45CCUSPw==
X-Received: by 2002:a05:6a00:84c:b0:581:1ee0:75a with SMTP id q12-20020a056a00084c00b005811ee0075amr36871808pfk.32.1672744373075;
        Tue, 03 Jan 2023 03:12:53 -0800 (PST)
Received: from localhost (21.160.199.104.bc.googleusercontent.com. [104.199.160.21])
        by smtp.gmail.com with UTF8SMTPSA id k187-20020a6284c4000000b005769b23260fsm20829792pfd.18.2023.01.03.03.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 03:12:52 -0800 (PST)
From:   Ying Hsu <yinghsu@chromium.org>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Ying Hsu <yinghsu@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
Date:   Tue,  3 Jan 2023 11:12:46 +0000
Message-Id: <20230103111221.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a possible deadlock when two processes are connecting
and closing concurrently:
  + CPU0: __rfcomm_dlc_close locks rfcomm and then calls
  rfcomm_sk_state_change which locks the sock.
  + CPU1: rfcomm_sock_connect locks the socket and then calls
  rfcomm_dlc_open which locks rfcomm.

Here's the call trace:

-> #2 (&d->lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock0x12f/0x1360 kernel/locking/mutex.c:747
       __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
       rfcomm_dlc_close+1e9/0x240 net/bluetooth/rfcomm/core.c:520
       __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
       rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
       rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
       __sock_release+0xcd/0x280 net/socket.c:650
       sock_close+0x1c/0x20 net/socket.c:1365
       __fput+0x27c/0xa90 fs/file_table.c:320
       task_work_run+0x16f/0x270 kernel/task_work.c:179
       exit_task_work include/linux/task_work.h:38 [inline]
       do_exit+0xaa8/0x2950 kernel/exit.c:867
       do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
       get_signal+0x21c3/0x2450 kernel/signal.c:2859
       arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
       exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
       exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
       __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
       syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
       do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #1 (rfcomm_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
       rfcomm_dlc_open+0x93/0xa80 net/bluetooth/rfcomm/core.c:425
       rfcomm_sock_connect+0x329/0x450 net/bluetooth/rfcomm/sock.c:413
       __sys_connect_file+0x153/0x1a0 net/socket.c:1976
       __sys_connect+0x165/0x1a0 net/socket.c:1993
       __do_sys_connect net/socket.c:2003 [inline]
       __se_sys_connect net/socket.c:2000 [inline]
       __x64_sys_connect+0x73/0xb0 net/socket.c:2000
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
       lock_acquire kernel/locking/lockdep.c:5668 [inline]
       lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
       lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
       lock_sock include/net/sock.h:1725 [inline]
       rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
       __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
       rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
       __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
       rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
       rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
       __sock_release+0xcd/0x280 net/socket.c:650
       sock_close+0x1c/0x20 net/socket.c:1365
       __fput+0x27c/0xa90 fs/file_table.c:320
       task_work_run+0x16f/0x270 kernel/task_work.c:179
       exit_task_work include/linux/task_work.h:38 [inline]
       do_exit+0xaa8/0x2950 kernel/exit.c:867
       do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
       get_signal+0x21c3/0x2450 kernel/signal.c:2859
       arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
       exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
       exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
       __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
       syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
       do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

Signed-off-by: Ying Hsu <yinghsu@chromium.org>
---
This commit has been tested with a C reproducer on qemu-x86_64.

 net/bluetooth/rfcomm/sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 21e24da4847f..29f9a88a3dc8 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -410,8 +410,10 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
 	d->sec_level = rfcomm_pi(sk)->sec_level;
 	d->role_switch = rfcomm_pi(sk)->role_switch;
 
+	release_sock(sk);
 	err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
 			      sa->rc_channel);
+	lock_sock(sk);
 	if (!err)
 		err = bt_sock_wait_state(sk, BT_CONNECTED,
 				sock_sndtimeo(sk, flags & O_NONBLOCK));
-- 
2.39.0.314.g84b9a713c41-goog

