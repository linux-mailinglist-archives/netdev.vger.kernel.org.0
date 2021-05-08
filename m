Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887AD376DCE
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhEHAbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhEHAam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:42 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085D5C06138F;
        Fri,  7 May 2021 17:29:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l14so10864471wrx.5;
        Fri, 07 May 2021 17:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ZXTotwH/H9zAiZZ9satckfQe8BvSUWtUnJjdJJzzOY=;
        b=mWdIHY474zMAMcnDllo8BAMta3HITEVnPH6OMFtW1NQIKH3bI0WbXZcl5JwGZN7oIe
         l6OL0xPdbLA3zSST65ivnc9B7C6rH+QYNLfUh44dCaDUrpfOUj9ZCQdslrko2dwnM75r
         PE4Yh19Gp+crlS3y9RPUfBF8IIdkCrcxdguC5FxTWRbOzIZ+/xa0lQEXS/YY+DuSqTsv
         fnAq0CQHqrACNwkLwvM31pf3qc66XanvXC6JSlRRdfREkOnYoDalvt/R6AJN8dLYI20h
         hU26GEuHNXZi3/YGLGcH/BQJABVqxmYY9Di4TZLDi4VqXpU0V//XiohY78du1muwEcsa
         HCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ZXTotwH/H9zAiZZ9satckfQe8BvSUWtUnJjdJJzzOY=;
        b=YOCQkICYXKj4xe84C8tNLhZw9U3TTWhp1qOXCgcBhNo2pRI5kG+mxjJMBuXD10vtxM
         cvDZJr5vAynJjk9gbzDf37IKnz/46pNFPV0vY7CspJF3158Ss6AGrW9OJnD2IgRi5IMW
         lwvrj2M7MwfW8oeV0EMT/3onrRX4OhIhtc+1vH5+pmHSDUBpw3kV3sGOdf96kTtDpruV
         P0OPw81ZukaPzxy7iHMY6WmcbuJcAoRnV9x7JWTEEnOZqACZGoMh5Q01f5Ks5oUx1tNy
         tu6XzKuJpG+8LPu4FCnmREz371q1F/zf6HdnQkb73uyeufVAbR1Y2X2qeU3UF0I5HxHl
         6ouw==
X-Gm-Message-State: AOAM5319JlO39FReBl/Ab9mccsDYFmVQTrs3q0OMNHDPzq8dy0K4Uf8q
        53F0ceslPxbFDJkXPHsOo5w=
X-Google-Smtp-Source: ABdhPJyhHvBh2CCCLQE4kZhv8UkamlV0Wjswj6XsrKHZk9ucKVvZB0/RhLn85plIsOGjHsE4sGPCOw==
X-Received: by 2002:adf:dc8e:: with SMTP id r14mr1467696wrj.44.1620433779671;
        Fri, 07 May 2021 17:29:39 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:39 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 19/28] net: dsa: qca8k: make rgmii delay configurable
Date:   Sat,  8 May 2021 02:29:09 +0200
Message-Id: <20210508002920.19945-19-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy qsdk code used a different delay instead of the max value.
Qsdk use 1 ps for rx and 2 ps for tx. Make these values configurable
using the standard rx/tx-internal-delay-ps ethernet binding and apply
qsdk values by default. The connected gmac doesn't add any delay so no
additional delay is added to tx/rx.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 54 +++++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/qca8k.h | 11 +++++----
 2 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 285cce4fab9f..0c53b6fdf6ee 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -789,6 +789,50 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int
+qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
+{
+	struct device_node *ports, *port;
+	u32 val;
+
+	ports = of_get_child_by_name(priv->dev->of_node, "ports");
+	if (!ports)
+		ports = of_get_child_by_name(priv->dev->of_node, "ethernet-ports");
+
+	if (!ports)
+		return -EINVAL;
+
+	/* Assume only one port with rgmii-id mode */
+	for_each_available_child_of_node(ports, port) {
+		if (!of_property_match_string(port, "phy-mode", "rgmii-id"))
+			continue;
+
+		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
+			val = 2;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii rx delay is limited to more than 3ps, setting to the max value");
+			priv->rgmii_rx_delay = 3;
+		} else {
+			priv->rgmii_rx_delay = val;
+		}
+
+		if (of_property_read_u32(port, "tx-internal-delay-ps", &val))
+			val = 1;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii tx delay is limited to more than 3ps, setting to the max value");
+			priv->rgmii_tx_delay = 3;
+		} else {
+			priv->rgmii_tx_delay = val;
+		}
+	}
+
+	of_node_put(ports);
+
+	return 0;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -814,6 +858,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_of_rgmii_delay(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
@@ -1026,8 +1074,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		 */
 		qca8k_write(priv, reg,
 			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		/* QCA8337 requires to set rgmii rx delay */
 		if (priv->switch_id == QCA8K_ID_QCA8337)
 			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 338277978ec0..a878486d9bcd 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -38,12 +38,11 @@
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		\
-						((0x8 + (x & 0x3)) << 22)
-#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
-						((0x10 + (x & 0x3)) << 20)
-#define   QCA8K_MAX_DELAY				3
+#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
+#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
+#define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
+#define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
@@ -254,6 +253,8 @@ struct qca8k_match_data {
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
+	u8 rgmii_tx_delay;
+	u8 rgmii_rx_delay;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

