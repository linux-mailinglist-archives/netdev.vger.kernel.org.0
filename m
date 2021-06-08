Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0BB39F762
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhFHNNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:13:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8094 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhFHNNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:13:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzrCl2LGczYs1X;
        Tue,  8 Jun 2021 21:08:51 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/5] net: hns3: add error handling compatibility during initialization
Date:   Tue, 8 Jun 2021 21:08:31 +0800
Message-ID: <1623157711-26846-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
References: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

During initialization, the driver logs and clears the hw errors that
already occurred. For device supports imp-handle ras capability, it
needs handle different error status, otherwise it may cause wrong reset.

So fix it by adding a new processing branch.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 22 ++++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  2 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 21 ++++++++++-----------
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 0e942d11dbf3..bad9fda19398 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -2152,6 +2152,28 @@ void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
 	kfree(desc);
 }
 
+bool hclge_find_error_source(struct hclge_dev *hdev)
+{
+	u32 msix_src_flag, hw_err_src_flag;
+
+	msix_src_flag = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS) &
+			HCLGE_VECTOR0_REG_MSIX_MASK;
+
+	hw_err_src_flag = hclge_read_dev(&hdev->hw,
+					 HCLGE_RAS_PF_OTHER_INT_STS_REG) &
+			  HCLGE_RAS_REG_ERR_MASK;
+
+	return msix_src_flag || hw_err_src_flag;
+}
+
+void hclge_handle_occurred_error(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+
+	if (hclge_find_error_source(hdev))
+		hclge_handle_error_info_log(ae_dev);
+}
+
 static void
 hclge_handle_error_type_reg_log(struct device *dev,
 				struct hclge_mod_err_info *mod_info,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index ce4c96bbef8e..07987fb8332e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -215,6 +215,8 @@ int hclge_config_mac_tnl_int(struct hclge_dev *hdev, bool en);
 int hclge_config_nic_hw_error(struct hclge_dev *hdev, bool state);
 int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en);
 void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev);
+bool hclge_find_error_source(struct hclge_dev *hdev);
+void hclge_handle_occurred_error(struct hclge_dev *hdev);
 pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev);
 int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 			       unsigned long *reset_requests);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9ff4210f6477..d960e08850ae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4255,18 +4255,11 @@ static void hclge_handle_err_reset_request(struct hclge_dev *hdev)
 
 static void hclge_handle_err_recovery(struct hclge_dev *hdev)
 {
-	u32 mask_val = HCLGE_RAS_REG_NFE_MASK | HCLGE_RAS_REG_ROCEE_ERR_MASK;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	u32 msix_src_flag, hw_err_src_flag;
 
-	msix_src_flag = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS) &
-			HCLGE_VECTOR0_REG_MSIX_MASK;
+	ae_dev->hw_err_reset_req = 0;
 
-	hw_err_src_flag = hclge_read_dev(&hdev->hw,
-					 HCLGE_RAS_PF_OTHER_INT_STS_REG) &
-			  mask_val;
-
-	if (msix_src_flag || hw_err_src_flag) {
+	if (hclge_find_error_source(hdev)) {
 		hclge_handle_error_info_log(ae_dev);
 		hclge_handle_mac_tnl(hdev);
 	}
@@ -11558,7 +11551,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_clear_resetting_state(hdev);
 
 	/* Log and clear the hw errors those already occurred */
-	hclge_handle_all_hns_hw_errors(ae_dev);
+	if (hnae3_dev_ras_imp_supported(hdev))
+		hclge_handle_occurred_error(hdev);
+	else
+		hclge_handle_all_hns_hw_errors(ae_dev);
 
 	/* request delayed reset for the error recovery because an immediate
 	 * global reset on a PF affecting pending initialization of other PFs
@@ -11911,7 +11907,10 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 	}
 
 	/* Log and clear the hw errors those already occurred */
-	hclge_handle_all_hns_hw_errors(ae_dev);
+	if (hnae3_dev_ras_imp_supported(hdev))
+		hclge_handle_occurred_error(hdev);
+	else
+		hclge_handle_all_hns_hw_errors(ae_dev);
 
 	/* Re-enable the hw error interrupts because
 	 * the interrupts get disabled on global reset.
-- 
2.8.1

