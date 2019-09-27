Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAEEC0328
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfI0KPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:56974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbfI0KO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:14:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BDD8AF92;
        Fri, 27 Sep 2019 10:14:58 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/17] staging: qlge: Remove page_chunk.last_flag
Date:   Fri, 27 Sep 2019 19:11:57 +0900
Message-Id: <20190927101210.23856-4-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As already done in ql_get_curr_lchunk(), this member can be replaced by a
simple test.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Acked-by: Manish Chopra <manishc@marvell.com>
---
 drivers/staging/qlge/qlge.h      |  1 -
 drivers/staging/qlge/qlge_main.c | 13 +++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 5d9a36deda08..0a156a95e981 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1363,7 +1363,6 @@ struct page_chunk {
 	char *va;		/* virt addr for this chunk */
 	u64 map;		/* mapping for master */
 	unsigned int offset;	/* offset for this chunk */
-	unsigned int last_flag; /* flag set for last chunk in page */
 };
 
 struct bq_desc {
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 7a8d6390d5de..a82920776e6b 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
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
2.23.0

