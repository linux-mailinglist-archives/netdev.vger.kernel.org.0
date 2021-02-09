Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4210315425
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhBIQmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbhBIQlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:41:51 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5190C06174A;
        Tue,  9 Feb 2021 08:41:10 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D40AA23E72;
        Tue,  9 Feb 2021 17:40:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612888860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJNVxqE7Xse8XBjBEKAe7Qk6Rnt0Snkjba3AveKRohU=;
        b=HijcEWfPxGz0uJt/Pxp18MnH9WYukHuyEoxWToXi4cz9PUNuCVEY1DOCKrzBY3RsBKcMQU
        K461ZQRSyoIK8yEzDE+B70a2SqXdJxUcZW2lBUZFS+wgc0EhmsMMkxZj2xwvuPBVFAJc+E
        0RFs3vPUiY75R1nlIlna6k9lZ5jptEc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 5/9] net: phy: icplus: add IP101A/IP101G model detection
Date:   Tue,  9 Feb 2021 17:40:47 +0100
Message-Id: <20210209164051.18156-6-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209164051.18156-1-michael@walle.cc>
References: <20210209164051.18156-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, the IP101A and IP101G share the same PHY identifier.
While most of the functions are somewhat backwards compatible, there is
for example the APS_EN bit on the IP101A but on the IP101G this bit
reserved. Also, the IP101G has many more functionalities.

Deduce the model by accessing the page select register which - according
to the datasheet - is not available on the IP101A. If this register is
writable, assume we have an IP101G.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/icplus.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 036bac628b11..189a9a34ed5f 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -44,6 +44,8 @@ MODULE_LICENSE("GPL");
 #define IP101A_G_IRQ_DUPLEX_CHANGE	BIT(1)
 #define IP101A_G_IRQ_LINK_CHANGE	BIT(0)
 
+#define IP101G_PAGE_CONTROL				0x14
+#define IP101G_PAGE_CONTROL_MASK			GENMASK(4, 0)
 #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
 #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
 
@@ -61,8 +63,14 @@ enum ip101gr_sel_intr32 {
 	IP101GR_SEL_INTR32_RXER,
 };
 
+enum ip101_model {
+	IP101A,
+	IP101G,
+};
+
 struct ip101a_g_phy_priv {
 	enum ip101gr_sel_intr32 sel_intr32;
+	enum ip101_model model;
 };
 
 static int ip175c_config_init(struct phy_device *phydev)
@@ -175,6 +183,39 @@ static int ip175c_config_aneg(struct phy_device *phydev)
 	return 0;
 }
 
+/* The IP101A and the IP101G share the same PHY identifier.The IP101G seems to
+ * be a successor of the IP101A and implements more functions. Amongst other
+ * things a page select register, which is not available on the IP101. Use this
+ * to distinguish these two.
+ */
+static int ip101a_g_detect_model(struct phy_device *phydev)
+{
+	struct ip101a_g_phy_priv *priv = phydev->priv;
+	int oldval, ret;
+
+	oldval = phy_read(phydev, IP101G_PAGE_CONTROL);
+	if (oldval < 0)
+		return oldval;
+
+	ret = phy_write(phydev, IP101G_PAGE_CONTROL, 0xffff);
+	if (ret)
+		return ret;
+
+	ret = phy_read(phydev, IP101G_PAGE_CONTROL);
+	if (ret < 0)
+		return ret;
+
+	if (ret == IP101G_PAGE_CONTROL_MASK)
+		priv->model = IP101G;
+	else
+		priv->model = IP101A;
+
+	phydev_dbg(phydev, "Detected %s\n",
+		   priv->model == IP101G ? "IP101G" : "IP101A");
+
+	return phy_write(phydev, IP101G_PAGE_CONTROL, oldval);
+}
+
 static int ip101a_g_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -203,7 +244,7 @@ static int ip101a_g_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
-	return 0;
+	return ip101a_g_detect_model(phydev);
 }
 
 static int ip101a_g_config_init(struct phy_device *phydev)
-- 
2.20.1

