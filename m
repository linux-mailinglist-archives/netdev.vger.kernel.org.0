Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC614A8874
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbfIDOJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:09:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730521AbfIDOJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 10:09:18 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A3E23FF442AD27FF69AB;
        Wed,  4 Sep 2019 22:09:13 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 22:09:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Jian Shen <shenjian15@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: fix error VF index when setting VLAN offload
Date:   Wed, 4 Sep 2019 22:06:40 +0800
Message-ID: <1567606006-39598-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
References: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

In original codes, the VF index used incorrectly in function
hclge_set_vlan_rx_offload_cfg() and hclge_set_vlan_rx_offload_cfg().
When VF id is greater than 8, for example 9, it will set the
same bit with VF id 1.

This patch fixes it by using  vport->vport_id % HCLGE_VF_NUM_PER_CMD /
HCLGE_VF_NUM_PER_BYTE as the array index, intead of vport->vport_id /
HCLGE_VF_NUM_PER_CMD.

Fixes: 052ece6dc19c ("net: hns3: add ethtool related offload command")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2b65f27..0e1225c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7691,6 +7691,7 @@ static int hclge_set_vlan_tx_offload_cfg(struct hclge_vport *vport)
 	struct hclge_vport_vtag_tx_cfg_cmd *req;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_desc desc;
+	u16 bmap_index;
 	int status;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_TX_CFG, false);
@@ -7713,8 +7714,10 @@ static int hclge_set_vlan_tx_offload_cfg(struct hclge_vport *vport)
 	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_CFG_NIC_ROCE_SEL_B, 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
-	req->vf_bitmap[req->vf_offset] =
-		1 << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
+	bmap_index = vport->vport_id % HCLGE_VF_NUM_PER_CMD /
+			HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] =
+		1U << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
@@ -7731,6 +7734,7 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 	struct hclge_vport_vtag_rx_cfg_cmd *req;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_desc desc;
+	u16 bmap_index;
 	int status;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_RX_CFG, false);
@@ -7746,8 +7750,10 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 		      vcfg->vlan2_vlan_prionly ? 1 : 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
-	req->vf_bitmap[req->vf_offset] =
-		1 << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
+	bmap_index = vport->vport_id % HCLGE_VF_NUM_PER_CMD /
+			HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] =
+		1U << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
-- 
2.7.4

