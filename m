Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C583A7D5C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhFOLiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:38:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9754 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229659AbhFOLil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:38:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FBUACX022086;
        Tue, 15 Jun 2021 04:35:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=XYx2vB1YGSkzQ3Y6U/8g/0FwqdP5VaWAFUP5B0euwTs=;
 b=MBAPDtfvCfnlQ3DHfaFdtuqJWM5CiPh37UawBSA5a2Hi/evv8tLdoYT+wM3Zf1kleMDG
 MMxOLOS72KJqSjGAL0mFoXymOMihAeKcBNS7MqwV9QT7VItVGj9Dv2yLZpB1nbyRuGv2
 Fx/nsny32dg/XIkXxmfcWdzZXg7+2Wr1iGrG4jmIq8hLK623YfGvLgpahgZU2zFgSGPQ
 GSSYJA/fSWgY3jFWuh1OaLxHNdnWNTF0t/KapwulKZ/zu6HdtE9BU2eNLSQ8dTge9q2U
 X49Uz5bpLL5RYC1sKZr6e61W3J8Rvkw/cxO9fCS+S3BwC49cruiCUW4hp5QaAkWTzy1J Tw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 396m0uj1xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 04:35:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 04:34:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Jun 2021 04:34:58 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 93CDC3F70AC;
        Tue, 15 Jun 2021 04:34:55 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 5/5] octeontx2-pf: Add police action for TC flower
Date:   Tue, 15 Jun 2021 17:04:31 +0530
Message-ID: <1623756871-12524-6-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8U9RC6P5B_FDg47WkArvsuwlp6kYbKrG
X-Proofpoint-ORIG-GUID: 8U9RC6P5B_FDg47WkArvsuwlp6kYbKrG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added police action for ingress TC flower
hardware offload. With this rate limiting can be
done per flow. Since rate limiting is tied to
RQs in hardware the number of TC flower filters
with action as police is limited to number
of receive queues of the interface. Both bps
and pps modes are supported.

Examples to rate limit a flow:
$ ethtool -K eth0 hw-tc-offload on
$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 parent ffff: protocol ip \
  flower ip_proto udp dst_port 80 action \
  police rate 100Mbit burst 32Kbit

$ tc filter add dev eth0 parent ffff: \
  protocol ip flower dst_mac 5e:b2:34:ee:29:49 \
  action police pkts_rate 5000 pkts_burst 2048

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   6 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 194 ++++++++++++++++++---
 3 files changed, 178 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 8ade5af..5d27f00 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -370,6 +370,7 @@ struct otx2_nic {
 
 	struct otx2_flow_config	*flow_cfg;
 	struct otx2_tc_info	tc_info;
+	unsigned long		rq_bmap;
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 9d9a2e4..8df748e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -286,6 +286,12 @@ static int otx2_set_channels(struct net_device *dev,
 	if (!channel->rx_count || !channel->tx_count)
 		return -EINVAL;
 
+	if (bitmap_weight(&pfvf->rq_bmap, pfvf->hw.rx_queues) > 1) {
+		netdev_err(dev,
+			   "Receive queues are in use by TC police action\n");
+		return -EINVAL;
+	}
+
 	if (if_up)
 		dev->netdev_ops->ndo_stop(dev);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index a46055f..64a7767 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -42,11 +42,14 @@ struct otx2_tc_flow_stats {
 struct otx2_tc_flow {
 	struct rhash_head		node;
 	unsigned long			cookie;
-	u16				entry;
 	unsigned int			bitpos;
 	struct rcu_head			rcu;
 	struct otx2_tc_flow_stats	stats;
 	spinlock_t			lock; /* lock for stats */
+	u16				rq;
+	u16				entry;
+	u16				leaf_profile;
+	bool				is_act_police;
 };
 
 static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
@@ -221,15 +224,72 @@ static int otx2_tc_egress_matchall_delete(struct otx2_nic *nic,
 	return err;
 }
 
+static int otx2_tc_act_set_police(struct otx2_nic *nic,
+				  struct otx2_tc_flow *node,
+				  struct flow_cls_offload *f,
+				  u64 rate, u32 burst, u32 mark,
+				  struct npc_install_flow_req *req, bool pps)
+{
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct otx2_hw *hw = &nic->hw;
+	int rq_idx, rc;
+
+	rq_idx = find_first_zero_bit(&nic->rq_bmap, hw->rx_queues);
+	if (rq_idx >= hw->rx_queues) {
+		NL_SET_ERR_MSG_MOD(extack, "Police action rules exceeded");
+		return -EINVAL;
+	}
+
+	mutex_lock(&nic->mbox.lock);
+
+	rc = cn10k_alloc_leaf_profile(nic, &node->leaf_profile);
+	if (rc) {
+		mutex_unlock(&nic->mbox.lock);
+		return rc;
+	}
+
+	rc = cn10k_set_ipolicer_rate(nic, node->leaf_profile, burst, rate, pps);
+	if (rc)
+		goto free_leaf;
+
+	rc = cn10k_map_unmap_rq_policer(nic, rq_idx, node->leaf_profile, true);
+	if (rc)
+		goto free_leaf;
+
+	mutex_unlock(&nic->mbox.lock);
+
+	req->match_id = mark & 0xFFFFULL;
+	req->index = rq_idx;
+	req->op = NIX_RX_ACTIONOP_UCAST;
+	set_bit(rq_idx, &nic->rq_bmap);
+	node->is_act_police = true;
+	node->rq = rq_idx;
+
+	return 0;
+
+free_leaf:
+	if (cn10k_free_leaf_profile(nic, node->leaf_profile))
+		netdev_err(nic->netdev,
+			   "Unable to free leaf bandwidth profile(%d)\n",
+			   node->leaf_profile);
+	mutex_unlock(&nic->mbox.lock);
+	return rc;
+}
+
 static int otx2_tc_parse_actions(struct otx2_nic *nic,
 				 struct flow_action *flow_action,
 				 struct npc_install_flow_req *req,
-				 struct flow_cls_offload *f)
+				 struct flow_cls_offload *f,
+				 struct otx2_tc_flow *node)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_action_entry *act;
 	struct net_device *target;
 	struct otx2_nic *priv;
+	u32 burst, mark = 0;
+	u8 nr_police = 0;
+	bool pps;
+	u64 rate;
 	int i;
 
 	if (!flow_action_has_entries(flow_action)) {
@@ -262,15 +322,51 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 			/* use RX_VTAG_TYPE7 which is initialized to strip vlan tag */
 			req->vtag0_type = NIX_AF_LFX_RX_VTAG_TYPE7;
 			break;
+		case FLOW_ACTION_POLICE:
+			/* Ingress ratelimiting is not supported on OcteonTx2 */
+			if (is_dev_otx2(nic->pdev)) {
+				NL_SET_ERR_MSG_MOD(extack,
+					"Ingress policing not supported on this platform");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.rate_bytes_ps > 0) {
+				rate = act->police.rate_bytes_ps * 8;
+				burst = act->police.burst;
+			} else if (act->police.rate_pkt_ps > 0) {
+				/* The algorithm used to calculate rate
+				 * mantissa, exponent values for a given token
+				 * rate (token can be byte or packet) requires
+				 * token rate to be mutiplied by 8.
+				 */
+				rate = act->police.rate_pkt_ps * 8;
+				burst = act->police.burst_pkt;
+				pps = true;
+			}
+			nr_police++;
+			break;
+		case FLOW_ACTION_MARK:
+			mark = act->mark;
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
 	}
 
+	if (nr_police > 1) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "rate limit police offload requires a single action");
+		return -EOPNOTSUPP;
+	}
+
+	if (nr_police)
+		return otx2_tc_act_set_police(nic, node, f, rate, burst,
+					      mark, req, pps);
+
 	return 0;
 }
 
-static int otx2_tc_prepare_flow(struct otx2_nic *nic,
+static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 				struct flow_cls_offload *f,
 				struct npc_install_flow_req *req)
 {
@@ -467,7 +563,7 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 			req->features |= BIT_ULL(NPC_SPORT_SCTP);
 	}
 
-	return otx2_tc_parse_actions(nic, &rule->action, req, f);
+	return otx2_tc_parse_actions(nic, &rule->action, req, f, node);
 }
 
 static int otx2_del_mcam_flow_entry(struct otx2_nic *nic, u16 entry)
@@ -502,6 +598,7 @@ static int otx2_tc_del_flow(struct otx2_nic *nic,
 {
 	struct otx2_tc_info *tc_info = &nic->tc_info;
 	struct otx2_tc_flow *flow_node;
+	int err;
 
 	flow_node = rhashtable_lookup_fast(&tc_info->flow_table,
 					   &tc_flow_cmd->cookie,
@@ -512,6 +609,27 @@ static int otx2_tc_del_flow(struct otx2_nic *nic,
 		return -EINVAL;
 	}
 
+	if (flow_node->is_act_police) {
+		mutex_lock(&nic->mbox.lock);
+
+		err = cn10k_map_unmap_rq_policer(nic, flow_node->rq,
+						 flow_node->leaf_profile, false);
+		if (err)
+			netdev_err(nic->netdev,
+				   "Unmapping RQ %d & profile %d failed\n",
+				   flow_node->rq, flow_node->leaf_profile);
+
+		err = cn10k_free_leaf_profile(nic, flow_node->leaf_profile);
+		if (err)
+			netdev_err(nic->netdev,
+				   "Unable to free leaf bandwidth profile(%d)\n",
+				   flow_node->leaf_profile);
+
+		__clear_bit(flow_node->rq, &nic->rq_bmap);
+
+		mutex_unlock(&nic->mbox.lock);
+	}
+
 	otx2_del_mcam_flow_entry(nic, flow_node->entry);
 
 	WARN_ON(rhashtable_remove_fast(&nic->tc_info.flow_table,
@@ -531,12 +649,18 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	struct netlink_ext_ack *extack = tc_flow_cmd->common.extack;
 	struct otx2_tc_info *tc_info = &nic->tc_info;
 	struct otx2_tc_flow *new_node, *old_node;
-	struct npc_install_flow_req *req;
-	int rc;
+	struct npc_install_flow_req *req, dummy;
+	int rc, err;
 
 	if (!(nic->flags & OTX2_FLAG_TC_FLOWER_SUPPORT))
 		return -ENOMEM;
 
+	if (bitmap_full(tc_info->tc_entries_bitmap, nic->flow_cfg->tc_max_flows)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Not enough MCAM space to add the flow");
+		return -ENOMEM;
+	}
+
 	/* allocate memory for the new flow and it's node */
 	new_node = kzalloc(sizeof(*new_node), GFP_KERNEL);
 	if (!new_node)
@@ -544,17 +668,11 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	spin_lock_init(&new_node->lock);
 	new_node->cookie = tc_flow_cmd->cookie;
 
-	mutex_lock(&nic->mbox.lock);
-	req = otx2_mbox_alloc_msg_npc_install_flow(&nic->mbox);
-	if (!req) {
-		mutex_unlock(&nic->mbox.lock);
-		return -ENOMEM;
-	}
+	memset(&dummy, 0, sizeof(struct npc_install_flow_req));
 
-	rc = otx2_tc_prepare_flow(nic, tc_flow_cmd, req);
+	rc = otx2_tc_prepare_flow(nic, new_node, tc_flow_cmd, &dummy);
 	if (rc) {
-		otx2_mbox_reset(&nic->mbox.mbox, 0);
-		mutex_unlock(&nic->mbox.lock);
+		kfree_rcu(new_node, rcu);
 		return rc;
 	}
 
@@ -565,14 +683,17 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	if (old_node)
 		otx2_tc_del_flow(nic, tc_flow_cmd);
 
-	if (bitmap_full(tc_info->tc_entries_bitmap, nic->flow_cfg->tc_max_flows)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Not enough MCAM space to add the flow");
-		otx2_mbox_reset(&nic->mbox.mbox, 0);
+	mutex_lock(&nic->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_install_flow(&nic->mbox);
+	if (!req) {
 		mutex_unlock(&nic->mbox.lock);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto free_leaf;
 	}
 
+	memcpy(&dummy.hdr, &req->hdr, sizeof(struct mbox_msghdr));
+	memcpy(req, &dummy, sizeof(struct npc_install_flow_req));
+
 	new_node->bitpos = find_first_zero_bit(tc_info->tc_entries_bitmap,
 					       nic->flow_cfg->tc_max_flows);
 	req->channel = nic->hw.rx_chan_base;
@@ -587,7 +708,8 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	if (rc) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to install MCAM flow entry");
 		mutex_unlock(&nic->mbox.lock);
-		goto out;
+		kfree_rcu(new_node, rcu);
+		goto free_leaf;
 	}
 	mutex_unlock(&nic->mbox.lock);
 
@@ -597,12 +719,35 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	if (rc) {
 		otx2_del_mcam_flow_entry(nic, req->entry);
 		kfree_rcu(new_node, rcu);
-		goto out;
+		goto free_leaf;
 	}
 
 	set_bit(new_node->bitpos, tc_info->tc_entries_bitmap);
 	tc_info->num_entries++;
-out:
+
+	return 0;
+
+free_leaf:
+	if (new_node->is_act_police) {
+		mutex_lock(&nic->mbox.lock);
+
+		err = cn10k_map_unmap_rq_policer(nic, new_node->rq,
+						 new_node->leaf_profile, false);
+		if (err)
+			netdev_err(nic->netdev,
+				   "Unmapping RQ %d & profile %d failed\n",
+				   new_node->rq, new_node->leaf_profile);
+		err = cn10k_free_leaf_profile(nic, new_node->leaf_profile);
+		if (err)
+			netdev_err(nic->netdev,
+				   "Unable to free leaf bandwidth profile(%d)\n",
+				   new_node->leaf_profile);
+
+		__clear_bit(new_node->rq, &nic->rq_bmap);
+
+		mutex_unlock(&nic->mbox.lock);
+	}
+
 	return rc;
 }
 
@@ -864,6 +1009,9 @@ int otx2_init_tc(struct otx2_nic *nic)
 {
 	struct otx2_tc_info *tc = &nic->tc_info;
 
+	/* Exclude receive queue 0 being used for police action */
+	set_bit(0, &nic->rq_bmap);
+
 	tc->flow_ht_params = tc_flow_ht_params;
 	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
 }
-- 
2.7.4

