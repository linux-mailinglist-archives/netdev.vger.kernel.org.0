Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C562531B327
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBNXFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:05:55 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45542 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230154AbhBNXFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:05:53 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 4BF587A21;
        Sun, 14 Feb 2021 15:05:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 4BF587A21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343902;
        bh=XDvlAbnyW7vyr78FxIvjRvIvNZahfppDGo4pVjCko3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNktaZ+Or7bdJt9rRjv8ZnNQWgXQCvkX80uzSbXxcSdEu+Fsr5z4dye/sBNJ3umHG
         X7BjWWOlPJ/bPg3f8i5PNNqqBt++aQkYbBqQ/5Hiuh5oKvU0YcSoSYzt+vfH+wIFkt
         iHZGF02JhbzH4QFmqXKT+Fyq5SyZgLhY1zduAFsc=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 2/7] bnxt_en: selectively allocate context memories
Date:   Sun, 14 Feb 2021 18:04:56 -0500
Message-Id: <1613343901-6629-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Newer devices may have local context memory instead of relying on the
host for backing store. In these cases, HWRM_FUNC_BACKING_STORE_QCAPS
will return a zero entry size to indicate contexts for which the host
should not allocate backing store.

Selectively allocate context memory based on device capabilities and
only enable backing store for the appropriate contexts.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 84 ++++++++++++++---------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f508c5c61a30..7512879a551a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6834,6 +6834,9 @@ static void bnxt_hwrm_set_pg_attr(struct bnxt_ring_mem_info *rmem, u8 *pg_attr,
 {
 	u8 pg_size = 0;
 
+	if (!rmem->nr_pages)
+		return;
+
 	if (BNXT_PAGE_SHIFT == 13)
 		pg_size = 1 << 4;
 	else if (BNXT_PAGE_SIZE == 16)
@@ -7124,39 +7127,49 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg = &ctx->qp_mem;
 	ctx_pg->entries = ctx->qp_min_qp1_entries + ctx->qp_max_l2_entries +
 			  extra_qps;
-	mem_size = ctx->qp_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
-	if (rc)
-		return rc;
+	if (ctx->qp_entry_size) {
+		mem_size = ctx->qp_entry_size * ctx_pg->entries;
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
+		if (rc)
+			return rc;
+	}
 
 	ctx_pg = &ctx->srq_mem;
 	ctx_pg->entries = ctx->srq_max_l2_entries + extra_srqs;
-	mem_size = ctx->srq_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
-	if (rc)
-		return rc;
+	if (ctx->srq_entry_size) {
+		mem_size = ctx->srq_entry_size * ctx_pg->entries;
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
+		if (rc)
+			return rc;
+	}
 
 	ctx_pg = &ctx->cq_mem;
 	ctx_pg->entries = ctx->cq_max_l2_entries + extra_qps * 2;
-	mem_size = ctx->cq_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
-	if (rc)
-		return rc;
+	if (ctx->cq_entry_size) {
+		mem_size = ctx->cq_entry_size * ctx_pg->entries;
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
+		if (rc)
+			return rc;
+	}
 
 	ctx_pg = &ctx->vnic_mem;
 	ctx_pg->entries = ctx->vnic_max_vnic_entries +
 			  ctx->vnic_max_ring_table_entries;
-	mem_size = ctx->vnic_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
-	if (rc)
-		return rc;
+	if (ctx->vnic_entry_size) {
+		mem_size = ctx->vnic_entry_size * ctx_pg->entries;
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
+		if (rc)
+			return rc;
+	}
 
 	ctx_pg = &ctx->stat_mem;
 	ctx_pg->entries = ctx->stat_max_entries;
-	mem_size = ctx->stat_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
-	if (rc)
-		return rc;
+	if (ctx->stat_entry_size) {
+		mem_size = ctx->stat_entry_size * ctx_pg->entries;
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
+		if (rc)
+			return rc;
+	}
 
 	ena = 0;
 	if (!(bp->flags & BNXT_FLAG_ROCE_CAP))
@@ -7169,10 +7182,12 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	num_mr = 1024 * 256;
 	num_ah = 1024 * 128;
 	ctx_pg->entries = num_mr + num_ah;
-	mem_size = ctx->mrav_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 2, true);
-	if (rc)
-		return rc;
+	if (ctx->mrav_entry_size) {
+		mem_size = ctx->mrav_entry_size * ctx_pg->entries;
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 2, true);
+		if (rc)
+			return rc;
+	}
 	ena = FUNC_BACKING_STORE_CFG_REQ_ENABLES_MRAV;
 	if (ctx->mrav_num_entries_units)
 		ctx_pg->entries =
@@ -7181,10 +7196,12 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 
 	ctx_pg = &ctx->tim_mem;
 	ctx_pg->entries = ctx->qp_mem.entries;
-	mem_size = ctx->tim_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, false);
-	if (rc)
-		return rc;
+	if (ctx->tim_entry_size) {
+		mem_size = ctx->tim_entry_size * ctx_pg->entries;
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, false);
+		if (rc)
+			return rc;
+	}
 	ena |= FUNC_BACKING_STORE_CFG_REQ_ENABLES_TIM;
 
 skip_rdma:
@@ -7198,10 +7215,13 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	for (i = 0; i < ctx->tqm_fp_rings_count + 1; i++) {
 		ctx_pg = ctx->tqm_mem[i];
 		ctx_pg->entries = i ? entries : entries_sp;
-		mem_size = ctx->tqm_entry_size * ctx_pg->entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, false);
-		if (rc)
-			return rc;
+		if (ctx->tqm_entry_size) {
+			mem_size = ctx->tqm_entry_size * ctx_pg->entries;
+			rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1,
+						    false);
+			if (rc)
+				return rc;
+		}
 		ena |= FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_SP << i;
 	}
 	ena |= FUNC_BACKING_STORE_CFG_REQ_DFLT_ENABLES;
-- 
2.18.1

