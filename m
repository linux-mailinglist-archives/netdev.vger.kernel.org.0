Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A320462ED3A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 06:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbiKRFd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 00:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240604AbiKRFdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 00:33:55 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B20DD7D;
        Thu, 17 Nov 2022 21:33:50 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI1rpcM014785;
        Thu, 17 Nov 2022 21:33:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=y/cAcxB2lXB3h5PUQLhAar5bEo6qOU8Wz5d11vlnIMs=;
 b=RgXroSDlQmMmA0nR0BNSgRZahKmD4djt+YyR7y7aBirNNwYbDpjMZQ2XTl/t5V0o/Nph
 7u9QtibWYC1Uoprh8TIPldjS1QrHYqmaHvZyyv8E7DdSYLiK9gyQ54l2Slc2gj3lusxO
 JD5E2fBzES38Laya3/LbtE1pI6E0fheb2AMioUGYt8GIjNb2e+5drCJhEv6RPS9Nks79
 3KF7cWqavuKLxsq3jjDKS2+NpTYJSIA1uMJJAIWDD4175VMbd4fOg8J94ZcW1wT5qtId
 hzCTxm743XyOx6esGcy0KGofNgGjN9nfutHyvA1qNi0sHDf5g2whlsGcahVBjdUVhFOT 5w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kx0st8p91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 21:33:39 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Nov
 2022 21:33:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 17 Nov 2022 21:33:37 -0800
Received: from localhost.localdomain (unknown [10.28.36.166])
        by maili.marvell.com (Postfix) with ESMTP id 467713F7054;
        Thu, 17 Nov 2022 21:33:34 -0800 (PST)
From:   Suman Ghosh <sumang@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <jerinj@marvell.com>, <gakula@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: Add additional checks while configuring ucast/bcast/mcast rules
Date:   Fri, 18 Nov 2022 11:03:29 +0530
Message-ID: <20221118053329.2288486-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: mEFzC4uiD56jsWY7D9--g9dHaE0_tTLH
X-Proofpoint-ORIG-GUID: mEFzC4uiD56jsWY7D9--g9dHaE0_tTLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. If a profile does not support DMAC extraction then avoid installing NPC
flow rules for unicast. Similarly, if LXMB(L2 and L3) extraction is not
supported by the profile then avoid installing broadcast and multicast
rules.
2. Allow MCAM entry insertion for promiscuous mode.
3. For the profiles where DMAC is not extracted in MKEX key default
unicast entry installed by AF is not valid. Hence do not use action
from the AF installed default unicast entry for such cases.
4. Adjacent packet header fields in a packet like IP header source
and destination addresses or UDP/TCP header source port and destination
can be extracted together in MKEX profile. Therefore MKEX profile can be
configured to in two ways:
	a. Total of 4 bytes from start of UDP header(src port
	   + destination port)
	or
	b. Two bytes from start and two bytes from offset 2

Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 14 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 22 ++++++
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 76 +++++++++++++++----
 .../marvell/octeontx2/nic/otx2_flows.c        | 27 ++++++-
 5 files changed, 124 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 8d5d5a0f68c4..c7c92c7510fa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -245,6 +245,9 @@ M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
 M(NPC_GET_SECRET_KEY, 0x6013, npc_get_secret_key,                     \
 				   npc_get_secret_key_req,              \
 				   npc_get_secret_key_rsp)              \
+M(NPC_GET_FIELD_STATUS, 0x6014, npc_get_field_status,                     \
+				   npc_get_field_status_req,              \
+				   npc_get_field_status_rsp)              \
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
@@ -1541,6 +1544,17 @@ struct ptp_rsp {
 	u64 clk;
 };
 
+struct npc_get_field_status_req {
+	struct mbox_msghdr hdr;
+	u8 intf;
+	u8 field;
+};
+
+struct npc_get_field_status_rsp {
+	struct mbox_msghdr hdr;
+	u8 enable;
+};
+
 struct set_vf_perm  {
 	struct  mbox_msghdr hdr;
 	u16	vf;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 76474385a602..f718cbd32a94 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -851,6 +851,7 @@ int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
 			       u64 chan_val, u64 chan_mask, u64 exact_val, u64 exact_mask,
 			       u64 bcast_mcast_val, u64 bcast_mcast_mask);
 void npc_mcam_rsrcs_reserve(struct rvu *rvu, int blkaddr, int entry_idx);
+bool npc_is_feature_supported(struct rvu *rvu, u64 features, u8 intf);
 
 /* CPT APIs */
 int rvu_cpt_register_interrupts(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 1e348fd0d930..16cfc802e348 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -617,6 +617,12 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 	if (blkaddr < 0)
 		return;
 
+	/* Ucast rule should not be installed if DMAC
+	 * extraction is not supported by the profile.
+	 */
+	if (!npc_is_feature_supported(rvu, BIT_ULL(NPC_DMAC), pfvf->nix_rx_intf))
+		return;
+
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_UCAST_ENTRY);
 
@@ -778,6 +784,14 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 	/* Get 'pcifunc' of PF device */
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	/* Bcast rule should not be installed if both DMAC
+	 * and LXMB extraction is not supported by the profile.
+	 */
+	if (!npc_is_feature_supported(rvu, BIT_ULL(NPC_DMAC), pfvf->nix_rx_intf) &&
+	    !npc_is_feature_supported(rvu, BIT_ULL(NPC_LXMB), pfvf->nix_rx_intf))
+		return;
+
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_BCAST_ENTRY);
 
@@ -848,6 +862,14 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	vf_func = pcifunc & RVU_PFVF_FUNC_MASK;
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	/* Mcast rule should not be installed if both DMAC
+	 * and LXMB extraction is not supported by the profile.
+	 */
+	if (!npc_is_feature_supported(rvu, BIT_ULL(NPC_DMAC), pfvf->nix_rx_intf) &&
+	    !npc_is_feature_supported(rvu, BIT_ULL(NPC_LXMB), pfvf->nix_rx_intf))
+		return;
+
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_ALLMULTI_ENTRY);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 50d3994efa97..f3fecd2a4015 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -47,6 +47,19 @@ static const char * const npc_flow_names[] = {
 	[NPC_UNKNOWN]	= "unknown",
 };
 
+bool npc_is_feature_supported(struct rvu *rvu, u64 features, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u64 mcam_features;
+	u64 unsupported;
+
+	mcam_features = is_npc_intf_tx(intf) ? mcam->tx_features : mcam->rx_features;
+	unsupported = (mcam_features ^ features) & ~mcam_features;
+
+	/* Return false if at least one of the input flows is not extracted */
+	return !unsupported;
+}
+
 const char *npc_get_field_name(u8 hdr)
 {
 	if (hdr >= ARRAY_SIZE(npc_flow_names))
@@ -436,8 +449,6 @@ static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
 	nr_bytes = FIELD_GET(NPC_BYTESM, cfg) + 1;
 	hdr = FIELD_GET(NPC_HDR_OFFSET, cfg);
 	key = FIELD_GET(NPC_KEY_OFFSET, cfg);
-	start_kwi = key / 8;
-	offset = (key * 8) % 64;
 
 	/* For Tx, Layer A has NIX_INST_HDR_S(64 bytes) preceding
 	 * ethernet header.
@@ -452,13 +463,18 @@ static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
 
 #define NPC_SCAN_HDR(name, hlid, hlt, hstart, hlen)			       \
 do {									       \
+	start_kwi = key / 8;						       \
+	offset = (key * 8) % 64;					       \
 	if (lid == (hlid) && lt == (hlt)) {				       \
 		if ((hstart) >= hdr &&					       \
 		    ((hstart) + (hlen)) <= (hdr + nr_bytes)) {	               \
 			bit_offset = (hdr + nr_bytes - (hstart) - (hlen)) * 8; \
 			npc_set_layer_mdata(mcam, (name), cfg, lid, lt, intf); \
+			offset += bit_offset;				       \
+			start_kwi += offset / 64;			       \
+			offset %= 64;					       \
 			npc_set_kw_masks(mcam, (name), (hlen) * 8,	       \
-					 start_kwi, offset + bit_offset, intf);\
+					 start_kwi, offset, intf);	       \
 		}							       \
 	}								       \
 } while (0)
@@ -650,9 +666,9 @@ static int npc_check_unsupported_flows(struct rvu *rvu, u64 features, u8 intf)
 
 	unsupported = (*mcam_features ^ features) & ~(*mcam_features);
 	if (unsupported) {
-		dev_info(rvu->dev, "Unsupported flow(s):\n");
+		dev_warn(rvu->dev, "Unsupported flow(s):\n");
 		for_each_set_bit(bit, (unsigned long *)&unsupported, 64)
-			dev_info(rvu->dev, "%s ", npc_get_field_name(bit));
+			dev_warn(rvu->dev, "%s ", npc_get_field_name(bit));
 		return -EOPNOTSUPP;
 	}
 
@@ -1007,8 +1023,20 @@ static void npc_update_rx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
 	action.match_id = req->match_id;
 	action.flow_key_alg = req->flow_key_alg;
 
-	if (req->op == NIX_RX_ACTION_DEFAULT && pfvf->def_ucast_rule)
-		action = pfvf->def_ucast_rule->rx_action;
+	if (req->op == NIX_RX_ACTION_DEFAULT) {
+		if (pfvf->def_ucast_rule) {
+			action = pfvf->def_ucast_rule->rx_action;
+		} else {
+			/* For profiles which do not extract DMAC, the default
+			 * unicast entry is unused. Hence modify action for the
+			 * requests which use same action as default unicast
+			 * entry
+			 */
+			*(u64 *)&action = 0;
+			action.pf_func = target;
+			action.op = NIX_RX_ACTIONOP_UCAST;
+		}
+	}
 
 	entry->action = *(u64 *)&action;
 
@@ -1239,18 +1267,19 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (npc_check_field(rvu, blkaddr, NPC_DMAC, req->intf))
 		goto process_flow;
 
-	if (is_pffunc_af(req->hdr.pcifunc)) {
+	if (is_pffunc_af(req->hdr.pcifunc) &&
+	    req->features & BIT_ULL(NPC_DMAC)) {
 		if (is_unicast_ether_addr(req->packet.dmac)) {
-			dev_err(rvu->dev,
-				"%s: mkex profile does not support ucast flow\n",
-				__func__);
+			dev_warn(rvu->dev,
+				 "%s: mkex profile does not support ucast flow\n",
+				 __func__);
 			return NPC_FLOW_NOT_SUPPORTED;
 		}
 
 		if (!npc_is_field_present(rvu, NPC_LXMB, req->intf)) {
-			dev_err(rvu->dev,
-				"%s: mkex profile does not support bcast/mcast flow",
-				__func__);
+			dev_warn(rvu->dev,
+				 "%s: mkex profile does not support bcast/mcast flow",
+				 __func__);
 			return NPC_FLOW_NOT_SUPPORTED;
 		}
 
@@ -1603,3 +1632,22 @@ int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
 
 	return 0;
 }
+
+int rvu_mbox_handler_npc_get_field_status(struct rvu *rvu,
+					  struct npc_get_field_status_req *req,
+					  struct npc_get_field_status_rsp *rsp)
+{
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return NPC_MCAM_INVALID_REQ;
+
+	if (!is_npc_interface_valid(rvu, req->intf))
+		return NPC_FLOW_INTF_INVALID;
+
+	if (npc_check_field(rvu, blkaddr, req->field, req->intf))
+		rsp->enable = 1;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 709fc0114fbd..13aa79efee03 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -164,6 +164,8 @@ EXPORT_SYMBOL(otx2_alloc_mcam_entries);
 static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_get_field_status_req *freq;
+	struct npc_get_field_status_rsp *frsp;
 	struct npc_mcam_alloc_entry_req *req;
 	struct npc_mcam_alloc_entry_rsp *rsp;
 	int vf_vlan_max_flows;
@@ -214,8 +216,29 @@ static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 	flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
 					OTX2_MAX_UNICAST_FLOWS;
 	pfvf->flags |= OTX2_FLAG_UCAST_FLTR_SUPPORT;
-	pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
-	pfvf->flags |= OTX2_FLAG_VF_VLAN_SUPPORT;
+
+	/* Check if NPC_DMAC field is supported
+	 * by the mkex profile before setting VLAN support flag.
+	 */
+	freq = otx2_mbox_alloc_msg_npc_get_field_status(&pfvf->mbox);
+	if (!freq) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	freq->field = NPC_DMAC;
+	if (otx2_sync_mbox_msg(&pfvf->mbox)) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -EINVAL;
+	}
+
+	frsp = (struct npc_get_field_status_rsp *)otx2_mbox_get_rsp
+	       (&pfvf->mbox.mbox, 0, &freq->hdr);
+
+	if (frsp->enable) {
+		pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_VF_VLAN_SUPPORT;
+	}
 
 	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 	mutex_unlock(&pfvf->mbox.lock);
-- 
2.25.1

