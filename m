Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12E636D999
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhD1O31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:29:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16929 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbhD1O3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 10:29:24 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FVgsp287gzvTJd;
        Wed, 28 Apr 2021 22:26:06 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Wed, 28 Apr 2021
 22:28:28 +0800
From:   zhangzhengming <zhangzhengming@huawei.com>
To:     <roopa@nvidia.com>, <nikolay@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <zhangzhengming@huawei.com>, <wangxiaogang3@huawei.com>,
        <xuhanbing@huawei.com>
Subject: [PATCH v2] bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit
Date:   Wed, 28 Apr 2021 22:38:14 +0800
Message-ID: <1619620694-12419-1-git-send-email-zhangzhengming@huawei.com>
X-Mailer: git-send-email 2.7.4.huawei.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Zhengming <zhangzhengming@huawei.com>

There is a crash in the function br_get_link_af_size_filtered,
as the port_exists(dev) is true and the rx_handler_data of dev is NULL.
But the rx_handler_data of dev is correct saved in vmcore.

The oops looks something like:
 ...
 pc : br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
 ...
 Call trace:
  br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
  if_nlmsg_size+0x180/0x1b0
  rtnl_calcit.isra.12+0xf8/0x148
  rtnetlink_rcv_msg+0x334/0x370
  netlink_rcv_skb+0x64/0x130
  rtnetlink_rcv+0x28/0x38
  netlink_unicast+0x1f0/0x250
  netlink_sendmsg+0x310/0x378
  sock_sendmsg+0x4c/0x70
  __sys_sendto+0x120/0x150
  __arm64_sys_sendto+0x30/0x40
  el0_svc_common+0x78/0x130
  el0_svc_handler+0x38/0x78
  el0_svc+0x8/0xc

In br_add_if(), we found there is no guarantee that
assigning rx_handler_data to dev->rx_handler_data
will before setting the IFF_BRIDGE_PORT bit of priv_flags.
So there is a possible data competition:

CPU 0:                                                        CPU 1:
(RCU read lock)                                               (RTNL lock)
rtnl_calcit()                                                 br_add_slave()
  if_nlmsg_size()                                               br_add_if()
    br_get_link_af_size_filtered()                              -> netdev_rx_handler_register
                                                                    ...
                                                                    // The order is not guaranteed
      ...                                                           -> dev->priv_flags |= IFF_BRIDGE_PORT;
      // The IFF_BRIDGE_PORT bit of priv_flags has been set
      -> if (br_port_exists(dev)) {
        // The dev->rx_handler_data has NOT been assigned
        -> p = br_port_get_rcu(dev);
        ....
                                                                    -> rcu_assign_pointer(dev->rx_handler_data, rx_handler_data);
                                                                     ...

Fix it in br_get_link_af_size_filtered, using br_port_get_check_rcu() and checking the return value.

Signed-off-by: Zhang Zhengming <zhangzhengming@huawei.com>
Reviewed-by: Zhao Lei <zhaolei69@huawei.com>
Reviewed-by: Wang Xiaogang <wangxiaogang3@huawei.com>
Suggested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index f2b1343..ed5aba2 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -103,8 +103,9 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 
 	rcu_read_lock();
 	if (netif_is_bridge_port(dev)) {
-		p = br_port_get_rcu(dev);
-		vg = nbp_vlan_group_rcu(p);
+		p = br_port_get_check_rcu(dev);
+		if (p)
+			vg = nbp_vlan_group_rcu(p);
 	} else if (dev->priv_flags & IFF_EBRIDGE) {
 		br = netdev_priv(dev);
 		vg = br_vlan_group_rcu(br);
-- 
2.7.4

