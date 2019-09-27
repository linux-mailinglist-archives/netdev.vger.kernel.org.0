Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18549C0331
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfI0KP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:57452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727455AbfI0KP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF023B052;
        Fri, 27 Sep 2019 10:15:24 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/17] staging: qlge: Factor out duplicated expression
Date:   Fri, 27 Sep 2019 19:12:05 +0900
Message-Id: <20190927101210.23856-12-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that (u16) 65536 == 0, that expression can be replaced by a simple
cast.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/qlge.h      |  5 +++++
 drivers/staging/qlge/qlge_main.c | 18 ++++++------------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 5a4b2520cd2a..24af938da7a4 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -77,6 +77,11 @@
 #define LSD(x)  ((u32)((u64)(x)))
 #define MSD(x)  ((u32)((((u64)(x)) >> 32)))
 
+/* In some cases, the device interprets a value of 0x0000 as 65536. These
+ * cases are marked using the following macro.
+ */
+#define QLGE_FIT16(value) ((u16)(value))
+
 /* MPI test register definitions. This register
  * is used for determining alternate NIC function's
  * PCI->func number.
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 0e304a7ac22f..e1099bd29672 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
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
2.23.0

