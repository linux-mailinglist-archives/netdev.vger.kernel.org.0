Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6F83A4F26
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 15:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhFLNw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 09:52:58 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:63740 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhFLNw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 09:52:57 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 15CDoqFR031324;
        Sat, 12 Jun 2021 06:50:53 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net] cxgb4: fix wrong ethtool n-tuple rule lookup
Date:   Sat, 12 Jun 2021 19:20:44 +0530
Message-Id: <1623505844-11391-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TID returned during successful filter creation is relative to
the region in which the filter is created. Using it directly always
returns Hi Prio/Normal filter region's entry for the first couple of
entries, even though the rule is actually inserted in Hash region.
Fix by analyzing in which region the filter has been inserted and
save the absolute TID to be used for lookup later.

Fixes: db43b30cd89c ("cxgb4: add ethtool n-tuple filter deletion")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index df20485b5744..83ed10ac8660 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1624,16 +1624,14 @@ static struct filter_entry *cxgb4_get_filter_entry(struct adapter *adap,
 						   u32 ftid)
 {
 	struct tid_info *t = &adap->tids;
-	struct filter_entry *f;
 
-	if (ftid < t->nhpftids)
-		f = &adap->tids.hpftid_tab[ftid];
-	else if (ftid < t->nftids)
-		f = &adap->tids.ftid_tab[ftid - t->nhpftids];
-	else
-		f = lookup_tid(&adap->tids, ftid);
+	if (ftid >= t->hpftid_base && ftid < t->hpftid_base + t->nhpftids)
+		return &t->hpftid_tab[ftid - t->hpftid_base];
+
+	if (ftid >= t->ftid_base && ftid < t->ftid_base + t->nftids)
+		return &t->ftid_tab[ftid - t->ftid_base];
 
-	return f;
+	return lookup_tid(t, ftid);
 }
 
 static void cxgb4_fill_filter_rule(struct ethtool_rx_flow_spec *fs,
@@ -1840,6 +1838,11 @@ static int cxgb4_ntuple_del_filter(struct net_device *dev,
 	filter_id = filter_info->loc_array[cmd->fs.location];
 	f = cxgb4_get_filter_entry(adapter, filter_id);
 
+	if (f->fs.prio)
+		filter_id -= adapter->tids.hpftid_base;
+	else if (!f->fs.hash)
+		filter_id -= (adapter->tids.ftid_base - adapter->tids.nhpftids);
+
 	ret = cxgb4_flow_rule_destroy(dev, f->fs.tc_prio, &f->fs, filter_id);
 	if (ret)
 		goto err;
@@ -1899,6 +1902,11 @@ static int cxgb4_ntuple_set_filter(struct net_device *netdev,
 
 	filter_info = &adapter->ethtool_filters->port[pi->port_id];
 
+	if (fs.prio)
+		tid += adapter->tids.hpftid_base;
+	else if (!fs.hash)
+		tid += (adapter->tids.ftid_base - adapter->tids.nhpftids);
+
 	filter_info->loc_array[cmd->fs.location] = tid;
 	set_bit(cmd->fs.location, filter_info->bmap);
 	filter_info->in_use++;
-- 
2.27.0

