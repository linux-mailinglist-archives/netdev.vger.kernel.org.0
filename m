Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18832E328B
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 20:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgL0TTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 14:19:22 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:39838 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbgL0TTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 14:19:22 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 88F567FC5;
        Sun, 27 Dec 2020 11:18:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 88F567FC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609096701;
        bh=g0x+YN3MbVLQrzstloZMmVek/Dw5AK4zqki3HksT1AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWx/42lUihhPNlb1/QPKEM0qmBNV09OUYsQM/0r6TVZ0rQ5cm/xy2SN1DJ2oDHo5n
         3iw8NOBOZEB3MogMb9iOTjPQGPUHZXfHpCKZX047ZS9HoUpJAEmobJXndmWN6D+C0l
         KOcXTAQajc/PUDk6KfWFcl1Fs3m+Fed5YgTOULqw=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 2/2] bnxt_en: Check TQM rings for maximum supported value.
Date:   Sun, 27 Dec 2020 14:18:18 -0500
Message-Id: <1609096698-15009-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609096698-15009-1-git-send-email-michael.chan@broadcom.com>
References: <1609096698-15009-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TQM rings are hardware resources that require host context memory
managed by the driver.  The driver supports up to 9 TQM rings and
the number of rings to use is requested by firmware during run-time.
Cap this number to the maximum supported to prevent accessing beyond
the array.  Future firmware may request more than 9 TQM rings.  Define
macros to remove the magic number 9 from the C code.

Fixes: ac3158cb0108 ("bnxt_en: Allocate TQM ring context memory according to fw specification.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 7 ++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b8351e24395d..d10e4f85dd11 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6790,8 +6790,10 @@ static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 		ctx->tqm_fp_rings_count = resp->tqm_fp_rings_count;
 		if (!ctx->tqm_fp_rings_count)
 			ctx->tqm_fp_rings_count = bp->max_q;
+		else if (ctx->tqm_fp_rings_count > BNXT_MAX_TQM_FP_RINGS)
+			ctx->tqm_fp_rings_count = BNXT_MAX_TQM_FP_RINGS;
 
-		tqm_rings = ctx->tqm_fp_rings_count + 1;
+		tqm_rings = ctx->tqm_fp_rings_count + BNXT_MAX_TQM_SP_RINGS;
 		ctx_pg = kcalloc(tqm_rings, sizeof(*ctx_pg), GFP_KERNEL);
 		if (!ctx_pg) {
 			kfree(ctx);
@@ -6925,7 +6927,8 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 	     pg_attr = &req.tqm_sp_pg_size_tqm_sp_lvl,
 	     pg_dir = &req.tqm_sp_page_dir,
 	     ena = FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_SP;
-	     i < 9; i++, num_entries++, pg_attr++, pg_dir++, ena <<= 1) {
+	     i < BNXT_MAX_TQM_RINGS;
+	     i++, num_entries++, pg_attr++, pg_dir++, ena <<= 1) {
 		if (!(enables & ena))
 			continue;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 950ea26ae0d2..51996c85547e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1436,6 +1436,11 @@ struct bnxt_ctx_pg_info {
 	struct bnxt_ctx_pg_info **ctx_pg_tbl;
 };
 
+#define BNXT_MAX_TQM_SP_RINGS		1
+#define BNXT_MAX_TQM_FP_RINGS		8
+#define BNXT_MAX_TQM_RINGS		\
+	(BNXT_MAX_TQM_SP_RINGS + BNXT_MAX_TQM_FP_RINGS)
+
 struct bnxt_ctx_mem_info {
 	u32	qp_max_entries;
 	u16	qp_min_qp1_entries;
@@ -1474,7 +1479,7 @@ struct bnxt_ctx_mem_info {
 	struct bnxt_ctx_pg_info stat_mem;
 	struct bnxt_ctx_pg_info mrav_mem;
 	struct bnxt_ctx_pg_info tim_mem;
-	struct bnxt_ctx_pg_info *tqm_mem[9];
+	struct bnxt_ctx_pg_info *tqm_mem[BNXT_MAX_TQM_RINGS];
 };
 
 struct bnxt_fw_health {
-- 
2.18.1

