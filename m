Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087851030B4
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfKTAZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:25:11 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:31003 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfKTAZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:25:11 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAK0P2GS028464;
        Tue, 19 Nov 2019 16:25:03 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@resnulli.us, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v5 3/3] cxgb4: add TC-MATCHALL classifier ingress offload
Date:   Wed, 20 Nov 2019 05:46:08 +0530
Message-Id: <b2300487337e2c7778ab206038e1cf973dc1985c.1574176510.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TC-MATCHALL classifier ingress offload support. The same actions
supported by existing TC-FLOWER offload can be applied to all incoming
traffic on the underlying interface.

Ensure the rule priority doesn't conflict with existing rules in the
TCAM. Only 1 ingress matchall rule can be active at a time on the
underlying interface.

v5:
- No change.

v4:
- Added check to ensure the matchall rule's prio doesn't conflict with
  other rules in TCAM.
- Added logic to fill default mask for VIID, if none has been
  provided, to prevent conflict with duplicate VIID rules.
- Used existing variables in private structure to fill VIID info,
  instead of extracting the info manually.

v3:
- No change.

v2:
- Removed logic to fetch free index from end of TCAM. Must maintain
  same ordering as in kernel.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c |   6 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  15 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  21 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |   6 +
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 145 +++++++++++++++++-
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |  18 ++-
 6 files changed, 192 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 8bdcccea47d5..1d39fca11810 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -872,6 +872,12 @@ static void fill_default_mask(struct ch_filter_specification *fs)
 		fs->mask.tos |= ~0;
 	if (fs->val.proto && !fs->mask.proto)
 		fs->mask.proto |= ~0;
+	if (fs->val.pfvf_vld && !fs->mask.pfvf_vld)
+		fs->mask.pfvf_vld |= ~0;
+	if (fs->val.pf && !fs->mask.pf)
+		fs->mask.pf |= ~0;
+	if (fs->val.vf && !fs->mask.vf)
+		fs->mask.vf |= ~0;
 
 	for (i = 0; i < ARRAY_SIZE(fs->val.lip); i++) {
 		lip |= fs->val.lip[i];
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index f04f9c858d52..e8a1826a1e90 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3236,7 +3236,8 @@ static int cxgb_setup_tc_cls_u32(struct net_device *dev,
 }
 
 static int cxgb_setup_tc_matchall(struct net_device *dev,
-				  struct tc_cls_matchall_offload *cls_matchall)
+				  struct tc_cls_matchall_offload *cls_matchall,
+				  bool ingress)
 {
 	struct adapter *adap = netdev2adap(dev);
 
@@ -3245,9 +3246,13 @@ static int cxgb_setup_tc_matchall(struct net_device *dev,
 
 	switch (cls_matchall->command) {
 	case TC_CLSMATCHALL_REPLACE:
-		return cxgb4_tc_matchall_replace(dev, cls_matchall);
+		return cxgb4_tc_matchall_replace(dev, cls_matchall, ingress);
 	case TC_CLSMATCHALL_DESTROY:
-		return cxgb4_tc_matchall_destroy(dev, cls_matchall);
+		return cxgb4_tc_matchall_destroy(dev, cls_matchall, ingress);
+	case TC_CLSMATCHALL_STATS:
+		if (ingress)
+			return cxgb4_tc_matchall_stats(dev, cls_matchall);
+		break;
 	default:
 		break;
 	}
@@ -3277,6 +3282,8 @@ static int cxgb_setup_tc_block_ingress_cb(enum tc_setup_type type,
 		return cxgb_setup_tc_cls_u32(dev, type_data);
 	case TC_SETUP_CLSFLOWER:
 		return cxgb_setup_tc_flower(dev, type_data);
+	case TC_SETUP_CLSMATCHALL:
+		return cxgb_setup_tc_matchall(dev, type_data, true);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3301,7 +3308,7 @@ static int cxgb_setup_tc_block_egress_cb(enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
-		return cxgb_setup_tc_matchall(dev, type_data);
+		return cxgb_setup_tc_matchall(dev, type_data, false);
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 5179ad23be3c..0fa80bef575d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -378,15 +378,14 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 	}
 }
 
-static void cxgb4_process_flow_actions(struct net_device *in,
-				       struct flow_cls_offload *cls,
-				       struct ch_filter_specification *fs)
+void cxgb4_process_flow_actions(struct net_device *in,
+				struct flow_action *actions,
+				struct ch_filter_specification *fs)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_action_entry *act;
 	int i;
 
-	flow_action_for_each(i, act, &rule->action) {
+	flow_action_for_each(i, act, actions) {
 		switch (act->id) {
 		case FLOW_ACTION_ACCEPT:
 			fs->action = FILTER_PASS;
@@ -544,17 +543,16 @@ static bool valid_pedit_action(struct net_device *dev,
 	return true;
 }
 
-static int cxgb4_validate_flow_actions(struct net_device *dev,
-				       struct flow_cls_offload *cls)
+int cxgb4_validate_flow_actions(struct net_device *dev,
+				struct flow_action *actions)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_action_entry *act;
 	bool act_redir = false;
 	bool act_pedit = false;
 	bool act_vlan = false;
 	int i;
 
-	flow_action_for_each(i, act, &rule->action) {
+	flow_action_for_each(i, act, actions) {
 		switch (act->id) {
 		case FLOW_ACTION_ACCEPT:
 		case FLOW_ACTION_DROP:
@@ -636,6 +634,7 @@ static int cxgb4_validate_flow_actions(struct net_device *dev,
 int cxgb4_tc_flower_replace(struct net_device *dev,
 			    struct flow_cls_offload *cls)
 {
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct adapter *adap = netdev2adap(dev);
 	struct ch_tc_flower_entry *ch_flower;
@@ -643,7 +642,7 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	struct filter_ctx ctx;
 	int fidx, ret;
 
-	if (cxgb4_validate_flow_actions(dev, cls))
+	if (cxgb4_validate_flow_actions(dev, &rule->action))
 		return -EOPNOTSUPP;
 
 	if (cxgb4_validate_flow_match(dev, cls))
@@ -658,7 +657,7 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	fs = &ch_flower->fs;
 	fs->hitcnts = 1;
 	cxgb4_process_flow_match(dev, cls, fs);
-	cxgb4_process_flow_actions(dev, cls, fs);
+	cxgb4_process_flow_actions(dev, &rule->action, fs);
 
 	fs->hash = is_filter_exact_match(adap, fs);
 	if (fs->hash) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index eb4c95248baf..e132516e9868 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -108,6 +108,12 @@ struct ch_tc_pedit_fields {
 #define PEDIT_TCP_SPORT_DPORT		0x0
 #define PEDIT_UDP_SPORT_DPORT		0x0
 
+void cxgb4_process_flow_actions(struct net_device *in,
+				struct flow_action *actions,
+				struct ch_filter_specification *fs);
+int cxgb4_validate_flow_actions(struct net_device *dev,
+				struct flow_action *actions);
+
 int cxgb4_tc_flower_replace(struct net_device *dev,
 			    struct flow_cls_offload *cls);
 int cxgb4_tc_flower_destroy(struct net_device *dev,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 85bf0a238a49..102b370fbd3e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -4,6 +4,9 @@
 #include "cxgb4.h"
 #include "cxgb4_tc_matchall.h"
 #include "sched.h"
+#include "cxgb4_uld.h"
+#include "cxgb4_filter.h"
+#include "cxgb4_tc_flower.h"
 
 static int cxgb4_matchall_egress_validate(struct net_device *dev,
 					  struct tc_cls_matchall_offload *cls)
@@ -118,8 +121,85 @@ static void cxgb4_matchall_free_tc(struct net_device *dev)
 	tc_port_matchall->egress.state = CXGB4_MATCHALL_STATE_DISABLED;
 }
 
+static int cxgb4_matchall_alloc_filter(struct net_device *dev,
+				       struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct ch_filter_specification *fs;
+	int ret, fidx;
+
+	/* Note that TC uses prio 0 to indicate stack to generate
+	 * automatic prio and hence doesn't pass prio 0 to driver.
+	 * However, the hardware TCAM index starts from 0. Hence, the
+	 * -1 here. 1 slot is enough to create a wildcard matchall
+	 * VIID rule.
+	 */
+	if (cls->common.prio <= adap->tids.nftids)
+		fidx = cls->common.prio - 1;
+	else
+		fidx = cxgb4_get_free_ftid(dev, PF_INET);
+
+	/* Only insert MATCHALL rule if its priority doesn't conflict
+	 * with existing rules in the LETCAM.
+	 */
+	if (fidx < 0 ||
+	    !cxgb4_filter_prio_in_range(dev, fidx, cls->common.prio)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "No free LETCAM index available");
+		return -ENOMEM;
+	}
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	fs = &tc_port_matchall->ingress.fs;
+	memset(fs, 0, sizeof(*fs));
+
+	fs->tc_prio = cls->common.prio;
+	fs->tc_cookie = cls->cookie;
+	fs->hitcnts = 1;
+
+	fs->val.pfvf_vld = 1;
+	fs->val.pf = adap->pf;
+	fs->val.vf = pi->vin;
+
+	cxgb4_process_flow_actions(dev, &cls->rule->action, fs);
+
+	ret = cxgb4_set_filter(dev, fidx, fs);
+	if (ret)
+		return ret;
+
+	tc_port_matchall->ingress.tid = fidx;
+	tc_port_matchall->ingress.state = CXGB4_MATCHALL_STATE_ENABLED;
+	return 0;
+}
+
+static int cxgb4_matchall_free_filter(struct net_device *dev)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	int ret;
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+
+	ret = cxgb4_del_filter(dev, tc_port_matchall->ingress.tid,
+			       &tc_port_matchall->ingress.fs);
+	if (ret)
+		return ret;
+
+	tc_port_matchall->ingress.packets = 0;
+	tc_port_matchall->ingress.bytes = 0;
+	tc_port_matchall->ingress.last_used = 0;
+	tc_port_matchall->ingress.tid = 0;
+	tc_port_matchall->ingress.state = CXGB4_MATCHALL_STATE_DISABLED;
+	return 0;
+}
+
 int cxgb4_tc_matchall_replace(struct net_device *dev,
-			      struct tc_cls_matchall_offload *cls_matchall)
+			      struct tc_cls_matchall_offload *cls_matchall,
+			      bool ingress)
 {
 	struct netlink_ext_ack *extack = cls_matchall->common.extack;
 	struct cxgb4_tc_port_matchall *tc_port_matchall;
@@ -128,6 +208,22 @@ int cxgb4_tc_matchall_replace(struct net_device *dev,
 	int ret;
 
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	if (ingress) {
+		if (tc_port_matchall->ingress.state ==
+		    CXGB4_MATCHALL_STATE_ENABLED) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only 1 Ingress MATCHALL can be offloaded");
+			return -ENOMEM;
+		}
+
+		ret = cxgb4_validate_flow_actions(dev,
+						  &cls_matchall->rule->action);
+		if (ret)
+			return ret;
+
+		return cxgb4_matchall_alloc_filter(dev, cls_matchall);
+	}
+
 	if (tc_port_matchall->egress.state == CXGB4_MATCHALL_STATE_ENABLED) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Only 1 Egress MATCHALL can be offloaded");
@@ -142,13 +238,22 @@ int cxgb4_tc_matchall_replace(struct net_device *dev,
 }
 
 int cxgb4_tc_matchall_destroy(struct net_device *dev,
-			      struct tc_cls_matchall_offload *cls_matchall)
+			      struct tc_cls_matchall_offload *cls_matchall,
+			      bool ingress)
 {
 	struct cxgb4_tc_port_matchall *tc_port_matchall;
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
 
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	if (ingress) {
+		if (cls_matchall->cookie !=
+		    tc_port_matchall->ingress.fs.tc_cookie)
+			return -ENOENT;
+
+		return cxgb4_matchall_free_filter(dev);
+	}
+
 	if (cls_matchall->cookie != tc_port_matchall->egress.cookie)
 		return -ENOENT;
 
@@ -156,6 +261,39 @@ int cxgb4_tc_matchall_destroy(struct net_device *dev,
 	return 0;
 }
 
+int cxgb4_tc_matchall_stats(struct net_device *dev,
+			    struct tc_cls_matchall_offload *cls_matchall)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	u64 packets, bytes;
+	int ret;
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	if (tc_port_matchall->ingress.state == CXGB4_MATCHALL_STATE_DISABLED)
+		return -ENOENT;
+
+	ret = cxgb4_get_filter_counters(dev, tc_port_matchall->ingress.tid,
+					&packets, &bytes,
+					tc_port_matchall->ingress.fs.hash);
+	if (ret)
+		return ret;
+
+	if (tc_port_matchall->ingress.packets != packets) {
+		flow_stats_update(&cls_matchall->stats,
+				  bytes - tc_port_matchall->ingress.bytes,
+				  packets - tc_port_matchall->ingress.packets,
+				  tc_port_matchall->ingress.last_used);
+
+		tc_port_matchall->ingress.packets = packets;
+		tc_port_matchall->ingress.bytes = bytes;
+		tc_port_matchall->ingress.last_used = jiffies;
+	}
+
+	return 0;
+}
+
 static void cxgb4_matchall_disable_offload(struct net_device *dev)
 {
 	struct cxgb4_tc_port_matchall *tc_port_matchall;
@@ -165,6 +303,9 @@ static void cxgb4_matchall_disable_offload(struct net_device *dev)
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
 	if (tc_port_matchall->egress.state == CXGB4_MATCHALL_STATE_ENABLED)
 		cxgb4_matchall_free_tc(dev);
+
+	if (tc_port_matchall->ingress.state == CXGB4_MATCHALL_STATE_ENABLED)
+		cxgb4_matchall_free_filter(dev);
 }
 
 int cxgb4_init_tc_matchall(struct adapter *adap)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
index ce5b0800f0d8..ab6b5683dfd3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
@@ -17,8 +17,18 @@ struct cxgb4_matchall_egress_entry {
 	u64 cookie; /* Used to identify the MATCHALL rule offloaded */
 };
 
+struct cxgb4_matchall_ingress_entry {
+	enum cxgb4_matchall_state state; /* Current MATCHALL offload state */
+	u32 tid; /* Index to hardware filter entry */
+	struct ch_filter_specification fs; /* Filter entry */
+	u64 bytes; /* # of bytes hitting the filter */
+	u64 packets; /* # of packets hitting the filter */
+	u64 last_used; /* Last updated jiffies time */
+};
+
 struct cxgb4_tc_port_matchall {
 	struct cxgb4_matchall_egress_entry egress; /* Egress offload info */
+	struct cxgb4_matchall_ingress_entry ingress; /* Ingress offload info */
 };
 
 struct cxgb4_tc_matchall {
@@ -26,9 +36,13 @@ struct cxgb4_tc_matchall {
 };
 
 int cxgb4_tc_matchall_replace(struct net_device *dev,
-			      struct tc_cls_matchall_offload *cls_matchall);
+			      struct tc_cls_matchall_offload *cls_matchall,
+			      bool ingress);
 int cxgb4_tc_matchall_destroy(struct net_device *dev,
-			      struct tc_cls_matchall_offload *cls_matchall);
+			      struct tc_cls_matchall_offload *cls_matchall,
+			      bool ingress);
+int cxgb4_tc_matchall_stats(struct net_device *dev,
+			    struct tc_cls_matchall_offload *cls_matchall);
 
 int cxgb4_init_tc_matchall(struct adapter *adap);
 void cxgb4_cleanup_tc_matchall(struct adapter *adap);
-- 
2.24.0

