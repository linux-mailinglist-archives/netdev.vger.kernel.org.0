Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F2441B9AB
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242995AbhI1Vzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:55:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:59509 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242949AbhI1Vzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:55:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224851567"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="224851567"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 14:53:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="486701072"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Sep 2021 14:53:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/6] ice: Fix link mode handling
Date:   Tue, 28 Sep 2021 14:57:54 -0700
Message-Id: <20210928215757.3378414-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
References: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

The messaging for unsupported module detection is different for
lenient mode and strict mode. Update the code to print the right
messaging for a given link mode.

Media topology conflict is not an error in lenient mode, so return
an error code only if not in lenient mode.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ab15862a66af..909e5cd98054 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -624,7 +624,10 @@ static void ice_print_topo_conflict(struct ice_vsi *vsi)
 		netdev_info(vsi->netdev, "Potential misconfiguration of the Ethernet port detected. If it was not intended, please use the Intel (R) Ethernet Port Configuration Tool to address the issue.\n");
 		break;
 	case ICE_AQ_LINK_TOPO_UNSUPP_MEDIA:
-		netdev_info(vsi->netdev, "Rx/Tx is disabled on this device because an unsupported module type was detected. Refer to the Intel(R) Ethernet Adapters and Devices User Guide for a list of supported modules.\n");
+		if (test_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, vsi->back->flags))
+			netdev_warn(vsi->netdev, "An unsupported module type was detected. Refer to the Intel(R) Ethernet Adapters and Devices User Guide for a list of supported modules\n");
+		else
+			netdev_err(vsi->netdev, "Rx/Tx is disabled on this device because an unsupported module type was detected. Refer to the Intel(R) Ethernet Adapters and Devices User Guide for a list of supported modules.\n");
 		break;
 	default:
 		break;
@@ -1965,7 +1968,8 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 
 	ice_print_topo_conflict(vsi);
 
-	if (phy->link_info.topo_media_conflict == ICE_AQ_LINK_TOPO_UNSUPP_MEDIA)
+	if (!test_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags) &&
+	    phy->link_info.topo_media_conflict == ICE_AQ_LINK_TOPO_UNSUPP_MEDIA)
 		return -EPERM;
 
 	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags))
-- 
2.26.2

