Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C6B3185EC
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBKHy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhBKHv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:51:57 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B388AC061793;
        Wed, 10 Feb 2021 23:51:59 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1E41D23E86;
        Thu, 11 Feb 2021 08:48:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613029681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YGa02HwcH6go5l6ROgYX9P7VfADAazrm+ZJjRSzbFv4=;
        b=vLhM0WAOK7HlmTz84mChdlvEKIAZKZzFG4zi4YPJlpjnYVqvTRtCWyt19rfSTsiWJOcfyq
        fUtbpympM/cJlytBtpEFvkykBmqSxW7ykApsZLLUNwVdbnEYj1PqaJKNWs5FQf2HNygr/v
        TNgYvFKqiBcoLNaSWP3DZ/PjKWmAZgc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v4 6/9] net: phy: icplus: don't set APS_EN bit on IP101G
Date:   Thu, 11 Feb 2021 08:47:47 +0100
Message-Id: <20210211074750.28674-7-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211074750.28674-1-michael@walle.cc>
References: <20210211074750.28674-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bit is reserved as 'always-write-1'. While this is not a particular
error, because we are only setting it, guard it by checking the model to
prevent errors in the future.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v3:
 - none

Changes since v2:
 - none

Changes since v1:
 - dropped the model check. Instead use two different functions.

 drivers/net/phy/icplus.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index dee4f4d988a2..bc2b58061507 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -208,10 +208,10 @@ static int ip101a_g_probe(struct phy_device *phydev)
 	return 0;
 }
 
-static int ip101a_g_config_init(struct phy_device *phydev)
+static int ip101a_g_config_intr_pin(struct phy_device *phydev)
 {
 	struct ip101a_g_phy_priv *priv = phydev->priv;
-	int err, c;
+	int err;
 
 	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
 	switch (priv->sel_intr32) {
@@ -241,11 +241,24 @@ static int ip101a_g_config_init(struct phy_device *phydev)
 		break;
 	}
 
+	return 0;
+}
+
+static int ip101a_config_init(struct phy_device *phydev)
+{
+	int ret;
+
 	/* Enable Auto Power Saving mode */
-	c = phy_read(phydev, IP10XX_SPEC_CTRL_STATUS);
-	c |= IP101A_G_APS_ON;
+	ret = phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS, IP101A_G_APS_ON);
+	if (ret)
+		return ret;
 
-	return phy_write(phydev, IP10XX_SPEC_CTRL_STATUS, c);
+	return ip101a_g_config_intr_pin(phydev);
+}
+
+static int ip101g_config_init(struct phy_device *phydev)
+{
+	return ip101a_g_config_intr_pin(phydev);
 }
 
 static int ip101a_g_ack_interrupt(struct phy_device *phydev)
@@ -379,7 +392,7 @@ static struct phy_driver icplus_driver[] = {
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
-	.config_init	= ip101a_g_config_init,
+	.config_init	= ip101a_config_init,
 	.soft_reset	= genphy_soft_reset,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
@@ -389,7 +402,7 @@ static struct phy_driver icplus_driver[] = {
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
-	.config_init	= ip101a_g_config_init,
+	.config_init	= ip101g_config_init,
 	.soft_reset	= genphy_soft_reset,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
-- 
2.20.1

