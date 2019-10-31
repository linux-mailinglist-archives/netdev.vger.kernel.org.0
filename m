Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31368EAD56
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfJaKXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:23:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36506 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbfJaKXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:23:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 37544280064;
        Thu, 31 Oct 2019 10:23:19 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 31 Oct 2019 10:23:14 +0000
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next v4 1/6] sfc: support encapsulation of xdp_frames in
 efx_tx_buffer
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Message-ID: <c4cb2b0b-ef5f-5d06-a98f-5a52a79494ea@solarflare.com>
Date:   Thu, 31 Oct 2019 10:23:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25012.003
X-TM-AS-Result: No-0.364200-8.000000-10
X-TMASE-MatchedRID: Bb4UMhd8oSWhqGDU6KwoEDCMW7zNwFaIURtSyr9IJuWdzjX37VUcWsiT
        Wug2C4DNl1M7KT9/aqA0uSYsteWBcgihmwiXCMoGPwKTD1v8YV5MkOX0UoduuWOMyb1Ixq8VpIs
        onG6IBJL3r6E0eamPVLdcsksEb7ZAOzpEi4NJ5xP1xv2JHBkcH0T0lGtfbK/pQW6eCaGxKwJ4pq
        O87q5acCDNUEs+GH8s3yKsu6qwUKcX/ky8TX34OqubsOtSWY2QkZOl7WKIImpvmJzqtHKHjwtuK
        BGekqUpOlxBO2IcOBbWk0nQ4NX0AhgFUF08WyGJ2RutfHU9JiQPqyY8fNao6lUNc2D7Sygp4d8q
        xAlWF8CRWYuNJeJdSC/ozfsngTZul4VSsRFgu5cXxY6mau8LG3IJh4dBcU42f4hpTpoBF9JqxGC
        SzFD9Mq9DVtyhkQKh
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.364200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25012.003
X-MDID: 1572517399-5tTajpkePaq9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a field to efx_tx_buffer so that we can track xdp_frames. Add a
flag so that buffers that contain xdp_frames can be identified and
passed to xdp_return_frame.

Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
---
 drivers/net/ethernet/sfc/net_driver.h | 10 ++++++++--
 drivers/net/ethernet/sfc/tx.c         |  2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 284a1b047ac2..7394d901e021 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -27,6 +27,7 @@
 #include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
 #include <net/busy_poll.h>
+#include <net/xdp.h>
 
 #include "enum.h"
 #include "bitfield.h"
@@ -136,7 +137,8 @@ struct efx_special_buffer {
  * struct efx_tx_buffer - buffer state for a TX descriptor
  * @skb: When @flags & %EFX_TX_BUF_SKB, the associated socket buffer to be
  *	freed when descriptor completes
- * @option: When @flags & %EFX_TX_BUF_OPTION, a NIC-specific option descriptor.
+ * @xdpf: When @flags & %EFX_TX_BUF_XDP, the XDP frame information; its @data
+ *	member is the associated buffer to drop a page reference on.
  * @dma_addr: DMA address of the fragment.
  * @flags: Flags for allocation and DMA mapping type
  * @len: Length of this fragment.
@@ -146,7 +148,10 @@ struct efx_special_buffer {
  * Only valid if @unmap_len != 0.
  */
 struct efx_tx_buffer {
-	const struct sk_buff *skb;
+	union {
+		const struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	};
 	union {
 		efx_qword_t option;
 		dma_addr_t dma_addr;
@@ -160,6 +165,7 @@ struct efx_tx_buffer {
 #define EFX_TX_BUF_SKB		2	/* buffer is last part of skb */
 #define EFX_TX_BUF_MAP_SINGLE	8	/* buffer was mapped with dma_map_single() */
 #define EFX_TX_BUF_OPTION	0x10	/* empty buffer for option descriptor */
+#define EFX_TX_BUF_XDP		0x20	/* buffer was sent with XDP */
 
 /**
  * struct efx_tx_queue - An Efx TX queue
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 65e81ec1b314..204aafb3d96a 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -95,6 +95,8 @@ static void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 		netif_vdbg(tx_queue->efx, tx_done, tx_queue->efx->net_dev,
 			   "TX queue %d transmission id %x complete\n",
 			   tx_queue->queue, tx_queue->read_count);
+	} else if (buffer->flags & EFX_TX_BUF_XDP) {
+		xdp_return_frame_rx_napi(buffer->xdpf);
 	}
 
 	buffer->len = 0;
