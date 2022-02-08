Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9661E4AE56B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 00:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiBHX22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 18:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiBHX21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 18:28:27 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8DDC061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 15:28:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y7so683977plp.2
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 15:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NN71mjQ5kvsWwQJrUVK/tc6hlUIQ5XOB3AVtys8FXR8=;
        b=p9NLmCM6p0LNEbpT2+HY7yxdmA8nninQ5MBU5dG3zPKU7sHElCGFz99aUWbDzOUEBB
         d2fa1rugi+ybvIMS3GwaiBJE+ZlKB17ehjxqVyyfV4bG+ou3jgzThLK0smH6RJXnE/N0
         442h8mJMnH6nZv+fyerjEEjOMO4BxQNAN4Kg4x/0meXY4uhPYYikW93EyXr2PqT77Cqf
         UwmuE9UnZnlzstmC8fmkudHAbTscBuslPjYfyl4AXJOR73eaafgqCuOFm0wtCA/CT2up
         RiTzv96qj34YgzG0aRf+5MLRetbUI6uQaxFaJuGgCRY3kAXLWgR56CpV7hkJwIxlX0Lo
         /T9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NN71mjQ5kvsWwQJrUVK/tc6hlUIQ5XOB3AVtys8FXR8=;
        b=0Ovlnus+DlR9FQxsItA+SkblMon0wC0EZ8OqejlodTfc6pXEl5zw77Yxv+p01SjzWi
         zFIiLSiK138GKsJwsn1wrOFQUFCt0sUDdmST/AqgnZ9c9WOOtWVoAmg8b1oad+Ts5RhM
         8FXIfopasqhSNwB5LQ4Hb4FaMn1Y2bP0mNdL7WU8HAxVG3pZbkosYvAqoje1nClXKr5w
         E4Lj9Is9OyoIYzhYDG4kePwLz0GIpXt/Ma/SX04cn9aY0uhi0TsM60i4eoGXBu0Qwv6L
         cGPB/d6Z9cx0qKUmnMLJxmUZ+gZ45g82ZDATmWAs0vXsfMc1JDsdC33hs3DE3g9LnNpi
         idaw==
X-Gm-Message-State: AOAM5318xS7odNNGlplJMAIZ/Qvoo9m7Jhv8dapfqOBitIWHhZPbA99+
        h1R8OtAOrhIke89cQhYQ4sU=
X-Google-Smtp-Source: ABdhPJxU/vG+FPjZ9qRThPmY0urnSEA87A7DzuTH+8JJTrs77CbEu/vHFxiYo/lOYcyhaL6Wvvh+xg==
X-Received: by 2002:a17:902:b708:: with SMTP id d8mr6425805pls.67.1644362905948;
        Tue, 08 Feb 2022 15:28:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:18f1:ac55:f426:b85d])
        by smtp.gmail.com with ESMTPSA id 38sm12194807pgm.37.2022.02.08.15.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 15:28:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] veth: fix races around rq->rx_notify_masked
Date:   Tue,  8 Feb 2022 15:28:22 -0800
Message-Id: <20220208232822.3432213-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

veth being NETIF_F_LLTX enabled, we need to be more careful
whenever we read/write rq->rx_notify_masked.

BUG: KCSAN: data-race in veth_xmit / veth_xmit

write to 0xffff888133d9a9f8 of 1 bytes by task 23552 on cpu 0:
 __veth_xdp_flush drivers/net/veth.c:269 [inline]
 veth_xmit+0x307/0x470 drivers/net/veth.c:350
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 br_dev_queue_push_xmit+0x3ce/0x430 net/bridge/br_forward.c:53
 NF_HOOK include/linux/netfilter.h:307 [inline]
 br_forward_finish net/bridge/br_forward.c:66 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 __br_forward+0x2e4/0x400 net/bridge/br_forward.c:115
 br_flood+0x521/0x5c0 net/bridge/br_forward.c:242
 br_dev_xmit+0x8b6/0x960
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 neigh_hh_output include/net/neighbour.h:525 [inline]
 neigh_output include/net/neighbour.h:539 [inline]
 ip_finish_output2+0x6f8/0xb70 net/ipv4/ip_output.c:228
 ip_finish_output+0xfb/0x240 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb+0x6e/0xe0 net/ipv4/ip_output.c:1570
 udp_send_skb+0x641/0x880 net/ipv4/udp.c:967
 udp_sendmsg+0x12ea/0x14c0 net/ipv4/udp.c:1254
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888133d9a9f8 of 1 bytes by task 23563 on cpu 1:
 __veth_xdp_flush drivers/net/veth.c:268 [inline]
 veth_xmit+0x2d6/0x470 drivers/net/veth.c:350
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 br_dev_queue_push_xmit+0x3ce/0x430 net/bridge/br_forward.c:53
 NF_HOOK include/linux/netfilter.h:307 [inline]
 br_forward_finish net/bridge/br_forward.c:66 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 __br_forward+0x2e4/0x400 net/bridge/br_forward.c:115
 br_flood+0x521/0x5c0 net/bridge/br_forward.c:242
 br_dev_xmit+0x8b6/0x960
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 neigh_hh_output include/net/neighbour.h:525 [inline]
 neigh_output include/net/neighbour.h:539 [inline]
 ip_finish_output2+0x6f8/0xb70 net/ipv4/ip_output.c:228
 ip_finish_output+0xfb/0x240 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb+0x6e/0xe0 net/ipv4/ip_output.c:1570
 udp_send_skb+0x641/0x880 net/ipv4/udp.c:967
 udp_sendmsg+0x12ea/0x14c0 net/ipv4/udp.c:1254
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 23563 Comm: syz-executor.5 Not tainted 5.17.0-rc2-syzkaller-00064-gc36c04c2e132 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 948d4f214fde ("veth: Add driver XDP")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/veth.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 354a963075c5f15d194152ca9b38c59c66763e94..d29fb9759cc9557d62370f016fc160f3dbd16ce3 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -265,9 +265,10 @@ static void __veth_xdp_flush(struct veth_rq *rq)
 {
 	/* Write ptr_ring before reading rx_notify_masked */
 	smp_mb();
-	if (!rq->rx_notify_masked) {
-		rq->rx_notify_masked = true;
-		napi_schedule(&rq->xdp_napi);
+	if (!READ_ONCE(rq->rx_notify_masked) &&
+	    napi_schedule_prep(&rq->xdp_napi)) {
+		WRITE_ONCE(rq->rx_notify_masked, true);
+		__napi_schedule(&rq->xdp_napi);
 	}
 }
 
@@ -912,8 +913,10 @@ static int veth_poll(struct napi_struct *napi, int budget)
 		/* Write rx_notify_masked before reading ptr_ring */
 		smp_store_mb(rq->rx_notify_masked, false);
 		if (unlikely(!__ptr_ring_empty(&rq->xdp_ring))) {
-			rq->rx_notify_masked = true;
-			napi_schedule(&rq->xdp_napi);
+			if (napi_schedule_prep(&rq->xdp_napi)) {
+				WRITE_ONCE(rq->rx_notify_masked, true);
+				__napi_schedule(&rq->xdp_napi);
+			}
 		}
 	}
 
-- 
2.35.0.263.gb82422642f-goog

