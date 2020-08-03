Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8208423AC8F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgHCSnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:43:49 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:14327 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgHCSns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:43:48 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 073Ihd3l031430;
        Mon, 3 Aug 2020 11:43:40 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net-next] cxgb4: add TC-MATCHALL IPv6 support
Date:   Tue,  4 Aug 2020 00:00:08 +0530
Message-Id: <1596479408-31023-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matching IPv6 traffic require allocating their own individual slots
in TCAM. So, fetch additional slots to insert IPv6 rules. Also, fetch
the cumulative stats of all the slots occupied by the Matchall rule.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   2 +
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 101 +++++++++++++-----
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |   5 +-
 3 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index adbc0d088070..9cb8b229c1b3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1438,6 +1438,8 @@ enum {
 	NAT_MODE_ALL		/* NAT on entire 4-tuple */
 };
 
+#define CXGB4_FILTER_TYPE_MAX 2
+
 /* Host shadow copy of ingress filter entry.  This is in host native format
  * and doesn't match the ordering or bit order, etc. of the hardware of the
  * firmware command.  The use of bit-field structure elements is purely to
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index e377e50c2492..2e309f6673f7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -231,8 +231,26 @@ static void cxgb4_matchall_mirror_free(struct net_device *dev)
 	tc_port_matchall->ingress.viid_mirror = 0;
 }
 
-static int cxgb4_matchall_alloc_filter(struct net_device *dev,
-				       struct tc_cls_matchall_offload *cls)
+static int cxgb4_matchall_del_filter(struct net_device *dev, u8 filter_type)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	int ret;
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	ret = cxgb4_del_filter(dev, tc_port_matchall->ingress.tid[filter_type],
+			       &tc_port_matchall->ingress.fs[filter_type]);
+	if (ret)
+		return ret;
+
+	tc_port_matchall->ingress.tid[filter_type] = 0;
+	return 0;
+}
+
+static int cxgb4_matchall_add_filter(struct net_device *dev,
+				     struct tc_cls_matchall_offload *cls,
+				     u8 filter_type)
 {
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct cxgb4_tc_port_matchall *tc_port_matchall;
@@ -244,28 +262,24 @@ static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 	/* Get a free filter entry TID, where we can insert this new
 	 * rule. Only insert rule if its prio doesn't conflict with
 	 * existing rules.
-	 *
-	 * 1 slot is enough to create a wildcard matchall VIID rule.
 	 */
-	fidx = cxgb4_get_free_ftid(dev, PF_INET, false, cls->common.prio);
+	fidx = cxgb4_get_free_ftid(dev, filter_type ? PF_INET6 : PF_INET,
+				   false, cls->common.prio);
 	if (fidx < 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "No free LETCAM index available");
 		return -ENOMEM;
 	}
 
-	ret = cxgb4_matchall_mirror_alloc(dev, cls);
-	if (ret)
-		return ret;
-
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
-	fs = &tc_port_matchall->ingress.fs;
+	fs = &tc_port_matchall->ingress.fs[filter_type];
 	memset(fs, 0, sizeof(*fs));
 
 	if (fidx < adap->tids.nhpftids)
 		fs->prio = 1;
 	fs->tc_prio = cls->common.prio;
 	fs->tc_cookie = cls->cookie;
+	fs->type = filter_type;
 	fs->hitcnts = 1;
 
 	fs->val.pfvf_vld = 1;
@@ -276,13 +290,39 @@ static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 
 	ret = cxgb4_set_filter(dev, fidx, fs);
 	if (ret)
-		goto out_free;
+		return ret;
+
+	tc_port_matchall->ingress.tid[filter_type] = fidx;
+	return 0;
+}
+
+static int cxgb4_matchall_alloc_filter(struct net_device *dev,
+				       struct tc_cls_matchall_offload *cls)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	int ret, i;
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+
+	ret = cxgb4_matchall_mirror_alloc(dev, cls);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < CXGB4_FILTER_TYPE_MAX; i++) {
+		ret = cxgb4_matchall_add_filter(dev, cls, i);
+		if (ret)
+			goto out_free;
+	}
 
-	tc_port_matchall->ingress.tid = fidx;
 	tc_port_matchall->ingress.state = CXGB4_MATCHALL_STATE_ENABLED;
 	return 0;
 
 out_free:
+	while (i-- > 0)
+		cxgb4_matchall_del_filter(dev, i);
+
 	cxgb4_matchall_mirror_free(dev);
 	return ret;
 }
@@ -293,20 +333,21 @@ static int cxgb4_matchall_free_filter(struct net_device *dev)
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
 	int ret;
+	u8 i;
 
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
 
-	ret = cxgb4_del_filter(dev, tc_port_matchall->ingress.tid,
-			       &tc_port_matchall->ingress.fs);
-	if (ret)
-		return ret;
+	for (i = 0; i < CXGB4_FILTER_TYPE_MAX; i++) {
+		ret = cxgb4_matchall_del_filter(dev, i);
+		if (ret)
+			return ret;
+	}
 
 	cxgb4_matchall_mirror_free(dev);
 
 	tc_port_matchall->ingress.packets = 0;
 	tc_port_matchall->ingress.bytes = 0;
 	tc_port_matchall->ingress.last_used = 0;
-	tc_port_matchall->ingress.tid = 0;
 	tc_port_matchall->ingress.state = CXGB4_MATCHALL_STATE_DISABLED;
 	return 0;
 }
@@ -362,8 +403,12 @@ int cxgb4_tc_matchall_destroy(struct net_device *dev,
 
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
 	if (ingress) {
+		/* All the filter types of this matchall rule save the
+		 * same cookie. So, checking for the first one is
+		 * enough.
+		 */
 		if (cls_matchall->cookie !=
-		    tc_port_matchall->ingress.fs.tc_cookie)
+		    tc_port_matchall->ingress.fs[0].tc_cookie)
 			return -ENOENT;
 
 		return cxgb4_matchall_free_filter(dev);
@@ -379,21 +424,29 @@ int cxgb4_tc_matchall_destroy(struct net_device *dev,
 int cxgb4_tc_matchall_stats(struct net_device *dev,
 			    struct tc_cls_matchall_offload *cls_matchall)
 {
+	u64 tmp_packets, tmp_bytes, packets = 0, bytes = 0;
 	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct cxgb4_matchall_ingress_entry *ingress;
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
-	u64 packets, bytes;
 	int ret;
+	u8 i;
 
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
 	if (tc_port_matchall->ingress.state == CXGB4_MATCHALL_STATE_DISABLED)
 		return -ENOENT;
 
-	ret = cxgb4_get_filter_counters(dev, tc_port_matchall->ingress.tid,
-					&packets, &bytes,
-					tc_port_matchall->ingress.fs.hash);
-	if (ret)
-		return ret;
+	ingress = &tc_port_matchall->ingress;
+	for (i = 0; i < CXGB4_FILTER_TYPE_MAX; i++) {
+		ret = cxgb4_get_filter_counters(dev, ingress->tid[i],
+						&tmp_packets, &tmp_bytes,
+						ingress->fs[i].hash);
+		if (ret)
+			return ret;
+
+		packets += tmp_packets;
+		bytes += tmp_bytes;
+	}
 
 	if (tc_port_matchall->ingress.packets != packets) {
 		flow_stats_update(&cls_matchall->stats,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
index e264b6e606c4..fe7ec423a4c9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
@@ -19,8 +19,9 @@ struct cxgb4_matchall_egress_entry {
 
 struct cxgb4_matchall_ingress_entry {
 	enum cxgb4_matchall_state state; /* Current MATCHALL offload state */
-	u32 tid; /* Index to hardware filter entry */
-	struct ch_filter_specification fs; /* Filter entry */
+	u32 tid[CXGB4_FILTER_TYPE_MAX]; /* Index to hardware filter entries */
+	/* Filter entries */
+	struct ch_filter_specification fs[CXGB4_FILTER_TYPE_MAX];
 	u16 viid_mirror; /* Identifier for allocated Mirror VI */
 	u64 bytes; /* # of bytes hitting the filter */
 	u64 packets; /* # of packets hitting the filter */
-- 
2.24.0

