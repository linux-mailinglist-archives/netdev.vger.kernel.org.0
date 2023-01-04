Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD1B65DE0F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 22:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbjADVGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 16:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240309AbjADVG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:06:27 -0500
Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C732CAE47
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:06:26 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id DAxcpwWwVxN58DAxtpFlJp; Wed, 04 Jan 2023 22:06:25 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 04 Jan 2023 22:06:25 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next 2/3] ezchip: Switch to some devm_ function to simplify code
Date:   Wed,  4 Jan 2023 22:05:33 +0100
Message-Id: <e1fd0cc1fd865e58af713c92f09251e6180c1636.1672865629.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
References: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_alloc_etherdev() and devm_register_netdev() can be used to simplify
code.

Now the error handling path of the probe and the remove function are
useless and can be removed completely.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 42 ++++++--------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 6389c6b5005c..21e230150104 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -579,7 +579,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	if (!dev->of_node)
 		return -ENODEV;
 
-	ndev = alloc_etherdev(sizeof(struct nps_enet_priv));
+	ndev = devm_alloc_etherdev(dev, sizeof(struct nps_enet_priv));
 	if (!ndev)
 		return -ENOMEM;
 
@@ -594,10 +594,8 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	ndev->flags &= ~IFF_MULTICAST;
 
 	priv->regs_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(priv->regs_base)) {
-		err = PTR_ERR(priv->regs_base);
-		goto out_netdev;
-	}
+	if (IS_ERR(priv->regs_base))
+		return PTR_ERR(priv->regs_base);
 	dev_dbg(dev, "Registers base address is 0x%p\n", priv->regs_base);
 
 	/* set kernel MAC address to dev */
@@ -607,41 +605,20 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 
 	/* Get IRQ number */
 	priv->irq = platform_get_irq(pdev, 0);
-	if (priv->irq < 0) {
-		err = -ENODEV;
-		goto out_netdev;
-	}
+	if (priv->irq < 0)
+		return -ENODEV;
 
 	netif_napi_add_weight(ndev, &priv->napi, nps_enet_poll,
 			      NPS_ENET_NAPI_POLL_WEIGHT);
 
 	/* Register the driver. Should be the last thing in probe */
-	err = register_netdev(ndev);
-	if (err) {
-		dev_err(dev, "Failed to register ndev for %s, err = 0x%08x\n",
-			ndev->name, (s32)err);
-		goto out_netif_api;
-	}
+	err = devm_register_netdev(dev, ndev);
+	if (err)
+		return dev_err_probe(dev, err, "Failed to register ndev for %s\n",
+				     ndev->name);
 
 	dev_info(dev, "(rx/tx=%d)\n", priv->irq);
 	return 0;
-
-out_netif_api:
-out_netdev:
-	free_netdev(ndev);
-
-	return err;
-}
-
-static s32 nps_enet_remove(struct platform_device *pdev)
-{
-	struct net_device *ndev = platform_get_drvdata(pdev);
-	struct nps_enet_priv *priv = netdev_priv(ndev);
-
-	unregister_netdev(ndev);
-	free_netdev(ndev);
-
-	return 0;
 }
 
 static const struct of_device_id nps_enet_dt_ids[] = {
@@ -652,7 +629,6 @@ MODULE_DEVICE_TABLE(of, nps_enet_dt_ids);
 
 static struct platform_driver nps_enet_driver = {
 	.probe = nps_enet_probe,
-	.remove = nps_enet_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table  = nps_enet_dt_ids,
-- 
2.34.1

