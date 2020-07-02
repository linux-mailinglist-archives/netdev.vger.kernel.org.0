Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95701211921
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgGBBbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729192AbgGBB03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD1420899;
        Thu,  2 Jul 2020 01:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653189;
        bh=tdq/pSImsj8wbS1K54WzGZDd6FUgFcwxktbu9Tbo1o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l74SrLSGP5+0AWy4vUUmUu9BLQ0pBbeJpCv+AfMT4w2D5tjUwKmruMvuj47t2j9ZZ
         6O6T2yRNO17wqGrpM1yRaevTry3dMHxVIVy8p+Dg569ADkuJ4KQidvNrfaVwzZe/k0
         swet1zbqFXR0dx1e3LUNd7MKXhGkFSeaoBtI6DSY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/27] ixgbe: protect ring accesses with READ- and WRITE_ONCE
Date:   Wed,  1 Jul 2020 21:25:59 -0400
Message-Id: <20200702012615.2701532-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

[ Upstream commit f140ad9fe2ae16f385f8fe4dc9cf67bb4c51d794 ]

READ_ONCE should be used when reading rings prior to accessing the
statistics pointer. Introduce this as well as the corresponding WRITE_ONCE
usage when allocating and freeing the rings, to ensure protected access.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 12 ++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 14 +++++++++++---
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index d361f570ca37b..952630cb882c2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -923,7 +923,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		ring->queue_index = txr_idx;
 
 		/* assign ring to adapter */
-		adapter->tx_ring[txr_idx] = ring;
+		WRITE_ONCE(adapter->tx_ring[txr_idx], ring);
 
 		/* update count and index */
 		txr_count--;
@@ -950,7 +950,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		set_ring_xdp(ring);
 
 		/* assign ring to adapter */
-		adapter->xdp_ring[xdp_idx] = ring;
+		WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
 
 		/* update count and index */
 		xdp_count--;
@@ -993,7 +993,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		ring->queue_index = rxr_idx;
 
 		/* assign ring to adapter */
-		adapter->rx_ring[rxr_idx] = ring;
+		WRITE_ONCE(adapter->rx_ring[rxr_idx], ring);
 
 		/* update count and index */
 		rxr_count--;
@@ -1022,13 +1022,13 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
 
 	ixgbe_for_each_ring(ring, q_vector->tx) {
 		if (ring_is_xdp(ring))
-			adapter->xdp_ring[ring->queue_index] = NULL;
+			WRITE_ONCE(adapter->xdp_ring[ring->queue_index], NULL);
 		else
-			adapter->tx_ring[ring->queue_index] = NULL;
+			WRITE_ONCE(adapter->tx_ring[ring->queue_index], NULL);
 	}
 
 	ixgbe_for_each_ring(ring, q_vector->rx)
-		adapter->rx_ring[ring->queue_index] = NULL;
+		WRITE_ONCE(adapter->rx_ring[ring->queue_index], NULL);
 
 	adapter->q_vector[v_idx] = NULL;
 	napi_hash_del(&q_vector->napi);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7d723b70fcf6d..4243ff4ec4b1d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7005,7 +7005,10 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
 	}
 
 	for (i = 0; i < adapter->num_rx_queues; i++) {
-		struct ixgbe_ring *rx_ring = adapter->rx_ring[i];
+		struct ixgbe_ring *rx_ring = READ_ONCE(adapter->rx_ring[i]);
+
+		if (!rx_ring)
+			continue;
 		non_eop_descs += rx_ring->rx_stats.non_eop_descs;
 		alloc_rx_page += rx_ring->rx_stats.alloc_rx_page;
 		alloc_rx_page_failed += rx_ring->rx_stats.alloc_rx_page_failed;
@@ -7026,15 +7029,20 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
 	packets = 0;
 	/* gather some stats to the adapter struct that are per queue */
 	for (i = 0; i < adapter->num_tx_queues; i++) {
-		struct ixgbe_ring *tx_ring = adapter->tx_ring[i];
+		struct ixgbe_ring *tx_ring = READ_ONCE(adapter->tx_ring[i]);
+
+		if (!tx_ring)
+			continue;
 		restart_queue += tx_ring->tx_stats.restart_queue;
 		tx_busy += tx_ring->tx_stats.tx_busy;
 		bytes += tx_ring->stats.bytes;
 		packets += tx_ring->stats.packets;
 	}
 	for (i = 0; i < adapter->num_xdp_queues; i++) {
-		struct ixgbe_ring *xdp_ring = adapter->xdp_ring[i];
+		struct ixgbe_ring *xdp_ring = READ_ONCE(adapter->xdp_ring[i]);
 
+		if (!xdp_ring)
+			continue;
 		restart_queue += xdp_ring->tx_stats.restart_queue;
 		tx_busy += xdp_ring->tx_stats.tx_busy;
 		bytes += xdp_ring->stats.bytes;
-- 
2.25.1

