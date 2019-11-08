Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D47F3E34
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfKHCtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:49:47 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52680 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfKHCtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 21:49:47 -0500
Received: by mail-pf1-f202.google.com with SMTP id 20so3601452pfp.19
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 18:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qem1my0WgkzGO9F5JA4eXGeQAETzRGVR+69w0STbjVk=;
        b=QDYnLFjfJtffW0oBJtTSOTe6R0nfcq1tAx6+mbWCazZiaClgPozWHqjiZuPlm/eekk
         ZuctlDi8eFp7JZLGsfvsECpiBhyRSG42vXT2PcD4ckoXibpWSvcwzLQ+d+PyOQ0L1i/S
         QVqWAK6zFofGmJhnnTmhEclAunHPV3cyquVqaDliYgHfpGKdyst9CUVdKcAJzvjQMjPF
         4j2qYJOZX3JT5sI0WP1IaSTzt4ZFMPuSzI/2JSWtPwawIr9DusLGoCkPPbvpnyvZkCs4
         87J8d7Ra9fKOHT1K5NXiDRyJ6j+qYkkX0QUth/hjSPKZ6GyOQa2C/vZQh7/Rzf9cCJKS
         T1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qem1my0WgkzGO9F5JA4eXGeQAETzRGVR+69w0STbjVk=;
        b=ANVPdKo11Zp6TzIJeTpZ6krUWH6tMD+KTqcUGTxR8HzLhT4RhTJ5eU/q1LoWR0SEWl
         0hWAgXmhQgkAYi9eCvURf+SorAZzVntorB0PJ8f5QUn7+bSq81tNQlT018J4tKFhjZ2D
         z4RTYpLD80PtCgKk3/iIPU45o2kaWMwHnUQ9b4vrue9gybobuZZT8MkcOeh3Eq4uLAOR
         imIKv6LfD2sk7dd7IGYoMEHVm1BVkCYnlhybCVqWCkd78erh2R/UABNecXwA/7WnLtVZ
         0D5cTwh0VrxKbRYx9keHg9/gnFMzevwPSnZolnZNa7bWzG7bzeIAnEl5TrQDtfHmUw4V
         19Pw==
X-Gm-Message-State: APjAAAUUOAm1u31k3pDQfRYWzIW4rHiHchE4g7DzziMwdl66xOmtdgAy
        OnDVM3ZwGeA07qPR1w+1oRdW54gQbrf8cQ==
X-Google-Smtp-Source: APXvYqx/GAas44vJVhE7eZhgNAmAAsZ5x2yDXrvV6YtJvGDeysb5JwPfZsp1OknAjllxylIWKONpS+GQ1AYkCw==
X-Received: by 2002:a63:d0f:: with SMTP id c15mr8864380pgl.313.1573181386253;
 Thu, 07 Nov 2019 18:49:46 -0800 (PST)
Date:   Thu,  7 Nov 2019 18:49:43 -0800
Message-Id: <20191108024943.225900-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] net: add a READ_ONCE() in skb_peek_tail()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_peek_tail() can be used without protection of a lock,
as spotted by KCSAN [1]

In order to avoid load-stearing, add a READ_ONCE()

Note that the corresponding WRITE_ONCE() are already there.

[1]
BUG: KCSAN: data-race in sk_wait_data / skb_queue_tail

read to 0xffff8880b36a4118 of 8 bytes by task 20426 on cpu 1:
 skb_peek_tail include/linux/skbuff.h:1784 [inline]
 sk_wait_data+0x15b/0x250 net/core/sock.c:2477
 kcm_wait_data+0x112/0x1f0 net/kcm/kcmsock.c:1103
 kcm_recvmsg+0xac/0x320 net/kcm/kcmsock.c:1130
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 ___sys_recvmsg+0x1a0/0x3e0 net/socket.c:2480
 do_recvmmsg+0x19a/0x5c0 net/socket.c:2601
 __sys_recvmmsg+0x1ef/0x200 net/socket.c:2680
 __do_sys_recvmmsg net/socket.c:2703 [inline]
 __se_sys_recvmmsg net/socket.c:2696 [inline]
 __x64_sys_recvmmsg+0x89/0xb0 net/socket.c:2696
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880b36a4118 of 8 bytes by task 451 on cpu 0:
 __skb_insert include/linux/skbuff.h:1852 [inline]
 __skb_queue_before include/linux/skbuff.h:1958 [inline]
 __skb_queue_tail include/linux/skbuff.h:1991 [inline]
 skb_queue_tail+0x7e/0xc0 net/core/skbuff.c:3145
 kcm_queue_rcv_skb+0x202/0x310 net/kcm/kcmsock.c:206
 kcm_rcv_strparser+0x74/0x4b0 net/kcm/kcmsock.c:370
 __strp_recv+0x348/0xf50 net/strparser/strparser.c:309
 strp_recv+0x84/0xa0 net/strparser/strparser.c:343
 tcp_read_sock+0x174/0x5c0 net/ipv4/tcp.c:1639
 strp_read_sock+0xd4/0x140 net/strparser/strparser.c:366
 do_strp_work net/strparser/strparser.c:414 [inline]
 strp_work+0x9a/0xe0 net/strparser/strparser.c:423
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 451 Comm: kworker/u4:3 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: kstrp strp_work

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/linux/skbuff.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 53238ac725a326a1f9c41f915c51b1e9cfdb0217..dfe02b658829d93b297fee0249c5997b3c10465b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1795,7 +1795,7 @@ static inline struct sk_buff *skb_peek_next(struct sk_buff *skb,
  */
 static inline struct sk_buff *skb_peek_tail(const struct sk_buff_head *list_)
 {
-	struct sk_buff *skb = list_->prev;
+	struct sk_buff *skb = READ_ONCE(list_->prev);
 
 	if (skb == (struct sk_buff *)list_)
 		skb = NULL;
@@ -1861,7 +1861,9 @@ static inline void __skb_insert(struct sk_buff *newsk,
 				struct sk_buff *prev, struct sk_buff *next,
 				struct sk_buff_head *list)
 {
-	/* see skb_queue_empty_lockless() for the opposite READ_ONCE() */
+	/* See skb_queue_empty_lockless() and skb_peek_tail()
+	 * for the opposite READ_ONCE()
+	 */
 	WRITE_ONCE(newsk->next, next);
 	WRITE_ONCE(newsk->prev, prev);
 	WRITE_ONCE(next->prev, newsk);
-- 
2.24.0.432.g9d3f5f5b63-goog

