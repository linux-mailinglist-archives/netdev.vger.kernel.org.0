Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0479AAF46A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfIKCnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:43:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbfIKCnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 22:43:07 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7FA5763F6E9862767B5A;
        Wed, 11 Sep 2019 10:43:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Sep 2019 10:42:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH V2 net-next 4/7] net: hns3: fix port setting handle for fibre port
Date:   Wed, 11 Sep 2019 10:40:36 +0800
Message-ID: <1568169639-43658-5-git-send-email-tanhuazhong@huawei.com>
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

