Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E311B6EAB56
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjDUNPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjDUNPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:15:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D57A5F0;
        Fri, 21 Apr 2023 06:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682082937; x=1713618937;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kmiOUVgBvjfIs0p4hj+2OzOGUD9EcJfcUGBRPSb0QWE=;
  b=GPRVPDMObKteuhX+d5bqVNEmjAz3TQa+p4F1IT3enbCH3SZmxNm1DgJA
   N7K8HvnY5JCPaK4gDtDTLgsjzUhWUH3P6w8JdOz2wDJuTMfGwZn479wAB
   a0MyfCRisr10wkW/8W3NQWRFCtu4kM8I8jDXNI+4nI3Liy26f6m+mLH4N
   uXZKw426FjEEU2i/OJLQAsrfW7VFsmTKZVA7/V11TuJSqzZxw3ZOuxq32
   78/cnBEgbLcXg4KaoF3FQayJK8QjYW/3KxwjM3O4NIUVpt5hw8XFjGcQo
   rBQ7N3+DA58KM05rVkGb8aJQRAnmMxlt47OZOyq5qBXJBACiTxDDmNCRf
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,214,1677567600"; 
   d="scan'208";a="148298571"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 06:15:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 06:15:11 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 21 Apr 2023 06:15:08 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <alexandr.lobakin@intel.com>, <maciej.fijalkowski@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] lan966x: Don't use xdp_frame when action is XDP_TX
Date:   Fri, 21 Apr 2023 15:14:22 +0200
Message-ID: <20230421131422.3530159-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the action of an xdp program was XDP_TX, lan966x was creating
a xdp_frame and use this one to send the frame back. But it is also
possible to send back the frame without needing a xdp_frame, because
it is possible to send it back using the page.
And then once the frame is transmitted is possible to use directly
page_pool_recycle_direct as lan966x is using page pools.
This would save some CPU usage on this path, which results in higher
number of transmitted frames. Bellow are the statistics:
Frame size:    Improvement:
64                ~8%
256              ~11%
512               ~8%
1000              ~0%
1500              ~0%

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- reduce number of arguments for the function lan966x_fdma_xmit_xdpf,
  as some of them are mutual exclusive, and other can be replaced with
  deduced from the other ones
- update commit message and add statistics for the improvement
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 43 +++++++++++--------
 .../ethernet/microchip/lan966x/lan966x_main.h |  6 +--
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 10 ++---
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 2ed76bb61a731..85c13231e0176 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -390,6 +390,7 @@ static void lan966x_fdma_stop_netdev(struct lan966x *lan966x)
 static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 {
 	struct lan966x_tx *tx = &lan966x->tx;
+	struct lan966x_rx *rx = &lan966x->rx;
 	struct lan966x_tx_dcb_buf *dcb_buf;
 	struct xdp_frame_bulk bq;
 	struct lan966x_db *db;
@@ -432,7 +433,8 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 			if (dcb_buf->xdp_ndo)
 				xdp_return_frame_bulk(dcb_buf->data.xdpf, &bq);
 			else
-				xdp_return_frame_rx_napi(dcb_buf->data.xdpf);
+				page_pool_recycle_direct(rx->page_pool,
+							 dcb_buf->data.page);
 		}
 
 		clear = true;
@@ -699,15 +701,14 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
 	tx->last_in_use = next_to_use;
 }
 
-int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
-			   struct xdp_frame *xdpf,
-			   struct page *page,
-			   bool dma_map)
+int lan966x_fdma_xmit_xdpf(struct lan966x_port *port, void *ptr, u32 len)
 {
 	struct lan966x *lan966x = port->lan966x;
 	struct lan966x_tx_dcb_buf *next_dcb_buf;
 	struct lan966x_tx *tx = &lan966x->tx;
+	struct xdp_frame *xdpf;
 	dma_addr_t dma_addr;
+	struct page *page;
 	int next_to_use;
 	__be32 *ifh;
 	int ret = 0;
@@ -722,8 +723,19 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 		goto out;
 	}
 
+	/* Fill up the buffer */
+	next_dcb_buf = &tx->dcbs_buf[next_to_use];
+	next_dcb_buf->use_skb = false;
+	next_dcb_buf->xdp_ndo = !len;
+	next_dcb_buf->len = len + IFH_LEN_BYTES;
+	next_dcb_buf->used = true;
+	next_dcb_buf->ptp = false;
+	next_dcb_buf->dev = port->dev;
+
 	/* Generate new IFH */
-	if (dma_map) {
+	if (!len) {
+		xdpf = ptr;
+
 		if (xdpf->headroom < IFH_LEN_BYTES) {
 			ret = NETDEV_TX_OK;
 			goto out;
@@ -743,11 +755,15 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 			goto out;
 		}
 
+		next_dcb_buf->data.xdpf = xdpf;
+
 		/* Setup next dcb */
 		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
 					  xdpf->len + IFH_LEN_BYTES,
 					  dma_addr);
 	} else {
+		page = ptr;
+
 		ifh = page_address(page) + XDP_PACKET_HEADROOM;
 		memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
 		lan966x_ifh_set_bypass(ifh, 1);
@@ -756,25 +772,18 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 		dma_addr = page_pool_get_dma_addr(page);
 		dma_sync_single_for_device(lan966x->dev,
 					   dma_addr + XDP_PACKET_HEADROOM,
-					   xdpf->len + IFH_LEN_BYTES,
+					   len + IFH_LEN_BYTES,
 					   DMA_TO_DEVICE);
 
+		next_dcb_buf->data.page = page;
+
 		/* Setup next dcb */
 		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
-					  xdpf->len + IFH_LEN_BYTES,
+					  len + IFH_LEN_BYTES,
 					  dma_addr + XDP_PACKET_HEADROOM);
 	}
 
-	/* Fill up the buffer */
-	next_dcb_buf = &tx->dcbs_buf[next_to_use];
-	next_dcb_buf->use_skb = false;
-	next_dcb_buf->data.xdpf = xdpf;
-	next_dcb_buf->xdp_ndo = dma_map;
-	next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
 	next_dcb_buf->dma_addr = dma_addr;
-	next_dcb_buf->used = true;
-	next_dcb_buf->ptp = false;
-	next_dcb_buf->dev = port->dev;
 
 	/* Start the transmission */
 	lan966x_fdma_tx_start(tx, next_to_use);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 757378516f1fd..27f272831ea5c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -262,6 +262,7 @@ struct lan966x_tx_dcb_buf {
 	union {
 		struct sk_buff *skb;
 		struct xdp_frame *xdpf;
+		struct page *page;
 	} data;
 	u32 len;
 	u32 used : 1;
@@ -593,10 +594,7 @@ int lan966x_ptp_setup_traps(struct lan966x_port *port, struct ifreq *ifr);
 int lan966x_ptp_del_traps(struct lan966x_port *port);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
-int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
-			   struct xdp_frame *frame,
-			   struct page *page,
-			   bool dma_map);
+int lan966x_fdma_xmit_xdpf(struct lan966x_port *port, void *ptr, u32 len);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index 2e6f486ec67d7..9ee61db8690b4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -62,7 +62,7 @@ int lan966x_xdp_xmit(struct net_device *dev,
 		struct xdp_frame *xdpf = frames[i];
 		int err;
 
-		err = lan966x_fdma_xmit_xdpf(port, xdpf, NULL, true);
+		err = lan966x_fdma_xmit_xdpf(port, xdpf, 0);
 		if (err)
 			break;
 
@@ -76,7 +76,6 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 {
 	struct bpf_prog *xdp_prog = port->xdp_prog;
 	struct lan966x *lan966x = port->lan966x;
-	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -90,11 +89,8 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 	case XDP_PASS:
 		return FDMA_PASS;
 	case XDP_TX:
-		xdpf = xdp_convert_buff_to_frame(&xdp);
-		if (!xdpf)
-			return FDMA_DROP;
-
-		return lan966x_fdma_xmit_xdpf(port, xdpf, page, false) ?
+		return lan966x_fdma_xmit_xdpf(port, page,
+					      data_len - IFH_LEN_BYTES) ?
 		       FDMA_DROP : FDMA_TX;
 	case XDP_REDIRECT:
 		if (xdp_do_redirect(port->dev, &xdp, xdp_prog))
-- 
2.38.0

