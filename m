Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AACE3AE737
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhFUKiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFUKiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:38:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07930C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:35:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so12340691pjn.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qACWu+bnbyPKnWsJHtA+hAZdpnvZk5bHIEy1Pug1Wwg=;
        b=AgvtY9XFqTFRZZMKYLON5qKVKzGP/iBwCiNh2pmuTSvbMRH6lrQt7MwjVsStzRgDh6
         40lvAhPLLEJQ174u7dpwDasEbgJbSVrCy10X4Dyw70FG5vwWiMZJi8CM9H3A/g3Y4Q9l
         1bW3hcQVsOS/xN4MGlUfO2tc1jKpdYv+89m1dmk3ZgqnYHvUOqvVqR/la5SjNs0ELTXb
         dKESFFgD4IaKZ3V9c0mwpIm7v66ECYTc/pR9Ce3ThbQmMSywCBbuxt88w+qgjey3npho
         j0+WEMpRTo/IdF+j6EOC0CX5Ao450J3k93rfEi6nMg4c+wAUWubaXRwiur9rgAeFAOje
         6nXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qACWu+bnbyPKnWsJHtA+hAZdpnvZk5bHIEy1Pug1Wwg=;
        b=gzZi0nG3SEBEb9nbpq9Qi4E0dmUjViqKLbNyW1qDrwIxgay/7MyDhejWyly5xNpY8X
         lA0jVg/9FRM/fjLppxKbY/SWNYBS5gYLsmE7bF6ULPtS+hfBP1dxmVo/v5FOs8/gq7Wx
         f90mT9cEugjEtBU8npPDNedyyQqf1uILSXfUEdlXkfghnWb/jWhjGMJe94cXAX8O+W7d
         t2vXkZf/D4VNFmyeWSlxF5uMdmSF2Yy06+vGjXr7p/pMRCod0SmrB347WSvW0SCL173e
         Jn02x5rfonDq8A/LsO/zoYnzt2LuSnuKm+hyVyIpDgtzk5K41r/9S8NPtLLiOUdR0+K+
         20cQ==
X-Gm-Message-State: AOAM530jsU3snCkQrqmEpAsAEhNm1c/FpDaFwpasAsiGLddWHSyKKut5
        24SN5Rk9RWIhFm/7ng4A9WWpEw==
X-Google-Smtp-Source: ABdhPJy27XwELFM11vFHrYq2LlRolxIXcisWCpcDRW+HzajDIMyFYbCd/wcPAeJ7UNsVnqQN59lsuA==
X-Received: by 2002:a17:90a:7381:: with SMTP id j1mr14004550pjg.29.1624271751494;
        Mon, 21 Jun 2021 03:35:51 -0700 (PDT)
Received: from starnight.local ([150.116.242.79])
        by smtp.googlemail.com with ESMTPSA id ml5sm1124159pjb.3.2021.06.21.03.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 03:35:51 -0700 (PDT)
From:   Jian-Hong Pan <jhp@endlessos.org>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        linux-rpi-kernel@lists.infradead.org,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
Date:   Mon, 21 Jun 2021 18:33:11 +0800
Message-Id: <20210621103310.186334-1-jhp@endlessos.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find the
ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach the
PHY.

bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
...
could not attach to PHY
bcmgenet fd580000.ethernet eth0: failed to connect to PHY
uart-pl011 fe201000.serial: no DMA platform data
libphy: bcmgenet MII bus: probed
...
unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus

This patch makes GENET try to connect the PHY up to 3 times. Also, waits
a while between each time for mdio-bcm-unimac module's loading and
probing.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=213485
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 5335244e4577..64f244471fd3 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -289,6 +289,7 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	struct phy_device *phydev;
 	u32 phy_flags = 0;
 	int ret;
+	int i;
 
 	/* Communicate the integrated PHY revision */
 	if (priv->internal_phy)
@@ -301,8 +302,22 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	priv->old_pause = -1;
 
 	if (dn) {
-		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
-					phy_flags, priv->phy_interface);
+		/* Try to connect the PHY on UniMAC DMIO bus up to 3 times.
+		 * Wait a while between each time for mdio-bcm-unimac module's
+		 * loading and probing.
+		 */
+		phydev = NULL;
+		for (i = 1; i < 4 && !phydev; i++) {
+			netdev_info(dev,
+				    "connect %s on UniMAC MDIO bus %d time",
+				    priv->phy_dn->full_name, i);
+			phydev = of_phy_connect(dev, priv->phy_dn,
+						bcmgenet_mii_setup,
+						phy_flags, priv->phy_interface);
+			if (!phydev && i < 3)
+				msleep(500);
+		}
+
 		if (!phydev) {
 			pr_err("could not attach to PHY\n");
 			return -ENODEV;
-- 
2.32.0

