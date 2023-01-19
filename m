Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B278674510
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjASVm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjASVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149F795142
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163685; x=1705699685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=euhB1ZxETxHwM1W2LGBNg6PSrl8MZjZSVSes3s6vxCE=;
  b=GU064y7JroKY8KCFG7SqZFhnGeSaAo4k7X9zF2ScfTGc/cQyzquDPWNR
   ijX70qQYPum1UCUGHw3rJ8FkN/jfzs8lN0WZWCbitqk6WSvV67LAX+BG/
   KK8nksDRvjWzgLTmyk+9lwZf1o72q26RWBAEAtHpaQEQQYzIV2SCwcmWI
   enu2g1TBY/1UrJ085BaCCqoXo8iN8Cg5GqiBlKB4EEPnTcuyqtrFfebTF
   vWsCZynxX1xCH4WC7CxEo4i1ntpY4g0G/LQHjoIlxN1SSceBqgdnU3WJt
   BllS0/zEzabUTHk7PwLiqrAnR2yRhNDN8Bl1qSOXlGPRju+YQSZG1kYON
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120599"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120599"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589871"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589871"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        lukasz.plachno@intel.com, Dave Ertman <david.m.ertman@intel.com>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net-next 02/15] ice: Handle LLDP MIB Pending change
Date:   Thu, 19 Jan 2023 13:27:29 -0800
Message-Id: <20230119212742.2106833-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

If the number of Traffic Classes (TC) is decreased, the FW will no
longer remove TC nodes, but will send a pending change notification. This
will allow RDMA to destroy corresponding Control QP markers. After RDMA
finishes outstanding operations, the ice driver will send an execute MIB
Pending change admin queue command to FW to finish DCB configuration
change.

The FW will buffer all incoming Pending changes, so there can be only
one active Pending change.

RDMA driver guarantees to remove Control QP markers within 5000 ms.
Hence, LLDP response timeout txTTL (default 30 sec) will be met.

In the case of a Pending change, LLDP MIB Change Event (opcode 0x0A01) will
contain the whole new MIB. But Get LLDP MIB (opcode 0x0A00) AQ call would
still return an old MIB, as the Pending change hasn't been applied yet.
Add ice_get_dcb_cfg_from_mib_change() function to retrieve DCBX config
from LLDP MIB Change Event's buffer for Pending changes.

Co-developed-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c     | 36 +++++++++++
 drivers/net/ethernet/intel/ice/ice_dcb.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 68 +++++++++++++++-----
 3 files changed, 91 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 22a94e05233a..776c1ff6e265 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -966,6 +966,42 @@ int ice_get_dcb_cfg(struct ice_port_info *pi)
 	return ret;
 }
 
+/**
+ * ice_get_dcb_cfg_from_mib_change
+ * @pi: port information structure
+ * @event: pointer to the admin queue receive event
+ *
+ * Set DCB configuration from received MIB Change event
+ */
+void ice_get_dcb_cfg_from_mib_change(struct ice_port_info *pi,
+				     struct ice_rq_event_info *event)
+{
+	struct ice_dcbx_cfg *dcbx_cfg = &pi->qos_cfg.local_dcbx_cfg;
+	struct ice_aqc_lldp_get_mib *mib;
+	u8 change_type, dcbx_mode;
+
+	mib = (struct ice_aqc_lldp_get_mib *)&event->desc.params.raw;
+
+	change_type = FIELD_GET(ICE_AQ_LLDP_MIB_TYPE_M,  mib->type);
+	if (change_type == ICE_AQ_LLDP_MIB_REMOTE)
+		dcbx_cfg = &pi->qos_cfg.remote_dcbx_cfg;
+
+	dcbx_mode = FIELD_GET(ICE_AQ_LLDP_DCBX_M, mib->type);
+
+	switch (dcbx_mode) {
+	case ICE_AQ_LLDP_DCBX_IEEE:
+		dcbx_cfg->dcbx_mode = ICE_DCBX_MODE_IEEE;
+		ice_lldp_to_dcb_cfg(event->msg_buf, dcbx_cfg);
+		break;
+
+	case ICE_AQ_LLDP_DCBX_CEE:
+		pi->qos_cfg.desired_dcbx_cfg = pi->qos_cfg.local_dcbx_cfg;
+		ice_cee_to_dcb_cfg((struct ice_aqc_get_cee_dcb_cfg_resp *)
+				   event->msg_buf, pi);
+		break;
+	}
+}
+
 /**
  * ice_init_dcb
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.h b/drivers/net/ethernet/intel/ice/ice_dcb.h
index 6abf28a14291..be34650a77d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.h
@@ -144,6 +144,8 @@ ice_aq_get_dcb_cfg(struct ice_hw *hw, u8 mib_type, u8 bridgetype,
 		   struct ice_dcbx_cfg *dcbcfg);
 int ice_get_dcb_cfg(struct ice_port_info *pi);
 int ice_set_dcb_cfg(struct ice_port_info *pi);
+void ice_get_dcb_cfg_from_mib_change(struct ice_port_info *pi,
+				     struct ice_rq_event_info *event);
 int ice_init_dcb(struct ice_hw *hw, bool enable_mib_change);
 int
 ice_query_port_ets(struct ice_port_info *pi,
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 4f24d441c35e..3a7e629145a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -943,6 +943,16 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring *tx_ring,
 	}
 }
 
+/**
+ * ice_dcb_is_mib_change_pending - Check if MIB change is pending
+ * @state: MIB change state
+ */
+static bool ice_dcb_is_mib_change_pending(u8 state)
+{
+	return ICE_AQ_LLDP_MIB_CHANGE_PENDING ==
+		FIELD_GET(ICE_AQ_LLDP_MIB_CHANGE_STATE_M, state);
+}
+
 /**
  * ice_dcb_process_lldp_set_mib_change - Process MIB change
  * @pf: ptr to ice_pf
@@ -956,6 +966,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_aqc_lldp_get_mib *mib;
 	struct ice_dcbx_cfg tmp_dcbx_cfg;
+	bool pending_handled = true;
 	bool need_reconfig = false;
 	struct ice_port_info *pi;
 	u8 mib_type;
@@ -972,41 +983,58 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 
 	pi = pf->hw.port_info;
 	mib = (struct ice_aqc_lldp_get_mib *)&event->desc.params.raw;
+
 	/* Ignore if event is not for Nearest Bridge */
-	mib_type = ((mib->type >> ICE_AQ_LLDP_BRID_TYPE_S) &
-		    ICE_AQ_LLDP_BRID_TYPE_M);
+	mib_type = FIELD_GET(ICE_AQ_LLDP_BRID_TYPE_M, mib->type);
 	dev_dbg(dev, "LLDP event MIB bridge type 0x%x\n", mib_type);
 	if (mib_type != ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID)
 		return;
 
+	/* A pending change event contains accurate config information, and
+	 * the FW setting has not been updaed yet, so detect if change is
+	 * pending to determine where to pull config information from
+	 * (FW vs event)
+	 */
+	if (ice_dcb_is_mib_change_pending(mib->state))
+		pending_handled = false;
+
 	/* Check MIB Type and return if event for Remote MIB update */
-	mib_type = mib->type & ICE_AQ_LLDP_MIB_TYPE_M;
+	mib_type = FIELD_GET(ICE_AQ_LLDP_MIB_TYPE_M, mib->type);
 	dev_dbg(dev, "LLDP event mib type %s\n", mib_type ? "remote" : "local");
 	if (mib_type == ICE_AQ_LLDP_MIB_REMOTE) {
 		/* Update the remote cached instance and return */
-		ret = ice_aq_get_dcb_cfg(pi->hw, ICE_AQ_LLDP_MIB_REMOTE,
-					 ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID,
-					 &pi->qos_cfg.remote_dcbx_cfg);
-		if (ret) {
-			dev_err(dev, "Failed to get remote DCB config\n");
-			return;
+		if (!pending_handled) {
+			ice_get_dcb_cfg_from_mib_change(pi, event);
+		} else {
+			ret =
+			  ice_aq_get_dcb_cfg(pi->hw, ICE_AQ_LLDP_MIB_REMOTE,
+					     ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID,
+					     &pi->qos_cfg.remote_dcbx_cfg);
+			if (ret)
+				dev_dbg(dev, "Failed to get remote DCB config\n");
 		}
+		return;
 	}
 
+	/* That a DCB change has happened is now determined */
 	mutex_lock(&pf->tc_mutex);
 
 	/* store the old configuration */
-	tmp_dcbx_cfg = pf->hw.port_info->qos_cfg.local_dcbx_cfg;
+	tmp_dcbx_cfg = pi->qos_cfg.local_dcbx_cfg;
 
 	/* Reset the old DCBX configuration data */
 	memset(&pi->qos_cfg.local_dcbx_cfg, 0,
 	       sizeof(pi->qos_cfg.local_dcbx_cfg));
 
 	/* Get updated DCBX data from firmware */
-	ret = ice_get_dcb_cfg(pf->hw.port_info);
-	if (ret) {
-		dev_err(dev, "Failed to get DCB config\n");
-		goto out;
+	if (!pending_handled) {
+		ice_get_dcb_cfg_from_mib_change(pi, event);
+	} else {
+		ret = ice_get_dcb_cfg(pi);
+		if (ret) {
+			dev_err(dev, "Failed to get DCB config\n");
+			goto out;
+		}
 	}
 
 	/* No change detected in DCBX configs */
@@ -1033,11 +1061,17 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	}
 
+	/* Send Execute Pending MIB Change event if it is a Pending event */
+	if (!pending_handled) {
+		ice_lldp_execute_pending_mib(&pf->hw);
+		pending_handled = true;
+	}
+
 	rtnl_lock();
 	/* disable VSIs affected by DCB changes */
 	ice_dcb_ena_dis_vsi(pf, false, true);
 
-	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
+	ret = ice_query_port_ets(pi, &buf, sizeof(buf), NULL);
 	if (ret) {
 		dev_err(dev, "Query Port ETS failed\n");
 		goto unlock_rtnl;
@@ -1052,4 +1086,8 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	rtnl_unlock();
 out:
 	mutex_unlock(&pf->tc_mutex);
+
+	/* Send Execute Pending MIB Change event if it is a Pending event */
+	if (!pending_handled)
+		ice_lldp_execute_pending_mib(&pf->hw);
 }
-- 
2.38.1

