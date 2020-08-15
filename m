Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFD245347
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgHOV7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbgHOVvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:38 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D6AC00458F
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 11:33:33 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4BTTTN5fJKzQlCD;
        Sat, 15 Aug 2020 20:33:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id xDsOT176kEYl; Sat, 15 Aug 2020 20:33:25 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] net: lantiq: Use napi_complete_done()
Date:   Sat, 15 Aug 2020 20:33:14 +0200
Message-Id: <20200815183314.404-3-hauke@hauke-m.de>
In-Reply-To: <20200815183314.404-1-hauke@hauke-m.de>
References: <20200815183314.404-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.85 / 15.00 / 15.00
X-Rspamd-Queue-Id: C432517F1
X-Rspamd-UID: d1da0e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_complete_done() and activate the interrupts when this function
returns true. This way the generic NAPI code can take care of activating
the interrupts.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/lantiq_xrx200.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index f34e4dc8c661..674ffb2ecd9a 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -229,10 +229,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
 		}
 	}
 
-	if (rx < budget) {
-		napi_complete(&ch->napi);
+	if (napi_complete_done(&ch->napi, rx))
 		ltq_dma_enable_irq(&ch->dma);
-	}
 
 	return rx;
 }
@@ -271,10 +269,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	if (netif_queue_stopped(net_dev))
 		netif_wake_queue(net_dev);
 
-	if (pkts < budget) {
-		napi_complete(&ch->napi);
+	if (napi_complete_done(&ch->napi, pkts))
 		ltq_dma_enable_irq(&ch->dma);
-	}
 
 	return pkts;
 }
-- 
2.20.1

