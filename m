Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EC94C0A13
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiBWDPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbiBWDPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:15:41 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C2E5BD18;
        Tue, 22 Feb 2022 19:15:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5FxgEv_1645586105;
Received: from fdadf40dcbca.tbsite.net(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5FxgEv_1645586105)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Feb 2022 11:15:09 +0800
From:   Heyi Guo <guoheyi@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org
Cc:     Heyi Guo <guoheyi@linux.alibaba.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
Subject: [PATCH 2/3] drivers/net/ftgmac100: adjust code place for function call dependency
Date:   Wed, 23 Feb 2022 11:14:35 +0800
Message-Id: <20220223031436.124858-3-guoheyi@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to prepare for ftgmac100_adjust_link() to call
ftgmac100_reset() directly. Only code places are changed.

Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>
---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Guangbin Huang <huangguangbin2@huawei.com>
Cc: Hao Chen <chenhao288@hisilicon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dylan Hung <dylan_hung@aspeedtech.com>
Cc: netdev@vger.kernel.org


---
 drivers/net/ethernet/faraday/ftgmac100.c | 222 +++++++++++------------
 1 file changed, 111 insertions(+), 111 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 1f3eb44314753..c1deb6e5d26c5 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -989,117 +989,6 @@ static int ftgmac100_alloc_rx_buffers(struct ftgmac100 *priv)
 	return 0;
 }
 
-static void ftgmac100_adjust_link(struct net_device *netdev)
-{
-	struct ftgmac100 *priv = netdev_priv(netdev);
-	struct phy_device *phydev = netdev->phydev;
-	bool tx_pause, rx_pause;
-	int new_speed;
-
-	/* We store "no link" as speed 0 */
-	if (!phydev->link)
-		new_speed = 0;
-	else
-		new_speed = phydev->speed;
-
-	/* Grab pause settings from PHY if configured to do so */
-	if (priv->aneg_pause) {
-		rx_pause = tx_pause = phydev->pause;
-		if (phydev->asym_pause)
-			tx_pause = !rx_pause;
-	} else {
-		rx_pause = priv->rx_pause;
-		tx_pause = priv->tx_pause;
-	}
-
-	/* Link hasn't changed, do nothing */
-	if (phydev->speed == priv->cur_speed &&
-	    phydev->duplex == priv->cur_duplex &&
-	    rx_pause == priv->rx_pause &&
-	    tx_pause == priv->tx_pause)
-		return;
-
-	/* Print status if we have a link or we had one and just lost it,
-	 * don't print otherwise.
-	 */
-	if (new_speed || priv->cur_speed)
-		phy_print_status(phydev);
-
-	priv->cur_speed = new_speed;
-	priv->cur_duplex = phydev->duplex;
-	priv->rx_pause = rx_pause;
-	priv->tx_pause = tx_pause;
-
-	/* Link is down, do nothing else */
-	if (!new_speed)
-		return;
-
-	/* Disable all interrupts */
-	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
-
-	/* Reset the adapter asynchronously */
-	schedule_work(&priv->reset_task);
-}
-
-static int ftgmac100_mii_probe(struct net_device *netdev)
-{
-	struct ftgmac100 *priv = netdev_priv(netdev);
-	struct platform_device *pdev = to_platform_device(priv->dev);
-	struct device_node *np = pdev->dev.of_node;
-	struct phy_device *phydev;
-	phy_interface_t phy_intf;
-	int err;
-
-	/* Default to RGMII. It's a gigabit part after all */
-	err = of_get_phy_mode(np, &phy_intf);
-	if (err)
-		phy_intf = PHY_INTERFACE_MODE_RGMII;
-
-	/* Aspeed only supports these. I don't know about other IP
-	 * block vendors so I'm going to just let them through for
-	 * now. Note that this is only a warning if for some obscure
-	 * reason the DT really means to lie about it or it's a newer
-	 * part we don't know about.
-	 *
-	 * On the Aspeed SoC there are additionally straps and SCU
-	 * control bits that could tell us what the interface is
-	 * (or allow us to configure it while the IP block is held
-	 * in reset). For now I chose to keep this driver away from
-	 * those SoC specific bits and assume the device-tree is
-	 * right and the SCU has been configured properly by pinmux
-	 * or the firmware.
-	 */
-	if (priv->is_aspeed && !(phy_interface_mode_is_rgmii(phy_intf))) {
-		netdev_warn(netdev,
-			    "Unsupported PHY mode %s !\n",
-			    phy_modes(phy_intf));
-	}
-
-	phydev = phy_find_first(priv->mii_bus);
-	if (!phydev) {
-		netdev_info(netdev, "%s: no PHY found\n", netdev->name);
-		return -ENODEV;
-	}
-
-	phydev = phy_connect(netdev, phydev_name(phydev),
-			     &ftgmac100_adjust_link, phy_intf);
-
-	if (IS_ERR(phydev)) {
-		netdev_err(netdev, "%s: Could not attach to PHY\n", netdev->name);
-		return PTR_ERR(phydev);
-	}
-
-	/* Indicate that we support PAUSE frames (see comment in
-	 * Documentation/networking/phy.rst)
-	 */
-	phy_support_asym_pause(phydev);
-
-	/* Display what we found */
-	phy_attached_info(phydev);
-
-	return 0;
-}
-
 static int ftgmac100_mdiobus_read(struct mii_bus *bus, int phy_addr, int regnum)
 {
 	struct net_device *netdev = bus->priv;
@@ -1465,6 +1354,117 @@ static void ftgmac100_reset_task(struct work_struct *work)
 	ftgmac100_reset(priv);
 }
 
+static void ftgmac100_adjust_link(struct net_device *netdev)
+{
+	struct ftgmac100 *priv = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
+	bool tx_pause, rx_pause;
+	int new_speed;
+
+	/* We store "no link" as speed 0 */
+	if (!phydev->link)
+		new_speed = 0;
+	else
+		new_speed = phydev->speed;
+
+	/* Grab pause settings from PHY if configured to do so */
+	if (priv->aneg_pause) {
+		rx_pause = tx_pause = phydev->pause;
+		if (phydev->asym_pause)
+			tx_pause = !rx_pause;
+	} else {
+		rx_pause = priv->rx_pause;
+		tx_pause = priv->tx_pause;
+	}
+
+	/* Link hasn't changed, do nothing */
+	if (phydev->speed == priv->cur_speed &&
+	    phydev->duplex == priv->cur_duplex &&
+	    rx_pause == priv->rx_pause &&
+	    tx_pause == priv->tx_pause)
+		return;
+
+	/* Print status if we have a link or we had one and just lost it,
+	 * don't print otherwise.
+	 */
+	if (new_speed || priv->cur_speed)
+		phy_print_status(phydev);
+
+	priv->cur_speed = new_speed;
+	priv->cur_duplex = phydev->duplex;
+	priv->rx_pause = rx_pause;
+	priv->tx_pause = tx_pause;
+
+	/* Link is down, do nothing else */
+	if (!new_speed)
+		return;
+
+	/* Disable all interrupts */
+	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
+
+	/* Reset the adapter asynchronously */
+	schedule_work(&priv->reset_task);
+}
+
+static int ftgmac100_mii_probe(struct net_device *netdev)
+{
+	struct ftgmac100 *priv = netdev_priv(netdev);
+	struct platform_device *pdev = to_platform_device(priv->dev);
+	struct device_node *np = pdev->dev.of_node;
+	struct phy_device *phydev;
+	phy_interface_t phy_intf;
+	int err;
+
+	/* Default to RGMII. It's a gigabit part after all */
+	err = of_get_phy_mode(np, &phy_intf);
+	if (err)
+		phy_intf = PHY_INTERFACE_MODE_RGMII;
+
+	/* Aspeed only supports these. I don't know about other IP
+	 * block vendors so I'm going to just let them through for
+	 * now. Note that this is only a warning if for some obscure
+	 * reason the DT really means to lie about it or it's a newer
+	 * part we don't know about.
+	 *
+	 * On the Aspeed SoC there are additionally straps and SCU
+	 * control bits that could tell us what the interface is
+	 * (or allow us to configure it while the IP block is held
+	 * in reset). For now I chose to keep this driver away from
+	 * those SoC specific bits and assume the device-tree is
+	 * right and the SCU has been configured properly by pinmux
+	 * or the firmware.
+	 */
+	if (priv->is_aspeed && !(phy_interface_mode_is_rgmii(phy_intf))) {
+		netdev_warn(netdev,
+			    "Unsupported PHY mode %s !\n",
+			    phy_modes(phy_intf));
+	}
+
+	phydev = phy_find_first(priv->mii_bus);
+	if (!phydev) {
+		netdev_info(netdev, "%s: no PHY found\n", netdev->name);
+		return -ENODEV;
+	}
+
+	phydev = phy_connect(netdev, phydev_name(phydev),
+			     &ftgmac100_adjust_link, phy_intf);
+
+	if (IS_ERR(phydev)) {
+		netdev_err(netdev, "%s: Could not attach to PHY\n", netdev->name);
+		return PTR_ERR(phydev);
+	}
+
+	/* Indicate that we support PAUSE frames (see comment in
+	 * Documentation/networking/phy.rst)
+	 */
+	phy_support_asym_pause(phydev);
+
+	/* Display what we found */
+	phy_attached_info(phydev);
+
+	return 0;
+}
+
 static int ftgmac100_open(struct net_device *netdev)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
-- 
2.17.1

