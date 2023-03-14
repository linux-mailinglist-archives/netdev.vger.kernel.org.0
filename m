Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C3C6B95EE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjCNNTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjCNNS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:18:56 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78702ABAE5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=tavda8UXLKrs9l
        ANFo8U4RN/BFpi0fs4WuVKPhmPVs0=; b=F2zKgF211WIEEAdGUWvHapL/d26hH9
        GHKORGNixFd0+NOffB0rFLhuyGFsgRO9sRCrV3EEVZrA++DhZY6vzBNx3xh+u33w
        lBWL4ElLJYCoTcwNLafQpi/9fmN/7lJAenIg0eNIdAUd9Ezr2wpYcaTa7c5IBhSS
        g/ycwkUlajY+M=
Received: (qmail 3111634 invoked from network); 14 Mar 2023 14:14:57 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 14 Mar 2023 14:14:57 +0100
X-UD-Smtp-Session: l3s3148p1@uxuWA9z2ms0ujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, kernel@pengutronix.de,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/4] sh_eth: avoid PHY being resumed when interface is not up
Date:   Tue, 14 Mar 2023 14:14:40 +0100
Message-Id: <20230314131443.46342-3-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SH_ETH doesn't need mdiobus suspend/resume, that's why it sets
'mac_managed_pm'. However, setting it needs to be moved from init to
probe, so mdiobus PM functions will really never be called (e.g. when
the interface is not up yet during suspend/resume).

Fixes: 6a1dbfefdae4 ("net: sh_eth: Fix PHY state warning splat during system resume")
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index ed17163d7811..d8ec729825be 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2029,8 +2029,6 @@ static int sh_eth_phy_init(struct net_device *ndev)
 	if (mdp->cd->register_type != SH_ETH_REG_GIGABIT)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
@@ -3097,6 +3095,8 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	struct bb_info *bitbang;
 	struct platform_device *pdev = mdp->pdev;
 	struct device *dev = &mdp->pdev->dev;
+	struct phy_device *phydev;
+	struct device_node *pn;
 
 	/* create bit control struct for PHY */
 	bitbang = devm_kzalloc(dev, sizeof(struct bb_info), GFP_KERNEL);
@@ -3133,6 +3133,14 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	if (ret)
 		goto out_free_bus;
 
+	pn = of_parse_phandle(dev->of_node, "phy-handle", 0);
+	phydev = of_phy_find_device(pn);
+	if (phydev) {
+		phydev->mac_managed_pm = true;
+		put_device(&phydev->mdio.dev);
+	}
+	of_node_put(pn);
+
 	return 0;
 
 out_free_bus:
-- 
2.30.2

