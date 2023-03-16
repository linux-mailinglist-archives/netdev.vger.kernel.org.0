Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20836BC799
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjCPHqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjCPHqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:46:16 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB532A568F
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=zl2jnjzDWpy3C4
        fB7TuVFiW4MYKclvO6XP0vE27XA8A=; b=MP4aeJnDTqGMF504Tj7vAH+ymvPq6/
        iwQaNrbgixzVmfBPrGf06njGKslRidfB0Ls7eDVDnht1EP0baYD/SsYBFbfQ4f7m
        9qPkg9sFl0V39b3683Ri8LrF1JH0FqMNj0600pQwSGzarUnBD3DR0Afjc0EPQjZn
        jcb5oiiNBsm0g=
Received: (qmail 3694275 invoked from network); 16 Mar 2023 08:46:10 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 16 Mar 2023 08:46:10 +0100
X-UD-Smtp-Session: l3s3148p1@Kbx3p//2XJwujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] smsc911x: avoid PHY being resumed when interface is not up
Date:   Thu, 16 Mar 2023 08:45:58 +0100
Message-Id: <20230316074558.15268-3-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230316074558.15268-1-wsa+renesas@sang-engineering.com>
References: <20230316074558.15268-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMSC911x doesn't need mdiobus suspend/resume, that's why it sets
'mac_managed_pm'. However, setting it needs to be moved from init to
probe, so mdiobus PM functions will really never be called (e.g. when
the interface is not up yet during suspend/resume). The errno is changed
because ENODEV has a special meaning when returned in probe().

Fixes: 3ce9f2bef755 ("net: smsc911x: Stop and start PHY during suspend and resume")
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/smsc/smsc911x.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 9d12fd54281a..4cc5b9833e8f 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1015,12 +1015,7 @@ static int smsc911x_mii_probe(struct net_device *dev)
 	struct phy_device *phydev = NULL;
 	int ret;
 
-	/* find the first phy */
 	phydev = phy_find_first(pdata->mii_bus);
-	if (!phydev) {
-		netdev_err(dev, "no PHY found\n");
-		return -ENODEV;
-	}
 
 	SMSC_TRACE(pdata, probe, "PHY: addr %d, phy_id 0x%08X",
 		   phydev->mdio.addr, phydev->phy_id);
@@ -1033,8 +1028,6 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -1062,6 +1055,7 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 			     struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
+	struct phy_device *phydev;
 	int err = -ENXIO;
 
 	pdata->mii_bus = mdiobus_alloc();
@@ -1104,6 +1098,15 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 		goto err_out_free_bus_2;
 	}
 
+	phydev = phy_find_first(pdata->mii_bus);
+	if (!phydev) {
+		netdev_err(dev, "no PHY found\n");
+		err = -ENOENT;
+		goto err_out_free_bus_2;
+	}
+
+	phydev->mac_managed_pm = true;
+
 	return 0;
 
 err_out_free_bus_2:
-- 
2.30.2

