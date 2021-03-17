Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37F833F143
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhCQNgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:36:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41726 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231209AbhCQNfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:35:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HDQIJh006945;
        Wed, 17 Mar 2021 06:35:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ctti3SSHpKpx004PYKO07+EYPAOVgT4Yeo13DQwWswY=;
 b=XVj2dkApV8AS9vyH1Q3TNmwLDad+IxrY3TmvDAu4xp/zklabn/jkizmT7WyeSuYXQ/M8
 p5oRjz1Myd4CbmApyzCZnz+4OisuuaBpY8op+rXv/5MfgrHtJkrd04Mo6tSyg8i02FI7
 m7c0OGzReuWEdF8cUvK0bZHqvC3DmbT6tJHNY3xDtIThmfKr6AExF3bLiKGMun40mnFS
 2AyaMbj8T1GvaSa5MmGQxEsVOIzvXhW/Rgjw2Yi8FLYi7o8TX+KbFBcwCrgxPsdKnF5d
 lm/2X5efQRl+ps2VKlwdnmY6RRESfNaIi0xnPdLkX3Fu4INb0SFEGHhipVMixEYZMCJz 0g== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqvf48-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 06:35:51 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Mar 2021 09:35:49 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Mar 2021 09:35:49 -0400
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 446653F7040;
        Wed, 17 Mar 2021 06:35:46 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 1/5] octeontx2-af: refactor function npc_install_flow for default entry
Date:   Wed, 17 Mar 2021 19:05:34 +0530
Message-ID: <20210317133538.15609-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210317133538.15609-1-naveenm@marvell.com>
References: <20210317133538.15609-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_07:2021-03-17,2021-03-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactors npc_install_flow function to install AF
installed default MCAM entries similar to other MCAM entries
installed by PF/VF. As a result the code would be more readable
and easy to maintain. Modified npc_verify_entry and npc_verify_channel
to properly check MCAM rules installed by AF.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  5 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    | 14 +++++--
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 47 +++++++---------------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 45 +++++++++------------
 5 files changed, 51 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3c640f6aba92..0675c55dcc7a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -420,6 +420,11 @@ struct nix_tx_action {
 #define TX_VTAG1_LID_MASK		GENMASK_ULL(42, 40)
 #define TX_VTAG1_RELPTR_MASK		GENMASK_ULL(39, 32)
 
+/* NPC MCAM reserved entry index per nixlf */
+#define NIXLF_UCAST_ENTRY	0
+#define NIXLF_BCAST_ENTRY	1
+#define NIXLF_PROMISC_ENTRY	2
+
 struct npc_mcam_kex {
 	/* MKEX Profle Header */
 	u64 mkex_sign; /* "mcam-kex-profile" (8 bytes/ASCII characters) */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index fa6e46e36ae4..e6517a697de7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -548,6 +548,12 @@ static inline int is_afvf(u16 pcifunc)
 	return !(pcifunc & ~RVU_PFVF_FUNC_MASK);
 }
 
+/* check if PF_FUNC is AF */
+static inline bool is_pffunc_af(u16 pcifunc)
+{
+	return !pcifunc;
+}
+
 static inline bool is_rvu_fwdata_valid(struct rvu *rvu)
 {
 	return (rvu->fwdata->header_magic == RVU_FWDATA_HEADER_MAGIC) &&
@@ -665,9 +671,6 @@ int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena);
 int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel);
 int npc_flow_steering_init(struct rvu *rvu, int blkaddr);
 const char *npc_get_field_name(u8 hdr);
-bool rvu_npc_write_default_rule(struct rvu *rvu, int blkaddr, int nixlf,
-				u16 pcifunc, u8 intf, struct mcam_entry *entry,
-				int *entry_index);
 int npc_get_bank(struct npc_mcam *mcam, int index);
 void npc_mcam_enable_flows(struct rvu *rvu, u16 target);
 void npc_mcam_disable_flows(struct rvu *rvu, u16 target);
@@ -679,6 +682,11 @@ void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 
+int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
+			     int type);
+bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam, int blkaddr,
+			   int index);
+
 /* CPT APIs */
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index aa2ca8780b9c..c8836d48a614 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2145,7 +2145,7 @@ static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
 		seq_printf(s, "\tmcam entry: %d\n", iter->entry);
 
 		rvu_dbg_npc_mcam_show_flows(s, iter);
-		if (iter->intf == NIX_INTF_RX) {
+		if (is_npc_intf_rx(iter->intf)) {
 			target = iter->rx_action.pf_func;
 			pf = (target >> RVU_PFVF_PF_SHIFT) & RVU_PFVF_PF_MASK;
 			seq_printf(s, "\tForward to: PF%d ", pf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 04bb0803a5c5..80b90a48df4f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -22,10 +22,6 @@
 #define RSVD_MCAM_ENTRIES_PER_PF	2 /* Bcast & Promisc */
 #define RSVD_MCAM_ENTRIES_PER_NIXLF	1 /* Ucast for LFs */
 
-#define NIXLF_UCAST_ENTRY	0
-#define NIXLF_BCAST_ENTRY	1
-#define NIXLF_PROMISC_ENTRY	2
-
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
 #define NPC_HW_TSTAMP_OFFSET		8
 #define NPC_KEX_CHAN_MASK		0xFFFULL
@@ -96,6 +92,10 @@ int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel)
 	if (is_npc_intf_tx(intf))
 		return 0;
 
+	/* return in case of AF installed rules */
+	if (is_pffunc_af(pcifunc))
+		return 0;
+
 	if (is_afvf(pcifunc)) {
 		end = rvu_get_num_lbk_chans();
 		if (end < 0)
@@ -196,8 +196,8 @@ static int npc_get_ucast_mcam_index(struct npc_mcam *mcam, u16 pcifunc,
 	return mcam->nixlf_offset + (max + nixlf) * RSVD_MCAM_ENTRIES_PER_NIXLF;
 }
 
-static int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
-				    u16 pcifunc, int nixlf, int type)
+int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
+			     u16 pcifunc, int nixlf, int type)
 {
 	int pf = rvu_get_pf(pcifunc);
 	int index;
@@ -230,8 +230,8 @@ int npc_get_bank(struct npc_mcam *mcam, int index)
 	return bank;
 }
 
-static bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam,
-				  int blkaddr, int index)
+bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam,
+			   int blkaddr, int index)
 {
 	int bank = npc_get_bank(mcam, index);
 	u64 cfg;
@@ -1674,6 +1674,9 @@ void rvu_npc_get_mcam_counter_alloc_info(struct rvu *rvu, u16 pcifunc,
 static int npc_mcam_verify_entry(struct npc_mcam *mcam,
 				 u16 pcifunc, int entry)
 {
+	/* verify AF installed entries */
+	if (is_pffunc_af(pcifunc))
+		return 0;
 	/* Verify if entry is valid and if it is indeed
 	 * allocated to the requesting PFFUNC.
 	 */
@@ -2268,6 +2271,10 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 		goto exit;
 	}
 
+	/* For AF installed rules, the nix_intf should be set to target NIX */
+	if (is_pffunc_af(req->hdr.pcifunc))
+		nix_intf = req->intf;
+
 	npc_config_mcam_entry(rvu, mcam, blkaddr, req->entry, nix_intf,
 			      &req->entry_data, req->enable_entry);
 
@@ -2730,30 +2737,6 @@ int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
-bool rvu_npc_write_default_rule(struct rvu *rvu, int blkaddr, int nixlf,
-				u16 pcifunc, u8 intf, struct mcam_entry *entry,
-				int *index)
-{
-	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
-	struct npc_mcam *mcam = &rvu->hw->mcam;
-	bool enable;
-	u8 nix_intf;
-
-	if (is_npc_intf_tx(intf))
-		nix_intf = pfvf->nix_tx_intf;
-	else
-		nix_intf = pfvf->nix_rx_intf;
-
-	*index = npc_get_nixlf_mcam_index(mcam, pcifunc,
-					  nixlf, NIXLF_UCAST_ENTRY);
-	/* dont force enable unicast entry  */
-	enable = is_mcam_entry_enabled(rvu, mcam, blkaddr, *index);
-	npc_config_mcam_entry(rvu, mcam, blkaddr, *index, nix_intf,
-			      entry, enable);
-
-	return enable;
-}
-
 int rvu_mbox_handler_npc_read_base_steer_rule(struct rvu *rvu,
 					      struct msg_req *req,
 					      struct npc_mcam_read_base_rule_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 4ba9d54ce4e3..9e710a534796 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -998,33 +998,21 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	if (is_npc_intf_tx(req->intf))
 		goto find_rule;
 
-	if (def_ucast_rule)
+	if (req->default_rule) {
+		entry_index = npc_get_nixlf_mcam_index(mcam, target, nixlf,
+						       NIXLF_UCAST_ENTRY);
+		enable = is_mcam_entry_enabled(rvu, mcam, blkaddr, entry_index);
+	}
+
+	/* update mcam entry with default unicast rule attributes */
+	if (def_ucast_rule && (msg_from_vf || (req->default_rule && req->append))) {
 		missing_features = (def_ucast_rule->features ^ features) &
 					def_ucast_rule->features;
-
-	if (req->default_rule && req->append) {
-		/* add to default rule */
 		if (missing_features)
 			npc_update_flow(rvu, entry, missing_features,
 					&def_ucast_rule->packet,
 					&def_ucast_rule->mask,
 					&dummy, req->intf);
-		enable = rvu_npc_write_default_rule(rvu, blkaddr,
-						    nixlf, target,
-						    pfvf->nix_rx_intf, entry,
-						    &entry_index);
-		installed_features = req->features | missing_features;
-	} else if (req->default_rule && !req->append) {
-		/* overwrite default rule */
-		enable = rvu_npc_write_default_rule(rvu, blkaddr,
-						    nixlf, target,
-						    pfvf->nix_rx_intf, entry,
-						    &entry_index);
-	} else if (msg_from_vf) {
-		/* normal rule - include default rule also to it for VF */
-		npc_update_flow(rvu, entry, missing_features,
-				&def_ucast_rule->packet, &def_ucast_rule->mask,
-				&dummy, req->intf);
 		installed_features = req->features | missing_features;
 	}
 
@@ -1036,12 +1024,9 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 			return -ENOMEM;
 		new = true;
 	}
-	/* no counter for default rule */
-	if (req->default_rule)
-		goto update_rule;
 
 	/* allocate new counter if rule has no counter */
-	if (req->set_cntr && !rule->has_cntr)
+	if (!req->default_rule && req->set_cntr && !rule->has_cntr)
 		rvu_mcam_add_counter_to_rule(rvu, owner, rule, rsp);
 
 	/* if user wants to delete an existing counter for a rule then
@@ -1051,7 +1036,14 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
 
 	write_req.hdr.pcifunc = owner;
-	write_req.entry = req->entry;
+
+	/* AF owns the default rules so change the owner just to relax
+	 * the checks in rvu_mbox_handler_npc_mcam_write_entry
+	 */
+	if (req->default_rule)
+		write_req.hdr.pcifunc = 0;
+
+	write_req.entry = entry_index;
 	write_req.intf = req->intf;
 	write_req.enable_entry = (u8)enable;
 	/* if counter is available then clear and use it */
@@ -1069,7 +1061,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 			kfree(rule);
 		return err;
 	}
-update_rule:
+	/* update rule */
 	memcpy(&rule->packet, &dummy.packet, sizeof(rule->packet));
 	memcpy(&rule->mask, &dummy.mask, sizeof(rule->mask));
 	rule->entry = entry_index;
@@ -1278,6 +1270,7 @@ static int npc_update_dmac_value(struct rvu *rvu, int npcblkaddr,
 
 	write_req.hdr.pcifunc = rule->owner;
 	write_req.entry = rule->entry;
+	write_req.intf = pfvf->nix_rx_intf;
 
 	mutex_unlock(&mcam->lock);
 	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req, &rsp);
-- 
2.16.5

