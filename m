Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB99E3DC411
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 08:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhGaGii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 02:38:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12335 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbhGaGih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 02:38:37 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GcDxK5b8Tz81GN;
        Sat, 31 Jul 2021 14:33:41 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 31
 Jul 2021 14:38:28 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: natsemi: Fix missing pci_disable_device() in probe and remove
Date:   Sat, 31 Jul 2021 14:38:01 +0800
Message-ID: <20210731063801.818658-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace pci_enable_device() with pcim_enable_device(),
pci_disable_device() and pci_release_regions() will be
called in release automatically.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/natsemi/natsemi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 51b4b25d15ad..84f7dbe9edff 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -819,7 +819,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 		printk(version);
 #endif
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 
 	/* natsemi has a non-standard PM control register
@@ -852,7 +852,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioaddr = ioremap(iostart, iosize);
 	if (!ioaddr) {
 		i = -ENOMEM;
-		goto err_ioremap;
+		goto err_pci_request_regions;
 	}
 
 	/* Work around the dropped serial bit. */
@@ -974,9 +974,6 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_register_netdev:
 	iounmap(ioaddr);
 
- err_ioremap:
-	pci_release_regions(pdev);
-
  err_pci_request_regions:
 	free_netdev(dev);
 	return i;
@@ -3241,7 +3238,6 @@ static void natsemi_remove1(struct pci_dev *pdev)
 
 	NATSEMI_REMOVE_FILE(pdev, dspcfg_workaround);
 	unregister_netdev (dev);
-	pci_release_regions (pdev);
 	iounmap(ioaddr);
 	free_netdev (dev);
 }
-- 
2.17.1

