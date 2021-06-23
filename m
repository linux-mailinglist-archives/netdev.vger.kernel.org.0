Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653C43B121C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFWDXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:23:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8434 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWDXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:23:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G8pPX4MFyzZkmD;
        Wed, 23 Jun 2021 11:18:24 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 11:21:25 +0800
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 11:21:24 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <eric.dumazet@gmail.com>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH] bonding: allow nesting of bonding device
Date:   Wed, 23 Jun 2021 11:21:08 +0800
Message-ID: <20210623032108.51472-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500021.china.huawei.com (7.185.36.109)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

The commit 3c9ef511b9fa ("bonding: avoid adding slave device with
IFF_MASTER flag") fix a crash when add slave device with IFF_MASTER,
but it rejects the scenario of nested bonding device.

As Eric Dumazet described: since there indeed is a usage scenario about
nesting bonding, we should not break it.

So we add a new judgment condition to allow nesting of bonding device.

Fixes: 3c9ef511b9fa ("bonding: avoid adding slave device with IFF_MASTER flag")
Suggested-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
 drivers/net/bonding/bond_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 16840c9bc00d..03b1a93d7fea 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1601,7 +1601,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	int link_reporting;
 	int res = 0, i;
 
-	if (slave_dev->flags & IFF_MASTER) {
+	if (slave_dev->flags & IFF_MASTER &&
+	    !netif_is_bond_master(slave_dev)) {
+		NL_SET_ERR_MSG(extack, "Device with IFF_MASTER cannot be enslaved");
 		netdev_err(bond_dev,
 			   "Error: Device with IFF_MASTER cannot be enslaved\n");
 		return -EPERM;
-- 
2.23.0

