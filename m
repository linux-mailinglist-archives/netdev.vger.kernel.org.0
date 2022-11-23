Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC45636B22
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239931AbiKWUbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239868AbiKWUbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:31:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FAE8CBAD;
        Wed, 23 Nov 2022 12:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669235245; x=1700771245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HTcLJvf8d0BVSvPmRlwJBDvPtNNdNQAuk/heYBi/Ckc=;
  b=yGHo3BMff8McFoC3IpFRtyD1dxg2gK5V5PmhvuGSnEhzG3rsNR0LzuHP
   6dQbr0BZ03x+fealmyEA7OMlY7WLU1v3zdN0vfmczf/nF2p142gMHLjCn
   thJpuz1O9ymoyL9NWP5vSa/FNUz0O+QUh+yXWYYaCmRD8Nb7EWFBKL6BT
   csg9w8NZwK5Y5zHt7Uxm+JBC2WrkumT5E2wErWYtJCU/HFuyq8kzfSRCq
   f/q/nOwS8F+KBC+PLLvo0TDfOB+cbnbbWOAZwApgcbqZ30Cqk0FO7dCEq
   2fC0y9JrOzLk5wptEWpwHwfuyZ1peCG9OnWDWFWVi0mpPrR48WLOeFcKU
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="190301302"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 13:27:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 13:27:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 13:27:21 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 6/7] net: lan966x: Add support for XDP_TX
Date:   Wed, 23 Nov 2022 21:31:38 +0100
Message-ID: <20221123203139.3828548-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
References: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend lan966x XDP support with the action XDP_TX. In this case when the
received buffer needs to execute XDP_TX, the buffer will be moved to the
TX buffers. So a new RX buffer will be allocated.
When the TX finish with the frame, it would give back the buffer to the
page pool.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 79 +++++++++++++++++--
 .../ethernet/microchip/lan966x/lan966x_main.c |  4 +-
 .../ethernet/microchip/lan966x/lan966x_main.h | 13 ++-
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  8 ++
 4 files changed, 94 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index bc30c31c43602..cd622310385bd 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -410,12 +410,17 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
 
 		dcb_buf->used = false;
-		dma_unmap_single(lan966x->dev,
-				 dcb_buf->dma_addr,
-				 dcb_buf->len,
-				 DMA_TO_DEVICE);
-		if (!dcb_buf->ptp)
-			dev_kfree_skb_any(dcb_buf->skb);
+		if (dcb_buf->use_skb) {
+			dma_unmap_single(lan966x->dev,
+					 dcb_buf->dma_addr,
+					 dcb_buf->len,
+					 DMA_TO_DEVICE);
+
+			if (!dcb_buf->ptp)
+				napi_consume_skb(dcb_buf->data.skb, weight);
+		} else {
+			xdp_return_frame_rx_napi(dcb_buf->data.xdpf);
+		}
 
 		clear = true;
 	}
@@ -548,6 +553,9 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
 			goto allocate_new;
+		case FDMA_TX:
+			lan966x_fdma_rx_advance_dcb(rx);
+			continue;
 		case FDMA_DROP:
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
@@ -669,6 +677,62 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
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
+
+	/* Setup next dcb */
+	lan966x_fdma_tx_setup_dcb(tx, next_to_use, xdpf->len + IFH_LEN_BYTES,
+				  dma_addr + XDP_PACKET_HEADROOM);
+
+	/* Fill up the buffer */
+	next_dcb_buf = &tx->dcbs_buf[next_to_use];
+	next_dcb_buf->use_skb = false;
+	next_dcb_buf->data.xdpf = xdpf;
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
@@ -724,7 +788,8 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 
 	/* Fill up the buffer */
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
-	next_dcb_buf->skb = skb;
+	next_dcb_buf->use_skb = true;
+	next_dcb_buf->data.skb = skb;
 	next_dcb_buf->len = skb->len;
 	next_dcb_buf->dma_addr = dma_addr;
 	next_dcb_buf->used = true;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 42be5d0f1f015..0b7707306da26 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -302,13 +302,13 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 }
 
-static void lan966x_ifh_set_bypass(void *ifh, u64 bypass)
+void lan966x_ifh_set_bypass(void *ifh, u64 bypass)
 {
 	packing(ifh, &bypass, IFH_POS_BYPASS + IFH_WID_BYPASS - 1,
 		IFH_POS_BYPASS, IFH_LEN * 4, PACK, 0);
 }
 
-static void lan966x_ifh_set_port(void *ifh, u64 bypass)
+void lan966x_ifh_set_port(void *ifh, u64 bypass)
 {
 	packing(ifh, &bypass, IFH_POS_DSTS + IFH_WID_DSTS - 1,
 		IFH_POS_DSTS, IFH_LEN * 4, PACK, 0);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 81c0b11097ce2..3c18fcec51629 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -105,11 +105,13 @@ enum macaccess_entry_type {
  * FDMA_PASS, frame is valid and can be used
  * FDMA_ERROR, something went wrong, stop getting more frames
  * FDMA_DROP, frame is dropped, but continue to get more frames
+ * FDMA_TX, frame is given to TX, but continue to get more frames
  */
 enum lan966x_fdma_action {
 	FDMA_PASS = 0,
 	FDMA_ERROR,
 	FDMA_DROP,
+	FDMA_TX,
 };
 
 struct lan966x_port;
@@ -175,10 +177,14 @@ struct lan966x_rx {
 struct lan966x_tx_dcb_buf {
 	dma_addr_t dma_addr;
 	struct net_device *dev;
-	struct sk_buff *skb;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	} data;
 	u32 len;
 	u32 used : 1;
 	u32 ptp : 1;
+	u32 use_skb : 1;
 };
 
 struct lan966x_tx {
@@ -360,6 +366,8 @@ bool lan966x_hw_offload(struct lan966x *lan966x, u32 port, struct sk_buff *skb);
 
 void lan966x_ifh_get_src_port(void *ifh, u64 *src_port);
 void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp);
+void lan966x_ifh_set_bypass(void *ifh, u64 bypass);
+void lan966x_ifh_set_port(void *ifh, u64 bypass);
 
 void lan966x_stats_get(struct net_device *dev,
 		       struct rtnl_link_stats64 *stats);
@@ -460,6 +468,9 @@ u32 lan966x_ptp_get_period_ps(void);
 int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
+int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
+			   struct xdp_frame *frame,
+			   struct page *page);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index ba7aa6df9d0e6..8996110a0846a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -54,6 +54,7 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 {
 	struct bpf_prog *xdp_prog = port->xdp_prog;
 	struct lan966x *lan966x = port->lan966x;
+	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -66,6 +67,13 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 	switch (act) {
 	case XDP_PASS:
 		return FDMA_PASS;
+	case XDP_TX:
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		if (!xdpf)
+			return FDMA_DROP;
+
+		return lan966x_fdma_xmit_xdpf(port, xdpf, page) ?
+		       FDMA_DROP : FDMA_TX;
 	default:
 		bpf_warn_invalid_xdp_action(port->dev, xdp_prog, act);
 		fallthrough;
-- 
2.38.0

