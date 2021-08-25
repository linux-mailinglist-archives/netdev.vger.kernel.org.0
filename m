Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B773F74F6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbhHYMUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:20:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9174 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240872AbhHYMTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:19:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6f2AP015535;
        Wed, 25 Aug 2021 05:19:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Fgo9lCn/hMJjhKHxTIOp/kWxhxTy9BC/VIVik49fvN8=;
 b=VUJyhnKa1tkoxA73tZG3gewGx6sr/M1JXKrj+kIgbhJT6aSjiALJWMV6Bwl4ohyFounb
 Z+mqgVtdUdmG8evBBxt0OyT75LrPfGSVQ9eVZYxd4r8Mo0TK/ybyS8w4C+WLD+fc541r
 QruaXmupK0pWkwD5aDA+XBOj9T7GpGluZN5fF2fYnWo9ZPOlb4FU0CHpxfxnNE7MU1jW
 Ut8Yk1jJWFUkbs1NXdrVlz7SnURlgd/XDDAyNv0O/nhFkbm+jq+hNOoJn6gwuPCWYVot
 ap2s2SRdi4gqND5OGfViCptu9NkFRfr74mFJRL3QWwBJE09qMAQ2MwIQPaEZP8LeD1va pQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017pv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:19:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:19:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:19:01 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id B65373F7067;
        Wed, 25 Aug 2021 05:18:59 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Harman Kalra <hkalra@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 4/9] octeontx2-af: nix and lbk in loop mode in 98xx
Date:   Wed, 25 Aug 2021 17:48:41 +0530
Message-ID: <1629893926-18398-5-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2EOZdOtPBwrSQZt34jiWdGcGwv005oOl
X-Proofpoint-GUID: 2EOZdOtPBwrSQZt34jiWdGcGwv005oOl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

In 98xx, there are 2 NIX blocks and 4 LBK blocks present. The way
these NIX-LBK should be configured depends on the use case. By
default loopback functionality is supported in AF VF pairs which
are attached to NIX0 and NIX1 LFs alternatively to ensure load
balancing. NIX0 transmits a packet to LBK1 which will be received
by NIX1 and packet transmitted by NIX1 will get received by NIX0 via
LBK2.

There are some requirements where only one AF VF is used and respective
NIX is expected to operate in a mode where it can receive it own packet
back. This can be achieved if NIX0 sends packet to LBK0 and not LBK1.
Adding a flag in LF alloc request mailbox which can setup NIX0 to use
LBK0 and NIX1 can use LBK3.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 29 +++++++++++++++++++---
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 487b834..ac1609f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -705,6 +705,7 @@ struct nix_lf_alloc_req {
 	u64 rx_cfg;   /* See NIX_AF_LF(0..127)_RX_CFG */
 	u64 way_mask;
 #define NIX_LF_RSS_TAG_LSB_AS_ADDER BIT_ULL(0)
+#define NIX_LF_LBK_BLK_SEL	    BIT_ULL(1)
 	u64 flags;
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index ab79232..7a6496a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -243,6 +243,7 @@ struct rvu_pfvf {
 	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 	u8	nix_rx_intf; /* NIX0_RX/NIX1_RX interface to NPC */
 	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
+	u8	lbkid;	     /* NIX0/1 lbk link ID */
 	u64     lmt_base_addr; /* Preseving the pcifunc's lmtst base addr*/
 	unsigned long flags;
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0cac0f3..2fbece5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -291,7 +291,7 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 }
 
 static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
-			      struct nix_lf_alloc_rsp *rsp)
+			      struct nix_lf_alloc_rsp *rsp, bool loop)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -344,6 +344,25 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
 		if (rvu->hw->lbk_links > 1)
 			lbkid = vf & 0x1 ? 0 : 1;
 
+		/* By default NIX0 is configured to send packet on lbk link 1
+		 * (which corresponds to LBK1), same packet will receive on
+		 * NIX1 over lbk link 0. If NIX1 sends packet on lbk link 0
+		 * (which corresponds to LBK2) packet will receive on NIX0 lbk
+		 * link 1.
+		 * But if lbk links for NIX0 and NIX1 are negated, i.e NIX0
+		 * transmits and receives on lbk link 0, whick corresponds
+		 * to LBK1 block, back to back connectivity between NIX and
+		 * LBK can be achieved (which is similar to 96xx)
+		 *
+		 *			RX		TX
+		 * NIX0 lbk link	1 (LBK2)	1 (LBK1)
+		 * NIX0 lbk link	0 (LBK0)	0 (LBK0)
+		 * NIX1 lbk link	0 (LBK1)	0 (LBK2)
+		 * NIX1 lbk link	1 (LBK3)	1 (LBK3)
+		 */
+		if (loop)
+			lbkid = !lbkid;
+
 		/* Note that AF's VFs work in pairs and talk over consecutive
 		 * loopback channels.Therefore if odd number of AF VFs are
 		 * enabled then the last VF remains with no pair.
@@ -355,6 +374,7 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
 		rsp->tx_link = hw->cgx_links + lbkid;
+		pfvf->lbkid = lbkid;
 		rvu_npc_set_pkind(rvu, NPC_RX_LBK_PKIND, pfvf);
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
@@ -1309,7 +1329,8 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
 
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
-	err = nix_interface_init(rvu, pcifunc, intf, nixlf, rsp);
+	err = nix_interface_init(rvu, pcifunc, intf, nixlf, rsp,
+				 !!(req->flags & NIX_LF_LBK_BLK_SEL));
 	if (err)
 		goto free_mem;
 
@@ -3766,6 +3787,7 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 	struct nix_txsch *txsch;
 	u64 cfg, lmac_fifo_len;
 	struct nix_hw *nix_hw;
+	struct rvu_pfvf *pfvf;
 	u8 cgx = 0, lmac = 0;
 	u16 max_mtu;
 
@@ -3822,7 +3844,8 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 		link = (cgx * hw->lmac_per_cgx) + lmac;
 	} else if (pf == 0) {
 		/* For VFs of PF0 ingress is LBK port, so config LBK link */
-		link = hw->cgx_links;
+		pfvf = rvu_get_pfvf(rvu, pcifunc);
+		link = hw->cgx_links + pfvf->lbkid;
 	}
 
 	if (link < 0)
-- 
2.7.4

