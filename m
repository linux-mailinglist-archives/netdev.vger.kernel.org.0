Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2734284C5
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhJKBds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhJKBdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:33:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF149C061762;
        Sun, 10 Oct 2021 18:31:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i20so44873952edj.10;
        Sun, 10 Oct 2021 18:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LQ2AFfPkCSh8+3p7cFQrEdkDEO1iLET137FOPU21gqU=;
        b=E4OvbCE7pdkJnaUkewYbl403uoxtzBTjD2783p1wGviPqe45kQAZTNzCd1nnhlT2hu
         7Lv13P9faGfgvKOl5kUp/5+y0MuDF/05Q9pNLZAYJXgZ7Wv0lylGSUPH3lKPxP8vPcyv
         AfN+CexeOkTOPtA6VsgTF9WOhQ8/i2Gh1MiFveMyF98iPW7XiseOgzsfPzmZSrULhgU5
         C2rn39K4uo5+mzH/Q5YUkeDJ44PMD5PchPnYI3Iyle7L5RFygw8vouQzdTUHTFzT/iFB
         CUbM0IZET6HR5hxf9cHCQyen0o2mjTRw5KBj9y0PfxEGzxBOLkCdiQwJhK9gdEwPAR8K
         ujfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LQ2AFfPkCSh8+3p7cFQrEdkDEO1iLET137FOPU21gqU=;
        b=Fcn5+x4PsRKZVpnreayxLvuZDmBLFpiU0oRAbum5qDqUmO66GwJ7wuzD4JVvWVUx9h
         8tYyt8LU+x4jEWv3GtKkqh6KTNwci62ioInJzr6FzOGo/GzOa4GsQ1qX2KImSBY0ah++
         KxbAhG3nKiy7RR4emS2XMvKJkxhBYBx/H1Ho0T21/ZBI7ET0y0zyz2A2DI1DlZdoPUnE
         BhVnvFCJ3mL3y8e1SQ9hqlZuV8xfbstjIITT8bsHutjrXsphRsVK2EAoTYdhItxTZVPZ
         5SV1JmzO9EdRyKWrL0zv+EanGrv9H80S+OJVoZFGuvsjJYYTWsnROx9lgJs04bilSYrX
         G7+Q==
X-Gm-Message-State: AOAM5316dUb3vt41Rd0PXkS8A9RhawZQzwbVzXPmRYA02wHNheAFXVxE
        G+POYhoGPakIzHxKlsEURfY=
X-Google-Smtp-Source: ABdhPJxJZ5zOd9xTiA8K5it40s7+endCdXEJiu9HHNJ8pS54lqNmxJDc3G9IbCxlGUC1d/6VqdZSww==
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr36228787eds.166.1633915859468;
        Sun, 10 Oct 2021 18:30:59 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:59 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 14/14] drivers: net: dsa: qca8k: move port config to dedicated struct
Date:   Mon, 11 Oct 2021 03:30:24 +0200
Message-Id: <20211011013024.569-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ports related config to dedicated struct to keep things organized.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 26 +++++++++++++-------------
 drivers/net/dsa/qca8k.h | 10 +++++++---
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 28635f4feaf5..0311249f6a26 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1013,7 +1013,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 				delay = 3;
 			}
 
-			priv->rgmii_tx_delay[cpu_port_index] = delay;
+			priv->ports_config.rgmii_tx_delay[cpu_port_index] = delay;
 
 			delay = 0;
 
@@ -1029,20 +1029,20 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 				delay = 3;
 			}
 
-			priv->rgmii_rx_delay[cpu_port_index] = delay;
+			priv->ports_config.rgmii_rx_delay[cpu_port_index] = delay;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
-				priv->sgmii_tx_clk_falling_edge = true;
+				priv->ports_config.sgmii_tx_clk_falling_edge = true;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
-				priv->sgmii_rx_clk_falling_edge = true;
+				priv->ports_config.sgmii_rx_clk_falling_edge = true;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-enable-pll")) {
-				priv->sgmii_enable_pll = true;
+				priv->ports_config.sgmii_enable_pll = true;
 
 				if (priv->switch_id == QCA8K_ID_QCA8327) {
 					dev_err(priv->dev, "SGMII PLL should NOT be enabled for qca8327. Aborting enabling");
-					priv->sgmii_enable_pll = false;
+					priv->ports_config.sgmii_enable_pll = false;
 				}
 
 				if (priv->switch_revision < 2)
@@ -1268,15 +1268,15 @@ qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_inde
 	 * not enabled. With ID or TX/RXID delay is enabled and set
 	 * to the default and recommended value.
 	 */
-	if (priv->rgmii_tx_delay[cpu_port_index]) {
-		delay = priv->rgmii_tx_delay[cpu_port_index];
+	if (priv->ports_config.rgmii_tx_delay[cpu_port_index]) {
+		delay = priv->ports_config.rgmii_tx_delay[cpu_port_index];
 
 		val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
 			QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
 	}
 
-	if (priv->rgmii_rx_delay[cpu_port_index]) {
-		delay = priv->rgmii_rx_delay[cpu_port_index];
+	if (priv->ports_config.rgmii_rx_delay[cpu_port_index]) {
+		delay = priv->ports_config.rgmii_rx_delay[cpu_port_index];
 
 		val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
 			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
@@ -1384,7 +1384,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 		val |= QCA8K_SGMII_EN_SD;
 
-		if (priv->sgmii_enable_pll)
+		if (priv->ports_config.sgmii_enable_pll)
 			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
 			       QCA8K_SGMII_EN_TX;
 
@@ -1412,10 +1412,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		val = 0;
 
 		/* SGMII Clock phase configuration */
-		if (priv->sgmii_rx_clk_falling_edge)
+		if (priv->ports_config.sgmii_rx_clk_falling_edge)
 			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
 
-		if (priv->sgmii_tx_clk_falling_edge)
+		if (priv->ports_config.sgmii_tx_clk_falling_edge)
 			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
 
 		if (val)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c5ca6277b45b..e10571a398c9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -270,15 +270,19 @@ enum {
 	QCA8K_CPU_PORT6,
 };
 
-struct qca8k_priv {
-	u8 switch_id;
-	u8 switch_revision;
+struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
 	bool sgmii_enable_pll;
 	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
+};
+
+struct qca8k_priv {
+	u8 switch_id;
+	u8 switch_revision;
 	bool legacy_phy_port_mapping;
+	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.32.0

