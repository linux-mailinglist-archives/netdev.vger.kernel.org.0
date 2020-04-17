Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B361AE355
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgDQRKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:10:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:24557 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729255AbgDQRKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:10:47 -0400
IronPort-SDR: 7Gj98a2rX+q4BazJszEN21cgfZC/BA5Fu/AeEkb0nhY2/gr2EkI6vzNz4JBZi2dATkJjm+dh+/
 DMtiSzKj8Krg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:10:41 -0700
IronPort-SDR: dn3YBuvp7MCbDDP2qxvKhLJ0NDfNVy1MTBEAPyJ4gQm0iJeI2Lr0Ve26KxCXZ2o9BzfaKps2JV
 8VEldHsdmHUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="278442169"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 17 Apr 2020 10:10:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 6/9] ice: Allow reset operations
Date:   Fri, 17 Apr 2020 10:10:31 -0700
Message-Id: <20200417171034.1533253-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Enable the PF to notify peers when it's going to reset so that peer devices
can prepare accordingly. Also enable the peer devices to request the PF to
reset.

Implement ice_peer_is_vsi_ready() so the peer device can determine when the
VSI is ready for operations following a reset.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_idc.c     | 140 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c     |   6 +
 drivers/net/ethernet/intel/ice/ice_main.c    |   3 +
 4 files changed, 150 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 9995112e0bda..5e1877772245 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -217,6 +217,40 @@ int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data)
 	return 0;
 }
 
+/**
+ * ice_close_peer_for_reset - queue work to close peer for reset
+ * @peer_dev_int: pointer peer dev internal struct
+ * @data: pointer to opaque data used for reset type
+ */
+int ice_close_peer_for_reset(struct ice_peer_dev_int *peer_dev_int, void *data)
+{
+	struct iidc_peer_dev *peer_dev;
+	enum ice_reset_req reset;
+
+	peer_dev = &peer_dev_int->peer_dev;
+	if (!ice_validate_peer_dev(peer_dev))
+		return 0;
+
+	reset = *(enum ice_reset_req *)data;
+
+	switch (reset) {
+	case ICE_RESET_GLOBR:
+		peer_dev_int->rst_type = IIDC_REASON_GLOBR_REQ;
+		break;
+	case ICE_RESET_CORER:
+		peer_dev_int->rst_type = IIDC_REASON_CORER_REQ;
+		break;
+	case ICE_RESET_PFR:
+		peer_dev_int->rst_type = IIDC_REASON_PFR_REQ;
+		break;
+	default:
+		/* reset type is invalid */
+		return 1;
+	}
+	queue_work(peer_dev_int->ice_peer_wq, &peer_dev_int->peer_close_task);
+	return 0;
+}
+
 /**
  * ice_check_peer_drv_for_events - check peer_drv for events to report
  * @peer_dev: peer device to report to
@@ -929,6 +963,74 @@ static int ice_peer_register(struct iidc_peer_dev *peer_dev)
 	return 0;
 }
 
+/**
+ * ice_peer_request_reset - accept request from peer to perform a reset
+ * @peer_dev: peer device that is request a reset
+ * @reset_type: type of reset the peer is requesting
+ */
+static int
+ice_peer_request_reset(struct iidc_peer_dev *peer_dev,
+		       enum iidc_peer_reset_type reset_type)
+{
+	enum ice_reset_req reset;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_dev(peer_dev))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+
+	switch (reset_type) {
+	case IIDC_PEER_PFR:
+		reset = ICE_RESET_PFR;
+		break;
+	case IIDC_PEER_CORER:
+		reset = ICE_RESET_CORER;
+		break;
+	case IIDC_PEER_GLOBR:
+		reset = ICE_RESET_GLOBR;
+		break;
+	default:
+		dev_err(ice_pf_to_dev(pf), "incorrect reset request from peer\n");
+		return -EINVAL;
+	}
+
+	return ice_schedule_reset(pf, reset);
+}
+
+/**
+ * ice_peer_is_vsi_ready - query if VSI in nominal state
+ * @peer_dev: pointer to iidc_peer_dev struct
+ */
+static int ice_peer_is_vsi_ready(struct iidc_peer_dev *peer_dev)
+{
+	DECLARE_BITMAP(check_bits, __ICE_STATE_NBITS) = { 0 };
+	struct ice_netdev_priv *np;
+	struct ice_vsi *vsi;
+
+	/* If the peer_dev or associated values are not valid, then return
+	 * 0 as there is no ready port associated with the values passed in
+	 * as parameters.
+	 */
+
+	if (!ice_validate_peer_dev(peer_dev))
+		return 0;
+
+	if (!peer_dev->netdev)
+		return 0;
+
+	np = netdev_priv(peer_dev->netdev);
+	vsi = np->vsi;
+	if (!vsi)
+		return 0;
+
+	bitmap_set(check_bits, 0, __ICE_STATE_NOMINAL_CHECK_BITS);
+	if (bitmap_intersects(vsi->state, check_bits, __ICE_STATE_NBITS))
+		return 0;
+
+	return 1;
+}
+
 /**
  * ice_peer_update_vsi_filter - update main VSI filters for RDMA
  * @peer_dev: pointer to RDMA peer device
@@ -972,9 +1074,11 @@ ice_peer_update_vsi_filter(struct iidc_peer_dev *peer_dev,
 static const struct iidc_ops ops = {
 	.alloc_res			= ice_peer_alloc_res,
 	.free_res			= ice_peer_free_res,
+	.is_vsi_ready			= ice_peer_is_vsi_ready,
 	.reg_for_notification		= ice_peer_reg_for_notif,
 	.unreg_for_notification		= ice_peer_unreg_for_notif,
 	.notify_state_change		= ice_peer_report_state_change,
+	.request_reset			= ice_peer_request_reset,
 	.peer_register			= ice_peer_register,
 	.peer_unregister		= ice_peer_unregister,
 	.update_vsi_filter		= ice_peer_update_vsi_filter,
@@ -999,6 +1103,41 @@ static int ice_reserve_peer_qvector(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_peer_close_task - call peer's close asynchronously
+ * @work: pointer to work_struct contained by the peer_dev_int struct
+ *
+ * This method (asynchronous) of calling a peer's close function is
+ * meant to be used in the reset path.
+ */
+static void ice_peer_close_task(struct work_struct *work)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct iidc_peer_dev *peer_dev;
+
+	peer_dev_int = container_of(work, struct ice_peer_dev_int,
+				    peer_close_task);
+
+	peer_dev = &peer_dev_int->peer_dev;
+	if (!peer_dev || !peer_dev->peer_ops)
+		return;
+
+	/* If this peer_dev is going to close, we do not want any state changes
+	 * to happen until after we successfully finish or abort the close.
+	 * Grab the peer_dev_state_mutex to protect this flow
+	 */
+	mutex_lock(&peer_dev_int->peer_dev_state_mutex);
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSING, true);
+
+	if (peer_dev->peer_ops->close)
+		peer_dev->peer_ops->close(peer_dev, peer_dev_int->rst_type);
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSED, true);
+
+	mutex_unlock(&peer_dev_int->peer_dev_state_mutex);
+}
+
 /**
  * ice_peer_vdev_release - function to map to virtbus_devices release callback
  * @vdev: pointer to virtbus_device to free
@@ -1097,6 +1236,7 @@ int ice_init_peer_devices(struct ice_pf *pf)
 			kfree(vbo);
 			return -ENOMEM;
 		}
+		INIT_WORK(&peer_dev_int->peer_close_task, ice_peer_close_task);
 
 		peer_dev->pdev = pdev;
 		qos_info = &peer_dev->initial_qos_info;
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
index 1d3d5cafc977..90e165434aea 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc_int.h
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -63,6 +63,7 @@ struct ice_peer_dev_int {
 };
 
 int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_close_peer_for_reset(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_peer_close(struct ice_peer_dev_int *peer_dev_int, void *data);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5043d5ed1b2a..34b41b1039f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2416,6 +2416,12 @@ void ice_vsi_close(struct ice_vsi *vsi)
 {
 	enum iidc_close_reason reason = IIDC_REASON_INTERFACE_DOWN;
 
+	if (test_bit(__ICE_CORER_REQ, vsi->back->state))
+		reason = IIDC_REASON_CORER_REQ;
+	if (test_bit(__ICE_GLOBR_REQ, vsi->back->state))
+		reason = IIDC_REASON_GLOBR_REQ;
+	if (test_bit(__ICE_PFR_REQ, vsi->back->state))
+		reason = IIDC_REASON_PFR_REQ;
 	if (!ice_is_safe_mode(vsi->back) && vsi->type == ICE_VSI_PF) {
 		int ret = ice_for_each_peer(vsi->back, &reason, ice_peer_close);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0649b951d693..09ec3ec4b7c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -559,6 +559,9 @@ static void ice_reset_subtask(struct ice_pf *pf)
 		/* return if no valid reset type requested */
 		if (reset_type == ICE_RESET_INVAL)
 			return;
+		if (ice_is_peer_ena(pf))
+			ice_for_each_peer(pf, &reset_type,
+					  ice_close_peer_for_reset);
 		ice_prepare_for_reset(pf);
 
 		/* make sure we are ready to rebuild */
-- 
2.25.2

