Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA33AFB4C
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 05:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFVDLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 23:11:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11077 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhFVDLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 23:11:54 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G8BBP5YG5zZgZY;
        Tue, 22 Jun 2021 11:06:37 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 11:09:37 +0800
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 11:09:37 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <kuba@kernel.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
Date:   Tue, 22 Jun 2021 11:09:29 +0800
Message-ID: <20210622030929.51295-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500021.china.huawei.com (7.185.36.109)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

The following steps will definitely cause the kernel to crash:
	ip link add vrf1 type vrf table 1
	modprobe bonding.ko max_bonds=1
	echo "+vrf1" >/sys/class/net/bond0/bonding/slaves
	rmmod bonding

The root cause is that: When the VRF is added to the slave device,
it will fail, and some cleaning work will be done. because VRF device
has IFF_MASTER flag, cleanup process  will not clear the IFF_BONDING flag.
Then, when we unload the bonding module, unregister_netdevice_notifier()
will treat the VRF device as a bond master device and treat netdev_priv()
as struct bonding{} which actually is struct net_vrf{}.

By analyzing the processing logic of bond_enslave(), it seems that
it is not allowed to add the slave device with the IFF_MASTER flag, so
we need to add a code check for this situation.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
 drivers/net/bonding/bond_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c5a646d06102..16840c9bc00d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1601,6 +1601,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	int link_reporting;
 	int res = 0, i;
 
+	if (slave_dev->flags & IFF_MASTER) {
+		netdev_err(bond_dev,
+			   "Error: Device with IFF_MASTER cannot be enslaved\n");
+		return -EPERM;
+	}
+
 	if (!bond->params.use_carrier &&
 	    slave_dev->ethtool_ops->get_link == NULL &&
 	    slave_ops->ndo_do_ioctl == NULL) {
-- 
2.23.0

