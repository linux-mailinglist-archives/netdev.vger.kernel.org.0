Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD30C4C262B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiBXIaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiBXI3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:29:44 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B132782A6
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:28:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9Uf-0004Wg-42
        for netdev@vger.kernel.org; Thu, 24 Feb 2022 09:28:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A5CCB3C3A5
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:27:30 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 635573C373;
        Thu, 24 Feb 2022 08:27:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id eb95104c;
        Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 32/36] can: mcp251xfd: ring: change order of TX and RX FIFOs
Date:   Thu, 24 Feb 2022 09:27:22 +0100
Message-Id: <20220224082726.3000007-33-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224082726.3000007-1-mkl@pengutronix.de>
References: <20220224082726.3000007-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch actually changes the order of the TX and RX FIFOs.

This gives the opportunity to minimize the number of SPI transfers in
the IRQ handler. The read of the IRQ status register and RX FIFO
status registers can be combined into single SPI transfer. If the RX
ring uses FIFO 1, the overall length of the transfer is smaller than
in the original layout, where the RX FIFO comes after the TX FIFO.

Link: https://lore.kernel.org/all/20220217103826.2299157-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c | 2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 39005725c665..9657dbf251b0 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -215,8 +215,8 @@ void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	netdev_reset_queue(priv->ndev);
 
 	mcp251xfd_ring_init_tef(priv, &base);
-	mcp251xfd_ring_init_tx(priv, &base, &fifo_nr);
 	mcp251xfd_ring_init_rx(priv, &base, &fifo_nr);
+	mcp251xfd_ring_init_tx(priv, &base, &fifo_nr);
 }
 
 void mcp251xfd_ring_free(struct mcp251xfd_priv *priv)
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 5c3f7f25caf0..8ee959890aea 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -596,8 +596,8 @@ struct mcp251xfd_priv {
 	u32 spi_max_speed_hz_slow;
 
 	struct mcp251xfd_tef_ring tef[1];
-	struct mcp251xfd_tx_ring tx[1];
 	struct mcp251xfd_rx_ring *rx[1];
+	struct mcp251xfd_tx_ring tx[1];
 
 	u8 rx_ring_num;
 
-- 
2.34.1


