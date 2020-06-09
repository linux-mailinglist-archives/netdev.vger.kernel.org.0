Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8A71F3CCF
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgFINky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 09:40:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:22603 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgFINkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 09:40:53 -0400
IronPort-SDR: 9ue5OnYhqm0GTmzV5htnMsWpOlozXb7cXm8BJVPqXkEs4H3acUwHAvIHLWvxsAQ9PBV78GC55K
 MR0uSGzEURcg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 06:40:52 -0700
IronPort-SDR: mpyT7sZhMKlrLlo0YzHV3LqvTaMfSV/lMAZxvBsqN/vdYSjm1gfC6tcrcAYOXXdBrgo7cfNh8y
 58XQCT5fgyuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="295837460"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.8])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2020 06:40:51 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ciara.loftus@intel.com
Subject: [PATCH net 3/3] ice: protect ring accesses with WRITE_ONCE
Date:   Tue,  9 Jun 2020 13:19:45 +0000
Message-Id: <20200609131945.18373-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200609131945.18373-1-ciara.loftus@intel.com>
References: <20200609131945.18373-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The READ_ONCE macro is used when reading rings prior to accessing the
statistics pointer. The corresponding WRITE_ONCE usage when allocating and
freeing the rings to ensure protected access was not in place. Introduce
this.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
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
2.17.1

