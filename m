Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6615F869
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfGDMnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:43:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:48071 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727271AbfGDMnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:43:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 05:43:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,451,1557212400"; 
   d="scan'208";a="315855018"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.32.218])
  by orsmga004.jf.intel.com with ESMTP; 04 Jul 2019 05:43:11 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v3 4/6] ixgbe: add support for AF_XDP need_wakup feature
Date:   Thu,  4 Jul 2019 14:42:12 +0200
Message-Id: <1562244134-19069-5-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562244134-19069-1-git-send-email-magnus.karlsson@intel.com>
References: <1562244134-19069-1-git-send-email-magnus.karlsson@intel.com>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index e598af9..3fbc4e4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -547,6 +547,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	q_vector->rx.total_packets += total_rx_packets;
 	q_vector->rx.total_bytes += total_rx_bytes;
 
+	if (xsk_umem_uses_might_sleep(rx_ring->xsk_umem)) {
+		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
+			xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
+		else
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
+
+		return (int)total_rx_packets;
+	}
 	return failure ? budget : (int)total_rx_packets;
 }
 
@@ -689,6 +697,14 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 		xsk_umem_complete_tx(umem, xsk_frames);
 
 	xmit_done = ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
+
+	if (xsk_umem_uses_might_sleep(tx_ring->xsk_umem)) {
+		if (tx_ring->next_to_clean == tx_ring->next_to_use)
+			xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
+		else
+			xsk_clear_tx_need_wakeup(tx_ring->xsk_umem);
+	}
+
 	return budget > 0 && xmit_done;
 }
 
-- 
2.7.4

