Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F178626F34
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 12:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiKMLMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 06:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiKMLMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 06:12:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0308C13D3B;
        Sun, 13 Nov 2022 03:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668337948; x=1699873948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wuhyGA6FrjRIi/7CVsrc2hpcv6AGAbJKF+GAwVEiQtM=;
  b=1vHCGLSERUgEi7ao68iog3K7dAnu4FD4MlOxhB2tYwvNwsOZFsCAqexI
   yRlE3mHDHTWPF1iAAsfwjuD2a3VyPeIy8QnDLz4j0iaDA7Sso+N4lhAXC
   kzht9/KJMwumQu8TmOrYGevZXF9ELAYIJ/fs2ptPqcQSI1Xk3z1WUjqXg
   3vLEkJWEJ9zYRRYXIZR9zKO5PmnAlghCBbldqw9Vh1pOver3xxmdKn9UR
   NFxm3w9mxARyqr+/rxGrDNHCBol8ZlDJlc35zX0u3u/Ed2DNVBRB/v5K9
   y41oulk2erBxfO8KYRLpTurSdFJO2kbDLZf2gikg+PGV4JbTBD/HwB87z
   w==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="123168938"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2022 04:12:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 13 Nov 2022 04:12:28 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 13 Nov 2022 04:12:25 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/5] net: lan966x: Add support for XDP_TX
Date:   Sun, 13 Nov 2022 12:15:58 +0100
Message-ID: <20221113111559.1028030-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221113111559.1028030-1-horatiu.vultur@microchip.com>
References: <20221113111559.1028030-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 833583f6bbfa6..a177ca499db4e 100644
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
+
 		clear = true;
 	}
 
@@ -534,6 +542,9 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
 			goto allocate_new;
+		case FDMA_TX:
+			lan966x_fdma_rx_advance_dcb(rx);
+			continue;
 		case FDMA_DROP:
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
@@ -655,6 +666,62 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
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
@@ -711,6 +778,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	/* Fill up the buffer */
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
 	next_dcb_buf->skb = skb;
+	next_dcb_buf->page = NULL;
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
index 7bb9098496f60..df7fec361962b 100644
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
@@ -175,6 +177,7 @@ struct lan966x_rx {
 struct lan966x_tx_dcb_buf {
 	struct net_device *dev;
 	struct sk_buff *skb;
+	struct page *page;
 	int len;
 	dma_addr_t dma_addr;
 	bool used;
@@ -360,6 +363,8 @@ bool lan966x_hw_offload(struct lan966x *lan966x, u32 port, struct sk_buff *skb);
 
 void lan966x_ifh_get_src_port(void *ifh, u64 *src_port);
 void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp);
+void lan966x_ifh_set_bypass(void *ifh, u64 bypass);
+void lan966x_ifh_set_port(void *ifh, u64 bypass);
 
 void lan966x_stats_get(struct net_device *dev,
 		       struct rtnl_link_stats64 *stats);
@@ -460,6 +465,9 @@ u32 lan966x_ptp_get_period_ps(void);
 int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
+int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
+			   struct xdp_frame *frame,
+			   struct page *page);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index bab447e79273f..c7dcb9d443ffa 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -39,6 +39,7 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 {
 	struct bpf_prog *xdp_prog = port->xdp_prog;
 	struct lan966x *lan966x = port->lan966x;
+	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -51,6 +52,13 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
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

