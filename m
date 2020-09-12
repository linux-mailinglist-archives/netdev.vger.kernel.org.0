Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353F8267C0D
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgILThM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgILTg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 15:36:58 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE54C061757
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 12:36:57 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4BpjYh0bh2zQkKW;
        Sat, 12 Sep 2020 21:36:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id F8nbp9IzO_AH; Sat, 12 Sep 2020 21:36:53 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com, eric.dumazet@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 3/4] net: lantiq: Use napi_complete_done()
Date:   Sat, 12 Sep 2020 21:36:28 +0200
Message-Id: <20200912193629.1586-4-hauke@hauke-m.de>
In-Reply-To: <20200912193629.1586-1-hauke@hauke-m.de>
References: <20200912193629.1586-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.75 / 15.00 / 15.00
X-Rspamd-Queue-Id: 0A38A17D5
X-Rspamd-UID: 380b5e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_complete_done() and activate the interrupts when this function
returns true. This way the generic NAPI code can take care of activating
the interrupts.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/lantiq_xrx200.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index f34e4dc8c661..abee7d61074c 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -230,8 +230,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
 	}
 
 	if (rx < budget) {
-		napi_complete(&ch->napi);
-		ltq_dma_enable_irq(&ch->dma);
+		if (napi_complete_done(&ch->napi, rx))
+			ltq_dma_enable_irq(&ch->dma);
 	}
 
 	return rx;
@@ -272,8 +272,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 		netif_wake_queue(net_dev);
 
 	if (pkts < budget) {
-		napi_complete(&ch->napi);
-		ltq_dma_enable_irq(&ch->dma);
+		if (napi_complete_done(&ch->napi, pkts))
+			ltq_dma_enable_irq(&ch->dma);
 	}
 
 	return pkts;
-- 
2.20.1

