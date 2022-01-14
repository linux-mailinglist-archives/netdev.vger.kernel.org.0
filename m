Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240EC48EE96
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbiANQnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiANQne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:43:34 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F887C06161C
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:43:34 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so22627765pja.1
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jWSBrjiB8CwiZ4auWO392RxKDunHZKFvs+KUiVQXrG4=;
        b=DQZGi6h9UDcCKic1hDsx15t5/VGP9PvcC+DjXKcgj0qoTtQ7p8MREc9+r11/CoCioI
         +fHedKN6yvCQ9auIn0M8tS2skdQyC1zZe0QXM9633uHAdwUQb2Ixt3W/2/MiuTOzoZyB
         IEumR88KfSxrla9guQ/haUbFGC94FHSUrwz7DOQOsa9RQwZ4j6RlJYmPt9xPStqHuhPy
         r5Z6MShJEA2qjTvYtHnmjNh13ObcS6BpP4uYPUkmP/HY1Qv21bRvFago0UuefrT8K62T
         tsdPDz/IjgrhUA7YE8+RV0+Na8QuqUzykrhRERT7XHKRFR3KO4F0RacIOc1qGSRfArmE
         AGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jWSBrjiB8CwiZ4auWO392RxKDunHZKFvs+KUiVQXrG4=;
        b=U4AAmjqm62bq5Hxz6OtOpa+YiTxlXhOiGwfb+B6IReRkTDBrHyDPUrS9VuomjPW3S+
         SMBB468tlchIw7zFwGLWowJ88qFpznHRcOULakk2swoBOipZP5CQ9YmaCYSBQhq71OAr
         loexumKkiOKcgowN26Zy8VgPgVuMHYy1z0+sUD4/Qi4u4iJ9GUjW8MkISs9Xp/qZ4Y38
         HGMvQpczaTDlwiTIbgv6S6JmOUa2Xnr8j7Mm9S402hVfIsWWf7c8/HthlUeBt7tyjINc
         /8FPRUcbAXqonoFV0IwFr8FZyovalYPGa8se/uOM5x33e8ttxdXOa/pnjYfPxoOGn3dB
         GaSw==
X-Gm-Message-State: AOAM530iRmVSH4+TRFfeijqt5uSPKEt8ngTgYTjsSsVx8W/lf+wsyNGs
        VPNMYxhHbQvxPogsHAxlyvDzPf3sy/pw3A==
X-Google-Smtp-Source: ABdhPJycIxSw6XGaqW+Kz1435VEjXbUaeSixd3rcVnUm9m55eshVA0P2Tsgdhy2gQduQ30oCL40teg==
X-Received: by 2002:a17:90a:bf0c:: with SMTP id c12mr11632454pjs.157.1642178614189;
        Fri, 14 Jan 2022 08:43:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f20:3e1b:6f78:eebe])
        by smtp.gmail.com with ESMTPSA id i23sm4988485pgi.92.2022.01.14.08.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:43:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
Date:   Fri, 14 Jan 2022 08:43:28 -0800
Message-Id: <20220114164328.2038499-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

wait_for_unix_gc() reads unix_tot_inflight & gc_in_progress
without synchronization.

Adds READ_ONCE()/WRITE_ONCE() and their associated comments
to better document the intent.

BUG: KCSAN: data-race in unix_inflight / wait_for_unix_gc

write to 0xffffffff86e2b7c0 of 4 bytes by task 9380 on cpu 0:
 unix_inflight+0x1e8/0x260 net/unix/scm.c:63
 unix_attach_fds+0x10c/0x1e0 net/unix/scm.c:121
 unix_scm_to_skb net/unix/af_unix.c:1674 [inline]
 unix_dgram_sendmsg+0x679/0x16b0 net/unix/af_unix.c:1817
 unix_seqpacket_sendmsg+0xcc/0x110 net/unix/af_unix.c:2258
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffffffff86e2b7c0 of 4 bytes by task 9375 on cpu 1:
 wait_for_unix_gc+0x24/0x160 net/unix/garbage.c:196
 unix_dgram_sendmsg+0x8e/0x16b0 net/unix/af_unix.c:1772
 unix_seqpacket_sendmsg+0xcc/0x110 net/unix/af_unix.c:2258
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000002 -> 0x00000004

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 9375 Comm: syz-executor.1 Not tainted 5.16.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 9915672d4127 ("af_unix: limit unix_tot_inflight")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/unix/garbage.c | 14 +++++++++++---
 net/unix/scm.c     |  6 ++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 12e2ddaf887f204a091f157905f270046fc384a6..d45d5366115a769b21bfc1db5a67f7d53c3fa9b8 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -192,8 +192,11 @@ void wait_for_unix_gc(void)
 {
 	/* If number of inflight sockets is insane,
 	 * force a garbage collect right now.
+	 * Paired with the WRITE_ONCE() in unix_inflight(),
+	 * unix_notinflight() and gc_in_progress().
 	 */
-	if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
+	if (READ_ONCE(unix_tot_inflight) > UNIX_INFLIGHT_TRIGGER_GC &&
+	    !READ_ONCE(gc_in_progress))
 		unix_gc();
 	wait_event(unix_gc_wait, gc_in_progress == false);
 }
@@ -213,7 +216,9 @@ void unix_gc(void)
 	if (gc_in_progress)
 		goto out;
 
-	gc_in_progress = true;
+	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
+	WRITE_ONCE(gc_in_progress, true);
+
 	/* First, select candidates for garbage collection.  Only
 	 * in-flight sockets are considered, and from those only ones
 	 * which don't have any external reference.
@@ -299,7 +304,10 @@ void unix_gc(void)
 
 	/* All candidates should have been detached by now. */
 	BUG_ON(!list_empty(&gc_candidates));
-	gc_in_progress = false;
+
+	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
+	WRITE_ONCE(gc_in_progress, false);
+
 	wake_up(&unix_gc_wait);
 
  out:
diff --git a/net/unix/scm.c b/net/unix/scm.c
index 052ae709ce2899e74ebb005d8886e42ccbf8b849..aa27a02478dc1a7e4022f77e6ea7ac55f40b95c7 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -60,7 +60,8 @@ void unix_inflight(struct user_struct *user, struct file *fp)
 		} else {
 			BUG_ON(list_empty(&u->link));
 		}
-		unix_tot_inflight++;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
 	}
 	user->unix_inflight++;
 	spin_unlock(&unix_gc_lock);
@@ -80,7 +81,8 @@ void unix_notinflight(struct user_struct *user, struct file *fp)
 
 		if (atomic_long_dec_and_test(&u->inflight))
 			list_del_init(&u->link);
-		unix_tot_inflight--;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
 	}
 	user->unix_inflight--;
 	spin_unlock(&unix_gc_lock);
-- 
2.34.1.703.g22d0c6ccf7-goog

