Return-Path: <netdev+bounces-9968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3348172B7E9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6195A1C20A2B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799855220;
	Mon, 12 Jun 2023 06:04:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5F679E0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:04:56 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02871E7B;
	Sun, 11 Jun 2023 23:04:55 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35BMr4WI028603;
	Sun, 11 Jun 2023 23:04:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=SIYtLTWRAHGdZ+9E8sbnIWjHfJRK3xn8D6DfEpmnv/Q=;
 b=kq5OEotUhaGQ5cKsMGs/4rM7CNhfBLoFmGQXZpXo2ibLbMk54sCBmyxgGYIlgIhp9IkX
 H4Q/dRH8Gthxn3naDjcwin7pjrKhqtsKLNd0skOvS+pNQSJF+nBtNtw6gxEHBMfDjHng
 HszJLITgi6kpYAzAkYZKRpdXn0HV/2Uiw89TQKzenPmuhF06sB8qhxaswRchRFvI6lLq
 kGlOodloQneYzILTZXNGw4CzinGAzpYJy1hhKk7bXeGWxl8aJYtr/mTpb/FMN1keZEqt
 Ku11oIVckuexoJ4r1Wppxcjk3Lcnkxl1+7ZheU9rc4ndPG9iGwhftFF5BzM5ka7/9Kb4 Pw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3r4phnc9u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 11 Jun 2023 23:04:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 11 Jun
 2023 23:04:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 11 Jun 2023 23:04:41 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id 20D755B6943;
	Sun, 11 Jun 2023 23:04:38 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Subbaraya Sundeep <sbhatta@marvell.com>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>
Subject: [net-next PATCH v2 4/6] octeontx2-af: Enable LBK links only when switch mode is on.
Date: Mon, 12 Jun 2023 11:34:22 +0530
Message-ID: <20230612060424.1427-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230612060424.1427-1-naveenm@marvell.com>
References: <20230612060424.1427-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 1Fu6Y1bK4xmyMTtnVvt82fljkwfYGkFD
X-Proofpoint-ORIG-GUID: 1Fu6Y1bK4xmyMTtnVvt82fljkwfYGkFD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_03,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Subbaraya Sundeep <sbhatta@marvell.com>

Currently, all the TL3_TL2 nodes are being configured to enable
switch LBK channel 63 in them. Instead enable them only when switch
mode is enabled.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h    |  2 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c    | 11 +++++------
 .../ethernet/marvell/octeontx2/af/rvu_switch.c | 18 ++++++++++++++++++
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 12e644bc239a..c07d826e36d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -806,6 +806,8 @@ int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc);
 int nix_get_dwrr_mtu_reg(struct rvu_hwinfo *hw, int smq_link_type);
 u32 convert_dwrr_mtu_to_bytes(u8 dwrr_mtu);
 u32 convert_bytes_to_dwrr_mtu(u32 bytes);
+void rvu_nix_tx_tl2_cfg(struct rvu *rvu, int blkaddr, u16 pcifunc,
+			struct nix_txsch *txsch, bool enable);
 
 /* NPC APIs */
 void rvu_npc_freemem(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f069d13dcb54..8a89cc5e5e40 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2460,17 +2460,19 @@ static int nix_txschq_cfg_read(struct rvu *rvu, struct nix_hw *nix_hw,
 	return 0;
 }
 
-static void rvu_nix_tx_tl2_cfg(struct rvu *rvu, int blkaddr,
-			       u16 pcifunc, struct nix_txsch *txsch)
+void rvu_nix_tx_tl2_cfg(struct rvu *rvu, int blkaddr, u16 pcifunc,
+			struct nix_txsch *txsch, bool enable)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	int lbk_link_start, lbk_links;
 	u8 pf = rvu_get_pf(pcifunc);
 	int schq;
+	u64 cfg;
 
 	if (!is_pf_cgxmapped(rvu, pf))
 		return;
 
+	cfg = enable ? (BIT_ULL(12) | RVU_SWITCH_LBK_CHAN) : 0;
 	lbk_link_start = hw->cgx_links;
 
 	for (schq = 0; schq < txsch->schq.max; schq++) {
@@ -2484,8 +2486,7 @@ static void rvu_nix_tx_tl2_cfg(struct rvu *rvu, int blkaddr,
 			rvu_write64(rvu, blkaddr,
 				    NIX_AF_TL3_TL2X_LINKX_CFG(schq,
 							      lbk_link_start +
-							      lbk_links),
-				    BIT_ULL(12) | RVU_SWITCH_LBK_CHAN);
+							      lbk_links), cfg);
 	}
 }
 
@@ -2591,8 +2592,6 @@ int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 		rvu_write64(rvu, blkaddr, reg, regval);
 	}
 
-	rvu_nix_tx_tl2_cfg(rvu, blkaddr, pcifunc,
-			   &nix_hw->txsch[NIX_TXSCH_LVL_TL2]);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
index 3392487f6b47..592b317f4637 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
@@ -8,6 +8,17 @@
 #include <linux/bitfield.h>
 #include "rvu.h"
 
+static void rvu_switch_enable_lbk_link(struct rvu *rvu, u16 pcifunc, bool enable)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct nix_hw *nix_hw;
+
+	nix_hw = get_nix_hw(rvu->hw, pfvf->nix_blkaddr);
+	/* Enable LBK links with channel 63 for TX MCAM rule */
+	rvu_nix_tx_tl2_cfg(rvu, pfvf->nix_blkaddr, pcifunc,
+			   &nix_hw->txsch[NIX_TXSCH_LVL_TL2], enable);
+}
+
 static int rvu_switch_install_rx_rule(struct rvu *rvu, u16 pcifunc,
 				      u16 chan_mask)
 {
@@ -52,6 +63,8 @@ static int rvu_switch_install_tx_rule(struct rvu *rvu, u16 pcifunc, u16 entry)
 	if (!test_bit(NIXLF_INITIALIZED, &pfvf->flags))
 		return 0;
 
+	rvu_switch_enable_lbk_link(rvu, pcifunc, true);
+
 	lbkid = pfvf->nix_blkaddr == BLKADDR_NIX0 ? 0 : 1;
 	ether_addr_copy(req.packet.dmac, pfvf->mac_addr);
 	eth_broadcast_addr((u8 *)&req.mask.dmac);
@@ -218,6 +231,9 @@ void rvu_switch_disable(struct rvu *rvu)
 				"Reverting RX rule for PF%d failed(%d)\n",
 				pf, err);
 
+		/* Disable LBK link */
+		rvu_switch_enable_lbk_link(rvu, pcifunc, false);
+
 		rvu_get_pf_numvfs(rvu, pf, &numvfs, NULL);
 		for (vf = 0; vf < numvfs; vf++) {
 			pcifunc = pf << 10 | ((vf + 1) & 0x3FF);
@@ -226,6 +242,8 @@ void rvu_switch_disable(struct rvu *rvu)
 				dev_err(rvu->dev,
 					"Reverting RX rule for PF%dVF%d failed(%d)\n",
 					pf, vf, err);
+
+			rvu_switch_enable_lbk_link(rvu, pcifunc, false);
 		}
 	}
 
-- 
2.39.0.198.ga38d39a4c5


