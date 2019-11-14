Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF97EFBDEC
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 03:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKNCcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 21:32:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6658 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbfKNCcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 21:32:21 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B92128307E3A81E7607D;
        Thu, 14 Nov 2019 10:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 14 Nov 2019 10:32:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 1/3] net: hns3: add compatible handling for MAC VLAN switch parameter configuration
Date:   Thu, 14 Nov 2019 10:32:39 +0800
Message-ID: <1573698761-25682-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573698761-25682-1-git-send-email-tanhuazhong@huawei.com>
References: <1573698761-25682-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Previously, hns3 driver just directly send specific setting bit
and mask bits of MAC VLAN switch parameter to the firmware, it
can not be compatible with the old firmware, because the old one
ignores mask bits and covers all bits with new setting bits.
So when running with old firmware, the communication between PF
and VF will fail after resetting or configuring spoof check, since
they will do the MAC VLAN switch parameter configuration.

This patch fixes this problem by reading switch parameter firstly,
then just modifies the corresponding bit and sends it to firmware.

Fixes: dd2956eab104 ("net: hns3: not allow SSU loopback while execute ethtool -t dev")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 16f7d0e..c052bb3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6263,11 +6263,23 @@ static int hclge_config_switch_param(struct hclge_dev *hdev, int vfid,
 
 	func_id = hclge_get_port_number(HOST_PORT, 0, vfid, 0);
 	req = (struct hclge_mac_vlan_switch_cmd *)desc.data;
+
+	/* read current config parameter */
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MAC_VLAN_SWITCH_PARAM,
-				   false);
+				   true);
 	req->roce_sel = HCLGE_MAC_VLAN_NIC_SEL;
 	req->func_id = cpu_to_le32(func_id);
-	req->switch_param = switch_param;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"read mac vlan switch parameter fail, ret = %d\n", ret);
+		return ret;
+	}
+
+	/* modify and write new config parameter */
+	hclge_cmd_reuse_desc(&desc, false);
+	req->switch_param = (req->switch_param & param_mask) | switch_param;
 	req->param_mask = param_mask;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-- 
2.7.4

