Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29441428A4C
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhJKKDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 06:03:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39366 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235718AbhJKKDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 06:03:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ANUFk2016732;
        Mon, 11 Oct 2021 03:01:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=KXYIN5ZH7dPatJ8M6+NgybdaSOiTeAoYQHOiTT4134A=;
 b=EKeksF/HXBtNywgBqkZgHiTVvpQ3eerngkJy4UpPFQJ9xflsc8ko7nJh5RxY1lH4Ek4a
 zOQQ0C1ntH3+jaAu5X/qsdcyc/h3tKSdLucj95FnNDYB5sa/FDivy3Hlygwl7Yh91WoZ
 hyEOo+ZWYHKqLet9zApIvb/TrfAy916pGRsF7I4WSeAB9vg+qvx3H7M7qbSP/CUxOacA
 1gVmUEw5pibTGKyTlDkO6XvVuAr8HUxaQfp91jUIufwxw9Nj80JbCldr0Eh7j3v9Xm5P
 gFoH5s5Z3cLK2RfQgRsVnOH9HD0yMwhukesUWPCjjHX/uFfZe3tpBXkxBtFnQ3TQD/om 4w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bm1s0ascp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:01:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 11 Oct
 2021 03:00:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 11 Oct 2021 03:00:58 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 534723F707E;
        Mon, 11 Oct 2021 03:00:54 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <schalla@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>
Subject: [PATCH net-next 2/3] octeontx2-af: Perform cpt lf teardown in non FLR path
Date:   Mon, 11 Oct 2021 15:30:42 +0530
Message-ID: <20211011100043.1657733-3-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011100043.1657733-1-schalla@marvell.com>
References: <20211011100043.1657733-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wNJ1wL8G75wCjfhgVfeUZhv0KlI9HsKo
X-Proofpoint-GUID: wNJ1wL8G75wCjfhgVfeUZhv0KlI9HsKo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_03,2021-10-07_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

Perform CPT LF teardown in non FLR path as well via cpt_lf_free()
Currently CPT LF teardown and reset sequence is only
done when FLR is handled with CPT LF still attached.

This patch also fixes cpt_lf_alloc() to set EXEC_LDWB in
CPT_AF_LFX_CTL2 when being completely overwritten as that is
the default value and is better for performance.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  3 +-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 32 +++++++++++--------
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 7487434c0405..09ca4ba9bc64 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2533,7 +2533,8 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 			rvu_npa_lf_teardown(rvu, pcifunc, lf);
 		else if ((block->addr == BLKADDR_CPT0) ||
 			 (block->addr == BLKADDR_CPT1))
-			rvu_cpt_lf_teardown(rvu, pcifunc, lf, slot);
+			rvu_cpt_lf_teardown(rvu, pcifunc, block->addr, lf,
+					    slot);
 
 		err = rvu_lf_reset(rvu, block, lf);
 		if (err) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index cdbd2846127d..75aa0b8cfe58 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -815,7 +815,8 @@ bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam, int blkaddr,
 /* CPT APIs */
 int rvu_cpt_register_interrupts(struct rvu *rvu);
 void rvu_cpt_unregister_interrupts(struct rvu *rvu);
-int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
+int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
+			int slot);
 
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index a59a2f17026f..a21533b5ef27 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -375,9 +375,13 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 
 		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
 
-		/* Set CPT LF NIX_PF_FUNC and SSO_PF_FUNC */
-		val = (u64)req->nix_pf_func << 48 |
-		      (u64)req->sso_pf_func << 32;
+		/* Set CPT LF NIX_PF_FUNC and SSO_PF_FUNC. EXE_LDWB is set
+		 * on reset.
+		 */
+		val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf));
+		val &= ~(GENMASK_ULL(63, 48) | GENMASK_ULL(47, 32));
+		val |= ((u64)req->nix_pf_func << 48 |
+			(u64)req->sso_pf_func << 32);
 		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), val);
 	}
 
@@ -387,7 +391,7 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 static int cpt_lf_free(struct rvu *rvu, struct msg_req *req, int blkaddr)
 {
 	u16 pcifunc = req->hdr.pcifunc;
-	int num_lfs, cptlf, slot;
+	int num_lfs, cptlf, slot, err;
 	struct rvu_block *block;
 
 	block = &rvu->hw->block[blkaddr];
@@ -401,10 +405,15 @@ static int cpt_lf_free(struct rvu *rvu, struct msg_req *req, int blkaddr)
 		if (cptlf < 0)
 			return CPT_AF_ERR_LF_INVALID;
 
-		/* Reset CPT LF group and priority */
-		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), 0x0);
-		/* Reset CPT LF NIX_PF_FUNC and SSO_PF_FUNC */
-		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), 0x0);
+		/* Perform teardown */
+		rvu_cpt_lf_teardown(rvu, pcifunc, blkaddr, cptlf, slot);
+
+		/* Reset LF */
+		err = rvu_lf_reset(rvu, block, cptlf);
+		if (err) {
+			dev_err(rvu->dev, "Failed to reset blkaddr %d LF%d\n",
+				block->addr, cptlf);
+		}
 	}
 
 	return 0;
@@ -848,15 +857,10 @@ static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int slot)
 		dev_warn(rvu->dev, "CPT FLR hits hard loop counter\n");
 }
 
-int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot)
+int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int slot)
 {
-	int blkaddr;
 	u64 reg;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, pcifunc);
-	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
-		return -EINVAL;
-
 	/* Enable BAR2 ALIAS for this pcifunc. */
 	reg = BIT_ULL(16) | pcifunc;
 	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
-- 
2.25.1

