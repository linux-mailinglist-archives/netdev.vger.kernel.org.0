Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4426831B328
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhBNXF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:05:57 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45564 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhBNXFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:05:53 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9488A7A52;
        Sun, 14 Feb 2021 15:05:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9488A7A52
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343902;
        bh=PhZrRB06/+Ev6abV/8H/cVu8JWmAZLfw2Jqgu3XDnEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUMoEuf/aLCPKA9RijakE+0HaJh3TzYZyvWBGiWAK6vmpvYKTQ76qBEzMtiItmefZ
         zxhV4KEsOxS1XC3OUzCpEkMWd+OHmH0PPxTwFvMQOTGo3qG47t7bbI5za4emiCcBXf
         u7/INQoWOpQpRGWmqnasNH00UV6AAsMtdpiMb2Ac=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 4/7] bnxt_en: Add context memory initialization infrastructure.
Date:   Sun, 14 Feb 2021 18:04:58 -0500
Message-Id: <1613343901-6629-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the driver calls memset() to set all relevant context memory
used by the chip to the initial value.  This can take many milliseconds
with the potentially large number of context pages allocated for the
chip.

To make this faster, we only need to initialize the "context kind" field
of each block of context memory.  This patch sets up the infrastructure
to do that with the bnxt_mem_init structure.  In the next patch, we'll
add the logic to obtain the offset of the "context kind" from the
firmware.  This patch is not changing the current behavior of calling
memset() to initialize all relevant context memory.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 52 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 19 ++++++++-
 2 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f2cf89d61eb2..888466c3ed78 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2747,8 +2747,8 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 		if (!rmem->pg_arr[i])
 			return -ENOMEM;
 
-		if (rmem->init_val)
-			memset(rmem->pg_arr[i], rmem->init_val,
+		if (rmem->mem_init && rmem->mem_init->init_val)
+			memset(rmem->pg_arr[i], rmem->mem_init->init_val,
 			       rmem->page_size);
 		if (rmem->nr_pages > 1 || rmem->depth > 0) {
 			if (i == rmem->nr_pages - 2 &&
@@ -6750,6 +6750,19 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 	return rc;
 }
 
+static void bnxt_init_ctx_initializer(struct bnxt_ctx_mem_info *ctx,
+			struct hwrm_func_backing_store_qcaps_output *resp)
+{
+	struct bnxt_mem_init *mem_init;
+	u8 init_val;
+	int i;
+
+	init_val = resp->ctx_kind_initializer;
+	mem_init = &ctx->mem_init[0];
+	for (i = 0; i < BNXT_CTX_MEM_INIT_MAX; i++, mem_init++)
+		mem_init->init_val = init_val;
+}
+
 static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 {
 	struct hwrm_func_backing_store_qcaps_input req = {0};
@@ -6804,7 +6817,9 @@ static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 			le16_to_cpu(resp->mrav_num_entries_units);
 		ctx->tim_entry_size = le16_to_cpu(resp->tim_entry_size);
 		ctx->tim_max_entries = le32_to_cpu(resp->tim_max_entries);
-		ctx->ctx_kind_initializer = resp->ctx_kind_initializer;
+
+		bnxt_init_ctx_initializer(ctx, resp);
+
 		ctx->tqm_fp_rings_count = resp->tqm_fp_rings_count;
 		if (!ctx->tqm_fp_rings_count)
 			ctx->tqm_fp_rings_count = bp->max_q;
@@ -6981,7 +6996,7 @@ static int bnxt_alloc_ctx_mem_blk(struct bnxt *bp,
 
 static int bnxt_alloc_ctx_pg_tbls(struct bnxt *bp,
 				  struct bnxt_ctx_pg_info *ctx_pg, u32 mem_size,
-				  u8 depth, bool use_init_val)
+				  u8 depth, struct bnxt_mem_init *mem_init)
 {
 	struct bnxt_ring_mem_info *rmem = &ctx_pg->ring_mem;
 	int rc;
@@ -7019,8 +7034,7 @@ static int bnxt_alloc_ctx_pg_tbls(struct bnxt *bp,
 			rmem->pg_tbl_map = ctx_pg->ctx_dma_arr[i];
 			rmem->depth = 1;
 			rmem->nr_pages = MAX_CTX_PAGES;
-			if (use_init_val)
-				rmem->init_val = bp->ctx->ctx_kind_initializer;
+			rmem->mem_init = mem_init;
 			if (i == (nr_tbls - 1)) {
 				int rem = ctx_pg->nr_pages % MAX_CTX_PAGES;
 
@@ -7035,8 +7049,7 @@ static int bnxt_alloc_ctx_pg_tbls(struct bnxt *bp,
 		rmem->nr_pages = DIV_ROUND_UP(mem_size, BNXT_PAGE_SIZE);
 		if (rmem->nr_pages > 1 || depth)
 			rmem->depth = 1;
-		if (use_init_val)
-			rmem->init_val = bp->ctx->ctx_kind_initializer;
+		rmem->mem_init = mem_init;
 		rc = bnxt_alloc_ctx_mem_blk(bp, ctx_pg);
 	}
 	return rc;
@@ -7100,6 +7113,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 {
 	struct bnxt_ctx_pg_info *ctx_pg;
 	struct bnxt_ctx_mem_info *ctx;
+	struct bnxt_mem_init *init;
 	u32 mem_size, ena, entries;
 	u32 entries_sp, min;
 	u32 num_mr, num_ah;
@@ -7129,7 +7143,8 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 			  extra_qps;
 	if (ctx->qp_entry_size) {
 		mem_size = ctx->qp_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
+		init = &ctx->mem_init[BNXT_CTX_MEM_INIT_QP];
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, init);
 		if (rc)
 			return rc;
 	}
@@ -7138,7 +7153,8 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg->entries = ctx->srq_max_l2_entries + extra_srqs;
 	if (ctx->srq_entry_size) {
 		mem_size = ctx->srq_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
+		init = &ctx->mem_init[BNXT_CTX_MEM_INIT_SRQ];
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, init);
 		if (rc)
 			return rc;
 	}
@@ -7147,7 +7163,8 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg->entries = ctx->cq_max_l2_entries + extra_qps * 2;
 	if (ctx->cq_entry_size) {
 		mem_size = ctx->cq_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
+		init = &ctx->mem_init[BNXT_CTX_MEM_INIT_CQ];
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, init);
 		if (rc)
 			return rc;
 	}
@@ -7157,7 +7174,8 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 			  ctx->vnic_max_ring_table_entries;
 	if (ctx->vnic_entry_size) {
 		mem_size = ctx->vnic_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
+		init = &ctx->mem_init[BNXT_CTX_MEM_INIT_VNIC];
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, init);
 		if (rc)
 			return rc;
 	}
@@ -7166,7 +7184,8 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg->entries = ctx->stat_max_entries;
 	if (ctx->stat_entry_size) {
 		mem_size = ctx->stat_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
+		init = &ctx->mem_init[BNXT_CTX_MEM_INIT_STAT];
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, init);
 		if (rc)
 			return rc;
 	}
@@ -7184,7 +7203,8 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg->entries = num_mr + num_ah;
 	if (ctx->mrav_entry_size) {
 		mem_size = ctx->mrav_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 2, true);
+		init = &ctx->mem_init[BNXT_CTX_MEM_INIT_MRAV];
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 2, init);
 		if (rc)
 			return rc;
 	}
@@ -7198,7 +7218,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg->entries = ctx->qp_mem.entries;
 	if (ctx->tim_entry_size) {
 		mem_size = ctx->tim_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, false);
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, NULL);
 		if (rc)
 			return rc;
 	}
@@ -7218,7 +7238,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 		if (ctx->tqm_entry_size) {
 			mem_size = ctx->tqm_entry_size * ctx_pg->entries;
 			rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1,
-						    false);
+						    NULL);
 			if (rc)
 				return rc;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 36007b0d1177..f5c45ea52b44 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -714,6 +714,13 @@ struct bnxt_sw_rx_agg_bd {
 	dma_addr_t		mapping;
 };
 
+struct bnxt_mem_init {
+	u8	init_val;
+	u16	offset;
+#define	BNXT_MEM_INVALID_OFFSET	0xffff
+	u16	size;
+};
+
 struct bnxt_ring_mem_info {
 	int			nr_pages;
 	int			page_size;
@@ -723,7 +730,7 @@ struct bnxt_ring_mem_info {
 #define BNXT_RMEM_USE_FULL_PAGE_FLAG	4
 
 	u16			depth;
-	u8			init_val;
+	struct bnxt_mem_init	*mem_init;
 
 	void			**pg_arr;
 	dma_addr_t		*dma_arr;
@@ -1474,7 +1481,6 @@ struct bnxt_ctx_mem_info {
 	u32	tim_max_entries;
 	u16	mrav_num_entries_units;
 	u8	tqm_entries_multiple;
-	u8	ctx_kind_initializer;
 	u8	tqm_fp_rings_count;
 
 	u32	flags;
@@ -1488,6 +1494,15 @@ struct bnxt_ctx_mem_info {
 	struct bnxt_ctx_pg_info mrav_mem;
 	struct bnxt_ctx_pg_info tim_mem;
 	struct bnxt_ctx_pg_info *tqm_mem[BNXT_MAX_TQM_RINGS];
+
+#define BNXT_CTX_MEM_INIT_QP	0
+#define BNXT_CTX_MEM_INIT_SRQ	1
+#define BNXT_CTX_MEM_INIT_CQ	2
+#define BNXT_CTX_MEM_INIT_VNIC	3
+#define BNXT_CTX_MEM_INIT_STAT	4
+#define BNXT_CTX_MEM_INIT_MRAV	5
+#define BNXT_CTX_MEM_INIT_MAX	6
+	struct bnxt_mem_init	mem_init[BNXT_CTX_MEM_INIT_MAX];
 };
 
 struct bnxt_fw_health {
-- 
2.18.1

