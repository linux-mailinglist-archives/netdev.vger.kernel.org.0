Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447C239A674
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhFCQ6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:58:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:13150 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230161AbhFCQ6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:58:43 -0400
IronPort-SDR: ZL9A5FcuDaZMr5Onbxb9PVnAZtM4nDCCQ8c5UrGDiZAQqvB0XfpW3Zu68FlPArSZuOP4imFDQx
 jM6JeX79dYBA==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="265260919"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="265260919"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 09:56:55 -0700
IronPort-SDR: HPvBwh5gFFpaoB6dk+7MrftyONBNw0jcbT4HYZGUSgv0fh/lpWy7CFnIuNCJkOraabV36JvYRW
 wMu+zPQuHeDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="550239156"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2021 09:56:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 8/8] ice: track AF_XDP ZC enabled queues in bitmap
Date:   Thu,  3 Jun 2021 09:59:23 -0700
Message-Id: <20210603165923.1918030-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210603165923.1918030-1-anthony.l.nguyen@intel.com>
References: <20210603165923.1918030-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Commit c7a219048e45 ("ice: Remove xsk_buff_pool from VSI structure")
silently introduced a regression and broke the Tx side of AF_XDP in copy
mode. xsk_pool on ice_ring is set only based on the existence of the XDP
prog on the VSI which in turn picks ice_clean_tx_irq_zc to be executed.
That is not something that should happen for copy mode as it should use
the regular data path ice_clean_tx_irq.

This results in a following splat when xdpsock is run in txonly or l2fwd
scenarios in copy mode:

<snip>
[  106.050195] BUG: kernel NULL pointer dereference, address: 0000000000000030
[  106.057269] #PF: supervisor read access in kernel mode
[  106.062493] #PF: error_code(0x0000) - not-present page
[  106.067709] PGD 0 P4D 0
[  106.070293] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  106.074721] CPU: 61 PID: 0 Comm: swapper/61 Not tainted 5.12.0-rc2+ #45
[  106.081436] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[  106.092027] RIP: 0010:xp_raw_get_dma+0x36/0x50
[  106.096551] Code: 74 14 48 b8 ff ff ff ff ff ff 00 00 48 21 f0 48 c1 ee 30 48 01 c6 48 8b 87 90 00 00 00 48 89 f2 81 e6 ff 0f 00 00 48 c1 ea 0c <48> 8b 04 d0 48 83 e0 fe 48 01 f0 c3 66 66 2e 0f 1f 84 00 00 00 00
[  106.115588] RSP: 0018:ffffc9000d694e50 EFLAGS: 00010206
[  106.120893] RAX: 0000000000000000 RBX: ffff88984b8c8a00 RCX: ffff889852581800
[  106.128137] RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffff88984cd8b800
[  106.135383] RBP: ffff888123b50001 R08: ffff889896800000 R09: 0000000000000800
[  106.142628] R10: 0000000000000000 R11: ffffffff826060c0 R12: 00000000000000ff
[  106.149872] R13: 0000000000000000 R14: 0000000000000040 R15: ffff888123b50018
[  106.157117] FS:  0000000000000000(0000) GS:ffff8897e0f40000(0000) knlGS:0000000000000000
[  106.165332] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.171163] CR2: 0000000000000030 CR3: 000000000560a004 CR4: 00000000007706e0
[  106.178408] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  106.185653] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  106.192898] PKRU: 55555554
[  106.195653] Call Trace:
[  106.198143]  <IRQ>
[  106.200196]  ice_clean_tx_irq_zc+0x183/0x2a0 [ice]
[  106.205087]  ice_napi_poll+0x3e/0x590 [ice]
[  106.209356]  __napi_poll+0x2a/0x160
[  106.212911]  net_rx_action+0xd6/0x200
[  106.216634]  __do_softirq+0xbf/0x29b
[  106.220274]  irq_exit_rcu+0x88/0xc0
[  106.223819]  common_interrupt+0x7b/0xa0
[  106.227719]  </IRQ>
[  106.229857]  asm_common_interrupt+0x1e/0x40
</snip>

Fix this by introducing the bitmap of queues that are zero-copy enabled,
where each bit, corresponding to a queue id that xsk pool is being
configured on, will be set/cleared within ice_xsk_pool_{en,dis}able and
checked within ice_xsk_pool(). The latter is a function used for
deciding which napi poll routine is executed.
Idea is being taken from our other drivers such as i40e and ixgbe.

Fixes: c7a219048e45 ("ice: Remove xsk_buff_pool from VSI structure")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h     |  8 +++++---
 drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.c |  3 +++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e35db3ff583b..2924c67567b8 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -335,6 +335,7 @@ struct ice_vsi {
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
+	unsigned long *af_xdp_zc_qps;	 /* tracks AF_XDP ZC enabled qps */
 	u16 num_xdp_txq;		 /* Used XDP queues */
 	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
 
@@ -547,15 +548,16 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
  */
 static inline struct xsk_buff_pool *ice_xsk_pool(struct ice_ring *ring)
 {
+	struct ice_vsi *vsi = ring->vsi;
 	u16 qid = ring->q_index;
 
 	if (ice_ring_is_xdp(ring))
-		qid -= ring->vsi->num_xdp_txq;
+		qid -= vsi->num_xdp_txq;
 
-	if (!ice_is_xdp_ena_vsi(ring->vsi))
+	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
 		return NULL;
 
-	return xsk_get_pool_from_qid(ring->vsi->netdev, qid);
+	return xsk_get_pool_from_qid(vsi->netdev, qid);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 82e2ce23df3d..7f7653906fce 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -105,8 +105,14 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	if (!vsi->q_vectors)
 		goto err_vectors;
 
+	vsi->af_xdp_zc_qps = bitmap_zalloc(max_t(int, vsi->alloc_txq, vsi->alloc_rxq), GFP_KERNEL);
+	if (!vsi->af_xdp_zc_qps)
+		goto err_zc_qps;
+
 	return 0;
 
+err_zc_qps:
+	devm_kfree(dev, vsi->q_vectors);
 err_vectors:
 	devm_kfree(dev, vsi->rxq_map);
 err_rxq_map:
@@ -288,6 +294,10 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 
 	dev = ice_pf_to_dev(pf);
 
+	if (vsi->af_xdp_zc_qps) {
+		bitmap_free(vsi->af_xdp_zc_qps);
+		vsi->af_xdp_zc_qps = NULL;
+	}
 	/* free the ring and vector containers */
 	if (vsi->q_vectors) {
 		devm_kfree(dev, vsi->q_vectors);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 7228e4d427bc..a1f89ea3c2bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -270,6 +270,7 @@ static int ice_xsk_pool_disable(struct ice_vsi *vsi, u16 qid)
 	if (!pool)
 		return -EINVAL;
 
+	clear_bit(qid, vsi->af_xdp_zc_qps);
 	xsk_pool_dma_unmap(pool, ICE_RX_DMA_ATTR);
 
 	return 0;
@@ -300,6 +301,8 @@ ice_xsk_pool_enable(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	if (err)
 		return err;
 
+	set_bit(qid, vsi->af_xdp_zc_qps);
+
 	return 0;
 }
 
-- 
2.26.2

