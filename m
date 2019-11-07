Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719BCF2399
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbfKGAwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:52:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:37378 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732822AbfKGAwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 19:52:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 16:52:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="205514202"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 06 Nov 2019 16:52:22 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 09/13] ice: print unsupported module message
Date:   Wed,  6 Nov 2019 16:52:16 -0800
Message-Id: <20191107005220.1039-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
References: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Print message to inform user if unsupported module is inserted, and
extend the topology / configuration detection.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 4 ++++
 drivers/net/ethernet/intel/ice/ice_main.c       | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 9b32aac66444..622c666399fd 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1044,6 +1044,10 @@ struct ice_aqc_get_link_status_data {
 #define ICE_AQ_LINK_TOPO_CONFLICT	BIT(0)
 #define ICE_AQ_LINK_MEDIA_CONFLICT	BIT(1)
 #define ICE_AQ_LINK_TOPO_CORRUPT	BIT(2)
+#define ICE_AQ_LINK_TOPO_UNREACH_PRT	BIT(4)
+#define ICE_AQ_LINK_TOPO_UNDRUTIL_PRT	BIT(5)
+#define ICE_AQ_LINK_TOPO_UNDRUTIL_MEDIA	BIT(6)
+#define ICE_AQ_LINK_TOPO_UNSUPP_MEDIA	BIT(7)
 	u8 reserved1;
 	u8 link_info;
 #define ICE_AQ_LINK_UP			BIT(0)	/* Link Status */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d061e9fd6f2c..7a90243198eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -637,8 +637,14 @@ static void ice_print_topo_conflict(struct ice_vsi *vsi)
 	switch (vsi->port_info->phy.link_info.topo_media_conflict) {
 	case ICE_AQ_LINK_TOPO_CONFLICT:
 	case ICE_AQ_LINK_MEDIA_CONFLICT:
+	case ICE_AQ_LINK_TOPO_UNREACH_PRT:
+	case ICE_AQ_LINK_TOPO_UNDRUTIL_PRT:
+	case ICE_AQ_LINK_TOPO_UNDRUTIL_MEDIA:
 		netdev_info(vsi->netdev, "Possible mis-configuration of the Ethernet port detected, please use the Intel(R) Ethernet Port Configuration Tool application to address the issue.\n");
 		break;
+	case ICE_AQ_LINK_TOPO_UNSUPP_MEDIA:
+		netdev_info(vsi->netdev, "Rx/Tx is disabled on this device because an unsupported module type was detected. Refer to the Intel(R) Ethernet Adapters and Devices User Guide for a list of supported modules.\n");
+		break;
 	default:
 		break;
 	}
-- 
2.21.0

