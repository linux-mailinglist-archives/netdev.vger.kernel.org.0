Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913292DA70B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 05:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgLOENF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 23:13:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24102 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725385AbgLOEMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 23:12:51 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BF4BKNF030103;
        Mon, 14 Dec 2020 20:12:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=J8JYuxRGbHlCktKeJ3Xo6p5nu7hipl1IZzbhLzAPIwE=;
 b=j8DSwYHOVhmTclCyK+C0t/bGAZpyn7lMaK88z351MxssN6x+3aK3OFzMiCEEw0+iYS+N
 N6CNdopjnDCV5W7+Ovu1lQ/i2VPnD+A0Ltuw9ISt68TM9d/eQNzhszFkJwtEpmBUCxWt
 EwKt+xn2OasSF3m5FXyZOX3Qbgf/zfUAa9ux7ya1f4NGLRT+oJDmdlCaSqMWHrceamJP
 MZhBiW1kO6oSHohw89S5vVmY4uqdTD0pry+uvn131PIAfPK3w4j/VZldWMQxLt4fNU7H
 dUg+UZ98Xsk8qUrivr52sD3czU0vQdwunHM8ZY2B1maX6lMjxtkRUFJivu6MtxW5vT6a lg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 35cv3sxn2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 20:12:05 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Dec
 2020 20:12:04 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Dec 2020 20:12:04 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A044F3F7045;
        Mon, 14 Dec 2020 20:12:02 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        "Geetha sowjanya" <gakula@marvell.com>
Subject: [PATCHv4 net-next] octeontx2-pf: Add RSS multi group support
Date:   Tue, 15 Dec 2020 09:41:56 +0530
Message-ID: <20201215041156.4504-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_03:2020-12-11,2020-12-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware supports 8 RSS groups per interface. Currently we are using
only group '0'. This patch allows user to create new RSS groups/contexts
and use the same as destination for flow steering rules.

usage:
To steer the traffic to RQ 2,3

ethtool -X eth0 weight 0 0 1 1 context new
(It will print the allocated context id number)
New RSS context is 1

ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1

To delete the context
ethtool -X eth0 context 1 delete

When an RSS context is removed, the active classification
rules using this context are also removed.

Change-log:

v4
- Fixed compiletime warning.
- Address Saeed's comments on v3.

v3
- Coverted otx2_set_rxfh() to use new function.

v2
- Removed unrelated whitespace
- Coverted otx2_get_rxfh() to use new function.


Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  26 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 133 ++++++++++++++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  37 +++++-
 4 files changed, 163 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 73fb94d..bdfa2e2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -270,14 +270,17 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 	return err;
 }
 
-int otx2_set_rss_table(struct otx2_nic *pfvf)
+int otx2_set_rss_table(struct otx2_nic *pfvf, int ctx_id)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	const int index = rss->rss_size * ctx_id;
 	struct mbox *mbox = &pfvf->mbox;
+	struct otx2_rss_ctx *rss_ctx;
 	struct nix_aq_enq_req *aq;
 	int idx, err;
 
 	mutex_lock(&mbox->lock);
+	rss_ctx = rss->rss_ctx[ctx_id];
 	/* Get memory to put this msg */
 	for (idx = 0; idx < rss->rss_size; idx++) {
 		aq = otx2_mbox_alloc_msg_nix_aq_enq(mbox);
@@ -297,10 +300,10 @@ int otx2_set_rss_table(struct otx2_nic *pfvf)
 			}
 		}
 
-		aq->rss.rq = rss->ind_tbl[idx];
+		aq->rss.rq = rss_ctx->ind_tbl[idx];
 
 		/* Fill AQ info */
-		aq->qidx = idx;
+		aq->qidx = index + idx;
 		aq->ctype = NIX_AQ_CTYPE_RSS;
 		aq->op = NIX_AQ_INSTOP_INIT;
 	}
@@ -335,9 +338,10 @@ void otx2_set_rss_key(struct otx2_nic *pfvf)
 int otx2_rss_init(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	struct otx2_rss_ctx *rss_ctx;
 	int idx, ret = 0;
 
-	rss->rss_size = sizeof(rss->ind_tbl);
+	rss->rss_size = sizeof(*rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP]);
 
 	/* Init RSS key if it is not setup already */
 	if (!rss->enable)
@@ -345,13 +349,19 @@ int otx2_rss_init(struct otx2_nic *pfvf)
 	otx2_set_rss_key(pfvf);
 
 	if (!netif_is_rxfh_configured(pfvf->netdev)) {
-		/* Default indirection table */
+		/* Set RSS group 0 as default indirection table */
+		rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP] = kzalloc(rss->rss_size,
+								  GFP_KERNEL);
+		if (!rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP])
+			return -ENOMEM;
+
+		rss_ctx = rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP];
 		for (idx = 0; idx < rss->rss_size; idx++)
-			rss->ind_tbl[idx] =
+			rss_ctx->ind_tbl[idx] =
 				ethtool_rxfh_indir_default(idx,
 							   pfvf->hw.rx_queues);
 	}
-	ret = otx2_set_rss_table(pfvf);
+	ret = otx2_set_rss_table(pfvf, DEFAULT_RSS_CONTEXT_GROUP);
 	if (ret)
 		return ret;
 
@@ -986,7 +996,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	nixlf->sq_cnt = pfvf->hw.tx_queues;
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
 	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
-	nixlf->rss_grps = 1; /* Single RSS indir table supported, for now */
+	nixlf->rss_grps = MAX_RSS_GROUPS;
 	nixlf->xqe_sz = NIX_XQESZ_W16;
 	/* We don't know absolute NPA LF idx attached.
 	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 1034304..143ae04 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -51,13 +51,17 @@ enum arua_mapped_qtypes {
 #define NIX_LF_POISON_VEC			0x82
 
 /* RSS configuration */
+struct otx2_rss_ctx {
+	u8  ind_tbl[MAX_RSS_INDIR_TBL_SIZE];
+};
+
 struct otx2_rss_info {
 	u8 enable;
 	u32 flowkey_cfg;
 	u16 rss_size;
-	u8  ind_tbl[MAX_RSS_INDIR_TBL_SIZE];
 #define RSS_HASH_KEY_SIZE	44   /* 352 bit key */
 	u8  key[RSS_HASH_KEY_SIZE];
+	struct otx2_rss_ctx	*rss_ctx[MAX_RSS_GROUPS];
 };
 
 /* NIX (or NPC) RX errors */
@@ -643,7 +647,7 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 int otx2_rss_init(struct otx2_nic *pfvf);
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf);
 void otx2_set_rss_key(struct otx2_nic *pfvf);
-int otx2_set_rss_table(struct otx2_nic *pfvf);
+int otx2_set_rss_table(struct otx2_nic *pfvf, int ctx_id);
 
 /* Mbox handlers */
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
@@ -684,10 +688,11 @@ int otx2_get_flow(struct otx2_nic *pfvf,
 int otx2_get_all_flows(struct otx2_nic *pfvf,
 		       struct ethtool_rxnfc *nfc, u32 *rule_locs);
 int otx2_add_flow(struct otx2_nic *pfvf,
-		  struct ethtool_rx_flow_spec *fsp);
+		  struct ethtool_rxnfc *nfc);
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
 int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			      struct npc_install_flow_req *req);
+void otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id);
 int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 67171b66a..aaba045 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -581,7 +581,7 @@ static int otx2_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
 		break;
 	case ETHTOOL_SRXCLSRLINS:
 		if (netif_running(dev) && ntuple)
-			ret = otx2_add_flow(pfvf, &nfc->fs);
+			ret = otx2_add_flow(pfvf, nfc);
 		break;
 	case ETHTOOL_SRXCLSRLDEL:
 		if (netif_running(dev) && ntuple)
@@ -641,42 +641,50 @@ static u32 otx2_get_rxfh_key_size(struct net_device *netdev)
 
 static u32 otx2_get_rxfh_indir_size(struct net_device *dev)
 {
-	struct otx2_nic *pfvf = netdev_priv(dev);
-
-	return pfvf->hw.rss_info.rss_size;
+	return  MAX_RSS_INDIR_TBL_SIZE;
 }
 
-/* Get RSS configuration */
-static int otx2_get_rxfh(struct net_device *dev, u32 *indir,
-			 u8 *hkey, u8 *hfunc)
+static int otx2_rss_ctx_delete(struct otx2_nic *pfvf, int ctx_id)
 {
-	struct otx2_nic *pfvf = netdev_priv(dev);
-	struct otx2_rss_info *rss;
-	int idx;
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
 
-	rss = &pfvf->hw.rss_info;
+	otx2_rss_ctx_flow_del(pfvf, ctx_id);
+	kfree(rss->rss_ctx[ctx_id]);
+	rss->rss_ctx[ctx_id] = NULL;
 
-	if (indir) {
-		for (idx = 0; idx < rss->rss_size; idx++)
-			indir[idx] = rss->ind_tbl[idx];
-	}
+	return 0;
+}
 
-	if (hkey)
-		memcpy(hkey, rss->key, sizeof(rss->key));
+static int otx2_rss_ctx_create(struct otx2_nic *pfvf,
+			       u32 *rss_context)
+{
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	u8 ctx;
 
-	if (hfunc)
-		*hfunc = ETH_RSS_HASH_TOP;
+	for (ctx = 0; ctx < MAX_RSS_GROUPS; ctx++) {
+		if (!rss->rss_ctx[ctx])
+			break;
+	}
+	if (ctx == MAX_RSS_GROUPS)
+		return -EINVAL;
+
+	rss->rss_ctx[ctx] = kzalloc(sizeof(*rss->rss_ctx[ctx]), GFP_KERNEL);
+	if (!rss->rss_ctx[ctx])
+		return -ENOMEM;
+	*rss_context = ctx;
 
 	return 0;
 }
 
-/* Configure RSS table and hash key */
-static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
-			 const u8 *hkey, const u8 hfunc)
+/* RSS context configuration */
+static int otx2_set_rxfh_context(struct net_device *dev, const u32 *indir,
+				 const u8 *hkey, const u8 hfunc,
+				 u32 *rss_context, bool delete)
 {
 	struct otx2_nic *pfvf = netdev_priv(dev);
+	struct otx2_rss_ctx *rss_ctx;
 	struct otx2_rss_info *rss;
-	int idx;
+	int ret, idx;
 
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
@@ -688,20 +696,85 @@ static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
 		return -EIO;
 	}
 
+	if (hkey) {
+		memcpy(rss->key, hkey, sizeof(rss->key));
+		otx2_set_rss_key(pfvf);
+	}
+	if (delete)
+		return otx2_rss_ctx_delete(pfvf, *rss_context);
+
+	if (*rss_context == ETH_RXFH_CONTEXT_ALLOC) {
+		ret = otx2_rss_ctx_create(pfvf, rss_context);
+		if (ret)
+			return ret;
+	}
 	if (indir) {
+		rss_ctx = rss->rss_ctx[*rss_context];
 		for (idx = 0; idx < rss->rss_size; idx++)
-			rss->ind_tbl[idx] = indir[idx];
+			rss_ctx->ind_tbl[idx] = indir[idx];
 	}
+	otx2_set_rss_table(pfvf, *rss_context);
 
-	if (hkey) {
-		memcpy(rss->key, hkey, sizeof(rss->key));
-		otx2_set_rss_key(pfvf);
+	return 0;
+}
+
+static int otx2_get_rxfh_context(struct net_device *dev, u32 *indir,
+				 u8 *hkey, u8 *hfunc, u32 rss_context)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	struct otx2_rss_ctx *rss_ctx;
+	struct otx2_rss_info *rss;
+	int idx, rx_queues;
+
+	rss = &pfvf->hw.rss_info;
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	if (!indir)
+		return 0;
+
+	if (!rss->enable && rss_context == DEFAULT_RSS_CONTEXT_GROUP) {
+		rx_queues = pfvf->hw.rx_queues;
+		for (idx = 0; idx < MAX_RSS_INDIR_TBL_SIZE; idx++)
+			indir[idx] = ethtool_rxfh_indir_default(idx, rx_queues);
+		return 0;
+	}
+	if (rss_context >= MAX_RSS_GROUPS)
+		return -ENOENT;
+
+	rss_ctx = rss->rss_ctx[rss_context];
+	if (!rss_ctx)
+		return -ENOENT;
+
+	if (indir) {
+		for (idx = 0; idx < rss->rss_size; idx++)
+			indir[idx] = rss_ctx->ind_tbl[idx];
 	}
+	if (hkey)
+		memcpy(hkey, rss->key, sizeof(rss->key));
 
-	otx2_set_rss_table(pfvf);
 	return 0;
 }
 
+/* Get RSS configuration */
+static int otx2_get_rxfh(struct net_device *dev, u32 *indir,
+			 u8 *hkey, u8 *hfunc)
+{
+	return otx2_get_rxfh_context(dev, indir, hkey, hfunc,
+				     DEFAULT_RSS_CONTEXT_GROUP);
+}
+
+/* Configure RSS table and hash key */
+static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
+			 const u8 *hkey, const u8 hfunc)
+{
+
+	u32 rss_context = DEFAULT_RSS_CONTEXT_GROUP;
+
+	return otx2_set_rxfh_context(dev, indir, hkey, hfunc, &rss_context, 0);
+}
+
 static u32 otx2_get_msglevel(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
@@ -771,6 +844,8 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
 	.get_rxfh		= otx2_get_rxfh,
 	.set_rxfh		= otx2_set_rxfh,
+	.get_rxfh_context	= otx2_get_rxfh_context,
+	.set_rxfh_context	= otx2_set_rxfh_context,
 	.get_msglevel		= otx2_get_msglevel,
 	.set_msglevel		= otx2_set_msglevel,
 	.get_pauseparam		= otx2_get_pauseparam,
@@ -866,6 +941,8 @@ static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
 	.get_rxfh		= otx2_get_rxfh,
 	.set_rxfh		= otx2_set_rxfh,
+	.get_rxfh_context	= otx2_get_rxfh_context,
+	.set_rxfh_context	= otx2_set_rxfh_context,
 	.get_ringparam		= otx2_get_ringparam,
 	.set_ringparam		= otx2_set_ringparam,
 	.get_coalesce		= otx2_get_coalesce,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index be8ccfc..6dd442d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -16,6 +16,7 @@ struct otx2_flow {
 	u32 location;
 	u16 entry;
 	bool is_vf;
+	u8 rss_ctx_id;
 	int vf;
 };
 
@@ -245,6 +246,7 @@ int otx2_get_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
 	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
 		if (iter->location == location) {
 			nfc->fs = iter->flow_spec;
+			nfc->rss_context = iter->rss_ctx_id;
 			return 0;
 		}
 	}
@@ -429,7 +431,7 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 	struct flow_msg *pkt = &req->packet;
 	u32 flow_type;
 
-	flow_type = fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
+	flow_type = fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
 	switch (flow_type) {
 	/* bits not set in mask are don't care */
 	case ETHER_FLOW:
@@ -532,9 +534,13 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 		/* change to unicast only if action of default entry is not
 		 * requested by user
 		 */
-		if (req->op != NIX_RX_ACTION_DEFAULT)
+		if (flow->flow_spec.flow_type & FLOW_RSS) {
+			req->op = NIX_RX_ACTIONOP_RSS;
+			req->index = flow->rss_ctx_id;
+		} else {
 			req->op = NIX_RX_ACTIONOP_UCAST;
-		req->index = ethtool_get_flow_spec_ring(ring_cookie);
+			req->index = ethtool_get_flow_spec_ring(ring_cookie);
+		}
 		vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
 		if (vf > pci_num_vf(pfvf->pdev)) {
 			mutex_unlock(&pfvf->mbox.lock);
@@ -555,14 +561,16 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 	return err;
 }
 
-int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rx_flow_spec *fsp)
+int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
-	u32 ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
+	struct ethtool_rx_flow_spec *fsp = &nfc->fs;
 	struct otx2_flow *flow;
 	bool new = false;
+	u32 ring;
 	int err;
 
+	ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
 	if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
 		return -ENOMEM;
 
@@ -585,6 +593,9 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rx_flow_spec *fsp)
 	/* struct copy */
 	flow->flow_spec = *fsp;
 
+	if (fsp->flow_type & FLOW_RSS)
+		flow->rss_ctx_id = nfc->rss_context;
+
 	err = otx2_add_flow_msg(pfvf, flow);
 	if (err) {
 		if (new)
@@ -647,6 +658,22 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 	return 0;
 }
 
+void otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id)
+{
+	struct otx2_flow *flow, *tmp;
+	int err;
+
+	list_for_each_entry_safe(flow, tmp, &pfvf->flow_cfg->flow_list, list) {
+		if (flow->rss_ctx_id != ctx_id)
+			continue;
+		err = otx2_remove_flow(pfvf, flow->location);
+		if (err)
+			netdev_warn(pfvf->netdev,
+				    "Can't delete the rule %d associated with this rss group err:%d",
+				    flow->location, err);
+	}
+}
+
 int otx2_destroy_ntuple_flows(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
-- 
2.7.4

