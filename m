Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C818F04E2
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390703AbfKESSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:18:24 -0500
Received: from inva021.nxp.com ([92.121.34.21]:50674 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbfKESSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 13:18:23 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F313F200256;
        Tue,  5 Nov 2019 19:18:21 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E5D492001FC;
        Tue,  5 Nov 2019 19:18:21 +0100 (CET)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B1A45205ED;
        Tue,  5 Nov 2019 19:18:21 +0100 (CET)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] gianfar: Maximize Rx buffer size
Date:   Tue,  5 Nov 2019 20:18:21 +0200
Message-Id: <1572977901-31431-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until now the size of a Rx buffer was artificially limited
to 1536B (which happens to be the default, after reset, hardware
value for a Rx buffer). This approach however leaves unused
memory space for Rx packets, since the driver uses a paged
allocation scheme that reserves half a page for each Rx skb.
There's also the inconvenience that frames around 1536 bytes
can get scattered if the limit is slightly exceeded. This limit
can be exceeded even for standard MTU of 1500B traffic, for common
cases like stacked VLANs, or DSA tags.
To address these issues, let's just compute the buffer size
starting from the upper limit of 2KB (half a page) and
subtract the skb overhead and alignment restrictions.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/gianfar.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index f472a6d..432c6a8 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -90,11 +90,11 @@ extern const char gfar_driver_version[];
 #define DEFAULT_RX_LFC_THR  16
 #define DEFAULT_LFC_PTVVAL  4
 
-/* prevent fragmenation by HW in DSA environments */
-#define GFAR_RXB_SIZE roundup(1536 + 8, 64)
-#define GFAR_SKBFRAG_SIZE (RXBUF_ALIGNMENT + GFAR_RXB_SIZE \
-			  + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 #define GFAR_RXB_TRUESIZE 2048
+#define GFAR_SKBFRAG_OVR (RXBUF_ALIGNMENT \
+			  + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+#define GFAR_RXB_SIZE rounddown(GFAR_RXB_TRUESIZE - GFAR_SKBFRAG_OVR, 64)
+#define GFAR_SKBFRAG_SIZE (GFAR_RXB_SIZE + GFAR_SKBFRAG_OVR)
 
 #define TX_RING_MOD_MASK(size) (size-1)
 #define RX_RING_MOD_MASK(size) (size-1)
-- 
2.7.4

