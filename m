Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE256B1AB
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbiGHEcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiGHEcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:32:01 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6191A2F03B;
        Thu,  7 Jul 2022 21:31:56 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2681t3sx031193;
        Thu, 7 Jul 2022 21:31:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=PmtGdV/W+//YE4u+RdrbbH0RFyIDykH/HVB0+3yd/0Q=;
 b=j66ugybd4bAA1jz7ykwtABvVdaj2O7PiOu1ba25Ie5D8ekKpywN3XIOBgpI66Tw01djF
 LsIW5b+BB5XBGAqRqsJeG7Ln74D4R5NUpLJ14LigNVfnHF8tnWmes6fJEpY/rT/9JKX2
 TPDr+nEblBtDOWhNUFhoZLXbQNzM0f65C2/nslombEWgtvicQJF08TtLS0+r7JIt7OQW
 oPhYHzoWVJLn4g+wxd/xv5tSni8oNStXvfVwzX1nlf4O+oCfZ+3b6wShRc7A5s++nrgj
 1qxaHWg7EyNGuS/Rf9OPCe+XFQKaXtlszRvIfx7EG9Wk8LZXiWY8yvBkYgcDa0DXnQnp GA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h6bay8dte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:31:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 21:31:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Jul 2022 21:31:49 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 165193F7074;
        Thu,  7 Jul 2022 21:31:46 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH v4 10/12] octeontx2-af: Invoke exact match functions if supported
Date:   Fri, 8 Jul 2022 10:00:58 +0530
Message-ID: <20220708043100.2971020-11-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708043100.2971020-1-rkannoth@marvell.com>
References: <20220708043100.2971020-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: vcc3BVhelCtRZkxoM6Bippf6piM0slab
X-Proofpoint-ORIG-GUID: vcc3BVhelCtRZkxoM6Bippf6piM0slab
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If exact match table is supported, call functions to add/del/update
entries in exact match table instead of RPM dmac filters

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 34 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  7 ++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 0d86f3e68fa0..5090ddcc7e8a 100644
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
@@ -585,6 +590,9 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_set(rvu, req, rsp);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
@@ -603,6 +611,9 @@ int rvu_mbox_handler_cgx_mac_addr_add(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_add(rvu, req, rsp);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	rc = cgx_lmac_addr_add(cgx_id, lmac_id, req->mac_addr);
 	if (rc >= 0) {
@@ -623,6 +634,9 @@ int rvu_mbox_handler_cgx_mac_addr_del(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_del(rvu, req, rsp);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_del(cgx_id, lmac_id, req->index);
 }
@@ -644,6 +658,11 @@ int rvu_mbox_handler_cgx_mac_max_entries_get(struct rvu *rvu,
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
@@ -681,6 +700,10 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	/* Disable drop on non hit rule */
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_promisc_enable(rvu, req->hdr.pcifunc);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_promisc_config(cgx_id, lmac_id, true);
@@ -696,6 +719,10 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
+	/* Disable drop on non hit rule */
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_promisc_disable(rvu, req->hdr.pcifunc);
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_promisc_config(cgx_id, lmac_id, false);
@@ -1099,6 +1126,10 @@ int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_res
 		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	if (rvu_npc_exact_has_match_table(rvu))
+		return rvu_npc_exact_mac_addr_reset(rvu, req, rsp);
+
 	return cgx_lmac_addr_reset(cgx_id, lmac_id);
 }
 
@@ -1112,6 +1143,9 @@ int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
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

