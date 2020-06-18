Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CD31FDAB1
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFRBE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:04:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55838 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgFRBE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:04:26 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 074CA7545236983D704C;
        Thu, 18 Jun 2020 09:04:24 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.203.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 09:04:16 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linyunsheng@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 1/5] net: hns3: remove unnecessary devm_kfree
Date:   Thu, 18 Jun 2020 13:02:07 +1200
Message-ID: <20200618010211.75840-2-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
References: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.203.42]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

since we are using device-managed function, it is unnecessary
to free in probe.

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b14f2abc2425..1817d7f2e5f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2097,10 +2097,8 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, ae_dev);
 
 	ret = hnae3_register_ae_dev(ae_dev);
-	if (ret) {
-		devm_kfree(&pdev->dev, ae_dev);
+	if (ret)
 		pci_set_drvdata(pdev, NULL);
-	}
 
 	return ret;
 }
@@ -2157,7 +2155,6 @@ static void hns3_shutdown(struct pci_dev *pdev)
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 
 	hnae3_unregister_ae_dev(ae_dev);
-	devm_kfree(&pdev->dev, ae_dev);
 	pci_set_drvdata(pdev, NULL);
 
 	if (system_state == SYSTEM_POWER_OFF)
-- 
2.23.0


