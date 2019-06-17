Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE847B9A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfFQHty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:49:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:40002 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfFQHty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 03:49:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18DDEAFE9;
        Mon, 17 Jun 2019 07:49:53 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 02/16] qlge: Remove page_chunk.last_flag
Date:   Mon, 17 Jun 2019 16:48:44 +0900
Message-Id: <20190617074858.32467-2-bpoirier@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As already done in ql_get_curr_lchunk(), this member can be replaced by a
simple test.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge.h      |  1 -
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 13 +++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h b/drivers/net/ethernet/qlogic/qlge/qlge.h
index 5d9a36deda08..0a156a95e981 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge.h
+++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
@@ -1363,7 +1363,6 @@ struct page_chunk {
 	char *va;		/* virt addr for this chunk */
 	u64 map;		/* mapping for master */
 	unsigned int offset;	/* offset for this chunk */
-	unsigned int last_flag; /* flag set for last chunk in page */
 };
 
 struct bq_desc {
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 0bfbe11db795..038a6bfc79c7 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -1077,11 +1077,9 @@ static int ql_get_next_chunk(struct ql_adapter *qdev, struct rx_ring *rx_ring,
 	rx_ring->pg_chunk.offset += rx_ring->lbq_buf_size;
 	if (rx_ring->pg_chunk.offset == ql_lbq_block_size(qdev)) {
 		rx_ring->pg_chunk.page = NULL;
-		lbq_desc->p.pg_chunk.last_flag = 1;
 	} else {
 		rx_ring->pg_chunk.va += rx_ring->lbq_buf_size;
 		get_page(rx_ring->pg_chunk.page);
-		lbq_desc->p.pg_chunk.last_flag = 0;
 	}
 	return 0;
 }
@@ -2778,6 +2776,8 @@ static int ql_alloc_tx_resources(struct ql_adapter *qdev,
 
 static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 {
+	unsigned int last_offset = ql_lbq_block_size(qdev) -
+		rx_ring->lbq_buf_size;
 	struct bq_desc *lbq_desc;
 
 	uint32_t  curr_idx, clean_idx;
@@ -2787,13 +2787,10 @@ static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring
 	while (curr_idx != clean_idx) {
 		lbq_desc = &rx_ring->lbq[curr_idx];
 
-		if (lbq_desc->p.pg_chunk.last_flag) {
-			pci_unmap_page(qdev->pdev,
-				lbq_desc->p.pg_chunk.map,
-				ql_lbq_block_size(qdev),
+		if (lbq_desc->p.pg_chunk.offset == last_offset)
+			pci_unmap_page(qdev->pdev, lbq_desc->p.pg_chunk.map,
+				       ql_lbq_block_size(qdev),
 				       PCI_DMA_FROMDEVICE);
-			lbq_desc->p.pg_chunk.last_flag = 0;
-		}
 
 		put_page(lbq_desc->p.pg_chunk.page);
 		lbq_desc->p.pg_chunk.page = NULL;
-- 
2.21.0

