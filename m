Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E44935895A
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhDHQMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:47825 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232017AbhDHQLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:53 -0400
IronPort-SDR: nDkF8HyeLZZ+ocis8W/W1H2yMIynuvPlrlA3z8YGSnfjnl3ZWcCnUILbiJKGN9IvKU6qjOyOPp
 9nv+/0/+/fNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="180707311"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="180707311"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:40 -0700
IronPort-SDR: yxsznglE87kzK34VyzggREf8Cg1T72bDKOb6GNLFh+xGsBqKFGMORb00ynhJcPl+A63i78Eo6C
 Zari3AmrbyOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841426"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 08/15] ice: Replace some memsets and memcpys with assignment
Date:   Thu,  8 Apr 2021 09:13:14 -0700
Message-Id: <20210408161321.3218024-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

In ice_set_link_ksettings, use assignment instead of memset/memcpy
where possible

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 41795d263dcd..5dd84ccf6756 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2195,8 +2195,9 @@ ice_set_link_ksettings(struct net_device *netdev,
 		       const struct ethtool_link_ksettings *ks)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ethtool_link_ksettings safe_ks, copy_ks;
 	u8 autoneg, timeout = TEST_SET_BITS_TIMEOUT;
+	struct ethtool_link_ksettings copy_ks = *ks;
+	struct ethtool_link_ksettings safe_ks = {};
 	struct ice_aqc_get_phy_caps_data *phy_caps;
 	struct ice_aqc_set_phy_cfg_data config;
 	u16 adv_link_speed, curr_link_speed;
@@ -2233,14 +2234,9 @@ ice_set_link_ksettings(struct net_device *netdev,
 		goto done;
 	}
 
-	/* copy the ksettings to copy_ks to avoid modifying the original */
-	memcpy(&copy_ks, ks, sizeof(copy_ks));
-
 	/* save autoneg out of ksettings */
 	autoneg = copy_ks.base.autoneg;
 
-	memset(&safe_ks, 0, sizeof(safe_ks));
-
 	/* Get link modes supported by hardware.*/
 	ice_phy_type_to_ethtool(netdev, &safe_ks);
 
@@ -2289,7 +2285,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	 * configuration is initialized during probe from PHY capabilities
 	 * software mode, and updated on set PHY configuration.
 	 */
-	memcpy(&config, &pi->phy.curr_user_phy_cfg, sizeof(config));
+	config = pi->phy.curr_user_phy_cfg;
 
 	config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 
-- 
2.26.2

