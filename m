Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2470065D6DD
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbjADPHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbjADPHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:07:23 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8BD1706B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:07:21 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id c2-20020a17090a020200b00226c762ed23so88373pjc.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 07:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PKEgnyMFwcgXk2aMsB6+O7Pav/CXcn/a1bbl0p4KdeE=;
        b=ZThp9cDYo0RcqzGNHuox72sutY4mSPfjzqeP0zFU0gendX9FC+UYl2mBH1WLfwh4+H
         +WftiO1in1+fMZrImQ3GlQ2KLNQXt1GSzCifjXORCQmWudmc2US1fEyP46wTEublqNB5
         ZgsMNhf6VcvwEQyWG+YZA0jbxjvIRgrziCewk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PKEgnyMFwcgXk2aMsB6+O7Pav/CXcn/a1bbl0p4KdeE=;
        b=D1Pp6Sh9hAOGN105ysXUL0qBXbHLScGpTPPMVv57mYecQ/uQQPfanAPGC/6ACHRel5
         L7wgUxBEFnNuXv2Tce6Zbjb0d/jnjIABHWghE5PVSlyjxZVKx+PHgUu3E03MVXilZ0/7
         uA00Dh10GfZoxH5e7cYrdrJQsFSC8Q9sPjfkMUG5Bzhzi0tNRIYtpG8I6QGplUYkHevT
         AIDrzz9jDa/D+eLLnz/JSm9086FKyateNP04i+9ASGmtRouW5w0Vg/5Z9c37HyMoOziN
         gkam+oMU5eiW2iRh9fI4JUg6yP+X2lwMMolEqRSqkYlh3LPFd20SW35RoXW6kTlZo8Fr
         uH+A==
X-Gm-Message-State: AFqh2kogsJ0/Yjk7pJCYNMWxpEkH2KMfKNMgCdvY3l3RKKVIHAT+pGeV
        y55oVa/JX3pWqcNJZj3sq8yBSA==
X-Google-Smtp-Source: AMrXdXsc2/xGMSPne4LohlL4RiBczdcrR/6eEz5BBnK2pG8Tqd64LQTPAPlrneexzuG2cct5/RfJOw==
X-Received: by 2002:a05:6a21:869f:b0:af:98cd:846a with SMTP id ox31-20020a056a21869f00b000af98cd846amr52100745pzb.30.1672844840952;
        Wed, 04 Jan 2023 07:07:20 -0800 (PST)
Received: from localhost (21.160.199.104.bc.googleusercontent.com. [104.199.160.21])
        by smtp.gmail.com with UTF8SMTPSA id h6-20020a63c006000000b00478b930f970sm20262786pgg.66.2023.01.04.07.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 07:07:20 -0800 (PST)
From:   Ying Hsu <yinghsu@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        leon@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Ying Hsu <yinghsu@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
Date:   Wed,  4 Jan 2023 15:07:11 +0000
Message-Id: <20230104150642.v2.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a possible deadlock when two processes are connecting
and closing a RFCOMM socket concurrently. Here's the call trace:

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
This commit has been tested with a C reproducer on qemu-x86_64
and a ChromeOS device.

Changes in v2:
- Fix potential use-after-free in rfc_comm_sock_connect.

 net/bluetooth/rfcomm/sock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 21e24da4847f..4397e14ff560 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -391,6 +391,7 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
+	sock_hold(sk);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
@@ -410,14 +411,18 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
 	d->sec_level = rfcomm_pi(sk)->sec_level;
 	d->role_switch = rfcomm_pi(sk)->role_switch;
 
+	/* Drop sock lock to avoid potential deadlock with the RFCOMM lock */
+	release_sock(sk);
 	err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
 			      sa->rc_channel);
-	if (!err)
+	lock_sock(sk);
+	if (!err && !sock_flag(sk, SOCK_ZAPPED))
 		err = bt_sock_wait_state(sk, BT_CONNECTED,
 				sock_sndtimeo(sk, flags & O_NONBLOCK));
 
 done:
 	release_sock(sk);
+	sock_put(sk);
 	return err;
 }
 
-- 
2.39.0.314.g84b9a713c41-goog

