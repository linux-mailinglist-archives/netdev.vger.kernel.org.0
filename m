Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5252AD243
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgKJJUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:20:09 -0500
Received: from mga06.intel.com ([134.134.136.31]:56522 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729938AbgKJJUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:20:06 -0500
IronPort-SDR: PzILMtLCSN+zoi6aVzIeZ6PxYXNZDOyhg+UzAI+JQ4gRJCTqR3BUI5IWCipneJkzRNauGEDmNl
 /vMXkQtL8yvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="231571774"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="231571774"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 01:20:04 -0800
IronPort-SDR: gHFsslM869yINAiY2RtRC0+4C4fxRO6hLvhI8SeWC/XCc9T7hGFJAKOK+vS1Ct9lwUKkFwonAh
 GB6PedjX+6EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="354433528"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 10 Nov 2020 01:20:01 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 8C27A5D4; Tue, 10 Nov 2020 11:19:57 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 07/10] thunderbolt: Make it possible to allocate one directional DMA tunnel
Date:   Tue, 10 Nov 2020 12:19:54 +0300
Message-Id: <20201110091957.17472-8-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With DMA tunnels it is possible that the service using it does not
require bi-directional paths so make RX and TX optional (but of course
one of them needs to be set).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
---
 drivers/thunderbolt/tunnel.c | 50 ++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index 829b6ccdd5d4..dcdf9c7a9cae 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -34,9 +34,6 @@
 #define TB_DP_AUX_PATH_OUT		1
 #define TB_DP_AUX_PATH_IN		2
 
-#define TB_DMA_PATH_OUT			0
-#define TB_DMA_PATH_IN			1
-
 static const char * const tb_tunnel_names[] = { "PCI", "DP", "DMA", "USB3" };
 
 #define __TB_TUNNEL_PRINT(level, tunnel, fmt, arg...)                   \
@@ -829,10 +826,10 @@ static void tb_dma_init_path(struct tb_path *path, unsigned int isb,
  * @nhi: Host controller port
  * @dst: Destination null port which the other domain is connected to
  * @transmit_ring: NHI ring number used to send packets towards the
- *		   other domain
+ *		   other domain. Set to %0 if TX path is not needed.
  * @transmit_path: HopID used for transmitting packets
  * @receive_ring: NHI ring number used to receive packets from the
- *		  other domain
+ *		  other domain. Set to %0 if RX path is not needed.
  * @reveive_path: HopID used for receiving packets
  *
  * Return: Returns a tb_tunnel on success or NULL on failure.
@@ -843,10 +840,19 @@ struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 				      int receive_path)
 {
 	struct tb_tunnel *tunnel;
+	size_t npaths = 0, i = 0;
 	struct tb_path *path;
 	u32 credits;
 
-	tunnel = tb_tunnel_alloc(tb, 2, TB_TUNNEL_DMA);
+	if (receive_ring)
+		npaths++;
+	if (transmit_ring)
+		npaths++;
+
+	if (WARN_ON(!npaths))
+		return NULL;
+
+	tunnel = tb_tunnel_alloc(tb, npaths, TB_TUNNEL_DMA);
 	if (!tunnel)
 		return NULL;
 
@@ -856,22 +862,28 @@ struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 
 	credits = tb_dma_credits(nhi);
 
-	path = tb_path_alloc(tb, dst, receive_path, nhi, receive_ring, 0, "DMA RX");
-	if (!path) {
-		tb_tunnel_free(tunnel);
-		return NULL;
+	if (receive_ring) {
+		path = tb_path_alloc(tb, dst, receive_path, nhi, receive_ring, 0,
+				     "DMA RX");
+		if (!path) {
+			tb_tunnel_free(tunnel);
+			return NULL;
+		}
+		tb_dma_init_path(path, TB_PATH_NONE, TB_PATH_SOURCE | TB_PATH_INTERNAL,
+				 credits);
+		tunnel->paths[i++] = path;
 	}
-	tb_dma_init_path(path, TB_PATH_NONE, TB_PATH_SOURCE | TB_PATH_INTERNAL,
-			 credits);
-	tunnel->paths[TB_DMA_PATH_IN] = path;
 
-	path = tb_path_alloc(tb, nhi, transmit_ring, dst, transmit_path, 0, "DMA TX");
-	if (!path) {
-		tb_tunnel_free(tunnel);
-		return NULL;
+	if (transmit_ring) {
+		path = tb_path_alloc(tb, nhi, transmit_ring, dst, transmit_path, 0,
+				     "DMA TX");
+		if (!path) {
+			tb_tunnel_free(tunnel);
+			return NULL;
+		}
+		tb_dma_init_path(path, TB_PATH_SOURCE, TB_PATH_ALL, credits);
+		tunnel->paths[i++] = path;
 	}
-	tb_dma_init_path(path, TB_PATH_SOURCE, TB_PATH_ALL, credits);
-	tunnel->paths[TB_DMA_PATH_OUT] = path;
 
 	return tunnel;
 }
-- 
2.28.0

