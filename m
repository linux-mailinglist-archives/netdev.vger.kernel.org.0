Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1AAAE634
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 11:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbfIJJBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 05:01:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729588AbfIJJBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 05:01:10 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ADFF15CEE0EE50052684;
        Tue, 10 Sep 2019 17:01:07 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Tue, 10 Sep 2019 17:01:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: fix port setting handle for fibre port
Date:   Tue, 10 Sep 2019 16:58:25 +0800
Message-ID: <1568105908-60983-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568105908-60983-1-git-send-email-tanhuazhong@huawei.com>
References: <1568105908-60983-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

For hardware doesn't support use specified speed and duplex
to negotiate, it's unnecessary to check and modify the port
speed and duplex for fibre port when autoneg is on.

Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index f5a681d..680c350 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -726,6 +726,12 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 	u8 duplex;
 	int ret;
 
+	/* hw doesn't support use specified speed and duplex to negotiate,
+	 * unnecessary to check them when autoneg on.
+	 */
+	if (cmd->base.autoneg)
+		return 0;
+
 	if (ops->get_ksettings_an_result) {
 		ops->get_ksettings_an_result(handle, &autoneg, &speed, &duplex);
 		if (cmd->base.autoneg == autoneg && cmd->base.speed == speed &&
@@ -787,6 +793,15 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 			return ret;
 	}
 
+	/* hw doesn't support use specified speed and duplex to negotiate,
+	 * ignore them when autoneg on.
+	 */
+	if (cmd->base.autoneg) {
+		netdev_info(netdev,
+			    "autoneg is on, ignore the speed and duplex\n");
+		return 0;
+	}
+
 	if (ops->cfg_mac_speed_dup_h)
 		ret = ops->cfg_mac_speed_dup_h(handle, cmd->base.speed,
 					       cmd->base.duplex);
-- 
2.7.4

