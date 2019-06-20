Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8F64D44F
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732049AbfFTQx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 12:53:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:16957 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfFTQx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 12:53:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 09:53:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,397,1557212400"; 
   d="scan'208";a="183135141"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.110])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jun 2019 09:53:55 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc:     bpf@vger.kernel.com, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH 05/11] ixgbe: add offset to zca_free
Date:   Thu, 20 Jun 2019 08:39:18 +0000
Message-Id: <20190620083924.1996-6-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620083924.1996-1-kevin.laatz@intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the offset param to for zero_copy_allocator to
ixgbe_zca_free. This change is required to calculate the handle, otherwise,
this function will not work in unaligned chunk mode since we can't easily mask
back to the original handle in unaligned chunk mode.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h | 3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c         | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index d93a690aff74..49702e2a4360 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -33,7 +33,8 @@ struct xdp_umem *ixgbe_xsk_umem(struct ixgbe_adapter *adapter,
 int ixgbe_xsk_umem_setup(struct ixgbe_adapter *adapter, struct xdp_umem *umem,
 			 u16 qid);
 
-void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle);
+void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle,
+		off_t off);
 
 void ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count);
 int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 49536adafe8e..1ec02077ccb2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -268,16 +268,16 @@ static void ixgbe_reuse_rx_buffer_zc(struct ixgbe_ring *rx_ring,
 	obi->skb = NULL;
 }
 
-void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
+void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle,
+		off_t off)
 {
 	struct ixgbe_rx_buffer *bi;
 	struct ixgbe_ring *rx_ring;
-	u64 hr, mask;
+	u64 hr;
 	u16 nta;
 
 	rx_ring = container_of(alloc, struct ixgbe_ring, zca);
 	hr = rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
-	mask = rx_ring->xsk_umem->chunk_mask;
 
 	nta = rx_ring->next_to_alloc;
 	bi = rx_ring->rx_buffer_info;
@@ -285,7 +285,7 @@ void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 	nta++;
 	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
 
-	handle &= mask;
+	handle -= off;
 
 	bi->dma = xdp_umem_get_dma(rx_ring->xsk_umem, handle);
 	bi->dma += hr;
-- 
2.17.1

