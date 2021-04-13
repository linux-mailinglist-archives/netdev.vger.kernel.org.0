Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDEB35E7E3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhDMU7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:59:14 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:59154 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232385AbhDMU7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=P88pMk4PnSldad+6WHmqsfjiq5x8YoXoUvHJ8oiVJbk=;
        b=rdc5cufNwaXBLpPzskGKVzs4Jm1+Ug7w1ttWb3+QNM22YUskFVUqNYLybDNrbwMq9SPuhZ0NXLuEn
         fuKy5AsBgrlpeedoWQqsQuXWzkaNUSapVIpT9BTwm335dlPTfKMbe3DYfVTBstMOh76rSQEGHaW7OK
         71b0wq9DO6lfK++FBxcCULNT/e79ksXIMyvLooDIZfauYGpcfHrjSABVl/san3aUwjQLkeb3f2QtV4
         p6H7+iXeA9CdEe4TC1O6NGbQZnxrG39s7ZyKvS628E+QecT8XGog8hQVBRELnQABZx4IvZFoUqKseS
         th3Pc6i/10tW/pVrHNoXWKIAJjwAu5Q==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.223.189])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 13 Apr 2021 23:58:35 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/3] net: phy: marvell-88x2222: check that link is operational
Date:   Tue, 13 Apr 2021 23:54:50 +0300
Message-Id: <2dbac64b0eb7d91962d1f66ac485b8efaa8b0528.1618347034.git.i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618347034.git.i.bornyakov@metrotek.ru>
References: <cover.1618347034.git.i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFP modules uses RX_LOS for link indication. In such cases link
will be always up, even without cable connected. RX_LOS changes will
trigger link_up()/link_down() upstream operations. Thus, check that SFP
link is operational before actual read link status.

If there is no SFP cage connected to the tranciever, check only PMD
Recieve Signal Detect register.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell-88x2222.c | 43 +++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index eca8c2f20684..28fe520228a4 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -32,6 +32,10 @@
 #define	MV_HOST_RST_SW	BIT(7)
 #define	MV_PORT_RST_SW	(MV_LINE_RST_SW | MV_HOST_RST_SW)
 
+/* PMD Receive Signal Detect */
+#define	MV_RX_SIGNAL_DETECT		0x000A
+#define	MV_RX_SIGNAL_DETECT_GLOBAL	BIT(0)
+
 /* 1000Base-X/SGMII Control Register */
 #define	MV_1GBX_CTRL		(0x2000 + MII_BMCR)
 
@@ -51,6 +55,7 @@
 struct mv2222_data {
 	phy_interface_t line_interface;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	bool sfp_link;
 };
 
 /* SFI PMA transmit enable */
@@ -139,6 +144,21 @@ static int mv2222_read_status_1g(struct phy_device *phydev)
 	return link;
 }
 
+static bool mv2222_link_is_operational(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_RX_SIGNAL_DETECT);
+	if (val < 0 || !(val & MV_RX_SIGNAL_DETECT_GLOBAL))
+		return false;
+
+	if (phydev->sfp_bus && !priv->sfp_link)
+		return false;
+
+	return true;
+}
+
 static int mv2222_read_status(struct phy_device *phydev)
 {
 	struct mv2222_data *priv = phydev->priv;
@@ -148,6 +168,9 @@ static int mv2222_read_status(struct phy_device *phydev)
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
 
+	if (!mv2222_link_is_operational(phydev))
+		return 0;
+
 	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
 		link = mv2222_read_status_10g(phydev);
 	else
@@ -446,9 +469,29 @@ static void mv2222_sfp_remove(void *upstream)
 	linkmode_zero(priv->supported);
 }
 
+static void mv2222_sfp_link_up(void *upstream)
+{
+	struct phy_device *phydev = upstream;
+	struct mv2222_data *priv;
+
+	priv = phydev->priv;
+	priv->sfp_link = true;
+}
+
+static void mv2222_sfp_link_down(void *upstream)
+{
+	struct phy_device *phydev = upstream;
+	struct mv2222_data *priv;
+
+	priv = phydev->priv;
+	priv->sfp_link = false;
+}
+
 static const struct sfp_upstream_ops sfp_phy_ops = {
 	.module_insert = mv2222_sfp_insert,
 	.module_remove = mv2222_sfp_remove,
+	.link_up = mv2222_sfp_link_up,
+	.link_down = mv2222_sfp_link_down,
 	.attach = phy_sfp_attach,
 	.detach = phy_sfp_detach,
 };
-- 
2.26.3


