Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD669A55A
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 06:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBQFvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 00:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBQFvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 00:51:39 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83A1498AA;
        Thu, 16 Feb 2023 21:51:37 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H4ooQK025324;
        Thu, 16 Feb 2023 21:51:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=tu33G6lhev8kVTyM8hrj3AyzN0usSGMur2dZeAoSfhU=;
 b=J2TgeuqwI5D4jjzKKCqjtK61qKKvXNp/22c7U5vbjRD8TWZ/micaAnJl3oaAj3OGH3aQ
 ix8LYvdUmAFDvBdKjslhSUtKDzjxkk2Qw6l2ZrqW2cuP2196vO7U2IRIcm/ChE4tvIC5
 TkLbZK/RTBsquMWBBVAg70eI2RIE6zvPLCTDJqKMR374Jg1tZu2V44NbP4kvJsdPrnVL
 lP8QDJltGuvKkJIZgfa1qtcx0QuMn6POvQ75RR12mVT61KdfSJ/9ESHT66MzvLTwFNit
 pWS+9F/+KrfhkBDbvRs30GNgSn6qAoeXR20Ve+6/wTZ5QjJsA1iC2tLatwb/TZNeYSQk Lg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nsg6wdu77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 21:51:24 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Feb
 2023 21:51:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Thu, 16 Feb 2023 21:51:22 -0800
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 77F823F706B;
        Thu, 16 Feb 2023 21:51:19 -0800 (PST)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Add NIX Errata workaround on CN10K silicon
Date:   Fri, 17 Feb 2023 11:21:12 +0530
Message-ID: <20230217055112.1248842-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Jl4JikID5YgAq7U2MJcIfNYiaYNTexoC
X-Proofpoint-GUID: Jl4JikID5YgAq7U2MJcIfNYiaYNTexoC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_02,2023-02-16_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

This patch adds workaround for below 2 HW erratas

1. Due to improper clock gating, NIXRX may free the same
NPA buffer multiple times.. to avoid this, always enable
NIX RX conditional clock.

2. NIX FIFO does not get initialized on reset, if the SMQ
flush is triggered before the first packet is processed, it
will lead to undefined state. The workaround to perform SMQ
flush only if packet count is non-zero in MDQ.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h    |  3 +++
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 18 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c    | 10 ++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h    |  2 ++
 4 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 5eea2b6cf6bd..389663a13d1d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -888,6 +888,9 @@ int rvu_cpt_init(struct rvu *rvu);
 int rvu_set_channels_base(struct rvu *rvu);
 void rvu_program_channels(struct rvu *rvu);
 
+/* CN10K NIX */
+void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw);
+
 /* CN10K RVU - LMT*/
 void rvu_reset_lmt_map_tbl(struct rvu *rvu, u16 pcifunc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 7dbbc115cde4..4ad9ff025c96 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -538,3 +538,21 @@ void rvu_program_channels(struct rvu *rvu)
 	rvu_lbk_set_channels(rvu);
 	rvu_rpm_set_channels(rvu);
 }
+
+void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
+{
+	int blkaddr = nix_hw->blkaddr;
+	u64 cfg;
+
+	/* Set AF vWQE timer interval to a LF configurable range of
+	 * 6.4us to 1.632ms.
+	 */
+	rvu_write64(rvu, blkaddr, NIX_AF_VWQE_TIMER, 0x3FULL);
+
+	/* Enable NIX RX stream and global conditional clock to
+	 * avoild multiple free of NPA buffers.
+	 */
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CFG);
+	cfg |= BIT_ULL(1) | BIT_ULL(2);
+	rvu_write64(rvu, blkaddr, NIX_AF_CFG, cfg);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 89e94569e74c..26e639e57dae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2058,6 +2058,13 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	int err, restore_tx_en = 0;
 	u64 cfg;
 
+	if (!is_rvu_otx2(rvu)) {
+		/* Skip SMQ flush if pkt count is zero */
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_MDQX_IN_MD_COUNT(smq));
+		if (!cfg)
+			return 0;
+	}
+
 	/* enable cgx tx if disabled */
 	if (is_pf_cgxmapped(rvu, pf)) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
@@ -4309,6 +4316,9 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 
 	rvu_write64(rvu, blkaddr, NIX_AF_SEB_CFG, cfg);
 
+	if (!is_rvu_otx2(rvu))
+		rvu_nix_block_cn10k_init(rvu, nix_hw);
+
 	if (is_block_implemented(hw, blkaddr)) {
 		err = nix_setup_txschq(rvu, nix_hw, blkaddr);
 		if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 5437bd20c719..1729b22580ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -189,6 +189,7 @@
 #define NIX_AF_RX_CFG			(0x00D0)
 #define NIX_AF_AVG_DELAY		(0x00E0)
 #define NIX_AF_CINT_DELAY		(0x00F0)
+#define NIX_AF_VWQE_TIMER		(0x00F8)
 #define NIX_AF_RX_MCAST_BASE		(0x0100)
 #define NIX_AF_RX_MCAST_CFG		(0x0110)
 #define NIX_AF_RX_MCAST_BUF_BASE	(0x0120)
@@ -426,6 +427,7 @@
 #define NIX_AF_RX_NPC_MIRROR_DROP	(0x4730)
 #define NIX_AF_RX_ACTIVE_CYCLES_PCX(a)	(0x4800 | (a) << 16)
 #define NIX_AF_LINKX_CFG(a)		(0x4010 | (a) << 17)
+#define NIX_AF_MDQX_IN_MD_COUNT(a)	(0x14e0 | (a) << 16)
 
 #define NIX_PRIV_AF_INT_CFG		(0x8000000)
 #define NIX_PRIV_LFX_CFG		(0x8000010)
-- 
2.25.1

