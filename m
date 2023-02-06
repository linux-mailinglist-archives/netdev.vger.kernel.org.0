Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1969A68BDBF
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjBFNRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjBFNRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EF5233C5
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N3-0007X6-EP
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:21 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 44FEA17142F
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4A0C11712C5;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d32106ea;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 18/47] can: ems_pci: Add read/write register and post irq functions
Date:   Mon,  6 Feb 2023 14:15:51 +0100
Message-Id: <20230206131620.2758724-19-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>

Add functions to read and write SJA1000 registers and also the
post irq routine

Signed-off-by: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>
Link: https://lore.kernel.org/all/20230120112616.6071-5-uttenthaler@ems-wuensche.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/ems_pci.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/ems_pci.c b/drivers/net/can/sja1000/ems_pci.c
index 5748c24dd137..0d6289fda447 100644
--- a/drivers/net/can/sja1000/ems_pci.c
+++ b/drivers/net/can/sja1000/ems_pci.c
@@ -172,6 +172,24 @@ static void ems_pci_v2_post_irq(const struct sja1000_priv *priv)
 	writel(PLX_ICSR_ENA_CLR, card->conf_addr + PLX_ICSR);
 }
 
+static u8 ems_pci_v3_read_reg(const struct sja1000_priv *priv, int port)
+{
+	return readb(priv->reg_base + port);
+}
+
+static void ems_pci_v3_write_reg(const struct sja1000_priv *priv,
+				 int port, u8 val)
+{
+	writeb(val, priv->reg_base + port);
+}
+
+static void ems_pci_v3_post_irq(const struct sja1000_priv *priv)
+{
+	struct ems_pci_card *card = (struct ems_pci_card *)priv->priv;
+
+	writel(ASIX_LINTSR_INT0AC, card->conf_addr + ASIX_LINTSR);
+}
+
 /* Check if a CAN controller is present at the specified location
  * by trying to set 'em into the PeliCAN mode
  */
@@ -330,10 +348,14 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 			priv->read_reg  = ems_pci_v1_read_reg;
 			priv->write_reg = ems_pci_v1_write_reg;
 			priv->post_irq  = ems_pci_v1_post_irq;
-		} else {
+		} else if (card->version == 2) {
 			priv->read_reg  = ems_pci_v2_read_reg;
 			priv->write_reg = ems_pci_v2_write_reg;
 			priv->post_irq  = ems_pci_v2_post_irq;
+		} else {
+			priv->read_reg  = ems_pci_v3_read_reg;
+			priv->write_reg = ems_pci_v3_write_reg;
+			priv->post_irq  = ems_pci_v3_post_irq;
 		}
 
 		/* Check if channel is present */
-- 
2.39.1


