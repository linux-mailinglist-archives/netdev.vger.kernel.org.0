Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB606E441F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjDQJjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjDQJji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:39:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61316582
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681724329; x=1713260329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xdIJybmHjN6f+RpYAJ6QHqRc4BQKRZTEUnrFK8Pi/QA=;
  b=HK7k0vFi62AZxS0mJGZAhwS4lwKp5NIOGuTdfcdl5neWh3G/e63gER75
   qbZq76YtdpHcbf/diUhX5u7f2aaAfxCCKSrhPJgdlEXK0Tc5Glgw78Bvy
   DqcLoiM6gDNK2FxMA+YSeLN7XDUUieXnEC1M5TTiXJt1QMJJTs0uJNtPj
   MDELzxS31SSA2dBekJm0AoWMATwXNkbxCg23Y1/s17fRc914YkLBbkNVu
   KHcLAJu0IWiUSQvlgoQ7F97QoZV3kPL2xdIPEtWYSQssrJE5guvjWoqfk
   j5iDzveT9rzFWIbA9upNcYL+0M5wxQvsDpFO8eLrj6vaqaZyvmCe8scK/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333644107"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="333644107"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 02:35:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="640899279"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="640899279"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2023 02:35:23 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 9F6BF37F4C;
        Mon, 17 Apr 2023 10:35:22 +0100 (IST)
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        david.m.ertman@intel.com, michal.swiatkowski@linux.intel.com,
        marcin.szycik@linux.intel.com, pawel.chmielewski@intel.com,
        sridhar.samudrala@intel.com
Subject: [PATCH net-next 09/12] ice: implement bridge port vlan
Date:   Mon, 17 Apr 2023 11:34:09 +0200
Message-Id: <20230417093412.12161-10-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417093412.12161-1-wojciech.drewek@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Port VLAN in this case means push and pop VLAN action on specific vid.
There are a few limitation in hardware:
- push and pop can't be used separately
- if port VLAN is used there can't be any trunk VLANs, because pop
  action is done on all trafic received by VSI in port VLAN mode
- port VLAN mode on uplink port isn't supported

Reflect these limitations in code using dev_info to inform the user
about unsupported configuration.

In bridge mode there is a need to configure port vlan without resetting
VFs. To do that implement ice_port_vlan_on/off() functions. They are
only configuring correct vlan_ops to allow setting port vlan.

We also need to clear port vlan without resetting the VF which is not
supported right now. Change it by implementing clear_port_vlan ops.
As previous VLAN configuration isn't always the same, store current
config while creating port vlan and restore it in clear function.

Configuration steps:
- configure switchdev with bridge
- #bridge vlan add dev eth0 vid 120 pvid untagged
- #bridge vlan add dev eth1 vid 120 pvid untagged
- ping from VF0 to VF1

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_eswitch_br.c   |  88 +++++++-
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |   1 +
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  | 195 ++++++++++--------
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.h  |   3 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c |  84 +++++++-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |   8 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |   1 +
 8 files changed, 291 insertions(+), 90 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5b2ade5908e8..489934ddfbb8 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -369,6 +369,7 @@ struct ice_vsi {
 	u16 rx_buf_len;
 
 	struct ice_aqc_vsi_props info;	 /* VSI properties */
+	struct ice_vsi_vlan_info vlan_info;	/* vlan config to be restored */
 
 	/* VSI stats */
 	struct rtnl_link_stats64 net_stats;
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index 56d36e397b12..a21eca5088f7 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -5,6 +5,8 @@
 #include "ice_eswitch_br.h"
 #include "ice_repr.h"
 #include "ice_switch.h"
+#include "ice_vlan.h"
+#include "ice_vf_vsi_vlan_ops.h"
 
 static const struct rhashtable_params ice_fdb_ht_params = {
 	.key_offset = offsetof(struct ice_esw_br_fdb_entry, data),
@@ -610,11 +612,26 @@ ice_eswitch_br_vlan_filtering_set(struct ice_esw_br *bridge, bool enable)
 		bridge->flags &= ~ICE_ESWITCH_BR_VLAN_FILTERING;
 }
 
+static void
+ice_eswitch_br_clear_pvid(struct ice_esw_br_port *port)
+{
+	struct ice_vsi_vlan_ops *vlan_ops =
+		ice_get_compat_vsi_vlan_ops(port->vsi);
+
+	vlan_ops->clear_port_vlan(port->vsi);
+
+	ice_vf_vsi_disable_port_vlan(port->vsi);
+
+	port->pvid = 0;
+}
+
 static void
 ice_eswitch_br_vlan_cleanup(struct ice_esw_br_port *port,
 			    struct ice_esw_br_vlan *vlan)
 {
 	xa_erase(&port->vlans, vlan->vid);
+	if (port->pvid == vlan->vid)
+		ice_eswitch_br_clear_pvid(port);
 	kfree(vlan);
 }
 
@@ -627,9 +644,50 @@ static void ice_eswitch_br_port_vlans_flush(struct ice_esw_br_port *port)
 		ice_eswitch_br_vlan_cleanup(port, vlan);
 }
 
+static int
+ice_eswitch_br_set_pvid(struct ice_esw_br_port *port,
+			struct ice_esw_br_vlan *vlan)
+{
+	struct ice_vlan port_vlan = ICE_VLAN(ETH_P_8021Q, vlan->vid, 0);
+	struct device *dev = ice_pf_to_dev(port->vsi->back);
+	struct ice_vsi_vlan_ops *vlan_ops;
+	int err;
+
+	if (port->pvid == vlan->vid || vlan->vid == 1)
+		return 0;
+
+	/* Setting port vlan on uplink isn't supported by hw */
+	if (port->type == ICE_ESWITCH_BR_UPLINK_PORT)
+		return -EOPNOTSUPP;
+
+	if (port->pvid) {
+		dev_info(dev,
+			 "Port VLAN (vsi=%u, vid=%u) already exists on the port, remove it before adding new one\n",
+			 port->vsi_idx, port->pvid);
+		return -EEXIST;
+	}
+
+	ice_vf_vsi_enable_port_vlan(port->vsi);
+
+	vlan_ops = ice_get_compat_vsi_vlan_ops(port->vsi);
+	err = vlan_ops->set_port_vlan(port->vsi, &port_vlan);
+	if (err)
+		return err;
+
+	err = vlan_ops->add_vlan(port->vsi, &port_vlan);
+	if (err)
+		return err;
+
+	ice_eswitch_br_port_vlans_flush(port);
+	port->pvid = vlan->vid;
+
+	return 0;
+}
+
 static struct ice_esw_br_vlan *
 ice_eswitch_br_vlan_create(u16 vid, u16 flags, struct ice_esw_br_port *port)
 {
+	struct device *dev = ice_pf_to_dev(port->vsi->back);
 	struct ice_esw_br_vlan *vlan;
 	int err;
 
@@ -639,14 +697,29 @@ ice_eswitch_br_vlan_create(u16 vid, u16 flags, struct ice_esw_br_port *port)
 
 	vlan->vid = vid;
 	vlan->flags = flags;
+	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
+	    (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
+		err = ice_eswitch_br_set_pvid(port, vlan);
+		if (err)
+			goto err_set_pvid;
+	} else if ((flags & BRIDGE_VLAN_INFO_PVID) ||
+		   (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
+		dev_info(dev, "VLAN push and pop are supported only simultaneously\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
 
 	err = xa_insert(&port->vlans, vlan->vid, vlan, GFP_KERNEL);
-	if (err) {
-		kfree(vlan);
-		return ERR_PTR(err);
-	}
+	if (err)
+		goto err_insert;
 
 	return vlan;
+
+err_insert:
+	if (port->pvid)
+		ice_eswitch_br_clear_pvid(port);
+err_set_pvid:
+	kfree(vlan);
+	return ERR_PTR(err);
 }
 
 static int
@@ -660,6 +733,13 @@ ice_eswitch_br_port_vlan_add(struct ice_esw_br *bridge, u16 vsi_idx, u16 vid,
 	if (!port)
 		return -EINVAL;
 
+	if (port->pvid) {
+		dev_info(ice_pf_to_dev(port->vsi->back),
+			 "Port VLAN (vsi=%u, vid=%d) exists on the port, remove it to add trunk VLANs\n",
+			 port->vsi_idx, port->pvid);
+		return -EEXIST;
+	}
+
 	vlan = xa_load(&port->vlans, vid);
 	if (vlan) {
 		if (vlan->flags == flags)
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
index cf3e2615a62a..b6eef068ea81 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
@@ -43,6 +43,7 @@ struct ice_esw_br_port {
 	struct ice_vsi *vsi;
 	u16 vsi_idx;
 	struct xarray vlans;
+	u16 pvid;
 };
 
 enum {
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index b1ffb81893d4..447b4e6ef7e4 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -21,6 +21,108 @@ noop_vlan(struct ice_vsi __always_unused *vsi)
 	return 0;
 }
 
+static void ice_port_vlan_on(struct ice_vsi *vsi)
+{
+	struct ice_vsi_vlan_ops *vlan_ops;
+	struct ice_pf *pf = vsi->back;
+
+	if (ice_is_dvm_ena(&pf->hw)) {
+		vlan_ops = &vsi->outer_vlan_ops;
+
+		/* setup outer VLAN ops */
+		vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
+		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
+		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
+		vlan_ops->ena_rx_filtering =
+			ice_vsi_ena_rx_vlan_filtering;
+
+		/* setup inner VLAN ops */
+		vlan_ops = &vsi->inner_vlan_ops;
+		vlan_ops->add_vlan = noop_vlan_arg;
+		vlan_ops->del_vlan = noop_vlan_arg;
+		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
+		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
+		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
+		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
+	} else {
+		vlan_ops = &vsi->inner_vlan_ops;
+
+		vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
+		vlan_ops->clear_port_vlan = ice_vsi_clear_inner_port_vlan;
+		vlan_ops->clear_port_vlan = ice_vsi_clear_inner_port_vlan;
+		vlan_ops->ena_rx_filtering =
+			ice_vsi_ena_rx_vlan_filtering;
+	}
+}
+
+static void ice_port_vlan_off(struct ice_vsi *vsi)
+{
+	struct ice_vsi_vlan_ops *vlan_ops;
+	struct ice_pf *pf = vsi->back;
+
+	if (ice_is_dvm_ena(&pf->hw)) {
+		/* setup inner VLAN ops */
+		vlan_ops = &vsi->inner_vlan_ops;
+
+		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
+		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
+		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
+		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
+
+		vlan_ops = &vsi->outer_vlan_ops;
+
+		vlan_ops->del_vlan = ice_vsi_del_vlan;
+		vlan_ops->ena_stripping = ice_vsi_ena_outer_stripping;
+		vlan_ops->dis_stripping = ice_vsi_dis_outer_stripping;
+		vlan_ops->ena_insertion = ice_vsi_ena_outer_insertion;
+		vlan_ops->dis_insertion = ice_vsi_dis_outer_insertion;
+	} else {
+		vlan_ops = &vsi->inner_vlan_ops;
+
+		vlan_ops->del_vlan = ice_vsi_del_vlan;
+		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
+		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
+		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
+		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
+	}
+
+	if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
+		vlan_ops->ena_rx_filtering = noop_vlan;
+	else
+		vlan_ops->ena_rx_filtering =
+			ice_vsi_ena_rx_vlan_filtering;
+}
+
+/**
+ * ice_vf_vsi_enable_port_vlan - Set VSI VLAN ops to support port VLAN
+ * @vsi: VF's VSI being configured
+ *
+ * The function won't create port VLAN, it only allows to create port VLAN
+ * using VLAN ops on the VF VSI.
+ */
+void ice_vf_vsi_enable_port_vlan(struct ice_vsi *vsi)
+{
+	if (WARN_ON(!vsi->vf))
+		return;
+
+	ice_port_vlan_on(vsi);
+}
+
+/**
+ * ice_vf_vsi_disable_port_vlan - Clear VSI support for creating port VLAN
+ * @vsi: VF's VSI being configured
+ *
+ * The function should be called after removing port VLAN on VSI
+ * (using VLAN ops)
+ */
+void ice_vf_vsi_disable_port_vlan(struct ice_vsi *vsi)
+{
+	if (WARN_ON(!vsi->vf))
+		return;
+
+	ice_port_vlan_off(vsi);
+}
+
 /**
  * ice_vf_vsi_init_vlan_ops - Initialize default VSI VLAN ops for VF VSI
  * @vsi: VF's VSI being configured
@@ -39,91 +141,18 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 	if (WARN_ON(!vf))
 		return;
 
-	if (ice_is_dvm_ena(&pf->hw)) {
-		vlan_ops = &vsi->outer_vlan_ops;
+	if (ice_vf_is_port_vlan_ena(vf))
+		ice_port_vlan_on(vsi);
+	else
+		ice_port_vlan_off(vsi);
 
-		/* outer VLAN ops regardless of port VLAN config */
-		vlan_ops->add_vlan = ice_vsi_add_vlan;
-		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
-		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
-
-		if (ice_vf_is_port_vlan_ena(vf)) {
-			/* setup outer VLAN ops */
-			vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
-			/* all Rx traffic should be in the domain of the
-			 * assigned port VLAN, so prevent disabling Rx VLAN
-			 * filtering
-			 */
-			vlan_ops->dis_rx_filtering = noop_vlan;
-			vlan_ops->ena_rx_filtering =
-				ice_vsi_ena_rx_vlan_filtering;
-
-			/* setup inner VLAN ops */
-			vlan_ops = &vsi->inner_vlan_ops;
-			vlan_ops->add_vlan = noop_vlan_arg;
-			vlan_ops->del_vlan = noop_vlan_arg;
-			vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
-			vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
-			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
-			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
-		} else {
-			vlan_ops->dis_rx_filtering =
-				ice_vsi_dis_rx_vlan_filtering;
-
-			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
-				vlan_ops->ena_rx_filtering = noop_vlan;
-			else
-				vlan_ops->ena_rx_filtering =
-					ice_vsi_ena_rx_vlan_filtering;
-
-			vlan_ops->del_vlan = ice_vsi_del_vlan;
-			vlan_ops->ena_stripping = ice_vsi_ena_outer_stripping;
-			vlan_ops->dis_stripping = ice_vsi_dis_outer_stripping;
-			vlan_ops->ena_insertion = ice_vsi_ena_outer_insertion;
-			vlan_ops->dis_insertion = ice_vsi_dis_outer_insertion;
-
-			/* setup inner VLAN ops */
-			vlan_ops = &vsi->inner_vlan_ops;
-
-			vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
-			vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
-			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
-			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
-		}
-	} else {
-		vlan_ops = &vsi->inner_vlan_ops;
+	vlan_ops = ice_is_dvm_ena(&pf->hw) ?
+		&vsi->outer_vlan_ops : &vsi->inner_vlan_ops;
 
-		/* inner VLAN ops regardless of port VLAN config */
-		vlan_ops->add_vlan = ice_vsi_add_vlan;
-		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
-		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
-		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
-
-		if (ice_vf_is_port_vlan_ena(vf)) {
-			vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
-			vlan_ops->ena_rx_filtering =
-				ice_vsi_ena_rx_vlan_filtering;
-			/* all Rx traffic should be in the domain of the
-			 * assigned port VLAN, so prevent disabling Rx VLAN
-			 * filtering
-			 */
-			vlan_ops->dis_rx_filtering = noop_vlan;
-		} else {
-			vlan_ops->dis_rx_filtering =
-				ice_vsi_dis_rx_vlan_filtering;
-			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
-				vlan_ops->ena_rx_filtering = noop_vlan;
-			else
-				vlan_ops->ena_rx_filtering =
-					ice_vsi_ena_rx_vlan_filtering;
-
-			vlan_ops->del_vlan = ice_vsi_del_vlan;
-			vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
-			vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
-			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
-			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
-		}
-	}
+	vlan_ops->add_vlan = ice_vsi_add_vlan;
+	vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
+	vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
+	vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h
index 875a4e615f39..845330b49608 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h
@@ -11,6 +11,9 @@ struct ice_vsi;
 void ice_vf_vsi_cfg_dvm_legacy_vlan_mode(struct ice_vsi *vsi);
 void ice_vf_vsi_cfg_svm_legacy_vlan_mode(struct ice_vsi *vsi);
 
+void ice_vf_vsi_enable_port_vlan(struct ice_vsi *vsi);
+void ice_vf_vsi_disable_port_vlan(struct ice_vsi *vsi);
+
 #ifdef CONFIG_PCI_IOV
 void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi);
 #else
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 5b4a0abb4607..d4ce3c50672f 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -202,6 +202,24 @@ int ice_vsi_dis_inner_insertion(struct ice_vsi *vsi)
 	return ice_vsi_manage_vlan_insertion(vsi);
 }
 
+static void
+ice_save_vlan_info(struct ice_aqc_vsi_props *info,
+		   struct ice_vsi_vlan_info *vlan)
+{
+	vlan->sw_flags2 = info->sw_flags2;
+	vlan->inner_vlan_flags = info->inner_vlan_flags;
+	vlan->outer_vlan_flags = info->outer_vlan_flags;
+}
+
+static void
+ice_restore_vlan_info(struct ice_aqc_vsi_props *info,
+		      struct ice_vsi_vlan_info *vlan)
+{
+	info->sw_flags2 = vlan->sw_flags2;
+	info->inner_vlan_flags = vlan->inner_vlan_flags;
+	info->outer_vlan_flags = vlan->outer_vlan_flags;
+}
+
 /**
  * __ice_vsi_set_inner_port_vlan - set port VLAN VSI context settings to enable a port VLAN
  * @vsi: the VSI to update
@@ -218,6 +236,7 @@ static int __ice_vsi_set_inner_port_vlan(struct ice_vsi *vsi, u16 pvid_info)
 	if (!ctxt)
 		return -ENOMEM;
 
+	ice_save_vlan_info(&vsi->info, &vsi->vlan_info);
 	ctxt->info = vsi->info;
 	info = &ctxt->info;
 	info->inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_TX_MODE_ACCEPTUNTAGGED |
@@ -259,6 +278,33 @@ int ice_vsi_set_inner_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 	return __ice_vsi_set_inner_port_vlan(vsi, port_vlan_info);
 }
 
+int ice_vsi_clear_inner_port_vlan(struct ice_vsi *vsi)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_aqc_vsi_props *info;
+	struct ice_vsi_ctx *ctxt;
+	int ret;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ice_restore_vlan_info(&vsi->info, &vsi->vlan_info);
+	vsi->info.port_based_inner_vlan = 0;
+	ctxt->info = vsi->info;
+	info = &ctxt->info;
+	info->valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
+					   ICE_AQ_VSI_PROP_SW_VALID);
+
+	ret = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (ret)
+		dev_info(ice_hw_to_dev(hw), "update VSI for port VLAN failed, err %d aq_err %s\n",
+			 ret, ice_aq_str(hw->adminq.sq_last_status));
+
+	kfree(ctxt);
+	return ret;
+}
+
 /**
  * ice_cfg_vlan_pruning - enable or disable VLAN pruning on the VSI
  * @vsi: VSI to enable or disable VLAN pruning on
@@ -647,6 +693,7 @@ __ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, u16 vlan_info, u16 tpid)
 	if (!ctxt)
 		return -ENOMEM;
 
+	ice_save_vlan_info(&vsi->info, &vsi->vlan_info);
 	ctxt->info = vsi->info;
 
 	ctxt->info.sw_flags2 |= ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
@@ -689,9 +736,6 @@ __ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, u16 vlan_info, u16 tpid)
  * used if DVM is supported. Also, this function should never be called directly
  * as it should be part of ice_vsi_vlan_ops if it's needed.
  *
- * This function does not support clearing the port VLAN as there is currently
- * no use case for this.
- *
  * Use the ice_vlan structure passed in to set this VSI in a port VLAN.
  */
 int ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
@@ -705,3 +749,37 @@ int ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 
 	return __ice_vsi_set_outer_port_vlan(vsi, port_vlan_info, vlan->tpid);
 }
+
+/**
+ * ice_vsi_clear_outer_port_vlan - clear outer port vlan
+ * @vsi: VSI to configure
+ *
+ * The function is restoring previously set vlan config (saved in
+ * vsi->vlan_info). Setting happens in port vlan configuration.
+ */
+int ice_vsi_clear_outer_port_vlan(struct ice_vsi *vsi)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_vsi_ctx *ctxt;
+	int err;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ice_restore_vlan_info(&vsi->info, &vsi->vlan_info);
+	vsi->info.port_based_outer_vlan = 0;
+	ctxt->info = vsi->info;
+
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_OUTER_TAG_VALID |
+			    ICE_AQ_VSI_PROP_SW_VALID);
+
+	err = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for clearing outer port based VLAN failed, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+
+	kfree(ctxt);
+	return err;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
index f459909490ec..f0d84d11bd5b 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
@@ -7,6 +7,12 @@
 #include <linux/types.h>
 #include "ice_vlan.h"
 
+struct ice_vsi_vlan_info {
+	u8 sw_flags2;
+	u8 inner_vlan_flags;
+	u8 outer_vlan_flags;
+};
+
 struct ice_vsi;
 
 int ice_vsi_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
@@ -17,6 +23,7 @@ int ice_vsi_dis_inner_stripping(struct ice_vsi *vsi);
 int ice_vsi_ena_inner_insertion(struct ice_vsi *vsi, u16 tpid);
 int ice_vsi_dis_inner_insertion(struct ice_vsi *vsi);
 int ice_vsi_set_inner_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
+int ice_vsi_clear_inner_port_vlan(struct ice_vsi *vsi);
 
 int ice_vsi_ena_rx_vlan_filtering(struct ice_vsi *vsi);
 int ice_vsi_dis_rx_vlan_filtering(struct ice_vsi *vsi);
@@ -28,5 +35,6 @@ int ice_vsi_dis_outer_stripping(struct ice_vsi *vsi);
 int ice_vsi_ena_outer_insertion(struct ice_vsi *vsi, u16 tpid);
 int ice_vsi_dis_outer_insertion(struct ice_vsi *vsi);
 int ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
+int ice_vsi_clear_outer_port_vlan(struct ice_vsi *vsi);
 
 #endif /* _ICE_VSI_VLAN_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
index 5b47568f6256..b2d2330dedcb 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
@@ -21,6 +21,7 @@ struct ice_vsi_vlan_ops {
 	int (*ena_tx_filtering)(struct ice_vsi *vsi);
 	int (*dis_tx_filtering)(struct ice_vsi *vsi);
 	int (*set_port_vlan)(struct ice_vsi *vsi, struct ice_vlan *vlan);
+	int (*clear_port_vlan)(struct ice_vsi *vsi);
 };
 
 void ice_vsi_init_vlan_ops(struct ice_vsi *vsi);
-- 
2.39.2

