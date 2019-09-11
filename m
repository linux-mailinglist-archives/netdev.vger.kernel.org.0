Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114B9AF468
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfIKCnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:43:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbfIKCnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 22:43:06 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 70FF120AF84EA8F6B56B;
        Wed, 11 Sep 2019 10:43:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Sep 2019 10:42:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH V2 net-next 2/7] net: hns3: revert to old channel when setting new channel num fail
Date:   Wed, 11 Sep 2019 10:40:34 +0800
Message-ID: <1568169639-43658-3-git-send-email-tanhuazhong@huawei.com>
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

From: Peng Li <lipeng321@huawei.com>

After setting new channel num, it needs free old ring memory and
allocate new ring memory. If there is no enough memory and allocate
new ring memory fail, the ring may initialize fail. To make sure
the network interface can work normally, driver should revert the
channel to the old configuration.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 51 ++++++++++++++++++-------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9f3f8e3..8dbaf36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4410,6 +4410,30 @@ static int hns3_reset_notify(struct hnae3_handle *handle,
 	return ret;
 }
 
+static int hns3_change_channels(struct hnae3_handle *handle, u32 new_tqp_num,
+				bool rxfh_configured)
+{
+	int ret;
+
+	ret = handle->ae_algo->ops->set_channels(handle, new_tqp_num,
+						 rxfh_configured);
+	if (ret) {
+		dev_err(&handle->pdev->dev,
+			"Change tqp num(%u) fail.\n", new_tqp_num);
+		return ret;
+	}
+
+	ret = hns3_reset_notify(handle, HNAE3_INIT_CLIENT);
+	if (ret)
+		return ret;
+
+	ret =  hns3_reset_notify(handle, HNAE3_UP_CLIENT);
+	if (ret)
+		hns3_reset_notify(handle, HNAE3_UNINIT_CLIENT);
+
+	return ret;
+}
+
 int hns3_set_channels(struct net_device *netdev,
 		      struct ethtool_channels *ch)
 {
@@ -4450,24 +4474,23 @@ int hns3_set_channels(struct net_device *netdev,
 		return ret;
 
 	org_tqp_num = h->kinfo.num_tqps;
-	ret = h->ae_algo->ops->set_channels(h, new_tqp_num, rxfh_configured);
+	ret = hns3_change_channels(h, new_tqp_num, rxfh_configured);
 	if (ret) {
-		ret = h->ae_algo->ops->set_channels(h, org_tqp_num,
-						    rxfh_configured);
-		if (ret) {
-			/* If revert to old tqp failed, fatal error occurred */
-			dev_err(&netdev->dev,
-				"Revert to old tqp num fail, ret=%d", ret);
-			return ret;
+		int ret1;
+
+		netdev_warn(netdev,
+			    "Change channels fail, revert to old value\n");
+		ret1 = hns3_change_channels(h, org_tqp_num, rxfh_configured);
+		if (ret1) {
+			netdev_err(netdev,
+				   "revert to old channel fail\n");
+			return ret1;
 		}
-		dev_info(&netdev->dev,
-			 "Change tqp num fail, Revert to old tqp num");
-	}
-	ret = hns3_reset_notify(h, HNAE3_INIT_CLIENT);
-	if (ret)
+
 		return ret;
+	}
 
-	return hns3_reset_notify(h, HNAE3_UP_CLIENT);
+	return 0;
 }
 
 static const struct hns3_hw_error_info hns3_hw_err[] = {
-- 
2.7.4

