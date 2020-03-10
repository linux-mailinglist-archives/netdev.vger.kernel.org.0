Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0F180979
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCJUpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 16:45:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:27462 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgCJUpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 16:45:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 13:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="441431002"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2020 13:45:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 08/15] ice: renegotiate link after FW DCB on
Date:   Tue, 10 Mar 2020 13:45:27 -0700
Message-Id: <20200310204534.2071912-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
References: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

When switching from SW DCB to FW DCB it is necessary
to renegotiate DCBx so that the FW agent can have up
to date information about the DCB settings of the link
partner.

Perform an autoneg restart on the link when activating
FW DCB.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 53 +++++++++++---------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 419e3d488012..03d4ecf47e3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1131,6 +1131,33 @@ ice_get_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
 	return err;
 }
 
+/**
+ * ice_nway_reset - restart autonegotiation
+ * @netdev: network interface device structure
+ */
+static int ice_nway_reset(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_port_info *pi;
+	enum ice_status status;
+
+	pi = vsi->port_info;
+	/* If VSI state is up, then restart autoneg with link up */
+	if (!test_bit(__ICE_DOWN, vsi->back->state))
+		status = ice_aq_set_link_restart_an(pi, true, NULL);
+	else
+		status = ice_aq_set_link_restart_an(pi, false, NULL);
+
+	if (status) {
+		netdev_info(netdev, "link restart failed, err %d aq_err %d\n",
+			    status, pi->hw->adminq.sq_last_status);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /**
  * ice_get_priv_flags - report device private flags
  * @netdev: network interface device structure
@@ -1264,6 +1291,8 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			status = ice_cfg_lldp_mib_change(&pf->hw, true);
 			if (status)
 				dev_dbg(dev, "Fail to enable MIB change events\n");
+
+			ice_nway_reset(netdev);
 		}
 	}
 	if (test_bit(ICE_FLAG_LEGACY_RX, change_flags)) {
@@ -2775,30 +2804,6 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	return err;
 }
 
-static int ice_nway_reset(struct net_device *netdev)
-{
-	/* restart autonegotiation */
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
-	struct ice_port_info *pi;
-	enum ice_status status;
-
-	pi = vsi->port_info;
-	/* If VSI state is up, then restart autoneg with link up */
-	if (!test_bit(__ICE_DOWN, vsi->back->state))
-		status = ice_aq_set_link_restart_an(pi, true, NULL);
-	else
-		status = ice_aq_set_link_restart_an(pi, false, NULL);
-
-	if (status) {
-		netdev_info(netdev, "link restart failed, err %d aq_err %d\n",
-			    status, pi->hw->adminq.sq_last_status);
-		return -EIO;
-	}
-
-	return 0;
-}
-
 /**
  * ice_get_pauseparam - Get Flow Control status
  * @netdev: network interface device structure
-- 
2.24.1

