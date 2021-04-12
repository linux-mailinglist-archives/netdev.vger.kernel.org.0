Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD4035C617
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240491AbhDLMV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:21:27 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:50835 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238059AbhDLMV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 08:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=oh4kxZwGwy53nO5b07oWCLMSgMZkgNXyPwI/EEEgYp0=;
        b=BVAfYqIVJvmgjXBbf+qX8BJu5es9xlstzTa5zY7BQIlxWrS655ykUZvvS2z2XUKbc1Ki/6X1FU4Ei
         C89ZyYKYd28R5ybUAKW4L2fqX3fckwIqVSoF+psbf4PINDjtV9zm6k7UmcDzZXyL6iZln3iqUyKrpu
         2Cf1YliPKss7dIIPwfaHozvRkF53b3vnQTfpG7mT7sUtg1rbjrDXExAJ6h64drmhNpnAgNaN6bjHAl
         ZXvliT4PjWFTcX2PoXfkv1rbKLNUWauMZ+UkWYLFwAZIZjyMoyBdqjdrWmKx4macZbPwjpiP0me2l2
         Eu3Cw6v3dZNuRA+QzzWvTmWM8aVeZ+w==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.223.189])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 12 Apr 2021 15:20:56 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link is operational
Date:   Mon, 12 Apr 2021 15:16:59 +0300
Message-Id: <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618227910.git.i.bornyakov@metrotek.ru>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
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

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell-88x2222.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index eca8c2f20684..fb285ac741b2 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -51,6 +51,7 @@
 struct mv2222_data {
 	phy_interface_t line_interface;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	bool sfp_link;
 };
 
 /* SFI PMA transmit enable */
@@ -148,6 +149,9 @@ static int mv2222_read_status(struct phy_device *phydev)
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
 
+	if (!priv->sfp_link)
+		return 0;
+
 	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
 		link = mv2222_read_status_10g(phydev);
 	else
@@ -446,9 +450,31 @@ static void mv2222_sfp_remove(void *upstream)
 	linkmode_zero(priv->supported);
 }
 
+static void mv2222_sfp_link_up(void *upstream)
+{
+	struct phy_device *phydev = upstream;
+	struct mv2222_data *priv;
+
+	priv = (struct mv2222_data *)phydev->priv;
+
+	priv->sfp_link = true;
+}
+
+static void mv2222_sfp_link_down(void *upstream)
+{
+	struct phy_device *phydev = upstream;
+	struct mv2222_data *priv;
+
+	priv = (struct mv2222_data *)phydev->priv;
+
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


