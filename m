Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECEB36E718
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbhD2Ifq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:35:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16171 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbhD2Ifm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:35:42 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FW7yV2B33zlW2d;
        Thu, 29 Apr 2021 16:31:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 29 Apr 2021 16:34:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/3] net: hns3: add check for HNS3_NIC_STATE_INITED in hns3_reset_notify_up_enet()
Date:   Thu, 29 Apr 2021 16:34:52 +0800
Message-ID: <1619685292-46644-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619685292-46644-1-git-send-email-tanhuazhong@huawei.com>
References: <1619685292-46644-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

In some cases, the device is not initialized because reset failed.
If another task calls hns3_reset_notify_up_enet() before reset
retry, it will cause an error since uninitialized pointer access.
So add check for HNS3_NIC_STATE_INITED before calling
hns3_nic_net_open() in hns3_reset_notify_up_enet().

Fixes: bb6b94a896d4 ("net: hns3: Add reset interface implementation in client")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index bf4302a..22ce73e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4554,6 +4554,11 @@ static int hns3_reset_notify_up_enet(struct hnae3_handle *handle)
 	struct hns3_nic_priv *priv = netdev_priv(kinfo->netdev);
 	int ret = 0;
 
+	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
+		netdev_err(kinfo->netdev, "device is not initialized yet\n");
+		return -EFAULT;
+	}
+
 	clear_bit(HNS3_NIC_STATE_RESETTING, &priv->state);
 
 	if (netif_running(kinfo->netdev)) {
-- 
2.7.4

