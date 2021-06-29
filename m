Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581A83B76D0
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhF2RC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:02:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7676 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234510AbhF2RCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 13:02:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TGofVt005575;
        Tue, 29 Jun 2021 10:00:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=k2xhezyg1iLCfm0QICjUiP8diNE8LG8wdB6fS8YjJ7E=;
 b=NfBavYYIPdcCpOtRDU6+lc1HrlRFLsbl5kiz3+4sc5t3zFrLIXXpwBzpRAQDmZM0RNMN
 TmpBJ2GsHV4gZw0Ra07GJx4SXYd9QX4hqDCdLEIKlYK3zKDJkGsLr9LZIIpIy8NTAhbb
 RCuV60yMdEaZfElqVdok1alUOo9R2lwzXVs0ngj5VSPkhzgfpIsfkwpeTriQi8896Tbf
 1D4kL2GfxCqwFWyZu8/sgnrpDaXOsLAytWqDow3SrfPjp6PLOwNarDJ7fElvRd3Me7bF
 6ryw0rkn/+pdzSsLPrZXa+wSjFxPFpPabupR5RMpQULgkIPkMl51VsXQMbiTkl5GI2dy RA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39f964ewjg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 10:00:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 10:00:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Jun 2021 10:00:18 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id F27235B693E;
        Tue, 29 Jun 2021 10:00:14 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <sgoutham@marvell.com>,
        <hkalra@marvell.com>
Subject: [net-next PATCH 2/3] octeontx2-af: cn10k: Support configurable LMTST regions
Date:   Tue, 29 Jun 2021 22:30:05 +0530
Message-ID: <20210629170006.722-3-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210629170006.722-1-gakula@marvell.com>
References: <20210629170006.722-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: U_stOqpiuUQuJ0N3lSgDhn3i4YyADquP
X-Proofpoint-GUID: U_stOqpiuUQuJ0N3lSgDhn3i4YyADquP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_10:2021-06-29,2021-06-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the lmtst_tbl_setup_req mbox to support run time
LMTST configuration.
RVU PF/VF and DPDK/ODP allocates a LMT region, creates a translation
entry for a device via VFIO IOCTLs.
This IOVA is shared with AF through above mbox. AF then uses
RVU_SMMU transulation Widget and gets PA for the IOVA and updates
the LMTtable entry for that device.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c | 130 +++++++++++++-----
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   5 +
 3 files changed, 103 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 638db868125a..9672cbf8a90a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1283,6 +1283,9 @@ struct set_vf_perm  {
 struct lmtst_tbl_setup_req {
 	struct mbox_msghdr hdr;
 	u16 base_pcifunc;
+	u8  use_local_lmt_region;
+	u64 lmt_iova;
+	u64 rsvd[4];
 };
 
 /* CPT mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 87f56e1f32e3..8d48b64485c6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -55,14 +55,101 @@ static u32 rvu_get_lmtst_tbl_index(struct rvu *rvu, u16 pcifunc)
 		(pcifunc & RVU_PFVF_FUNC_MASK)) * LMT_MAPTBL_ENTRY_SIZE;
 }
 
+static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
+			   u64 iova, u64 *lmt_addr)
+{
+	u64 pa, val, pf;
+	int err;
+
+	if (!iova) {
+		dev_err(rvu->dev, "%s Requested Null address for transulation\n", __func__);
+		return -EINVAL;
+	}
+
+	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_REQ, iova);
+	pf = rvu_get_pf(pcifunc) & 0x1F;
+	val = BIT_ULL(63) | BIT_ULL(14) | BIT_ULL(13) | pf << 8 |
+	      ((pcifunc & RVU_PFVF_FUNC_MASK) & 0xFF);
+	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TXN_REQ, val);
+
+	err = rvu_poll_reg(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_STS, BIT_ULL(0), false);
+	if (err) {
+		dev_err(rvu->dev, "%s LMTLINE iova transulation failed\n", __func__);
+		return err;
+	}
+	val = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_STS);
+	if (val & ~0x1ULL) {
+		dev_err(rvu->dev, "%s LMTLINE iova transulation failed err:%llx\n", __func__, val);
+		return -EIO;
+	}
+	/* PA[51:12] = RVU_AF_SMMU_TLN_FLIT1[60:21]
+	 * PA[11:0] = IOVA[11:0]
+	 */
+	pa = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TLN_FLIT1) >> 21;
+	pa &= GENMASK_ULL(39, 0);
+	*lmt_addr = (pa << 12) | (iova  & 0xFFF);
+
+	return 0;
+}
+
+static int rvu_update_lmtaddr(struct rvu *rvu, u16 pcifunc, u64 lmt_addr)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	u32 tbl_idx;
+	int err = 0;
+	u64 val;
+
+	/* Read the current lmt addr of pcifunc */
+	tbl_idx = rvu_get_lmtst_tbl_index(rvu, pcifunc);
+	err = lmtst_map_table_ops(rvu, tbl_idx, &val, LMT_TBL_OP_READ);
+	if (err) {
+		dev_err(rvu->dev,
+			"Failed to read LMT map table: index 0x%x err %d\n",
+			tbl_idx, err);
+		return err;
+	}
+
+	/* Storing the seondary's lmt base address as this needs to be
+	 * reverted in FLR. Also making sure this default value doesn't
+	 * get overwritten on multiple calls to this mailbox.
+	 */
+	if (!pfvf->lmt_base_addr)
+		pfvf->lmt_base_addr = val;
+
+	/* Update the LMT table with new addr */
+	err = lmtst_map_table_ops(rvu, tbl_idx, &lmt_addr, LMT_TBL_OP_WRITE);
+	if (err) {
+		dev_err(rvu->dev,
+			"Failed to update LMT map table: index 0x%x err %d\n",
+			tbl_idx, err);
+		return err;
+	}
+	return 0;
+}
+
 int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 				     struct lmtst_tbl_setup_req *req,
 				     struct msg_rsp *rsp)
 {
-	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
-	u32 pri_tbl_idx, sec_tbl_idx;
+	u64 lmt_addr, val;
+	u32 pri_tbl_idx;
 	int err = 0;
-	u64 val;
+
+	/* Check if PF_FUNC wants to use it's own local memory as LMTLINE
+	 * region, if so, convert that IOVA to physical address and
+	 * populate LMT table with that address
+	 */
+	if (req->use_local_lmt_region) {
+		err = rvu_get_lmtaddr(rvu, req->hdr.pcifunc,
+				      req->lmt_iova, &lmt_addr);
+		if (err < 0)
+			return err;
+
+		/* Update the lmt addr for this PFFUNC in the LMT table */
+		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, lmt_addr);
+		if (err)
+			return err;
+	}
 
 	/* Reconfiguring lmtst map table in lmt region shared mode i.e. make
 	 * multiple PF_FUNCs to share an LMTLINE region, so primary/base
@@ -76,27 +163,6 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 		 */
 		pri_tbl_idx = rvu_get_lmtst_tbl_index(rvu, req->base_pcifunc);
 
-		/* Truncating secondary pcifunc to calculate the LMT table index
-		 * equivalent to secondary pcifunc.
-		 */
-		sec_tbl_idx = rvu_get_lmtst_tbl_index(rvu, req->hdr.pcifunc);
-		/* Read the base lmt addr of the secondary pcifunc */
-		err = lmtst_map_table_ops(rvu, sec_tbl_idx, &val,
-					  LMT_TBL_OP_READ);
-		if (err) {
-			dev_err(rvu->dev,
-				"Failed to read LMT map table: index 0x%x err %d\n",
-				sec_tbl_idx, err);
-			goto error;
-		}
-
-		/* Storing the seondary's lmt base address as this needs to be
-		 * reverted in FLR. Also making sure this default value doesn't
-		 * get overwritten on multiple calls to this mailbox.
-		 */
-		if (!pfvf->lmt_base_addr)
-			pfvf->lmt_base_addr = val;
-
 		/* Read the base lmt addr of the primary pcifunc */
 		err = lmtst_map_table_ops(rvu, pri_tbl_idx, &val,
 					  LMT_TBL_OP_READ);
@@ -104,24 +170,18 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 			dev_err(rvu->dev,
 				"Failed to read LMT map table: index 0x%x err %d\n",
 				pri_tbl_idx, err);
-			goto error;
+			return err;
 		}
 
 		/* Update the base lmt addr of secondary with primary's base
 		 * lmt addr.
 		 */
-		err = lmtst_map_table_ops(rvu, sec_tbl_idx, &val,
-					  LMT_TBL_OP_WRITE);
-		if (err) {
-			dev_err(rvu->dev,
-				"Failed to update LMT map table: index 0x%x err %d\n",
-				sec_tbl_idx, err);
-			goto error;
-		}
+		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, val);
+		if (err)
+			return err;
 	}
 
-error:
-	return err;
+	return 0;
 }
 
 /* Resetting the lmtst map table to original base addresses */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 61bafe956aae..8b01ef6e2c99 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -49,6 +49,11 @@
 #define RVU_AF_PFX_VF_BAR4_ADDR             (0x5400 | (a) << 4)
 #define RVU_AF_PFX_VF_BAR4_CFG              (0x5600 | (a) << 4)
 #define RVU_AF_PFX_LMTLINE_ADDR             (0x5800 | (a) << 4)
+#define RVU_AF_SMMU_ADDR_REQ		    (0x6000)
+#define RVU_AF_SMMU_TXN_REQ		    (0x6008)
+#define RVU_AF_SMMU_ADDR_RSP_STS	    (0x6010)
+#define RVU_AF_SMMU_ADDR_TLN		    (0x6018)
+#define RVU_AF_SMMU_TLN_FLIT1		    (0x6030)
 
 /* Admin function's privileged PF/VF registers */
 #define RVU_PRIV_CONST                      (0x8000000)
-- 
2.17.1

