Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D453828CB91
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgJMK0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgJMK0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:26:52 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE3CC0613D2
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:52 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hk7so474303pjb.2
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pmtSLsNOOW8G2LXBB5V8DeAGMiSYhaA498eQKjyFKpw=;
        b=AQ9KoxCeXi+s6cLai/+kPS4qqKblgs/YM+M89rfswuSr/ho65mO2WtNSnEACcTp+/N
         DdjnYuQSRYSTFSkoveLepzScWuX3jQq0ZgXHSc2oSa3J1BnLzshfvp7l2T8ubEUpI2Wf
         +IZ4XncMJpo/pJrmP30GbGuJSlKnMHsnMJvOgHFszP+yXSHQUbLuKb7nX92o/CJPWoyR
         fwudG68UcuAOkBmmDVO88UIQkjTFfLX4Pl4wAwFQRFdCqOTvYC4+01UOLGWaZWmhJmu6
         7u7+FlxqALjDUWl/b3UmqqPPIocuirB5qNeUzulqp0ebKZCqjMeNwC44pAd6G4gvIEtJ
         XS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pmtSLsNOOW8G2LXBB5V8DeAGMiSYhaA498eQKjyFKpw=;
        b=a84HziimHqfIG3s3A6I8EC+fobzSZfDFukb/07pOXDqtWL95+j+1/dBGdU5dwAKeSS
         33HZgRqowDQM66w6jyXWlAh39y094IY957ttuCpCoTbK47XBl/i/Gbe2huXkzblCqtzg
         rnzSwJYAHTYm+yppdJduPJgnOKBsYNQ5oCbnDs+TqmSw9CKA98IbgCQbxeu0l4fPjc4k
         wQZLGVz8yg3UnQeMs9Y6+0ZJ16FeLtBJF08ZCMsM8eu1waHPHhEr9eV54n4B6lGYqimK
         vwMunVjOw54TJW/c4Zj2KWabjloNSX5WHTo+s4/2Pr43LaRdn6DSdNSkNDq3A6ZHff/c
         G4cg==
X-Gm-Message-State: AOAM530wyTZklhIVFF2Nk49Cta5u46pbcRm6nBTrl+eckxyaKzw3f50A
        vXeUJleucECTMRZsCjGHw4JLkbfitkvDVg==
X-Google-Smtp-Source: ABdhPJxq8ZXkHOC+omnno1fArEUovyfUjjQ7kqzUerx7RXpV40J5Cc3yQWdITukX9RurU/9WHf2CPg==
X-Received: by 2002:a17:902:525:b029:d1:920c:c200 with SMTP id 34-20020a1709020525b02900d1920cc200mr27827796plf.25.1602584811988;
        Tue, 13 Oct 2020 03:26:51 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.26.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:26:51 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 02/10] octeontx2-af: Manage new blocks in 98xx
Date:   Tue, 13 Oct 2020 15:56:24 +0530
Message-Id: <1602584792-22274-3-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

AF manages the tasks of allocating, freeing
LFs from RVU blocks to PF and VFs. With new
NIX1 and CPT1 blocks in 98xx, this patch
adds support for handling new blocks too.

Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 142 ++++++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   4 +-
 3 files changed, 105 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index ead7711..2f59983 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -210,6 +210,9 @@ int rvu_get_lf(struct rvu *rvu, struct rvu_block *block, u16 pcifunc, u16 slot)
  * multiple blocks of same type.
  *
  * @pcifunc has to be zero when no LF is yet attached.
+ *
+ * For a pcifunc if LFs are attached from multiple blocks of same type, then
+ * return blkaddr of first encountered block.
  */
 int rvu_get_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
 {
@@ -258,20 +261,39 @@ int rvu_get_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
 		devnum = rvu_get_pf(pcifunc);
 	}
 
-	/* Check if the 'pcifunc' has a NIX LF from 'BLKADDR_NIX0' */
+	/* Check if the 'pcifunc' has a NIX LF from 'BLKADDR_NIX0' or
+	 * 'BLKADDR_NIX1'.
+	 */
 	if (blktype == BLKTYPE_NIX) {
-		reg = is_pf ? RVU_PRIV_PFX_NIX0_CFG : RVU_PRIV_HWVFX_NIX0_CFG;
+		reg = is_pf ? RVU_PRIV_PFX_NIXX_CFG(0) :
+			RVU_PRIV_HWVFX_NIXX_CFG(0);
 		cfg = rvu_read64(rvu, BLKADDR_RVUM, reg | (devnum << 16));
-		if (cfg)
+		if (cfg) {
 			blkaddr = BLKADDR_NIX0;
+			goto exit;
+		}
+
+		reg = is_pf ? RVU_PRIV_PFX_NIXX_CFG(1) :
+			RVU_PRIV_HWVFX_NIXX_CFG(1);
+		cfg = rvu_read64(rvu, BLKADDR_RVUM, reg | (devnum << 16));
+		if (cfg)
+			blkaddr = BLKADDR_NIX1;
 	}
 
-	/* Check if the 'pcifunc' has a CPT LF from 'BLKADDR_CPT0' */
 	if (blktype == BLKTYPE_CPT) {
-		reg = is_pf ? RVU_PRIV_PFX_CPT0_CFG : RVU_PRIV_HWVFX_CPT0_CFG;
+		reg = is_pf ? RVU_PRIV_PFX_CPTX_CFG(0) :
+			RVU_PRIV_HWVFX_CPTX_CFG(0);
 		cfg = rvu_read64(rvu, BLKADDR_RVUM, reg | (devnum << 16));
-		if (cfg)
+		if (cfg) {
 			blkaddr = BLKADDR_CPT0;
+			goto exit;
+		}
+
+		reg = is_pf ? RVU_PRIV_PFX_CPTX_CFG(1) :
+			RVU_PRIV_HWVFX_CPTX_CFG(1);
+		cfg = rvu_read64(rvu, BLKADDR_RVUM, reg | (devnum << 16));
+		if (cfg)
+			blkaddr = BLKADDR_CPT1;
 	}
 
 exit:
@@ -471,12 +493,16 @@ static void rvu_reset_all_blocks(struct rvu *rvu)
 	/* Do a HW reset of all RVU blocks */
 	rvu_block_reset(rvu, BLKADDR_NPA, NPA_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_NIX0, NIX_AF_BLK_RST);
+	rvu_block_reset(rvu, BLKADDR_NIX1, NIX_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_NPC, NPC_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_SSO, SSO_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_TIM, TIM_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_CPT0, CPT_AF_BLK_RST);
+	rvu_block_reset(rvu, BLKADDR_CPT1, CPT_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_NDC_NIX0_RX, NDC_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_NDC_NIX0_TX, NDC_AF_BLK_RST);
+	rvu_block_reset(rvu, BLKADDR_NDC_NIX1_RX, NDC_AF_BLK_RST);
+	rvu_block_reset(rvu, BLKADDR_NDC_NIX1_TX, NDC_AF_BLK_RST);
 	rvu_block_reset(rvu, BLKADDR_NDC_NPA0, NDC_AF_BLK_RST);
 }
 
@@ -762,6 +788,61 @@ static void rvu_fwdata_exit(struct rvu *rvu)
 		iounmap(rvu->fwdata);
 }
 
+static int rvu_setup_nix_hw_resource(struct rvu *rvu, int blkaddr)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkid;
+	u64 cfg;
+
+	/* Init NIX LF's bitmap */
+	block = &hw->block[blkaddr];
+	if (!block->implemented)
+		return 0;
+	blkid = (blkaddr == BLKADDR_NIX0) ? 0 : 1;
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST2);
+	block->lf.max = cfg & 0xFFF;
+	block->addr = blkaddr;
+	block->type = BLKTYPE_NIX;
+	block->lfshift = 8;
+	block->lookup_reg = NIX_AF_RVU_LF_CFG_DEBUG;
+	block->pf_lfcnt_reg = RVU_PRIV_PFX_NIXX_CFG(blkid);
+	block->vf_lfcnt_reg = RVU_PRIV_HWVFX_NIXX_CFG(blkid);
+	block->lfcfg_reg = NIX_PRIV_LFX_CFG;
+	block->msixcfg_reg = NIX_PRIV_LFX_INT_CFG;
+	block->lfreset_reg = NIX_AF_LF_RST;
+	sprintf(block->name, "NIX%d", blkid);
+	return rvu_alloc_bitmap(&block->lf);
+}
+
+static int rvu_setup_cpt_hw_resource(struct rvu *rvu, int blkaddr)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkid;
+	u64 cfg;
+
+	/* Init CPT LF's bitmap */
+	block = &hw->block[blkaddr];
+	if (!block->implemented)
+		return 0;
+	blkid = (blkaddr == BLKADDR_CPT0) ? 0 : 1;
+	cfg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS0);
+	block->lf.max = cfg & 0xFF;
+	block->addr = blkaddr;
+	block->type = BLKTYPE_CPT;
+	block->multislot = true;
+	block->lfshift = 3;
+	block->lookup_reg = CPT_AF_RVU_LF_CFG_DEBUG;
+	block->pf_lfcnt_reg = RVU_PRIV_PFX_CPTX_CFG(blkid);
+	block->vf_lfcnt_reg = RVU_PRIV_HWVFX_CPTX_CFG(blkid);
+	block->lfcfg_reg = CPT_PRIV_LFX_CFG;
+	block->msixcfg_reg = CPT_PRIV_LFX_INT_CFG;
+	block->lfreset_reg = CPT_AF_LF_RST;
+	sprintf(block->name, "CPT%d", blkid);
+	return rvu_alloc_bitmap(&block->lf);
+}
+
 static int rvu_setup_hw_resources(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -796,27 +877,13 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		return err;
 
 nix:
-	/* Init NIX LF's bitmap */
-	block = &hw->block[BLKADDR_NIX0];
-	if (!block->implemented)
-		goto sso;
-	cfg = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_CONST2);
-	block->lf.max = cfg & 0xFFF;
-	block->addr = BLKADDR_NIX0;
-	block->type = BLKTYPE_NIX;
-	block->lfshift = 8;
-	block->lookup_reg = NIX_AF_RVU_LF_CFG_DEBUG;
-	block->pf_lfcnt_reg = RVU_PRIV_PFX_NIX0_CFG;
-	block->vf_lfcnt_reg = RVU_PRIV_HWVFX_NIX0_CFG;
-	block->lfcfg_reg = NIX_PRIV_LFX_CFG;
-	block->msixcfg_reg = NIX_PRIV_LFX_INT_CFG;
-	block->lfreset_reg = NIX_AF_LF_RST;
-	sprintf(block->name, "NIX");
-	err = rvu_alloc_bitmap(&block->lf);
+	err = rvu_setup_nix_hw_resource(rvu, BLKADDR_NIX0);
+	if (err)
+		return err;
+	err = rvu_setup_nix_hw_resource(rvu, BLKADDR_NIX1);
 	if (err)
 		return err;
 
-sso:
 	/* Init SSO group's bitmap */
 	block = &hw->block[BLKADDR_SSO];
 	if (!block->implemented)
@@ -882,28 +949,13 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		return err;
 
 cpt:
-	/* Init CPT LF's bitmap */
-	block = &hw->block[BLKADDR_CPT0];
-	if (!block->implemented)
-		goto init;
-	cfg = rvu_read64(rvu, BLKADDR_CPT0, CPT_AF_CONSTANTS0);
-	block->lf.max = cfg & 0xFF;
-	block->addr = BLKADDR_CPT0;
-	block->type = BLKTYPE_CPT;
-	block->multislot = true;
-	block->lfshift = 3;
-	block->lookup_reg = CPT_AF_RVU_LF_CFG_DEBUG;
-	block->pf_lfcnt_reg = RVU_PRIV_PFX_CPT0_CFG;
-	block->vf_lfcnt_reg = RVU_PRIV_HWVFX_CPT0_CFG;
-	block->lfcfg_reg = CPT_PRIV_LFX_CFG;
-	block->msixcfg_reg = CPT_PRIV_LFX_INT_CFG;
-	block->lfreset_reg = CPT_AF_LF_RST;
-	sprintf(block->name, "CPT");
-	err = rvu_alloc_bitmap(&block->lf);
+	err = rvu_setup_cpt_hw_resource(rvu, BLKADDR_CPT0);
+	if (err)
+		return err;
+	err = rvu_setup_cpt_hw_resource(rvu, BLKADDR_CPT1);
 	if (err)
 		return err;
 
-init:
 	/* Allocate memory for PFVF data */
 	rvu->pf = devm_kcalloc(rvu->dev, hw->total_pfs,
 			       sizeof(struct rvu_pfvf), GFP_KERNEL);
@@ -1970,7 +2022,7 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 			continue;
 
 		/* Cleanup LF and reset it */
-		if (block->addr == BLKADDR_NIX0)
+		if (block->addr == BLKADDR_NIX0 || block->addr == BLKADDR_NIX1)
 			rvu_nix_lf_teardown(rvu, pcifunc, block->addr, lf);
 		else if (block->addr == BLKADDR_NPA)
 			rvu_npa_lf_teardown(rvu, pcifunc, lf);
@@ -1992,7 +2044,9 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	 * 3. Cleanup pools (NPA)
 	 */
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NIX0);
+	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NIX1);
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_CPT0);
+	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_CPT1);
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_TIM);
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_SSOW);
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_SSO);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 7ca599b..b929f8f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -54,20 +54,20 @@
 #define RVU_PRIV_PFX_MSIX_CFG(a)            (0x8000110 | (a) << 16)
 #define RVU_PRIV_PFX_ID_CFG(a)              (0x8000120 | (a) << 16)
 #define RVU_PRIV_PFX_INT_CFG(a)             (0x8000200 | (a) << 16)
-#define RVU_PRIV_PFX_NIX0_CFG               (0x8000300)
+#define RVU_PRIV_PFX_NIXX_CFG(a)            (0x8000300 | (a) << 3)
 #define RVU_PRIV_PFX_NPA_CFG		    (0x8000310)
 #define RVU_PRIV_PFX_SSO_CFG                (0x8000320)
 #define RVU_PRIV_PFX_SSOW_CFG               (0x8000330)
 #define RVU_PRIV_PFX_TIM_CFG                (0x8000340)
-#define RVU_PRIV_PFX_CPT0_CFG               (0x8000350)
+#define RVU_PRIV_PFX_CPTX_CFG(a)            (0x8000350 | (a) << 3)
 #define RVU_PRIV_BLOCK_TYPEX_REV(a)         (0x8000400 | (a) << 3)
 #define RVU_PRIV_HWVFX_INT_CFG(a)           (0x8001280 | (a) << 16)
-#define RVU_PRIV_HWVFX_NIX0_CFG             (0x8001300)
+#define RVU_PRIV_HWVFX_NIXX_CFG(a)          (0x8001300 | (a) << 3)
 #define RVU_PRIV_HWVFX_NPA_CFG              (0x8001310)
 #define RVU_PRIV_HWVFX_SSO_CFG              (0x8001320)
 #define RVU_PRIV_HWVFX_SSOW_CFG             (0x8001330)
 #define RVU_PRIV_HWVFX_TIM_CFG              (0x8001340)
-#define RVU_PRIV_HWVFX_CPT0_CFG             (0x8001350)
+#define RVU_PRIV_HWVFX_CPTX_CFG(a)          (0x8001350 | (a) << 3)
 
 /* RVU PF registers */
 #define	RVU_PF_VFX_PFVF_MBOX0		    (0x00000)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index a3ecb5d..6336de3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -31,7 +31,9 @@ enum rvu_block_addr_e {
 	BLKADDR_NDC_NIX0_RX	= 0xcULL,
 	BLKADDR_NDC_NIX0_TX	= 0xdULL,
 	BLKADDR_NDC_NPA0	= 0xeULL,
-	BLK_COUNT		= 0xfULL,
+	BLKADDR_NDC_NIX1_RX	= 0x10ULL,
+	BLKADDR_NDC_NIX1_TX	= 0x11ULL,
+	BLK_COUNT		= 0x12ULL,
 };
 
 /* RVU Block Type Enumeration */
-- 
2.7.4

