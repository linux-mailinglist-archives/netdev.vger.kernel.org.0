Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907E3358958
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhDHQL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:11:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:47825 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231961AbhDHQLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:52 -0400
IronPort-SDR: L6EQJOTaQTSFdISIkZ78dZeTPT6ZJXJaCa1vuc/yXP0jAgxbxUrEet9LoEo1V+2QQEZ+ZJgpHc
 z5iqtfOWSbQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="180707306"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="180707306"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:40 -0700
IronPort-SDR: u1N1qI66IyF+4tGqWwFOg7MxhkiSWPs1QNio6fBi7wqmhsJ9kAj8TePfuKefiqv1Rt9sNsAAwC
 CxVIzJ8otivw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841421"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 07/15] ice: Fix error return codes in ice_set_link_ksettings
Date:   Thu,  8 Apr 2021 09:13:13 -0700
Message-Id: <20210408161321.3218024-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Return more appropriate error codes so that the right error
message is communicated to the user by ethtool.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a31b6cf8d599..41795d263dcd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2212,7 +2212,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	pi = np->vsi->port_info;
 
 	if (!pi)
-		return -EOPNOTSUPP;
+		return -EIO;
 
 	if (pi->phy.media_type != ICE_MEDIA_BASET &&
 	    pi->phy.media_type != ICE_MEDIA_FIBER &&
@@ -2229,7 +2229,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
 				     phy_caps, NULL);
 	if (status) {
-		err = -EAGAIN;
+		err = -EIO;
 		goto done;
 	}
 
@@ -2252,7 +2252,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 			   __ETHTOOL_LINK_MODE_MASK_NBITS)) {
 		if (!test_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags))
 			netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
-		err = -EINVAL;
+		err = -EOPNOTSUPP;
 		goto done;
 	}
 
@@ -2304,7 +2304,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	pi->phy.get_link_info = true;
 	status = ice_get_link_status(pi, &linkup);
 	if (status) {
-		err = -EAGAIN;
+		err = -EIO;
 		goto done;
 	}
 
@@ -2335,7 +2335,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	/* check if there is a PHY type for the requested advertised speed */
 	if (!(phy_type_low || phy_type_high)) {
 		netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
-		err = -EAGAIN;
+		err = -EOPNOTSUPP;
 		goto done;
 	}
 
@@ -2359,7 +2359,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 					      pf->nvm_phy_type_lo;
 		} else {
 			netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
-			err = -EAGAIN;
+			err = -EOPNOTSUPP;
 			goto done;
 		}
 	}
@@ -2378,7 +2378,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	status = ice_aq_set_phy_cfg(&pf->hw, pi, &config, NULL);
 	if (status) {
 		netdev_info(netdev, "Set phy config failed,\n");
-		err = -EAGAIN;
+		err = -EIO;
 		goto done;
 	}
 
-- 
2.26.2

