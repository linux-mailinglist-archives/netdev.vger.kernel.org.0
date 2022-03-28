Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4567D4E95E5
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 13:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242044AbiC1L4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 07:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241769AbiC1L4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 07:56:23 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415D13F8B6;
        Mon, 28 Mar 2022 04:52:36 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4803C22249;
        Mon, 28 Mar 2022 13:52:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648468354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eRjPElhQopDSElrlp5mEAUIG8VZuLHV4XKTK/xd/xVQ=;
        b=X+OR4j71vkeL1JwsqlcdHJyU8sMbD7I3BfjnfVCxUNEm84tsYYumOfTHBoKKXwNuBGpcKd
        dTxWOp0WnSS2jucTmvh5BuRyfCqlLxqWf2QwCHXkXRrLyltjSlqCLt3ExedT5O5ZeZQIyt
        1NhlD/QhttdhN/CsEn1clq5xvdWqPRQ=
From:   Michael Walle <michael@walle.cc>
To:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH v1 2/2] net: phy: use hwmon_sanitize_name()
Date:   Mon, 28 Mar 2022 13:52:26 +0200
Message-Id: <20220328115226.3042322-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220328115226.3042322-1-michael@walle.cc>
References: <20220328115226.3042322-1-michael@walle.cc>
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

Instead of open-coding it, use the new hwmon_sanitize_name() in th
nxp-tja11xx and sfp driver.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/nxp-tja11xx.c | 5 +----
 drivers/net/phy/sfp.c         | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 9944cc501806..3973aa1b90dc 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -444,15 +444,12 @@ static int tja11xx_hwmon_register(struct phy_device *phydev,
 				  struct tja11xx_priv *priv)
 {
 	struct device *dev = &phydev->mdio.dev;
-	int i;
 
 	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
 	if (!priv->hwmon_name)
 		return -ENOMEM;
 
-	for (i = 0; priv->hwmon_name[i]; i++)
-		if (hwmon_is_bad_char(priv->hwmon_name[i]))
-			priv->hwmon_name[i] = '_';
+	hwmon_sanitize_name(priv->hwmon_name);
 
 	priv->hwmon_dev =
 		devm_hwmon_device_register_with_info(dev, priv->hwmon_name,
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4dfb79807823..35a4641303eb 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1289,7 +1289,7 @@ static const struct hwmon_chip_info sfp_hwmon_chip_info = {
 static void sfp_hwmon_probe(struct work_struct *work)
 {
 	struct sfp *sfp = container_of(work, struct sfp, hwmon_probe.work);
-	int err, i;
+	int err;
 
 	/* hwmon interface needs to access 16bit registers in atomic way to
 	 * guarantee coherency of the diagnostic monitoring data. If it is not
@@ -1323,9 +1323,7 @@ static void sfp_hwmon_probe(struct work_struct *work)
 		return;
 	}
 
-	for (i = 0; sfp->hwmon_name[i]; i++)
-		if (hwmon_is_bad_char(sfp->hwmon_name[i]))
-			sfp->hwmon_name[i] = '_';
+	hwmon_sanitize_name(sfp->hwmon_name);
 
 	sfp->hwmon_dev = hwmon_device_register_with_info(sfp->dev,
 							 sfp->hwmon_name, sfp,
-- 
2.30.2

