Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD526571AF5
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiGLNQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiGLNQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:16:09 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1280D80519;
        Tue, 12 Jul 2022 06:16:04 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2B6752224D;
        Tue, 12 Jul 2022 15:16:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657631762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0q0S8Q96ZyO6ESUfNLtf32EjwK3M5wnz6DlAPCArk/0=;
        b=dU7Gvw0FO1+t3dAqq98T4F8dnbwt9NbD0skFCreGpEDLwG4u5lzNI06s5R5zJyrFlaHWBF
        JY992rfDAlsjQoTHAeaQxREI/oNAgtvfrK+6Vg171MXazQudN39heignRQY3g/aHV4FFIn
        ofYVrsKyrbBm73UH+HOAgQOsdM72PPU=
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 3/4] net: phy: mxl-gpy: rename the FW type field name
Date:   Tue, 12 Jul 2022 15:15:53 +0200
Message-Id: <20220712131554.2737792-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712131554.2737792-1-michael@walle.cc>
References: <20220712131554.2737792-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align the firmware field name with the reference manual where it is
called "major".

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index b6303089d425..ac62b01c61ed 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -56,7 +56,7 @@
 				 PHY_IMASK_ANC)
 
 #define PHY_FWV_REL_MASK	BIT(15)
-#define PHY_FWV_TYPE_MASK	GENMASK(11, 8)
+#define PHY_FWV_MAJOR_MASK	GENMASK(11, 8)
 #define PHY_FWV_MINOR_MASK	GENMASK(7, 0)
 
 /* SGMII */
@@ -78,12 +78,12 @@
 #define WOL_EN			BIT(0)
 
 struct gpy_priv {
-	u8 fw_type;
+	u8 fw_major;
 	u8 fw_minor;
 };
 
 static const struct {
-	int type;
+	int major;
 	int minor;
 } ver_need_sgmii_reaneg[] = {
 	{7, 0x6D},
@@ -222,7 +222,7 @@ static int gpy_probe(struct phy_device *phydev)
 	fw_version = phy_read(phydev, PHY_FWV);
 	if (fw_version < 0)
 		return fw_version;
-	priv->fw_type = FIELD_GET(PHY_FWV_TYPE_MASK, fw_version);
+	priv->fw_major = FIELD_GET(PHY_FWV_MAJOR_MASK, fw_version);
 	priv->fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, fw_version);
 
 	ret = gpy_hwmon_register(phydev);
@@ -242,7 +242,7 @@ static bool gpy_sgmii_need_reaneg(struct phy_device *phydev)
 	size_t i;
 
 	for (i = 0; i < ARRAY_SIZE(ver_need_sgmii_reaneg); i++) {
-		if (priv->fw_type != ver_need_sgmii_reaneg[i].type)
+		if (priv->fw_major != ver_need_sgmii_reaneg[i].major)
 			continue;
 		if (priv->fw_minor < ver_need_sgmii_reaneg[i].minor)
 			return true;
-- 
2.30.2

