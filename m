Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FD339F75C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhFHNNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:13:38 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3473 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFHNNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:13:34 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzrCS0V6zz6w3c;
        Tue,  8 Jun 2021 21:08:36 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
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
Subject: [PATCH net-next 3/5] net: hns3: add support for imp-handle ras capability
Date:   Tue, 8 Jun 2021 21:08:29 +0800
Message-ID: <1623157711-26846-4-git-send-email-huangguangbin2@huawei.com>
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

IMP(Intelligent Management Processor) firmware add a new feature to
handle and consolidate RAS information for new devices, NIC driver
only needs to query the reported RAS information. NIC driver adds
support for this feature.

Driver queries device capability to check whether IMP support this
feature, If yes, execute the new RAS processing branch.

In order to add a method to check whether PF supports imp-handle RAS
feature, add dumping this info in debugfs.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c      | 3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c  | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 5 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index dc9b5bc3431b..e564aa32a414 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -91,6 +91,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_STASH_B,
 	HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B,
 	HNAE3_DEV_SUPPORT_PAUSE_B,
+	HNAE3_DEV_SUPPORT_RAS_IMP_B,
 	HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B,
 	HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
 	HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B,
@@ -129,6 +130,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_dev_phy_imp_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (hdev)->ae_dev->caps)
 
+#define hnae3_dev_ras_imp_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_RAS_IMP_B, (hdev)->ae_dev->caps)
+
 #define hnae3_dev_tqp_txrx_indep_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, (hdev)->ae_dev->caps)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index cf1efd2f4a0f..a0edca848392 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -350,6 +350,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 		.name = "support imp-controlled PHY",
 		.cap_bit = HNAE3_DEV_SUPPORT_PHY_IMP_B,
 	}, {
+		.name = "support imp-controlled RAS",
+		.cap_bit = HNAE3_DEV_SUPPORT_RAS_IMP_B,
+	}, {
 		.name = "support rxd advanced layout",
 		.cap_bit = HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B,
 	}, {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 614763f5e877..887297e37cf3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -387,6 +387,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_PHY_IMP_B))
 		set_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_RAS_IMP_B))
+		set_bit(HNAE3_DEV_SUPPORT_RAS_IMP_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_RXD_ADV_LAYOUT_B))
 		set_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_PORT_VLAN_BYPASS_B)) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 234f0a3beec1..221811af9473 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -392,6 +392,7 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_HW_PAD_B,
 	HCLGE_CAP_STASH_B,
 	HCLGE_CAP_UDP_TUNNEL_CSUM_B,
+	HCLGE_CAP_RAS_IMP_B = 12,
 	HCLGE_CAP_FEC_B = 13,
 	HCLGE_CAP_PAUSE_B = 14,
 	HCLGE_CAP_RXD_ADV_LAYOUT_B = 15,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3c08fc71b951..cf34216df171 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4299,7 +4299,7 @@ static void hclge_errhand_service_task(struct hclge_dev *hdev)
 	if (!test_and_clear_bit(HCLGE_STATE_ERR_SERVICE_SCHED, &hdev->state))
 		return;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+	if (hnae3_dev_ras_imp_supported(hdev))
 		hclge_handle_err_recovery(hdev);
 	else
 		hclge_misc_err_recovery(hdev);
-- 
2.8.1

