Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E147F368A9F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbhDWBtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240298AbhDWBso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AB1C061346;
        Thu, 22 Apr 2021 18:48:03 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y3so19423484eds.5;
        Thu, 22 Apr 2021 18:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uhLbsqsD1UeBHl9g3+cRO5/yYo+Kk02FCDPrTgf7heY=;
        b=gfOqBa4VU57XUrhMExIO4kzxF0q76b9VjVo5c0m9+3PkoQG4lW/dfPOWOMxXoEG4Rl
         rLRjMrt6YoMr/UGZRkfSzs/ZIXRsYnjTvRGnnpI8uvs8M94nXTbgZFljDdxb9aVENmyV
         GzUOnZ20++UKybTLVQLpt4L7b8jmc96L5L1sYISGZMTewEn+q+htKqfpAsXxEfraH53x
         dm+6+v/iXdpgBhKBfW0irqG4FdAbPmyfxL4JoPYAxdY5j+42xI08KOliMSlii7gNGeq+
         l5lNcrnNsybIKSCPENm2Pir4M+Bx0mRe92fE/vLHk9xRMnfpwSjiXtQwe+eC4NUSilpw
         CVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uhLbsqsD1UeBHl9g3+cRO5/yYo+Kk02FCDPrTgf7heY=;
        b=mSBFWAwfhnNtXqHOJMbYoiJp8FUmYqzcC0Ejw7c8zgk2oI+6h3qWBIqx6kxfNQaBIc
         fAvxzHTcODXQCtKZahRTl9AIHzWGHY2/uzQ1jeEHiv0A3HXkViNO7vH9qr5HwhkbME8F
         nYkRoQDy5xOnXCSCiJco3+cgyZ4rnmqo8JC686QnYS9UBHIr341YOSa+zdiP35RTKeF7
         2rSWUw0YrNrN9lV0D6iOjaEk7dzYEfgjP2s47UmrJPGpU9CUsABrJW53dFPFZURX1FKU
         ZGfKYV3rcMHlL/bXzTrhmNTgi0lGK+mPrWt0sEJfZItfU1fiIDktYk/H+jAKtEdEIHY9
         eucQ==
X-Gm-Message-State: AOAM531NkeHSu0vMCC1OHArduuwCevd/ZEC85XAX0eG05h+TmgnlAr9b
        38ogBycwl68DugNKbCVrxYI=
X-Google-Smtp-Source: ABdhPJxvpvfxgIEe8vQvP3vgLGG6GwZ6QXsujtBXl3GyinOBxHQ5gjTHTmgXbjMd9/t4ESV7dEbBXw==
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr1574997edd.168.1619142482566;
        Thu, 22 Apr 2021 18:48:02 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:02 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] drivers: net: dsa: qca8k: limit priority tweak to qca8337 switch
Date:   Fri, 23 Apr 2021 03:47:33 +0200
Message-Id: <20210423014741.11858-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet priority tweak and the rx delay is specific to qca8337.
Limit this changes to qca8337 as now we also support 8327 switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 84 +++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ca12394c2ff7..19bb3754d9ec 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -700,9 +700,13 @@ static int
 qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	const struct qca8k_match_data *data;
 	int ret, i;
 	u32 mask;
 
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
 		pr_err("port 0 is not the CPU port\n");
@@ -790,41 +794,43 @@ qca8k_setup(struct dsa_switch *ds)
 	 * To fix this the original code has some specific priority values
 	 * suggested by the QCA switch team.
 	 */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		switch (i) {
-		/* The 2 CPU port and port 5 requires some different
-		 * priority than any other ports.
-		 */
-		case 0:
-		case 5:
-		case 6:
-			mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x4) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x4) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI4(0x6) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI5(0x8) |
-				QCA8K_PORT_HOL_CTRL0_EG_PORT(0x1e);
-			break;
-		default:
-			mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x6) |
-				QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
-				QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
+	if (data->id == QCA8K_ID_QCA8337) {
+		for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+			switch (i) {
+			/* The 2 CPU port and port 5 requires some different
+			 * priority than any other ports.
+			 */
+			case 0:
+			case 5:
+			case 6:
+				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI4(0x6) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI5(0x8) |
+					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x1e);
+				break;
+			default:
+				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x6) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
+					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
+			}
+			qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
+
+			mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
+			QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+			QCA8K_PORT_HOL_CTRL1_WRED_EN;
+			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
+				  QCA8K_PORT_HOL_CTRL1_ING_BUF |
+				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
+				  mask);
 		}
-		qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
-
-		mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
-		       QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
-		       QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
-		       QCA8K_PORT_HOL_CTRL1_WRED_EN;
-		qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
-			  QCA8K_PORT_HOL_CTRL1_ING_BUF |
-			  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
-			  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
-			  QCA8K_PORT_HOL_CTRL1_WRED_EN,
-			  mask);
 	}
 
 	/* Flush the FDB table */
@@ -840,9 +846,13 @@ static void
 qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
+	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv = ds->priv;
 	u32 reg, val;
 
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+
 	switch (port) {
 	case 0: /* 1st CPU port */
 		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
@@ -895,8 +905,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY(2) |
 			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
-		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		/* QCA8337 requires to set rgmii rx delay */
+		if (data->id == QCA8K_ID_QCA8337)
+			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
-- 
2.30.2

