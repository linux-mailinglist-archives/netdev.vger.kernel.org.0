Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA51772FD4
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfGXN0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:26:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:14367 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfGXN0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 09:26:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 06:26:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,303,1559545200"; 
   d="scan'208";a="369295056"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by fmsmga006.fm.intel.com with ESMTP; 24 Jul 2019 06:26:12 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v3 01/11] i40e: simplify Rx buffer recycle
Date:   Wed, 24 Jul 2019 05:10:33 +0000
Message-Id: <20190724051043.14348-2-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190724051043.14348-1-kevin.laatz@intel.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the dma, addr and handle are modified when we reuse Rx buffers
in zero-copy mode. However, this is not required as the inputs to the
function are copies, not the original values themselves. As we use the
copies within the function, we can use the original 'old_bi' values
directly without having to mask and add the headroom.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 32bad014d76c..dfa096db2244 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -420,8 +420,6 @@ static void i40e_reuse_rx_buffer_zc(struct i40e_ring *rx_ring,
 				    struct i40e_rx_buffer *old_bi)
 {
 	struct i40e_rx_buffer *new_bi = &rx_ring->rx_bi[rx_ring->next_to_alloc];
-	unsigned long mask = (unsigned long)rx_ring->xsk_umem->chunk_mask;
-	u64 hr = rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
 	u16 nta = rx_ring->next_to_alloc;
 
 	/* update, and store next to alloc */
@@ -429,14 +427,9 @@ static void i40e_reuse_rx_buffer_zc(struct i40e_ring *rx_ring,
 	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
 
 	/* transfer page from old buffer to new buffer */
-	new_bi->dma = old_bi->dma & mask;
-	new_bi->dma += hr;
-
-	new_bi->addr = (void *)((unsigned long)old_bi->addr & mask);
-	new_bi->addr += hr;
-
-	new_bi->handle = old_bi->handle & mask;
-	new_bi->handle += rx_ring->xsk_umem->headroom;
+	new_bi->dma = old_bi->dma;
+	new_bi->addr = old_bi->addr;
+	new_bi->handle = old_bi->handle;
 
 	old_bi->addr = NULL;
 }
-- 
2.17.1

