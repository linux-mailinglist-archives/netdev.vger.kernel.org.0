Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBA447BA0
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfFQHuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:50:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:40270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfFQHuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 03:50:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9ADC8AFE9;
        Mon, 17 Jun 2019 07:50:10 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 10/16] qlge: Factor out duplicated expression
Date:   Mon, 17 Jun 2019 16:48:52 +0900
Message-Id: <20190617074858.32467-10-bpoirier@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge.h      |  6 ++++++
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 18 ++++++------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h b/drivers/net/ethernet/qlogic/qlge/qlge.h
index 5a4b2520cd2a..0bb7ccdca6a7 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge.h
+++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
@@ -77,6 +77,12 @@
 #define LSD(x)  ((u32)((u64)(x)))
 #define MSD(x)  ((u32)((((u64)(x)) >> 32)))
 
+#define QLGE_FIT16(value) \
+({ \
+	typeof(value) _value = value; \
+	(_value) == 65536 ? 0 : (u16)(_value); \
+})
+
 /* MPI test register definitions. This register
  * is used for determining alternate NIC function's
  * PCI->func number.
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 733f3b87c3a5..a21c47c4b9bd 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -2974,7 +2974,6 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	void __iomem *doorbell_area =
 	    qdev->doorbell_area + (DB_PAGE_SIZE * (128 + rx_ring->cq_id));
 	int err = 0;
-	u16 bq_len;
 	u64 tmp;
 	__le64 *base_indirect_ptr;
 	int page_entries;
@@ -3009,8 +3008,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	memset((void *)cqicb, 0, sizeof(struct cqicb));
 	cqicb->msix_vect = rx_ring->irq;
 
-	bq_len = (rx_ring->cq_len == 65536) ? 0 : (u16) rx_ring->cq_len;
-	cqicb->len = cpu_to_le16(bq_len | LEN_V | LEN_CPP_CONT);
+	cqicb->len = cpu_to_le16(QLGE_FIT16(rx_ring->cq_len) | LEN_V |
+				 LEN_CPP_CONT);
 
 	cqicb->addr = cpu_to_le64(rx_ring->cq_base_dma);
 
@@ -3034,12 +3033,9 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 			page_entries++;
 		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->lbq.len));
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
-		bq_len = qdev->lbq_buf_size == 65536 ? 0 :
-			(u16)qdev->lbq_buf_size;
-		cqicb->lbq_buf_size = cpu_to_le16(bq_len);
-		bq_len = (rx_ring->lbq.len == 65536) ? 0 :
-			(u16)rx_ring->lbq.len;
-		cqicb->lbq_len = cpu_to_le16(bq_len);
+		cqicb->lbq_buf_size =
+			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
+		cqicb->lbq_len = cpu_to_le16(QLGE_FIT16(rx_ring->lbq.len));
 		rx_ring->lbq.prod_idx = 0;
 		rx_ring->lbq.curr_idx = 0;
 		rx_ring->lbq.clean_idx = 0;
@@ -3059,9 +3055,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 		cqicb->sbq_addr =
 		    cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-		bq_len = (rx_ring->sbq.len == 65536) ? 0 :
-			(u16)rx_ring->sbq.len;
-		cqicb->sbq_len = cpu_to_le16(bq_len);
+		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(rx_ring->sbq.len));
 		rx_ring->sbq.prod_idx = 0;
 		rx_ring->sbq.curr_idx = 0;
 		rx_ring->sbq.clean_idx = 0;
-- 
2.21.0

