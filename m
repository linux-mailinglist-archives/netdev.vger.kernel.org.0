Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8BB37ED01
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383040AbhELUFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352677AbhELSD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 14:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FE4D6143A;
        Wed, 12 May 2021 18:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842570;
        bh=NxRr3i/3FfdnK/KAHIiXOLrAkGgYPUD+efpTLGlFqX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEt+pP136ssI4AaYaSSHE8/ZuVLLDyoR9ifNtWwr99SYQ3VnypXWUnn/SMoZC0EeH
         HCzHRr6La8xKYoczNxc2+Vs1iPNhtpqNHD68ZolFyMuVZcRE6I/6eZdMgZZd1YHoJR
         ZIODsrZZYiNwlxx2T46PDLk74yKjWpNl6TCIYahCoWuSK2EcNr7EktIQO6J9XUrY43
         ue0dqu5CL8kGZtriOFEboE6yt0YPBfMBCQy8kItcUISOahaWWoEoT6san9tsW8SBFW
         J48UDVJ9Qz24wLcTcccAJKQFpBYaULQ5Jit6WLuc/UaFxOSz1rJRU8P6R6/uWvZOAC
         HuMbHfgkjL90w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Zhengming <zhangzhengming@huawei.com>,
        Zhao Lei <zhaolei69@huawei.com>,
        Wang Xiaogang <wangxiaogang3@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 26/35] bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit
Date:   Wed, 12 May 2021 14:01:56 -0400
Message-Id: <20210512180206.664536-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Zhengming <zhangzhengming@huawei.com>

[ Upstream commit 59259ff7a81b9eb6213891c6451221e567f8f22f ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 49700ce0e919..a0a134050b2c 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -102,8 +102,9 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 
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
2.30.2

