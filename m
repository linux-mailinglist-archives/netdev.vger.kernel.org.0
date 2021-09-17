Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F305C4100F3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbhIQV5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhIQV5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 17:57:11 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46E0C061574;
        Fri, 17 Sep 2021 14:55:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m26so10457231pff.3;
        Fri, 17 Sep 2021 14:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zTxc3Wdtc4s3d3QzXi4IrshyvmO03k245cg+J15IPmw=;
        b=nHw06hflDjXbOig9Rc0UBUMHaco0gAEGCfHq64OT8ZFPc2zXxUE4sHCSBAcgbdwKDM
         bYIkKO+gBQS/TP9jWya1vAY8c+kaKnjsjtH9MmkAeSRk/x3QPvQs/pUbfSqnL95xTS6g
         iAiLIou+ixEyMi0E5wFHDVQTIO1ak4d45lNKMslESz49iaUK40a5vB8kseMLK6xkMVGh
         Pc/B1g5O43vz9pn6HGt4B6GjsXTBZ3Leo1g9cI3r/FZmx++c0mfSxc8IbXMsJnEXJjaD
         tSI9V77pE8Mpp+Bf9Ym9d3NUwFucB1ysyIYVHWKk78Xhg4m4ZCbDSi95GHcb0xE3Vf2l
         wGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zTxc3Wdtc4s3d3QzXi4IrshyvmO03k245cg+J15IPmw=;
        b=Y/1+FKL58dl76JZlkcUE4OwFLiGaKgJThnbrrAhLPAPNiTBEx5bXpM50c2CVAW2Ts1
         J9gOwIibwRj9i8nEVcaS6dyulF6GDsZ+GynNpSZrl8AaUPCI9uTGsynh7T9R8FUgMMGw
         4yNKfJ2JoL7jt4veVSE5SVGzf3V1V/gTvijMXsCURghENT2ejTLWvFdOU+ECtJhZu/Fh
         lOwvhKmmbPfUXJBCo36tvbyYueyMMITRhhQM16YsRZj7HOGEQAhWR7gYRq7s+6Mao5sQ
         6U6u0+4GhChc0tB48Rgc1+dJYlTyLTNHiPmg0QDh8LaTTFoqlTuo6eEbQBVqQJTavjqx
         Frhg==
X-Gm-Message-State: AOAM530uZbtsrOvhIUPTV4nZU1uFwGkTt1sxOBTThYFJHLVgFunAJHM7
        jouhSGzE8UC+MHqZodxUK1HJ10hl10U=
X-Google-Smtp-Source: ABdhPJyMVityzJdi38AlNeQkFoG4G8QDwRf+eyD88jCFD8HshiBgVvruNWcs6XVWlfLsexl+BcOgqQ==
X-Received: by 2002:a63:7e11:: with SMTP id z17mr11632854pgc.436.1631915747807;
        Fri, 17 Sep 2021 14:55:47 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z33sm7007731pga.20.2021.09.17.14.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 14:55:47 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: bcmgenet: Patch PHY interface for dedicated PHY driver
Date:   Fri, 17 Sep 2021 14:55:38 -0700
Message-Id: <20210917215539.3020216-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are using a dedicated PHY driver (not the Generic PHY driver)
chances are that it is going to configure RGMII delays and do that in a
way that is incompatible with our incorrect interpretation of the
phy_interface value.

Add a quirk in order to reverse the PHY_INTERFACE_MODE_RGMII to the
value of PHY_INTERFACE_MODE_RGMII_ID such that the MAC continues to be
configured the way it used to be, but the PHY driver can account for
adding delays. Conversely when PHY_INTERFACE_MODE_RGMII_TXID is
specified, return PHY_INTERFACE_MODE_RGMII_RXID to the PHY since we will
have enabled a TXC MAC delay (id_mode_dis=0, meaning there is a delay
inserted).

This is not considered a bug fix at this point since it only affects
Broadcom STB platforms shipping with a Device Tree blob that is not
updatable in the field (quite a few devices out there) and which was
generated using the scripted Device Tree environment shipped with those
platforms' SDK.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 38 ++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 89d16c587bb7..2d29de9a33e3 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -286,6 +286,7 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
 	struct device_node *dn = kdev->of_node;
+	phy_interface_t phy_iface = priv->phy_interface;
 	struct phy_device *phydev;
 	u32 phy_flags = 0;
 	int ret;
@@ -300,9 +301,42 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	priv->old_duplex = -1;
 	priv->old_pause = -1;
 
+	/* This is an ugly quirk but we have not been correctly interpreting
+	 * the phy_interface values and we have done that across different
+	 * drivers, so at least we are consistent in our mistakes.
+	 *
+	 * When the Generic PHY driver is in use either the PHY has been
+	 * strapped or programmed correctly by the boot loader so we should
+	 * stick to our incorrect interpretation since we have validated it.
+	 *
+	 * Now when a dedicated PHY driver is in use, we need to reverse the
+	 * meaning of the phy_interface_mode values to something that the PHY
+	 * driver will interpret and act on such that we have two mistakes
+	 * canceling themselves so to speak. We only do this for the two
+	 * modes that GENET driver officially supports on Broadcom STB chips:
+	 * PHY_INTERFACE_MODE_RGMII and PHY_INTERFACE_MODE_RGMII_TXID. Other
+	 * modes are not *officially* supported with the boot loader and the
+	 * scripted environment generating Device Tree blobs for those
+	 * platforms.
+	 *
+	 * Note that internal PHY, MoCA and fixed-link configurations are not
+	 * affected because they use different phy_interface_t values or the
+	 * Generic PHY driver.
+	 */
+	switch (priv->phy_interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		phy_iface = PHY_INTERFACE_MODE_RGMII_ID;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		phy_iface = PHY_INTERFACE_MODE_RGMII_RXID;
+		break;
+	default:
+		break;
+	}
+
 	if (dn) {
 		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
-					phy_flags, priv->phy_interface);
+					phy_flags, phy_iface);
 		if (!phydev) {
 			pr_err("could not attach to PHY\n");
 			return -ENODEV;
@@ -332,7 +366,7 @@ int bcmgenet_mii_probe(struct net_device *dev)
 		phydev->dev_flags = phy_flags;
 
 		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
-					 priv->phy_interface);
+					 phy_iface);
 		if (ret) {
 			pr_err("could not attach to PHY\n");
 			return -ENODEV;
-- 
2.25.1

