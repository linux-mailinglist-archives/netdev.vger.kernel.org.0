Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7AB2D9AF6
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbgLNP3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408091AbgLNP27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:28:59 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F38EC061793;
        Mon, 14 Dec 2020 07:28:19 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id m5so6742022pjv.5;
        Mon, 14 Dec 2020 07:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fiEFFp/qBeTwEL4YDNSgy5LUMAf16WRbjWYFForKcCU=;
        b=RoHniJKJRQP4iEM4HugjBaByx03JO8i7x+AI4x4OV8p++gtTIwFGtNfEseLRf0itAZ
         kmdNrKA+4XAwwuzx7nSF/WEXFl+SEZiDBA4tOAPJkNl0BVFFImkievP1/RORj6zjqqFK
         JfSTNumT9K77RJhUtOvpIZb4akqWsOVQ/EHqX3HGNOZyD6/wLEzMqOhPmuseBux2yCu5
         FrqYW0AOJCWUBUbVAqNnkFnGY9Ll9w7Gpe8ru+CSRfQZX3Ee6MS8f3uhrrUatIKj+9IL
         yRGqQps0cIe9mVI4/8AIsHDzEhjtmbuRXBQKFAFTGeLPTCx+xJ68keQBDF9awgmtnipy
         CVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fiEFFp/qBeTwEL4YDNSgy5LUMAf16WRbjWYFForKcCU=;
        b=G7hp9gMqwBqEGa0tbkn8PXbFupvaDrTcNPP6PmiplQoYvo/whrz3uUYROhZbuk2DBJ
         C0Lh7Jb80gdgb1+pYEvDCrob2SE1MA8XAg5KIoXiHn9U0Xo1safBXiLCSgV0ljg2vlfp
         j46cuZADO7BqA+waafPvMXoT9FAQtgAkCx1qhzDd4Va/fcn2qRsKeUPAPV9BdlrsZ/Jk
         GqfNly3vLYUuTA+uM8wr3Ij2lG3MoU+FLAOJLupAaDVWMPUfiRou2eXllHkVaNX5KNf8
         KpNsv6VTrixZCx3RuY6Wl1XumadQFgmqer8AW9vXSn16sfRSRfbzYm0zmdanoYlqaAVW
         qiWA==
X-Gm-Message-State: AOAM530EOF+hUvgADfs8rrnkKHPXshD+Lbvs6xy47Ecb3A1hy6IuY7Ak
        VZs6H7eawPWaopsDGDxi6Xw=
X-Google-Smtp-Source: ABdhPJwMYO2AXrfFGeKbf4tmySoGIOFN7xOX4aPUtTOCBue/LWq+mZZEE06dkGHi1hotjm+qDDl+Yw==
X-Received: by 2002:a17:90a:cc06:: with SMTP id b6mr25806360pju.94.1607959698685;
        Mon, 14 Dec 2020 07:28:18 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id 5sm20036027pgm.57.2020.12.14.07.28.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Dec 2020 07:28:18 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, A.Zema@falconvsystems.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH bpf 1/2] xsk: fix race in SKB mode transmit with shared cq
Date:   Mon, 14 Dec 2020 16:27:56 +0100
Message-Id: <20201214152757.7632-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201214152757.7632-1-magnus.karlsson@gmail.com>
References: <20201214152757.7632-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a race when multiple sockets are simultaneously calling sendto()
when the completion ring is shared in the SKB case. This is the case
when you share the same netdev and queue id through the
XDP_SHARED_UMEM bind flag. The problem is that multiple processes can
be in xsk_generic_xmit() and call the backpressure mechanism in
xskq_prod_reserve(xs->pool->cq). As this is a shared resource in this
specific scenario, a race might occur since the rings are
single-producer single-consumer.

Fix this by moving the tx_completion_lock from the socket to the pool
as the pool is shared between the sockets that share the completion
ring. (The pool is not shared when this is not the case.) And then
protect the accesses to xskq_prod_reserve() with this lock. The
tx_completion_lock is renamed cq_lock to better reflect that it
protects accesses to the potentially shared completion ring.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Fixes: a9744f7ca200 ("xsk: fix potential race in SKB TX completion code")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/net/xdp_sock.h      | 4 ----
 include/net/xsk_buff_pool.h | 5 +++++
 net/xdp/xsk.c               | 9 ++++++---
 net/xdp/xsk_buff_pool.c     | 1 +
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 4f4e93bf814c..cc17bc957548 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -58,10 +58,6 @@ struct xdp_sock {
 
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head tx_list;
-	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
-	 * in the SKB destructor callback.
-	 */
-	spinlock_t tx_completion_lock;
 	/* Protects generic receive. */
 	spinlock_t rx_lock;
 
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 01755b838c74..eaa8386dbc63 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -73,6 +73,11 @@ struct xsk_buff_pool {
 	bool dma_need_sync;
 	bool unaligned;
 	void *addrs;
+	/* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
+	 * NAPI TX thread and sendmsg error paths in the SKB destructor callback and when
+	 * sockets share a single cq when the same netdev and queue id is shared.
+	 */
+	spinlock_t cq_lock;
 	struct xdp_buff_xsk *free_heads[];
 };
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 62504471fd20..42cb5f94d49e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -364,9 +364,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	struct xdp_sock *xs = xdp_sk(skb->sk);
 	unsigned long flags;
 
-	spin_lock_irqsave(&xs->tx_completion_lock, flags);
+	spin_lock_irqsave(&xs->pool->cq_lock, flags);
 	xskq_prod_submit_addr(xs->pool->cq, addr);
-	spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
+	spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
 	sock_wfree(skb);
 }
@@ -378,6 +378,7 @@ static int xsk_generic_xmit(struct sock *sk)
 	bool sent_frame = false;
 	struct xdp_desc desc;
 	struct sk_buff *skb;
+	unsigned long flags;
 	int err = 0;
 
 	mutex_lock(&xs->mutex);
@@ -409,10 +410,13 @@ static int xsk_generic_xmit(struct sock *sk)
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
+		spin_lock_irqsave(&xs->pool->cq_lock, flags);
 		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 			kfree_skb(skb);
 			goto out;
 		}
+		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
 		skb->dev = xs->dev;
 		skb->priority = sk->sk_priority;
@@ -1193,7 +1197,6 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	xs->state = XSK_READY;
 	mutex_init(&xs->mutex);
 	spin_lock_init(&xs->rx_lock);
-	spin_lock_init(&xs->tx_completion_lock);
 
 	INIT_LIST_HEAD(&xs->map_list);
 	spin_lock_init(&xs->map_list_lock);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index d5adeee9d5d9..7da28566ac11 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -71,6 +71,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	INIT_LIST_HEAD(&pool->free_list);
 	INIT_LIST_HEAD(&pool->xsk_tx_list);
 	spin_lock_init(&pool->xsk_tx_list_lock);
+	spin_lock_init(&pool->cq_lock);
 	refcount_set(&pool->users, 1);
 
 	pool->fq = xs->fq_tmp;
-- 
2.29.0

