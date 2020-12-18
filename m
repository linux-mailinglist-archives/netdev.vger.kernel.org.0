Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A11F2DE36C
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 14:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgLRNq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 08:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgLRNq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 08:46:29 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC0BC0617B0;
        Fri, 18 Dec 2020 05:45:48 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g3so1445712plp.2;
        Fri, 18 Dec 2020 05:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QDmLdv1yL5l0hpXF2TgoENNSs0aO/B/hx+r7ZWVrQq8=;
        b=rIcsyXuJ+FI7mRmQkH/THTxRPnPtkJwg8xqgHBgytb0Rukh2v1zjsKlJt3DtDO/eAW
         vbhk9AQtONtGOm1N3ERLto1VNZs+ltml4AJVgc2p9oEDNo7oPkqTGOPD/jhHw36IjPGP
         nwgY4gfe37RJjWGMxuLqI6QqAl0DjOhHSAVmXGnc+gfzlOj2zMr67OAwB6hKb4truNSU
         LhH2HzoG+CJhhKR7zypbP1rycf3mCJP83AhAuiYJJZeJY2HhyUZFTpuW6F97vE9AgarK
         oYF5+SKNgMk1O/En0iyAluNcRKq27rzC1XYMzeiLKSstWef6SSu91bijfXf/wIij2G4A
         Bnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QDmLdv1yL5l0hpXF2TgoENNSs0aO/B/hx+r7ZWVrQq8=;
        b=b1PcVE4IMZhcHQLaxMrfCXs9sdXMhKydSTz1Xo7jE3BTjgyh784eLVbM1Pj1Q5D32x
         4u3RNJsYiL7tjuQYcgv6o+VKqJY2w24ezXgCyaLjancLbAEnGlYHuxq3W+7i7x7vaJXf
         MY1zpAmacOuNZIBQQxVytqI+bCrPZRTsdDYJLMriSo2d1nGipIrTzTKidABmaajEfPRe
         M47nf1WVIZwVSM5/X7liss2isyh6i2sZG5MOcJAlsHQ9wVBOALix1ggm4r2A85MIQqMp
         03o8hqS+cAPShL7VsZKuuBZ2bo323NQSTV1dWXn/8X49S26TsnWeUYOXZUs+kmUrzfCu
         fyMA==
X-Gm-Message-State: AOAM531Y8MALbNIS5mHBgFQAsOOf/vb6aR+p3U5LC91CZCzpwH5DjB5a
        4KGwtIeoWXmogtDwnuxCqlg=
X-Google-Smtp-Source: ABdhPJwsabkLRsmpIUfbqaSdCbMYfwd0pCSQBLtKRG2zayVeZDSq7txZ8s4PDdgunJZta9lWk4Kptw==
X-Received: by 2002:a17:90b:46d2:: with SMTP id jx18mr4510165pjb.106.1608299148342;
        Fri, 18 Dec 2020 05:45:48 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id r185sm9075906pfc.53.2020.12.18.05.45.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Dec 2020 05:45:47 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, A.Zema@falconvsystems.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH bpf v2 1/2] xsk: fix race in SKB mode transmit with shared cq
Date:   Fri, 18 Dec 2020 14:45:24 +0100
Message-Id: <20201218134525.13119-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201218134525.13119-1-magnus.karlsson@gmail.com>
References: <20201218134525.13119-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
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
index c6532d77fde7..d531f9cd0de6 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -423,9 +423,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	struct xdp_sock *xs = xdp_sk(skb->sk);
 	unsigned long flags;
 
-	spin_lock_irqsave(&xs->tx_completion_lock, flags);
+	spin_lock_irqsave(&xs->pool->cq_lock, flags);
 	xskq_prod_submit_addr(xs->pool->cq, addr);
-	spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
+	spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
 	sock_wfree(skb);
 }
@@ -437,6 +437,7 @@ static int xsk_generic_xmit(struct sock *sk)
 	bool sent_frame = false;
 	struct xdp_desc desc;
 	struct sk_buff *skb;
+	unsigned long flags;
 	int err = 0;
 
 	mutex_lock(&xs->mutex);
@@ -468,10 +469,13 @@ static int xsk_generic_xmit(struct sock *sk)
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
@@ -1303,7 +1307,6 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	xs->state = XSK_READY;
 	mutex_init(&xs->mutex);
 	spin_lock_init(&xs->rx_lock);
-	spin_lock_init(&xs->tx_completion_lock);
 
 	INIT_LIST_HEAD(&xs->map_list);
 	spin_lock_init(&xs->map_list_lock);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 818b75060922..20598eea658c 100644
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

