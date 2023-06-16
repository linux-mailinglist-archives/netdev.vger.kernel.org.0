Return-Path: <netdev+bounces-11449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD6F73326C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D8A1C20FB9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603C218015;
	Fri, 16 Jun 2023 13:45:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CCD156C1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:45:59 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B312683;
	Fri, 16 Jun 2023 06:45:56 -0700 (PDT)
X-GND-Sasl: miquel.raynal@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686923155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iqNuk91ReidgvjGQ/uHdYSnJCuf4AbcP78tiAgRTYr4=;
	b=Fcxde2Kb8PA/g6Jn3KysPKF0UEqV+mpnXTMjIJgs0J3FfmWbBKP47JcAjCEqagbRu9YbMm
	5sU1ySqclwS+WcLumo1L0hM7DNbz4TMoqgOS5Uvr187qSZJZfay91G5rDlCouoj5FXsKoB
	SEtEaJS2gPhLxmxArbts/J3b03/HwieOpO1MNT77EtIAKj93vqEkHQLSVFwejKQ6XypY+b
	pGnAY3+XMKMgVDWeWAFm1qdyYOvGGm5zM/K4jsJJdy3Ymn/LhNT6RkS7qRenncRK+uU6gL
	9hdJTv4tqluZS89Yyn+fHZAw82d+z2PFEPSfUKMImd3/P1/o/h4LDGY0Rg8qDQ==
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id AC07FC000C;
	Fri, 16 Jun 2023 13:45:53 +0000 (UTC)
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-can@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Sylvain Girard <sylvain.girard@se.com>,
	Pascal Eberhard <pascal.eberhard@se.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Herve Codina <herve.codina@bootlin.com>,
	=?UTF-8?q?J=C3=A9r=C3=A9mie=20Dautheribes?= <jeremie.dautheribes@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next 1/2] can: sja1000: Prepare the use of a threaded handler
Date: Fri, 16 Jun 2023 15:45:52 +0200
Message-Id: <20230616134553.2786391-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order to support a flavor of the sja1000 which sometimes freezes, it
will be needed upon certain interrupts to perform a soft reset. The soft
reset operation takes a bit of time, so better not do it within the hard
interrupt handler but rather in a threaded handler. Let's prepare the
possibility for sja1000_err() to request "interrupting" the current flow
and request the threaded handler to be run while keeping the interrupt
line low.

There is no functional change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/can/sja1000/sja1000.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index aac5956e4a53..4719806e3a9f 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -501,7 +501,8 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 	struct sja1000_priv *priv = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
 	uint8_t isrc, status;
-	int n = 0;
+	irqreturn_t ret = 0;
+	int n = 0, err;
 
 	if (priv->pre_irq)
 		priv->pre_irq(priv);
@@ -546,19 +547,23 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 		}
 		if (isrc & (IRQ_DOI | IRQ_EI | IRQ_BEI | IRQ_EPI | IRQ_ALI)) {
 			/* error interrupt */
-			if (sja1000_err(dev, isrc, status))
+			err = sja1000_err(dev, isrc, status);
+			if (err)
 				break;
 		}
 		n++;
 	}
 out:
+	if (!ret)
+		ret = (n) ? IRQ_HANDLED : IRQ_NONE;
+
 	if (priv->post_irq)
 		priv->post_irq(priv);
 
 	if (n >= SJA1000_MAX_IRQ)
 		netdev_dbg(dev, "%d messages handled in ISR", n);
 
-	return (n) ? IRQ_HANDLED : IRQ_NONE;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(sja1000_interrupt);
 
-- 
2.34.1


