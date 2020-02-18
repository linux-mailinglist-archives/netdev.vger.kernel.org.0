Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0416162D10
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgBRReM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:34:12 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47796 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbgBRReL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:34:11 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 46473580094;
        Tue, 18 Feb 2020 17:34:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 18 Feb
 2020 17:34:05 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next] sfc: elide assignment of skb
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Message-ID: <85e28e89-0488-c7e2-8ea4-3feaeada22a4@solarflare.com>
Date:   Tue, 18 Feb 2020 17:34:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25238.003
X-TM-AS-Result: No-2.886100-8.000000-10
X-TMASE-MatchedRID: XZ8r374dJmN4iIlKJTjiEfKR06Kw3DzKeouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5ra/g/NGTW3Mjth0sPlikKsMiMrbc70Pfej/vWEpdIOB5cFdomgH0lnOX/
        V8P8ail2cIZLVZAQa0MavT21DsLD/UEhWy9W70AHCttcwYNipX6Znf3oa3keFWAQgk2vaT2oDPf
        /wSoTefYfBGxP95mA4TCBcNZ0m1rBi+R60VmJbbIL/2FquGjxfyg1Eu4PbVU8fE0XTbBVRm0ITY
        8cIIS1JfObqGK9JplminaV/dK0aEhK3Vty8oXtkps2YVnJpfNg=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.886100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25238.003
X-MDID: 1582047251-5Q4f4Mmv8fxx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of assigning skb = segments before the loop, just pass
 segments directly as the first argument to skb_list_walk_safe().

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 04d7f41d7ed9..696a77c20cb7 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -287,9 +287,8 @@ static int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue,
 		return PTR_ERR(segments);
 
 	dev_consume_skb_any(skb);
-	skb = segments;
 
-	skb_list_walk_safe(skb, skb, next) {
+	skb_list_walk_safe(segments, skb, next) {
 		skb_mark_not_on_list(skb);
 		efx_enqueue_skb(tx_queue, skb);
 	}
