Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7933C5CC8C
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 11:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfGBJWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 05:22:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:2907 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGBJWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 05:22:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 02:22:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,442,1557212400"; 
   d="scan'208";a="315171717"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.32.218])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2019 02:22:29 -0700
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
Subject: [PATCH bpf-next v2 3/6] i40e: add support for AF_XDP need_wakup feature
Date:   Tue,  2 Jul 2019 11:21:25 +0200
Message-Id: <1562059288-26773-4-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562059288-26773-1-git-send-email-magnus.karlsson@intel.com>
References: <1562059288-26773-1-git-send-email-magnus.karlsson@intel.com>
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
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index d0ff5d8..18de7b6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -626,6 +626,15 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
+
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
 
@@ -761,6 +770,13 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
 out_xmit:
 	xmit_done = i40e_xmit_zc(tx_ring, budget);
 
+	if (xsk_umem_uses_might_sleep(tx_ring->xsk_umem)) {
+		if (tx_ring->next_to_clean == tx_ring->next_to_use)
+			xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
+		else
+			xsk_clear_tx_need_wakeup(tx_ring->xsk_umem);
+	}
+
 	return work_done && xmit_done;
 }
 
-- 
2.7.4

