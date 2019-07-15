Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6F268ED4
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388764AbfGOOJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388746AbfGOOJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:09:49 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8371206B8;
        Mon, 15 Jul 2019 14:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199788;
        bh=yxNacmgHMLHx5/+OIOhdF6pDHJWL60lTeHmUILz1JqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGzW8Mv5ra7e17jZszRujd0YJNT0N6KRDINWz5nrG17CoQxdfcBGpbTizSbKnumXm
         ObEY2+YNdftIh/7dNeg2Fm7h8DANH4cikahvpYD3zm9k3DvEeRovF7Sw1sqFEqU2TG
         DYkUzu3ZNVLMkkgwVDn4fYDPtP2hLaIcRLEpti+4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 106/219] iavf: allow null RX descriptors
Date:   Mon, 15 Jul 2019 10:01:47 -0400
Message-Id: <20190715140341.6443-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit efa14c3985828da3163f5372137cb64d992b0f79 ]

In some circumstances, the hardware can hand us a null receive
descriptor, with no data attached but otherwise valid. Unfortunately,
the driver was ill-equipped to handle such an event, and would stop
processing packets at that point.

To fix this, use the Descriptor Done bit instead of the size to
determine whether or not a descriptor is ready to be processed. Add some
checks to allow for unused buffers.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 9b4d7cec2e18..9cc2a617c9f3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1236,6 +1236,9 @@ static void iavf_add_rx_frag(struct iavf_ring *rx_ring,
 	unsigned int truesize = SKB_DATA_ALIGN(size + iavf_rx_offset(rx_ring));
 #endif
 
+	if (!size)
+		return;
+
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
 			rx_buffer->page_offset, size, truesize);
 
@@ -1260,6 +1263,9 @@ static struct iavf_rx_buffer *iavf_get_rx_buffer(struct iavf_ring *rx_ring,
 {
 	struct iavf_rx_buffer *rx_buffer;
 
+	if (!size)
+		return NULL;
+
 	rx_buffer = &rx_ring->rx_bi[rx_ring->next_to_clean];
 	prefetchw(rx_buffer->page);
 
@@ -1299,6 +1305,8 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 	unsigned int headlen;
 	struct sk_buff *skb;
 
+	if (!rx_buffer)
+		return NULL;
 	/* prefetch first cache line of first page */
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
@@ -1363,6 +1371,8 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 #endif
 	struct sk_buff *skb;
 
+	if (!rx_buffer)
+		return NULL;
 	/* prefetch first cache line of first page */
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
@@ -1398,6 +1408,9 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 static void iavf_put_rx_buffer(struct iavf_ring *rx_ring,
 			       struct iavf_rx_buffer *rx_buffer)
 {
+	if (!rx_buffer)
+		return;
+
 	if (iavf_can_reuse_rx_page(rx_buffer)) {
 		/* hand second half of page back to the ring */
 		iavf_reuse_rx_page(rx_ring, rx_buffer);
@@ -1496,11 +1509,12 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
 		 * verified the descriptor has been written back.
 		 */
 		dma_rmb();
+#define IAVF_RXD_DD BIT(IAVF_RX_DESC_STATUS_DD_SHIFT)
+		if (!iavf_test_staterr(rx_desc, IAVF_RXD_DD))
+			break;
 
 		size = (qword & IAVF_RXD_QW1_LENGTH_PBUF_MASK) >>
 		       IAVF_RXD_QW1_LENGTH_PBUF_SHIFT;
-		if (!size)
-			break;
 
 		iavf_trace(clean_rx_irq, rx_ring, rx_desc, skb);
 		rx_buffer = iavf_get_rx_buffer(rx_ring, size);
@@ -1516,7 +1530,8 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
-			rx_buffer->pagecnt_bias++;
+			if (rx_buffer)
+				rx_buffer->pagecnt_bias++;
 			break;
 		}
 
-- 
2.20.1

