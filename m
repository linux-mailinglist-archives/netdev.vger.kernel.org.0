Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DC48CCC4
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfHNH2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:28:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:60179 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfHNH2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 03:28:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 00:28:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="327923067"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.52.109])
  by orsmga004.jf.intel.com with ESMTP; 14 Aug 2019 00:28:18 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com,
        maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, jonathan.lemon@gmail.com,
        kiran.patil@intel.com, axboe@kernel.dk,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v4 4/8] ixgbe: add support for AF_XDP need_wakeup feature
Date:   Wed, 14 Aug 2019 09:27:19 +0200
Message-Id: <1565767643-4908-5-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the need_wakeup feature of AF_XDP. If the
application has told the kernel that it might sleep using the new bind
flag XDP_USE_NEED_WAKEUP, the driver will then set this flag if it has
no more buffers on the NIC Rx ring and yield to the application. For
Tx, it will set the flag if it has no outstanding Tx completion
interrupts and return to the application.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index e598af9..9a28d98 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -547,6 +547,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	q_vector->rx.total_packets += total_rx_packets;
 	q_vector->rx.total_bytes += total_rx_bytes;
 
+	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
+		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
+			xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
+		else
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
+
+		return (int)total_rx_packets;
+	}
 	return failure ? budget : (int)total_rx_packets;
 }
 
@@ -615,6 +623,8 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	if (tx_desc) {
 		ixgbe_xdp_ring_update_tail(xdp_ring);
 		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
+		if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem))
+			xsk_clear_tx_need_wakeup(xdp_ring->xsk_umem);
 	}
 
 	return !!budget && work_done;
@@ -688,7 +698,15 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	if (xsk_frames)
 		xsk_umem_complete_tx(umem, xsk_frames);
 
+	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem)) {
+		if (tx_ring->next_to_clean == tx_ring->next_to_use)
+			xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
+		else
+			xsk_clear_tx_need_wakeup(tx_ring->xsk_umem);
+	}
+
 	xmit_done = ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
+
 	return budget > 0 && xmit_done;
 }
 
-- 
2.7.4

