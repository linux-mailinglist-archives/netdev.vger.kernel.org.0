Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F96234324F
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCUMKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:10:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40940 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhCUMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC4gfj017682;
        Sun, 21 Mar 2021 05:10:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RdhvS/vQ0KeJ/J+H5yxAcMB0IHz+M2KD6lHcX/Eu+8s=;
 b=MFwmawtJlVY1d1PhNzPED7gafntnrpqXvTBsAduOUuWu3iM7khRqB0ET8ag3IxlZG9DH
 Nx2nUp5QmRvbRJarp3v5zfzDdHQXuEBcoPUwPvihltwVweIRWsDPlz/kvILlojdjv5V3
 fJlBv9wrQzCGIgJWNe85owajIoiRusyWNvUXHXieYCubadFBvQnWp20CGzf/S0Y5eQi6
 +JlvvWKjjAQsl/D4P1EW/n99poTCwdyVSbcX+hr9K/pfl1QF5YEu6eQ3Zg2gTGvrQX/3
 AMEAXJWoEjqAvhfN5hT12NXsjPtOkxRpZP6Tztm0L67miVklBCB/X0myNKCW710OTn7D jQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnt34t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:13 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6C26B3F704A;
        Sun, 21 Mar 2021 05:10:10 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 3/8] octeontx2-af: Support for parsing pkts with switch headers
Date:   Sun, 21 Mar 2021 17:39:53 +0530
Message-ID: <20210321120958.17531-4-hkelam@marvell.com>
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

Switch headers are designed to support better flow control and
loadbalancing etc. When switch headers like EDSA, Higig2 etc are
present in ingress or egress pkts default iKPU index (or PKIND)
used by NPC to parse pkts will not work as there are additional
headers appended to the pkt. Hence a separate Pkind is chosen on
Rx and/or Tx sides to tell to KPU to parse the pkts accordingly.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 14 +++++
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  6 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  4 ++
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  4 ++
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 54 +++++++++++++++++++
 6 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 66ab320b845..1ce22782260 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -222,6 +222,8 @@ M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
 M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
 				   npc_mcam_get_stats_req,              \
 				   npc_mcam_get_stats_rsp)              \
+M(NPC_SET_PKIND,	   0x6013, npc_set_pkind,                        \
+				   npc_set_pkind, msg_rsp)               \
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
@@ -475,6 +477,18 @@ struct cgx_fw_data {
 	struct cgx_lmac_fwdata_s fwdata;
 };
 
+struct npc_set_pkind {
+	struct mbox_msghdr hdr;
+#define OTX2_PRIV_FLAGS_DEFAULT  BIT_ULL(0)
+#define OTX2_PRIV_FLAGS_EDSA     BIT_ULL(1)
+#define OTX2_PRIV_FLAGS_HIGIG    BIT_ULL(2)
+#define OTX2_PRIV_FLAGS_CUSTOM   BIT_ULL(63)
+	u64 mode;
+#define PKIND_TX		BIT_ULL(0)
+#define PKIND_RX		BIT_ULL(1)
+	u8 dir;
+	u8 pkind; /* valid only in case custom flag */
+};
 struct cgx_set_link_mode_args {
 	u32 speed;
 	u8 duplex;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 1e012e78726..e60f1fa2d55 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -146,7 +146,11 @@ enum npc_kpu_lh_ltype {
  * Ethernet interfaces, LBK interfaces, etc.
  */
 enum npc_pkind_type {
-	NPC_TX_DEF_PKIND = 63ULL,	/* NIX-TX PKIND */
+	NPC_TX_HIGIG_PKIND = 60ULL,
+	NPC_RX_HIGIG_PKIND,
+	NPC_RX_EDSA_PKIND,
+	NPC_TX_DEF_PKIND,
+
 };
 
 /* list of known and supported fields in packet header and
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index baaba01bd8c..2b31ecd3d21 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -616,6 +616,8 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable);
 int rvu_cgx_start_stop_io(struct rvu *rvu, u16 pcifunc, bool start);
 int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
+bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc);
+
 /* NPA APIs */
 int rvu_npa_init(struct rvu *rvu);
 void rvu_npa_freemem(struct rvu *rvu);
@@ -682,6 +684,8 @@ void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 u8 *intf, u8 *ena);
 bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
+int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
+			   u64 pkind);
 
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index b78e48d18f6..992e53e56c3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -396,7 +396,7 @@ int rvu_cgx_exit(struct rvu *rvu)
  * VF's of mapped PF and other PFs are not allowed. This fn() checks
  * whether a PFFUNC is permitted to do the config or not.
  */
-static bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
+bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
 {
 	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
 	    !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index a8710412134..42cc443e6e8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1284,6 +1284,10 @@ int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct nix_lf_free_req *req,
 		return NIX_AF_ERR_LF_RESET;
 	}
 
+	/* reset HW config done for Switch headers */
+	rvu_npc_set_parse_mode(rvu, pcifunc, OTX2_PRIV_FLAGS_DEFAULT,
+			       (PKIND_TX | PKIND_RX), 0);
+
 	nix_ctx_free(rvu, pfvf);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 16d7797b7a1..802668e1f90 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2845,3 +2845,57 @@ int rvu_mbox_handler_npc_mcam_entry_stats(struct rvu *rvu,
 
 	return 0;
 }
+
+int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
+			   u64 pkind)
+{
+	int pf = rvu_get_pf(pcifunc);
+	int blkaddr, nixlf, rc;
+	u64 rxpkind, txpkind;
+	u8 cgx_id, lmac_id;
+
+	/* use default pkind to disable edsa/higig */
+	rxpkind = rvu_npc_get_pkind(rvu, pf);
+	txpkind = NPC_TX_DEF_PKIND;
+
+	if (mode & OTX2_PRIV_FLAGS_EDSA) {
+		rxpkind = NPC_RX_EDSA_PKIND;
+	} else if (mode & OTX2_PRIV_FLAGS_HIGIG) {
+		rxpkind = NPC_RX_HIGIG_PKIND;
+		txpkind = NPC_TX_HIGIG_PKIND;
+	} else if (mode & OTX2_PRIV_FLAGS_CUSTOM) {
+		rxpkind = pkind;
+		txpkind = pkind;
+	}
+
+	if (dir & PKIND_RX) {
+		/* rx pkind set req valid only for cgx mapped PFs */
+		if (!is_cgx_config_permitted(rvu, pcifunc))
+			return 0;
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+		rc = cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu),
+				   lmac_id, rxpkind);
+		if (rc)
+			return rc;
+	}
+
+	if (dir & PKIND_TX) {
+		/* Tx pkind set request valid if PCIFUNC has NIXLF attached */
+		rc = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+		if (rc)
+			return rc;
+
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf),
+			    txpkind);
+	}
+	return 0;
+}
+
+int rvu_mbox_handler_npc_set_pkind(struct rvu *rvu,
+				   struct npc_set_pkind *req,
+				   struct msg_rsp *rsp)
+{
+	return rvu_npc_set_parse_mode(rvu, req->hdr.pcifunc, req->mode,
+				      req->dir, req->pkind);
+}
-- 
2.17.1

