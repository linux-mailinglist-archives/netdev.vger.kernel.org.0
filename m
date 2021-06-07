Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0AD39E482
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFGQxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:57113 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhFGQwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:47 -0400
IronPort-SDR: Q7Jl0Aa64DuaZGOT91k6JBHtbnqaf6jGrirEMrOW433kT1m5eZbrQ2NVW7D7gGXxN3jSmDPWLw
 dPmlsjHtE+ow==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474561"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474561"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:55 -0700
IronPort-SDR: aYBQk1+EzyptHQpbCsDEndYL5CLIHJoSyRS7dvxl0ofhqd4zE9g4+6RQWGpwZq1gw9lEn2sV95
 Zs3Zuiihrcxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841262"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 11/15] ice: wait for reset before reporting devlink info
Date:   Mon,  7 Jun 2021 09:53:21 -0700
Message-Id: <20210607165325.182087-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Requesting device firmware information while the device is busy cleaning
up after a reset can result in an unexpected failure:

This occurs because the command is attempting to access the device
AdminQ while it is down. Resolve this by having the command wait for
a while until the reset is complete. To do this, introduce
a reset_wait_queue and associated helper function "ice_wait_for_reset".

This helper will use the wait queue to sleep until the driver is done
rebuilding. Use of a wait queue is preferred because the potential sleep
duration can be several seconds.

To ensure that the thread wakes up properly, a new wake_up call is added
during all code paths which clear the reset state bits associated with
the driver rebuild flow.

Using this ensures that tools can request device information without
worrying about whether the driver is cleaning up from a reset.
Specifically, it is expected that a flash update could result in
a device reset, and it is better to delay the response for information
until the reset is complete rather than exit with an immediate failure.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  2 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c |  6 +++++
 drivers/net/ethernet/intel/ice/ice_lib.c     | 28 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c    |  5 ++++
 5 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 228055e8f33b..21f8b36df11a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -455,6 +455,8 @@ struct ice_pf {
 	struct hlist_head aq_wait_list;
 	wait_queue_head_t aq_wait_queue;
 
+	wait_queue_head_t reset_wait_queue;
+
 	u32 hw_csum_rx_error;
 	u16 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u16 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 2923591d01ea..91b545ab8b8f 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -276,6 +276,12 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	size_t i;
 	int err;
 
+	err = ice_wait_for_reset(pf, 10 * HZ);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Device is busy resetting");
+		return err;
+	}
+
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 357c5d39913d..1c636f4bb4fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3218,6 +3218,34 @@ bool ice_is_reset_in_progress(unsigned long *state)
 	       test_bit(ICE_GLOBR_REQ, state);
 }
 
+/**
+ * ice_wait_for_reset - Wait for driver to finish reset and rebuild
+ * @pf: pointer to the PF structure
+ * @timeout: length of time to wait, in jiffies
+ *
+ * Wait (sleep) for a short time until the driver finishes cleaning up from
+ * a device reset. The caller must be able to sleep. Use this to delay
+ * operations that could fail while the driver is cleaning up after a device
+ * reset.
+ *
+ * Returns 0 on success, -EBUSY if the reset is not finished within the
+ * timeout, and -ERESTARTSYS if the thread was interrupted.
+ */
+int ice_wait_for_reset(struct ice_pf *pf, unsigned long timeout)
+{
+	long ret;
+
+	ret = wait_event_interruptible_timeout(pf->reset_wait_queue,
+					       !ice_is_reset_in_progress(pf->state),
+					       timeout);
+	if (ret < 0)
+		return ret;
+	else if (!ret)
+		return -EBUSY;
+	else
+		return 0;
+}
+
 #ifdef CONFIG_DCB
 /**
  * ice_vsi_update_q_map - update our copy of the VSI info with new queue map
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 9bd619e2399a..6e2b8c2c8aa0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -77,6 +77,7 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id);
 int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
+int ice_wait_for_reset(struct ice_pf *pf, unsigned long timeout);
 
 void
 ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 254cfc14d6b4..a89ca799109f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -503,6 +503,7 @@ static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 		clear_bit(ICE_PFR_REQ, pf->state);
 		clear_bit(ICE_CORER_REQ, pf->state);
 		clear_bit(ICE_GLOBR_REQ, pf->state);
+		wake_up(&pf->reset_wait_queue);
 		return;
 	}
 
@@ -515,6 +516,7 @@ static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 		ice_rebuild(pf, reset_type);
 		clear_bit(ICE_PREPARED_FOR_RESET, pf->state);
 		clear_bit(ICE_PFR_REQ, pf->state);
+		wake_up(&pf->reset_wait_queue);
 		ice_reset_all_vfs(pf, true);
 	}
 }
@@ -565,6 +567,7 @@ static void ice_reset_subtask(struct ice_pf *pf)
 			clear_bit(ICE_PFR_REQ, pf->state);
 			clear_bit(ICE_CORER_REQ, pf->state);
 			clear_bit(ICE_GLOBR_REQ, pf->state);
+			wake_up(&pf->reset_wait_queue);
 			ice_reset_all_vfs(pf, true);
 		}
 
@@ -3343,6 +3346,8 @@ static int ice_init_pf(struct ice_pf *pf)
 	spin_lock_init(&pf->aq_wait_lock);
 	init_waitqueue_head(&pf->aq_wait_queue);
 
+	init_waitqueue_head(&pf->reset_wait_queue);
+
 	/* setup service timer and periodic service task */
 	timer_setup(&pf->serv_tmr, ice_service_timer, 0);
 	pf->serv_tmr_period = HZ;
-- 
2.26.2

