Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499C440C7F6
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbhIOPOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:14:52 -0400
Received: from mx24.baidu.com ([111.206.215.185]:40664 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237821AbhIOPOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:14:49 -0400
Received: from BJHW-Mail-Ex07.internal.baidu.com (unknown [10.127.64.17])
        by Forcepoint Email with ESMTPS id D634F1F886F5E3385F18;
        Wed, 15 Sep 2021 22:57:54 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex07.internal.baidu.com (10.127.64.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:57:54 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:57:54 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: atl1c: Make use of the helper function dev_err_probe()
Date:   Wed, 15 Sep 2021 22:57:48 +0800
Message-ID: <20210915145749.7251-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex07_2021-09-15 22:57:54:824
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When possible use dev_err_probe help to properly deal with the
PROBE_DEFER error, the benefit is that DEFER issue will be logged
in the devices_deferred debugfs file.
And using dev_err_probe() can reduce code size, and simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3b51b172b317..20c032ab631b 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2662,10 +2662,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "cannot enable PCI device\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "cannot enable PCI device\n");
 
 	/*
 	 * The atl1c chip can DMA to 64-bit addresses, but it uses a single
-- 
2.25.1

