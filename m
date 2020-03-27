Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F15C195940
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgC0OoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:44:22 -0400
Received: from mx.0dd.nl ([5.2.79.48]:45632 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgC0OoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:44:22 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 0DD755FA7A;
        Fri, 27 Mar 2020 15:44:21 +0100 (CET)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="Nr7wtkCa";
        dkim-atps=neutral
Received: from pc-rene-vdorst-com.vdorst.com (pc-rene-vdorst-com.vdorst.com [192.168.2.14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id C2E0926409D;
        Fri, 27 Mar 2020 15:44:20 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com C2E0926409D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1585320260;
        bh=aKWB1fYafsU00dAeSkuJV48ua04gryao/7n12RqYpkY=;
        h=From:To:Cc:Subject:Date:From;
        b=Nr7wtkCasrQ1/kaPw8pMFNl0AYrgjKvBLHZUHvt7J+sN7Vmj/BqEt/4UcfnDbsOMb
         pl0HIfdPiQ+9kHABjB62Kd90ulQsbQfLZjNPaC4XlpyH/9ZxxEhLfzFaeQmFgY+Mbl
         phcHV8DExewt6QUvtOg4Qhq86VjkOqSugri3gQ4LW0U2MmbQKVCldOT3MaRIj0p7YL
         fJicGBMJX4CUyqmoryi85iEA7ehSv3avUn9w8z43f5f9VwTenuFJquXH5+Mwrqq9vS
         ar/3+Wz/nnzEBQv9g6HjI2KNg3ABzaU27D6LOfTJ+MqZ+f6SXTIpa1n9fCIhBmxt4G
         Porm0RkPumFeQ==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     netdev@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next] net: dsa: mt7530: use resolved link config in mac_link_up()
Date:   Fri, 27 Mar 2020 15:44:12 +0100
Message-Id: <20200327144412.100913-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the mt7530 switch driver to use the finalised link
parameters in mac_link_up() rather than the parameters in mac_config().

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 57 +++++++++++++++++-----------------------
 drivers/net/dsa/mt7530.h |  4 +++
 2 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6e91fe2f4b9a..ef57552db260 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -563,17 +563,6 @@ mt7530_mib_reset(struct dsa_switch *ds)
 	mt7530_write(priv, MT7530_MIB_CCR, CCR_MIB_ACTIVATE);
 }
 
-static void
-mt7530_port_set_status(struct mt7530_priv *priv, int port, int enable)
-{
-	u32 mask = PMCR_TX_EN | PMCR_RX_EN | PMCR_FORCE_LNK;
-
-	if (enable)
-		mt7530_set(priv, MT7530_PMCR_P(port), mask);
-	else
-		mt7530_clear(priv, MT7530_PMCR_P(port), mask);
-}
-
 static int mt7530_phy_read(struct dsa_switch *ds, int port, int regnum)
 {
 	struct mt7530_priv *priv = ds->priv;
@@ -750,7 +739,7 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
 	priv->ports[port].enable = true;
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
 		   priv->ports[port].pm);
-	mt7530_port_set_status(priv, port, 0);
+	mt7530_clear(priv, MT7530_PMCR_P(port), PMCR_LINK_SETTINGS_MASK);
 
 	mutex_unlock(&priv->reg_mutex);
 
@@ -773,7 +762,7 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 	priv->ports[port].enable = false;
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
 		   PCR_MATRIX_CLR);
-	mt7530_port_set_status(priv, port, 0);
+	mt7530_clear(priv, MT7530_PMCR_P(port), PMCR_LINK_SETTINGS_MASK);
 
 	mutex_unlock(&priv->reg_mutex);
 }
@@ -1499,8 +1488,7 @@ static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	mcr_cur = mt7530_read(priv, MT7530_PMCR_P(port));
 	mcr_new = mcr_cur;
-	mcr_new &= ~(PMCR_FORCE_SPEED_1000 | PMCR_FORCE_SPEED_100 |
-		     PMCR_FORCE_FDX | PMCR_TX_FC_EN | PMCR_RX_FC_EN);
+	mcr_new &= ~PMCR_LINK_SETTINGS_MASK;
 	mcr_new |= PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | PMCR_BACKOFF_EN |
 		   PMCR_BACKPR_EN | PMCR_FORCE_MODE;
 
@@ -1508,22 +1496,6 @@ static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
 	if (port == 5 && dsa_is_user_port(ds, 5))
 		mcr_new |= PMCR_EXT_PHY;
 
-	switch (state->speed) {
-	case SPEED_1000:
-		mcr_new |= PMCR_FORCE_SPEED_1000;
-		break;
-	case SPEED_100:
-		mcr_new |= PMCR_FORCE_SPEED_100;
-		break;
-	}
-	if (state->duplex == DUPLEX_FULL) {
-		mcr_new |= PMCR_FORCE_FDX;
-		if (state->pause & MLO_PAUSE_TX)
-			mcr_new |= PMCR_TX_FC_EN;
-		if (state->pause & MLO_PAUSE_RX)
-			mcr_new |= PMCR_RX_FC_EN;
-	}
-
 	if (mcr_new != mcr_cur)
 		mt7530_write(priv, MT7530_PMCR_P(port), mcr_new);
 }
@@ -1534,7 +1506,7 @@ static void mt7530_phylink_mac_link_down(struct dsa_switch *ds, int port,
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	mt7530_port_set_status(priv, port, 0);
+	mt7530_clear(priv, MT7530_PMCR_P(port), PMCR_LINK_SETTINGS_MASK);
 }
 
 static void mt7530_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1545,8 +1517,27 @@ static void mt7530_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				       bool tx_pause, bool rx_pause)
 {
 	struct mt7530_priv *priv = ds->priv;
+	u32 mcr;
+
+	mcr = PMCR_RX_EN | PMCR_TX_EN | PMCR_FORCE_LNK;
+
+	switch (speed) {
+	case SPEED_1000:
+		mcr |= PMCR_FORCE_SPEED_1000;
+		break;
+	case SPEED_100:
+		mcr |= PMCR_FORCE_SPEED_100;
+		break;
+	}
+	if (duplex == DUPLEX_FULL) {
+		mcr |= PMCR_FORCE_FDX;
+		if (tx_pause)
+			mcr |= PMCR_TX_FC_EN;
+		if (rx_pause)
+			mcr |= PMCR_RX_FC_EN;
+	}
 
-	mt7530_port_set_status(priv, port, 1);
+	mt7530_set(priv, MT7530_PMCR_P(port), mcr);
 }
 
 static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index b7cfb3d52b1c..ef9b52f3152b 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -206,6 +206,10 @@ enum mt7530_vlan_port_attr {
 #define  PMCR_FORCE_LNK			BIT(0)
 #define  PMCR_SPEED_MASK		(PMCR_FORCE_SPEED_100 | \
 					 PMCR_FORCE_SPEED_1000)
+#define  PMCR_LINK_SETTINGS_MASK	(PMCR_TX_EN | PMCR_FORCE_SPEED_1000 | \
+					 PMCR_RX_EN | PMCR_FORCE_SPEED_100 | \
+					 PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
+					 PMCR_FORCE_FDX | PMCR_FORCE_LNK)
 
 #define MT7530_PMSR_P(x)		(0x3008 + (x) * 0x100)
 #define  PMSR_EEE1G			BIT(7)
-- 
2.25.1

