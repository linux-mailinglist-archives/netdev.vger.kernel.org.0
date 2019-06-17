Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEEC47BA6
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfFQHuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:50:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:40448 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfFQHuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 03:50:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6BA81AFE3;
        Mon, 17 Jun 2019 07:50:21 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 15/16] qlge: Refill rx buffers up to multiple of 16
Date:   Mon, 17 Jun 2019 16:48:57 +0900
Message-Id: <20190617074858.32467-15-bpoirier@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reading the {s,l}bq_prod_idx registers on a running device, it appears that
the adapter will only use buffers up to prod_idx & 0xfff0. The driver
currently uses fixed-size guard zones (16 for sbq, 32 for lbq - don't know
why this difference). After the previous patch, this approach no longer
guarantees prod_idx values aligned on multiples of 16. While it appears
that we can write unaligned values to prod_idx without ill effects on
device operation, it makes more sense to change qlge_refill_bq() to refill
up to a limit that corresponds with the device's behavior.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge.h      |  8 ++++++
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 29 ++++++++------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h b/drivers/net/ethernet/qlogic/qlge/qlge.h
index c1b71af1d351..1d90b32f6285 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge.h
+++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
@@ -1424,6 +1424,9 @@ struct qlge_bq {
 	__le64 *base_indirect;
 	dma_addr_t base_indirect_dma;
 	struct qlge_bq_desc *queue;
+	/* prod_idx is the index of the first buffer that may NOT be used by
+	 * hw, ie. one after the last. Advanced by sw.
+	 */
 	void __iomem *prod_idx_db_reg;
 	/* next index where sw should refill a buffer for hw */
 	u16 next_to_use;
@@ -1443,6 +1446,11 @@ struct qlge_bq {
 					  offsetof(struct rx_ring, lbq))); \
 })
 
+/* Experience shows that the device ignores the low 4 bits of the tail index.
+ * Refill up to a x16 multiple.
+ */
+#define QLGE_BQ_ALIGN(index) ALIGN_DOWN(index, 16)
+
 #define QLGE_BQ_WRAP(index) ((index) & (QLGE_BQ_LEN - 1))
 
 struct rx_ring {
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 949dd48b3930..7db4c31c9cc4 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -1114,22 +1114,12 @@ static void qlge_refill_bq(struct qlge_bq *bq)
 	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
 	struct ql_adapter *qdev = rx_ring->qdev;
 	struct qlge_bq_desc *bq_desc;
-	int free_count, refill_count;
-	unsigned int reserved_count;
+	int refill_count;
 	int i;
 
-	if (bq->type == QLGE_SB)
-		reserved_count = 16;
-	else
-		reserved_count = 32;
-
-	free_count = bq->next_to_clean - bq->next_to_use;
-	if (free_count <= 0)
-		free_count += QLGE_BQ_LEN;
-
-	refill_count = free_count - reserved_count;
-	/* refill batch size */
-	if (refill_count < 16)
+	refill_count = QLGE_BQ_WRAP(QLGE_BQ_ALIGN(bq->next_to_clean - 1) -
+				    bq->next_to_use);
+	if (!refill_count)
 		return;
 
 	i = bq->next_to_use;
@@ -1164,11 +1154,14 @@ static void qlge_refill_bq(struct qlge_bq *bq)
 	i += QLGE_BQ_LEN;
 
 	if (bq->next_to_use != i) {
-		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
-			     "ring %u %s: updating prod idx = %d.\n",
-			     rx_ring->cq_id, bq_type_name[bq->type], i);
+		if (QLGE_BQ_ALIGN(bq->next_to_use) != QLGE_BQ_ALIGN(i)) {
+			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
+				     "ring %u %s: updating prod idx = %d.\n",
+				     rx_ring->cq_id, bq_type_name[bq->type],
+				     i);
+			ql_write_db_reg(i, bq->prod_idx_db_reg);
+		}
 		bq->next_to_use = i;
-		ql_write_db_reg(bq->next_to_use, bq->prod_idx_db_reg);
 	}
 }
 
-- 
2.21.0

