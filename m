Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6D48C449
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 13:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353298AbiALM7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 07:59:23 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34903 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240947AbiALM7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 07:59:22 -0500
Received: from kwepemi100005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JYngN5w3MzccYq;
        Wed, 12 Jan 2022 20:58:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100005.china.huawei.com (7.221.188.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 20:59:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 20:59:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net] net: bonding: fix bond_xmit_broadcast return value error bug
Date:   Wed, 12 Jan 2022 20:54:18 +0800
Message-ID: <20220112125418.55118-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

In Linux bonding scenario, one packet is copied to several copies and sent
by all slave device of bond0 in mode 3(broadcast mode). The mode 3 xmit
function bond_xmit_broadcast() only ueses the last slave device's tx result
as the final result. In this case, if the last slave device is down, then
it always return NET_XMIT_DROP, even though the other slave devices xmit
success. It may cause the tx statistics error, and cause the application
(e.g. scp) consider the network is unreachable.

For example, use the following command to configure server A.

echo 3 > /sys/class/net/bond0/bonding/mode
ifconfig bond0 up
ifenslave bond0 eth0 eth1
ifconfig bond0 192.168.1.125
ifconfig eth0 up
ifconfig eth1 down
The slave device eth0 and eth1 are connected to server B(192.168.1.107).
Run the ping 192.168.1.107 -c 3 -i 0.2 command, the following information
is displayed.

PING 192.168.1.107 (192.168.1.107) 56(84) bytes of data.
64 bytes from 192.168.1.107: icmp_seq=1 ttl=64 time=0.077 ms
64 bytes from 192.168.1.107: icmp_seq=2 ttl=64 time=0.056 ms
64 bytes from 192.168.1.107: icmp_seq=3 ttl=64 time=0.051 ms

 192.168.1.107 ping statistics
0 packets transmitted, 3 received

Actually, the slave device eth0 of the bond successfully sends three
ICMP packets, but the result shows that 0 packets are transmitted.

Also if we use scp command to get remote files, the command end with the
following printings.

ssh_exchange_identification: read: Connection timed out

So this patch modifies the bond_xmit_broadcast to return NET_XMIT_SUCCESS
if one slave device in the bond sends packets successfully. If all slave
devices send packets fail, the discarded packets stats is increased. The
skb is released when there is no slave device in the bond or the last slave
device is down.

Fixes: ae46f184bc1f ("bonding: propagate transmit status")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/bonding/bond_main.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 07fc603c2fa7..fce80b57f15b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4884,25 +4884,39 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave = NULL;
 	struct list_head *iter;
+	bool xmit_suc = false;
+	bool skb_used = false;
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (bond_is_last_slave(bond, slave))
-			break;
-		if (bond_slave_is_up(slave) && slave->link == BOND_LINK_UP) {
-			struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
+		struct sk_buff *skb2;
+
+		if (!(bond_slave_is_up(slave) && slave->link == BOND_LINK_UP))
+			continue;
 
+		if (bond_is_last_slave(bond, slave)) {
+			skb2 = skb;
+			skb_used = true;
+		} else {
+			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (!skb2) {
 				net_err_ratelimited("%s: Error: %s: skb_clone() failed\n",
 						    bond_dev->name, __func__);
 				continue;
 			}
-			bond_dev_queue_xmit(bond, skb2, slave->dev);
 		}
+
+		if (bond_dev_queue_xmit(bond, skb2, slave->dev) == NETDEV_TX_OK)
+			xmit_suc = true;
 	}
-	if (slave && bond_slave_is_up(slave) && slave->link == BOND_LINK_UP)
-		return bond_dev_queue_xmit(bond, skb, slave->dev);
 
-	return bond_tx_drop(bond_dev, skb);
+	if (!skb_used)
+		dev_kfree_skb_any(skb);
+
+	if (xmit_suc)
+		return NETDEV_TX_OK;
+
+	atomic_long_inc(&bond_dev->tx_dropped);
+	return NET_XMIT_DROP;
 }
 
 /*------------------------- Device initialization ---------------------------*/
-- 
2.33.0

