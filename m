Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCC240C7F8
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhIOPOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:14:54 -0400
Received: from mx22.baidu.com ([220.181.50.185]:40632 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237825AbhIOPOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:14:49 -0400
Received: from BJHW-Mail-Ex02.internal.baidu.com (unknown [10.127.64.12])
        by Forcepoint Email with ESMTPS id 406FDD45A41AAC31470D;
        Wed, 15 Sep 2021 22:58:10 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex02.internal.baidu.com (10.127.64.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:10 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:09 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: cadence: macb: Make use of the helper function dev_err_probe()
Date:   Wed, 15 Sep 2021 22:58:04 +0800
Message-ID: <20210915145804.7357-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) To
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
 drivers/net/ethernet/cadence/macb_pci.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 8b7b59908a1a..d09c570a15ae 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -35,10 +35,8 @@ static int macb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* enable pci device */
 	err = pcim_enable_device(pdev);
-	if (err < 0) {
-		dev_err(&pdev->dev, "Enabling PCI device has failed: %d", err);
-		return err;
-	}
+	if (err < 0)
+		return dev_err_probe(&pdev->dev, err, "Enabling PCI device has failed\n");
 
 	pci_set_master(pdev);
 
-- 
2.25.1

