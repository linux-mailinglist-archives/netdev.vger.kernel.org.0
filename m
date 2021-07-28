Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9A33D8908
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhG1Hnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:43:43 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12323 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhG1Hnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:43:42 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GZQWz266wz8036;
        Wed, 28 Jul 2021 15:38:55 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 28
 Jul 2021 15:43:38 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <christophe.jaillet@wanadoo.fr>, <gustavoars@kernel.org>,
        <tanghui20@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
Date:   Wed, 28 Jul 2021 15:43:13 +0800
Message-ID: <20210728074313.272055-1-wanghai38@huawei.com>
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
 drivers/net/ethernet/dec/tulip/winbond-840.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index f6ff1f76eacb..1876f15dd827 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -357,7 +357,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i, option = find_cnt < MAX_UNITS ? options[find_cnt] : 0;
 	void __iomem *ioaddr;
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 
 	pci_set_master(pdev);
@@ -379,7 +379,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ioaddr = pci_iomap(pdev, TULIP_BAR, netdev_res_size);
 	if (!ioaddr)
-		goto err_out_free_res;
+		goto err_out_netdev;
 
 	for (i = 0; i < 3; i++)
 		((__le16 *)dev->dev_addr)[i] = cpu_to_le16(eeprom_read(ioaddr, i));
@@ -458,8 +458,6 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_cleardev:
 	pci_iounmap(pdev, ioaddr);
-err_out_free_res:
-	pci_release_regions(pdev);
 err_out_netdev:
 	free_netdev (dev);
 	return -ENODEV;
@@ -1526,7 +1524,6 @@ static void w840_remove1(struct pci_dev *pdev)
 	if (dev) {
 		struct netdev_private *np = netdev_priv(dev);
 		unregister_netdev(dev);
-		pci_release_regions(pdev);
 		pci_iounmap(pdev, np->base_addr);
 		free_netdev(dev);
 	}
-- 
2.17.1

