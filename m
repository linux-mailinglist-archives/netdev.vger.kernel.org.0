Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F51E3CD062
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhGSIgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:36:04 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11446 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbhGSIgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:36:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GSx316W5gzcfPs;
        Mon, 19 Jul 2021 17:13:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <fengchengwen@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net 4/4] net: hns3: fix rx VLAN offload state inconsistent issue
Date:   Mon, 19 Jul 2021 17:13:08 +0800
Message-ID: <1626685988-25869-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
References: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, VF doesn't enable rx VLAN offload when initializating,
and PF does it for VFs. If user disable the rx VLAN offload for
VF with ethtool -K, and reload the VF driver, it may cause the
rx VLAN offload state being inconsistent between hardware and
software.

Fixes it by enabling rx VLAN offload when VF initializing.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 52eaf82b7cd7..8784d61e833f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2641,6 +2641,16 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 
 static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev)
 {
+	struct hnae3_handle *nic = &hdev->nic;
+	int ret;
+
+	ret = hclgevf_en_hw_strip_rxvtag(nic, true);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to enable rx vlan offload, ret = %d\n", ret);
+		return ret;
+	}
+
 	return hclgevf_set_vlan_filter(&hdev->nic, htons(ETH_P_8021Q), 0,
 				       false);
 }
-- 
2.8.1

