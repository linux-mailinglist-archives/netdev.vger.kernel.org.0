Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC603CCFCE
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhGSIUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:20:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235329AbhGSIUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:20:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J8u0CP006763;
        Mon, 19 Jul 2021 02:00:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Mhxo7/BQoNxox563+v7uPJJHTsUEZiYbnknktXQuYo4=;
 b=jJQV3NLrSlqg7c+0dmg1e1WXX6eYSaW8YJ5MwPcJVg9tVyDAxeg97Ru+NI5BjGF1/Axy
 ariXYwc7HpKuNExeqzeraMJ7djPFE74Fokb8Zo3Ore1TMMWixSerxFx210U2iHTx9I/0
 H5JduRRMdtEu0Hd3xeCo5okw0lHVU2sl7Ys/bvz+UNwHsRjnWm0Rg5d3wjYi9T7MWuCj
 7RVeD6IwsvZplBxoDsriPpjiuFnBvSwgFMMLiNiXL413reAlZ2TuL1FNWgHs7+/jYBt/
 Sm/8vn8B0cbyglKHEot2BjHiahpaSllLmYI9nWBitayFdqaKYQ8vew6udDwJWo8ijMDC Yw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39vytq961c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 02:00:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 19 Jul
 2021 01:59:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 19 Jul 2021 01:59:58 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 64C135E6861;
        Mon, 19 Jul 2021 01:59:56 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 1/3] octeontx2-af: Enable transmit side LBK link
Date:   Mon, 19 Jul 2021 14:29:32 +0530
Message-ID: <1626685174-4766-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
References: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GbOktZzIJ1WQuG5HZ1i6_XoJxOlLqdfl
X-Proofpoint-GUID: GbOktZzIJ1WQuG5HZ1i6_XoJxOlLqdfl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_02:2021-07-16,2021-07-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For enabling VF-VF switching the packets egressing
out of CGX mapped VFs needed to be sent to LBK
so that same packets are received back to the system.
But the LBK link also needs to be enabled in addition
to a VF's mapped CGX_LMAC link otherwise hardware
raises send error interrupt indicating selected LBK
link is not enabled in NIX_AF_TL3_TL2X_LINKX_CFG register.
Hence this patch enables all LBK links in
TL3_TL2_LINKX_CFG registers.
Also to enable packet flow between PFs/VFs of NIX0
to PFs/VFs of NIX1(in 98xx silicon) the NPC TX DMAC
rules has to be installed such that rules must be hit
for any TX interface i.e., NIX0-TX or NIX1-TX provided
DMAC match creteria is met. Hence this patch changes the
behavior such that MCAM is programmed to match with any
NIX0/1-TX interface for TX rules.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  6 ++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 32 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 15 ++++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  9 +++++-
 5 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 10cddf1..086eb6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2859,6 +2859,12 @@ static int rvu_enable_sriov(struct rvu *rvu)
 	if (!vfs)
 		return 0;
 
+	/* LBK channel number 63 is used for switching packets between
+	 * CGX mapped VFs. Hence limit LBK pairs till 62 only.
+	 */
+	if (vfs > 62)
+		vfs = 62;
+
 	/* Save VFs number for reference in VF interrupts handlers.
 	 * Since interrupts might start arriving during SRIOV enablement
 	 * ordinary API cannot be used to get number of enabled VFs.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 10e58a5..e53f530 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -415,6 +415,8 @@ struct npc_kpu_profile_adapter {
 	size_t				kpus;
 };
 
+#define RVU_SWITCH_LBK_CHAN	63
+
 struct rvu {
 	void __iomem		*afreg_base;
 	void __iomem		*pfreg_base;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index aeae377..a2d69ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1952,6 +1952,35 @@ static void nix_tl1_default_cfg(struct rvu *rvu, struct nix_hw *nix_hw,
 	pfvf_map[schq] = TXSCH_SET_FLAG(pfvf_map[schq], NIX_TXSCHQ_CFG_DONE);
 }
 
+static void rvu_nix_tx_tl2_cfg(struct rvu *rvu, int blkaddr,
+			       u16 pcifunc, struct nix_txsch *txsch)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int lbk_link_start, lbk_links;
+	u8 pf = rvu_get_pf(pcifunc);
+	int schq;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return;
+
+	lbk_link_start = hw->cgx_links;
+
+	for (schq = 0; schq < txsch->schq.max; schq++) {
+		if (TXSCH_MAP_FUNC(txsch->pfvf_map[schq]) != pcifunc)
+			continue;
+		/* Enable all LBK links with channel 63 by default so that
+		 * packets can be sent to LBK with a NPC TX MCAM rule
+		 */
+		lbk_links = hw->lbk_links;
+		while (lbk_links--)
+			rvu_write64(rvu, blkaddr,
+				    NIX_AF_TL3_TL2X_LINKX_CFG(schq,
+							      lbk_link_start +
+							      lbk_links),
+				    BIT_ULL(12) | RVU_SWITCH_LBK_CHAN);
+	}
+}
+
 int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 				    struct nix_txschq_config *req,
 				    struct msg_rsp *rsp)
@@ -2040,6 +2069,9 @@ int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 		rvu_write64(rvu, blkaddr, reg, regval);
 	}
 
+	rvu_nix_tx_tl2_cfg(rvu, blkaddr, pcifunc,
+			   &nix_hw->txsch[NIX_TXSCH_LVL_TL2]);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3612e0a..16c557c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -468,6 +468,8 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 {
 	int bank = npc_get_bank(mcam, index);
 	int kw = 0, actbank, actindex;
+	u8 tx_intf_mask = ~intf & 0x3;
+	u8 tx_intf = intf;
 	u64 cam0, cam1;
 
 	actbank = bank; /* Save bank id, to set action later on */
@@ -488,12 +490,21 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	 */
 	for (; bank < (actbank + mcam->banks_per_entry); bank++, kw = kw + 2) {
 		/* Interface should be set in all banks */
+		if (is_npc_intf_tx(intf)) {
+			/* Last bit must be set and rest don't care
+			 * for TX interfaces
+			 */
+			tx_intf_mask = 0x1;
+			tx_intf = intf & tx_intf_mask;
+			tx_intf_mask = ~tx_intf & tx_intf_mask;
+		}
+
 		rvu_write64(rvu, blkaddr,
 			    NPC_AF_MCAMEX_BANKX_CAMX_INTF(index, bank, 1),
-			    intf);
+			    tx_intf);
 		rvu_write64(rvu, blkaddr,
 			    NPC_AF_MCAMEX_BANKX_CAMX_INTF(index, bank, 0),
-			    ~intf & 0x3);
+			    tx_intf_mask);
 
 		/* Set the match key */
 		npc_get_keyword(entry, kw, &cam0, &cam1);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 6863314..92d64bd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -949,9 +949,16 @@ static void npc_update_tx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
 				struct npc_install_flow_req *req, u16 target)
 {
 	struct nix_tx_action action;
+	u64 mask = ~0ULL;
+
+	/* If AF is installing then do not care about
+	 * PF_FUNC in Send Descriptor
+	 */
+	if (is_pffunc_af(req->hdr.pcifunc))
+		mask = 0;
 
 	npc_update_entry(rvu, NPC_PF_FUNC, entry, (__force u16)htons(target),
-			 0, ~0ULL, 0, NIX_INTF_TX);
+			 0, mask, 0, NIX_INTF_TX);
 
 	*(u64 *)&action = 0x00;
 	action.op = req->op;
-- 
2.7.4

