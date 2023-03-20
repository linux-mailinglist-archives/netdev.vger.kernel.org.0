Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBF96C0D19
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjCTJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjCTJVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:21:19 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0D2234D8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=DfsC6bnYi3tDvb
        jmiiFrhH8pT9NOHPzKI8k3QOYtKg4=; b=PO6n0iREOsfnz106nHUPWkLnOvShlT
        TfOKOYGGy8CDH2eTvqBzALWKu4PxkuGshlsdbU1iEVpFQ8RqTaGfh4ZF7yI6Te+n
        j+LuEKyP1LoAKhWmiInnVl6Sm1bLUdyflLP6kyg5Zh73udbWGr3bZEpNzG39b/6c
        GgMm24oe5+fR8=
Received: (qmail 860502 invoked from network); 20 Mar 2023 10:20:48 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 20 Mar 2023 10:20:48 +0100
X-UD-Smtp-Session: l3s3148p1@lVZDcVH3btwujnuq
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/2] smsc911x: avoid PHY being resumed when interface is not up
Date:   Mon, 20 Mar 2023 10:20:41 +0100
Message-Id: <20230320092041.1656-3-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
References: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
Changes since v1:
* no change

In smsc911x_mii_probe(), I remove the sanity check for 'phydev' because
it was already done in smsc911x_mii_init(). Let me know if this is
acceptable or if a more defensive approach is favoured.


 drivers/net/ethernet/smsc/smsc911x.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 67cb5eb9c716..8b875bbbc05e 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1019,12 +1019,7 @@ static int smsc911x_mii_probe(struct net_device *dev)
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
@@ -1037,8 +1032,6 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -1066,6 +1059,7 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 			     struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
+	struct phy_device *phydev;
 	int err = -ENXIO;
 
 	pdata->mii_bus = mdiobus_alloc();
@@ -1108,6 +1102,15 @@ static int smsc911x_mii_init(struct platform_device *pdev,
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

