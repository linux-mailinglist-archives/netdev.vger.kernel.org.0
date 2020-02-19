Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBBE165223
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgBSWHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:62535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgBSWHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:07:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824812"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Avinash JD <avinash.dayanand@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/13] ice: Add DCBNL ops required to configure ETS in CEE for SW DCB
Date:   Wed, 19 Feb 2020 14:06:44 -0800
Message-Id: <20200219220652.2255171-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avinash JD <avinash.dayanand@intel.com>

Couple of DCBNL ops are required for configuring ETS in SW DCB CEE mode. If
these functions are not added, it'll break the CEE functionality.

Signed-off-by: Avinash JD <avinash.dayanand@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 43 +++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index c572aa5c28e0..589b820a6b5b 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -540,6 +540,30 @@ ice_dcbnl_get_pg_tc_cfg_rx(struct net_device *netdev, int prio,
 	*pgid = pi->local_dcbx_cfg.etscfg.prio_table[prio];
 }
 
+/**
+ * ice_dcbnl_set_pg_tc_cfg_rx
+ * @netdev: relevant netdev struct
+ * @prio: corresponding user priority
+ * @prio_type: the traffic priority type
+ * @pgid: the PG ID
+ * @bw_pct: BW percentage for corresponding BWG
+ * @up_map: prio mapped to corresponding TC
+ *
+ * lldpad requires this function pointer to be non-NULL to complete CEE config.
+ */
+static void
+ice_dcbnl_set_pg_tc_cfg_rx(struct net_device *netdev,
+			   int __always_unused prio,
+			   u8 __always_unused prio_type,
+			   u8 __always_unused pgid,
+			   u8 __always_unused bw_pct,
+			   u8 __always_unused up_map)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	dev_dbg(ice_pf_to_dev(pf), "Rx TC PG Config Not Supported.\n");
+}
+
 /**
  * ice_dcbnl_get_pg_bwg_cfg_rx - Get CEE PG BW Rx config
  * @netdev: pointer to netdev struct
@@ -559,6 +583,23 @@ ice_dcbnl_get_pg_bwg_cfg_rx(struct net_device *netdev, int __always_unused pgid,
 	*bw_pct = 0;
 }
 
+/**
+ * ice_dcbnl_set_pg_bwg_cfg_rx
+ * @netdev: the corresponding netdev
+ * @pgid: corresponding TC
+ * @bw_pct: BW percentage for given TC
+ *
+ * lldpad requires this function pointer to be non-NULL to complete CEE config.
+ */
+static void
+ice_dcbnl_set_pg_bwg_cfg_rx(struct net_device *netdev, int __always_unused pgid,
+			    u8 __always_unused bw_pct)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	dev_dbg(ice_pf_to_dev(pf), "Rx BWG PG Config Not Supported.\n");
+}
+
 /**
  * ice_dcbnl_get_cap - Get DCBX capabilities of adapter
  * @netdev: pointer to netdev struct
@@ -805,6 +846,8 @@ static const struct dcbnl_rtnl_ops dcbnl_ops = {
 	.getpermhwaddr = ice_dcbnl_get_perm_hw_addr,
 	.setpgtccfgtx = ice_dcbnl_set_pg_tc_cfg_tx,
 	.setpgbwgcfgtx = ice_dcbnl_set_pg_bwg_cfg_tx,
+	.setpgtccfgrx = ice_dcbnl_set_pg_tc_cfg_rx,
+	.setpgbwgcfgrx = ice_dcbnl_set_pg_bwg_cfg_rx,
 	.getpgtccfgtx = ice_dcbnl_get_pg_tc_cfg_tx,
 	.getpgbwgcfgtx = ice_dcbnl_get_pg_bwg_cfg_tx,
 	.getpgtccfgrx = ice_dcbnl_get_pg_tc_cfg_rx,
-- 
2.24.1

