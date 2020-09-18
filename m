Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99E026F452
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgIRDNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgIRCBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2576521D92;
        Fri, 18 Sep 2020 02:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394515;
        bh=GqoM6cRd9EYADEHXrQ0iozMlUKV4gzbkkS4fqV+rltY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKx2c7Cm7qHejxsLG2SOrb0/Bur2fExCQw5zXSIYoXGKEIfQhQ6MFOMyFGz4vQvGm
         4AYE6pXs6bd7awwKXamQFw3Sn61tsTtLnTxmBGsPo7RxMXYT3ztAZ+bn/LjuIQni2g
         o2u6e3L3RcEZiSMjDEer4GXpi+txc+W3hCnaPqtQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Usha Ketineni <usha.k.ketineni@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 037/330] ice: Fix to change Rx/Tx ring descriptor size via ethtool with DCBx
Date:   Thu, 17 Sep 2020 21:56:17 -0400
Message-Id: <20200918020110.2063155-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

[ Upstream commit c0a3665f71a2f086800abea4d9d14d28269089d6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 62673e27af0e8..fc9ff985a62bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2635,14 +2635,14 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
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
@@ -2667,14 +2667,14 @@ process_rx:
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
@@ -2712,7 +2712,7 @@ process_link:
 		ice_down(vsi);
 
 		if (tx_rings) {
-			for (i = 0; i < vsi->alloc_txq; i++) {
+			ice_for_each_txq(vsi, i) {
 				ice_free_tx_ring(vsi->tx_rings[i]);
 				*vsi->tx_rings[i] = tx_rings[i];
 			}
@@ -2720,7 +2720,7 @@ process_link:
 		}
 
 		if (rx_rings) {
-			for (i = 0; i < vsi->alloc_rxq; i++) {
+			ice_for_each_rxq(vsi, i) {
 				ice_free_rx_ring(vsi->rx_rings[i]);
 				/* copy the real tail offset */
 				rx_rings[i].tail = vsi->rx_rings[i]->tail;
@@ -2744,7 +2744,7 @@ process_link:
 free_tx:
 	/* error cleanup if the Rx allocations failed after getting Tx */
 	if (tx_rings) {
-		for (i = 0; i < vsi->alloc_txq; i++)
+		ice_for_each_txq(vsi, i)
 			ice_free_tx_ring(&tx_rings[i]);
 		devm_kfree(&pf->pdev->dev, tx_rings);
 	}
-- 
2.25.1

