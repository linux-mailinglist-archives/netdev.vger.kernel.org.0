Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898E5433858
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhJSOZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:25:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14829 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhJSOXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HYbPp4R14z90LK;
        Tue, 19 Oct 2021 22:15:58 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 8/8] net: hns3: disable sriov before unload hclge layer
Date:   Tue, 19 Oct 2021 22:16:35 +0800
Message-ID: <20211019141635.43695-9-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211019141635.43695-1-huangguangbin2@huawei.com>
References: <20211019141635.43695-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

HNS3 driver includes hns3.ko, hnae3.ko and hclge.ko.
hns3.ko includes network stack and pci_driver, hclge.ko includes
HW device action, algo_ops and timer task, hnae3.ko includes some
register function.

When SRIOV is enable and hclge.ko is removed, HW device is unloaded
but VF still exists, PF will not reply VF mbx messages, and cause
errors.

This patch fix it by disable SRIOV before remove hclge.ko.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c   | 21 +++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index eef1b2764d34..67b0bf310daa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -10,6 +10,27 @@ static LIST_HEAD(hnae3_ae_algo_list);
 static LIST_HEAD(hnae3_client_list);
 static LIST_HEAD(hnae3_ae_dev_list);
 
+void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo)
+{
+	const struct pci_device_id *pci_id;
+	struct hnae3_ae_dev *ae_dev;
+
+	if (!ae_algo)
+		return;
+
+	list_for_each_entry(ae_dev, &hnae3_ae_dev_list, node) {
+		if (!hnae3_get_bit(ae_dev->flag, HNAE3_DEV_INITED_B))
+			continue;
+
+		pci_id = pci_match_id(ae_algo->pdev_id_table, ae_dev->pdev);
+		if (!pci_id)
+			continue;
+		if (IS_ENABLED(CONFIG_PCI_IOV))
+			pci_disable_sriov(ae_dev->pdev);
+	}
+}
+EXPORT_SYMBOL(hnae3_unregister_ae_algo_prepare);
+
 /* we are keeping things simple and using single lock for all the
  * list. This is a non-critical code so other updations, if happen
  * in parallel, can wait.
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 8ba21d6dc220..d701451596c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -853,6 +853,7 @@ struct hnae3_handle {
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
+void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo);
 void hnae3_unregister_ae_algo(struct hnae3_ae_algo *ae_algo);
 void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f5b8d1fee0f1..dcd40cc73082 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -13065,6 +13065,7 @@ static int hclge_init(void)
 
 static void hclge_exit(void)
 {
+	hnae3_unregister_ae_algo_prepare(&ae_algo);
 	hnae3_unregister_ae_algo(&ae_algo);
 	destroy_workqueue(hclge_wq);
 }
-- 
2.33.0

