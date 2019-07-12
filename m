Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D2266FD6
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfGLNQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:16:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56694 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727189AbfGLNQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 09:16:43 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EE4DE11277CF686DA60C;
        Fri, 12 Jul 2019 21:16:40 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 12 Jul 2019
 21:16:31 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sergei.shtylyov@cogentembedded.com>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH] net: hisilicon: Use devm_platform_ioremap_resource
Date:   Fri, 12 Jul 2019 21:16:24 +0800
Message-ID: <1562937384-121710-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource instead of
devm_ioremap_resource. Make the code simpler.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c    | 7 ++-----
 drivers/net/ethernet/hisilicon/hisi_femac.c   | 7 ++-----
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 7 ++-----
 drivers/net/ethernet/hisilicon/hns_mdio.c     | 4 +---
 4 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 6256357..d604528 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -899,7 +899,6 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	struct of_phandle_args arg;
 	struct net_device *ndev;
 	struct hip04_priv *priv;
-	struct resource *res;
 	int irq;
 	int ret;
 
@@ -912,16 +911,14 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->base = devm_ioremap_resource(d, res);
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
 		goto init_fail;
 	}
 
 #if defined(CONFIG_HI13X1_GMAC)
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	priv->sysctrl_base = devm_ioremap_resource(d, res);
+	priv->sysctrl_base = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(priv->sysctrl_base)) {
 		ret = PTR_ERR(priv->sysctrl_base);
 		goto init_fail;
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index d2e019d..689f18e 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -781,7 +781,6 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
-	struct resource *res;
 	struct net_device *ndev;
 	struct hisi_femac_priv *priv;
 	struct phy_device *phy;
@@ -799,15 +798,13 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 	priv->dev = dev;
 	priv->ndev = ndev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->port_base = devm_ioremap_resource(dev, res);
+	priv->port_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->port_base)) {
 		ret = PTR_ERR(priv->port_base);
 		goto out_free_netdev;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	priv->glb_base = devm_ioremap_resource(dev, res);
+	priv->glb_base = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(priv->glb_base)) {
 		ret = PTR_ERR(priv->glb_base);
 		goto out_free_netdev;
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 89ef764..3499705 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1097,7 +1097,6 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id = NULL;
 	struct net_device *ndev;
 	struct hix5hd2_priv *priv;
-	struct resource *res;
 	struct mii_bus *bus;
 	const char *mac_addr;
 	int ret;
@@ -1119,15 +1118,13 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	}
 	priv->hw_cap = (unsigned long)of_id->data;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->base = devm_ioremap_resource(dev, res);
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
 		goto out_free_netdev;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	priv->ctrl_base = devm_ioremap_resource(dev, res);
+	priv->ctrl_base = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(priv->ctrl_base)) {
 		ret = PTR_ERR(priv->ctrl_base);
 		goto out_free_netdev;
diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 918cab1..3e863a7 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -417,7 +417,6 @@ static int hns_mdio_probe(struct platform_device *pdev)
 {
 	struct hns_mdio_device *mdio_dev;
 	struct mii_bus *new_bus;
-	struct resource *res;
 	int ret = -ENODEV;
 
 	if (!pdev) {
@@ -442,8 +441,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 	new_bus->priv = mdio_dev;
 	new_bus->parent = &pdev->dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	mdio_dev->vbase = devm_ioremap_resource(&pdev->dev, res);
+	mdio_dev->vbase = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(mdio_dev->vbase)) {
 		ret = PTR_ERR(mdio_dev->vbase);
 		return ret;
-- 
1.8.5.6

