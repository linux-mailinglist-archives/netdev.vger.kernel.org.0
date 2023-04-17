Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE56E42F2
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 10:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDQIwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 04:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQIwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 04:52:39 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3007C210D;
        Mon, 17 Apr 2023 01:52:37 -0700 (PDT)
Received: from smtp102.mailbox.org (unknown [10.196.197.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Q0LR34Cj6z9sdW;
        Mon, 17 Apr 2023 10:52:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cookiesoft.de;
        s=MBO0001; t=1681721551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KsFkyz4MRyQ4FcmUuleFlCbfeDCalAVJgeJVMb81CEY=;
        b=F2E2ZDmFPG4CcXfigz0icbw9QWhIyiXDrJCeN41JD7zd/6vNGygYkQVui9ME/hX3cWaPug
        2mIrey8PBl6Hzn10e3qv0++DxiLztht++eAyVeiwWahF4dO9o2I0iBLal2uDeYrZ/F39Xp
        nkajnZFP14WS8LbzmrgdK8rfE4rPfD8s1yed80XuofAEP2V3yfF4ICONtG8WCiaQtHLr2z
        fV6X+Y8TizBcDNl5cn0dgZmp9X73AX4tbFtoPKhHe+brGDnLhfxo/ab8wQcYiNTqTfl+xY
        OkXtNibHdMn0VSWIzpx6vhpAq5a3n5aUWylQr3MU0Bh1mxrIxJWZH3W1euxqUw==
From:   Marcel Hellwig <git@cookiesoft.de>
To:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     Marcel Hellwig <mhellwig@mut-group.com>,
        Marcel Hellwig <git@cookiesoft.de>
Subject: [PATCH] can: dev: add transceiver capabilities to xilinx_can
Date:   Mon, 17 Apr 2023 10:52:04 +0200
Message-Id: <20230417085204.179268-1-git@cookiesoft.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the xilinx_can driver does not support adding a phy like the
"ti,tcan1043" to its devicetree.

This code makes it possible to add such phy, so that the kernel makes
sure that the PHY is in operational state, when the link is set to an
"up" state.

Signed-off-by: Marcel Hellwig <git@cookiesoft.de>
---
 drivers/net/can/xilinx_can.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 43c812ea1de0..6a5b805d579a 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
 
 #define DRIVER_NAME	"xilinx_can"
@@ -215,6 +216,7 @@ struct xcan_priv {
 	struct clk *bus_clk;
 	struct clk *can_clk;
 	struct xcan_devtype_data devtype;
+	struct phy *transceiver;
 };
 
 /* CAN Bittiming constants as per Xilinx CAN specs */
@@ -1419,6 +1421,12 @@ static int xcan_open(struct net_device *ndev)
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
 
+	ret = phy_power_on(priv->transceiver);
+	if (ret) {
+		netdev_err(ndev, "%s: phy_power_on failed(%d)\n", __func__, ret);
+		return ret;
+	}
+
 	ret = pm_runtime_get_sync(priv->dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
@@ -1461,6 +1469,7 @@ static int xcan_open(struct net_device *ndev)
 err_irq:
 	free_irq(ndev->irq, ndev);
 err:
+	phy_power_off(priv->transceiver);
 	pm_runtime_put(priv->dev);
 
 	return ret;
@@ -1482,6 +1491,7 @@ static int xcan_close(struct net_device *ndev)
 	free_irq(ndev->irq, ndev);
 	close_candev(ndev);
 
+	phy_power_off(priv->transceiver);
 	pm_runtime_put(priv->dev);
 
 	return 0;
@@ -1713,6 +1723,7 @@ static int xcan_probe(struct platform_device *pdev)
 {
 	struct net_device *ndev;
 	struct xcan_priv *priv;
+	struct phy *transceiver;
 	const struct of_device_id *of_id;
 	const struct xcan_devtype_data *devtype = &xcan_axi_data;
 	void __iomem *addr;
@@ -1843,6 +1854,14 @@ static int xcan_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
+	transceiver = devm_phy_optional_get(&pdev->dev, NULL);
+	if (IS_ERR(transceiver)) {
+		ret = PTR_ERR(transceiver);
+		dev_err_probe(&pdev->dev, ret, "failed to get phy\n");
+		goto err_free;
+	}
+	priv->transceiver = transceiver;
+
 	priv->write_reg = xcan_write_reg_le;
 	priv->read_reg = xcan_read_reg_le;
 
@@ -1869,6 +1888,7 @@ static int xcan_probe(struct platform_device *pdev)
 		goto err_disableclks;
 	}
 
+	of_can_transceiver(ndev);
 	pm_runtime_put(&pdev->dev);
 
 	if (priv->devtype.flags & XCAN_FLAG_CANFD_2) {
-- 
2.34.1

