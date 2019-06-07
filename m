Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4ACC39572
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfFGTVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:21:09 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51142 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730018AbfFGTVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:21:06 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKQA-0004YF-5P; Fri, 07 Jun 2019 21:21:02 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 net-next 7/7] net: hwbm: Make the hwbm_pool lock a mutex
Date:   Fri,  7 Jun 2019 21:20:40 +0200
Message-Id: <20190607192040.19367-8-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on review, `lock' is only acquired in hwbm_pool_add() which is
invoked via ->probe(), ->resume() and ->ndo_change_mtu(). Based on this
the lock can become a mutex and there is no need to disable interrupts
during the procedure.
Now that the lock is a mutex, hwbm_pool_add() no longer invokes
hwbm_pool_refill() in an atomic context so we can pass GFP_KERNEL to
hwbm_pool_refill() and remove the `gfp' argument from hwbm_pool_add().

Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/marvell/mvneta.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta_bm.c |  4 ++--
 include/net/hwbm.h                       |  6 +++---
 net/core/hwbm.c                          | 15 +++++++--------
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 269bd73be1a0a..fb9b27983b5e7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1118,7 +1118,7 @@ static void mvneta_bm_update_mtu(struct mvneta_port *pp, int mtu)
 			SKB_DATA_ALIGN(MVNETA_RX_BUF_SIZE(bm_pool->pkt_size));
 
 	/* Fill entire long pool */
-	num = hwbm_pool_add(hwbm_pool, hwbm_pool->size, GFP_ATOMIC);
+	num = hwbm_pool_add(hwbm_pool, hwbm_pool->size);
 	if (num != hwbm_pool->size) {
 		WARN(1, "pool %d: %d of %d allocated\n",
 		     bm_pool->id, num, hwbm_pool->size);
diff --git a/drivers/net/ethernet/marvell/mvneta_bm.c b/drivers/net/ethernet/marvell/mvneta_bm.c
index de468e1bdba9f..82ee2bcca6fd2 100644
--- a/drivers/net/ethernet/marvell/mvneta_bm.c
+++ b/drivers/net/ethernet/marvell/mvneta_bm.c
@@ -190,7 +190,7 @@ struct mvneta_bm_pool *mvneta_bm_pool_use(struct mvneta_bm *priv, u8 pool_id,
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		hwbm_pool->construct = mvneta_bm_construct;
 		hwbm_pool->priv = new_pool;
-		spin_lock_init(&hwbm_pool->lock);
+		mutex_init(&hwbm_pool->buf_lock);
 
 		/* Create new pool */
 		err = mvneta_bm_pool_create(priv, new_pool);
@@ -201,7 +201,7 @@ struct mvneta_bm_pool *mvneta_bm_pool_use(struct mvneta_bm *priv, u8 pool_id,
 		}
 
 		/* Allocate buffers for this pool */
-		num = hwbm_pool_add(hwbm_pool, hwbm_pool->size, GFP_ATOMIC);
+		num = hwbm_pool_add(hwbm_pool, hwbm_pool->size);
 		if (num != hwbm_pool->size) {
 			WARN(1, "pool %d: %d of %d allocated\n",
 			     new_pool->id, num, hwbm_pool->size);
diff --git a/include/net/hwbm.h b/include/net/hwbm.h
index 89085e2e2da5e..81643cf8a1c43 100644
--- a/include/net/hwbm.h
+++ b/include/net/hwbm.h
@@ -12,18 +12,18 @@ struct hwbm_pool {
 	/* constructor called during alocation */
 	int (*construct)(struct hwbm_pool *bm_pool, void *buf);
 	/* protect acces to the buffer counter*/
-	spinlock_t lock;
+	struct mutex buf_lock;
 	/* private data */
 	void *priv;
 };
 #ifdef CONFIG_HWBM
 void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf);
 int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp);
-int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num, gfp_t gfp);
+int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num);
 #else
 void hwbm_buf_free(struct hwbm_pool *bm_pool, void *buf) {}
 int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp) { return 0; }
-int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num, gfp_t gfp)
+int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
 { return 0; }
 #endif /* CONFIG_HWBM */
 #endif /* _HWBM_H */
diff --git a/net/core/hwbm.c b/net/core/hwbm.c
index fd822ca5a2457..ac1a66df9adc0 100644
--- a/net/core/hwbm.c
+++ b/net/core/hwbm.c
@@ -43,34 +43,33 @@ int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(hwbm_pool_refill);
 
-int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num, gfp_t gfp)
+int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num)
 {
 	int err, i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&bm_pool->lock, flags);
+	mutex_lock(&bm_pool->buf_lock);
 	if (bm_pool->buf_num == bm_pool->size) {
 		pr_warn("pool already filled\n");
-		spin_unlock_irqrestore(&bm_pool->lock, flags);
+		mutex_unlock(&bm_pool->buf_lock);
 		return bm_pool->buf_num;
 	}
 
 	if (buf_num + bm_pool->buf_num > bm_pool->size) {
 		pr_warn("cannot allocate %d buffers for pool\n",
 			buf_num);
-		spin_unlock_irqrestore(&bm_pool->lock, flags);
+		mutex_unlock(&bm_pool->buf_lock);
 		return 0;
 	}
 
 	if ((buf_num + bm_pool->buf_num) < bm_pool->buf_num) {
 		pr_warn("Adding %d buffers to the %d current buffers will overflow\n",
 			buf_num,  bm_pool->buf_num);
-		spin_unlock_irqrestore(&bm_pool->lock, flags);
+		mutex_unlock(&bm_pool->buf_lock);
 		return 0;
 	}
 
 	for (i = 0; i < buf_num; i++) {
-		err = hwbm_pool_refill(bm_pool, gfp);
+		err = hwbm_pool_refill(bm_pool, GFP_KERNEL);
 		if (err < 0)
 			break;
 	}
@@ -79,7 +78,7 @@ int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num, gfp_t gfp)
 	bm_pool->buf_num += i;
 
 	pr_debug("hwpm pool: %d of %d buffers added\n", i, buf_num);
-	spin_unlock_irqrestore(&bm_pool->lock, flags);
+	mutex_unlock(&bm_pool->buf_lock);
 
 	return i;
 }
-- 
2.20.1

