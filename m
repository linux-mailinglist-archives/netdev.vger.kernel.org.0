Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7D93DF39D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbhHCRKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:10:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:16898 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237631AbhHCRKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:10:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213466140"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213466140"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:19 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521327135"
Received: from shyamasr-mobl.amr.corp.intel.com ([10.209.65.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:18 -0700
From:   Kishen Maloor <kishen.maloor@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org,
        magnus.karlsson@intel.com
Cc:     Jithu Joseph <jithu.joseph@intel.com>
Subject: [RFC bpf-next 3/5] igc: Launchtime support in XDP Tx ZC path
Date:   Tue,  3 Aug 2021 13:10:04 -0400
Message-Id: <20210803171006.13915-4-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210803171006.13915-1-kishen.maloor@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jithu Joseph <jithu.joseph@intel.com>

Adds Launchtime support in the XDP Zero copy Tx path.

If launchtime is enabled for the ring handling the
packet and if the launch-time data is present, programs
a context descriptor with the launchtime so that NIC
can transmit the packet at the appropriate time.

As for the non-ZC path, txtime info is copied into
skb->tstamp in the XDP layer and the existing Tx path
in the driver has support for honoring that.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 49 +++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b7aab35c1132..336cf6bc0a71 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2582,6 +2582,35 @@ static void igc_update_tx_stats(struct igc_q_vector *q_vector,
 	q_vector->tx.total_packets += packets;
 }
 
+static void igc_launchtm_ctxtdesc(struct igc_ring *tx_ring,
+				  ktime_t txtime)
+{
+	struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
+	struct igc_adv_tx_context_desc *context_desc;
+	u16 i = tx_ring->next_to_use;
+	u32 mss_l4len_idx = 0;
+	u32 type_tucmd = 0;
+
+	context_desc = IGC_TX_CTXTDESC(tx_ring, i);
+
+	i++;
+	tx_ring->next_to_use = (i < tx_ring->count) ? i : 0;
+
+	/* set bits to identify this as an advanced context descriptor */
+	type_tucmd |= IGC_TXD_CMD_DEXT | IGC_ADVTXD_DTYP_CTXT;
+
+	/* For i225, context index must be unique per ring. */
+	if (test_bit(IGC_RING_FLAG_TX_CTX_IDX, &tx_ring->flags))
+		mss_l4len_idx |= tx_ring->reg_idx << 4;
+
+	context_desc->vlan_macip_lens	= 0;
+	context_desc->type_tucmd_mlhl	= cpu_to_le32(type_tucmd);
+	context_desc->mss_l4len_idx	= cpu_to_le32(mss_l4len_idx);
+
+	context_desc->launch_time = igc_tx_launchtime(adapter,
+						      txtime);
+}
+
 static void igc_xdp_xmit_zc(struct igc_ring *ring)
 {
 	struct xsk_buff_pool *pool = ring->xsk_pool;
@@ -2599,11 +2628,25 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 
 	budget = igc_desc_unused(ring);
 
-	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget--) {
+	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget > 2) {
 		u32 cmd_type, olinfo_status;
 		struct igc_tx_buffer *bi;
+		s64 launch_tm = 0;
 		dma_addr_t dma;
 
+		bi = &ring->tx_buffer_info[ring->next_to_use];
+
+		if (ring->launchtime_enable && (xdp_desc.options & XDP_DESC_OPTION_SO_TXTIME)) {
+			launch_tm = xsk_buff_get_txtime(pool, &xdp_desc);
+			if (launch_tm != -1) {
+				budget--;
+				igc_launchtm_ctxtdesc(ring, (ktime_t)launch_tm);
+			}
+		}
+
+		/* re-read ntu as igc_launchtm_ctxtdesc() updates it */
+		ntu = ring->next_to_use;
+
 		cmd_type = IGC_ADVTXD_DTYP_DATA | IGC_ADVTXD_DCMD_DEXT |
 			   IGC_ADVTXD_DCMD_IFCS | IGC_TXD_DCMD |
 			   xdp_desc.len;
@@ -2612,12 +2655,12 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 		dma = xsk_buff_raw_get_dma(pool, xdp_desc.addr);
 		xsk_buff_raw_dma_sync_for_device(pool, dma, xdp_desc.len);
 
+		budget--;
 		tx_desc = IGC_TX_DESC(ring, ntu);
 		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
 		tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
 		tx_desc->read.buffer_addr = cpu_to_le64(dma);
 
-		bi = &ring->tx_buffer_info[ntu];
 		bi->type = IGC_TX_BUFFER_TYPE_XSK;
 		bi->protocol = 0;
 		bi->bytecount = xdp_desc.len;
@@ -2630,9 +2673,9 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 		ntu++;
 		if (ntu == ring->count)
 			ntu = 0;
+		ring->next_to_use = ntu;
 	}
 
-	ring->next_to_use = ntu;
 	if (tx_desc) {
 		igc_flush_tx_descriptors(ring);
 		xsk_tx_release(pool);
-- 
2.24.3 (Apple Git-128)

