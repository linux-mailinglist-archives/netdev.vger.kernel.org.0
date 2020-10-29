Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E408D29E425
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgJ2He5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgJ2HY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:58 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F720C0613BC
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b3so1396086pfo.2
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nvTjwGiFy7RMpGjR4NEsuKbMJyl0YwUcfl9zUvcb++o=;
        b=nEesr5ewctFz6+l4dBVIGsN14d2NFejsJ106ovT4W2XU5FqZ0/3kTVA8LYOoUXF6Rl
         JGSrNrD41m4qukuiw9mf3GyDqAYYpXiMJnng1RdEkjLSIHhvtyrxIAkLtBwOlnmXE+xK
         /jOe2refvWDzgn/YE9L24ChAJfPUZVjKgvtwmZ0s7S/5IPGLEpdx8FgFz0eZDkNNjbVy
         fU4XnTNC8veZ9l++/mvP5ktj+FbZqgSvnmkKJXUMHEnN9hs/jLjup4NLAysi0F+8JYWl
         34r0CAOxxrYVpekvb7TErwGPx40FLR08CEVNK1Z2QIQUP+8CdhjkSRfPPRbbQmjWv7/8
         N4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nvTjwGiFy7RMpGjR4NEsuKbMJyl0YwUcfl9zUvcb++o=;
        b=lliZwhwlbcfCZtNoGUrWKFoT0kq9TlPB2HW8IMyytm7RxtaFGkAoFdbyWA1vvAAqUA
         v3KXwk2P6sjw0ijdij+hdohvy+22jNkxCuqtHHfqDLr6+vCdWx+bBoz/+Ri4SkRCciyn
         MuhdRb2CuE9vPrXbX+jCrVgV5AdSgzbU5Ol61+OR8Vckhq9BmEcCH+lI5PJUnd8xNTVV
         WsSnP9V6he8nvfabhASIlh4vKdY48OOkOCUBXgm14LroGthV65hPa2kod9df2YhIguBG
         LfGyKk9wuzN2oecIZeG04PCNG87B/Fae0zrRBBMZCklpinHRxgGIgSKbr1PMKCDo9RdT
         coqA==
X-Gm-Message-State: AOAM530R9Ofm7PzYRV2JbHY4FTreCrcH7d/8VFFmh9n2M+cM3pfcVvKt
        07q9+PDgRRh6joFt61WtINc=
X-Google-Smtp-Source: ABdhPJwE9f4XGltWiaCQWA8n7N2SJ8HJ5M6bHidgEorY+ob2+2hGZsOb5DzyVpEiV7/ta0HNQheawg==
X-Received: by 2002:a62:fcc3:0:b029:155:d55:7c13 with SMTP id e186-20020a62fcc30000b02901550d557c13mr2709549pfh.79.1603948577704;
        Wed, 28 Oct 2020 22:16:17 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:17 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [v2 net-next PATCH 05/10] octeontx2-af: Setup MCE context for assigned NIX
Date:   Thu, 29 Oct 2020 10:45:44 +0530
Message-Id: <1603948549-781-6-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Initialize MCE context for the assigned NIX0/1
block for a CGX mapped PF. Modified rvu_nix_aq_enq_inst
function to work with nix_hw so that MCE contexts
for both NIX blocks can be inited.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 56 ++++++++++++++--------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 6b8c964..9b60172 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -649,8 +649,9 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 	return 0;
 }
 
-static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
-			       struct nix_aq_enq_rsp *rsp)
+static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
+				   struct nix_aq_enq_req *req,
+				   struct nix_aq_enq_rsp *rsp)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
@@ -659,15 +660,11 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	struct rvu_block *block;
 	struct admin_queue *aq;
 	struct rvu_pfvf *pfvf;
-	struct nix_hw *nix_hw;
 	void *ctx, *mask;
 	bool ena;
 	u64 cfg;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
+	blkaddr = nix_hw->blkaddr;
 	block = &hw->block[blkaddr];
 	aq = block->aq;
 	if (!aq) {
@@ -675,10 +672,6 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 		return NIX_AF_ERR_AQ_ENQUEUE;
 	}
 
-	nix_hw =  get_nix_hw(rvu->hw, blkaddr);
-	if (!nix_hw)
-		return -EINVAL;
-
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
 
@@ -875,6 +868,23 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	return 0;
 }
 
+static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
+			       struct nix_aq_enq_rsp *rsp)
+{
+	struct nix_hw *nix_hw;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, req->hdr.pcifunc);
+	if (blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	nix_hw =  get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return -EINVAL;
+
+	return rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
+}
+
 static const char *nix_get_ctx_name(int ctype)
 {
 	switch (ctype) {
@@ -1993,8 +2003,8 @@ int rvu_mbox_handler_nix_vtag_cfg(struct rvu *rvu,
 	return 0;
 }
 
-static int nix_setup_mce(struct rvu *rvu, int mce, u8 op,
-			 u16 pcifunc, int next, bool eol)
+static int nix_blk_setup_mce(struct rvu *rvu, struct nix_hw *nix_hw,
+			     int mce, u8 op, u16 pcifunc, int next, bool eol)
 {
 	struct nix_aq_enq_req aq_req;
 	int err;
@@ -2014,7 +2024,7 @@ static int nix_setup_mce(struct rvu *rvu, int mce, u8 op,
 	/* All fields valid */
 	*(u64 *)(&aq_req.mce_mask) = ~0ULL;
 
-	err = rvu_nix_aq_enq_inst(rvu, &aq_req, NULL);
+	err = rvu_nix_blk_aq_enq_inst(rvu, nix_hw, &aq_req, NULL);
 	if (err) {
 		dev_err(rvu->dev, "Failed to setup Bcast MCE for PF%d:VF%d\n",
 			rvu_get_pf(pcifunc), pcifunc & RVU_PFVF_FUNC_MASK);
@@ -2120,9 +2130,9 @@ int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 
 		next_idx = idx + 1;
 		/* EOL should be set in last MCE */
-		err = nix_setup_mce(rvu, idx, NIX_AQ_INSTOP_WRITE,
-				    mce->pcifunc, next_idx,
-				    (next_idx > last_idx) ? true : false);
+		err = nix_blk_setup_mce(rvu, nix_hw, idx, NIX_AQ_INSTOP_WRITE,
+					mce->pcifunc, next_idx,
+					(next_idx > last_idx) ? true : false);
 		if (err)
 			goto end;
 		idx++;
@@ -2151,6 +2161,11 @@ static int nix_setup_bcast_tables(struct rvu *rvu, struct nix_hw *nix_hw)
 		numvfs = (cfg >> 12) & 0xFF;
 
 		pfvf = &rvu->pf[pf];
+
+		/* This NIX0/1 block mapped to PF ? */
+		if (pfvf->nix_blkaddr != nix_hw->blkaddr)
+			continue;
+
 		/* Save the start MCE */
 		pfvf->bcast_mce_idx = nix_alloc_mce_list(mcast, numvfs + 1);
 
@@ -2165,9 +2180,10 @@ static int nix_setup_bcast_tables(struct rvu *rvu, struct nix_hw *nix_hw)
 			 * Will be updated when a NIXLF is attached/detached to
 			 * these PF/VFs.
 			 */
-			err = nix_setup_mce(rvu, pfvf->bcast_mce_idx + idx,
-					    NIX_AQ_INSTOP_INIT,
-					    pcifunc, 0, true);
+			err = nix_blk_setup_mce(rvu, nix_hw,
+						pfvf->bcast_mce_idx + idx,
+						NIX_AQ_INSTOP_INIT,
+						pcifunc, 0, true);
 			if (err)
 				return err;
 		}
-- 
2.7.4

