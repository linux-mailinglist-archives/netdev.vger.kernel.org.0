Return-Path: <netdev+bounces-3571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A12C707E16
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D81B1C2095D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521D613AD9;
	Thu, 18 May 2023 10:26:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0BD13AD6
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:26:43 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2661BEA
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684405601; x=1715941601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K3kpBK9SLQx9yogV9QhZwbURZfdtUbdLPkuDa6JNRyc=;
  b=I0UWFOwi9+ScPZCeUjT4HG0oeVvHKYgjeQYeoCWVbXZaQg4FJNdht3iM
   JXVevRj8DUMUUGrOoPDXrgRLa8DnR6QlzGDB2HZNM8pWB8t6AOU+4hKnA
   Eyv2dJ7fStyquAuKHecy/gt8aWCZNct0tVrk0PGk6EZBN7NbLRgUvl+3+
   ICBjk6lBee+6HB7ywTPOP7U6loqv7YTorezAUvJ3DcC58/GdXhpsxsJw8
   xguPwESfSoDB2eeOFgoYjF78EH9FgFPLpe/RndcXsCFQogFmESmSQaFCL
   gcf8j4TL3qTNrTTRilDvqBud9/00p0GsNcYLGawI9p+7ct4SMYHBpyonL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="438371442"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="438371442"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 03:26:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="767143753"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="767143753"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 18 May 2023 03:26:26 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 4FDCC36C17;
	Thu, 18 May 2023 11:26:25 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com
Subject: [PATCH iwl-next v2 09/10] ice: implement static version of ageing
Date: Thu, 18 May 2023 12:25:08 +0200
Message-Id: <20230518102509.20913-10-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518102509.20913-1-wojciech.drewek@intel.com>
References: <20230518102509.20913-1-wojciech.drewek@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Remove fdb entries always when ageing time expired.

Allow user to set ageing time using port object attribute.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: use msecs_to_jiffies upon definition of
    ICE_ESW_BRIDGE_UPDATE_INTERVAL
---
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 48 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_eswitch_br.h   | 10 ++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index e4a8c9ac5e5d..41c47dec5d32 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -8,6 +8,8 @@
 #include "ice_vlan.h"
 #include "ice_vf_vsi_vlan_ops.h"
 
+#define ICE_ESW_BRIDGE_UPDATE_INTERVAL msecs_to_jiffies(1000)
+
 static const struct rhashtable_params ice_fdb_ht_params = {
 	.key_offset = offsetof(struct ice_esw_br_fdb_entry, data),
 	.key_len = sizeof(struct ice_esw_br_fdb_data),
@@ -452,6 +454,7 @@ ice_eswitch_br_fdb_entry_create(struct net_device *netdev,
 	fdb_entry->br_port = br_port;
 	fdb_entry->flow = flow;
 	fdb_entry->dev = netdev;
+	fdb_entry->last_use = jiffies;
 	event = SWITCHDEV_FDB_ADD_TO_BRIDGE;
 
 	if (added_by_user) {
@@ -845,6 +848,10 @@ ice_eswitch_br_port_obj_attr_set(struct net_device *netdev, const void *ctx,
 		ice_eswitch_br_vlan_filtering_set(br_port->bridge,
 						  attr->u.vlan_filtering);
 		return 0;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		br_port->bridge->ageing_time =
+			clock_t_to_jiffies(attr->u.ageing_time);
+		return 0;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1016,6 +1023,7 @@ ice_eswitch_br_init(struct ice_esw_br_offloads *br_offloads, int ifindex)
 	INIT_LIST_HEAD(&bridge->fdb_list);
 	bridge->br_offloads = br_offloads;
 	bridge->ifindex = ifindex;
+	bridge->ageing_time = clock_t_to_jiffies(BR_DEFAULT_AGEING_TIME);
 	xa_init(&bridge->ports);
 	br_offloads->bridge = bridge;
 
@@ -1219,6 +1227,7 @@ ice_eswitch_br_offloads_deinit(struct ice_pf *pf)
 	if (!br_offloads)
 		return;
 
+	cancel_delayed_work_sync(&br_offloads->update_work);
 	unregister_netdevice_notifier(&br_offloads->netdev_nb);
 	unregister_switchdev_blocking_notifier(&br_offloads->switchdev_blk);
 	unregister_switchdev_notifier(&br_offloads->switchdev_nb);
@@ -1233,6 +1242,40 @@ ice_eswitch_br_offloads_deinit(struct ice_pf *pf)
 	rtnl_unlock();
 }
 
+static void ice_eswitch_br_update(struct ice_esw_br_offloads *br_offloads)
+{
+	struct ice_esw_br *bridge = br_offloads->bridge;
+	struct ice_esw_br_fdb_entry *entry, *tmp;
+
+	if (!bridge)
+		return;
+
+	rtnl_lock();
+	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list) {
+		if (entry->flags & ICE_ESWITCH_BR_FDB_ADDED_BY_USER)
+			continue;
+
+		if (time_is_after_eq_jiffies(entry->last_use +
+					     bridge->ageing_time))
+			continue;
+
+		ice_eswitch_br_fdb_entry_notify_and_cleanup(bridge, entry);
+	}
+	rtnl_unlock();
+}
+
+static void ice_eswitch_br_update_work(struct work_struct *work)
+{
+	struct ice_esw_br_offloads *br_offloads;
+
+	br_offloads = ice_work_to_br_offloads(work);
+
+	ice_eswitch_br_update(br_offloads);
+
+	queue_delayed_work(br_offloads->wq, &br_offloads->update_work,
+			   ICE_ESW_BRIDGE_UPDATE_INTERVAL);
+}
+
 int
 ice_eswitch_br_offloads_init(struct ice_pf *pf)
 {
@@ -1281,6 +1324,11 @@ ice_eswitch_br_offloads_init(struct ice_pf *pf)
 		goto err_reg_netdev_nb;
 	}
 
+	INIT_DELAYED_WORK(&br_offloads->update_work,
+			  ice_eswitch_br_update_work);
+	queue_delayed_work(br_offloads->wq, &br_offloads->update_work,
+			   ICE_ESW_BRIDGE_UPDATE_INTERVAL);
+
 	return 0;
 
 err_reg_netdev_nb:
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
index 8c108fc25b2f..d17f7a6fefc4 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
@@ -5,6 +5,7 @@
 #define _ICE_ESWITCH_BR_H_
 
 #include <linux/rhashtable.h>
+#include <linux/workqueue.h>
 
 struct ice_esw_br_fdb_data {
 	unsigned char addr[ETH_ALEN];
@@ -30,6 +31,8 @@ struct ice_esw_br_fdb_entry {
 	struct net_device *dev;
 	struct ice_esw_br_port *br_port;
 	struct ice_esw_br_flow *flow;
+
+	unsigned long last_use;
 };
 
 enum ice_esw_br_port_type {
@@ -59,6 +62,7 @@ struct ice_esw_br {
 
 	int ifindex;
 	u32 flags;
+	unsigned long ageing_time;
 };
 
 struct ice_esw_br_offloads {
@@ -69,6 +73,7 @@ struct ice_esw_br_offloads {
 	struct notifier_block switchdev_nb;
 
 	struct workqueue_struct *wq;
+	struct delayed_work update_work;
 };
 
 struct ice_esw_br_fdb_work {
@@ -89,6 +94,11 @@ struct ice_esw_br_vlan {
 		     struct ice_esw_br_offloads, \
 		     nb_name)
 
+#define ice_work_to_br_offloads(w) \
+	container_of(w, \
+		     struct ice_esw_br_offloads, \
+		     update_work.work)
+
 #define ice_work_to_fdb_work(w) \
 	container_of(w, \
 		     struct ice_esw_br_fdb_work, \
-- 
2.40.1


