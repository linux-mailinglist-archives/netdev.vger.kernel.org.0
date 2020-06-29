Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A120D819
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732424AbgF2Tfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:35:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57466 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730701AbgF2Tfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:35:41 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CDFFA20D3B0
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:37:04 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BE3C42008F;
        Mon, 29 Jun 2020 13:37:04 +0000 (UTC)
Received: from us4-mdac16-66.at1.mdlocal (unknown [10.110.50.157])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BB5A48009B;
        Mon, 29 Jun 2020 13:37:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5B0FE4007A;
        Mon, 29 Jun 2020 13:37:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 219F230006B;
        Mon, 29 Jun 2020 13:37:04 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:36:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 15/15] sfc: extend common GRO interface to support
 CHECKSUM_COMPLETE
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <d5bd28fc-f121-d408-e6d7-813d108bee31@solarflare.com>
Date:   Mon, 29 Jun 2020 14:36:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25510.003
X-TM-AS-Result: No-6.994900-8.000000-10
X-TMASE-MatchedRID: 4RYRT8I4pwkp6sCplNKGM0jBb8q+S/OCGIMg4+U4kbXg91xayX4L8wFK
        sDvaUiE9K4QmH9zcA5EaNleJxx1YlAUcfW/oedmqnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQ0HT
        LLuKQyhg67b/kwWwP0e+/tLvk1Pm5CWJZymXNAFdIkDvKxvWt/n6NJZ3HRhRTjFFYmmGGytxNqd
        2Y/0f53uLzNWBegCW2RYvisGWbbS+No+PRbWqfRLI7zVffJqTze0g/mWveFMSobMJzccnrXoslf
        +CuQmdtD2p0OuxwxJ3L2fQYZX/JpH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.994900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437824-MQSpTpL4Onx5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 will use CHECKSUM_COMPLETE, but will also make use of
 efx_rx_packet_gro(), thus needs to be able to pass the checksum value
 into that function.
Drivers for older NICs pass in a csum of 0 to get the old semantics (use
 the RX flags for CHECKSUM_UNNECESSARY marking).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/rx.c        |  2 +-
 drivers/net/ethernet/sfc/rx_common.c | 11 ++++++++---
 drivers/net/ethernet/sfc/rx_common.h |  2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index a201a30b5d29..c73b933a9101 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -411,7 +411,7 @@ void __efx_rx_packet(struct efx_channel *channel)
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EFX_RX_PKT_TCP) && !channel->type->receive_skb)
-		efx_rx_packet_gro(channel, rx_buf, channel->rx_pkt_n_frags, eh);
+		efx_rx_packet_gro(channel, rx_buf, channel->rx_pkt_n_frags, eh, 0);
 	else
 		efx_rx_deliver(channel, eh, rx_buf, channel->rx_pkt_n_frags);
 out:
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 9927e9ecbbb4..fb77c7bbe4af 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -510,7 +510,7 @@ void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic)
  */
 void
 efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
-		  unsigned int n_frags, u8 *eh)
+		  unsigned int n_frags, u8 *eh, __wsum csum)
 {
 	struct napi_struct *napi = &channel->napi_str;
 	struct efx_nic *efx = channel->efx;
@@ -528,8 +528,13 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 	if (efx->net_dev->features & NETIF_F_RXHASH)
 		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
-	skb->ip_summed = ((rx_buf->flags & EFX_RX_PKT_CSUMMED) ?
-			  CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
+	if (csum) {
+		skb->csum = csum;
+		skb->ip_summed = CHECKSUM_COMPLETE;
+	} else {
+		skb->ip_summed = ((rx_buf->flags & EFX_RX_PKT_CSUMMED) ?
+				  CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
+	}
 	skb->csum_level = !!(rx_buf->flags & EFX_RX_PKT_CSUM_LEVEL);
 
 	for (;;) {
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index 3508dd316570..1672d74f30e2 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -67,7 +67,7 @@ void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic);
 
 void
 efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
-		  unsigned int n_frags, u8 *eh);
+		  unsigned int n_frags, u8 *eh, __wsum csum);
 
 struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx);
 struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id);
