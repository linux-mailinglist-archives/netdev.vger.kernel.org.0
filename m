Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0D9343250
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhCUMKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:10:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48506 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229944AbhCUMKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC5irD023822;
        Sun, 21 Mar 2021 05:10:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=aDEzqQT6mqV4m4i0RDXZbaPkZZp9sGjqRefU7rILAF8=;
 b=OFoxueLSRvX1gPWBqSMULmcmQwYqjE2x3OYRbhE2t9OOsUic4vsoXIrKDPCew/KbBVDL
 jIHS/P7AiL0U87Tm4JeQ+yJKVpt+mxJhPmVdr1uyoUeWi03Ah+iQCTU9AmZqrqpAJUSz
 LYdVpYpqjdpw+tpFj3TS7bg4Fhiro/otCXZ4cr2R1XISx7PmOFNc/LCixoIxyp7Ih60h
 jND9Wstx0a/rs2dSbQYn1PvH1W7+xO+znsAU7yb9lw3bHcMHfeE46exOPg0FJGxlSdPj
 UcaP08u5NDQHpLc4Aql/ZWt3z2DiqLf3qLezAcBEQPFQ8g12utje73wt+uuGu1uAyyMc bg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrab2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:16 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id C864B3F7051;
        Sun, 21 Mar 2021 05:10:13 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 4/8] octeontx2-af: Do not allow VFs to overwrite PKIND config
Date:   Sun, 21 Mar 2021 17:39:54 +0530
Message-ID: <20210321120958.17531-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210321120958.17531-1-hkelam@marvell.com>
References: <20210321120958.17531-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-21_01:2021-03-19,2021-03-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When switch headers like EDSA, Higig2 etc are present in ingress
or egress packets the packet parsing done by NPC needs to take additional
headers into account. KPU profile handles these using specific
PKINDs (the iKPU index) to  parse these packets differently.

AF writes these pkinds to HW upon receiving NPC_SET_PKIND mbox request.
But in nix_lf_alloc mbox request from VF, AF writes default RX/TX
pkinds to HW. Since PF and its VFs share same CGX/LMAC pair, earlier
configuration is getting overwritten. Ideally VF should not override PF
configuration. This patch adds proper validation to ensure the same.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 12 +++++++
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 36 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 14 +++++---
 5 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 294e7d12f15..aa86691885d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -231,6 +231,18 @@ int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind)
 	return 0;
 }
 
+int cgx_get_pkind(void *cgxd, u8 lmac_id, int *pkind)
+{
+	struct cgx *cgx = cgxd;
+
+	if (!is_lmac_valid(cgx, lmac_id))
+		return -ENODEV;
+
+	*pkind = cgx_read(cgx, lmac_id, CGXX_CMRX_RX_ID_MAP);
+	*pkind = *pkind & 0x3F;
+	return 0;
+}
+
 static u8 cgx_get_lmac_type(void *cgxd, int lmac_id)
 {
 	struct cgx *cgx = cgxd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 10b5611a3b4..237a91b801e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -167,4 +167,5 @@ void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val);
 u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
 int cgx_set_phy_mod_type(int mod, void *cgxd, int lmac_id);
 int cgx_get_phy_mod_type(void *cgxd, int lmac_id);
+int cgx_get_pkind(void *cgxd, u8 lmac_id, int *pkind);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 2b31ecd3d21..292351bad5b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -617,6 +617,7 @@ int rvu_cgx_start_stop_io(struct rvu *rvu, u16 pcifunc, bool start);
 int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
 bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc);
+bool rvu_cgx_is_pkind_config_permitted(struct rvu *rvu, u16 pcifunc);
 
 /* NPA APIs */
 int rvu_npa_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 992e53e56c3..9c30692070b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -970,3 +970,39 @@ int rvu_mbox_handler_cgx_get_phy_mod_type(struct rvu *rvu, struct msg_req *req,
 		return rsp->mod;
 	return 0;
 }
+
+/* Dont allow cgx mapped VFs to overwrite PKIND config
+ * incase of special PKINDs are configured like (HIGIG/EDSA)
+ */
+bool rvu_cgx_is_pkind_config_permitted(struct rvu *rvu, u16 pcifunc)
+{
+	int rc, pf, rxpkind;
+	u8 cgx_id, lmac_id;
+
+	pf = rvu_get_pf(pcifunc);
+
+	/* Ret here for PFs or non cgx interfaces */
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+		return true;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return true;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	rc = cgx_get_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, &rxpkind);
+	if (rc)
+		return false;
+
+	switch (rxpkind) {
+	/* Add here specific pkinds reserved for pkt parsing */
+	case NPC_RX_HIGIG_PKIND:
+	case NPC_RX_EDSA_PKIND:
+		rc = false;
+		break;
+	default:
+		rc = true;
+	}
+
+	return rc;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 42cc443e6e8..ed96ebc4022 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -239,8 +239,12 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		pfvf->tx_chan_base = pfvf->rx_chan_base;
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
-		cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, pkind);
-		rvu_npc_set_pkind(rvu, pkind, pfvf);
+
+		if (rvu_cgx_is_pkind_config_permitted(rvu, pcifunc)) {
+			cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				      pkind);
+			rvu_npc_set_pkind(rvu, pkind, pfvf);
+		}
 
 		mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
 		/* By default we enable pause frames */
@@ -1196,8 +1200,10 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_CFG(nixlf), req->rx_cfg);
 
 	/* Configure pkind for TX parse config */
-	cfg = NPC_TX_DEF_PKIND;
-	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
+	if (rvu_cgx_is_pkind_config_permitted(rvu, pcifunc)) {
+		cfg = NPC_TX_DEF_PKIND;
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
+	}
 
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
 	err = nix_interface_init(rvu, pcifunc, intf, nixlf);
-- 
2.17.1

