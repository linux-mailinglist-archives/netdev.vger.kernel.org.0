Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73B23CF63F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhGTH6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 03:58:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15042 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhGTH54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 03:57:56 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GTX8Z3625zZqp7;
        Tue, 20 Jul 2021 16:35:10 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 16:38:32 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 16:38:32 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <zhangjiaran@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <moyufeng@huawei.com>,
        <linuxarm@huawei.com>, <linuxarm@openeuler.org>
Subject: [PATCH RFC] net: hns3: add a module parameter wq_unbound
Date:   Tue, 20 Jul 2021 16:34:57 +0800
Message-ID: <1626770097-56989-1-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To meet the requirements of different scenarios, the WQ_UNBOUND
flag of the workqueue is transferred as a module parameter. Users
can flexibly configure the usage mode as required.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 10 +++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dd3354a..9816592 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -76,6 +76,10 @@ static struct hnae3_ae_algo ae_algo;
 
 static struct workqueue_struct *hclge_wq;
 
+static unsigned int wq_unbound;
+module_param(wq_unbound, uint, 0400);
+MODULE_PARM_DESC(wq_unbound, "Specifies WQ_UNBOUND flag for the workqueue, non-zero value takes effect");
+
 static const struct pci_device_id ae_algo_pci_tbl[] = {
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_GE), 0},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_25GE), 0},
@@ -12936,7 +12940,11 @@ static int hclge_init(void)
 {
 	pr_info("%s is initializing\n", HCLGE_NAME);
 
-	hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
+	if (wq_unbound)
+		hclge_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGE_NAME);
+	else
+		hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
+
 	if (!hclge_wq) {
 		pr_err("%s: failed to create workqueue\n", HCLGE_NAME);
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 52eaf82..85f6772 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -21,6 +21,10 @@ static struct hnae3_ae_algo ae_algovf;
 
 static struct workqueue_struct *hclgevf_wq;
 
+static unsigned int wq_unbound;
+module_param(wq_unbound, uint, 0400);
+MODULE_PARM_DESC(wq_unbound, "Specifies WQ_UNBOUND flag for the workqueue, non-zero value takes effect");
+
 static const struct pci_device_id ae_algovf_pci_tbl[] = {
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_VF), 0},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_RDMA_DCB_PFC_VF),
@@ -3855,7 +3859,11 @@ static int hclgevf_init(void)
 {
 	pr_info("%s is initializing\n", HCLGEVF_NAME);
 
-	hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
+	if (wq_unbound)
+		hclgevf_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGEVF_NAME);
+	else
+		hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
+
 	if (!hclgevf_wq) {
 		pr_err("%s: failed to create workqueue\n", HCLGEVF_NAME);
 		return -ENOMEM;
-- 
2.8.1

