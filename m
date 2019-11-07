Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A502F2398
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732894AbfKGAwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:52:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:37378 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbfKGAwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 19:52:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 16:52:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="205514196"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 06 Nov 2019 16:52:22 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 07/13] ice: Check for null pointer dereference when setting rings
Date:   Wed,  6 Nov 2019 16:52:14 -0800
Message-Id: <20191107005220.1039-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
References: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Without this check rebuild vsi can lead to kernel panic.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 76c5324268c5..d061e9fd6f2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4303,8 +4303,13 @@ int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_txq(vsi, i) {
-		vsi->tx_rings[i]->netdev = vsi->netdev;
-		err = ice_setup_tx_ring(vsi->tx_rings[i]);
+		struct ice_ring *ring = vsi->tx_rings[i];
+
+		if (!ring)
+			return -EINVAL;
+
+		ring->netdev = vsi->netdev;
+		err = ice_setup_tx_ring(ring);
 		if (err)
 			break;
 	}
@@ -4329,8 +4334,13 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_rxq(vsi, i) {
-		vsi->rx_rings[i]->netdev = vsi->netdev;
-		err = ice_setup_rx_ring(vsi->rx_rings[i]);
+		struct ice_ring *ring = vsi->rx_rings[i];
+
+		if (!ring)
+			return -EINVAL;
+
+		ring->netdev = vsi->netdev;
+		err = ice_setup_rx_ring(ring);
 		if (err)
 			break;
 	}
-- 
2.21.0

