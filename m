Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009AF2CEA0D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgLDIoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:44:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8688 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgLDIoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:44:37 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CnR7C3bbvzkl35;
        Fri,  4 Dec 2020 16:43:19 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 4 Dec 2020 16:43:45 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael Wu <flamingice@sourmilk.net>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH wireless] adm8211: fix error return code in adm8211_probe()
Date:   Fri, 4 Dec 2020 16:47:17 +0800
Message-ID: <1607071638-33619-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: cc0b88cf5ecf ("[PATCH] Add adm8211 802.11b wireless driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/wireless/admtek/adm8211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index 5cf2045..c41e725 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -1796,6 +1796,7 @@ static int adm8211_probe(struct pci_dev *pdev,
 	if (io_len < 256 || mem_len < 1024) {
 		printk(KERN_ERR "%s (adm8211): Too short PCI resources\n",
 		       pci_name(pdev));
+		err = -ENOMEM;
 		goto err_disable_pdev;
 	}
 
@@ -1805,6 +1806,7 @@ static int adm8211_probe(struct pci_dev *pdev,
 	if (reg != ADM8211_SIG1 && reg != ADM8211_SIG2) {
 		printk(KERN_ERR "%s (adm8211): Invalid signature (0x%x)\n",
 		       pci_name(pdev), reg);
+		err = -EINVAL;
 		goto err_disable_pdev;
 	}
 
@@ -1815,8 +1817,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 		return err; /* someone else grabbed it? don't disable it */
 	}
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) ||
-	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (err) {
 		printk(KERN_ERR "%s (adm8211): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
-- 
2.9.5

