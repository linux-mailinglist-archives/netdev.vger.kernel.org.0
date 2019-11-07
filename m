Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E3FF3B39
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfKGWQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:16:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:16680 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfKGWOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 17:14:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 14:14:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,279,1569308400"; 
   d="scan'208";a="233420899"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 07 Nov 2019 14:14:41 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Usha Ketineni <usha.k.ketineni@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Fix to change Rx/Tx ring descriptor size via ethtool with DCBx
Date:   Thu,  7 Nov 2019 14:14:28 -0800
Message-Id: <20191107221438.17994-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
References: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

This patch fixes the call trace caused by the kernel when the Rx/Tx
descriptor size change request is initiated via ethtool when DCB is
configured. ice_set_ringparam() should use vsi->num_txq instead of
vsi->alloc_txq as it represents the queues that are enabled in the
driver when DCB is enabled/disabled. Otherwise, queue index being
used can go out of range.

For example, when vsi->alloc_txq has 104 queues and with 3 TCS enabled
via DCB, each TC gets 34 queues, vsi->num_txq will be 102 and only 102
queues will be enabled.

Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a8e51bc95198..f85d224f964d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2654,14 +2654,14 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	netdev_info(netdev, "Changing Tx descriptor count from %d to %d\n",
 		    vsi->tx_rings[0]->count, new_tx_cnt);
 
-	tx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_txq,
+	tx_rings = devm_kcalloc(&pf->pdev->dev, vsi->num_txq,
 				sizeof(*tx_rings), GFP_KERNEL);
 	if (!tx_rings) {
 		err = -ENOMEM;
 		goto done;
 	}
 
-	for (i = 0; i < vsi->alloc_txq; i++) {
+	ice_for_each_txq(vsi, i) {
 		/* clone ring and setup updated count */
 		tx_rings[i] = *vsi->tx_rings[i];
 		tx_rings[i].count = new_tx_cnt;
@@ -2714,14 +2714,14 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	netdev_info(netdev, "Changing Rx descriptor count from %d to %d\n",
 		    vsi->rx_rings[0]->count, new_rx_cnt);
 
-	rx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_rxq,
+	rx_rings = devm_kcalloc(&pf->pdev->dev, vsi->num_rxq,
 				sizeof(*rx_rings), GFP_KERNEL);
 	if (!rx_rings) {
 		err = -ENOMEM;
 		goto done;
 	}
 
-	for (i = 0; i < vsi->alloc_rxq; i++) {
+	ice_for_each_rxq(vsi, i) {
 		/* clone ring and setup updated count */
 		rx_rings[i] = *vsi->rx_rings[i];
 		rx_rings[i].count = new_rx_cnt;
@@ -2759,7 +2759,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 		ice_down(vsi);
 
 		if (tx_rings) {
-			for (i = 0; i < vsi->alloc_txq; i++) {
+			ice_for_each_txq(vsi, i) {
 				ice_free_tx_ring(vsi->tx_rings[i]);
 				*vsi->tx_rings[i] = tx_rings[i];
 			}
@@ -2767,7 +2767,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 		}
 
 		if (rx_rings) {
-			for (i = 0; i < vsi->alloc_rxq; i++) {
+			ice_for_each_rxq(vsi, i) {
 				ice_free_rx_ring(vsi->rx_rings[i]);
 				/* copy the real tail offset */
 				rx_rings[i].tail = vsi->rx_rings[i]->tail;
@@ -2801,7 +2801,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 free_tx:
 	/* error cleanup if the Rx allocations failed after getting Tx */
 	if (tx_rings) {
-		for (i = 0; i < vsi->alloc_txq; i++)
+		ice_for_each_txq(vsi, i)
 			ice_free_tx_ring(&tx_rings[i]);
 		devm_kfree(&pf->pdev->dev, tx_rings);
 	}
-- 
2.21.0

