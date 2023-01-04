Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761D965CE22
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjADIRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbjADIRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:17:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872F11743D
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 00:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672820222; x=1704356222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J+zpa2BqWk+tRHhzXfuLbyvdPdX5Y4wgcNMLso1xyu8=;
  b=OSjk/L8RKcXbmjeXZtaLY6PMEC9ACv9DUGEO2jqddRrcgH0rrSlgzml9
   XvCfnfSbhCg/VXJwz9zF3xDHovipd/3UqQJqwOxQRgeYyfxCPRex/zo1O
   9BJUGC1HQpIz+2rxmMvlD5ijWL1nZaOfCstcToB706BcEFfwUrDpujg7U
   PSA7BlZrRua0c2aTGZQZjubzRalIv7kz2nXsw2oHBCJCGHEixB57kCoG4
   HGE3zEEBwFQ0aXqStuw6YvRTFDV/aCAEhLSdVqAQkt6+l0AKWYceymIJR
   SGWxp87W2DrW/oj19L2O3Dio2V2qxrpLj/xskRLnexm5Zx26YTgOcdyHZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="319581799"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="319581799"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 00:17:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="983832975"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="983832975"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jan 2023 00:16:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id D0D81220; Wed,  4 Jan 2023 10:17:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 3/3] net: thunderbolt: Add tracepoints
Date:   Wed,  4 Jan 2023 10:17:31 +0200
Message-Id: <20230104081731.45928-4-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
References: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are useful when debugging various performance issues.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt/Makefile |   5 +-
 drivers/net/thunderbolt/main.c   |  21 +++++
 drivers/net/thunderbolt/trace.c  |  10 +++
 drivers/net/thunderbolt/trace.h  | 141 +++++++++++++++++++++++++++++++
 4 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/thunderbolt/trace.c
 create mode 100644 drivers/net/thunderbolt/trace.h

diff --git a/drivers/net/thunderbolt/Makefile b/drivers/net/thunderbolt/Makefile
index dd644c8775d9..e81c2a4849f0 100644
--- a/drivers/net/thunderbolt/Makefile
+++ b/drivers/net/thunderbolt/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_USB4_NET) := thunderbolt_net.o
-thunderbolt_net-objs := main.o
+thunderbolt_net-objs := main.o trace.o
+
+# Tracepoints need to know where to find trace.h
+CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index bd0c2af1172d..26ef3706445e 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -23,6 +23,8 @@
 
 #include <net/ip6_checksum.h>
 
+#include "trace.h"
+
 /* Protocol timeouts in ms */
 #define TBNET_LOGIN_DELAY	4500
 #define TBNET_LOGIN_TIMEOUT	500
@@ -353,6 +355,8 @@ static void tbnet_free_buffers(struct tbnet_ring *ring)
 			size = TBNET_RX_PAGE_SIZE;
 		}
 
+		trace_tbnet_free_frame(i, tf->page, tf->frame.buffer_phy, dir);
+
 		if (tf->frame.buffer_phy)
 			dma_unmap_page(dma_dev, tf->frame.buffer_phy, size,
 				       dir);
@@ -526,6 +530,9 @@ static int tbnet_alloc_rx_buffers(struct tbnet *net, unsigned int nbuffers)
 		tf->frame.buffer_phy = dma_addr;
 		tf->dev = net->dev;
 
+		trace_tbnet_alloc_rx_frame(index, tf->page, dma_addr,
+					   DMA_FROM_DEVICE);
+
 		tb_ring_rx(ring->ring, &tf->frame);
 
 		ring->prod++;
@@ -602,6 +609,8 @@ static int tbnet_alloc_tx_buffers(struct tbnet *net)
 		tf->frame.callback = tbnet_tx_callback;
 		tf->frame.sof = TBIP_PDF_FRAME_START;
 		tf->frame.eof = TBIP_PDF_FRAME_END;
+
+		trace_tbnet_alloc_tx_frame(i, tf->page, dma_addr, DMA_TO_DEVICE);
 	}
 
 	ring->cons = 0;
@@ -832,12 +841,16 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
 
 		hdr = page_address(page);
 		if (!tbnet_check_frame(net, tf, hdr)) {
+			trace_tbnet_invalid_rx_ip_frame(hdr->frame_size,
+				hdr->frame_id, hdr->frame_index, hdr->frame_count);
 			__free_pages(page, TBNET_RX_PAGE_ORDER);
 			dev_kfree_skb_any(net->skb);
 			net->skb = NULL;
 			continue;
 		}
 
+		trace_tbnet_rx_ip_frame(hdr->frame_size, hdr->frame_id,
+					hdr->frame_index, hdr->frame_count);
 		frame_size = le32_to_cpu(hdr->frame_size);
 
 		skb = net->skb;
@@ -871,6 +884,7 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
 
 		if (last) {
 			skb->protocol = eth_type_trans(skb, net->dev);
+			trace_tbnet_rx_skb(skb);
 			napi_gro_receive(&net->napi, skb);
 			net->skb = NULL;
 		}
@@ -990,6 +1004,8 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
 		for (i = 0; i < frame_count; i++) {
 			hdr = page_address(frames[i]->page);
 			hdr->frame_count = cpu_to_le32(frame_count);
+			trace_tbnet_tx_ip_frame(hdr->frame_size, hdr->frame_id,
+						hdr->frame_index, hdr->frame_count);
 			dma_sync_single_for_device(dma_dev,
 				frames[i]->frame.buffer_phy,
 				tbnet_frame_size(frames[i]), DMA_TO_DEVICE);
@@ -1054,6 +1070,8 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
 		len = le32_to_cpu(hdr->frame_size) - offset;
 		wsum = csum_partial(dest, len, wsum);
 		hdr->frame_count = cpu_to_le32(frame_count);
+		trace_tbnet_tx_ip_frame(hdr->frame_size, hdr->frame_id,
+					hdr->frame_index, hdr->frame_count);
 
 		offset = 0;
 	}
@@ -1096,6 +1114,8 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
 	bool unmap = false;
 	void *dest;
 
+	trace_tbnet_tx_skb(skb);
+
 	nframes = DIV_ROUND_UP(data_len, TBNET_MAX_PAYLOAD_SIZE);
 	if (tbnet_available_buffers(&net->tx_ring) < nframes) {
 		netif_stop_queue(net->dev);
@@ -1202,6 +1222,7 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
 	net->stats.tx_packets++;
 	net->stats.tx_bytes += skb->len;
 
+	trace_tbnet_consume_skb(skb);
 	dev_consume_skb_any(skb);
 
 	return NETDEV_TX_OK;
diff --git a/drivers/net/thunderbolt/trace.c b/drivers/net/thunderbolt/trace.c
new file mode 100644
index 000000000000..937d92826730
--- /dev/null
+++ b/drivers/net/thunderbolt/trace.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tracepoints for Thunderbolt/USB4 networking driver
+ *
+ * Copyright (C) 2022, Intel Corporation
+ * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
+ */
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/drivers/net/thunderbolt/trace.h b/drivers/net/thunderbolt/trace.h
new file mode 100644
index 000000000000..bb1e2cbe7477
--- /dev/null
+++ b/drivers/net/thunderbolt/trace.h
@@ -0,0 +1,141 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Tracepoints for Thunderbolt/USB4 networking driver
+ *
+ * Copyright (C) 2022, Intel Corporation
+ * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM thunderbolt_net
+
+#if !defined(__TRACE_THUNDERBOLT_NET_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __TRACE_THUNDERBOLT_NET_H
+
+#include <linux/dma-direction.h>
+#include <linux/skbuff.h>
+#include <linux/tracepoint.h>
+
+#define DMA_DATA_DIRECTION_NAMES			\
+	{ DMA_BIDIRECTIONAL, "DMA_BIDIRECTIONAL" },	\
+	{ DMA_TO_DEVICE, "DMA_TO_DEVICE" },		\
+	{ DMA_FROM_DEVICE, "DMA_FROM_DEVICE" },		\
+	{ DMA_NONE, "DMA_NONE" }
+
+DECLARE_EVENT_CLASS(tbnet_frame,
+	TP_PROTO(unsigned int index, const void *page, dma_addr_t phys,
+		 enum dma_data_direction dir),
+	TP_ARGS(index, page, phys, dir),
+	TP_STRUCT__entry(
+		__field(unsigned int, index)
+		__field(const void *, page)
+		__field(dma_addr_t, phys)
+		__field(enum dma_data_direction, dir)
+	),
+	TP_fast_assign(
+		__entry->index = index;
+		__entry->page = page;
+		__entry->phys = phys;
+		__entry->dir = dir;
+	),
+	TP_printk("index=%u page=%p phys=%pad dir=%s",
+		  __entry->index, __entry->page, &__entry->phys,
+		__print_symbolic(__entry->dir, DMA_DATA_DIRECTION_NAMES))
+);
+
+DEFINE_EVENT(tbnet_frame, tbnet_alloc_rx_frame,
+	TP_PROTO(unsigned int index, const void *page, dma_addr_t phys,
+		 enum dma_data_direction dir),
+	TP_ARGS(index, page, phys, dir)
+);
+
+DEFINE_EVENT(tbnet_frame, tbnet_alloc_tx_frame,
+	TP_PROTO(unsigned int index, const void *page, dma_addr_t phys,
+		 enum dma_data_direction dir),
+	TP_ARGS(index, page, phys, dir)
+);
+
+DEFINE_EVENT(tbnet_frame, tbnet_free_frame,
+	TP_PROTO(unsigned int index, const void *page, dma_addr_t phys,
+		 enum dma_data_direction dir),
+	TP_ARGS(index, page, phys, dir)
+);
+
+DECLARE_EVENT_CLASS(tbnet_ip_frame,
+	TP_PROTO(u32 size, u32 id, u32 index, u32 count),
+	TP_ARGS(size, id, index, count),
+	TP_STRUCT__entry(
+		__field(u32, size)
+		__field(u32, id)
+		__field(u32, index)
+		__field(u32, count)
+	),
+	TP_fast_assign(
+		__entry->size = le32_to_cpu(size);
+		__entry->id = le32_to_cpu(id);
+		__entry->index = le32_to_cpu(index);
+		__entry->count = le32_to_cpu(count);
+	),
+	TP_printk("id=%u size=%u index=%u count=%u",
+		  __entry->id, __entry->size, __entry->index, __entry->count)
+);
+
+DEFINE_EVENT(tbnet_ip_frame, tbnet_rx_ip_frame,
+	TP_PROTO(u32 size, u32 id, u32 index, u32 count),
+	TP_ARGS(size, id, index, count)
+);
+
+DEFINE_EVENT(tbnet_ip_frame, tbnet_invalid_rx_ip_frame,
+	TP_PROTO(u32 size, u32 id, u32 index, u32 count),
+	TP_ARGS(size, id, index, count)
+);
+
+DEFINE_EVENT(tbnet_ip_frame, tbnet_tx_ip_frame,
+	TP_PROTO(u32 size, u32 id, u32 index, u32 count),
+	TP_ARGS(size, id, index, count)
+);
+
+DECLARE_EVENT_CLASS(tbnet_skb,
+	TP_PROTO(const struct sk_buff *skb),
+	TP_ARGS(skb),
+	TP_STRUCT__entry(
+		__field(const void *, addr)
+		__field(unsigned int, len)
+		__field(unsigned int, data_len)
+		__field(unsigned int, nr_frags)
+	),
+	TP_fast_assign(
+		__entry->addr = skb;
+		__entry->len = skb->len;
+		__entry->data_len = skb->data_len;
+		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
+	),
+	TP_printk("skb=%p len=%u data_len=%u nr_frags=%u",
+		  __entry->addr, __entry->len, __entry->data_len,
+		  __entry->nr_frags)
+);
+
+DEFINE_EVENT(tbnet_skb, tbnet_rx_skb,
+	TP_PROTO(const struct sk_buff *skb),
+	TP_ARGS(skb)
+);
+
+DEFINE_EVENT(tbnet_skb, tbnet_tx_skb,
+	TP_PROTO(const struct sk_buff *skb),
+	TP_ARGS(skb)
+);
+
+DEFINE_EVENT(tbnet_skb, tbnet_consume_skb,
+	TP_PROTO(const struct sk_buff *skb),
+	TP_ARGS(skb)
+);
+
+#endif /* _TRACE_THUNDERBOLT_NET_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+#include <trace/define_trace.h>
-- 
2.35.1

