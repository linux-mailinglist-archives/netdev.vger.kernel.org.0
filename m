Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C60373267
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhEDWav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhEDWam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B83CC061345;
        Tue,  4 May 2021 15:29:45 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id u13so9599424edd.3;
        Tue, 04 May 2021 15:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aex0wQpZmDEcq0EGwxB3fTvDNc6qfno7zLje/qmotOc=;
        b=QwjA6YOBOuRaybPOf2coJ5Uhc/6GhjJB5Ml/l+MuBRonV0Zw4kiYf7HX2HNi70tJl0
         FvcNT8hGXQ0i1lW2V8R8GaqO4rSaerr+NqCfJugjMxQ0hnAHJeFD6tK7JEE2vMGNUmHM
         vo3YEH+WN966ydXRJQ4ZqcTTNmSGxkvLy+OdR2I8hIzJ24mi8lKVVfEiY0JDzLkgrFRV
         UzGwhMPaqiEj6j+AZHMscl51RhJSVB0CEPRcAW4jIYej6FoaU4EThrKvAqf9XNPSWiIh
         Uuqzzo/TVqOjeZps2GUZvPfkocAVAcKXy197XMrf30p65NSmUOLirg/kyNqCaTy/80ZK
         kNmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aex0wQpZmDEcq0EGwxB3fTvDNc6qfno7zLje/qmotOc=;
        b=FvdbOsP2dZGs8i6zmZGTGT3r2FAecI5L76+yywcXJk9JC4Nc8/C4/MG4QY1ENazjSv
         IT7VcXJRe+bgzh9l6E6OcUWDhVAu64dmvefa2z7I4TAP4rI+ab0hMG41ku8c1s83A/hO
         /jDbsWS5/4M9GcHTVljnxDLUMndzO9eA7h0kMqbvx/ZgpYn4cH7aKJ6Seh6k6F1BdOKM
         rWSEXkt1vwfyAmYnn14GwjVMfhIa4u+AMGOEGioELMopqowLsyFX8aw3Rszirk4D3I3U
         inXJmCfElgbnub5/i5v3xQVJmk5Her/u5+PjO55ITezAWXbAwOcS4+GAftd6J+lSLUS4
         Ngyw==
X-Gm-Message-State: AOAM532vRePNXJxv0TngkQrgJ9AWOu1Jr1gTjXDqcwbQO+oCPprDkcYw
        YEhiLQfwizp5G/CvK7aXEak=
X-Google-Smtp-Source: ABdhPJxZ3QalRkpvhCLe5iXITCUkEkXh7uUzLcTDIeqCTWVs8elPLoLII/j6WWVB8Xg0GSwEA8jMJA==
X-Received: by 2002:a05:6402:31a1:: with SMTP id dj1mr20708563edb.351.1620167384262;
        Tue, 04 May 2021 15:29:44 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:43 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 10/20] net: dsa: qca8k: add priority tweak to qca8337 switch
Date:   Wed,  5 May 2021 00:29:04 +0200
Message-Id: <20210504222915.17206-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port 5 of the ar8337 have some problem in flood condition. The
original legacy driver had some specific buffer and priority settings
for the different port suggested by the QCA switch team. Add this
missing settings to improve switch stability under load condition.
The packet priority tweak and the rx delay is specific to qca8337.
Limit this changes to qca8337 as now we also support 8327 switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 54 +++++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/qca8k.h | 24 ++++++++++++++++++
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 17c6fd4afa7d..9e034c445085 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -783,7 +783,12 @@ static int
 qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	const struct qca8k_match_data *data;
 	int ret, i;
+	u32 mask;
+
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
 
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
@@ -889,6 +894,45 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 	}
 
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
+		}
+	}
+
 	/* Setup our port MTUs to match power on defaults */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
@@ -909,9 +953,13 @@ static void
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
@@ -962,8 +1010,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			    QCA8K_PORT_PAD_RGMII_EN |
 			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
-		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		/* QCA8337 requires to set rgmii rx delay */
+		if (data->id == QCA8K_ID_QCA8337)
+			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 86e8d479c9f9..34c5522e7202 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -166,6 +166,30 @@
 #define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 
+#define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1_BUF		GENMASK(7, 4)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1(x)		((x) << 4)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2_BUF		GENMASK(11, 8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2(x)		((x) << 8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3_BUF		GENMASK(15, 12)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3(x)		((x) << 12)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4_BUF		GENMASK(19, 16)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4(x)		((x) << 16)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5_BUF		GENMASK(23, 20)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5(x)		((x) << 20)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT_BUF		GENMASK(29, 24)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT(x)		((x) << 24)
+
+#define QCA8K_REG_PORT_HOL_CTRL1(_i)			(0x974 + (_i) * 0x8)
+#define   QCA8K_PORT_HOL_CTRL1_ING_BUF			GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL1_ING(x)			((x) << 0)
+#define   QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN		BIT(6)
+#define   QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN		BIT(7)
+#define   QCA8K_PORT_HOL_CTRL1_WRED_EN			BIT(8)
+#define   QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN		BIT(16)
+
 /* Pkt edit registers */
 #define QCA8K_EGRESS_VLAN(x)				(0x0c70 + (4 * (x / 2)))
 
-- 
2.30.2

