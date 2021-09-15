Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9357340C809
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbhIOPP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:15:58 -0400
Received: from mx22.baidu.com ([220.181.50.185]:41268 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238079AbhIOPPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:15:50 -0400
Received: from BJHW-Mail-Ex11.internal.baidu.com (unknown [10.127.64.34])
        by Forcepoint Email with ESMTPS id AE1B8FAE9CF7574D3303;
        Wed, 15 Sep 2021 22:58:25 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex11.internal.baidu.com (10.127.64.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:25 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:24 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: enetc: Make use of the helper function dev_err_probe()
Date:   Wed, 15 Sep 2021 22:58:19 +0800
Message-ID: <20210915145820.7463-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex10.internal.baidu.com (10.127.64.33) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When possible use dev_err_probe help to properly deal with the
PROBE_DEFER error, the benefit is that DEFER issue will be logged
in the devices_deferred debugfs file.
And using dev_err_probe() can reduce code size, and simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c     |  6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  | 12 ++++--------
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c |  6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_vf.c  |  6 ++----
 4 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3ca93adb9662..0c69409fe0d0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2610,10 +2610,8 @@ int enetc_pci_probe(struct pci_dev *pdev, const char *name, int sizeof_priv)
 
 	pcie_flr(pdev);
 	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "device enable failed\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "device enable failed\n");
 
 	/* set up for high or low dma */
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 60d94e0a07d6..f0ff95096846 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -804,10 +804,8 @@ static int enetc_mdio_probe(struct enetc_pf *pf, struct device_node *np)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
 	err = of_mdiobus_register(bus, np);
-	if (err) {
-		dev_err(dev, "cannot register MDIO bus\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(dev, err, "cannot register MDIO bus\n");
 
 	pf->mdio = bus;
 
@@ -1216,10 +1214,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 			 ERR_PTR(err));
 
 	err = enetc_pci_probe(pdev, KBUILD_MODNAME, sizeof(*pf));
-	if (err) {
-		dev_err(&pdev->dev, "PCI probing failed\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "PCI probing failed\n");
 
 	si = pci_get_drvdata(pdev);
 	if (!si->hw.port || !si->hw.global) {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
index bc594892507a..36b4f51dd297 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -39,10 +39,8 @@ static int enetc_ptp_probe(struct pci_dev *pdev,
 	}
 
 	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "device enable failed\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "device enable failed\n");
 
 	/* set up for high or low dma */
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 1a9d1e8b772c..0704f6bf12fd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -143,10 +143,8 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 	int err;
 
 	err = enetc_pci_probe(pdev, KBUILD_MODNAME, 0);
-	if (err) {
-		dev_err(&pdev->dev, "PCI probing failed\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "PCI probing failed\n");
 
 	si = pci_get_drvdata(pdev);
 
-- 
2.25.1

