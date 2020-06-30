Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F6020F439
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgF3MN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:13:26 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33488 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387509AbgF3MNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:13:25 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E78B820081;
        Tue, 30 Jun 2020 12:13:24 +0000 (UTC)
Received: from us4-mdac16-74.at1.mdlocal (unknown [10.110.50.192])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E4C0B800A3;
        Tue, 30 Jun 2020 12:13:24 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8B03B100076;
        Tue, 30 Jun 2020 12:13:24 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 543A4140055;
        Tue, 30 Jun 2020 12:13:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:13:19 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 09/14] sfc: factor out efx_tx_tso_header_length() and
 understand encapsulation
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <ddebccd7-fbea-b8d5-1a3d-de5d56f63c73@solarflare.com>
Date:   Tue, 30 Jun 2020 13:13:15 +0100
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
X-TM-AS-Result: No-8.029800-8.000000-10
X-TMASE-MatchedRID: llTo18AJfvGXC3sMAGu+n6iUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5rB034o9aD3zF09rZAYZpfOkr0W/BDHWEVfAXPuWnqbj7lmMfLNiukavIf
        NMqvY8HmjkoEn/gUJLYpv+QMT5WBbSODTO7sFJpYuOya45qyEYn0tCKdnhB58vqq8s2MNhPAir3
        kOMJmHTHYJEUfDojP/33fj+sMArfNSleqDFXU3qVu5RcffncpltOPVz3csprQ3pLcnMlHWhctgD
        gNJ6UqhoVfkLFAzcgJ+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.029800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519205-6MMMTCKC_ThT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ef100 will need to check this against NIC limits.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/tx_common.c | 17 +++++++++++++++--
 drivers/net/ethernet/sfc/tx_common.h |  1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 6ac19daa891a..2a058b76d1f0 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -311,6 +311,20 @@ struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 	return buffer;
 }
 
+int efx_tx_tso_header_length(struct sk_buff *skb)
+{
+	size_t header_len;
+
+	if (skb->encapsulation)
+		header_len = skb_inner_transport_header(skb) -
+				skb->data +
+				(inner_tcp_hdr(skb)->doff << 2u);
+	else
+		header_len = skb_transport_header(skb) - skb->data +
+				(tcp_hdr(skb)->doff << 2u);
+	return header_len;
+}
+
 /* Map all data from an SKB for DMA and create descriptors on the queue. */
 int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 		    unsigned int segment_count)
@@ -339,8 +353,7 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 		/* For TSO we need to put the header in to a separate
 		 * descriptor. Map this separately if necessary.
 		 */
-		size_t header_len = skb_transport_header(skb) - skb->data +
-				(tcp_hdr(skb)->doff << 2u);
+		size_t header_len = efx_tx_tso_header_length(skb);
 
 		if (header_len != len) {
 			tx_queue->tso_long_headers++;
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
index 82e2e291317d..cbe995b024a6 100644
--- a/drivers/net/ethernet/sfc/tx_common.h
+++ b/drivers/net/ethernet/sfc/tx_common.h
@@ -34,6 +34,7 @@ void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
 
 struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 				       dma_addr_t dma_addr, size_t len);
+int efx_tx_tso_header_length(struct sk_buff *skb);
 int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 		    unsigned int segment_count);
 

