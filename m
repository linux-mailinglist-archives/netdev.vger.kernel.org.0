Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAD71AEA55
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgDRGsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:48:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54286 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726048AbgDRGs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 02:48:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2BD041BD36E313F0A85C;
        Sat, 18 Apr 2020 14:48:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 18 Apr 2020 14:48:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/10] net: hns3: add debug information for flow table when failed
Date:   Sat, 18 Apr 2020 14:47:07 +0800
Message-ID: <1587192429-11463-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
References: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Add some debug information for processing flow table if failed.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 40 ++++++++++++++++------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 74efd95..20216e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5381,22 +5381,31 @@ static int hclge_fd_check_ext_tuple(struct hclge_dev *hdev,
 				    u32 *unused_tuple)
 {
 	if (fs->flow_type & FLOW_EXT) {
-		if (fs->h_ext.vlan_etype)
+		if (fs->h_ext.vlan_etype) {
+			dev_err(&hdev->pdev->dev, "vlan-etype is not supported!\n");
 			return -EOPNOTSUPP;
+		}
+
 		if (!fs->h_ext.vlan_tci)
 			*unused_tuple |= BIT(INNER_VLAN_TAG_FST);
 
 		if (fs->m_ext.vlan_tci &&
-		    be16_to_cpu(fs->h_ext.vlan_tci) >= VLAN_N_VID)
+		    be16_to_cpu(fs->h_ext.vlan_tci) >= VLAN_N_VID) {
+			dev_err(&hdev->pdev->dev, "failed to config vlan_tci, invalid vlan_tci: %u, max is %u.\n",
+				ntohs(fs->h_ext.vlan_tci), VLAN_N_VID - 1);
 			return -EINVAL;
+		}
 	} else {
 		*unused_tuple |= BIT(INNER_VLAN_TAG_FST);
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {
 		if (hdev->fd_cfg.fd_mode !=
-		    HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1)
+		    HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1) {
+			dev_err(&hdev->pdev->dev,
+				"FLOW_MAC_EXT is not supported in current fd mode!\n");
 			return -EOPNOTSUPP;
+		}
 
 		if (is_zero_ether_addr(fs->h_ext.h_dest))
 			*unused_tuple |= BIT(INNER_DST_MAC);
@@ -5414,8 +5423,12 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 	u32 flow_type;
 	int ret = 0;
 
-	if (fs->location >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
+	if (fs->location >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]) {
+		dev_err(&hdev->pdev->dev, "failed to config fd rules, invalid rule location: %u, max is %u\n.",
+			fs->location,
+			hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1] - 1);
 		return -EINVAL;
+	}
 
 	if ((fs->flow_type & FLOW_EXT) &&
 	    (fs->h_ext.data[0] != 0 || fs->h_ext.data[1] != 0)) {
@@ -5457,11 +5470,16 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 						 unused_tuple);
 		break;
 	default:
+		dev_err(&hdev->pdev->dev, "unsupported protocol type, protocol type = %#x\n",
+			flow_type);
 		return -EOPNOTSUPP;
 	}
 
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "failed to check flow union tuple, ret = %d\n",
+			ret);
 		return ret;
+	}
 
 	return hclge_fd_check_ext_tuple(hdev, fs, unused_tuple);
 }
@@ -5729,22 +5747,22 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	u8 action;
 	int ret;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_dev_fd_supported(hdev)) {
+		dev_err(&hdev->pdev->dev, "flow table director is not supported\n");
 		return -EOPNOTSUPP;
+	}
 
 	if (!hdev->fd_en) {
-		dev_warn(&hdev->pdev->dev,
-			 "Please enable flow director first\n");
+		dev_err(&hdev->pdev->dev,
+			"please enable flow director first\n");
 		return -EOPNOTSUPP;
 	}
 
 	fs = (struct ethtool_rx_flow_spec *)&cmd->fs;
 
 	ret = hclge_fd_check_spec(hdev, fs, &unused);
-	if (ret) {
-		dev_err(&hdev->pdev->dev, "Check fd spec failed\n");
+	if (ret)
 		return ret;
-	}
 
 	if (fs->ring_cookie == RX_CLS_FLOW_DISC) {
 		action = HCLGE_FD_ACTION_DROP_PACKET;
-- 
2.7.4

