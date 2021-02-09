Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396F7315428
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhBIQm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:42:57 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:36215 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbhBIQlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:41:53 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4DB5323E7C;
        Tue,  9 Feb 2021 17:41:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612888861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OLq7zojglq/Jan3SGQnLAO0bK4fFOVDgCTTyFGeMNaI=;
        b=b/7cPTGhXNinL68BjG1IHoJm6Rn8HLVpeMmw+hxdMQXLgrcdcIGIXz43rNCqJtB/5rPNVn
        MmuHuslkzIE2bHPyjFjf2gPlaLfODkLr+4YfYx8DO/Qrl2bOU5yfkazIAP9HnqUHxVWFJe
        in7ecyORSfnk+mk8820Pfuf7LmDCrGU=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 8/9] net: phy: icplus: add PHY counter for IP101G
Date:   Tue,  9 Feb 2021 17:40:50 +0100
Message-Id: <20210209164051.18156-9-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209164051.18156-1-michael@walle.cc>
References: <20210209164051.18156-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IP101G provides three counters: RX packets, CRC errors and symbol
errors. The error counters can be configured to clear automatically on
read. Unfortunately, this isn't true for the RX packet counter. Because
of this and because the RX packet counter is more likely to overflow,
than the error counters implement only support for the error counters.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/icplus.c | 78 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 858b9326a72d..d1b57d81f281 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -51,6 +51,12 @@ MODULE_LICENSE("GPL");
 
 #define IP101G_DEFAULT_PAGE			16
 
+#define IP101G_P1_CNT_CTRL		17
+#define CNT_CTRL_RX_EN			BIT(13)
+#define IP101G_P8_CNT_CTRL		17
+#define CNT_CTRL_RDCLR_EN		BIT(15)
+#define IP101G_CNT_REG			18
+
 #define IP175C_PHY_ID 0x02430d80
 #define IP1001_PHY_ID 0x02430d90
 #define IP101A_PHY_ID 0x02430c54
@@ -70,9 +76,20 @@ enum ip101_model {
 	IP101G,
 };
 
+struct ip101g_hw_stat {
+	const char *name;
+	int page;
+};
+
+static struct ip101g_hw_stat ip101g_hw_stats[] = {
+	{ "phy_crc_errors", 1 },
+	{ "phy_symbol_errors", 11, },
+};
+
 struct ip101a_g_phy_priv {
 	enum ip101gr_sel_intr32 sel_intr32;
 	enum ip101_model model;
+	u64 stats[ARRAY_SIZE(ip101g_hw_stats)];
 };
 
 static int ip175c_config_init(struct phy_device *phydev)
@@ -254,6 +271,18 @@ static int ip101a_g_config_init(struct phy_device *phydev)
 	struct ip101a_g_phy_priv *priv = phydev->priv;
 	int oldpage, err;
 
+	/* Enable the PHY counters */
+	err = phy_modify_paged(phydev, 1, IP101G_P1_CNT_CTRL,
+			       CNT_CTRL_RX_EN, CNT_CTRL_RX_EN);
+	if (err)
+		return err;
+
+	/* Clear error counters on read */
+	err = phy_modify_paged(phydev, 8, IP101G_P8_CNT_CTRL,
+			       CNT_CTRL_RDCLR_EN, CNT_CTRL_RDCLR_EN);
+	if (err)
+		return err;
+
 	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
 
 	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
@@ -373,6 +402,52 @@ static int ip101a_g_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, IP101G_PAGE_CONTROL, page);
 }
 
+static int ip101a_g_get_sset_count(struct phy_device *phydev)
+{
+	struct ip101a_g_phy_priv *priv = phydev->priv;
+
+	if (priv->model == IP101A)
+		return -EOPNOTSUPP;
+
+	return ARRAY_SIZE(ip101g_hw_stats);
+}
+
+static void ip101a_g_get_strings(struct phy_device *phydev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ip101g_hw_stats); i++)
+		strscpy(data + i * ETH_GSTRING_LEN,
+			ip101g_hw_stats[i].name, ETH_GSTRING_LEN);
+}
+
+static u64 ip101a_g_get_stat(struct phy_device *phydev, int i)
+{
+	struct ip101g_hw_stat stat = ip101g_hw_stats[i];
+	struct ip101a_g_phy_priv *priv = phydev->priv;
+	int val;
+	u64 ret;
+
+	val = phy_read_paged(phydev, stat.page, IP101G_CNT_REG);
+	if (val < 0) {
+		ret = U64_MAX;
+	} else {
+		priv->stats[i] += val;
+		ret = priv->stats[i];
+	}
+
+	return ret;
+}
+
+static void ip101a_g_get_stats(struct phy_device *phydev,
+			       struct ethtool_stats *stats, u64 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ip101g_hw_stats); i++)
+		data[i] = ip101a_g_get_stat(phydev, i);
+}
+
 static struct phy_driver icplus_driver[] = {
 {
 	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
@@ -402,6 +477,9 @@ static struct phy_driver icplus_driver[] = {
 	.read_page	= ip101a_g_read_page,
 	.write_page	= ip101a_g_write_page,
 	.soft_reset	= genphy_soft_reset,
+	.get_sset_count = ip101a_g_get_sset_count,
+	.get_strings	= ip101a_g_get_strings,
+	.get_stats	= ip101a_g_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
-- 
2.20.1

