Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0002D107DBA
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKWI0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:40 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39163 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfKWI0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:39 -0500
Received: by mail-pg1-f193.google.com with SMTP id b137so2316874pga.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wm3gh1tO9Fw/vhJ0y7oJGx0X7PPXZUjxIfGYmtv6avU=;
        b=IGeOVIKnPB+mYW+tIdeDTx0YaO0Zour4gaoCCIf2Nbhjm8gYl2Yz2RUJcgSe54BlX8
         bYVFsiqQyqIun/BxImpMMXWGhCRXF2YyIvLJZQLmjfpGbrqFgYvN6rsoJMzALdFAiWRK
         exWXM1diHeYhmL/UWYNW7P6xgDDhijE3w8o4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wm3gh1tO9Fw/vhJ0y7oJGx0X7PPXZUjxIfGYmtv6avU=;
        b=QLgym4yMvSmPHnlTTDDbYHgvDmmW2eXUhpkukO/ll0ZJvVlf3e5ahLgEUIfkWNx4NP
         JCwMqnA8vH28eSivdPg/AJnSfKfWFRghNjac7yJrtx1YGbBTeiSLMAun5rPpRjkZcTZV
         wGTh7yUdC2TJ+8RWLpJRXflOQWlFwjbDcgNyknDM6qZxOQQSlbK09L/pU4feHJQmyc0d
         4UsjLyTnguRbYKiwroxevUV5DaZyLEGIys0PsVqMfV/agECyibP0OLqy3vJvC+sK0Mo5
         UVcO7N2Xu5/TazXHuvoLq08rG2l+hicz5WCnTMgI2OhGdoRKgcsOrAr2lw8meGV5gmYP
         vqdg==
X-Gm-Message-State: APjAAAWYd4BSjj9X0Ls7zaApNRrYof+S5eT/BRH1yqh93wKF9a/Y+oRG
        +8fgGTAda2wRKuveA88gpiWafcNT0Zc=
X-Google-Smtp-Source: APXvYqzT8Q6U5s6E1iB1ZrJ2U5rwKaEduxIfhl946LQX3/ah/qlq5DfNe8ayZ7olYLkj2XCFoad80A==
X-Received: by 2002:a63:d546:: with SMTP id v6mr20310541pgi.295.1574497598616;
        Sat, 23 Nov 2019 00:26:38 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:38 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 07/15] bnxt_en: Initialize context memory to the value specified by firmware.
Date:   Sat, 23 Nov 2019 03:26:02 -0500
Message-Id: <1574497570-22102-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some chips that need host context memory as a backing store requires
the memory to be initialized to a non-zero value.  Query the
value from firmware and initialize the context memory accordingly.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 +++++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  2 ++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6a12ab5..0e384c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2688,6 +2688,9 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 		if (!rmem->pg_arr[i])
 			return -ENOMEM;
 
+		if (rmem->init_val)
+			memset(rmem->pg_arr[i], rmem->init_val,
+			       rmem->page_size);
 		if (rmem->nr_pages > 1 || rmem->depth > 0) {
 			if (i == rmem->nr_pages - 2 &&
 			    (rmem->flags & BNXT_RMEM_RING_PTE_FLAG))
@@ -6487,6 +6490,7 @@ static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 			le16_to_cpu(resp->mrav_num_entries_units);
 		ctx->tim_entry_size = le16_to_cpu(resp->tim_entry_size);
 		ctx->tim_max_entries = le32_to_cpu(resp->tim_max_entries);
+		ctx->ctx_kind_initializer = resp->ctx_kind_initializer;
 	} else {
 		rc = 0;
 	}
@@ -6641,7 +6645,7 @@ static int bnxt_alloc_ctx_mem_blk(struct bnxt *bp,
 
 static int bnxt_alloc_ctx_pg_tbls(struct bnxt *bp,
 				  struct bnxt_ctx_pg_info *ctx_pg, u32 mem_size,
-				  u8 depth)
+				  u8 depth, bool use_init_val)
 {
 	struct bnxt_ring_mem_info *rmem = &ctx_pg->ring_mem;
 	int rc;
@@ -6679,6 +6683,8 @@ static int bnxt_alloc_ctx_pg_tbls(struct bnxt *bp,
 			rmem->pg_tbl_map = ctx_pg->ctx_dma_arr[i];
 			rmem->depth = 1;
 			rmem->nr_pages = MAX_CTX_PAGES;
+			if (use_init_val)
+				rmem->init_val = bp->ctx->ctx_kind_initializer;
 			if (i == (nr_tbls - 1)) {
 				int rem = ctx_pg->nr_pages % MAX_CTX_PAGES;
 
@@ -6693,6 +6699,8 @@ static int bnxt_alloc_ctx_pg_tbls(struct bnxt *bp,
 		rmem->nr_pages = DIV_ROUND_UP(mem_size, BNXT_PAGE_SIZE);
 		if (rmem->nr_pages > 1 || depth)
 			rmem->depth = 1;
+		if (use_init_val)
+			rmem->init_val = bp->ctx->ctx_kind_initializer;
 		rc = bnxt_alloc_ctx_mem_blk(bp, ctx_pg);
 	}
 	return rc;
@@ -6783,21 +6791,21 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg->entries = ctx->qp_min_qp1_entries + ctx->qp_max_l2_entries +
 			  extra_qps;
 	mem_size = ctx->qp_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl);
+	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
 	if (rc)
 		return rc;
 
 	ctx_pg = &ctx->srq_mem;
 	ctx_pg->entries = ctx->srq_max_l2_entries + extra_srqs;
 	mem_size = ctx->srq_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl);
+	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
 	if (rc)
 		return rc;
 
 	ctx_pg = &ctx->cq_mem;
 	ctx_pg->entries = ctx->cq_max_l2_entries + extra_qps * 2;
 	mem_size = ctx->cq_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl);
+	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, pg_lvl, true);
 	if (rc)
 		return rc;
 
@@ -6805,14 +6813,14 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg->entries = ctx->vnic_max_vnic_entries +
 			  ctx->vnic_max_ring_table_entries;
 	mem_size = ctx->vnic_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1);
+	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
 	if (rc)
 		return rc;
 
 	ctx_pg = &ctx->stat_mem;
 	ctx_pg->entries = ctx->stat_max_entries;
 	mem_size = ctx->stat_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1);
+	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, true);
 	if (rc)
 		return rc;
 
@@ -6828,7 +6836,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	num_ah = 1024 * 128;
 	ctx_pg->entries = num_mr + num_ah;
 	mem_size = ctx->mrav_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 2);
+	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 2, true);
 	if (rc)
 		return rc;
 	ena = FUNC_BACKING_STORE_CFG_REQ_ENABLES_MRAV;
@@ -6840,7 +6848,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctx_pg = &ctx->tim_mem;
 	ctx_pg->entries = ctx->qp_mem.entries;
 	mem_size = ctx->tim_entry_size * ctx_pg->entries;
-	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1);
+	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, false);
 	if (rc)
 		return rc;
 	ena |= FUNC_BACKING_STORE_CFG_REQ_ENABLES_TIM;
@@ -6854,7 +6862,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 		ctx_pg = ctx->tqm_mem[i];
 		ctx_pg->entries = entries;
 		mem_size = ctx->tqm_entry_size * entries;
-		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1);
+		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, false);
 		if (rc)
 			return rc;
 		ena |= FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_SP << i;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 35c483b..dbdd097 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -721,6 +721,7 @@ struct bnxt_ring_mem_info {
 #define BNXT_RMEM_USE_FULL_PAGE_FLAG	4
 
 	u16			depth;
+	u8			init_val;
 
 	void			**pg_arr;
 	dma_addr_t		*dma_arr;
@@ -1352,6 +1353,7 @@ struct bnxt_ctx_mem_info {
 	u32	tim_max_entries;
 	u16	mrav_num_entries_units;
 	u8	tqm_entries_multiple;
+	u8	ctx_kind_initializer;
 
 	u32	flags;
 	#define BNXT_CTX_FLAG_INITED	0x01
-- 
2.5.1

