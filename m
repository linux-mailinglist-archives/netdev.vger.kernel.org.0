Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6CAF46B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfIKCnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:43:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51264 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726803AbfIKCnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 22:43:08 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9E181A2348C97B64AED4;
        Wed, 11 Sep 2019 10:43:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Sep 2019 10:42:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH V2 net-next 5/7] net: hns3: modify some logs format
Date:   Wed, 11 Sep 2019 10:40:37 +0800
Message-ID: <1568169639-43658-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

The pfc_en and pfc_map need to be displayed in hexadecimal notation,
printing dma address should use %pad, and the end of printed string
needs to be add "\n".

This patch modifies them.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c      | 7 +++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 5cf4c1e..28961a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -166,6 +166,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	struct hns3_enet_ring *ring;
 	u32 tx_index, rx_index;
 	u32 q_num, value;
+	dma_addr_t addr;
 	int cnt;
 
 	cnt = sscanf(&cmd_buf[8], "%u %u", &q_num, &tx_index);
@@ -194,8 +195,9 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	}
 
 	tx_desc = &ring->desc[tx_index];
+	addr = le64_to_cpu(tx_desc->addr);
 	dev_info(dev, "TX Queue Num: %u, BD Index: %u\n", q_num, tx_index);
-	dev_info(dev, "(TX)addr: 0x%llx\n", tx_desc->addr);
+	dev_info(dev, "(TX)addr: %pad\n", &addr);
 	dev_info(dev, "(TX)vlan_tag: %u\n", tx_desc->tx.vlan_tag);
 	dev_info(dev, "(TX)send_size: %u\n", tx_desc->tx.send_size);
 	dev_info(dev, "(TX)vlan_tso: %u\n", tx_desc->tx.type_cs_vlan_tso);
@@ -217,8 +219,9 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	rx_index = (cnt == 1) ? value : tx_index;
 	rx_desc	 = &ring->desc[rx_index];
 
+	addr = le64_to_cpu(rx_desc->addr);
 	dev_info(dev, "RX Queue Num: %u, BD Index: %u\n", q_num, rx_index);
-	dev_info(dev, "(RX)addr: 0x%llx\n", rx_desc->addr);
+	dev_info(dev, "(RX)addr: %pad\n", &addr);
 	dev_info(dev, "(RX)l234_info: %u\n", rx_desc->rx.l234_info);
 	dev_info(dev, "(RX)pkt_len: %u\n", rx_desc->rx.pkt_len);
 	dev_info(dev, "(RX)size: %u\n", rx_desc->rx.size);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 816f920..c063301 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -342,7 +342,7 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	hdev->tm_info.pfc_en = pfc->pfc_en;
 
 	netif_dbg(h, drv, netdev,
-		  "set pfc: pfc_en=%u, pfc_map=%u, num_tc=%u\n",
+		  "set pfc: pfc_en=%x, pfc_map=%x, num_tc=%u\n",
 		  pfc->pfc_en, pfc_map, hdev->tm_info.num_tc);
 
 	hclge_tm_pfc_info_update(hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8d4dc1b..bc5bad3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3751,7 +3751,7 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 	else if (time_after(jiffies, (hdev->last_reset_time + 4 * 5 * HZ)))
 		hdev->reset_level = HNAE3_FUNC_RESET;
 
-	dev_info(&hdev->pdev->dev, "received reset event , reset type is %d",
+	dev_info(&hdev->pdev->dev, "received reset event, reset type is %d\n",
 		 hdev->reset_level);
 
 	/* request reset & schedule reset task */
-- 
2.7.4

