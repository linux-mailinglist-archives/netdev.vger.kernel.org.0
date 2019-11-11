Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25ECBF7E8B
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfKKSj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:39:56 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39135 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728692AbfKKSjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:39:55 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so11230745pfo.6
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O84puTg6T69ldNuEOb50dicRPX7vl5jtCEhMtgqcSsc=;
        b=uKfYZ5seoSYqxD5cdHflMEPYTWODAsM/aFdSXNEh23sCkFuqiEkHTIAxcazvktf2PV
         13AmZLgkmRC2qXy6E0p8IBoyDQll9aF6iQ5kA46kbwlFhT//iuzd7caNZV7VMD85+wsU
         NBs+JWHKr1Zl4qVi7mQfMDFVtGwsOfcjsUeg9w8lI3W0aTIsvgxZpQ/FbQn3UAvV+A7f
         v3JXy11/eAWQd6dHX61uWYMshedPxMRnzY6frEOAYb/ylptF56x6HXI60TFdTxit9LbD
         WWf95VrYZkgJGRzzRH0lvGXI1rDd4u2T9sSMjM8pjskAFdtNuwy5QJW0iPwJaaEtmZuq
         4GcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O84puTg6T69ldNuEOb50dicRPX7vl5jtCEhMtgqcSsc=;
        b=PAY8ED5ACKxu364SY50IFVeXBviJdWEtCftqmcuOEeWtsJnMguiKVc7k63nCyjXxTK
         lloBRhJEDH4TlfGY72MX19I/WoCwpByNqHdRiLvTL4nKjy5fOOgu7hYWCtka+yltantn
         BNHe12mzGivsGUXUoq+MbxreEuNGdqLXfsUKimwOEqpo5fINNUlYOERSjmjXeE/0aeEh
         Mk8jdY17UCBWcPyn+6Spn+8u5uI9DdbCzjKBgoNs/KVM8mywJB1ZMBn6CzdbSodh3b+c
         lqQhR280QGDnLARx0cpAi1AudLpRwT3PPMkbiWEDc4NqZ0mqpAvXK9S+QkMuecaaMu35
         1zOg==
X-Gm-Message-State: APjAAAUZhC59tQ37xKhmudKKvbJ02FWptxSdBlhGd+hXu6FnrtByUgEn
        31iYkamYAaKlcRVc4TIlXTW6D//E1ks=
X-Google-Smtp-Source: APXvYqyawi+rmCeFYoDe1vqp+e/DpyhrM6yb2Mf7GWqO27GG0tQlgMF1hHSJoCbAFSdXfaND1FNfBA==
X-Received: by 2002:a17:90a:5d83:: with SMTP id t3mr583702pji.90.1573497593313;
        Mon, 11 Nov 2019 10:39:53 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id b5sm16921762pfp.149.2019.11.11.10.39.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 10:39:52 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 16/18] octeontx2-af: Support configurable NDC cache way_mask
Date:   Tue, 12 Nov 2019 00:08:12 +0530
Message-Id: <1573497494-11468-17-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Each of the NIX/NPA LFs can choose which ways of their respective
NDC caches should be used to cache their contexts. This enables
flexible configurations like disabling caching for a LF, limiting
it's context to a certain set of ways etc etc. Separate way_mask
for NIX-TX and NIX-RX is not supported.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 28 +++++++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  9 +++++--
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index fc9c731..f143d7b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -361,6 +361,7 @@ struct npa_lf_alloc_req {
 	int node;
 	int aura_sz;  /* No of auras */
 	u32 nr_pools; /* No of pools */
+	u64 way_mask;
 };
 
 struct npa_lf_alloc_rsp {
@@ -451,6 +452,7 @@ struct nix_lf_alloc_req {
 	u16 npa_func;
 	u16 sso_func;
 	u64 rx_cfg;   /* See NIX_AF_LF(0..127)_RX_CFG */
+	u64 way_mask;
 };
 
 struct nix_lf_alloc_rsp {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 4519d80..86042a7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -378,7 +378,8 @@ static void nix_ctx_free(struct rvu *rvu, struct rvu_pfvf *pfvf)
 
 static int nixlf_rss_ctx_init(struct rvu *rvu, int blkaddr,
 			      struct rvu_pfvf *pfvf, int nixlf,
-			      int rss_sz, int rss_grps, int hwctx_size)
+			      int rss_sz, int rss_grps, int hwctx_size,
+			      u64 way_mask)
 {
 	int err, grp, num_indices;
 
@@ -398,7 +399,8 @@ static int nixlf_rss_ctx_init(struct rvu *rvu, int blkaddr,
 	/* Config full RSS table size, enable RSS and caching */
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RSS_CFG(nixlf),
 		    BIT_ULL(36) | BIT_ULL(4) |
-		    ilog2(num_indices / MAX_RSS_INDIR_TBL_SIZE));
+		    ilog2(num_indices / MAX_RSS_INDIR_TBL_SIZE) |
+		    way_mask << 20);
 	/* Config RSS group offset and sizes */
 	for (grp = 0; grp < rss_grps; grp++)
 		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RSS_GRPX(nixlf, grp),
@@ -741,6 +743,9 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	if (!req->rq_cnt || !req->sq_cnt || !req->cq_cnt)
 		return NIX_AF_ERR_PARAM;
 
+	if (req->way_mask)
+		req->way_mask &= 0xFFFF;
+
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
 	if (!pfvf->nixlf || blkaddr < 0)
@@ -806,7 +811,7 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 		    (u64)pfvf->rq_ctx->iova);
 
 	/* Set caching and queue count in HW */
-	cfg = BIT_ULL(36) | (req->rq_cnt - 1);
+	cfg = BIT_ULL(36) | (req->rq_cnt - 1) | req->way_mask << 20;
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RQS_CFG(nixlf), cfg);
 
 	/* Alloc NIX SQ HW context memory and config the base */
@@ -821,7 +826,8 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_SQS_BASE(nixlf),
 		    (u64)pfvf->sq_ctx->iova);
-	cfg = BIT_ULL(36) | (req->sq_cnt - 1);
+
+	cfg = BIT_ULL(36) | (req->sq_cnt - 1) | req->way_mask << 20;
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_SQS_CFG(nixlf), cfg);
 
 	/* Alloc NIX CQ HW context memory and config the base */
@@ -836,13 +842,14 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CQS_BASE(nixlf),
 		    (u64)pfvf->cq_ctx->iova);
-	cfg = BIT_ULL(36) | (req->cq_cnt - 1);
+
+	cfg = BIT_ULL(36) | (req->cq_cnt - 1) | req->way_mask << 20;
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CQS_CFG(nixlf), cfg);
 
 	/* Initialize receive side scaling (RSS) */
 	hwctx_size = 1UL << ((ctx_cfg >> 12) & 0xF);
-	err = nixlf_rss_ctx_init(rvu, blkaddr, pfvf, nixlf,
-				 req->rss_sz, req->rss_grps, hwctx_size);
+	err = nixlf_rss_ctx_init(rvu, blkaddr, pfvf, nixlf, req->rss_sz,
+				 req->rss_grps, hwctx_size, req->way_mask);
 	if (err)
 		goto free_mem;
 
@@ -856,7 +863,9 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CINTS_BASE(nixlf),
 		    (u64)pfvf->cq_ints_ctx->iova);
-	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CINTS_CFG(nixlf), BIT_ULL(36));
+
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CINTS_CFG(nixlf),
+		    BIT_ULL(36) | req->way_mask << 20);
 
 	/* Alloc memory for QINT's HW contexts */
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST2);
@@ -868,7 +877,8 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_QINTS_BASE(nixlf),
 		    (u64)pfvf->nix_qints_ctx->iova);
-	rvu_write64(rvu, blkaddr, NIX_AF_LFX_QINTS_CFG(nixlf), BIT_ULL(36));
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_QINTS_CFG(nixlf),
+		    BIT_ULL(36) | req->way_mask << 20);
 
 	/* Setup VLANX TPID's.
 	 * Use VLAN1 for 802.1Q
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index e702a11..a8f9376 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -289,6 +289,9 @@ int rvu_mbox_handler_npa_lf_alloc(struct rvu *rvu,
 	    req->aura_sz == NPA_AURA_SZ_0 || !req->nr_pools)
 		return NPA_AF_ERR_PARAM;
 
+	if (req->way_mask)
+		req->way_mask &= 0xFFFF;
+
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, pcifunc);
 	if (!pfvf->npalf || blkaddr < 0)
@@ -345,7 +348,8 @@ int rvu_mbox_handler_npa_lf_alloc(struct rvu *rvu,
 	/* Clear way partition mask and set aura offset to '0' */
 	cfg &= ~(BIT_ULL(34) - 1);
 	/* Set aura size & enable caching of contexts */
-	cfg |= (req->aura_sz << 16) | BIT_ULL(34);
+	cfg |= (req->aura_sz << 16) | BIT_ULL(34) | req->way_mask;
+
 	rvu_write64(rvu, blkaddr, NPA_AF_LFX_AURAS_CFG(npalf), cfg);
 
 	/* Configure aura HW context's base */
@@ -353,7 +357,8 @@ int rvu_mbox_handler_npa_lf_alloc(struct rvu *rvu,
 		    (u64)pfvf->aura_ctx->iova);
 
 	/* Enable caching of qints hw context */
-	rvu_write64(rvu, blkaddr, NPA_AF_LFX_QINTS_CFG(npalf), BIT_ULL(36));
+	rvu_write64(rvu, blkaddr, NPA_AF_LFX_QINTS_CFG(npalf),
+		    BIT_ULL(36) | req->way_mask << 20);
 	rvu_write64(rvu, blkaddr, NPA_AF_LFX_QINTS_BASE(npalf),
 		    (u64)pfvf->npa_qints_ctx->iova);
 
-- 
2.7.4

