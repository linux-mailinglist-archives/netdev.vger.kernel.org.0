Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC59A79E6
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfIDEfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfIDEfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804426"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: Report stats when VSI is down
Date:   Tue,  3 Sep 2019 21:35:10 -0700
Message-Id: <20190904043512.28066-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

There is currently a check in get_ndo_stats that
returns before updating stats if the VSI is down
or there are no Tx or Rx queues.  This causes the
netdev to report zero stats with the netdev is down.

Remove the check so that the behavior of reporting
stats is the same as it was in IXGBE.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 732397a2e8fa..50a17a0337be 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3477,12 +3477,16 @@ void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 
 	vsi_stats = &vsi->net_stats;
 
-	if (test_bit(__ICE_DOWN, vsi->state) || !vsi->num_txq || !vsi->num_rxq)
+	if (!vsi->num_txq || !vsi->num_rxq)
 		return;
+
 	/* netdev packet/byte stats come from ring counter. These are obtained
 	 * by summing up ring counters (done by ice_update_vsi_ring_stats).
+	 * But, only call the update routine and read the registers if VSI is
+	 * not down.
 	 */
-	ice_update_vsi_ring_stats(vsi);
+	if (!test_bit(__ICE_DOWN, vsi->state))
+		ice_update_vsi_ring_stats(vsi);
 	stats->tx_packets = vsi_stats->tx_packets;
 	stats->tx_bytes = vsi_stats->tx_bytes;
 	stats->rx_packets = vsi_stats->rx_packets;
-- 
2.21.0

