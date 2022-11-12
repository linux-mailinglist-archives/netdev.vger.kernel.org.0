Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3731B6266F6
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiKLEdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiKLEcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:32 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78075D6AB;
        Fri, 11 Nov 2022 20:32:20 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC1FXSr018814;
        Fri, 11 Nov 2022 20:32:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bHSpXt04q8T8NvPjk0IgfiuKvBUnM40hrVtAsP16hxU=;
 b=aAg6M5XUv1iTZAHNLixyi6wWgKqZxUj9OCJikunWHwBeMsqbAB8UGZqh/Q2FAWQlQwdC
 uJNqFBoPMX9T1y68/lFKwyhH7K1tJz3IKt0cFrPU0uEe1Ytimk7t7EzJ/xP4tjL4aUvv
 rd50xQeT5k8sm70KZlIKCg3yPCXg75XbUbiPhL63WKkzPwCUMeTYAFMPNAQo1g3nCaFs
 wC4TakEdx08pDLYL6T3xhIz5PDhUiMAGy4Y5+BGyjloa/9qZ45XU/3WRNLdJFBQiX9K9
 DzikWOzxFmCCzgHOLBdtPLxT/rlzJG2FErAxn/LI2mFpNQQ/RyLf0WxDyHv+GtnHIzej lQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1nv0bet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:32:15 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Nov
 2022 20:32:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Nov 2022 20:32:14 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id EC9073F7048;
        Fri, 11 Nov 2022 20:32:10 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 7/9] octeontx2-af: Add proper return codes for AF mbox handlers
Date:   Sat, 12 Nov 2022 10:01:39 +0530
Message-ID: <20221112043141.13291-8-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: R_91pJZJON4QT_rBnwoJwQ61slaxSW-G
X-Proofpoint-GUID: R_91pJZJON4QT_rBnwoJwQ61slaxSW-G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-12_02,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

Add appropriate error codes to be used when returning from AF
mailbox handlers.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 8a8a12ac7ac8..b603fcb8673f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -602,7 +602,7 @@ int rvu_mbox_handler_cgx_stats_rst(struct rvu *rvu, struct msg_req *req,
 	void *cgxd;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -ENODEV;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	parent_pf = &rvu->pf[pf];
 	/* To ensure reset cgx stats won't affect VF stats,
@@ -650,7 +650,7 @@ int rvu_mbox_handler_cgx_mac_addr_add(struct rvu *rvu,
 	int rc = 0;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	if (rvu_npc_exact_has_match_table(rvu))
 		return rvu_npc_exact_mac_addr_add(rvu, req, rsp);
@@ -673,7 +673,7 @@ int rvu_mbox_handler_cgx_mac_addr_del(struct rvu *rvu,
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	if (rvu_npc_exact_has_match_table(rvu))
 		return rvu_npc_exact_mac_addr_del(rvu, req, rsp);
@@ -739,7 +739,7 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	/* Disable drop on non hit rule */
 	if (rvu_npc_exact_has_match_table(rvu))
@@ -758,7 +758,7 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	/* Disable drop on non hit rule */
 	if (rvu_npc_exact_has_match_table(rvu))
@@ -786,7 +786,7 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	 */
 	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
 	    !is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgxd = rvu_cgx_pdata(cgx_id, rvu);
@@ -798,7 +798,7 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	 * and if PTP is disabled then no shift is required
 	 */
 	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, enable))
-		return -EINVAL;
+		return NIX_AF_ERR_PTP_CONFIG_FAIL;
 	/* This flag is required to clean up CGX conf if app gets killed */
 	pfvf->hw_rx_tstamp_en = enable;
 
@@ -809,7 +809,7 @@ int rvu_mbox_handler_cgx_ptp_rx_enable(struct rvu *rvu, struct msg_req *req,
 				       struct msg_rsp *rsp)
 {
 	if (!is_pf_cgxmapped(rvu, rvu_get_pf(req->hdr.pcifunc)))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	return rvu_cgx_ptp_rx_cfg(rvu, req->hdr.pcifunc, true);
 }
@@ -826,7 +826,7 @@ static int rvu_cgx_config_linkevents(struct rvu *rvu, u16 pcifunc, bool en)
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -864,7 +864,7 @@ int rvu_mbox_handler_cgx_get_linkinfo(struct rvu *rvu, struct msg_req *req,
 	pf = rvu_get_pf(req->hdr.pcifunc);
 
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -925,7 +925,7 @@ static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
@@ -1001,7 +1001,7 @@ int rvu_mbox_handler_cgx_cfg_pause_frm(struct rvu *rvu,
 	 * if received from other PF/VF simply ACK, nothing to do.
 	 */
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgxd = rvu_cgx_pdata(cgx_id, rvu);
@@ -1128,7 +1128,7 @@ int rvu_mbox_handler_cgx_set_fec_param(struct rvu *rvu,
 	u8 cgx_id, lmac_id;
 
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -EPERM;
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	if (req->fec == OTX2_FEC_OFF)
 		req->fec = OTX2_FEC_NONE;
@@ -1147,7 +1147,7 @@ int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
 		return LMAC_AF_ERR_FIRMWARE_DATA_NOT_MAPPED;
 
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -EPERM;
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -1172,7 +1172,7 @@ int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
 	void *cgxd;
 
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
 	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
@@ -1227,7 +1227,7 @@ int rvu_cgx_prio_flow_ctrl_cfg(struct rvu *rvu, u16 pcifunc, u8 tx_pause,
 	 * if received from other PF/VF simply ACK, nothing to do.
 	 */
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgxd = rvu_cgx_pdata(cgx_id, rvu);
@@ -1265,7 +1265,7 @@ int rvu_mbox_handler_cgx_prio_flow_ctrl_cfg(struct rvu *rvu,
 	 * if received from other PF/VF simply ACK, nothing to do.
 	 */
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgxd = rvu_cgx_pdata(cgx_id, rvu);
-- 
2.17.1

