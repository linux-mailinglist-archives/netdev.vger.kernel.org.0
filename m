Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F5FEEB0B
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbfKDVXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:23:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:13954 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbfKDVXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:23:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:23:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219715284"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:23:49 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 3/7] ixgbe: Make use of cpumask_local_spread to improve RSS locality
Date:   Mon,  4 Nov 2019 13:23:44 -0800
Message-Id: <20191104212348.9625-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
References: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

This patch is meant to address locality issues present in the ixgbe driver
when it is loaded on a system supporting multiple NUMA nodes and more CPUs
then the device can map in a 1:1 fashion. Instead of just arbitrarily
mapping itself to CPUs 0-62 it would make much more sense to map itself to
the local CPUs first, and then map itself to any remaining CPUs that might
be used.

The first effect of this is that queue 0 should always be allocated on the
local CPU/NUMA node. This is important as it is the default destination if
a packet doesn't match any existing flow director filter or RSS rule and as
such having it local should help to reduce QPI cross-talk in the event of
an unrecognized traffic type.

In addition this should increase the likelihood of the RSS queues being
allocated and used on CPUs local to the device while the ATR/Flow Director
queues would be able to route traffic directly to the CPU that is likely to
be processing it.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index cc3196ae5aea..fd9f5d41b594 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -832,9 +832,9 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 				int xdp_count, int xdp_idx,
 				int rxr_count, int rxr_idx)
 {
+	int node = dev_to_node(&adapter->pdev->dev);
 	struct ixgbe_q_vector *q_vector;
 	struct ixgbe_ring *ring;
-	int node = NUMA_NO_NODE;
 	int cpu = -1;
 	int ring_count;
 	u8 tcs = adapter->hw_tcs;
@@ -845,10 +845,8 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 	if ((tcs <= 1) && !(adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)) {
 		u16 rss_i = adapter->ring_feature[RING_F_RSS].indices;
 		if (rss_i > 1 && adapter->atr_sample_rate) {
-			if (cpu_online(v_idx)) {
-				cpu = v_idx;
-				node = cpu_to_node(cpu);
-			}
+			cpu = cpumask_local_spread(v_idx, node);
+			node = cpu_to_node(cpu);
 		}
 	}
 
-- 
2.21.0

