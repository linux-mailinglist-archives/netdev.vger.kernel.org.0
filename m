Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376AC3A9E05
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhFPOt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbhFPOt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:49:28 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AC2C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:47:21 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h12so1231189plf.4
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EVQ39BAYs7ilsxm9SZ/I4sOQ+d/CaCJTv9l0aNgfTj4=;
        b=oSKa3+gX8ltmlld0CSljp3wZ5Iv2oeNx5HUSJZ6XH5ZsT16/4dGJgGqW57Jo/HKiJ5
         UxUbg6JTGB8Ad7lK4J63uHMZSyTistha9WC4UpW6Z8N4kHB0gdRjezsV3KgA3Cb/9y6b
         KPr4nfJgSfDrFccrvfaaEFZW094pdBWrjdXq779+jXG+ZmMrch9IKBZiTNlxDaQUYQdh
         6WZbulX7X6CdVlsUXVZUQbIkVtqRbDbCtVEcFYMVca+pbuGpgYwmIZPDSeHzIu+GljR2
         qgOcO9wx6nvJEiY6n+8bpeM3g+iKl4IGluRFpTXaxgx6rRA/ZhnAGEcOv2dH1GfAJMR8
         f0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EVQ39BAYs7ilsxm9SZ/I4sOQ+d/CaCJTv9l0aNgfTj4=;
        b=Q3zkeIvPZ33CCNb8fIJeujG8+WiCWasDfXjtJkDkXZckb9n//2mge8WEb4cebYkZ1J
         XDRr5bgPecqtt/o66zv0vbtjOpEtNLvveXWq/MXO8tArVTABt4rPtvQLgTGXv1GvJfs6
         48dTA3Aaq8v783zqSATuxT7TVzEOHmdIAW/mx1FQxxQiijmEsOvilxuxtfIlAiBBoKYg
         s6DGVVFEA2H0bK9D4bhe79Ui+a9ey3JehU9ZMNn5JDam01VOa0enF5KYrFZ2JPNDqYRV
         8ezVFFb6hqTL/5SPcvEjdgzR6nAnyaOfhABXpte6jilKa9vIEJRI5hyNEDLl4VYi3Lx2
         f4fQ==
X-Gm-Message-State: AOAM532YSnbDhnUPrDG9SKqACf7xTqG2y2Xphi4fu0d7PeNAldAKw/wQ
        9/EeFc3rYxxJYp+pmBYBKvE=
X-Google-Smtp-Source: ABdhPJwwL/+apkGwTRYQzAMnAtoH2p4iGvHURY/4dBNAWJCgeUesP+OOPR6jfrgJeFkrHBoi/F704w==
X-Received: by 2002:a17:902:a5c9:b029:f7:9f7e:aa2f with SMTP id t9-20020a170902a5c9b02900f79f7eaa2fmr9583988plq.54.1623854841202;
        Wed, 16 Jun 2021 07:47:21 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e857:405b:92df:8194])
        by smtp.gmail.com with ESMTPSA id s11sm5807057pjz.42.2021.06.16.07.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 07:47:20 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net/af_unix: fix a  data-race in unix_dgram_sendmsg / unix_release_sock
Date:   Wed, 16 Jun 2021 07:47:15 -0700
Message-Id: <20210616144715.3701428-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While unix_may_send(sk, osk) is called while osk is locked, it appears
unix_release_sock() can overwrite unix_peer() after this lock has been
released, making KCSAN unhappy.

Changing unix_release_sock() to access/change unix_peer()
before lock is released should fix this issue.

BUG: KCSAN: data-race in unix_dgram_sendmsg / unix_release_sock

write to 0xffff88810465a338 of 8 bytes by task 20852 on cpu 1:
 unix_release_sock+0x4ed/0x6e0 net/unix/af_unix.c:558
 unix_release+0x2f/0x50 net/unix/af_unix.c:859
 __sock_release net/socket.c:599 [inline]
 sock_close+0x6c/0x150 net/socket.c:1258
 __fput+0x25b/0x4e0 fs/file_table.c:280
 ____fput+0x11/0x20 fs/file_table.c:313
 task_work_run+0xae/0x130 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x156/0x190 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:302
 do_syscall_64+0x56/0x90 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88810465a338 of 8 bytes by task 20888 on cpu 0:
 unix_may_send net/unix/af_unix.c:189 [inline]
 unix_dgram_sendmsg+0x923/0x1610 net/unix/af_unix.c:1712
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2516
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffff888167905400 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 20888 Comm: syz-executor.0 Not tainted 5.13.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/unix/af_unix.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a31307ceb76df1cf699b161963b92e06300aa2b..5d1192ceb13973ee74cc0f208fb91a36adabc643 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -535,11 +535,13 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	u->path.mnt = NULL;
 	state = sk->sk_state;
 	sk->sk_state = TCP_CLOSE;
-	unix_state_unlock(sk);
-
-	wake_up_interruptible_all(&u->peer_wait);
 
 	skpair = unix_peer(sk);
+	unix_peer(sk) = NULL;
+
+	unix_state_unlock(sk);
+
+	wake_up_interruptible_all(&u->peer_wait);
 
 	if (skpair != NULL) {
 		if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) {
@@ -555,7 +557,6 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 		unix_dgram_peer_wake_disconnect(sk, skpair);
 		sock_put(skpair); /* It may now die */
-		unix_peer(sk) = NULL;
 	}
 
 	/* Try to flush out this socket. Throw out buffers at least */
-- 
2.32.0.272.g935e593368-goog

