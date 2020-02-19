Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E5C16394D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgBSBYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:24:12 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10212 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727944AbgBSBYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 20:24:12 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A42EC7D194874AEEB6F1;
        Wed, 19 Feb 2020 09:24:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 19 Feb 2020 09:23:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: modify an unsuitable print when setting unknown duplex to fibre
Date:   Wed, 19 Feb 2020 09:23:30 +0800
Message-ID: <1582075413-34966-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582075413-34966-1-git-send-email-tanhuazhong@huawei.com>
References: <1582075413-34966-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Currently, if device is in link down status and user uses
'ethtool -s' command to set speed but not specify duplex
mode, the duplex mode passed from ethtool to driver is
unknown value(255), and the fibre port will identify this
value as half duplex mode and print "only copper port
supports half duplex!". This message is confusing.

So for fibre port, only the setting duplex is half, prints
error and returns.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c03856e..3f59a19 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -736,7 +736,7 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 	if (ops->get_media_type)
 		ops->get_media_type(handle, &media_type, &module_type);
 
-	if (cmd->base.duplex != DUPLEX_FULL &&
+	if (cmd->base.duplex == DUPLEX_HALF &&
 	    media_type != HNAE3_MEDIA_TYPE_COPPER) {
 		netdev_err(netdev,
 			   "only copper port supports half duplex!");
-- 
2.7.4

