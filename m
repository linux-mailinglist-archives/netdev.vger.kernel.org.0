Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A60512809F
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTQ1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:27:20 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33004 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727362AbfLTQ1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:27:20 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BBE5C68007A;
        Fri, 20 Dec 2019 16:27:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 20 Dec
 2019 16:27:13 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 2/2] sfc: Include XDP packet headroom in buffer step size.
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <83c50994-18de-1d8f-67ce-b2322d226338@solarflare.com>
Message-ID: <bb198e68-df88-e91a-2516-26cffdbac7da@solarflare.com>
Date:   Fri, 20 Dec 2019 16:27:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <83c50994-18de-1d8f-67ce-b2322d226338@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25114.003
X-TM-AS-Result: No-3.047800-8.000000-10
X-TMASE-MatchedRID: JbtIZinIcnI2jeY+Udg/Irb55TietSt6+eBf9ovw8I1psnGGIgWMmYbH
        6cTCX9B6m8hxAIEws9piucu0gIo06DA9KOtcb1F9UyxW4vmvLt16i696PjRPiB3RY4pGTCyHeWg
        68DhoEkmt2gtuWr1Lmtr+D80ZNbcycGCkjn3GWnYjRwcsjqWGArEhhZOhPCz3uWYx8s2K6Rphz/
        HivrpiI84WZ2e8JNtqg3BGMlB+x2PnmDJKPFuKfodlc1JaOB1TfS0Ip2eEHny+qryzYw2E8CKve
        Q4wmYdMdgkRR8OiM/9YF3qW3Je6+4I6gp8lN4acYsngetMXOZnmN1XBQy6gQ5Z8bmrvg131aOSK
        iFL/ZjX4Fv7FxFFlHYPfpEB25qYdIU7pBEDRPOQb4f74IlmD7DHCqV7rv9Y1QDMFuK2P9FjtoWa
        vEW7HRE3Z8jKJCdR04mqLFh5vfmx+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.047800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25114.003
X-MDID: 1576859239-F9ts4Lhl_YBl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Charles McLachlan <cmclachlan@solarflare.com>

Correct a mismatch between rx_page_buf_step and the actual step size
used when filling buffer pages.

This patch fixes the page overrun that occured when the MTU was set to
anything bigger than 1692.

Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/rx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index ef52b24ad9e7..c29bf862a94c 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -96,11 +96,12 @@ static inline void efx_sync_rx_buffer(struct efx_nic *efx,
 
 void efx_rx_config_page_split(struct efx_nic *efx)
 {
-	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + efx->rx_ip_align,
+	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + efx->rx_ip_align +
+				      XDP_PACKET_HEADROOM,
 				      EFX_RX_BUF_ALIGNMENT);
 	efx->rx_bufs_per_page = efx->rx_buffer_order ? 1 :
 		((PAGE_SIZE - sizeof(struct efx_rx_page_state)) /
-		(efx->rx_page_buf_step + XDP_PACKET_HEADROOM));
+		efx->rx_page_buf_step);
 	efx->rx_buffer_truesize = (PAGE_SIZE << efx->rx_buffer_order) /
 		efx->rx_bufs_per_page;
 	efx->rx_pages_per_batch = DIV_ROUND_UP(EFX_RX_PREFERRED_BATCH,
@@ -190,14 +191,13 @@ static int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
 		page_offset = sizeof(struct efx_rx_page_state);
 
 		do {
-			page_offset += XDP_PACKET_HEADROOM;
-			dma_addr += XDP_PACKET_HEADROOM;
-
 			index = rx_queue->added_count & rx_queue->ptr_mask;
 			rx_buf = efx_rx_buffer(rx_queue, index);
-			rx_buf->dma_addr = dma_addr + efx->rx_ip_align;
+			rx_buf->dma_addr = dma_addr + efx->rx_ip_align +
+					   XDP_PACKET_HEADROOM;
 			rx_buf->page = page;
-			rx_buf->page_offset = page_offset + efx->rx_ip_align;
+			rx_buf->page_offset = page_offset + efx->rx_ip_align +
+					      XDP_PACKET_HEADROOM;
 			rx_buf->len = efx->rx_dma_len;
 			rx_buf->flags = 0;
 			++rx_queue->added_count;
