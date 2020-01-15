Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDDE13B7F4
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 03:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAOCqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 21:46:55 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:47458 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728862AbgAOCqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 21:46:54 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BB136C706C7E975A87C8;
        Wed, 15 Jan 2020 10:46:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Wed, 15 Jan 2020 10:46:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net] net: hns3: pad the short frame before sending to the hardware
Date:   Wed, 15 Jan 2020 10:46:45 +0800
Message-ID: <1579056405-30385-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

The hardware can not handle short frames below or equal to 32
bytes according to the hardware user manual, and it will trigger
a RAS error when the frame's length is below 33 bytes.

This patch pads the SKB when skb->len is below 33 bytes before
sending it to hardware.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 69545dd..b3deb5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -54,6 +54,8 @@ MODULE_PARM_DESC(debug, " Network interface message level setting");
 #define HNS3_INNER_VLAN_TAG	1
 #define HNS3_OUTER_VLAN_TAG	2
 
+#define HNS3_MIN_TX_LEN		33U
+
 /* hns3_pci_tbl - PCI Device ID Table
  *
  * Last entry must be all 0s
@@ -1405,6 +1407,10 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	int bd_num = 0;
 	int ret;
 
+	/* Hardware can only handle short frames above 32 bytes */
+	if (skb_put_padto(skb, HNS3_MIN_TX_LEN))
+		return NETDEV_TX_OK;
+
 	/* Prefetch the data used later */
 	prefetch(skb->data);
 
-- 
2.7.4

