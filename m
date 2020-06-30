Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF65B20F42F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbgF3MMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:12:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54194 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387454AbgF3MMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:12:01 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5BDAE200A8;
        Tue, 30 Jun 2020 12:12:00 +0000 (UTC)
Received: from us4-mdac16-4.at1.mdlocal (unknown [10.110.49.155])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5946A800A3;
        Tue, 30 Jun 2020 12:12:00 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.6])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EAB56100070;
        Tue, 30 Jun 2020 12:11:59 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B477DB0006F;
        Tue, 30 Jun 2020 12:11:59 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:11:55 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 06/14] sfc: commonise efx_sync_rx_buffer()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <a24c7a15-1106-d729-b343-8b614f35771a@solarflare.com>
Date:   Tue, 30 Jun 2020 13:11:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-2.817000-8.000000-10
X-TMASE-MatchedRID: i/wEjRUPNdw2jeY+Udg/IiNHByyOpYYCeouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEfGzuoVn0Vs6PQi9XuOWoOC5Ara2x6EWaVnzlQiaE21pn+sA9+u1YLUdmDSBYfnJR0iS
        XG6dWPltI7SJ3puSczPMVfR6ftjhyCWJZymXNAFfN+qWlu2ZxaFfot81W1F7ImyiLZetSf8nJ4y
        0wP1A6AEl4W8WVUOR/joczmuoPCq282n7Zd4+UgqF3emSwFdKg4SIH9obs/OYjrQ4EF2+AYladX
        xz39LQshEiMiWktaVrkAfuaaNhoZjwz5NiQARnDy3QqIPj9h6UXxY6mau8LG3IJh4dBcU42f4hp
        TpoBF9JqxGCSzFD9Mq9DVtyhkQKh
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.817000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519120-684b-3KR0NUb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ef100 RX path will also need to DMA-sync RX buffers.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/rx.c        | 8 --------
 drivers/net/ethernet/sfc/rx_common.h | 9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index c73b933a9101..59a43d586967 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -40,14 +40,6 @@
 #define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
 				      EFX_RX_USR_BUF_SIZE)
 
-static inline void efx_sync_rx_buffer(struct efx_nic *efx,
-				      struct efx_rx_buffer *rx_buf,
-				      unsigned int len)
-{
-	dma_sync_single_for_cpu(&efx->pci_dev->dev, rx_buf->dma_addr, len,
-				DMA_FROM_DEVICE);
-}
-
 static void efx_rx_packet__check_len(struct efx_rx_queue *rx_queue,
 				     struct efx_rx_buffer *rx_buf,
 				     int len)
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index 1672d74f30e2..207ccd8ba062 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -57,6 +57,15 @@ void efx_init_rx_buffer(struct efx_rx_queue *rx_queue,
 			unsigned int page_offset,
 			u16 flags);
 void efx_unmap_rx_buffer(struct efx_nic *efx, struct efx_rx_buffer *rx_buf);
+
+static inline void efx_sync_rx_buffer(struct efx_nic *efx,
+				      struct efx_rx_buffer *rx_buf,
+				      unsigned int len)
+{
+	dma_sync_single_for_cpu(&efx->pci_dev->dev, rx_buf->dma_addr, len,
+				DMA_FROM_DEVICE);
+}
+
 void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
 			 struct efx_rx_buffer *rx_buf,
 			 unsigned int num_bufs);

