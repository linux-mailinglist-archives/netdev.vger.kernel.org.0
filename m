Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EF72D5FE0
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391399AbgLJPh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391648AbgLJPhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:37:17 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E0DC061793;
        Thu, 10 Dec 2020 07:36:37 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id t18so2964519plo.0;
        Thu, 10 Dec 2020 07:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qklYZ0hnytF3zPV5UWA7tMSlDUWdbmOGJ8CkVNl8yfM=;
        b=XNR2dIOhO1XwrkAWrI56QyRDZvssjd7LdVEQkfecC/D8XZUMWV3F8MUTJU+kEleaza
         WcEWzN1Oknq7qXKLN6PCbDtCHX9niHIKwgwE83nYim9aCJnImCjrj0jJjz9n4B0wAoXz
         oyg34KvSqtAhsCaW3C6amhid4XKudhfRa5vtk5hwfyigTq4zB/jXLlnDRWJ9Zpu9ECXx
         urU4CVSPgqpIOZrRtMSn2krbHhY/27hlyA4T6XX1186Vx0dlZ8Lsdck3YsU/IEjHRKy3
         HzqvrgL4P4M1dXbd167/CUu8MC84E5hVhh/In9e/b/Z/tUeM1edP+2H7rYsH24IceCYh
         AHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qklYZ0hnytF3zPV5UWA7tMSlDUWdbmOGJ8CkVNl8yfM=;
        b=scgnz6mqvZm3P6RlAQURSmuRnwHmeCLoGxBUqrA4wIsAsmZeNHd9YJE1ex6CSLGznh
         pBJI2SdqnFwQBGQZX8Ew5mjvv2tqmaDy7pTTEIoJw2vAuHK0PHNJ/BwKNONxZGvaTE49
         TBr5HatsikFIvxVlYbJ4U7o2RcrTfwTonml5RKiJJbTkQXh2rGT1mJ8sLEXDDo03VBjn
         /JF4/NroRvu3S83vP9TxxK4iI4UBnmJjcK/sLdtjoHPEX4eiSO9X/i1yoNQP258mQGHd
         XhjnhcJkxFvwE2MOgyqtRPTep2sosQX6plrjlZiDvjIdwT8risGviodwlshDWU9iguOa
         Ne8w==
X-Gm-Message-State: AOAM5329GoeFcEuP8C7LQObvn2ksuZCaQG562MHORAnQDIZUzb9b8HCT
        Pq/4VsjUtPcTjUKHD9UtnJE=
X-Google-Smtp-Source: ABdhPJySBujCH3wu9QzGm4/Lvf24k8KALOV3X7RzDA+jFZAtnWimjeecj0vb9+cPp3zZO4SrFchsLw==
X-Received: by 2002:a17:902:e9c5:b029:db:d1ae:46ba with SMTP id 5-20020a170902e9c5b02900dbd1ae46bamr6367270plk.38.1607614597132;
        Thu, 10 Dec 2020 07:36:37 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id 123sm6588972pgh.21.2020.12.10.07.36.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 07:36:36 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH bpf] xsk: fix race in SKB mode transmit with shared cq
Date:   Thu, 10 Dec 2020 16:36:18 +0100
Message-Id: <20201210153618.21226-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
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

base-commit: 4e083fdfa39db29bbc7725e229e701867d0da183
-- 
2.29.0

