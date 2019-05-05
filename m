Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D101713F2D
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfEELRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39594 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbfEELR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id w22so3693405pgi.6
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3rK3cYo3er/yAhhkeuZx1Aew+j7jVKrA8N9MbYku7ew=;
        b=HYouRUbvnV1wx6kEPYtF8GvrBHdLdNlBC0f0tsiUfH8/jhpbf8GqOZ21HbASZlRwG1
         Nia0KnO6m6yah4aWEEwMnjJKmYL9J25mo8oqXxJwCtRRujtRBZm/slRhlg5klii8p7P5
         1abm1jYZYPGFXsGoOk7BzY7WFF8cG5sIza9yg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3rK3cYo3er/yAhhkeuZx1Aew+j7jVKrA8N9MbYku7ew=;
        b=HFdzMAker4zHK3wHlfRFwopFXwrjz+gbu+I7GayiNzgVSzR49jtykCLgrRD1T/2ymE
         wTDt8sSvuiv/vRAglt53uMAH1hTXoca/fhY8gWRdS3t+kndaI5R2TGDvhE2SeTfahxfC
         kDKUZ4e7Qq8XZncoQBW6mdH4YtgGsfZWj1XO+/ek/1Tn78AzcuXm0br/9MOT1VuKqTm4
         Nq0DMQtNq9YWzX94UD0Ld5x91wY+vGINyfsF3cuzCmUhe+6vtCtP8fkx+WMaC8BSlChM
         DVMjtSsWCmEloW1egWEinLHjdGB2YEMrCzQvGzv+Avajl8sL4Sa88UnX2njzMZ7rJlf1
         xiCA==
X-Gm-Message-State: APjAAAWGzyAsnuJHUkkicrK47cKSaicyrUB8RzQx3RsypVRYBeDcwyD3
        OusRCHVZmDWV+bvDfeuGx+5cqA==
X-Google-Smtp-Source: APXvYqwEwppZvbMqTnFIDgnsHDLMhWcRKIGILletA0bEfh1lchVDUkKWYeb2v3lL1tgkj8lq2aKevQ==
X-Received: by 2002:aa7:93a7:: with SMTP id x7mr25212393pff.196.1557055046727;
        Sun, 05 May 2019 04:17:26 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:26 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 07/11] bnxt_en: Separate RDMA MR/AH context allocation.
Date:   Sun,  5 May 2019 07:17:04 -0400
Message-Id: <1557055028-14816-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Devesh Sharma <devesh.sharma@broadcom.com>

In newer firmware, the context memory for MR (Memory Region)
and AH (Address Handle) to support RDMA are specified separately.
Modify driver to specify and allocate the 2 context memory types
separately when supported by the firmware.

Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7073b99..d70320c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6074,6 +6074,8 @@ static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 			ctx->tqm_entries_multiple = 1;
 		ctx->mrav_max_entries = le32_to_cpu(resp->mrav_max_entries);
 		ctx->mrav_entry_size = le16_to_cpu(resp->mrav_entry_size);
+		ctx->mrav_num_entries_units =
+			le16_to_cpu(resp->mrav_num_entries_units);
 		ctx->tim_entry_size = le16_to_cpu(resp->tim_entry_size);
 		ctx->tim_max_entries = le32_to_cpu(resp->tim_max_entries);
 	} else {
@@ -6120,6 +6122,7 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 	struct bnxt_ctx_pg_info *ctx_pg;
 	__le32 *num_entries;
 	__le64 *pg_dir;
+	u32 flags = 0;
 	u8 *pg_attr;
 	int i, rc;
 	u32 ena;
@@ -6179,6 +6182,9 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 	if (enables & FUNC_BACKING_STORE_CFG_REQ_ENABLES_MRAV) {
 		ctx_pg = &ctx->mrav_mem;
 		req.mrav_num_entries = cpu_to_le32(ctx_pg->entries);
+		if (ctx->mrav_num_entries_units)
+			flags |=
+			FUNC_BACKING_STORE_CFG_REQ_FLAGS_MRAV_RESERVATION_SPLIT;
 		req.mrav_entry_size = cpu_to_le16(ctx->mrav_entry_size);
 		bnxt_hwrm_set_pg_attr(&ctx_pg->ring_mem,
 				      &req.mrav_pg_size_mrav_lvl,
@@ -6205,6 +6211,7 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 		*num_entries = cpu_to_le32(ctx_pg->entries);
 		bnxt_hwrm_set_pg_attr(&ctx_pg->ring_mem, pg_attr, pg_dir);
 	}
+	req.flags = cpu_to_le32(flags);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
 		rc = -EIO;
@@ -6343,6 +6350,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	struct bnxt_ctx_pg_info *ctx_pg;
 	struct bnxt_ctx_mem_info *ctx;
 	u32 mem_size, ena, entries;
+	u32 num_mr, num_ah;
 	u32 extra_srqs = 0;
 	u32 extra_qps = 0;
 	u8 pg_lvl = 1;
@@ -6406,12 +6414,21 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 		goto skip_rdma;
 
 	ctx_pg = &ctx->mrav_mem;
-	ctx_pg->entries = extra_qps * 4;
+	/* 128K extra is needed to accommodate static AH context
+	 * allocation by f/w.
+	 */
+	num_mr = 1024 * 256;
+	num_ah = 1024 * 128;
+	ctx_pg->entries = num_mr + num_ah;
 	mem_size = ctx->mrav_entry_size * ctx_pg->entries;
 	rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 2);
 	if (rc)
 		return rc;
 	ena = FUNC_BACKING_STORE_CFG_REQ_ENABLES_MRAV;
+	if (ctx->mrav_num_entries_units)
+		ctx_pg->entries =
+			((num_mr / ctx->mrav_num_entries_units) << 16) |
+			 (num_ah / ctx->mrav_num_entries_units);
 
 	ctx_pg = &ctx->tim_mem;
 	ctx_pg->entries = ctx->qp_mem.entries;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 2c18f08..bc4c37a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1227,6 +1227,7 @@ struct bnxt_ctx_mem_info {
 	u16	mrav_entry_size;
 	u16	tim_entry_size;
 	u32	tim_max_entries;
+	u16	mrav_num_entries_units;
 	u8	tqm_entries_multiple;
 
 	u32	flags;
-- 
2.5.1

