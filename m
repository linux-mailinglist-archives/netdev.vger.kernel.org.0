Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101C562C2AD
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiKPPfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKPPe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:34:59 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74B71180B;
        Wed, 16 Nov 2022 07:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668612898; x=1700148898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wj5K9Vlpjbs5N2B8PCfWrnygyNn/3oGRftL7tuGMhMM=;
  b=ECg/2dNILWto8srrBJNIK5eLBDpiD4OPdb/e0W61WnV4rn5toJhfnOTl
   nlp/BXtK6Z8op91wClOoaAOimZq5mZv2Q3jdCCGBUQTVYeCmWfjZCRM62
   kRwu0EBRGo8fJEoUpwpHJMmvHhbiaSRnBeKhx7Xd8eDCDyp89kxtIvt9u
   1WdR7IsudcQp1pefu0jWIHX5aHivKiJQOFAPuIgPmm7Tjxdd0s0yhJRCQ
   i8K3zAZyClzOyEJIQ6AvfG9DLYQ0s4qFn3DpU/hM4SfLYOUo2qX229EQB
   Cpea8RIYvPKPbsTNgggjqM7KlXNaeJnePOfA34tsCXtqPPdSh2m2j81aM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="398859749"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="398859749"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 07:34:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="745093734"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="745093734"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2022 07:34:55 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AGFYsEF029828;
        Wed, 16 Nov 2022 15:34:54 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 4/5] net: lan966x: Add support for XDP_TX
Date:   Wed, 16 Nov 2022 16:34:18 +0100
Message-Id: <20221116153418.3389630-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115214456.1456856-5-horatiu.vultur@microchip.com>
References: <20221115214456.1456856-1-horatiu.vultur@microchip.com> <20221115214456.1456856-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Tue, 15 Nov 2022 22:44:55 +0100

Extend lan966x XDP support with the action XDP_TX. In this case when the
received buffer needs to execute XDP_TX, the buffer will be moved to the
TX buffers. So a new RX buffer will be allocated.
When the TX finish with the frame, it would release completely this
buffer.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 78 +++++++++++++++++--
 .../ethernet/microchip/lan966x/lan966x_main.c |  4 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  8 ++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  8 ++
 4 files changed, 91 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 384ed34197d58..c2e56233a8da5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -394,13 +394,21 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
 
 		dcb_buf->used = false;
-		dma_unmap_single(lan966x->dev,
-				 dcb_buf->dma_addr,
-				 dcb_buf->len,
-				 DMA_TO_DEVICE);
-		if (!dcb_buf->ptp)
+		if (dcb_buf->skb)
+			dma_unmap_single(lan966x->dev,
+					 dcb_buf->dma_addr,
+					 dcb_buf->len,
+					 DMA_TO_DEVICE);
+
+		if (dcb_buf->skb && !dcb_buf->ptp)
 			dev_kfree_skb_any(dcb_buf->skb);
 
+		if (dcb_buf->page) {
+			page_pool_release_page(lan966x->rx.page_pool,
+					       dcb_buf->page);
+			put_page(dcb_buf->page);
+		}

Hmm, that's not really correct.

For skb, you need to unmap + free, true (BPW, just use
napi_consume_skb()).
For %XDP_TX, as you use Page Pool, you don't need to unmap, but you
need to do xdp_return_frame{,_bulk}. Plus, as Tx is being done here
directly from an Rx NAPI polling cycle, xdp_return_frame_rx_napi()
is usually used. Anyway, each of xdp_return_frame()'s variants will
call page_pool_put_full_page() for you.
For %XDP_REDIRECT, as you don't know the source of the XDP frame,
you need to unmap it (as it was previously mapped in
::ndo_xdp_xmit()), plus call xdp_return_frame{,_bulk} to free the
XDP frame. Note that _rx_napi() variant is not applicable here.

That description might be confusing, so you can take a look at the
already existing code[0] to get the idea. I think this piece shows
the expected logics rather well.

+
 		clear = true;
 	}
 
@@ -532,6 +540,9 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
 			goto allocate_new;
+		case FDMA_TX:
+			lan966x_fdma_rx_advance_dcb(rx);
+			continue;
 		case FDMA_DROP:
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
@@ -653,6 +664,62 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
 	tx->last_in_use = next_to_use;
 }
 
+int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
+			   struct xdp_frame *xdpf,
+			   struct page *page)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_tx_dcb_buf *next_dcb_buf;
+	struct lan966x_tx *tx = &lan966x->tx;
+	dma_addr_t dma_addr;
+	int next_to_use;
+	__be32 *ifh;
+	int ret = 0;
+
+	spin_lock(&lan966x->tx_lock);
+
+	/* Get next index */
+	next_to_use = lan966x_fdma_get_next_dcb(tx);
+	if (next_to_use < 0) {
+		netif_stop_queue(port->dev);
+		ret = NETDEV_TX_BUSY;
+		goto out;
+	}
+
+	/* Generate new IFH */
+	ifh = page_address(page) + XDP_PACKET_HEADROOM;
+	memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
+	lan966x_ifh_set_bypass(ifh, 1);
+	lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
+
+	dma_addr = page_pool_get_dma_addr(page);
+	dma_sync_single_for_device(lan966x->dev, dma_addr + XDP_PACKET_HEADROOM,
+				   xdpf->len + IFH_LEN_BYTES,
+				   DMA_TO_DEVICE);

Also not correct. This page was mapped with %DMA_FROM_DEVICE in the
Rx code, now you sync it for the opposite.
Most drivers in case of XDP enabled create Page Pools with ::dma_dir
set to %DMA_BIDIRECTIONAL. Now you would need only to sync it here
with the same direction (bidir) and that's it.

+
+	/* Setup next dcb */
+	lan966x_fdma_tx_setup_dcb(tx, next_to_use, xdpf->len + IFH_LEN_BYTES,
+				  dma_addr + XDP_PACKET_HEADROOM);
+
+	/* Fill up the buffer */
+	next_dcb_buf = &tx->dcbs_buf[next_to_use];
+	next_dcb_buf->skb = NULL;
+	next_dcb_buf->page = page;
+	next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
+	next_dcb_buf->dma_addr = dma_addr;
+	next_dcb_buf->used = true;
+	next_dcb_buf->ptp = false;
+	next_dcb_buf->dev = port->dev;
+
+	/* Start the transmission */
+	lan966x_fdma_tx_start(tx, next_to_use);
+
+out:
+	spin_unlock(&lan966x->tx_lock);
+
+	return ret;
+}
+
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
@@ -709,6 +776,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	/* Fill up the buffer */
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
 	next_dcb_buf->skb = skb;
+	next_dcb_buf->page = NULL;
 	next_dcb_buf->len = skb->len;
 	next_dcb_buf->dma_addr = dma_addr;
 	next_dcb_buf->used = true;

[...]

-- 
2.38.0

Thanks,
Olek
