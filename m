Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36AFC63BEC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfGIT3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:29:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51690 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbfGIT3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:29:16 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 66E94B40062;
        Tue,  9 Jul 2019 19:29:15 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 9 Jul
 2019 12:29:11 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH net-next 2/3] sfc: falcon: don't score irq moderation
 points for GRO
To:     David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Message-ID: <4ff1a476-6b0d-c7f8-f70d-2359cff3dcf5@solarflare.com>
Date:   Tue, 9 Jul 2019 20:29:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24748.005
X-TM-AS-Result: No-1.346800-4.000000-10
X-TMASE-MatchedRID: 4HJvlKN2LbNAEjf8JRFbHLsHVDDM5xAP1JP9NndNOkVBV3GkrxX03XHU
        HCqTYbHtrdoLblq9S5p1WMYsMQ0A8TmzjEr3tKb/WZTeB0tqopv0Bx2652QDU5soi2XrUn/JyeM
        tMD9QOgBJeFvFlVDkf/cUt5lc1lLgVDY46cMBpkcqxgU9R59YaaWWIlGbK4Tb6ZzjIq3CtgtYzJ
        WpkRPVGGx2HE/zfRoGXXWV+G4mMJUoXiSvk8+6Xk4txcztNYA1Jh9+cVm/44IaEFYXAylB9SUSM
        5mwacGkICQpusqRi2ejpeaEV8oRRFqAtPM/2FFilExlQIQeRG0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.346800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24748.005
X-MDID: 1562700556-heY2RzSA_yyT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same rationale as for sfc, except that this wasn't performance-tested.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/falcon/rx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index fd850d3d8ec0..05ea3523890a 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -424,7 +424,6 @@ ef4_rx_packet_gro(struct ef4_channel *channel, struct ef4_rx_buffer *rx_buf,
 		  unsigned int n_frags, u8 *eh)
 {
 	struct napi_struct *napi = &channel->napi_str;
-	gro_result_t gro_result;
 	struct ef4_nic *efx = channel->efx;
 	struct sk_buff *skb;
 
@@ -460,9 +459,7 @@ ef4_rx_packet_gro(struct ef4_channel *channel, struct ef4_rx_buffer *rx_buf,
 
 	skb_record_rx_queue(skb, channel->rx_queue.core_index);
 
-	gro_result = napi_gro_frags(napi);
-	if (gro_result != GRO_DROP)
-		channel->irq_mod_score += 2;
+	napi_gro_frags(napi);
 }
 
 /* Allocate and construct an SKB around page fragments */

