Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D7649B989
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347777AbiAYRBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345205AbiAYQ7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:59:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27ACC061788
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wD8jzBB0QKON7Vy1kuZDguDO+NgQeNfPXsqQhoX8kAc=; b=Hl5vIO/fn05moMRYjd1FsxGUyX
        ibt3qiShO6Kk+t6PCxWLCLgnObXLGqJm7pZHYH3A0yrU3WadXuPmVLeiZnEwx24hkdyG4bq0TmQZu
        OXJE3hQDXIqSIel5FcuOFpK5oM1aWRZYo85xFsbcasn+HKrbAExxaYfelsz6GsVRlih7s/35X0pju
        MQ3T4jYth0SCr18yxlvVzMVYRMc+YRgRuWz9FVF3LGN9TMmFkCKYIcp1w7LIsWfebjMQp49Wglwbt
        K3rrH1/PwEQdUYOcIqAuaV+DqA0VTOXY5q5fZ3JdYhKfkt8JcD/JqRiJTKAo8a9pL8ktmfPWLgeNh
        Y+WxASPA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57536 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCPAH-0002F8-M6; Tue, 25 Jan 2022 16:59:29 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCPAH-005LdI-3e; Tue, 25 Jan 2022 16:59:29 +0000
In-Reply-To: <YfAsXaXfSGQX8w75@shell.armlinux.org.uk>
References: <YfAsXaXfSGQX8w75@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: mvneta: reorder initialisation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCPAH-005LdI-3e@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:59:29 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-order the mvneta initialisation to move devm based resources and
easy setup earlier in the probe function. The primary reason for this
is to allow us to switch the driver to use phylink's mac_select_pcs()
callback.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 103 +++++++++++++-------------
 1 file changed, 51 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 57c708b55685..c4aadb6a5640 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5365,26 +5365,62 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
-	dev->irq = irq_of_parse_and_map(dn, 0);
-	if (dev->irq == 0)
-		return -EINVAL;
+	dev->tx_queue_len = MVNETA_MAX_TXD;
+	dev->watchdog_timeo = 5 * HZ;
+	dev->netdev_ops = &mvneta_netdev_ops;
+	dev->ethtool_ops = &mvneta_eth_tool_ops;
+
+	pp = netdev_priv(dev);
+	spin_lock_init(&pp->lock);
+	pp->dn = dn;
+
+	pp->rxq_def = rxq_def;
+	pp->indir[0] = rxq_def;
 
 	err = of_get_phy_mode(dn, &phy_mode);
 	if (err) {
 		dev_err(&pdev->dev, "incorrect phy-mode\n");
-		goto err_free_irq;
+		return err;
 	}
 
+	pp->phy_interface = phy_mode;
+
 	comphy = devm_of_phy_get(&pdev->dev, dn, NULL);
-	if (comphy == ERR_PTR(-EPROBE_DEFER)) {
-		err = -EPROBE_DEFER;
-		goto err_free_irq;
-	} else if (IS_ERR(comphy)) {
+	if (comphy == ERR_PTR(-EPROBE_DEFER))
+		return -EPROBE_DEFER;
+
+	if (IS_ERR(comphy))
 		comphy = NULL;
+
+	pp->comphy = comphy;
+
+	pp->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(pp->base))
+		return PTR_ERR(pp->base);
+
+	/* Get special SoC configurations */
+	if (of_device_is_compatible(dn, "marvell,armada-3700-neta"))
+		pp->neta_armada3700 = true;
+
+	dev->irq = irq_of_parse_and_map(dn, 0);
+	if (dev->irq == 0)
+		return -EINVAL;
+
+	pp->clk = devm_clk_get(&pdev->dev, "core");
+	if (IS_ERR(pp->clk))
+		pp->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pp->clk)) {
+		err = PTR_ERR(pp->clk);
+		goto err_free_irq;
 	}
 
-	pp = netdev_priv(dev);
-	spin_lock_init(&pp->lock);
+	clk_prepare_enable(pp->clk);
+
+	pp->clk_bus = devm_clk_get(&pdev->dev, "bus");
+	if (!IS_ERR(pp->clk_bus))
+		clk_prepare_enable(pp->clk_bus);
+
+	pp->phylink_pcs.ops = &mvneta_phylink_pcs_ops;
 
 	pp->phylink_config.dev = &dev->dev;
 	pp->phylink_config.type = PHYLINK_NETDEV;
@@ -5421,55 +5457,18 @@ static int mvneta_probe(struct platform_device *pdev)
 				 phy_mode, &mvneta_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
-		goto err_free_irq;
+		goto err_clk;
 	}
 
-	dev->tx_queue_len = MVNETA_MAX_TXD;
-	dev->watchdog_timeo = 5 * HZ;
-	dev->netdev_ops = &mvneta_netdev_ops;
-
-	dev->ethtool_ops = &mvneta_eth_tool_ops;
-
 	pp->phylink = phylink;
-	pp->comphy = comphy;
-	pp->phy_interface = phy_mode;
-	pp->dn = dn;
-
-	pp->rxq_def = rxq_def;
-	pp->indir[0] = rxq_def;
-
-	/* Get special SoC configurations */
-	if (of_device_is_compatible(dn, "marvell,armada-3700-neta"))
-		pp->neta_armada3700 = true;
-
-	pp->clk = devm_clk_get(&pdev->dev, "core");
-	if (IS_ERR(pp->clk))
-		pp->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pp->clk)) {
-		err = PTR_ERR(pp->clk);
-		goto err_free_phylink;
-	}
-
-	clk_prepare_enable(pp->clk);
 
-	pp->clk_bus = devm_clk_get(&pdev->dev, "bus");
-	if (!IS_ERR(pp->clk_bus))
-		clk_prepare_enable(pp->clk_bus);
-
-	pp->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(pp->base)) {
-		err = PTR_ERR(pp->base);
-		goto err_clk;
-	}
-
-	pp->phylink_pcs.ops = &mvneta_phylink_pcs_ops;
 	phylink_set_pcs(phylink, &pp->phylink_pcs);
 
 	/* Alloc per-cpu port structure */
 	pp->ports = alloc_percpu(struct mvneta_pcpu_port);
 	if (!pp->ports) {
 		err = -ENOMEM;
-		goto err_clk;
+		goto err_free_phylink;
 	}
 
 	/* Alloc per-cpu stats */
@@ -5613,12 +5612,12 @@ static int mvneta_probe(struct platform_device *pdev)
 	free_percpu(pp->stats);
 err_free_ports:
 	free_percpu(pp->ports);
-err_clk:
-	clk_disable_unprepare(pp->clk_bus);
-	clk_disable_unprepare(pp->clk);
 err_free_phylink:
 	if (pp->phylink)
 		phylink_destroy(pp->phylink);
+err_clk:
+	clk_disable_unprepare(pp->clk_bus);
+	clk_disable_unprepare(pp->clk);
 err_free_irq:
 	irq_dispose_mapping(dev->irq);
 	return err;
-- 
2.30.2

