Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C7563BEB
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfGIT3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:29:05 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50564 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbfGIT3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:29:05 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 10A8D94007C;
        Tue,  9 Jul 2019 19:29:04 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 9 Jul
 2019 12:29:00 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH net-next 1/3] sfc: don't score irq moderation points for
 GRO
To:     David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Message-ID: <73f86f75-575c-fa39-5f20-2ecd2ea72ade@solarflare.com>
Date:   Tue, 9 Jul 2019 20:28:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24748.005
X-TM-AS-Result: No-0.451400-4.000000-10
X-TMASE-MatchedRID: X/b4gTAzQPtYwMQSR3qB3Uf49ONH0RaSlS5IbQ8u3TqzU0R+5DbDbBMb
        ntr5LgIG0+nrETiJLgkFuUksuzAWGsiLtyO0mH+oUharQ9sKnjF6i696PjRPiB3RY4pGTCyHeWg
        68DhoEkmt2gtuWr1LmnVYxiwxDQDxObOMSve0pv9ZlN4HS2qim/QHHbrnZANTmyiLZetSf8nJ4y
        0wP1A6AEl4W8WVUOR/9xS3mVzWUuCMx6OO8+QGvtJ62FN/MyPJdwU8Hxp6BwA2UjCBAZdN1odAa
        eMz0QmDSkCL/sez/BOi9+sSwSNbEoqZbFra/BQTCInc/iuPTs3qRt1Ud+ml4BoQVhcDKUH1JRIz
        mbBpwaQgJCm6ypGLZ6Ol5oRXyhFEVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.451400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24748.005
X-MDID: 1562700544-OPv1XXRCh9CG
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

