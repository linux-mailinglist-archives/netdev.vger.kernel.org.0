Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126DF338776
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhCLIdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhCLIdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:33:37 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368C6C061574;
        Fri, 12 Mar 2021 00:33:37 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 16so8972142pgo.13;
        Fri, 12 Mar 2021 00:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XnJggIYcB7bvO5E+r31vh1ptSfkVx+1tzs4d1DijcUk=;
        b=nQ4djR7TmlpqCM8TuI3pDIlRoX/fM843QLW0fr/2q/9IE4P0aNa4wvhkrdpNwES6Ns
         31tQ6bQoRIrddtEj2JaHP/bLXgC8EjyCwe0IWOA0UXBe5TYh/PU4wF7IJg4/tuX4rpJ9
         4M3Qn3XIWfcJRszh+ZVYyppuggwIInvwkohTyTB+bkgREIGxznW0FoA+Bgal8MlTAvAa
         J477/SHD7fSuCnyEK3oj29FQXjaU6G5BDk61GdPcJjy0jibKtuOGkkJMLCOCrM4KVBfY
         WqDywfBdiKz8+1NeMh2tdNJB//BnoAEb3hDx6aRIbU2qNIws6ckyqi/bO4V15OEgLBb1
         Gaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XnJggIYcB7bvO5E+r31vh1ptSfkVx+1tzs4d1DijcUk=;
        b=TVPeaNhWQJGfnf+ufqGXn6ZVTOEx89HTsfXY1cFUwOLA+oyZPaS2lqjuPyj7s9Ytv8
         /NSiuSkzrEY7Q1aFY9/a4zt7BLpJFCLODp0PShUG+C4gqnLz6zApsiT6JTZUX5KzmQta
         3xiQHbi4hNCX7FgdQ8zhgZMDTZ2Ii/ghKUPgl127kKvVfkxu0ZxxeUuEveSEnhd/BPRy
         odb9f+3j5pGPm40bSSBbiqoWEUEvJr8+3FfQpTeyj5tyJdfUR3NSR5tqwUx7RwQ4kgWo
         QYxD2Xkvcuum/I+fEvLESpTmyJd3U6Ztx5d3kdUnJhiVjMAoA7GNf6iUhAjh+tXdbxGN
         E6cA==
X-Gm-Message-State: AOAM5314XbV57SAKenEwGscf4amIqmJPBjAfhA07uEJSLfCHXqjSkmAo
        nbkiogVYbM9vnWxI9c2zFrw=
X-Google-Smtp-Source: ABdhPJwgtpxZivWszUO3jj1kbnv01AeJb4nu+82wck9emisqxOWYv5eE91pqWe46UWT295VfoYY9sg==
X-Received: by 2002:a63:8c0b:: with SMTP id m11mr10683839pgd.306.1615538015799;
        Fri, 12 Mar 2021 00:33:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5186:d796:2218:6442])
        by smtp.gmail.com with ESMTPSA id w1sm4258173pgs.15.2021.03.12.00.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 00:33:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, stable@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Qingyu Li <ieatmuttonchuan@gmail.com>
Subject: [PATCH 4.19-stable 3/3] tcp: add sanity tests to TCP_QUEUE_SEQ
Date:   Fri, 12 Mar 2021 00:33:23 -0800
Message-Id: <20210312083323.3720479-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210312083323.3720479-1-eric.dumazet@gmail.com>
References: <20210312083323.3720479-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8811f4a9836e31c14ecdf79d9f3cb7c5d463265d ]

Qingyu Li reported a syzkaller bug where the repro
changes RCV SEQ _after_ restoring data in the receive queue.

mprotect(0x4aa000, 12288, PROT_READ)    = 0
mmap(0x1ffff000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x1ffff000
mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
mmap(0x21000000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x21000000
socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
setsockopt(3, SOL_TCP, TCP_REPAIR, [1], 4) = 0
connect(3, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28) = 0
setsockopt(3, SOL_TCP, TCP_REPAIR_QUEUE, [1], 4) = 0
sendmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="0x0000000000000003\0\0", iov_len=20}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 20
setsockopt(3, SOL_TCP, TCP_REPAIR, [0], 4) = 0
setsockopt(3, SOL_TCP, TCP_QUEUE_SEQ, [128], 4) = 0
recvfrom(3, NULL, 20, 0, NULL, NULL)    = -1 ECONNRESET (Connection reset by peer)

syslog shows:
[  111.205099] TCP recvmsg seq # bug 2: copied 80, seq 0, rcvnxt 80, fl 0
[  111.207894] WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343 tcp_recvmsg_locked+0x90e/0x29a0

This should not be allowed. TCP_QUEUE_SEQ should only be used
when queues are empty.

This patch fixes this case, and the tx path as well.

Fixes: ee9952831cfd ("tcp: Initial repair mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=212005
Reported-by: Qingyu Li <ieatmuttonchuan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 370faff782cd363e82014969331df459b8188d94..769e1f683471ace151855df8c682c1b784cc59f7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2886,16 +2886,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_QUEUE_SEQ:
-		if (sk->sk_state != TCP_CLOSE)
+		if (sk->sk_state != TCP_CLOSE) {
 			err = -EPERM;
-		else if (tp->repair_queue == TCP_SEND_QUEUE)
-			WRITE_ONCE(tp->write_seq, val);
-		else if (tp->repair_queue == TCP_RECV_QUEUE) {
-			WRITE_ONCE(tp->rcv_nxt, val);
-			WRITE_ONCE(tp->copied_seq, val);
-		}
-		else
+		} else if (tp->repair_queue == TCP_SEND_QUEUE) {
+			if (!tcp_rtx_queue_empty(sk))
+				err = -EPERM;
+			else
+				WRITE_ONCE(tp->write_seq, val);
+		} else if (tp->repair_queue == TCP_RECV_QUEUE) {
+			if (tp->rcv_nxt != tp->copied_seq) {
+				err = -EPERM;
+			} else {
+				WRITE_ONCE(tp->rcv_nxt, val);
+				WRITE_ONCE(tp->copied_seq, val);
+			}
+		} else {
 			err = -EINVAL;
+		}
 		break;
 
 	case TCP_REPAIR_OPTIONS:
-- 
2.31.0.rc2.261.g7f71774620-goog

