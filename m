Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056F983356
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfHFNx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:53:26 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54138 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfHFNx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:53:26 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 733E3980078;
        Tue,  6 Aug 2019 13:53:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 6 Aug
 2019 06:53:21 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 1/3] sfc: don't score irq moderation points for
 GRO
To:     David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        <linux-net-drivers@solarflare.com>
References: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
Message-ID: <1ccc3c46-b240-413c-39ba-cf9275b588f6@solarflare.com>
Date:   Tue, 6 Aug 2019 14:53:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24824.005
X-TM-AS-Result: No-0.451400-4.000000-10
X-TMASE-MatchedRID: 17aM+gFDWwdYwMQSR3qB3Uf49ONH0RaSlS5IbQ8u3TqzU0R+5DbDbBMb
        ntr5LgIG0+nrETiJLgkFuUksuzAWGsiLtyO0mH+oUharQ9sKnjF6i696PjRPiB3RY4pGTCyHeWg
        68DhoEkmt2gtuWr1LmnVYxiwxDQDxObOMSve0pv9ZlN4HS2qim/QHHbrnZANTmyiLZetSf8nJ4y
        0wP1A6AEl4W8WVUOR/joczmuoPCq2dvJgmn5fVUdKaVPlUqiIZaleqs57bJjeNWvs5LJ62cFgzi
        14CVdzJpmK0osIbJT02NFP4plovglTglCfJSwnfMmHNkM/TtxEXxY6mau8LG3IJh4dBcU42f4hp
        TpoBF9JqxGCSzFD9MrDMWvXXz1lrlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.451400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24824.005
X-MDID: 1565099606-Ft1VMiBnLD20
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already scored points when handling the RX event, no-one else does this,
 and looking at the history it appears this was originally meant to only
 score on merges, not on GRO_NORMAL.  Moreover, it gets in the way of
 changing GRO to not immediately pass GRO_NORMAL skbs to the stack.
Performance testing with four TCP streams received on a single CPU (where
 throughput was line rate of 9.4Gbps in all tests) showed a 13.7% reduction
 in RX CPU usage (n=6, p=0.03).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/rx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index d5db045535d3..85ec07f5a674 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -412,7 +412,6 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		  unsigned int n_frags, u8 *eh)
 {
 	struct napi_struct *napi = &channel->napi_str;
-	gro_result_t gro_result;
 	struct efx_nic *efx = channel->efx;
 	struct sk_buff *skb;
 
@@ -449,9 +448,7 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 
 	skb_record_rx_queue(skb, channel->rx_queue.core_index);
 
-	gro_result = napi_gro_frags(napi);
-	if (gro_result != GRO_DROP)
-		channel->irq_mod_score += 2;
+	napi_gro_frags(napi);
 }
 
 /* Allocate and construct an SKB around page fragments */

