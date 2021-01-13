Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EFF2F4E6B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbhAMPVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:21:36 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37720 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725949AbhAMPVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:21:35 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DF54pZ012940;
        Wed, 13 Jan 2021 07:20:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=T6ss/rWHUgoNN5WwCfQwU+KMInnNrI13C/m9NoNIBpM=;
 b=OnNhWq1tjNdI0qUX1BZomVN3zK9Vk6jZyfFwlpQfsWff0WVDwFuQRgWGqi4tp4w1WZXA
 KTXjFuVqbm/nZKGlZXmwagV0Q6MMVurUY9c+iSVo6eICFjYgsgLoGf6OZ1P2ONsujrO1
 lmmF5R4gm4PEDSiyrUX7T9XBLxtyKgnFP49iIeq/78r6D9n2OlURVlOwtpI4v5+U98Bn
 uWi/+foLROkNK3flyCt0nqWqK6j6TC1sj6VvFEpSWlZKioUs91ePwe/HtzUHknGUZZp4
 HW0xBtQtVWnA5ljQ43BoG5AdYkx8tZkGf3GyTdJGVtQMFsbzldNhe+oyvTleZFLlGq+4 nQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpuu09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 07:20:51 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 13 Jan
 2021 07:20:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 13 Jan
 2021 07:20:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 13 Jan 2021 07:20:49 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 551F13F7040;
        Wed, 13 Jan 2021 07:20:46 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH net-next,3/3] octeontx2-af: Handle CPT function level reset
Date:   Wed, 13 Jan 2021 20:50:07 +0530
Message-ID: <20210113152007.30293-4-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210113152007.30293-1-schalla@marvell.com>
References: <20210113152007.30293-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When FLR is initiated for a VF (PCI function level reset),
the parent PF gets a interrupt. PF then sends a message to
admin function (AF), which then cleans up all resources
attached to that VF. This patch adds support to handle
CPT FLR.

Signed-off-by: Narayana Prasad Raju Atherya <pathreya@marvell.com>
Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  3 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 74 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  8 ++
 4 files changed, 87 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e8fd712860a1..0d538b39462d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2150,6 +2150,9 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 			rvu_nix_lf_teardown(rvu, pcifunc, block->addr, lf);
 		else if (block->addr == BLKADDR_NPA)
 			rvu_npa_lf_teardown(rvu, pcifunc, lf);
+		else if ((block->addr == BLKADDR_CPT0) ||
+			 (block->addr == BLKADDR_CPT1))
+			rvu_cpt_lf_teardown(rvu, pcifunc, lf, slot);
 
 		err = rvu_lf_reset(rvu, block, lf);
 		if (err) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index b1a6ecfd563e..6f64a13e752a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -601,6 +601,8 @@ void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 int blkaddr, u16 src, struct mcam_entry *entry,
 			 u8 *intf, u8 *ena);
+/* CPT APIs */
+int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index b6de4b95a72a..ea435d7da975 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -240,3 +240,77 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 
 	return 0;
 }
+
+static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int slot)
+{
+	u64 inprog, grp_ptr;
+	int i = 0;
+
+	/* Disable instructions enqueuing */
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_CTL), 0x0);
+
+	/* Disable executions in the LF's queue */
+	inprog = rvu_read64(rvu, blkaddr,
+			    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+	inprog &= ~BIT_ULL(16);
+	rvu_write64(rvu, blkaddr,
+		    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG), inprog);
+
+	/* Wait for CPT queue to become execution-quiescent */
+	do {
+		inprog = rvu_read64(rvu, blkaddr,
+				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+		/* Check for partial entries (GRB_PARTIAL) */
+		if (inprog & BIT_ULL(31))
+			i = 0;
+		else
+			i++;
+
+		grp_ptr = rvu_read64(rvu, blkaddr,
+				     CPT_AF_BAR2_ALIASX(slot,
+							CPT_LF_Q_GRP_PTR));
+	} while ((i < 10) && (((grp_ptr >> 32) & 0x7FFF) !=
+				(grp_ptr & 0x7FFF)));
+
+	i = 0;
+	do {
+		inprog = rvu_read64(rvu, blkaddr,
+				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+		/* GWB writes groups of 40. So below formula is used for
+		 * knowing that no more instructions will be scheduled
+		 * (INFLIGHT == 0) && (GWB < 40) && (GRB == 0 OR 40)
+		 */
+		if (((inprog & 0x1FF) == 0) &&
+		    (((inprog >> 40) & 0xFF) < 40) &&
+		    ((((inprog >> 32) & 0xFF) == 0) ||
+		    (((inprog >> 32) & 0xFF) == 40)))
+			i++;
+		else
+			i = 0;
+	} while (i < 10);
+}
+
+int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot)
+{
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, pcifunc);
+	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
+		return -EINVAL;
+
+	/* Enable BAR2 ALIAS for this pcifunc. */
+	reg = BIT_ULL(16) | pcifunc;
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
+
+	cpt_lf_disable_iqueue(rvu, blkaddr, slot);
+
+	/* Set group drop to help clear out hardware */
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
+	reg |= BIT_ULL(17);
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG), reg);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 0fb2aa909a23..79a6dcf0e3c0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -484,9 +484,17 @@
 #define CPT_AF_RAS_INT_ENA_W1S          (0x47030)
 #define CPT_AF_RAS_INT_ENA_W1C          (0x47038)
 
+#define AF_BAR2_ALIASX(a, b)            (0x9100000ull | (a) << 12 | (b))
+#define CPT_AF_BAR2_SEL                 0x9000000
+#define CPT_AF_BAR2_ALIASX(a, b)        AF_BAR2_ALIASX(a, b)
+
 #define CPT_AF_LF_CTL2_SHIFT 3
 #define CPT_AF_LF_SSO_PF_FUNC_SHIFT 32
 
+#define CPT_LF_CTL                      0x10
+#define CPT_LF_INPROG                   0x40
+#define CPT_LF_Q_GRP_PTR                0x120
+
 #define NPC_AF_BLK_RST                  (0x00040)
 
 /* NPC */
-- 
2.29.0

