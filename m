Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8C56689F
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiGEKvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiGEKu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:50:56 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC5F15A3A;
        Tue,  5 Jul 2022 03:50:41 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264MMtrH032125;
        Tue, 5 Jul 2022 03:50:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=3nN4IuFRdz1Nc//CLj0lvMvoQ/h6DKK1fDkpewqHKmU=;
 b=Wyl/CdzWtLn88GhIkLZJb3hIBgyQ+bJnDPEbK2cldKIrCQtaqVG9zZMUOry0sPQ2F2gq
 4qNXMT4q6TS6W0dozsNzFhlXcPimuPDvnEEWDb5XlVsVShZv1PgXJQt5u6kEREJ6EXMn
 1INgRvbPSu63L8woqoHkkHkoc+m47ZDocb9UO9mTNlXyGS+Cxk9EvE+DUrv/iEIRqrXe
 Onkrepb4ZnBZ60of2Z1BCy2GL9PXbqwPPHk9D6McSZIBHFN8g7gi9RKfltQPddGMMYFP
 U3W2ZvMEN/e6ZiYdimfkAE6p4Xz06469ID0QmmS/xvTtnSSgTJjK0VR4FvpqEmsanBn9 aQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h2nhnrnw7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 03:50:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 Jul
 2022 03:50:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Jul 2022 03:50:07 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 383693F707E;
        Tue,  5 Jul 2022 03:50:02 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [PATCH 10/12] octeontx2-af: Invoke exact match functions if supported
Date:   Tue, 5 Jul 2022 16:19:21 +0530
Message-ID: <20220705104923.2113935-11-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705104923.2113935-1-rkannoth@marvell.com>
References: <20220705104923.2113935-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bUj56nLfX0BAXTAPc5VaQN7fW-FeEbwt
X-Proofpoint-GUID: bUj56nLfX0BAXTAPc5VaQN7fW-FeEbwt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If exact match table is suppoted, call functions to add/del/update
entries in exact match table instead of RPM dmac filters

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Change-Id: I3c80668740b339e6b8eba5b84c2181dd4c9fc835
---
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 36 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  7 ++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 0d86f3e68fa0..967901eb2dbb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -475,6 +475,11 @@ void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
 	if (!is_cgx_config_permitted(rvu, pcifunc))
 		return;
 
+	if (rvu_npc_exact_has_match_table(rvu)) {
+		rvu_npc_exact_reset(rvu, pcifunc);
+		return;
+	}
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgx_dev = cgx_get_pdata(cgx_id);
 	lmac_count = cgx_get_lmac_cnt(cgx_dev);
@@ -575,6 +580,8 @@ int rvu_mbox_handler_cgx_fec_stats(struct rvu *rvu,
 	return cgx_get_fec_stats(cgxd, lmac, rsp);
 }
 
+/* TODO: how to fix del/add of entry in exact match table ?
+ */
 int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 				      struct cgx_mac_addr_set_or_get *req,
 				      struct cgx_mac_addr_set_or_get *rsp)
@@ -585,6 +592,9 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_set(rvu, req, rsp);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
@@ -603,6 +613,9 @@ int rvu_mbox_handler_cgx_mac_addr_add(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_add(rvu, req, rsp);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	rc = cgx_lmac_addr_add(cgx_id, lmac_id, req->mac_addr);
 	if (rc >= 0) {
@@ -623,6 +636,9 @@ int rvu_mbox_handler_cgx_mac_addr_del(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_del(rvu, req, rsp);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_del(cgx_id, lmac_id, req->index);
 }
@@ -644,6 +660,11 @@ int rvu_mbox_handler_cgx_mac_max_entries_get(struct rvu *rvu,
 		return 0;
 	}
 
+	if (rvu_npc_exact_has_match_table(rvu)) {
+		rsp->max_dmac_filters = rvu_npc_exact_get_max_entries(rvu);
+		return 0;
+	}
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	rsp->max_dmac_filters = cgx_lmac_addr_max_entries_get(cgx_id, lmac_id);
 	return 0;
@@ -681,6 +702,10 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	/* Disable drop on non hit rule */
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_promisc_enable(rvu, req->hdr.pcifunc);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_promisc_config(cgx_id, lmac_id, true);
@@ -696,6 +721,10 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	/* Disable drop on non hit rule */
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_promisc_disable(rvu, req->hdr.pcifunc);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_promisc_config(cgx_id, lmac_id, false);
@@ -1099,6 +1128,10 @@ int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_res
 		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_reset(rvu, req, rsp);
+
 	return cgx_lmac_addr_reset(cgx_id, lmac_id);
 }
 
@@ -1112,6 +1145,9 @@ int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return LMAC_AF_ERR_PERM_DENIED;
 
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_update(rvu, req, rsp);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_update(cgx_id, lmac_id, req->mac_addr, req->index);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0fa625e2528e..1d3323da6930 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -14,6 +14,7 @@
 #include "npc.h"
 #include "cgx.h"
 #include "lmac_common.h"
+#include "rvu_npc_hash.h"
 
 static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc);
 static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
@@ -3792,9 +3793,15 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
 					      pfvf->rx_chan_cnt);
+
+		if (rvu_npc_exact_has_match_table(rvu))
+			rvu_npc_exact_promisc_enable(rvu, pcifunc);
 	} else {
 		if (!nix_rx_multicast)
 			rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf, false);
+
+		if (rvu_npc_exact_has_match_table(rvu))
+			rvu_npc_exact_promisc_disable(rvu, pcifunc);
 	}
 
 	return 0;
-- 
2.25.1

