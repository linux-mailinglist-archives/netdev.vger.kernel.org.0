Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1058821197E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgGBBfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgGBBX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF722082F;
        Thu,  2 Jul 2020 01:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653007;
        bh=ORPv43D/MfkF8nCaY6eTl41d5n0TRntKOvuBRXLyLPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGr/jOHaa4V4iXHdx+2xpuIBRNH9nH6Z2TnK7EVMwcMohISwxkp1J35C551ykpU09
         d3L44dcp4ZG0/TRGV/EPxFSI2fdHfg8oBqpm+6BADN/EYcqfilIU6mCP1QPnsyQP8W
         zQ6soI1ix7wvYuChq+ly8QXlnHVC6jJ4xjb2FnnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 26/53] i40e: protect ring accesses with READ- and WRITE_ONCE
Date:   Wed,  1 Jul 2020 21:21:35 -0400
Message-Id: <20200702012202.2700645-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

[ Upstream commit d59e267912cd90b0adf33b4659050d831e746317 ]

READ_ONCE should be used when reading rings prior to accessing the
statistics pointer. Introduce this as well as the corresponding WRITE_ONCE
usage when allocating and freeing the rings, to ensure protected access.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 29 ++++++++++++++-------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2a037ec244b94..80dc5fcb82db7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -439,11 +439,15 @@ static void i40e_get_netdev_stats_struct(struct net_device *netdev,
 		i40e_get_netdev_stats_struct_tx(ring, stats);
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
-			ring++;
+			ring = READ_ONCE(vsi->xdp_rings[i]);
+			if (!ring)
+				continue;
 			i40e_get_netdev_stats_struct_tx(ring, stats);
 		}
 
-		ring++;
+		ring = READ_ONCE(vsi->rx_rings[i]);
+		if (!ring)
+			continue;
 		do {
 			start   = u64_stats_fetch_begin_irq(&ring->syncp);
 			packets = ring->stats.packets;
@@ -787,6 +791,8 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
 		p = READ_ONCE(vsi->tx_rings[q]);
+		if (!p)
+			continue;
 
 		do {
 			start = u64_stats_fetch_begin_irq(&p->syncp);
@@ -800,8 +806,11 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		tx_linearize += p->tx_stats.tx_linearize;
 		tx_force_wb += p->tx_stats.tx_force_wb;
 
-		/* Rx queue is part of the same block as Tx queue */
-		p = &p[1];
+		/* locate Rx ring */
+		p = READ_ONCE(vsi->rx_rings[q]);
+		if (!p)
+			continue;
+
 		do {
 			start = u64_stats_fetch_begin_irq(&p->syncp);
 			packets = p->stats.packets;
@@ -10816,10 +10825,10 @@ static void i40e_vsi_clear_rings(struct i40e_vsi *vsi)
 	if (vsi->tx_rings && vsi->tx_rings[0]) {
 		for (i = 0; i < vsi->alloc_queue_pairs; i++) {
 			kfree_rcu(vsi->tx_rings[i], rcu);
-			vsi->tx_rings[i] = NULL;
-			vsi->rx_rings[i] = NULL;
+			WRITE_ONCE(vsi->tx_rings[i], NULL);
+			WRITE_ONCE(vsi->rx_rings[i], NULL);
 			if (vsi->xdp_rings)
-				vsi->xdp_rings[i] = NULL;
+				WRITE_ONCE(vsi->xdp_rings[i], NULL);
 		}
 	}
 }
@@ -10853,7 +10862,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		if (vsi->back->hw_features & I40E_HW_WB_ON_ITR_CAPABLE)
 			ring->flags = I40E_TXR_FLAGS_WB_ON_ITR;
 		ring->itr_setting = pf->tx_itr_default;
-		vsi->tx_rings[i] = ring++;
+		WRITE_ONCE(vsi->tx_rings[i], ring++);
 
 		if (!i40e_enabled_xdp_vsi(vsi))
 			goto setup_rx;
@@ -10871,7 +10880,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 			ring->flags = I40E_TXR_FLAGS_WB_ON_ITR;
 		set_ring_xdp(ring);
 		ring->itr_setting = pf->tx_itr_default;
-		vsi->xdp_rings[i] = ring++;
+		WRITE_ONCE(vsi->xdp_rings[i], ring++);
 
 setup_rx:
 		ring->queue_index = i;
@@ -10884,7 +10893,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		ring->size = 0;
 		ring->dcb_tc = 0;
 		ring->itr_setting = pf->rx_itr_default;
-		vsi->rx_rings[i] = ring;
+		WRITE_ONCE(vsi->rx_rings[i], ring);
 	}
 
 	return 0;
-- 
2.25.1

