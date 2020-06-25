Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25717209E2C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404222AbgFYMLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:11:33 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:54452 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404450AbgFYMLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:11:32 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05PCBTHd025237;
        Thu, 25 Jun 2020 05:11:30 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 1/3] cxgb4: add mirror action to TC-MATCHALL offload
Date:   Thu, 25 Jun 2020 17:28:41 +0530
Message-Id: <9a8e0a8df764f44f6dce0c3fbb9dd56aa8d049ab.1593085107.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mirror Virtual Interface (VI) support to receive all ingress
mirror traffic from the underlying device. The mirror VI is
created dynamically, if the TC-MATCHALL rule has a corresponding
mirror action. Also request MSI-X vectors needed for the mirror VI
Rxqs. If no vectors are available, then disable mirror VI support.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    | 10 ++
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 94 ++++++++++++++++++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 16 +++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 57 ++++++++++-
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |  1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 16 ++++
 7 files changed, 187 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index d811df1b93d9..14ef48e82cde 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -679,6 +679,11 @@ struct port_info {
 	u8 rx_cchan;
 
 	bool tc_block_shared;
+
+	/* Mirror VI information */
+	u16 viid_mirror;
+	refcount_t vi_mirror_refcnt;
+	u16 nmirrorqsets;
 };
 
 struct dentry;
@@ -960,6 +965,7 @@ struct sge {
 	u16 ofldqsets;              /* # of active ofld queue sets */
 	u16 nqs_per_uld;	    /* # of Rx queues per ULD */
 	u16 eoqsets;                /* # of ETHOFLD queues */
+	u16 mirrorqsets;            /* # of Mirror queues */
 
 	u16 timer_val[SGE_NTIMERS];
 	u8 counter_val[SGE_NCOUNTERS];
@@ -1857,6 +1863,8 @@ int t4_init_rss_mode(struct adapter *adap, int mbox);
 int t4_init_portinfo(struct port_info *pi, int mbox,
 		     int port, int pf, int vf, u8 mac[]);
 int t4_port_init(struct adapter *adap, int mbox, int pf, int vf);
+int t4_init_port_mirror(struct port_info *pi, u8 mbox, u8 port, u8 pf, u8 vf,
+			u16 *mirror_viid);
 void t4_fatal_err(struct adapter *adapter);
 unsigned int t4_chip_rss_size(struct adapter *adapter);
 int t4_config_rss_range(struct adapter *adapter, int mbox, unsigned int viid,
@@ -2141,6 +2149,8 @@ int cxgb_open(struct net_device *dev);
 int cxgb_close(struct net_device *dev);
 void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q);
 void cxgb4_quiesce_rx(struct sge_rspq *q);
+int cxgb4_port_mirror_alloc(struct net_device *dev);
+void cxgb4_port_mirror_free(struct net_device *dev);
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 int cxgb4_set_ktls_feature(struct adapter *adap, bool enable);
 #endif
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 87505a0d906a..cb4cb2d70e6d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1285,6 +1285,47 @@ static int setup_debugfs(struct adapter *adap)
 	return 0;
 }
 
+int cxgb4_port_mirror_alloc(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	int ret;
+
+	if (!pi->nmirrorqsets)
+		return -EOPNOTSUPP;
+
+	if (pi->viid_mirror) {
+		refcount_inc(&pi->vi_mirror_refcnt);
+		return 0;
+	}
+
+	ret = t4_init_port_mirror(pi, adap->mbox, pi->port_id, adap->pf, 0,
+				  &pi->viid_mirror);
+	if (ret)
+		return ret;
+
+	refcount_set(&pi->vi_mirror_refcnt, 1);
+	return 0;
+}
+
+void cxgb4_port_mirror_free(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+
+	if (!pi->viid_mirror)
+		return;
+
+	if (refcount_read(&pi->vi_mirror_refcnt) > 1) {
+		refcount_dec(&pi->vi_mirror_refcnt);
+		return;
+	}
+
+	refcount_set(&pi->vi_mirror_refcnt, 0);
+	t4_free_vi(adap, adap->mbox, adap->pf, 0, pi->viid_mirror);
+	pi->viid_mirror = 0;
+}
+
 /*
  * upper-layer driver support
  */
@@ -5503,6 +5544,19 @@ static int cfg_queues(struct adapter *adap)
 		avail_qsets -= s->eoqsets;
 	}
 
+	/* Mirror queues must follow same scheme as normal Ethernet
+	 * Queues, when there are enough queues available. Otherwise,
+	 * allocate at least 1 queue per port. If even 1 queue is not
+	 * available, then disable mirror queues support.
+	 */
+	if (avail_qsets >= s->max_ethqsets)
+		s->mirrorqsets = s->max_ethqsets;
+	else if (avail_qsets >= adap->params.nports)
+		s->mirrorqsets = adap->params.nports;
+	else
+		s->mirrorqsets = 0;
+	avail_qsets -= s->mirrorqsets;
+
 	for (i = 0; i < ARRAY_SIZE(s->ethrxq); i++) {
 		struct sge_eth_rxq *r = &s->ethrxq[i];
 
@@ -5616,8 +5670,8 @@ void cxgb4_free_msix_idx_in_bmap(struct adapter *adap,
 
 static int enable_msix(struct adapter *adap)
 {
-	u32 eth_need, uld_need = 0, ethofld_need = 0;
-	u32 ethqsets = 0, ofldqsets = 0, eoqsets = 0;
+	u32 eth_need, uld_need = 0, ethofld_need = 0, mirror_need = 0;
+	u32 ethqsets = 0, ofldqsets = 0, eoqsets = 0, mirrorqsets = 0;
 	u8 num_uld = 0, nchan = adap->params.nports;
 	u32 i, want, need, num_vec;
 	struct sge *s = &adap->sge;
@@ -5648,6 +5702,12 @@ static int enable_msix(struct adapter *adap)
 		need += ethofld_need;
 	}
 
+	if (s->mirrorqsets) {
+		want += s->mirrorqsets;
+		mirror_need = nchan;
+		need += mirror_need;
+	}
+
 	want += EXTRA_VECS;
 	need += EXTRA_VECS;
 
@@ -5681,8 +5741,10 @@ static int enable_msix(struct adapter *adap)
 		adap->params.ethofld = 0;
 		s->ofldqsets = 0;
 		s->eoqsets = 0;
+		s->mirrorqsets = 0;
 		uld_need = 0;
 		ethofld_need = 0;
+		mirror_need = 0;
 	}
 
 	num_vec = allocated;
@@ -5696,6 +5758,8 @@ static int enable_msix(struct adapter *adap)
 			ofldqsets = nchan;
 		if (is_ethofld(adap))
 			eoqsets = ethofld_need;
+		if (s->mirrorqsets)
+			mirrorqsets = mirror_need;
 
 		num_vec -= need;
 		while (num_vec) {
@@ -5727,12 +5791,25 @@ static int enable_msix(struct adapter *adap)
 				num_vec -= uld_need;
 			}
 		}
+
+		if (s->mirrorqsets) {
+			while (num_vec) {
+				if (num_vec < mirror_need ||
+				    mirrorqsets > s->mirrorqsets)
+					break;
+
+				mirrorqsets++;
+				num_vec -= mirror_need;
+			}
+		}
 	} else {
 		ethqsets = s->max_ethqsets;
 		if (is_uld(adap))
 			ofldqsets = s->ofldqsets;
 		if (is_ethofld(adap))
 			eoqsets = s->eoqsets;
+		if (s->mirrorqsets)
+			mirrorqsets = s->mirrorqsets;
 	}
 
 	if (ethqsets < s->max_ethqsets) {
@@ -5748,6 +5825,14 @@ static int enable_msix(struct adapter *adap)
 	if (is_ethofld(adap))
 		s->eoqsets = eoqsets;
 
+	if (s->mirrorqsets) {
+		s->mirrorqsets = mirrorqsets;
+		for_each_port(adap, i) {
+			pi = adap2pinfo(adap, i);
+			pi->nmirrorqsets = s->mirrorqsets / nchan;
+		}
+	}
+
 	/* map for msix */
 	ret = alloc_msix_info(adap, allocated);
 	if (ret)
@@ -5759,8 +5844,9 @@ static int enable_msix(struct adapter *adap)
 	}
 
 	dev_info(adap->pdev_dev,
-		 "%d MSI-X vectors allocated, nic %d eoqsets %d per uld %d\n",
-		 allocated, s->max_ethqsets, s->eoqsets, s->nqs_per_uld);
+		 "%d MSI-X vectors allocated, nic %d eoqsets %d per uld %d mirrorqsets %d\n",
+		 allocated, s->max_ethqsets, s->eoqsets, s->nqs_per_uld,
+		 s->mirrorqsets);
 
 	kfree(entries);
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index ccc7aab9a8be..4e8bcc51253d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -382,6 +382,7 @@ void cxgb4_process_flow_actions(struct net_device *in,
 		case FLOW_ACTION_DROP:
 			fs->action = FILTER_DROP;
 			break;
+		case FLOW_ACTION_MIRRED:
 		case FLOW_ACTION_REDIRECT: {
 			struct net_device *out = act->dev;
 			struct port_info *pi = netdev_priv(out);
@@ -539,7 +540,8 @@ static bool valid_pedit_action(struct net_device *dev,
 
 int cxgb4_validate_flow_actions(struct net_device *dev,
 				struct flow_action *actions,
-				struct netlink_ext_ack *extack)
+				struct netlink_ext_ack *extack,
+				u8 matchall_filter)
 {
 	struct flow_action_entry *act;
 	bool act_redir = false;
@@ -556,11 +558,19 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 		case FLOW_ACTION_DROP:
 			/* Do nothing */
 			break;
+		case FLOW_ACTION_MIRRED:
 		case FLOW_ACTION_REDIRECT: {
 			struct adapter *adap = netdev2adap(dev);
 			struct net_device *n_dev, *target_dev;
-			unsigned int i;
 			bool found = false;
+			unsigned int i;
+
+			if (act->id == FLOW_ACTION_MIRRED &&
+			    !matchall_filter) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Egress mirror action is only supported for tc-matchall");
+				return -EOPNOTSUPP;
+			}
 
 			target_dev = act->dev;
 			for_each_port(adap, i) {
@@ -699,7 +709,7 @@ int cxgb4_flow_rule_replace(struct net_device *dev, struct flow_rule *rule,
 	u8 inet_family;
 	int fidx, ret;
 
-	if (cxgb4_validate_flow_actions(dev, &rule->action, extack))
+	if (cxgb4_validate_flow_actions(dev, &rule->action, extack, 0))
 		return -EOPNOTSUPP;
 
 	if (cxgb4_validate_flow_match(dev, rule))
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index befa459324fb..6296e1d5a12b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -113,7 +113,8 @@ void cxgb4_process_flow_actions(struct net_device *in,
 				struct ch_filter_specification *fs);
 int cxgb4_validate_flow_actions(struct net_device *dev,
 				struct flow_action *actions,
-				struct netlink_ext_ack *extack);
+				struct netlink_ext_ack *extack,
+				u8 matchall_filter);
 
 int cxgb4_tc_flower_replace(struct net_device *dev,
 			    struct flow_cls_offload *cls);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index c439b5bce9c9..e377e50c2492 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -188,6 +188,49 @@ static void cxgb4_matchall_free_tc(struct net_device *dev)
 	tc_port_matchall->egress.state = CXGB4_MATCHALL_STATE_DISABLED;
 }
 
+static int cxgb4_matchall_mirror_alloc(struct net_device *dev,
+				       struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct flow_action_entry *act;
+	int ret;
+	u32 i;
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	flow_action_for_each(i, act, &cls->rule->action) {
+		if (act->id == FLOW_ACTION_MIRRED) {
+			ret = cxgb4_port_mirror_alloc(dev);
+			if (ret) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Couldn't allocate mirror");
+				return ret;
+			}
+
+			tc_port_matchall->ingress.viid_mirror = pi->viid_mirror;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void cxgb4_matchall_mirror_free(struct net_device *dev)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	if (!tc_port_matchall->ingress.viid_mirror)
+		return;
+
+	cxgb4_port_mirror_free(dev);
+	tc_port_matchall->ingress.viid_mirror = 0;
+}
+
 static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 				       struct tc_cls_matchall_offload *cls)
 {
@@ -211,6 +254,10 @@ static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 		return -ENOMEM;
 	}
 
+	ret = cxgb4_matchall_mirror_alloc(dev, cls);
+	if (ret)
+		return ret;
+
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
 	fs = &tc_port_matchall->ingress.fs;
 	memset(fs, 0, sizeof(*fs));
@@ -229,11 +276,15 @@ static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 
 	ret = cxgb4_set_filter(dev, fidx, fs);
 	if (ret)
-		return ret;
+		goto out_free;
 
 	tc_port_matchall->ingress.tid = fidx;
 	tc_port_matchall->ingress.state = CXGB4_MATCHALL_STATE_ENABLED;
 	return 0;
+
+out_free:
+	cxgb4_matchall_mirror_free(dev);
+	return ret;
 }
 
 static int cxgb4_matchall_free_filter(struct net_device *dev)
@@ -250,6 +301,8 @@ static int cxgb4_matchall_free_filter(struct net_device *dev)
 	if (ret)
 		return ret;
 
+	cxgb4_matchall_mirror_free(dev);
+
 	tc_port_matchall->ingress.packets = 0;
 	tc_port_matchall->ingress.bytes = 0;
 	tc_port_matchall->ingress.last_used = 0;
@@ -279,7 +332,7 @@ int cxgb4_tc_matchall_replace(struct net_device *dev,
 
 		ret = cxgb4_validate_flow_actions(dev,
 						  &cls_matchall->rule->action,
-						  extack);
+						  extack, 1);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
index ab6b5683dfd3..e264b6e606c4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
@@ -21,6 +21,7 @@ struct cxgb4_matchall_ingress_entry {
 	enum cxgb4_matchall_state state; /* Current MATCHALL offload state */
 	u32 tid; /* Index to hardware filter entry */
 	struct ch_filter_specification fs; /* Filter entry */
+	u16 viid_mirror; /* Identifier for allocated Mirror VI */
 	u64 bytes; /* # of bytes hitting the filter */
 	u64 packets; /* # of packets hitting the filter */
 	u64 last_used; /* Last updated jiffies time */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 8f2b7c9aa384..a2343631c951 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -9712,6 +9712,22 @@ int t4_port_init(struct adapter *adap, int mbox, int pf, int vf)
 	return 0;
 }
 
+int t4_init_port_mirror(struct port_info *pi, u8 mbox, u8 port, u8 pf, u8 vf,
+			u16 *mirror_viid)
+{
+	int ret;
+
+	ret = t4_alloc_vi(pi->adapter, mbox, port, pf, vf, 1, NULL, NULL,
+			  NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	if (mirror_viid)
+		*mirror_viid = ret;
+
+	return 0;
+}
+
 /**
  *	t4_read_cimq_cfg - read CIM queue configuration
  *	@adap: the adapter
-- 
2.24.0

