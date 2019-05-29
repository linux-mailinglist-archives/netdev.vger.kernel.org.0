Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6372E7ED
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfE2WPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:15:37 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49966 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbfE2WPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:15:35 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.89)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1hW6r6-0008F3-MH; Thu, 30 May 2019 00:15:33 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 7/7] net: hwbm: Make the hwbm_pool lock a mutex
Date:   Thu, 30 May 2019 00:15:23 +0200
Message-Id: <20190529221523.22399-8-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529221523.22399-1-bigeasy@linutronix.de>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,HEADER_FROM_DIFFERENT_DOMAINS=0.001
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
index e758650b2c26e..256d57ad42b76 100644
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
index 2cab489ae62e6..f784be14d38fe 100644
--- a/net/core/hwbm.c
+++ b/net/core/hwbm.c
@@ -47,34 +47,33 @@ int hwbm_pool_refill(struct hwbm_pool *bm_pool, gfp_t gfp)
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
@@ -83,7 +82,7 @@ int hwbm_pool_add(struct hwbm_pool *bm_pool, unsigned int buf_num, gfp_t gfp)
 	bm_pool->buf_num += i;
 
 	pr_debug("hwpm pool: %d of %d buffers added\n", i, buf_num);
-	spin_unlock_irqrestore(&bm_pool->lock, flags);
+	mutex_unlock(&bm_pool->buf_lock);
 
 	return i;
 }
-- 
2.20.1

