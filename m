Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB59274B48
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 23:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIVVlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 17:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVVlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 17:41:39 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A09C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 14:41:38 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Bwvrw3qbvzQjVK;
        Tue, 22 Sep 2020 23:41:36 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id u3rmZOB7gU-N; Tue, 22 Sep 2020 23:41:33 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] net: lantiq: Add locking for TX DMA channel
Date:   Tue, 22 Sep 2020 23:41:12 +0200
Message-Id: <20200922214112.19591-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.77 / 15.00 / 15.00
X-Rspamd-Queue-Id: 780D514AF
X-Rspamd-UID: f3aafa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TX DMA channel data is accessed by the xrx200_start_xmit() and the
xrx200_tx_housekeeping() function from different threads. Make sure the
accesses are synchronized by acquiring the netif_tx_lock() in the
xrx200_tx_housekeeping() function too. This lock is acquired by the
kernel before calling xrx200_start_xmit().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index affec78cc0f5..36847ff93918 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -239,6 +239,7 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	int pkts = 0;
 	int bytes = 0;
 
+	netif_tx_lock(net_dev);
 	while (pkts < budget) {
 		struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->tx_free];
 
@@ -262,6 +263,7 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	net_dev->stats.tx_bytes += bytes;
 	netdev_completed_queue(ch->priv->net_dev, pkts, bytes);
 
+	netif_tx_unlock(net_dev);
 	if (netif_queue_stopped(net_dev))
 		netif_wake_queue(net_dev);
 
-- 
2.20.1

