Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E9140C80C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbhIOPQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:16:12 -0400
Received: from mx22.baidu.com ([220.181.50.185]:41262 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234098AbhIOPPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:15:51 -0400
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id B80761D8F0A4AF123AE5;
        Wed, 15 Sep 2021 22:58:48 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:48 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:47 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: thunderx: Make use of the helper function dev_err_probe()
Date:   Wed, 15 Sep 2021 22:58:42 +0800
Message-ID: <20210915145843.7622-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex10.internal.baidu.com (10.127.64.33) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex14_2021-09-15 22:58:48:702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When possible use dev_err_probe help to properly deal with the
PROBE_DEFER error, the benefit is that DEFER issue will be logged
in the devices_deferred debugfs file.
And using dev_err_probe() can reduce code size, and simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/cavium/thunder/nic_main.c    | 3 +--
 drivers/net/ethernet/cavium/thunder/nicvf_main.c  | 6 ++----
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nic_main.c b/drivers/net/ethernet/cavium/thunder/nic_main.c
index 691e1475d55e..b3d7d1afced7 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1311,9 +1311,8 @@ static int nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		dev_err(dev, "Failed to enable PCI device\n");
 		pci_set_drvdata(pdev, NULL);
-		return err;
+		return dev_err_probe(dev, err, "Failed to enable PCI device\n");
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index d1667b759522..2b87565781a0 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2119,10 +2119,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	err = pci_enable_device(pdev);
-	if (err) {
-		dev_err(dev, "Failed to enable PCI device\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(dev, err, "Failed to enable PCI device\n");
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index c36fed9c3d73..db66d4beb28a 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1597,9 +1597,8 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = pcim_enable_device(pdev);
 	if (err) {
-		dev_err(dev, "Failed to enable PCI device\n");
 		pci_set_drvdata(pdev, NULL);
-		return err;
+		return dev_err_probe(dev, err, "Failed to enable PCI device\n");
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
-- 
2.25.1

