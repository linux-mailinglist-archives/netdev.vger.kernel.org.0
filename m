Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01A1C34E2
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgEDIvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728379AbgEDIvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272C8C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mq3so3509205pjb.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4kd5FJ+0g7EnjVR/IY5uppqlJFOJxh74Bu03xSB3jkM=;
        b=Kbq3ekUwHo2K1ecelw3kV8RGeqeZZ9GiIZDMVQrj3YxVIPR8tnyJYIqxI4Yd1qeAhN
         NH1dbSsthuUr+iZenHMfpAtuJVmNbX+FFRhc0sTmYGi/JArYyENWSNHbVi+kqsROC7VY
         ZTfZB3qYiz3TdneD4Z3h81slYqodQTIzZotTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4kd5FJ+0g7EnjVR/IY5uppqlJFOJxh74Bu03xSB3jkM=;
        b=OPBWFDalD/XX8jh2yNoHZ/ApGvtGDKYVypRa+oXtboTCzXZQn4wjpF3MCRyMkVz+CF
         NMigdlMMEhZPD5UqSLd2N0OXEHf3OX420egai4C3++sivgTghoVQBX96BOTuz8cQEMK+
         nQytUyc/mdhog/41QP1t4py1Y2xzG7fz6TYTZOaugbXPRO+qAEtwEKxPuiVUakYpqnTu
         oFp0c5CO9H4v5oL7P+Why72SoSkg4zj70A2ssiSGDwSgBY6Ab0cCNoq7eAU9jxDkeKYS
         ahUDQ5DYrdJtuC4hvO/bGVqg07kg0/WmDGJJ/xIQTv7Cr3tRW0kMCJ7179ZUQZNT+bQQ
         q1kQ==
X-Gm-Message-State: AGi0PuZDGTOOS8FAx1L3rmE0BxSkjFiZ07nFKageaOrLPNy+A2yu5mWb
        ux8ntq0QTcwURrhoM3IZOWvn5/rJb4g=
X-Google-Smtp-Source: APiQypK4wmfVK6gO4Ax3jGl2D7/EiAD3MyzCelLb4pZ1pqZ62oVgsfXJh6NHpHsN0gFgpdhGic0q0w==
X-Received: by 2002:a17:902:9693:: with SMTP id n19mr17164038plp.277.1588582259654;
        Mon, 04 May 2020 01:50:59 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.50.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:50:59 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 02/15] bnxt_en: Allocate TQM ring context memory according to fw specification.
Date:   Mon,  4 May 2020 04:50:28 -0400
Message-Id: <1588582241-31066-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer firmware spec. will specify the number of TQM rings to allocate
context memory for.  Use the firmware specified value and fall back
to the old value derived from bp->max_q if it is not available.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 30 +++++++++++++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fead64f..32a2083 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6434,23 +6434,13 @@ static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 	if (!rc) {
 		struct bnxt_ctx_pg_info *ctx_pg;
 		struct bnxt_ctx_mem_info *ctx;
-		int i;
+		int i, tqm_rings;
 
 		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 		if (!ctx) {
 			rc = -ENOMEM;
 			goto ctx_err;
 		}
-		ctx_pg = kzalloc(sizeof(*ctx_pg) * (bp->max_q + 1), GFP_KERNEL);
-		if (!ctx_pg) {
-			kfree(ctx);
-			rc = -ENOMEM;
-			goto ctx_err;
-		}
-		for (i = 0; i < bp->max_q + 1; i++, ctx_pg++)
-			ctx->tqm_mem[i] = ctx_pg;
-
-		bp->ctx = ctx;
 		ctx->qp_max_entries = le32_to_cpu(resp->qp_max_entries);
 		ctx->qp_min_qp1_entries = le16_to_cpu(resp->qp_min_qp1_entries);
 		ctx->qp_max_l2_entries = le16_to_cpu(resp->qp_max_l2_entries);
@@ -6483,6 +6473,20 @@ static int bnxt_hwrm_func_backing_store_qcaps(struct bnxt *bp)
 		ctx->tim_entry_size = le16_to_cpu(resp->tim_entry_size);
 		ctx->tim_max_entries = le32_to_cpu(resp->tim_max_entries);
 		ctx->ctx_kind_initializer = resp->ctx_kind_initializer;
+		ctx->tqm_fp_rings_count = resp->tqm_fp_rings_count;
+		if (!ctx->tqm_fp_rings_count)
+			ctx->tqm_fp_rings_count = bp->max_q;
+
+		tqm_rings = ctx->tqm_fp_rings_count + 1;
+		ctx_pg = kcalloc(tqm_rings, sizeof(*ctx_pg), GFP_KERNEL);
+		if (!ctx_pg) {
+			kfree(ctx);
+			rc = -ENOMEM;
+			goto ctx_err;
+		}
+		for (i = 0; i < tqm_rings; i++, ctx_pg++)
+			ctx->tqm_mem[i] = ctx_pg;
+		bp->ctx = ctx;
 	} else {
 		rc = 0;
 	}
@@ -6735,7 +6739,7 @@ static void bnxt_free_ctx_mem(struct bnxt *bp)
 		return;
 
 	if (ctx->tqm_mem[0]) {
-		for (i = 0; i < bp->max_q + 1; i++)
+		for (i = 0; i < ctx->tqm_fp_rings_count + 1; i++)
 			bnxt_free_ctx_pg_tbls(bp, ctx->tqm_mem[i]);
 		kfree(ctx->tqm_mem[0]);
 		ctx->tqm_mem[0] = NULL;
@@ -6849,7 +6853,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	entries = roundup(entries, ctx->tqm_entries_multiple);
 	entries = clamp_t(u32, entries, ctx->tqm_min_entries_per_ring,
 			  ctx->tqm_max_entries_per_ring);
-	for (i = 0; i < bp->max_q + 1; i++) {
+	for (i = 0; i < ctx->tqm_fp_rings_count + 1; i++) {
 		ctx_pg = ctx->tqm_mem[i];
 		ctx_pg->entries = entries;
 		mem_size = ctx->tqm_entry_size * entries;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f2caa27..1dbc3ae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1357,6 +1357,7 @@ struct bnxt_ctx_mem_info {
 	u16	mrav_num_entries_units;
 	u8	tqm_entries_multiple;
 	u8	ctx_kind_initializer;
+	u8	tqm_fp_rings_count;
 
 	u32	flags;
 	#define BNXT_CTX_FLAG_INITED	0x01
-- 
2.5.1

