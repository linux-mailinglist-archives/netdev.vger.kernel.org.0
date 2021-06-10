Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDFD3A2E25
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhFJO3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhFJO3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:29:49 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3A8C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:27:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ei4so3755818pjb.3
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4MviCyqV/hihMVnK+sdYvqNaJRCcQXA4li4y0W2ETi4=;
        b=Gv3qQgDxznHwcnt4220s30WWpl94OrYDJw6hDwTuzpCF76SLPIqveX6UrNkumUM0y9
         6GIq7N6qlBh1qjyRX3HUWo798jiacdgQvyPVPtnLbLcS/NjcDZf81Kkk9m1+JDE/UGKM
         uI2DvFsX9sfUiFWMPtLbNEXFjOeKu3CEaxNcpSsonnYLfiNJG/9Fz2pgiGqhY8l/9gpN
         Z73WTWv7x/yOUop/fb2kHKQhfRyTR00Q0gzxkMm18FPT9MEsFHqkqiy88lLk/KOUtJGP
         dQkBBNBm+gp+RGkErrCwRRXOID+Gr6FkqH6GADZZc8GttsRH7Wy3ev9NS7AQFJ8RNJNh
         6leA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4MviCyqV/hihMVnK+sdYvqNaJRCcQXA4li4y0W2ETi4=;
        b=nGLaV/JO00NrRswGfH05/87YrePXle1LBO4945sDb5fgihWh4HuNgsywjAzbITgUC7
         93RVF7iP6fXWYuq43eIsPvL5ufF8zJABeRTzre6LPEI4rqCZ+UHSgpdujVuc1tFX2tAr
         bZlfd4iFBHchhc9T0ZWN0c9TR76ZTNbQ4I3RVr9y3mEDgtme5vutSpb0c3eAg/tPr5YV
         mxjT2w+rVuqIJy6qq50U7Y9/MivSfiEoW73fMoeQT+LargkKrpPt61layZ6VINdiy1sl
         M5h4hsQYpsDMXA+HCPzm58Ii6rWc59cEuzQ4VG7gu0ajZZ2KKMhlU2yeaIysoZv0xgGM
         0dfw==
X-Gm-Message-State: AOAM532XzhxNWc9SHHw65bNYldpL45XO7hIC2vhsrghFXjXSBUwCw8vN
        uOEMRTQHdx+4EtVYNu3sRhc=
X-Google-Smtp-Source: ABdhPJxTLcSiL64XgnCrZiuwctzDWGrOz/Rn2H3RtDDxJDbCocHuCJTAyVGpq1B/c4Cg9bF46ZdBJQ==
X-Received: by 2002:a17:902:b713:b029:fd:8738:63cb with SMTP id d19-20020a170902b713b02900fd873863cbmr4935147pls.28.1623335261775;
        Thu, 10 Jun 2021 07:27:41 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6f4:90b5:5614:38a0])
        by smtp.gmail.com with ESMTPSA id ip7sm2499640pjb.39.2021.06.10.07.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 07:27:41 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: annotate data race in sock_error()
Date:   Thu, 10 Jun 2021 07:27:37 -0700
Message-Id: <20210610142737.1350210-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sock_error() is known to be racy. The code avoids
an atomic operation is sk_err is zero, and this field
could be changed under us, this is fine.

Sysbot reported:

BUG: KCSAN: data-race in sock_alloc_send_pskb / unix_release_sock

write to 0xffff888131855630 of 4 bytes by task 9365 on cpu 1:
 unix_release_sock+0x2e9/0x6e0 net/unix/af_unix.c:550
 unix_release+0x2f/0x50 net/unix/af_unix.c:859
 __sock_release net/socket.c:599 [inline]
 sock_close+0x6c/0x150 net/socket.c:1258
 __fput+0x25b/0x4e0 fs/file_table.c:280
 ____fput+0x11/0x20 fs/file_table.c:313
 task_work_run+0xae/0x130 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x156/0x190 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
 do_syscall_64+0x56/0x90 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888131855630 of 4 bytes by task 9385 on cpu 0:
 sock_error include/net/sock.h:2269 [inline]
 sock_alloc_send_pskb+0xe4/0x4e0 net/core/sock.c:2336
 unix_dgram_sendmsg+0x478/0x1610 net/unix/af_unix.c:1671
 unix_seqpacket_sendmsg+0xc2/0x100 net/unix/af_unix.c:2055
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 __sys_sendmsg_sock+0x25/0x30 net/socket.c:2416
 io_sendmsg fs/io_uring.c:4367 [inline]
 io_issue_sqe+0x231a/0x6750 fs/io_uring.c:6135
 __io_queue_sqe+0xe9/0x360 fs/io_uring.c:6414
 __io_req_task_submit fs/io_uring.c:2039 [inline]
 io_async_task_func+0x312/0x590 fs/io_uring.c:5074
 __tctx_task_work fs/io_uring.c:1910 [inline]
 tctx_task_work+0x1d4/0x3d0 fs/io_uring.c:1924
 task_work_run+0xae/0x130 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:145 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xf8/0x190 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
 do_syscall_64+0x56/0x90 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x00000068

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 9385 Comm: syz-executor.3 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/sock.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 0e962d8bc73b1ce5a38ca1f64c6489f94ab587e4..2fc513aa114c0f4bd7554ca08655d0daf63f4544 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2266,8 +2266,13 @@ struct sk_buff *sock_dequeue_err_skb(struct sock *sk);
 static inline int sock_error(struct sock *sk)
 {
 	int err;
-	if (likely(!sk->sk_err))
+
+	/* Avoid an atomic operation for the common case.
+	 * This is racy since another cpu/thread can change sk_err under us.
+	 */
+	if (likely(data_race(!sk->sk_err)))
 		return 0;
+
 	err = xchg(&sk->sk_err, 0);
 	return -err;
 }
-- 
2.32.0.rc1.229.g3e70b5a671-goog

