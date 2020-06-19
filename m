Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF0200B52
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgFSOWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:22:21 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:60872 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFSOWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:22:16 -0400
Received: from vishal.asicdesigners.com (chethan-pc.asicdesigners.com [10.193.177.170] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05JELtbe002529;
        Fri, 19 Jun 2020 07:22:11 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, rahul.lakkireddy@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 3/5] cxgb4: add ethtool n-tuple filter deletion
Date:   Fri, 19 Jun 2020 19:51:37 +0530
Message-Id: <20200619142139.27982-4-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200619142139.27982-1-vishal@chelsio.com>
References: <20200619142139.27982-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to delete ethtool n-tuple filter. Fetch the appropriate
filter region (HPFILTER, HASH, NORMAL) in which the filter exists,
and delete it from the respective region, accordingly.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 61 +++++++++++++++++++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 30 ++++++---
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  2 +
 3 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 82fc09b6dc8e..5c588677877d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1573,6 +1573,22 @@ static int set_rss_table(struct net_device *dev, const u32 *p, const u8 *key,
 	return -EPERM;
 }
 
+static struct filter_entry *cxgb4_get_filter_entry(struct adapter *adap,
+						   u32 ftid)
+{
+	struct tid_info *t = &adap->tids;
+	struct filter_entry *f;
+
+	if (ftid < t->nhpftids)
+		f = &adap->tids.hpftid_tab[ftid];
+	else if (ftid < t->nftids)
+		f = &adap->tids.ftid_tab[ftid - t->nhpftids];
+	else
+		f = lookup_tid(&adap->tids, ftid);
+
+	return f;
+}
+
 static int get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 		     u32 *rules)
 {
@@ -1636,6 +1652,48 @@ static int get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 	return -EOPNOTSUPP;
 }
 
+static int cxgb4_ntuple_del_filter(struct net_device *dev,
+				   struct ethtool_rxnfc *cmd)
+{
+	struct cxgb4_ethtool_filter_info *filter_info;
+	struct adapter *adapter = netdev2adap(dev);
+	struct port_info *pi = netdev_priv(dev);
+	struct filter_entry *f;
+	u32 filter_id;
+	int ret;
+
+	if (!(adapter->flags & CXGB4_FULL_INIT_DONE))
+		return -EAGAIN;  /* can still change nfilters */
+
+	if (!adapter->ethtool_filters)
+		return -EOPNOTSUPP;
+
+	if (cmd->fs.location >= adapter->ethtool_filters->nentries) {
+		dev_err(adapter->pdev_dev,
+			"Location must be < %u",
+			adapter->ethtool_filters->nentries);
+		return -ERANGE;
+	}
+
+	filter_info = &adapter->ethtool_filters->port[pi->port_id];
+
+	if (!test_bit(cmd->fs.location, filter_info->bmap))
+		return -ENOENT;
+
+	filter_id = filter_info->loc_array[cmd->fs.location];
+	f = cxgb4_get_filter_entry(adapter, filter_id);
+
+	ret = cxgb4_flow_rule_destroy(dev, f->fs.tc_prio, &f->fs, filter_id);
+	if (ret)
+		goto err;
+
+	clear_bit(cmd->fs.location, filter_info->bmap);
+	filter_info->in_use--;
+
+err:
+	return ret;
+}
+
 /* Add Ethtool n-tuple filters. */
 static int cxgb4_ntuple_set_filter(struct net_device *netdev,
 				   struct ethtool_rxnfc *cmd)
@@ -1702,6 +1760,9 @@ static int set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	case ETHTOOL_SRXCLSRLINS:
 		ret = cxgb4_ntuple_set_filter(dev, cmd);
 		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		ret = cxgb4_ntuple_del_filter(dev, cmd);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 222f4bc19908..53dbb3683653 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -797,23 +797,38 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	return ret;
 }
 
+int cxgb4_flow_rule_destroy(struct net_device *dev, u32 tc_prio,
+			    struct ch_filter_specification *fs, int tid)
+{
+	struct adapter *adap = netdev2adap(dev);
+	u8 hash;
+	int ret;
+
+	hash = fs->hash;
+
+	ret = cxgb4_del_filter(dev, tid, fs);
+	if (ret)
+		return ret;
+
+	if (hash)
+		cxgb4_tc_flower_hash_prio_del(adap, tc_prio);
+
+	return ret;
+}
+
 int cxgb4_tc_flower_destroy(struct net_device *dev,
 			    struct flow_cls_offload *cls)
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct ch_tc_flower_entry *ch_flower;
-	u32 tc_prio;
-	bool hash;
 	int ret;
 
 	ch_flower = ch_flower_lookup(adap, cls->cookie);
 	if (!ch_flower)
 		return -ENOENT;
 
-	hash = ch_flower->fs.hash;
-	tc_prio = ch_flower->fs.tc_prio;
-
-	ret = cxgb4_del_filter(dev, ch_flower->filter_id, &ch_flower->fs);
+	ret = cxgb4_flow_rule_destroy(dev, ch_flower->fs.tc_prio,
+				      &ch_flower->fs, ch_flower->filter_id);
 	if (ret)
 		goto err;
 
@@ -825,9 +840,6 @@ int cxgb4_tc_flower_destroy(struct net_device *dev,
 	}
 	kfree_rcu(ch_flower, rcu);
 
-	if (hash)
-		cxgb4_tc_flower_hash_prio_del(adap, tc_prio);
-
 err:
 	return ret;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index 7fa379749500..befa459324fb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -124,6 +124,8 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 int cxgb4_flow_rule_replace(struct net_device *dev, struct flow_rule *rule,
 			    u32 tc_prio, struct netlink_ext_ack *extack,
 			    struct ch_filter_specification *fs, u32 *tid);
+int cxgb4_flow_rule_destroy(struct net_device *dev, u32 tc_prio,
+			    struct ch_filter_specification *fs, int tid);
 
 int cxgb4_init_tc_flower(struct adapter *adap);
 void cxgb4_cleanup_tc_flower(struct adapter *adap);
-- 
2.21.1

