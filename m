Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8846F17512A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 01:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCBAC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 19:02:28 -0500
Received: from mout-p-201.mailbox.org ([80.241.56.171]:24368 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgCBAC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 19:02:28 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 48W0h25BDRzQl9N;
        Mon,  2 Mar 2020 01:02:26 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id IORgp0ak0UOt; Mon,  2 Mar 2020 01:02:23 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net, linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 1/2] ag71xx: Handle allocation errors in ag71xx_rings_init()
Date:   Mon,  2 Mar 2020 01:02:07 +0100
Message-Id: <20200302000208.18260-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free the allocated resources in ag71xx_rings_init() in case
ag71xx_ring_rx_init() returns an error.

This is only a potential problem, I did not ran into this one.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
---

v2:
 * rebased onm top of "net: ag71xx: port to phylink"

 drivers/net/ethernet/atheros/ag71xx.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 02b7705393ca..38683224b70b 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1169,6 +1169,7 @@ static int ag71xx_rings_init(struct ag71xx *ag)
 	struct ag71xx_ring *tx = &ag->tx_ring;
 	struct ag71xx_ring *rx = &ag->rx_ring;
 	int ring_size, tx_size;
+	int ret;
 
 	ring_size = BIT(tx->order) + BIT(rx->order);
 	tx_size = BIT(tx->order);
@@ -1181,9 +1182,8 @@ static int ag71xx_rings_init(struct ag71xx *ag)
 					   ring_size * AG71XX_DESC_SIZE,
 					   &tx->descs_dma, GFP_KERNEL);
 	if (!tx->descs_cpu) {
-		kfree(tx->buf);
-		tx->buf = NULL;
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_free_buf;
 	}
 
 	rx->buf = &tx->buf[tx_size];
@@ -1191,7 +1191,21 @@ static int ag71xx_rings_init(struct ag71xx *ag)
 	rx->descs_dma = tx->descs_dma + tx_size * AG71XX_DESC_SIZE;
 
 	ag71xx_ring_tx_init(ag);
-	return ag71xx_ring_rx_init(ag);
+	ret = ag71xx_ring_rx_init(ag);
+	if (ret)
+		goto err_free_dma;
+
+	return 0;
+
+err_free_dma:
+	dma_free_coherent(&ag->pdev->dev, ring_size * AG71XX_DESC_SIZE,
+			  tx->descs_cpu, tx->descs_dma);
+	rx->buf = NULL;
+err_free_buf:
+	kfree(tx->buf);
+	tx->buf = NULL;
+
+	return ret;
 }
 
 static void ag71xx_rings_free(struct ag71xx *ag)
-- 
2.20.1

