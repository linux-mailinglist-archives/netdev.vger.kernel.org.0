Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969DA304DAF
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbhAZXNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:62462 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbhAZWNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 17:13:24 -0500
IronPort-SDR: Yie7yhT6/gdsH6natmL8KmyPjznNmRMTkZERhJi0FmYDYdstoiV0tuCO4jaVmNcM7lgurkooeP
 Tiw7S6Mmwixw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="179198678"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="179198678"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 14:10:01 -0800
IronPort-SDR: OquP1jIvEaj0UBYBFs2zouidenwxgxkoQpSGjOMTH6LriOD9Xk23Iigy/RrcRVvCsbDjZLcUpf
 IWsa22Nxs81Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="472908313"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jan 2021 14:10:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nick Nunley <nicholas.d.nunley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net v2 3/7] ice: update dev_addr in ice_set_mac_address even if HW filter exists
Date:   Tue, 26 Jan 2021 14:10:31 -0800
Message-Id: <20210126221035.658124-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Nunley <nicholas.d.nunley@intel.com>

Fix the driver to copy the MAC address configured in ndo_set_mac_address
into dev_addr, even if the MAC filter already exists in HW. In some
situations (e.g. bonding) the netdev's dev_addr could have been modified
outside of the driver, with no change to the HW filter, so the driver
cannot assume that they match.

Fixes: 757976ab16be ("ice: Fix check for removing/adding mac filters")
Signed-off-by: Nick Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c52b9bb0e3ab..fb81aa5979e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4884,9 +4884,15 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		goto err_update_filters;
 	}
 
-	/* Add filter for new MAC. If filter exists, just return success */
+	/* Add filter for new MAC. If filter exists, return success */
 	status = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
 	if (status == ICE_ERR_ALREADY_EXISTS) {
+		/* Although this MAC filter is already present in hardware it's
+		 * possible in some cases (e.g. bonding) that dev_addr was
+		 * modified outside of the driver and needs to be restored back
+		 * to this value.
+		 */
+		memcpy(netdev->dev_addr, mac, netdev->addr_len);
 		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
 		return 0;
 	}
-- 
2.26.2

