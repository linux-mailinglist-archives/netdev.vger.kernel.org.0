Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D7622FF7B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgG1CTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:19:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8281 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgG1CTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 22:19:09 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7DAC8F6A8F4BC1AD62CD;
        Tue, 28 Jul 2020 10:19:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 10:18:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/5] net: hns3: fix a TX timeout issue
Date:   Tue, 28 Jul 2020 10:16:49 +0800
Message-ID: <1595902612-12880-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
References: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

When the queue depth and queue parameters are modified, there is
a low probability that TX timeout occurs. The two operations cause
the link to be down or up when the watchdog is still working. All
queues are stopped when the link is down. After the carrier is on,
all queues are woken up. If the watchdog detects the link between
the carrier on and wakeup queues, a false TX timeout occurs.

So fix this issue by modifying the sequence of carrier on and queue
wakeup, which is symmetrical to the link down action.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3328500..71ed4c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4136,8 +4136,8 @@ static void hns3_link_status_change(struct hnae3_handle *handle, bool linkup)
 		return;
 
 	if (linkup) {
-		netif_carrier_on(netdev);
 		netif_tx_wake_all_queues(netdev);
+		netif_carrier_on(netdev);
 		if (netif_msg_link(handle))
 			netdev_info(netdev, "link up\n");
 	} else {
-- 
2.7.4

