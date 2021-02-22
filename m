Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25573222E0
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhBVX6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:58:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:20936 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhBVX6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 18:58:41 -0500
IronPort-SDR: x54W3mo9Mnm8etwns8qZ2bfN9ndYrbeApRIhmOeeawWAVwQnBk2PaNPK4Q8BToUmLEbr8pUWKV
 aC2QwczyevNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="184751844"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="184751844"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 15:57:14 -0800
IronPort-SDR: 9VDyUP6yRNPOwcS81P6jKdAgPOeI+q/7o2Lkd9qGphQaZAZlbpUhAyDT4SxvZSRojZWgR2UhMc
 aBLBDkK6Bvag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="592882910"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2021 15:57:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 4/5] ice: Fix state bits on LLDP mode switch
Date:   Mon, 22 Feb 2021 15:58:13 -0800
Message-Id: <20210222235814.834282-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
References: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

DCBX_CAP bits were not being adjusted when switching
between SW and FW controlled LLDP.

Adjust bits to correctly indicate which mode the
LLDP logic is in.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 2 --
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c  | 4 ++++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index dae8280ce17c..357706444dd5 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -454,9 +454,7 @@ struct ice_pf {
 	struct ice_hw_port_stats stats_prev;
 	struct ice_hw hw;
 	u8 stat_prev_loaded:1; /* has previous stats been loaded */
-#ifdef CONFIG_DCB
 	u16 dcbx_cap;
-#endif /* CONFIG_DCB */
 	u32 tx_timeout_count;
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 299bf7edbf82..468a63f7eff9 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -159,6 +159,10 @@ static u8 ice_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct ice_qos_cfg *qos_cfg;
 
+	/* if FW LLDP agent is running, DCBNL not allowed to change mode */
+	if (test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+		return ICE_DCB_NO_HW_CHG;
+
 	/* No support for LLD_MANAGED modes or CEE+IEEE */
 	if ((mode & DCB_CAP_DCBX_LLD_MANAGED) ||
 	    ((mode & DCB_CAP_DCBX_VER_IEEE) && (mode & DCB_CAP_DCBX_VER_CEE)) ||
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 5636c9b23896..4001857788f8 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -8,6 +8,7 @@
 #include "ice_fltr.h"
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
+#include <net/dcbnl.h>
 
 struct ice_stats {
 	char stat_string[ETH_GSTRING_LEN];
@@ -1238,6 +1239,9 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_warn(dev, "Fail to init DCB\n");
+
+			pf->dcbx_cap &= ~DCB_CAP_DCBX_LLD_MANAGED;
+			pf->dcbx_cap |= DCB_CAP_DCBX_HOST;
 		} else {
 			enum ice_status status;
 			bool dcbx_agent_status;
@@ -1280,6 +1284,9 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			if (status)
 				dev_dbg(dev, "Fail to enable MIB change events\n");
 
+			pf->dcbx_cap &= ~DCB_CAP_DCBX_HOST;
+			pf->dcbx_cap |= DCB_CAP_DCBX_LLD_MANAGED;
+
 			ice_nway_reset(netdev);
 		}
 	}
-- 
2.26.2

