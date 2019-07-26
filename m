Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F1976033
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 09:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfGZHxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 03:53:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726297AbfGZHxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 03:53:36 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C4E617836BBAD0DED5E8;
        Fri, 26 Jul 2019 15:53:34 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Fri, 26 Jul 2019 15:53:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 01/10] net: hns3: add reset checking before set channels
Date:   Fri, 26 Jul 2019 15:51:21 +0800
Message-ID: <1564127490-22173-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564127490-22173-1-git-send-email-tanhuazhong@huawei.com>
References: <1564127490-22173-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

hns3_set_channels() should check the resetting status firstly,
since the device will reinitialize when resetting. If the
reset has not completed, the hns3_set_channels() may access
invalid memory.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 69f7ef8..08af782 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4378,6 +4378,9 @@ int hns3_set_channels(struct net_device *netdev,
 	u16 org_tqp_num;
 	int ret;
 
+	if (hns3_nic_resetting(netdev))
+		return -EBUSY;
+
 	if (ch->rx_count || ch->tx_count)
 		return -EINVAL;
 
-- 
2.7.4

