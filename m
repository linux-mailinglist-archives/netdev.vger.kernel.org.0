Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5617532B377
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449646AbhCCEB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:01:28 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:55440 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344792AbhCBMjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 07:39:12 -0500
Received: from localhost.localdomain (unknown [185.12.128.224])
        by mail.strongswan.org (Postfix) with ESMTPSA id 7CD5E409FE;
        Tue,  2 Mar 2021 13:24:36 +0100 (CET)
From:   Martin Willi <martin@strongswan.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: [PATCH net] can: dev: Move device back to init netns on owning netns delete
Date:   Tue,  2 Mar 2021 13:24:23 +0100
Message-Id: <20210302122423.872326-1-martin@strongswan.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a non-initial netns is destroyed, the usual policy is to delete
all virtual network interfaces contained, but move physical interfaces
back to the initial netns. This keeps the physical interface visible
on the system.

CAN devices are somewhat special, as they define rtnl_link_ops even
if they are physical devices. If a CAN interface is moved into a
non-initial netns, destroying that netns lets the interface vanish
instead of moving it back to the initial netns. default_device_exit()
skips CAN interfaces due to having rtnl_link_ops set. Reproducer:

  ip netns add foo
  ip link set can0 netns foo
  ip netns delete foo

WARNING: CPU: 1 PID: 84 at net/core/dev.c:11030 ops_exit_list+0x38/0x60
CPU: 1 PID: 84 Comm: kworker/u4:2 Not tainted 5.10.19 #1
Workqueue: netns cleanup_net
[<c010e700>] (unwind_backtrace) from [<c010a1d8>] (show_stack+0x10/0x14)
[<c010a1d8>] (show_stack) from [<c086dc10>] (dump_stack+0x94/0xa8)
[<c086dc10>] (dump_stack) from [<c086b938>] (__warn+0xb8/0x114)
[<c086b938>] (__warn) from [<c086ba10>] (warn_slowpath_fmt+0x7c/0xac)
[<c086ba10>] (warn_slowpath_fmt) from [<c0629f20>] (ops_exit_list+0x38/0x60)
[<c0629f20>] (ops_exit_list) from [<c062a5c4>] (cleanup_net+0x230/0x380)
[<c062a5c4>] (cleanup_net) from [<c0142c20>] (process_one_work+0x1d8/0x438)
[<c0142c20>] (process_one_work) from [<c0142ee4>] (worker_thread+0x64/0x5a8)
[<c0142ee4>] (worker_thread) from [<c0148a98>] (kthread+0x148/0x14c)
[<c0148a98>] (kthread) from [<c0100148>] (ret_from_fork+0x14/0x2c)

To properly restore physical CAN devices to the initial netns on owning
netns exit, introduce a flag on rtnl_link_ops that can be set by drivers.
For CAN devices setting this flag, default_device_exit() considers them
non-virtual, applying the usual namespace move.

The issue was introduced in the commit mentioned below, as at that time
CAN devices did not have a dellink() operation.

Fixes: e008b5fc8dc7 ("net: Simplfy default_device_exit and improve batching.")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/can/dev/netlink.c | 1 +
 include/net/rtnetlink.h       | 2 ++
 net/core/dev.c                | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 867f6be31230..f5d79e6e5483 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -355,6 +355,7 @@ static void can_dellink(struct net_device *dev, struct list_head *head)
 
 struct rtnl_link_ops can_link_ops __read_mostly = {
 	.kind		= "can",
+	.netns_refund	= true,
 	.maxtype	= IFLA_CAN_MAX,
 	.policy		= can_policy,
 	.setup		= can_setup,
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index e2091bb2b3a8..4da61c950e93 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -33,6 +33,7 @@ static inline int rtnl_msg_family(const struct nlmsghdr *nlh)
  *
  *	@list: Used internally
  *	@kind: Identifier
+ *	@netns_refund: Physical device, move to init_net on netns exit
  *	@maxtype: Highest device specific netlink attribute number
  *	@policy: Netlink policy for device specific attribute validation
  *	@validate: Optional validation function for netlink/changelink parameters
@@ -64,6 +65,7 @@ struct rtnl_link_ops {
 	size_t			priv_size;
 	void			(*setup)(struct net_device *dev);
 
+	bool			netns_refund;
 	unsigned int		maxtype;
 	const struct nla_policy	*policy;
 	int			(*validate)(struct nlattr *tb[],
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..a142a207fc1d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11346,7 +11346,7 @@ static void __net_exit default_device_exit(struct net *net)
 			continue;
 
 		/* Leave virtual devices for the generic cleanup */
-		if (dev->rtnl_link_ops)
+		if (dev->rtnl_link_ops && !dev->rtnl_link_ops->netns_refund)
 			continue;
 
 		/* Push remaining network devices to init_net */
-- 
2.25.1

