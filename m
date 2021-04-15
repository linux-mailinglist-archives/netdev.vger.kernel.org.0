Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D26A35FEE2
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhDOA3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:27420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231514AbhDOA2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:49 -0400
IronPort-SDR: MaHnYdnBOOt2e80RKoW8QsO08cnkHC/y9U3HIBfqdJduxAHcDzjNaO/BkQJaLKK47gZHSeEoAq
 lEqDOrIMjlbg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262242"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262242"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: XzrBJX6p0u2YRHbM++TSeStbl/w0H1ZbfKb4UaS88XEhiamzkrEhqDLV7oIHSdg/7l2//1aJWj
 zpUNDO1QhweA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379543"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 14/15] ice: remove return variable
Date:   Wed, 14 Apr 2021 17:30:12 -0700
Message-Id: <20210415003013.19717-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

We were saving the return value from ice_vsi_manage_rss_lut(), but
the errors from that function are not critical so change it to
return void and remove the code that saved the value.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 8 +++-----
 drivers/net/ethernet/intel/ice/ice_lib.h  | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index eb6e352d3387..82e2ce23df3d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1313,14 +1313,13 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
  * LUT, while in the event of enable request for RSS, it will reconfigure RSS
  * LUT.
  */
-int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
+void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
 {
-	int err = 0;
 	u8 *lut;
 
 	lut = kzalloc(vsi->rss_table_size, GFP_KERNEL);
 	if (!lut)
-		return -ENOMEM;
+		return;
 
 	if (ena) {
 		if (vsi->rss_lut_user)
@@ -1330,9 +1329,8 @@ int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
 					 vsi->rss_size);
 	}
 
-	err = ice_set_rss_lut(vsi, lut, vsi->rss_table_size);
+	ice_set_rss_lut(vsi, lut, vsi->rss_table_size);
 	kfree(lut);
-	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index f48c5ccb8036..511c2316c40c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -85,7 +85,7 @@ void ice_vsi_free_rx_rings(struct ice_vsi *vsi);
 
 void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
 
-int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
+void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
 void ice_update_tx_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 02672be04f78..6dbaa9099fdf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5112,10 +5112,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	 * separate if/else statements to guarantee each feature is checked
 	 */
 	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
-		ret = ice_vsi_manage_rss_lut(vsi, true);
+		ice_vsi_manage_rss_lut(vsi, true);
 	else if (!(features & NETIF_F_RXHASH) &&
 		 netdev->features & NETIF_F_RXHASH)
-		ret = ice_vsi_manage_rss_lut(vsi, false);
+		ice_vsi_manage_rss_lut(vsi, false);
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
-- 
2.26.2

