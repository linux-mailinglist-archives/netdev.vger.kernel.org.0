Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A7B15B0C0
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgBLTPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:15:30 -0500
Received: from mga07.intel.com ([134.134.136.100]:19425 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgBLTO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 14:14:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 11:14:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="237806991"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 12 Feb 2020 11:14:26 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RFC PATCH v4 05/25] ice: Enable event notifications
Date:   Wed, 12 Feb 2020 11:14:04 -0800
Message-Id: <20200212191424.1715577-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Enable registration of notifications. Peer devices can register to be
notified of certain events as well as notify the driver of its state
changes.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  34 +++
 drivers/net/ethernet/intel/ice/ice_idc.c     | 221 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c    |  27 ++-
 4 files changed, 277 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index b0b957e22bf3..9401f2051293 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -148,6 +148,27 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_peer_prep_tc_change - Pre-notify RDMA Peer in blocking call of TC change
+ * @peer_dev_int: ptr to peer device internal struct
+ * @data: ptr to opaque data
+ */
+static int
+ice_peer_prep_tc_change(struct ice_peer_dev_int *peer_dev_int,
+			void __always_unused *data)
+{
+	struct iidc_peer_dev *peer_dev;
+
+	peer_dev = &peer_dev_int->peer_dev;
+	if (!ice_validate_peer_dev(peer_dev))
+		return 0;
+
+	if (peer_dev->peer_ops && peer_dev->peer_ops->prep_tc_change)
+		peer_dev->peer_ops->prep_tc_change(peer_dev);
+
+	return 0;
+}
+
 /**
  * ice_pf_dcb_cfg - Apply new DCB configuration
  * @pf: pointer to the PF struct
@@ -182,6 +203,9 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		return ret;
 	}
 
+	/* Notify capable peers about impending change to TCs */
+	ice_for_each_peer(pf, NULL, ice_peer_prep_tc_change);
+
 	/* Store old config in case FW config fails */
 	old_cfg = kmemdup(curr_cfg, sizeof(*old_cfg), GFP_KERNEL);
 	if (!old_cfg)
@@ -542,6 +566,7 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 void ice_pf_dcb_recfg(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
+	struct iidc_event *event;
 	u8 tc_map = 0;
 	int v, ret;
 
@@ -577,6 +602,15 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return;
+
+	set_bit(IIDC_EVENT_TC_CHANGE, event->type);
+	event->reporter = NULL;
+	ice_setup_dcb_qos_info(pf, &event->info.port_qos);
+	ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+	kfree(event);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 92bf499bbf35..ff3dc452d7d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -217,6 +217,72 @@ int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data)
 	return 0;
 }
 
+/**
+ * ice_check_peer_drv_for_events - check peer_drv for events to report
+ * @peer_dev: peer device to report to
+ */
+static void ice_check_peer_drv_for_events(struct iidc_peer_dev *peer_dev)
+{
+	const struct iidc_peer_ops *p_ops = peer_dev->peer_ops;
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv_int *peer_drv_int;
+	int i;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return;
+	peer_drv_int = peer_dev_int->peer_drv_int;
+
+	for_each_set_bit(i, peer_dev_int->events, IIDC_EVENT_NBITS) {
+		struct iidc_event *curr = &peer_drv_int->current_events[i];
+
+		if (!bitmap_empty(curr->type, IIDC_EVENT_NBITS) &&
+		    p_ops->event_handler)
+			p_ops->event_handler(peer_dev, curr);
+	}
+}
+
+/**
+ * ice_check_peer_for_events - check peer_devs for events new peer reg'd for
+ * @src_peer_int: peer to check for events
+ * @data: ptr to opaque data, to be used for the peer struct that opened
+ *
+ * This function is to be called when a peer device is opened.
+ *
+ * Since a new peer opening would have missed any events that would
+ * have happened before its opening, we need to walk the peers and see
+ * if any of them have events that the new peer cares about
+ *
+ * This function is meant to be called by a device_for_each_child.
+ */
+static int
+ice_check_peer_for_events(struct ice_peer_dev_int *src_peer_int, void *data)
+{
+	struct iidc_peer_dev *new_peer = (struct iidc_peer_dev *)data;
+	const struct iidc_peer_ops *p_ops = new_peer->peer_ops;
+	struct ice_peer_dev_int *new_peer_int;
+	struct iidc_peer_dev *src_peer;
+	int i;
+
+	src_peer = &src_peer_int->peer_dev;
+	if (!ice_validate_peer_dev(new_peer) ||
+	    !ice_validate_peer_dev(src_peer))
+		return 0;
+
+	new_peer_int = peer_to_ice_dev_int(new_peer);
+
+	for_each_set_bit(i, new_peer_int->events, IIDC_EVENT_NBITS) {
+		struct iidc_event *curr = &src_peer_int->current_events[i];
+
+		if (!bitmap_empty(curr->type, IIDC_EVENT_NBITS) &&
+		    new_peer->peer_dev_id != src_peer->peer_dev_id &&
+		    p_ops->event_handler)
+			p_ops->event_handler(new_peer, curr);
+	}
+
+	return 0;
+}
+
 /**
  * ice_for_each_peer - iterate across and call function for each peer dev
  * @pf: pointer to private board struct
@@ -322,6 +388,9 @@ ice_finish_init_peer_device(struct ice_peer_dev_int *peer_dev_int,
 
 		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_OPENED,
 				      true);
+		ret = ice_for_each_peer(pf, peer_dev,
+					ice_check_peer_for_events);
+		ice_check_peer_drv_for_events(peer_dev);
 	}
 
 init_unlock:
@@ -654,6 +723,155 @@ ice_peer_free_res(struct iidc_peer_dev *peer_dev, struct iidc_res *res)
 	return ret;
 }
 
+/**
+ * ice_peer_reg_for_notif - register a peer to receive specific notifications
+ * @peer_dev: peer that is registering for event notifications
+ * @events: mask of event types peer is registering for
+ */
+static void
+ice_peer_reg_for_notif(struct iidc_peer_dev *peer_dev,
+		       struct iidc_event *events)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_dev(peer_dev) || !events)
+		return;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	pf = pci_get_drvdata(peer_dev->pdev);
+
+	bitmap_or(peer_dev_int->events, peer_dev_int->events, events->type,
+		  IIDC_EVENT_NBITS);
+
+	/* Check to see if any events happened previous to peer registering */
+	ice_for_each_peer(pf, peer_dev, ice_check_peer_for_events);
+	ice_check_peer_drv_for_events(peer_dev);
+}
+
+/**
+ * ice_peer_unreg_for_notif - unreg a peer from receiving certain notifications
+ * @peer_dev: peer that is unregistering from event notifications
+ * @events: mask of event types peer is unregistering for
+ */
+static void
+ice_peer_unreg_for_notif(struct iidc_peer_dev *peer_dev,
+			 struct iidc_event *events)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+
+	if (!ice_validate_peer_dev(peer_dev) || !events)
+		return;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+
+	bitmap_andnot(peer_dev_int->events, peer_dev_int->events, events->type,
+		      IIDC_EVENT_NBITS);
+}
+
+/**
+ * ice_peer_check_for_reg - check to see if any peers are reg'd for event
+ * @peer_dev_int: ptr to peer device internal struct
+ * @data: ptr to opaque data, to be used for ice_event to report
+ *
+ * This function is to be called by device_for_each_child to handle an
+ * event reported by a peer or the ice driver.
+ */
+int ice_peer_check_for_reg(struct ice_peer_dev_int *peer_dev_int, void *data)
+{
+	struct iidc_event *event = (struct iidc_event *)data;
+	DECLARE_BITMAP(comp_events, IIDC_EVENT_NBITS);
+	struct iidc_peer_dev *peer_dev;
+	bool check = true;
+
+	peer_dev = &peer_dev_int->peer_dev;
+
+	if (!ice_validate_peer_dev(peer_dev) || !data)
+	/* If invalid dev, in this case return 0 instead of error
+	 * because caller ignores this return value
+	 */
+		return 0;
+
+	if (event->reporter)
+		check = event->reporter->peer_dev_id != peer_dev->peer_dev_id;
+
+	if (bitmap_and(comp_events, event->type, peer_dev_int->events,
+		       IIDC_EVENT_NBITS) &&
+	    (test_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev_int->state) ||
+	     test_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev_int->state) ||
+	     test_bit(ICE_PEER_DEV_STATE_PREPPED, peer_dev_int->state)) &&
+	    check &&
+	    peer_dev->peer_ops->event_handler)
+		peer_dev->peer_ops->event_handler(peer_dev, event);
+
+	return 0;
+}
+
+/**
+ * ice_peer_report_state_change - accept report of a peer state change
+ * @peer_dev: peer that is sending notification about state change
+ * @event: ice_event holding info on what the state change is
+ *
+ * We also need to parse the list of peers to see if anyone is registered
+ * for notifications about this state change event, and if so, notify them.
+ */
+static void
+ice_peer_report_state_change(struct iidc_peer_dev *peer_dev,
+			     struct iidc_event *event)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv_int *peer_drv_int;
+	int e_type, drv_event = 0;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_dev(peer_dev) || !event)
+		return;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	peer_drv_int = peer_dev_int->peer_drv_int;
+
+	e_type = find_first_bit(event->type, IIDC_EVENT_NBITS);
+	if (!e_type)
+		return;
+
+	switch (e_type) {
+	/* Check for peer_drv events */
+	case IIDC_EVENT_MBX_CHANGE:
+		drv_event = 1;
+		if (event->info.mbx_rdy)
+			set_bit(ICE_PEER_DRV_STATE_MBX_RDY,
+				peer_drv_int->state);
+		else
+			clear_bit(ICE_PEER_DRV_STATE_MBX_RDY,
+				  peer_drv_int->state);
+		break;
+
+	/* Check for peer_dev events */
+	case IIDC_EVENT_API_CHANGE:
+		if (event->info.api_rdy)
+			set_bit(ICE_PEER_DEV_STATE_API_RDY,
+				peer_dev_int->state);
+		else
+			clear_bit(ICE_PEER_DEV_STATE_API_RDY,
+				  peer_dev_int->state);
+		break;
+
+	default:
+		return;
+	}
+
+	/* store the event and state to notify any new peers opening */
+	if (drv_event)
+		memcpy(&peer_drv_int->current_events[e_type], event,
+		       sizeof(*event));
+	else
+		memcpy(&peer_dev_int->current_events[e_type], event,
+		       sizeof(*event));
+
+	ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+}
+
 /**
  * ice_peer_unregister - request to unregister peer
  * @peer_dev: peer device
@@ -779,6 +997,9 @@ ice_peer_update_vsi_filter(struct iidc_peer_dev *peer_dev,
 static const struct iidc_ops ops = {
 	.alloc_res			= ice_peer_alloc_res,
 	.free_res			= ice_peer_free_res,
+	.reg_for_notification		= ice_peer_reg_for_notif,
+	.unreg_for_notification		= ice_peer_unreg_for_notif,
+	.notify_state_change		= ice_peer_report_state_change,
 	.peer_register			= ice_peer_register,
 	.peer_unregister		= ice_peer_unregister,
 	.update_vsi_filter		= ice_peer_update_vsi_filter,
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
index d22e6f5bb50e..1d3d5cafc977 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc_int.h
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -66,6 +66,7 @@ int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_peer_close(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_peer_check_for_reg(struct ice_peer_dev_int *peer_dev_int, void *data);
 int
 ice_finish_init_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e67969ae1327..b085a3e66b4f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4852,7 +4852,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct iidc_event *event;
 	u8 count = 0;
+	int err = 0;
 
 	if (new_mtu == netdev->mtu) {
 		netdev_warn(netdev, "MTU is already %u\n", netdev->mtu);
@@ -4894,27 +4896,40 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
 	netdev->mtu = new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
 	if (!test_and_set_bit(__ICE_DOWN, vsi->state)) {
-		int err;
-
 		err = ice_down(vsi);
 		if (err) {
-			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			return err;
+			netdev_err(netdev, "change MTU if_down err %d\n", err);
+			goto free_event;
 		}
 
 		err = ice_up(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			return err;
+			goto free_event;
 		}
 	}
 
+	if (ice_is_safe_mode(pf))
+		goto out;
+
+	set_bit(IIDC_EVENT_MTU_CHANGE, event->type);
+	event->reporter = NULL;
+	event->info.mtu = new_mtu;
+	ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+
+out:
 	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
-	return 0;
+free_event:
+	kfree(event);
+	return err;
 }
 
 /**
-- 
2.24.1

