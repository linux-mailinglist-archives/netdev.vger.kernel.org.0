Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9924E078F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387474AbfJVPiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:38:04 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:48382 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730305AbfJVPiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:38:03 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 09884B8005A;
        Tue, 22 Oct 2019 15:38:01 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 22 Oct 2019 16:37:56 +0100
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next 1/6] sfc: support encapsulation of xdp_frames in
 efx_tx_buffer.
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Message-ID: <7eca8299-a6bf-5d47-1815-4d2cfa87c070@solarflare.com>
Date:   Tue, 22 Oct 2019 16:37:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.003
X-TM-AS-Result: No-3.185300-8.000000-10
X-TMASE-MatchedRID: Q/M1H33ihxihqGDU6KwoEDCMW7zNwFaIURtSyr9IJuWdzjX37VUcWsiT
        Wug2C4DNl1M7KT9/aqA0uSYsteWBcgihmwiXCMoGPwKTD1v8YV5MkOX0UoduuWOMyb1Ixq8VpIs
        onG6IBJL3r6E0eamPVLdcsksEb7ZAOzpEi4NJ5xP1xv2JHBkcH0T0lGtfbK/pQW6eCaGxKwJ4pq
        O87q5acCDNUEs+GH8s3yKsu6qwUKcsm617PZ0pZ+LzNWBegCW2XC3N7C7YzreNo+PRbWqfRMprJ
        P8FBOIaKM/YLUgK1bxAdX7FtqXCxVPf/vBv7o/B7Ho/vbykSFMvoPEXhOt7wK3VFtxX24Vk8jAc
        BvHv6uXc/McDGqUEKVMAGgQqc7wytjcNO3CcIFNDgw2OfwbhLKMa5OkNpiHkifsL+6CY4Rll3xQ
        +X3ZmUQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.185300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.003
X-MDID: 1571758682-W0yUKINWmYng
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
index 65e81ec1b314..9905e8952a45 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -95,6 +95,8 @@ static void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 		netif_vdbg(tx_queue->efx, tx_done, tx_queue->efx->net_dev,
 			   "TX queue %d transmission id %x complete\n",
 			   tx_queue->queue, tx_queue->read_count);
+	} else if (buffer->flags & EFX_TX_BUF_XDP) {
+		xdp_return_frame(buffer->xdpf);
 	}
 
 	buffer->len = 0;
