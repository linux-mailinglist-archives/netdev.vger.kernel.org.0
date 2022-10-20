Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FC4606B7B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiJTWpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJTWpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:45:24 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25C2F4196
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:45:19 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 22-20020ac85756000000b0039cf0d41e2cso639474qtx.13
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MJVY2U/gLkRLqk7c9Krx7oI5gjbx3/ytC15tm+5mQZA=;
        b=qNP1zcNv3HZIG2nRpRwJ7LGD0VEG/zVjtw4nEFcsze+M7V03JYsZcAZ38BvRtSqQsU
         K3oYxP8ATCTE7pZD4kULaGZ+6pVtW/xiImmUjmpliMHvxFHFTyl+YOl8SgaSgKuQckvi
         8wofhDkzOFzM8icT6gHHaWyNyz7zk54MfoZeKdaRZOORSLqbwuD7u2nKRwehEjwEg/l+
         BvV1IsI8DilGjTG1QTCNqb87FqcBthnl34A1X2dQ+8UXiCsr7lmmQJ7FykS7dOXZQ/K/
         CDSEaVPNm1orQ0T1zYWRcxIxL0p8wBgm8nuqa59heIOFei9Gv/aUrJE9QR2zXbj1TkKT
         1Wsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJVY2U/gLkRLqk7c9Krx7oI5gjbx3/ytC15tm+5mQZA=;
        b=sRSVEHYGTBMYxFAovUkWh7vlK8ZrIXpNCUZwbmlEozdPvHo1aLsmTQ3V85Nh1GQNYH
         2JSy9TG6VRHsrLgMf/hQ46UTpYizxr3E9G0kHbiPn7ToPbU+2X3xmokVW0JK6SwezJx7
         AHiU2r9NYUi+Alnvu8hFgC6NmIYZ4sBEX+5HsBDbR/0LKagX9axzwbxieg3tiQA0ALh+
         79L/8R/SGr1/0FMz04GK5hvf1ovpRoSnhwcsOy3Bu2wLv/q/Kx07i4gx6I5AKyhRisQR
         hwX44ris/q0DnucexI7QA5ZYNJNa3O28gxWUtYCwfXqP6oEsAMgiR2DMrZrMP8uPX+LF
         94SA==
X-Gm-Message-State: ACrzQf0GlH/ENfW5dysGbPgnbE06/UnAYdF1u8TaHj39kmFVSD5lrzm3
        jSVRiTBvmnN2/YDr+l0ojgCYLbL5HlErmQ==
X-Google-Smtp-Source: AMsMyM4bVA1XhvKyLbbVpTX+OF+57gKeo5MU4Pqy91wUFM+Pv9mCRkdJwPHJgy4uTxlLxvGQaZCCJukCyP4j6w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6214:1c0c:b0:4b1:d2fe:7ad4 with SMTP
 id u12-20020a0562141c0c00b004b1d2fe7ad4mr13904090qvc.128.1666305918606; Thu,
 20 Oct 2022 15:45:18 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:45:12 +0000
In-Reply-To: <20221020224512.3211657-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221020224512.3211657-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221020224512.3211657-3-edumazet@google.com>
Subject: [PATCH net 2/2] kcm: annotate data-races around kcm->rx_wait
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kcm->rx_psock can be read locklessly in kcm_rfree().
Annotate the read and writes accordingly.

syzbot reported:

BUG: KCSAN: data-race in kcm_rcv_strparser / kcm_rfree

write to 0xffff88810784e3d0 of 1 bytes by task 1823 on cpu 1:
reserve_rx_kcm net/kcm/kcmsock.c:283 [inline]
kcm_rcv_strparser+0x250/0x3a0 net/kcm/kcmsock.c:363
__strp_recv+0x64c/0xd20 net/strparser/strparser.c:301
strp_recv+0x6d/0x80 net/strparser/strparser.c:335
tcp_read_sock+0x13e/0x5a0 net/ipv4/tcp.c:1703
strp_read_sock net/strparser/strparser.c:358 [inline]
do_strp_work net/strparser/strparser.c:406 [inline]
strp_work+0xe8/0x180 net/strparser/strparser.c:415
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

read to 0xffff88810784e3d0 of 1 bytes by task 17869 on cpu 0:
kcm_rfree+0x121/0x220 net/kcm/kcmsock.c:181
skb_release_head_state+0x8e/0x160 net/core/skbuff.c:841
skb_release_all net/core/skbuff.c:852 [inline]
__kfree_skb net/core/skbuff.c:868 [inline]
kfree_skb_reason+0x5c/0x260 net/core/skbuff.c:891
kfree_skb include/linux/skbuff.h:1216 [inline]
kcm_recvmsg+0x226/0x2b0 net/kcm/kcmsock.c:1161
____sys_recvmsg+0x16c/0x2e0
___sys_recvmsg net/socket.c:2743 [inline]
do_recvmmsg+0x2f1/0x710 net/socket.c:2837
__sys_recvmmsg net/socket.c:2916 [inline]
__do_sys_recvmmsg net/socket.c:2939 [inline]
__se_sys_recvmmsg net/socket.c:2932 [inline]
__x64_sys_recvmmsg+0xde/0x160 net/socket.c:2932
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x01 -> 0x00

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 17869 Comm: syz-executor.2 Not tainted 6.1.0-rc1-syzkaller-00010-gbb1a1146467a-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/kcm/kcmsock.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 0109ef6ddf9aed853a6cf1fb69e330fd8bc6654a..63e32f181f435334530c42e54c7a36e8e993104b 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -162,7 +162,8 @@ static void kcm_rcv_ready(struct kcm_sock *kcm)
 	/* Buffer limit is okay now, add to ready list */
 	list_add_tail(&kcm->wait_rx_list,
 		      &kcm->mux->kcm_rx_waiters);
-	kcm->rx_wait = true;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, true);
 }
 
 static void kcm_rfree(struct sk_buff *skb)
@@ -178,7 +179,7 @@ static void kcm_rfree(struct sk_buff *skb)
 	/* For reading rx_wait and rx_psock without holding lock */
 	smp_mb__after_atomic();
 
-	if (!kcm->rx_wait && !READ_ONCE(kcm->rx_psock) &&
+	if (!READ_ONCE(kcm->rx_wait) && !READ_ONCE(kcm->rx_psock) &&
 	    sk_rmem_alloc_get(sk) < sk->sk_rcvlowat) {
 		spin_lock_bh(&mux->rx_lock);
 		kcm_rcv_ready(kcm);
@@ -237,7 +238,8 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 		if (kcm_queue_rcv_skb(&kcm->sk, skb)) {
 			/* Should mean socket buffer full */
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 
 			/* Commit rx_wait to read in kcm_free */
 			smp_wmb();
@@ -280,7 +282,8 @@ static struct kcm_sock *reserve_rx_kcm(struct kcm_psock *psock,
 	kcm = list_first_entry(&mux->kcm_rx_waiters,
 			       struct kcm_sock, wait_rx_list);
 	list_del(&kcm->wait_rx_list);
-	kcm->rx_wait = false;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, false);
 
 	psock->rx_kcm = kcm;
 	/* paired with lockless reads in kcm_rfree() */
@@ -1242,7 +1245,8 @@ static void kcm_recv_disable(struct kcm_sock *kcm)
 	if (!kcm->rx_psock) {
 		if (kcm->rx_wait) {
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 		}
 
 		requeue_rx_msgs(mux, &kcm->sk.sk_receive_queue);
@@ -1795,7 +1799,8 @@ static void kcm_done(struct kcm_sock *kcm)
 
 	if (kcm->rx_wait) {
 		list_del(&kcm->wait_rx_list);
-		kcm->rx_wait = false;
+		/* paired with lockless reads in kcm_rfree() */
+		WRITE_ONCE(kcm->rx_wait, false);
 	}
 	/* Move any pending receive messages to other kcm sockets */
 	requeue_rx_msgs(mux, &sk->sk_receive_queue);
-- 
2.38.0.135.g90850a2211-goog

