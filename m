Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B3834D8ED
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhC2USA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:19968 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229884AbhC2UR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:26 -0400
IronPort-SDR: /EBvPEp54n1elforFibgt+BkzNoWKh7N5pdlBRZsekK4u0UAwpTr3YUy1kS0ZBjAi0hdChDW1b
 XqEeXM4GlHjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160815"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160815"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: ZeHkosTueqjSDZWA5yVUONsuI2/L9bzMYfYHhzZwX0vghbF90JdmVuT2Kac5DtxzYCo10SGcSz
 l7TwsptdVmvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700534"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 1/9] ice: Continue probe on link/PHY errors
Date:   Mon, 29 Mar 2021 13:18:49 -0700
Message-Id: <20210329201857.3509461-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

An incorrect NVM update procedure can result in the driver failing probe.
In this case, the recommended resolution method is to update the NVM
using the right procedure. However, if the driver fails probe, the user
will not be able to update the NVM. So do not fail probe on link/PHY
errors.

Fixes: 1a3571b5938c ("ice: restore PHY settings on media insertion")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2c23c8f468a5..53e053c997eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4192,28 +4192,25 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_send_version_unroll;
 	}
 
+	/* not a fatal error if this fails */
 	err = ice_init_nvm_phy_type(pf->hw.port_info);
-	if (err) {
+	if (err)
 		dev_err(dev, "ice_init_nvm_phy_type failed: %d\n", err);
-		goto err_send_version_unroll;
-	}
 
+	/* not a fatal error if this fails */
 	err = ice_update_link_info(pf->hw.port_info);
-	if (err) {
+	if (err)
 		dev_err(dev, "ice_update_link_info failed: %d\n", err);
-		goto err_send_version_unroll;
-	}
 
 	ice_init_link_dflt_override(pf->hw.port_info);
 
 	/* if media available, initialize PHY settings */
 	if (pf->hw.port_info->phy.link_info.link_info &
 	    ICE_AQ_MEDIA_AVAILABLE) {
+		/* not a fatal error if this fails */
 		err = ice_init_phy_user_cfg(pf->hw.port_info);
-		if (err) {
+		if (err)
 			dev_err(dev, "ice_init_phy_user_cfg failed: %d\n", err);
-			goto err_send_version_unroll;
-		}
 
 		if (!test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags)) {
 			struct ice_vsi *vsi = ice_get_main_vsi(pf);
-- 
2.26.2

