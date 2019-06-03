Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9834232663
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 04:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfFCCLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 22:11:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17651 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726917AbfFCCLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 22:11:02 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C9C3996AC0E7F6520BDA;
        Mon,  3 Jun 2019 10:11:00 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 3 Jun 2019 10:10:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 02/10] net: hns3: don't configure new VLAN ID into VF VLAN table when it's full
Date:   Mon, 3 Jun 2019 10:09:14 +0800
Message-ID: <1559527762-22931-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
References: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

VF VLAN table can only support no more than 256 VLANs. When user
adds too many VLANs, the VF VLAN table will be full, and firmware
will close the VF VLAN table for the function. When VF VLAN table
is full, and user keeps adding new VLANs, it's unnecessary to
configure the VF VLAN table, because it will always fail, and print
warning message. The worst case is adding 4K VLANs, and doing reset,
it will take much time to restore these VLANs, which may cause VF
reset fail by timeout.

Fixes: 6c251711b37f ("net: hns3: Disable vf vlan filter when vf vlan table is full")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 ++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f0f618d..1215455 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7025,6 +7025,12 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, int vfid,
 	u8 vf_byte_off;
 	int ret;
 
+	/* if vf vlan table is full, firmware will close vf vlan filter, it
+	 * is unable and unnecessary to add new vlan id to vf vlan filter
+	 */
+	if (test_bit(vfid, hdev->vf_vlan_full) && !is_kill)
+		return 0;
+
 	hclge_cmd_setup_basic_desc(&desc[0],
 				   HCLGE_OPC_VLAN_FILTER_VF_CFG, false);
 	hclge_cmd_setup_basic_desc(&desc[1],
@@ -7060,6 +7066,7 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, int vfid,
 			return 0;
 
 		if (req0->resp_code == HCLGE_VF_VLAN_NO_ENTRY) {
+			set_bit(vfid, hdev->vf_vlan_full);
 			dev_warn(&hdev->pdev->dev,
 				 "vf vlan table is full, vf vlan filter is disabled\n");
 			return 0;
@@ -8621,6 +8628,7 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_stats_clear(hdev);
 	memset(hdev->vlan_table, 0, sizeof(hdev->vlan_table));
+	memset(hdev->vf_vlan_full, 0, sizeof(hdev->vf_vlan_full));
 
 	ret = hclge_cmd_init(hdev);
 	if (ret) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 2b3bc95..414f7db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -820,6 +820,7 @@ struct hclge_dev {
 	struct hclge_vlan_type_cfg vlan_type_cfg;
 
 	unsigned long vlan_table[VLAN_N_VID][BITS_TO_LONGS(HCLGE_VPORT_NUM)];
+	unsigned long vf_vlan_full[BITS_TO_LONGS(HCLGE_VPORT_NUM)];
 
 	struct hclge_fd_cfg fd_cfg;
 	struct hlist_head fd_rule_list;
-- 
2.7.4

