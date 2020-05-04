Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C421C34E3
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEDIvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728379AbgEDIvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220E8C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:02 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a31so3433258pje.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R9lBVPU1fy57QPb4beGnfo+2TQ+hrOnK9YTO16l7h9s=;
        b=ci9Ib2v38fZpde83eeDmcHCpcXCUODGwWB3oSRJv1iTDK4OttrBg59yGpbuvLWZ7sx
         CDcKFngXmJ5ojdq/llyinz/iIK5gyUdc2c1o5is2KkYPnype+VRjQSjNJ12hQ17+vGaV
         z/QEitGsA2vT+2OBllGZQtA0A4aR8aSF01tl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R9lBVPU1fy57QPb4beGnfo+2TQ+hrOnK9YTO16l7h9s=;
        b=CbEDbMKLvZhO2KdrfA8IktFLaDDwj2FLDLveoFSw9AHSihlaT1+hSsEkGXkxSHvW88
         UaQz7Tg4ZkiPdWX5S6+AImrlWREUJZwvMMO5/xeXwW3KqBsN3ZxiTwJNR9yZeUWK9c8O
         GV8I9c3Z5O/Ex2yk2Q4sHWZdImH8ha660TjYi+iwomQknKXjeCRNqklOIeIAACeqxosQ
         uiGtUYt6JQmn+m59qIRa46DCNMAb+hYWuio+Gk5fGeQ8SrA9OxG1KZzYHOQMT0wElE9d
         CI+3n/+EIbLLE3EysRlMZ9lTj22uZyAnvmYUYxj8/qyKm2N3OTGpvrbxuJZQoyoLo/28
         Wn+A==
X-Gm-Message-State: AGi0PuZTglegSTKIpsIMINnyWbuvjPPL3vlbWtSreEOp7jyfa/LtfliS
        JRyDh7HZy/1DXoJP182tRvD8vQ==
X-Google-Smtp-Source: APiQypIAn/otSJcjjEbaquZkMOJjBaUWEhrpSB8/nvYySGCi50mCcdGli0n5xYxlEAiIvXuSw3AXew==
X-Received: by 2002:a17:90a:8d01:: with SMTP id c1mr15780788pjo.170.1588582261632;
        Mon, 04 May 2020 01:51:01 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:01 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 03/15] bnxt_en: Improve TQM ring context memory sizing formulas.
Date:   Mon,  4 May 2020 04:50:29 -0400
Message-Id: <1588582241-31066-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current formulas to calculate the TQM slow path and fast path ring
context memory sizes are not quite correct.  TQM slow path entry is
array index 0 of ctx->tqm_mem[].  The other array entries are for fast
path.  Fix these sizes according to latest firmware spec. for 57500 and
newer chips.

Fixes: 3be8136ce14e ("bnxt_en: Initialize context memory to the value specified by firmware.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 32a2083..0cf41a1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6760,6 +6760,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	struct bnxt_ctx_pg_info *ctx_pg;
 	struct bnxt_ctx_mem_info *ctx;
 	u32 mem_size, ena, entries;
+	u32 entries_sp, min;
 	u32 num_mr, num_ah;
 	u32 extra_srqs = 0;
 	u32 extra_qps = 0;
@@ -6849,14 +6850,17 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ena |= FUNC_BACKING_STORE_CFG_REQ_ENABLES_TIM;
 
 skip_rdma:
-	entries = ctx->qp_max_l2_entries + extra_qps;
+	min = ctx->tqm_min_entries_per_ring;
+	entries_sp = ctx->vnic_max_vnic_entries + ctx->qp_max_l2_entries +
+		     2 * (extra_qps + ctx->qp_min_qp1_entries) + min;
+	entries_sp = roundup(entries_sp, ctx->tqm_entries_multiple);
+	entries = ctx->qp_max_l2_entries + extra_qps + ctx->qp_min_qp1_entries;
 	entries = roundup(entries, ctx->tqm_entries_multiple);
-	entries = clamp_t(u32, entries, ctx->tqm_min_entries_per_ring,
-			  ctx->tqm_max_entries_per_ring);
+	entries = clamp_t(u32, entries, min, ctx->tqm_max_entries_per_ring);
 	for (i = 0; i < ctx->tqm_fp_rings_count + 1; i++) {
 		ctx_pg = ctx->tqm_mem[i];
-		ctx_pg->entries = entries;
-		mem_size = ctx->tqm_entry_size * entries;
+		ctx_pg->entries = i ? entries : entries_sp;
+		mem_size = ctx->tqm_entry_size * ctx_pg->entries;
 		rc = bnxt_alloc_ctx_pg_tbls(bp, ctx_pg, mem_size, 1, false);
 		if (rc)
 			return rc;
-- 
2.5.1

