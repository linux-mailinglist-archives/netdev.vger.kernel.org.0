Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0544E3DA3CF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhG2NTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:19:45 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16027 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbhG2NTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 09:19:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gb9yf0BNHzZvM9;
        Thu, 29 Jul 2021 21:16:10 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 21:19:39 +0800
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 21:19:38 +0800
From:   Di Zhu <zhudi21@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <maheshb@google.com>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH] ipvlan: Add handling of NETDEV_UP events
Date:   Thu, 29 Jul 2021 21:19:30 +0800
Message-ID: <20210729131930.1991-1-zhudi21@huawei.com>
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

When an ipvlan device is created on a bond device, the link state
of the ipvlan device may be abnormal. This is because bonding device
allows to add physical network card device in the down state and so
NETDEV_CHANGE event will not be notified to other listeners, so ipvlan
has no chance to update its link status.

The following steps can cause such problems:
	1) bond0 is down
	2) ip link add link bond0 name ipvlan type ipvlan mode l2
	3) echo +enp2s7 >/sys/class/net/bond0/bonding/slaves
	4) ip link set bond0 up

After these steps, use ip link command, we found ipvlan has NO-CARRIER:
  ipvlan@bond0: <NO-CARRIER, BROADCAST,MULTICAST,UP,M-DOWN> mtu ...>

We can deal with this problem like VLAN: Add handling of NETDEV_UP
events. If we receive NETDEV_UP event, we will update the link status
of the ipvlan.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index a707502a0c0f..c0b21a5580d5 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -732,6 +732,7 @@ static int ipvlan_device_event(struct notifier_block *unused,
 	port = ipvlan_port_get_rtnl(dev);
 
 	switch (event) {
+	case NETDEV_UP:
 	case NETDEV_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode)
 			netif_stacked_transfer_operstate(ipvlan->phy_dev,
-- 
2.27.0

