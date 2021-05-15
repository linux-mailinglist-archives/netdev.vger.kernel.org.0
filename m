Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE3A38168E
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 09:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhEOH0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 03:26:44 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:59990 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231421AbhEOH0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 03:26:37 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id A777B3892F;
        Sat, 15 May 2021 00:25:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com A777B3892F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1621063522;
        bh=4CM/M0dSg7XMSIFVfX9iTItoUMDKSNxZVoaGrPsg6VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wU0XlukexqoKnj/YjV3q6zHbjLkvhj9Wnpj/3NmAIcGL38dH/I7HTzwy5zrdREq/X
         yNnHUzEnf6MyMaldKS8rsndsdq3JUQ6mvg4Onopo7MOI5qeMzwb1OgWpqGSWCTQWUT
         Jd3g8tSopcz2m1SPpVSKO/6FErpgGOCwVVBQiCgI=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 2/2] bnxt_en: Fix context memory setup for 64K page size.
Date:   Sat, 15 May 2021 03:25:19 -0400
Message-Id: <1621063519-7764-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1621063519-7764-1-git-send-email-michael.chan@broadcom.com>
References: <1621063519-7764-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was a typo in the code that checks for 64K BNXT_PAGE_SHIFT in
bnxt_hwrm_set_pg_attr().  Fix it and make the code more understandable
with a new macro BNXT_SET_CTX_PAGE_ATTR().

Fixes: 1b9394e5a2ad ("bnxt_en: Configure context memory on new devices.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |  9 +--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4e57041b4775..fcc729d52b17 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6933,17 +6933,10 @@ static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 static void bnxt_hwrm_set_pg_attr(struct bnxt_ring_mem_info *rmem, u8 *pg_attr,
 				  __le64 *pg_dir)
 {
-	u8 pg_size = 0;
-
 	if (!rmem->nr_pages)
 		return;
 
-	if (BNXT_PAGE_SHIFT == 13)
-		pg_size = 1 << 4;
-	else if (BNXT_PAGE_SIZE == 16)
-		pg_size = 2 << 4;
-
-	*pg_attr = pg_size;
+	BNXT_SET_CTX_PAGE_ATTR(*pg_attr);
 	if (rmem->depth >= 1) {
 		if (rmem->depth == 2)
 			*pg_attr |= 2;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 98e0cef4532c..30e47ea343f9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1457,6 +1457,16 @@ struct bnxt_ctx_pg_info {
 
 #define BNXT_BACKING_STORE_CFG_LEGACY_LEN	256
 
+#define BNXT_SET_CTX_PAGE_ATTR(attr)					\
+do {									\
+	if (BNXT_PAGE_SIZE == 0x2000)					\
+		attr = FUNC_BACKING_STORE_CFG_REQ_SRQ_PG_SIZE_PG_8K;	\
+	else if (BNXT_PAGE_SIZE == 0x10000)				\
+		attr = FUNC_BACKING_STORE_CFG_REQ_QPC_PG_SIZE_PG_64K;	\
+	else								\
+		attr = FUNC_BACKING_STORE_CFG_REQ_QPC_PG_SIZE_PG_4K;	\
+} while (0)
+
 struct bnxt_ctx_mem_info {
 	u32	qp_max_entries;
 	u16	qp_min_qp1_entries;
-- 
2.18.1

