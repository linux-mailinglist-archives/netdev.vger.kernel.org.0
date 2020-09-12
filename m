Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E189267C0C
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgILThL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgILTg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 15:36:59 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFA6C061786
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 12:36:59 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4BpjYj2zRpzQlQC;
        Sat, 12 Sep 2020 21:36:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id an5CRbw2S-Vt; Sat, 12 Sep 2020 21:36:54 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com, eric.dumazet@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 4/4] net: lantiq: Disable IRQs only if NAPI gets scheduled
Date:   Sat, 12 Sep 2020 21:36:29 +0200
Message-Id: <20200912193629.1586-5-hauke@hauke-m.de>
In-Reply-To: <20200912193629.1586-1-hauke@hauke-m.de>
References: <20200912193629.1586-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: ***
X-Rspamd-Score: 3.15 / 15.00 / 15.00
X-Rspamd-Queue-Id: 629CD1283
X-Rspamd-UID: 8af62b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_schedule() call will only schedule the NAPI if it is not
already running. To make sure that we do not deactivate interrupts
without scheduling NAPI only deactivate the interrupts in case NAPI also
gets scheduled.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/lantiq_xrx200.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index abee7d61074c..635ff3a5dcfb 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -345,10 +345,12 @@ static irqreturn_t xrx200_dma_irq(int irq, void *ptr)
 {
 	struct xrx200_chan *ch = ptr;
 
-	ltq_dma_disable_irq(&ch->dma);
-	ltq_dma_ack_irq(&ch->dma);
+	if (napi_schedule_prep(&ch->napi)) {
+		__napi_schedule(&ch->napi);
+		ltq_dma_disable_irq(&ch->dma);
+	}
 
-	napi_schedule(&ch->napi);
+	ltq_dma_ack_irq(&ch->dma);
 
 	return IRQ_HANDLED;
 }
-- 
2.20.1

