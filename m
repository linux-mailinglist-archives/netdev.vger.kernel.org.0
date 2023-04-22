Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E53D6EB9A2
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 16:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjDVO1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 10:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVO1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 10:27:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9018A18E;
        Sat, 22 Apr 2023 07:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682173638; x=1713709638;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZJUYAOJtumkx0anAvSi4mEUPinyG4AUgH/nrR7sE5DU=;
  b=bQyocb5wLOcxdh3Ll7vqig+Zf7XF4NUiE6HZXUJkwZokehN6h+d5O19g
   COg3+RuqK+y62O9Bsjk89fdkcKpW+l+gJ3DCQJZK2iXvTmLQRpGAo2AaC
   EkufigbDa5H9C9XpKQ8mhvSzHiidfKB8zhBUMhGynXJnHD7dydOSkGpjR
   0nIj6ovI1LameQA8L7NI/SWsrPjRdtSctwgfygcoyVsisE6CUnKO3CCjF
   H75+xqOoFeZ0EktblozSU4GyVxwlu4oacyauhste3yV0ptb3Ka9h+MYJ3
   2TVL/zXOr71qxQInuc2e1yAIQjgY8h65aka6GUIkx23fEe7Wrhe4Tgti9
   w==;
X-IronPort-AV: E=Sophos;i="5.99,218,1677567600"; 
   d="scan'208";a="207795273"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2023 07:27:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 22 Apr 2023 07:27:17 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sat, 22 Apr 2023 07:27:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <aleksander.lobakin@intel.com>, <maciej.fijalkowski@intel.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3] lan966x: Don't use xdp_frame when action is XDP_TX
Date:   Sat, 22 Apr 2023 16:23:44 +0200
Message-ID: <20230422142344.3630602-1-horatiu.vultur@microchip.com>
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
v2->v3:
- fix length issue when the XDP action is XDP_REDIRECT, this issue was
  introduced in v2 of this patch series.
- reduce the number of changes by moving back all the assignments to
  next_dcb_buf

v1->v2:
- reduce number of arguments for the function lan966x_fdma_xmit_xdpf,
  as some of them are mutual exclusive, and other can be replaced with
  deduced from the other ones
- update commit message and add statistics for the improvement
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 35 ++++++++++++-------
 .../ethernet/microchip/lan966x/lan966x_main.h |  6 ++--
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 10 ++----
 3 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 2ed76bb61a731..bd72fbc2220f3 100644
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
@@ -722,8 +723,13 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 		goto out;
 	}
 
+	/* Get the next buffer */
+	next_dcb_buf = &tx->dcbs_buf[next_to_use];
+
 	/* Generate new IFH */
-	if (dma_map) {
+	if (!len) {
+		xdpf = ptr;
+
 		if (xdpf->headroom < IFH_LEN_BYTES) {
 			ret = NETDEV_TX_OK;
 			goto out;
@@ -743,11 +749,16 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 			goto out;
 		}
 
+		next_dcb_buf->data.xdpf = xdpf;
+		next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
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
@@ -756,21 +767,21 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 		dma_addr = page_pool_get_dma_addr(page);
 		dma_sync_single_for_device(lan966x->dev,
 					   dma_addr + XDP_PACKET_HEADROOM,
-					   xdpf->len + IFH_LEN_BYTES,
+					   len + IFH_LEN_BYTES,
 					   DMA_TO_DEVICE);
 
+		next_dcb_buf->data.page = page;
+		next_dcb_buf->len = len + IFH_LEN_BYTES;
+
 		/* Setup next dcb */
 		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
-					  xdpf->len + IFH_LEN_BYTES,
+					  len + IFH_LEN_BYTES,
 					  dma_addr + XDP_PACKET_HEADROOM);
 	}
 
 	/* Fill up the buffer */
-	next_dcb_buf = &tx->dcbs_buf[next_to_use];
 	next_dcb_buf->use_skb = false;
-	next_dcb_buf->data.xdpf = xdpf;
-	next_dcb_buf->xdp_ndo = dma_map;
-	next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
+	next_dcb_buf->xdp_ndo = !len;
 	next_dcb_buf->dma_addr = dma_addr;
 	next_dcb_buf->used = true;
 	next_dcb_buf->ptp = false;
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

