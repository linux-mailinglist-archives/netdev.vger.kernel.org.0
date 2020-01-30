Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FE614E044
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 18:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgA3RyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 12:54:11 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:40109 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgA3RyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 12:54:10 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2020 12:54:09 EST
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 58CF323D1F;
        Thu, 30 Jan 2020 18:54:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1580406847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kaOfHjbgVG2hzVamygH5MQlu1cASd7Wu6GtVr8voMJY=;
        b=vcis+tVuUO0ZJCzge+HFilMLMfo/b8Oj8OwV6bBn7AyTMSwMt+79UhksdsPUvO0OgSW8bb
        tvF60c+jQaFBoVhOqsp+m48A2YWbiwSz2sAmNOb4uLpNtQK+p1dgtlviORzBMHOBbDy/70
        Jac/+ocnMCDKiSrk2odDteTr1VBP8S0=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: at803x: disable vddio regulator
Date:   Thu, 30 Jan 2020 18:54:02 +0100
Message-Id: <20200130175402.19567-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 58CF323D1F
X-Spamd-Result: default: False [6.40 / 15.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[davemloft.net,armlinux.org.uk,gmail.com,lunn.ch,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The probe() might enable a VDDIO regulator, which needs to be disabled
again before calling regulator_put(). Add a remove() function.

Fixes: 2f664823a470 ("net: phy: at803x: add device tree binding")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index aee62610bade..481cf48c9b9e 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -489,6 +489,14 @@ static int at803x_probe(struct phy_device *phydev)
 	return at803x_parse_dt(phydev);
 }
 
+static void at803x_remove(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	if (priv->vddio)
+		regulator_disable(priv->vddio);
+}
+
 static int at803x_clk_out_config(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
@@ -711,6 +719,7 @@ static struct phy_driver at803x_driver[] = {
 	.name			= "Qualcomm Atheros AR8035",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
@@ -726,6 +735,7 @@ static struct phy_driver at803x_driver[] = {
 	.name			= "Qualcomm Atheros AR8030",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
 	.set_wol		= at803x_set_wol,
@@ -741,6 +751,7 @@ static struct phy_driver at803x_driver[] = {
 	.name			= "Qualcomm Atheros AR8031/AR8033",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
-- 
2.20.1

