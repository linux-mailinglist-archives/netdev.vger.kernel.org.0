Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12D431B32B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhBNXGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:06:44 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45600 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229945AbhBNXGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:06:43 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B88C9EA;
        Sun, 14 Feb 2021 15:05:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B88C9EA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343902;
        bh=Wp3p0pYGehlmq7X2umzhrTehXnMHlNP3T3VF1yiTciU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JM+5Bebc96wLySCCAAk0Bex//xFlIwykwZYYiGqODwErDCaJyqwhY4f2ERLnV8Kmg
         kVbbxd7QU1hDfXCnMhXwoDf4hqWyxreyhwB5l3Hu3ux09HaOCZMZEQfQqCqY76DPe2
         FFqJZDAkHI7rcA6iLVfVASfhiFNKJNEFfVIn3QNE=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 5/7] bnxt_en: Initialize "context kind" field for context memory blocks.
Date:   Sun, 14 Feb 2021 18:04:59 -0500
Message-Id: <1613343901-6629-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If firmware provides the offset to the "context kind" field of the
relevant context memory blocks, we'll initialize just that field for
each block instead of initializing all of context memory.

Populate the bnxt_mem_init structure with the proper offset returned
by firmware.  If it is older firmware and the information is not
available, we set the offset to an invalid value and fall back to
the old behavior of initializing every byte.  Otherwise, we initialize
only the "context kind" byte at the offset.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 47 ++++++++++++++++++++---
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 888466c3ed78..2bd9358c11e0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2688,6 +2688,23 @@ static void bnxt_free_skbs(struct bnxt *bp)
 	bnxt_free_rx_skbs(bp);
 }
 
+static void bnxt_init_ctx_mem(struct bnxt_mem_init *mem_init, void *p, int len)
+{
+	u8 init_val = mem_init->init_val;
+	u16 offset = mem_init->offset;
+	u8 *p2 = p;
+	int i;
+
+	if (!init_val)
+		return;
+	if (offset == BNXT_MEM_INVALID_OFFSET) {
+		memset(p, init_val, len);
+		return;
+	}
+	for (i = 0; i < len; i += mem_init->size)
+		*(p2 + i + offset) = init_val;
+}
+
 static void bnxt_free_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 {
 	struct pci_dev *pdev = bp->pdev;
@@ -2747,9 +2764,9 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 		if (!rmem->pg_arr[i])
 			return -ENOMEM;
 
-		if (rmem->mem_init && rmem->mem_init->init_val)
-			memset(rmem->pg_arr[i], rmem->mem_init->init_val,
-			       rmem->page_size);
+		if (rmem->mem_init)
+			bnxt_init_ctx_mem(rmem->mem_init, rmem->pg_arr[i],
+					  rmem->page_size);
 		if (rmem->nr_pages > 1 || rmem->depth > 0) {
 			if (i == rmem->nr_pages - 2 &&
 			    (rmem->flags & BNXT_RMEM_RING_PTE_FLAG))
@@ -6754,13 +6771,33 @@ static void bnxt_init_ctx_initializer(struct bnxt_ctx_mem_info *ctx,
 			struct hwrm_func_backing_store_qcaps_output *resp)
 {
 	struct bnxt_mem_init *mem_init;
+	u16 init_mask;
 	u8 init_val;
+	u8 *offset;
 	int i;
 
 	init_val = resp->ctx_kind_initializer;
-	mem_init = &ctx->mem_init[0];
-	for (i = 0; i < BNXT_CTX_MEM_INIT_MAX; i++, mem_init++)
+	init_mask = le16_to_cpu(resp->ctx_init_mask);
+	offset = &resp->qp_init_offset;
+	mem_init = &ctx->mem_init[BNXT_CTX_MEM_INIT_QP];
+	for (i = 0; i < BNXT_CTX_MEM_INIT_MAX; i++, mem_init++, offset++) {
 		mem_init->init_val = init_val;
+		mem_init->offset = BNXT_MEM_INVALID_OFFSET;
+		if (!init_mask)
+			continue;
+		if (i == BNXT_CTX_MEM_INIT_STAT)
+			offset = &resp->stat_init_offset;
+		if (init_mask & (1 << i))
+			mem_init->offset = *offset * 4;
+		else
+			mem_init->init_val = 0;
+	}
+	ctx->mem_init[BNXT_CTX_MEM_INIT_QP].size = ctx->qp_entry_size;
+	ctx->mem_init[BNXT_CTX_MEM_INIT_SRQ].size = ctx->srq_entry_size;
+	ctx->mem_init[BNXT_CTX_MEM_INIT_CQ].size = ctx->cq_entry_size;
+	ctx->mem_init[BNXT_CTX_MEM_INIT_VNIC].size = ctx->vnic_entry_size;
+	ctx->mem_init[BNXT_CTX_MEM_INIT_STAT].size = ctx->stat_entry_size;
+	ctx->mem_init[BNXT_CTX_MEM_INIT_MRAV].size = ctx->mrav_entry_size;
 }
 
 static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
-- 
2.18.1

