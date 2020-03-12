Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECAF182994
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388090AbgCLHMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:12:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11631 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388082AbgCLHMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 03:12:16 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 052506EFF710082B7DB4;
        Thu, 12 Mar 2020 15:12:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Mar 2020 15:12:07 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 4/4] net: hns3: clear port base VLAN when unload PF
Date:   Thu, 12 Mar 2020 15:11:06 +0800
Message-ID: <1583997066-24773-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
References: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, PF missed to clear the port base VLAN for VF when
unload. In this case, the VLAN id will remain in the VLAN
table. This patch fixes it.

Fixes: 92f11ea177cd ("net: hns3: fix set port based VLAN issue for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 06d0ed0..d3b0cd7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8500,6 +8500,28 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	}
 }
 
+static void hclge_clear_vf_vlan(struct hclge_dev *hdev)
+{
+	struct hclge_vlan_info *vlan_info;
+	struct hclge_vport *vport;
+	int ret;
+	int vf;
+
+	/* clear port base vlan for all vf */
+	for (vf = HCLGE_VF_VPORT_START_NUM; vf < hdev->num_alloc_vport; vf++) {
+		vport = &hdev->vport[vf];
+		vlan_info = &vport->port_base_vlan_cfg.vlan_info;
+
+		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+					       vport->vport_id,
+					       vlan_info->vlan_tag, true);
+		if (ret)
+			dev_err(&hdev->pdev->dev,
+				"failed to clear vf vlan for vf%d, ret = %d\n",
+				vf - HCLGE_VF_VPORT_START_NUM, ret);
+	}
+}
+
 int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 			  u16 vlan_id, bool is_kill)
 {
@@ -9909,6 +9931,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	struct hclge_mac *mac = &hdev->hw.mac;
 
 	hclge_reset_vf_rate(hdev);
+	hclge_clear_vf_vlan(hdev);
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 
-- 
2.7.4

