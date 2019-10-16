Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C63D894A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403830AbfJPHUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:20:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730832AbfJPHUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:20:13 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B7F02AFAE9B54753A334;
        Wed, 16 Oct 2019 15:20:08 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 16 Oct 2019 15:19:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: optimized MAC address in management table.
Date:   Wed, 16 Oct 2019 15:17:05 +0800
Message-ID: <1571210231-29154-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

mac_addr_hi32 and mac_addr_lo16 are used to store the MAC address
for management table. But using array of mac_addr[ETH_ALEN] would
be more general and not need to care about the big-endian mode of
the CPU.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 3578832..919911f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -5,6 +5,7 @@
 #define __HCLGE_CMD_H
 #include <linux/types.h>
 #include <linux/io.h>
+#include <linux/etherdevice.h>
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
 
@@ -712,8 +713,7 @@ struct hclge_mac_mgr_tbl_entry_cmd {
 	u8      flags;
 	u8      resp_code;
 	__le16  vlan_tag;
-	__le32  mac_addr_hi32;
-	__le16  mac_addr_lo16;
+	u8      mac_addr[ETH_ALEN];
 	__le16  rsv1;
 	__le16  ethter_type;
 	__le16  egress_port;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 962c4b4..72c19b3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -325,8 +325,7 @@ static const struct hclge_mac_mgr_tbl_entry_cmd hclge_mgr_table[] = {
 	{
 		.flags = HCLGE_MAC_MGR_MASK_VLAN_B,
 		.ethter_type = cpu_to_le16(ETH_P_LLDP),
-		.mac_addr_hi32 = cpu_to_le32(htonl(0x0180C200)),
-		.mac_addr_lo16 = cpu_to_le16(htons(0x000E)),
+		.mac_addr = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e},
 		.i_port_bitmap = 0x1,
 	},
 };
-- 
2.7.4

