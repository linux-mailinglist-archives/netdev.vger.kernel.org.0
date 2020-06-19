Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDAA2001E6
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 08:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgFSGWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 02:22:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:50185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgFSGWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 02:22:16 -0400
IronPort-SDR: kDNLAnhRy1LUZrUB7oYV2uzwJd2LH8Ym5Per5qiEYIGUoRDmrlYRR/sfrpfDLu2eNI43wEk66T
 ZnubQP8kW4wQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="130229728"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="130229728"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 23:22:13 -0700
IronPort-SDR: WDsxgGjAaHjL+WGxVKljHzhUeJP4/pwm+zkmeh26dQtfb98/hiEaQKwabohCgl4bSJt1wPN+y9
 A6YkZUATqOig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="421753963"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2020 23:22:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 3/4] ice: protect ring accesses with WRITE_ONCE
Date:   Thu, 18 Jun 2020 23:22:09 -0700
Message-Id: <20200619062210.3159291-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619062210.3159291-1-jeffrey.t.kirsher@intel.com>
References: <20200619062210.3159291-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

The READ_ONCE macro is used when reading rings prior to accessing the
statistics pointer. The corresponding WRITE_ONCE usage when allocating and
freeing the rings to ensure protected access was not in place. Introduce
this.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 8 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 28b46cc9f5cb..2e3a39cea2c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1194,7 +1194,7 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 		for (i = 0; i < vsi->alloc_txq; i++) {
 			if (vsi->tx_rings[i]) {
 				kfree_rcu(vsi->tx_rings[i], rcu);
-				vsi->tx_rings[i] = NULL;
+				WRITE_ONCE(vsi->tx_rings[i], NULL);
 			}
 		}
 	}
@@ -1202,7 +1202,7 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 		for (i = 0; i < vsi->alloc_rxq; i++) {
 			if (vsi->rx_rings[i]) {
 				kfree_rcu(vsi->rx_rings[i], rcu);
-				vsi->rx_rings[i] = NULL;
+				WRITE_ONCE(vsi->rx_rings[i], NULL);
 			}
 		}
 	}
@@ -1235,7 +1235,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->vsi = vsi;
 		ring->dev = dev;
 		ring->count = vsi->num_tx_desc;
-		vsi->tx_rings[i] = ring;
+		WRITE_ONCE(vsi->tx_rings[i], ring);
 	}
 
 	/* Allocate Rx rings */
@@ -1254,7 +1254,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->netdev = vsi->netdev;
 		ring->dev = dev;
 		ring->count = vsi->num_rx_desc;
-		vsi->rx_rings[i] = ring;
+		WRITE_ONCE(vsi->rx_rings[i], ring);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 082825e3cb39..4cbd49c87568 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1702,7 +1702,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		xdp_ring->netdev = NULL;
 		xdp_ring->dev = dev;
 		xdp_ring->count = vsi->num_tx_desc;
-		vsi->xdp_rings[i] = xdp_ring;
+		WRITE_ONCE(vsi->xdp_rings[i], xdp_ring);
 		if (ice_setup_tx_ring(xdp_ring))
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
-- 
2.26.2

