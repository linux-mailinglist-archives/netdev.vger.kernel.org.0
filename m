Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6E9636B32
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbiKWUbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239147AbiKWUbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:31:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA3E13CEB;
        Wed, 23 Nov 2022 12:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669235248; x=1700771248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dF7aDB2VwyWKLU0Vwp0ficgmb8OQHa7Dy9YaZOLlgUs=;
  b=Of+h8KDoamw41twmAfwA89e5BfAuN19qh+0GGa8Jiy+c1EWFr3SK4VlJ
   ceo89NhlifzWuSYNRZziDMO9piPEyHq+tLfH7IPQB82OltLLlcSCAAarN
   dZ9dFq7wsW27RBWZedaMzD6H4ee2rsTHRIVq8e95G2k7RR/C/NJNcE7ja
   WrrP76FPXKeUs/sIOoc7DibEu5GxO5iBkOCDFXXf12No4PGR3a64OF4JW
   UbW/OkBNEu9qpbT8/xYKCyj/CdT/V/h4I3zM4vGEICvIcHbI0p7XtwmpO
   4xjLa/4r/Px/fPnfpjtZbKdZowVwFzT4FHvNrHJLDRFaqN/R/TMXwZ0Gh
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="190333711"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 13:27:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 13:27:27 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 13:27:24 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 7/7] net: lan966x: Add support for XDP_REDIRECT
Date:   Wed, 23 Nov 2022 21:31:39 +0100
Message-ID: <20221123203139.3828548-8-horatiu.vultur@microchip.com>
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

Extend lan966x XDP support with the action XDP_REDIRECT. This is similar
with the XDP_TX, so a lot of functionality can be reused.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 79 ++++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.c |  1 +
 .../ethernet/microchip/lan966x/lan966x_main.h | 10 ++-
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 29 ++++++-
 4 files changed, 104 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index cd622310385bd..5314c064ceae7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include <linux/bpf.h>
+#include <linux/filter.h>
 
 #include "lan966x_main.h"
 
@@ -390,11 +391,14 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 {
 	struct lan966x_tx *tx = &lan966x->tx;
 	struct lan966x_tx_dcb_buf *dcb_buf;
+	struct xdp_frame_bulk bq;
 	struct lan966x_db *db;
 	unsigned long flags;
 	bool clear = false;
 	int i;
 
+	xdp_frame_bulk_init(&bq);
+
 	spin_lock_irqsave(&lan966x->tx_lock, flags);
 	for (i = 0; i < FDMA_DCB_MAX; ++i) {
 		dcb_buf = &tx->dcbs_buf[i];
@@ -419,12 +423,23 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 			if (!dcb_buf->ptp)
 				napi_consume_skb(dcb_buf->data.skb, weight);
 		} else {
-			xdp_return_frame_rx_napi(dcb_buf->data.xdpf);
+			if (dcb_buf->xdp_ndo)
+				dma_unmap_single(lan966x->dev,
+						 dcb_buf->dma_addr,
+						 dcb_buf->len,
+						 DMA_TO_DEVICE);
+
+			if (dcb_buf->xdp_ndo)
+				xdp_return_frame_bulk(dcb_buf->data.xdpf, &bq);
+			else
+				xdp_return_frame_rx_napi(dcb_buf->data.xdpf);
 		}
 
 		clear = true;
 	}
 
+	xdp_flush_frame_bulk(&bq);
+
 	if (clear)
 		lan966x_fdma_wakeup_netdev(lan966x);
 
@@ -531,6 +546,7 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 	int dcb_reload = rx->dcb_index;
 	struct lan966x_rx_dcb *old_dcb;
 	struct lan966x_db *db;
+	bool redirect = false;
 	struct sk_buff *skb;
 	struct page *page;
 	int counter = 0;
@@ -553,6 +569,9 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
 			goto allocate_new;
+		case FDMA_REDIRECT:
+			redirect = true;
+			fallthrough;
 		case FDMA_TX:
 			lan966x_fdma_rx_advance_dcb(rx);
 			continue;
@@ -592,6 +611,9 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 	if (counter < weight && napi_complete_done(napi, counter))
 		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
 
+	if (redirect)
+		xdp_do_flush();
+
 	return counter;
 }
 
@@ -679,7 +701,8 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
 
 int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 			   struct xdp_frame *xdpf,
-			   struct page *page)
+			   struct page *page,
+			   bool dma_map)
 {
 	struct lan966x *lan966x = port->lan966x;
 	struct lan966x_tx_dcb_buf *next_dcb_buf;
@@ -700,24 +723,53 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 	}
 
 	/* Generate new IFH */
-	ifh = page_address(page) + XDP_PACKET_HEADROOM;
-	memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
-	lan966x_ifh_set_bypass(ifh, 1);
-	lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
+	if (dma_map) {
+		if (xdpf->headroom < IFH_LEN_BYTES) {
+			ret = NETDEV_TX_OK;
+			goto out;
+		}
 
-	dma_addr = page_pool_get_dma_addr(page);
-	dma_sync_single_for_device(lan966x->dev, dma_addr + XDP_PACKET_HEADROOM,
-				   xdpf->len + IFH_LEN_BYTES,
-				   DMA_TO_DEVICE);
+		ifh = xdpf->data - IFH_LEN_BYTES;
+		memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
+		lan966x_ifh_set_bypass(ifh, 1);
+		lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
+
+		dma_addr = dma_map_single(lan966x->dev,
+					  xdpf->data - IFH_LEN_BYTES,
+					  xdpf->len + IFH_LEN_BYTES,
+					  DMA_TO_DEVICE);
+		if (dma_mapping_error(lan966x->dev, dma_addr)) {
+			ret = NETDEV_TX_OK;
+			goto out;
+		}
 
-	/* Setup next dcb */
-	lan966x_fdma_tx_setup_dcb(tx, next_to_use, xdpf->len + IFH_LEN_BYTES,
-				  dma_addr + XDP_PACKET_HEADROOM);
+		/* Setup next dcb */
+		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
+					  xdpf->len + IFH_LEN_BYTES,
+					  dma_addr);
+	} else {
+		ifh = page_address(page) + XDP_PACKET_HEADROOM;
+		memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
+		lan966x_ifh_set_bypass(ifh, 1);
+		lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
+
+		dma_addr = page_pool_get_dma_addr(page);
+		dma_sync_single_for_device(lan966x->dev,
+					   dma_addr + XDP_PACKET_HEADROOM,
+					   xdpf->len + IFH_LEN_BYTES,
+					   DMA_TO_DEVICE);
+
+		/* Setup next dcb */
+		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
+					  xdpf->len + IFH_LEN_BYTES,
+					  dma_addr + XDP_PACKET_HEADROOM);
+	}
 
 	/* Fill up the buffer */
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
 	next_dcb_buf->use_skb = false;
 	next_dcb_buf->data.xdpf = xdpf;
+	next_dcb_buf->xdp_ndo = dma_map;
 	next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
 	next_dcb_buf->dma_addr = dma_addr;
 	next_dcb_buf->used = true;
@@ -790,6 +842,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
 	next_dcb_buf->use_skb = true;
 	next_dcb_buf->data.skb = skb;
+	next_dcb_buf->xdp_ndo = false;
 	next_dcb_buf->len = skb->len;
 	next_dcb_buf->dma_addr = dma_addr;
 	next_dcb_buf->used = true;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 0b7707306da26..0aed244826d39 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -469,6 +469,7 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_eth_ioctl			= lan966x_port_ioctl,
 	.ndo_setup_tc			= lan966x_tc_setup,
 	.ndo_bpf			= lan966x_xdp,
+	.ndo_xdp_xmit			= lan966x_xdp_xmit,
 };
 
 bool lan966x_netdevice_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 3c18fcec51629..a0170a3fb9760 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -106,12 +106,14 @@ enum macaccess_entry_type {
  * FDMA_ERROR, something went wrong, stop getting more frames
  * FDMA_DROP, frame is dropped, but continue to get more frames
  * FDMA_TX, frame is given to TX, but continue to get more frames
+ * FDMA_REDIRECT, frame is given to TX, but continue to get more frames
  */
 enum lan966x_fdma_action {
 	FDMA_PASS = 0,
 	FDMA_ERROR,
 	FDMA_DROP,
 	FDMA_TX,
+	FDMA_REDIRECT,
 };
 
 struct lan966x_port;
@@ -185,6 +187,7 @@ struct lan966x_tx_dcb_buf {
 	u32 used : 1;
 	u32 ptp : 1;
 	u32 use_skb : 1;
+	u32 xdp_ndo : 1;
 };
 
 struct lan966x_tx {
@@ -470,7 +473,8 @@ int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
 int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
 			   struct xdp_frame *frame,
-			   struct page *page);
+			   struct page *page,
+			   bool dma_map);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
@@ -568,6 +572,10 @@ int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int lan966x_xdp_run(struct lan966x_port *port,
 		    struct page *page,
 		    u32 data_len);
+int lan966x_xdp_xmit(struct net_device *dev,
+		     int n,
+		     struct xdp_frame **frames,
+		     u32 flags);
 bool lan966x_xdp_present(struct lan966x *lan966x);
 static inline bool lan966x_xdp_port_present(struct lan966x_port *port)
 {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index 8996110a0846a..2e6f486ec67d7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -50,6 +50,28 @@ int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+int lan966x_xdp_xmit(struct net_device *dev,
+		     int n,
+		     struct xdp_frame **frames,
+		     u32 flags)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	int nxmit = 0;
+
+	for (int i = 0; i < n; ++i) {
+		struct xdp_frame *xdpf = frames[i];
+		int err;
+
+		err = lan966x_fdma_xmit_xdpf(port, xdpf, NULL, true);
+		if (err)
+			break;
+
+		nxmit++;
+	}
+
+	return nxmit;
+}
+
 int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 {
 	struct bpf_prog *xdp_prog = port->xdp_prog;
@@ -72,8 +94,13 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 		if (!xdpf)
 			return FDMA_DROP;
 
-		return lan966x_fdma_xmit_xdpf(port, xdpf, page) ?
+		return lan966x_fdma_xmit_xdpf(port, xdpf, page, false) ?
 		       FDMA_DROP : FDMA_TX;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(port->dev, &xdp, xdp_prog))
+			return FDMA_DROP;
+
+		return FDMA_REDIRECT;
 	default:
 		bpf_warn_invalid_xdp_action(port->dev, xdp_prog, act);
 		fallthrough;
-- 
2.38.0

