Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BD763E0EA
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiK3Tn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiK3Tno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:43:44 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173783FB81
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837424; x=1701373424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fCYfDlaZMJvAJdcmak7NoDJ2v7a1FBNg5bZpMDmkeq4=;
  b=KUIXYIbhKbY4nPuKksmwdKbuzyTd45xXiV23yYGvIkNrk3NztDvNrWpV
   n+9lTnHlOY14MiGSo4OXxwhKcMv7pAGZD8zzdQtkIzu/+KFyl9ThtlyQR
   cCh+Z52dveDLQn3iQjHCrj7rNFBHjpeXYxg4woj/bSAi0FkTy+RsernSh
   YXaNXbxQ6YKBSSgH3ww1ogVq2ShHOrebYt5FS7K4NOKES4XAViuhT3QDC
   QaVsxWzOTQfd56qljKn1j9Duuy+3B6eGeWNgooc9aYTOm78cXNMXjwp78
   ax64/npLDLnTB4hrTRBdYSBabDH8SZGMUDl8aTJmwiISQ58lXYbsF0y5y
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303098382"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303098382"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818752286"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818752286"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 11:43:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Dave Ertman <david.m.ertman@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 05/14] ice: always call ice_ptp_link_change and make it void
Date:   Wed, 30 Nov 2022 11:43:21 -0800
Message-Id: <20221130194330.3257836-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_ptp_link_change function is currently only called for E822 based
hardware. Future changes are going to extend this function to perform
additional tasks on link change.

Always call this function, moving the E810 check from the callers down to
just before we call the E822-specific function required to restart the PHY.

This function also returns an error value, but none of the callers actually
check it. In general, the errors it produces are more likely systemic
problems such as invalid or corrupt port numbers. No caller checks these,
and so no warning is logged.

Re-order the flag checks so that ICE_FLAG_PTP is checked first. Drop the
unnecessary check for ICE_FLAG_PTP_SUPPORTED, as ICE_FLAG_PTP will not be
set except when ICE_FLAG_PTP_SUPPORTED is set.

Convert the port checks to WARN_ON_ONCE, in order to generate a kernel
stack trace when they are hit.

Convert the function to void since no caller actually checks these return
values.

Co-developed-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c |  9 +++------
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 24 +++++++++++------------
 drivers/net/ethernet/intel/ice/ice_ptp.h  |  7 ++++---
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2b23b4714a26..a9a7f8b52140 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1111,8 +1111,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	if (link_up == old_link && link_speed == old_link_speed)
 		return 0;
 
-	if (!ice_is_e810(&pf->hw))
-		ice_ptp_link_change(pf, pf->hw.pf_id, link_up);
+	ice_ptp_link_change(pf, pf->hw.pf_id, link_up);
 
 	if (ice_is_dcb_active(pf)) {
 		if (test_bit(ICE_FLAG_DCB_ENA, pf->flags))
@@ -6340,8 +6339,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 		ice_print_link_msg(vsi, true);
 		netif_tx_start_all_queues(vsi->netdev);
 		netif_carrier_on(vsi->netdev);
-		if (!ice_is_e810(&pf->hw))
-			ice_ptp_link_change(pf, pf->hw.pf_id, true);
+		ice_ptp_link_change(pf, pf->hw.pf_id, true);
 	}
 
 	/* Perform an initial read of the statistics registers now to
@@ -6773,8 +6771,7 @@ int ice_down(struct ice_vsi *vsi)
 
 	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
 		vlan_err = ice_vsi_del_vlan_zero(vsi);
-		if (!ice_is_e810(&vsi->back->hw))
-			ice_ptp_link_change(vsi->back, vsi->back->hw.pf_id, false);
+		ice_ptp_link_change(vsi->back, vsi->back->hw.pf_id, false);
 		netif_carrier_off(vsi->netdev);
 		netif_tx_disable(vsi->netdev);
 	} else if (vsi->type == ICE_VSI_SWITCHDEV_CTRL) {
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 5607ec578499..1564c72189bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1328,33 +1328,33 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 }
 
 /**
- * ice_ptp_link_change - Set or clear port registers for timestamping
+ * ice_ptp_link_change - Reconfigure PTP after link status change
  * @pf: Board private structure
  * @port: Port for which the PHY start is set
  * @linkup: Link is up or down
  */
-int ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
+void ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
 {
 	struct ice_ptp_port *ptp_port;
 
-	if (!test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
-		return 0;
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return;
 
-	if (port >= ICE_NUM_EXTERNAL_PORTS)
-		return -EINVAL;
+	if (WARN_ON_ONCE(port >= ICE_NUM_EXTERNAL_PORTS))
+		return;
 
 	ptp_port = &pf->ptp.port;
-	if (ptp_port->port_num != port)
-		return -EINVAL;
+	if (WARN_ON_ONCE(ptp_port->port_num != port))
+		return;
 
 	/* Update cached link status for this port immediately */
 	ptp_port->link_up = linkup;
 
-	if (!test_bit(ICE_FLAG_PTP, pf->flags))
-		/* PTP is not setup */
-		return -EAGAIN;
+	/* E810 devices do not need to reconfigure the PHY */
+	if (ice_is_e810(&pf->hw))
+		return;
 
-	return ice_ptp_port_phy_restart(ptp_port);
+	ice_ptp_port_phy_restart(ptp_port);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index ca0fbfd71ed2..39cab020f1af 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -257,7 +257,7 @@ void ice_ptp_reset(struct ice_pf *pf);
 void ice_ptp_prepare_for_reset(struct ice_pf *pf);
 void ice_ptp_init(struct ice_pf *pf);
 void ice_ptp_release(struct ice_pf *pf);
-int ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup);
+void ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup);
 #else /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
 static inline int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
 {
@@ -292,7 +292,8 @@ static inline void ice_ptp_reset(struct ice_pf *pf) { }
 static inline void ice_ptp_prepare_for_reset(struct ice_pf *pf) { }
 static inline void ice_ptp_init(struct ice_pf *pf) { }
 static inline void ice_ptp_release(struct ice_pf *pf) { }
-static inline int ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
-{ return 0; }
+static inline void ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
+{
+}
 #endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
 #endif /* _ICE_PTP_H_ */
-- 
2.35.1

