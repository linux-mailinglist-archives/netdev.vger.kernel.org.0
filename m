Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDC316BC7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhBJQwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbhBJQt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:49:59 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF166C061756;
        Wed, 10 Feb 2021 08:49:18 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4832423E82;
        Wed, 10 Feb 2021 17:48:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612975680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1uSl+dUW0xjnoJ3uxLG4ASQZ0SNxGxoU81I2YBKvtcw=;
        b=rKjgD1pQ6nktHws7DPLib041QY6NsxS/x7pL8h2yBeWmyGhbrRc4az1ZlyQkMPybMhtyKE
        7MGvi43hNc20W9TzGAG5aCDL7a+LTiQ2reTn4ioKJgbk7deDkuWZLu3hBa3fRd/R9iizmI
        A9bcK4v70TmgDh4VcBUFdEx9HTky3qE=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 8/9] net: phy: icplus: add PHY counter for IP101G
Date:   Wed, 10 Feb 2021 17:47:45 +0100
Message-Id: <20210210164746.26336-9-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210164746.26336-1-michael@walle.cc>
References: <20210210164746.26336-1-michael@walle.cc>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v1:
 - renamed the functions to represend a IP101G-only function
 - enable the counters in IP101G's config_init()

 drivers/net/phy/icplus.c | 75 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index a6394ad3cfe0..52ba5a697025 100644
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
@@ -65,8 +71,19 @@ enum ip101gr_sel_intr32 {
 	IP101GR_SEL_INTR32_RXER,
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
+	u64 stats[ARRAY_SIZE(ip101g_hw_stats)];
 };
 
 static int ip175c_config_init(struct phy_device *phydev)
@@ -263,6 +280,20 @@ static int ip101a_config_init(struct phy_device *phydev)
 
 static int ip101g_config_init(struct phy_device *phydev)
 {
+	int ret;
+
+	/* Enable the PHY counters */
+	ret = phy_modify_paged(phydev, 1, IP101G_P1_CNT_CTRL,
+			       CNT_CTRL_RX_EN, CNT_CTRL_RX_EN);
+	if (ret)
+		return ret;
+
+	/* Clear error counters on read */
+	ret = phy_modify_paged(phydev, 8, IP101G_P8_CNT_CTRL,
+			       CNT_CTRL_RDCLR_EN, CNT_CTRL_RDCLR_EN);
+	if (ret)
+		return ret;
+
 	return ip101a_g_config_intr_pin(phydev);
 }
 
@@ -403,6 +434,47 @@ static int ip101g_match_phy_device(struct phy_device *phydev)
 	return ip101a_g_match_phy_device(phydev, false);
 }
 
+static int ip101g_get_sset_count(struct phy_device *phydev)
+{
+	return ARRAY_SIZE(ip101g_hw_stats);
+}
+
+static void ip101g_get_strings(struct phy_device *phydev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ip101g_hw_stats); i++)
+		strscpy(data + i * ETH_GSTRING_LEN,
+			ip101g_hw_stats[i].name, ETH_GSTRING_LEN);
+}
+
+static u64 ip101g_get_stat(struct phy_device *phydev, int i)
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
+static void ip101g_get_stats(struct phy_device *phydev,
+			     struct ethtool_stats *stats, u64 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ip101g_hw_stats); i++)
+		data[i] = ip101g_get_stat(phydev, i);
+}
+
 static struct phy_driver icplus_driver[] = {
 {
 	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
@@ -445,6 +517,9 @@ static struct phy_driver icplus_driver[] = {
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101g_config_init,
 	.soft_reset	= genphy_soft_reset,
+	.get_sset_count = ip101g_get_sset_count,
+	.get_strings	= ip101g_get_strings,
+	.get_stats	= ip101g_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
-- 
2.20.1

