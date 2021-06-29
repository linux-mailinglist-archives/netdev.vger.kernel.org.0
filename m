Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141643B76CC
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhF2RCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:02:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1128 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234094AbhF2RCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 13:02:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TGoc8q024537;
        Tue, 29 Jun 2021 10:00:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=djfM5LTCum7iC5KUneLG+g2VtGgC3gqGcRBHaL9eVYc=;
 b=kBSJ5OS7LR9moUM6TVbvlBd4gO89y8JA/BK5QUGioDURyRRvkDVraPEwL2nH3OObXRNi
 ta7Ej5D20c6mMA7MP7gJK9uIEIZ3+6BBnbSDOsIje4hZmd39YHyOuyiD0j9XhoJcB0o2
 ySmrUeyBqsn8XMycDaxY+gPWhsw2GgynajGXSO/IVChFFlWyJ/j3+v4cZIoyhnETPXyZ
 qGzPqs/yIqurJtZIwuPeutW0JKv3aVUgm+Trd+l072dK5DsDn1SF/k21vNDHYjSuQgg0
 lkc/AEeCTE/szrYjPoj2y+nPbL8fqs+lk+EydymVkwjJku0oKth6hQs1Drizkf/Ay5yR 2A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39fuw53151-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 10:00:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 10:00:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Jun 2021 10:00:14 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 5570A5B692C;
        Tue, 29 Jun 2021 10:00:11 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <sgoutham@marvell.com>,
        <hkalra@marvell.com>
Subject: [net-next PATCH 1/3] octeontx2-af: cn10k: Setting up lmtst map table
Date:   Tue, 29 Jun 2021 22:30:04 +0530
Message-ID: <20210629170006.722-2-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210629170006.722-1-gakula@marvell.com>
References: <20210629170006.722-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JeezndI9Pau1nfkvXbyt3JGM4sTKPQHY
X-Proofpoint-GUID: JeezndI9Pau1nfkvXbyt3JGM4sTKPQHY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_10:2021-06-29,2021-06-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

Introducing a new mailbox to support updating lmt entries
and common lmt base address scheme i.e. multiple pcifuncs
can share lmt region to reduce L1 cache pressure for application.
Parameters passed to mailbox includes the primary pcifunc
value whose lmt regions will be shared by other secondary
pcifuncs. Here secondary pcifunc will be the one who is
calling the mailbox.
For example:
By default each pcifunc has its own LMT base address:
        PCIFUNC1    LMT_BASE_ADDR A
        PCIFUNC2    LMT_BASE_ADDR B
        PCIFUNC3    LMT_BASE_ADDR C
        PCIFUNC4    LMT_BASE_ADDR D
Application will choose PCIFUNC1 as base/primary pcifunc
and as and when other pcifunc(secondary pcifuncs) gets
probed, this mailbox will be called and LMTST table will
be updated as:
        PCIFUNC1    LMT_BASE_ADDR A
        PCIFUNC2    LMT_BASE_ADDR A
        PCIFUNC3    LMT_BASE_ADDR A
        PCIFUNC4    LMT_BASE_ADDR A

On FLR lmtst map table gets resetted to the default lmt
base addresses for all secondary pcifuncs.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   7 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c | 140 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   5 +
 .../marvell/octeontx2/af/rvu_struct.h         |   3 +-
 6 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 770d86262838..638db868125a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -134,6 +134,8 @@ M(MSIX_OFFSET,		0x005, msix_offset, msg_req, msix_offset_rsp)	\
 M(VF_FLR,		0x006, vf_flr, msg_req, msg_rsp)		\
 M(PTP_OP,		0x007, ptp_op, ptp_req, ptp_rsp)		\
 M(GET_HW_CAP,		0x008, get_hw_cap, msg_req, get_hw_cap_rsp)	\
+M(LMTST_TBL_SETUP,	0x00a, lmtst_tbl_setup, lmtst_tbl_setup_req,    \
+				msg_rsp)				\
 M(SET_VF_PERM,		0x00b, set_vf_perm, set_vf_perm, msg_rsp)	\
 /* CGX mbox IDs (range 0x200 - 0x3FF) */				\
 M(CGX_START_RXTX,	0x200, cgx_start_rxtx, msg_req, msg_rsp)	\
@@ -1278,6 +1280,11 @@ struct set_vf_perm  {
 	u64	flags;
 };
 
+struct lmtst_tbl_setup_req {
+	struct mbox_msghdr hdr;
+	u16 base_pcifunc;
+};
+
 /* CPT mailbox error codes
  * Range 901 - 1000.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 0b092949d7ac..10cddf1ac7b9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2333,6 +2333,7 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_SSOW);
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_SSO);
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
+	rvu_reset_lmt_map_tbl(rvu, pcifunc);
 	rvu_detach_rsrcs(rvu, NULL, pcifunc);
 	mutex_unlock(&rvu->flr_lock);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 9e5d9ba6f01e..3c0a7e981f72 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -243,6 +243,7 @@ struct rvu_pfvf {
 	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 	u8	nix_rx_intf; /* NIX0_RX/NIX1_RX interface to NPC */
 	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
+	u64     lmt_base_addr; /* Preseving the pcifunc's lmtst base addr*/
 	unsigned long flags;
 };
 
@@ -754,6 +755,9 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 int rvu_set_channels_base(struct rvu *rvu);
 void rvu_program_channels(struct rvu *rvu);
 
+/* CN10K RVU - LMT*/
+void rvu_reset_lmt_map_tbl(struct rvu *rvu, u16 pcifunc);
+
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
 void rvu_dbg_exit(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 7d9e71c6965f..87f56e1f32e3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -10,6 +10,146 @@
 #include "cgx.h"
 #include "rvu_reg.h"
 
+/* RVU LMTST */
+#define LMT_TBL_OP_READ		0
+#define LMT_TBL_OP_WRITE	1
+#define LMT_MAP_TABLE_SIZE	(128 * 1024)
+#define LMT_MAPTBL_ENTRY_SIZE	16
+
+/* Function to perform operations (read/write) on lmtst map table */
+static int lmtst_map_table_ops(struct rvu *rvu, u32 index, u64 *val,
+			       int lmt_tbl_op)
+{
+	void __iomem *lmt_map_base;
+	u64 tbl_base;
+
+	tbl_base = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_MAP_BASE);
+
+	lmt_map_base = ioremap_wc(tbl_base, LMT_MAP_TABLE_SIZE);
+	if (!lmt_map_base) {
+		dev_err(rvu->dev, "Failed to setup lmt map table mapping!!\n");
+		return -ENOMEM;
+	}
+
+	if (lmt_tbl_op == LMT_TBL_OP_READ) {
+		*val = readq(lmt_map_base + index);
+	} else {
+		writeq((*val), (lmt_map_base + index));
+		/* Flushing the AP interceptor cache to make APR_LMT_MAP_ENTRY_S
+		 * changes effective. Write 1 for flush and read is being used as a
+		 * barrier and sets up a data dependency. Write to 0 after a write
+		 * to 1 to complete the flush.
+		 */
+		rvu_write64(rvu, BLKADDR_APR, APR_AF_LMT_CTL, BIT_ULL(0));
+		rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_CTL);
+		rvu_write64(rvu, BLKADDR_APR, APR_AF_LMT_CTL, 0x00);
+	}
+
+	iounmap(lmt_map_base);
+	return 0;
+}
+
+static u32 rvu_get_lmtst_tbl_index(struct rvu *rvu, u16 pcifunc)
+{
+	return ((rvu_get_pf(pcifunc) * rvu->hw->total_vfs) +
+		(pcifunc & RVU_PFVF_FUNC_MASK)) * LMT_MAPTBL_ENTRY_SIZE;
+}
+
+int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
+				     struct lmtst_tbl_setup_req *req,
+				     struct msg_rsp *rsp)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+	u32 pri_tbl_idx, sec_tbl_idx;
+	int err = 0;
+	u64 val;
+
+	/* Reconfiguring lmtst map table in lmt region shared mode i.e. make
+	 * multiple PF_FUNCs to share an LMTLINE region, so primary/base
+	 * pcifunc (which is passed as an argument to mailbox) is the one
+	 * whose lmt base address will be shared among other secondary
+	 * pcifunc (will be the one who is calling this mailbox).
+	 */
+	if (req->base_pcifunc) {
+		/* Calculating the LMT table index equivalent to primary
+		 * pcifunc.
+		 */
+		pri_tbl_idx = rvu_get_lmtst_tbl_index(rvu, req->base_pcifunc);
+
+		/* Truncating secondary pcifunc to calculate the LMT table index
+		 * equivalent to secondary pcifunc.
+		 */
+		sec_tbl_idx = rvu_get_lmtst_tbl_index(rvu, req->hdr.pcifunc);
+		/* Read the base lmt addr of the secondary pcifunc */
+		err = lmtst_map_table_ops(rvu, sec_tbl_idx, &val,
+					  LMT_TBL_OP_READ);
+		if (err) {
+			dev_err(rvu->dev,
+				"Failed to read LMT map table: index 0x%x err %d\n",
+				sec_tbl_idx, err);
+			goto error;
+		}
+
+		/* Storing the seondary's lmt base address as this needs to be
+		 * reverted in FLR. Also making sure this default value doesn't
+		 * get overwritten on multiple calls to this mailbox.
+		 */
+		if (!pfvf->lmt_base_addr)
+			pfvf->lmt_base_addr = val;
+
+		/* Read the base lmt addr of the primary pcifunc */
+		err = lmtst_map_table_ops(rvu, pri_tbl_idx, &val,
+					  LMT_TBL_OP_READ);
+		if (err) {
+			dev_err(rvu->dev,
+				"Failed to read LMT map table: index 0x%x err %d\n",
+				pri_tbl_idx, err);
+			goto error;
+		}
+
+		/* Update the base lmt addr of secondary with primary's base
+		 * lmt addr.
+		 */
+		err = lmtst_map_table_ops(rvu, sec_tbl_idx, &val,
+					  LMT_TBL_OP_WRITE);
+		if (err) {
+			dev_err(rvu->dev,
+				"Failed to update LMT map table: index 0x%x err %d\n",
+				sec_tbl_idx, err);
+			goto error;
+		}
+	}
+
+error:
+	return err;
+}
+
+/* Resetting the lmtst map table to original base addresses */
+void rvu_reset_lmt_map_tbl(struct rvu *rvu, u16 pcifunc)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	u32 tbl_idx;
+	int err;
+
+	if (is_rvu_otx2(rvu))
+		return;
+
+	if (pfvf->lmt_base_addr) {
+		/* This corresponds to lmt map table index */
+		tbl_idx = rvu_get_lmtst_tbl_index(rvu, pcifunc);
+		/* Reverting back original lmt base addr for respective
+		 * pcifunc.
+		 */
+		err = lmtst_map_table_ops(rvu, tbl_idx, &pfvf->lmt_base_addr,
+					  LMT_TBL_OP_WRITE);
+		if (err)
+			dev_err(rvu->dev,
+				"Failed to update LMT map table: index 0x%x err %d\n",
+				tbl_idx, err);
+		pfvf->lmt_base_addr = 0;
+	}
+}
+
 int rvu_set_channels_base(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 76837d5e19c6..61bafe956aae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -692,4 +692,9 @@
 #define LBK_LINK_CFG_ID_MASK		GENMASK_ULL(11, 6)
 #define LBK_LINK_CFG_BASE_MASK		GENMASK_ULL(5, 0)
 
+/* APR */
+#define	APR_AF_LMT_CFG			(0x000ull)
+#define	APR_AF_LMT_MAP_BASE		(0x008ull)
+#define	APR_AF_LMT_CTL			(0x010ull)
+
 #endif /* RVU_REG_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 14aa8e37ea41..5bbe6727d11d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -35,7 +35,8 @@ enum rvu_block_addr_e {
 	BLKADDR_NDC_NPA0	= 0xeULL,
 	BLKADDR_NDC_NIX1_RX	= 0x10ULL,
 	BLKADDR_NDC_NIX1_TX	= 0x11ULL,
-	BLK_COUNT		= 0x12ULL,
+	BLKADDR_APR		= 0x16ULL,
+	BLK_COUNT		= 0x17ULL,
 };
 
 /* RVU Block Type Enumeration */
-- 
2.17.1

