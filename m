Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3D6E93EB
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbjDTMN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbjDTMN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:13:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F04F5BBC;
        Thu, 20 Apr 2023 05:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681992772; x=1713528772;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NRLHbDsBJVpzWvjpCk2Jx+iKC43ICF+rlOYgCNSiUaM=;
  b=EboPsy9/3OWENkYyNUxLFr7Ly5iy7lIDdf5tH07BtCDnsy9I6jWMbqYL
   k25QuZi7xYrSbqgM5EzJzGcHWYe9agJGZsaiQOXvVxm8BxKSP/hm8WXXR
   ebNCmBy0H4GbXx0xyyjKTxLj+URRr6RzFltay/1MczLkgXoNLUeBrqh3c
   ADNtSACbOzU+EKsfdxjrfj4ihPBT7g+DTJ2dCqIhkAguXojkBxF39hlM8
   ZlLAF599nUufvRRt9khKlXAVrZmPMFd3XDvbxHs+6/YLc7Kz7SVhn/iiu
   2x0cZlwzPc0QzzWf7SqnBG/a5IObEx767ez+6cEFLBcPRjVpb2RMAfp83
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,212,1677567600"; 
   d="scan'208";a="209953526"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2023 05:12:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 20 Apr 2023 05:12:08 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Thu, 20 Apr 2023 05:12:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <maciej.fijalkowski@intel.com>,
        <alexandr.lobakin@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Don't use xdp_frame when action is XDP_TX
Date:   Thu, 20 Apr 2023 14:11:52 +0200
Message-ID: <20230420121152.2737625-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the action of an xdp program was XDP_TX, lan966x was creating
a xdp_frame and use this one to send the frame back. But it is also
possible to send back the frame without needing a xdp_frame, because
it possible to send it back using the page.
And then once the frame is transmitted is possible to use directly
page_pool_recycle_direct as lan966x is using page pools.
This would save some CPU usage on this path.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 35 +++++++++++--------
 .../ethernet/microchip/lan966x/lan966x_main.h |  2 ++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 11 +++---
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 2ed76bb61a731..7947259e67e4e 100644
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
@@ -702,6 +704,7 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
 int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 			   struct xdp_frame *xdpf,
 			   struct page *page,
+			   u32 len,
 			   bool dma_map)
 {
 	struct lan966x *lan966x = port->lan966x;
@@ -722,6 +725,15 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 		goto out;
 	}
 
+	/* Fill up the buffer */
+	next_dcb_buf = &tx->dcbs_buf[next_to_use];
+	next_dcb_buf->use_skb = false;
+	next_dcb_buf->xdp_ndo = dma_map;
+	next_dcb_buf->len = len + IFH_LEN_BYTES;
+	next_dcb_buf->used = true;
+	next_dcb_buf->ptp = false;
+	next_dcb_buf->dev = port->dev;
+
 	/* Generate new IFH */
 	if (dma_map) {
 		if (xdpf->headroom < IFH_LEN_BYTES) {
@@ -736,16 +748,18 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 
 		dma_addr = dma_map_single(lan966x->dev,
 					  xdpf->data - IFH_LEN_BYTES,
-					  xdpf->len + IFH_LEN_BYTES,
+					  len + IFH_LEN_BYTES,
 					  DMA_TO_DEVICE);
 		if (dma_mapping_error(lan966x->dev, dma_addr)) {
 			ret = NETDEV_TX_OK;
 			goto out;
 		}
 
+		next_dcb_buf->data.xdpf = xdpf;
+
 		/* Setup next dcb */
 		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
-					  xdpf->len + IFH_LEN_BYTES,
+					  len + IFH_LEN_BYTES,
 					  dma_addr);
 	} else {
 		ifh = page_address(page) + XDP_PACKET_HEADROOM;
@@ -756,25 +770,18 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
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
index 851afb0166b19..59da35a2c93d4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -243,6 +243,7 @@ struct lan966x_tx_dcb_buf {
 	union {
 		struct sk_buff *skb;
 		struct xdp_frame *xdpf;
+		struct page *page;
 	} data;
 	u32 len;
 	u32 used : 1;
@@ -544,6 +545,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
 int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 			   struct xdp_frame *frame,
 			   struct page *page,
+			   u32 len,
 			   bool dma_map);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index 2e6f486ec67d7..a8ad1f4e431cb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -62,7 +62,7 @@ int lan966x_xdp_xmit(struct net_device *dev,
 		struct xdp_frame *xdpf = frames[i];
 		int err;
 
-		err = lan966x_fdma_xmit_xdpf(port, xdpf, NULL, true);
+		err = lan966x_fdma_xmit_xdpf(port, xdpf, NULL, xdpf->len, true);
 		if (err)
 			break;
 
@@ -76,7 +76,6 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 {
 	struct bpf_prog *xdp_prog = port->xdp_prog;
 	struct lan966x *lan966x = port->lan966x;
-	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -90,11 +89,9 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 	case XDP_PASS:
 		return FDMA_PASS;
 	case XDP_TX:
-		xdpf = xdp_convert_buff_to_frame(&xdp);
-		if (!xdpf)
-			return FDMA_DROP;
-
-		return lan966x_fdma_xmit_xdpf(port, xdpf, page, false) ?
+		return lan966x_fdma_xmit_xdpf(port, NULL, page,
+					      data_len - IFH_LEN_BYTES,
+					      false) ?
 		       FDMA_DROP : FDMA_TX;
 	case XDP_REDIRECT:
 		if (xdp_do_redirect(port->dev, &xdp, xdp_prog))
-- 
2.38.0

