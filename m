Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E93404D2C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbhIIMBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343998AbhIIL6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF36F613D1;
        Thu,  9 Sep 2021 11:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187942;
        bh=FJDEMwktXn6qoOVuuZ3UsTrU/a8iOrq0C9h8bgYPG6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agnM9wyK991SiTKcGukADw7WlRFbjYkIUwuxXboMZMpjtsunOcZsXMQMTAMqwaslM
         AR+DeSUzb2GEbAnarUQyK5y9nXu7zzzJJmvpM/4eqsknn96ZFmi865ZzfJKstFEwn0
         tjjlHkdteK60W/spUQQKAdxb6Vm449x8KtiTjb5JIRkjD3vOwLyKT+pgTTMP6gQdXQ
         r8O/5qD2V2zUGov7Bm1SiqbI22unQ78MnNqKBdDmaycTfxNOzOTAdsAADR/cWsguLr
         1J5IlrqW098i+rOy/RP+SjA4cK1g0OVz7hUdwIAbQ4sD9m98wqDiXA5FRiwz9qty27
         jBZAVETV1NmiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 212/252] octeontx2-pf: cleanup transmit link deriving logic
Date:   Thu,  9 Sep 2021 07:40:26 -0400
Message-Id: <20210909114106.141462-212-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 039190bb353a16657b44c5833bcad57e029c6934 ]

Unlike OcteonTx2, the channel numbers used by CGX/RPM
and LBK on CN10K silicons aren't fixed in HW. They are
SW programmable, hence we cannot derive transmit link
from static channel numbers anymore. Get the same from
admin function via mailbox.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  9 ++++++--
 .../marvell/octeontx2/nic/otx2_common.c       | 23 ++-----------------
 .../marvell/octeontx2/nic/otx2_common.h       |  1 +
 4 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f5ec39de026a..05f4334700e9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -717,6 +717,7 @@ struct nix_lf_alloc_rsp {
 	u8	cgx_links;  /* No. of CGX links present in HW */
 	u8	lbk_links;  /* No. of LBK links present in HW */
 	u8	sdp_links;  /* No. of SDP links present in HW */
+	u8	tx_link;    /* Transmit channel link number */
 };
 
 struct nix_lf_free_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 4bfbbdf38770..592230c3e171 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -249,9 +249,11 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 	return true;
 }
 
-static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
+static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
+			      struct nix_lf_alloc_rsp *rsp)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct rvu_hwinfo *hw = rvu->hw;
 	struct mac_ops *mac_ops;
 	int pkind, pf, vf, lbkid;
 	u8 cgx_id, lmac_id;
@@ -276,6 +278,8 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		pfvf->tx_chan_base = pfvf->rx_chan_base;
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
+		rsp->tx_link = cgx_id * hw->lmac_per_cgx + lmac_id;
+
 		cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, pkind);
 		rvu_npc_set_pkind(rvu, pkind, pfvf);
 
@@ -309,6 +313,7 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 					rvu_nix_chan_lbk(rvu, lbkid, vf + 1);
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
+		rsp->tx_link = hw->cgx_links + lbkid;
 		rvu_npc_set_pkind(rvu, NPC_RX_LBK_PKIND, pfvf);
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
@@ -1258,7 +1263,7 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
 
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
-	err = nix_interface_init(rvu, pcifunc, intf, nixlf);
+	err = nix_interface_init(rvu, pcifunc, intf, nixlf, rsp);
 	if (err)
 		goto free_mem;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 211200879b3e..791046eb9604 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -572,25 +572,6 @@ void otx2_get_mac_from_af(struct net_device *netdev)
 }
 EXPORT_SYMBOL(otx2_get_mac_from_af);
 
-static int otx2_get_link(struct otx2_nic *pfvf)
-{
-	int link = 0;
-	u16 map;
-
-	/* cgx lmac link */
-	if (pfvf->hw.tx_chan_base >= CGX_CHAN_BASE) {
-		map = pfvf->hw.tx_chan_base & 0x7FF;
-		link = 4 * ((map >> 8) & 0xF) + ((map >> 4) & 0xF);
-	}
-	/* LBK channel */
-	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE) {
-		map = pfvf->hw.tx_chan_base & 0x7FF;
-		link = pfvf->hw.cgx_links | ((map >> 8) & 0xF);
-	}
-
-	return link;
-}
-
 int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 {
 	struct otx2_hw *hw = &pfvf->hw;
@@ -646,8 +627,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | DFLT_RR_QTM;
 
 		req->num_regs++;
-		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq,
-							otx2_get_link(pfvf));
+		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
 		/* Enable this queue and backpressure */
 		req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
 
@@ -1592,6 +1572,7 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
 	pfvf->hw.cgx_links = rsp->cgx_links;
 	pfvf->hw.lbk_links = rsp->lbk_links;
+	pfvf->hw.tx_link = rsp->tx_link;
 }
 EXPORT_SYMBOL(mbox_handler_nix_lf_alloc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 8fd58cd07f50..93b17bbb9b44 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -212,6 +212,7 @@ struct otx2_hw {
 	u64			cgx_fec_uncorr_blks;
 	u8			cgx_links;  /* No. of CGX links present in HW */
 	u8			lbk_links;  /* No. of LBK links present in HW */
+	u8			tx_link;    /* Transmit channel link number */
 #define HW_TSO			0
 #define CN10K_MBOX		1
 #define CN10K_LMTST		2
-- 
2.30.2

