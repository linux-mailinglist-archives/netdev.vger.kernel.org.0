Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD85433CFA3
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhCPIVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbhCPIVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:21:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CE7C061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:21:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lM4wz-00033B-UT
        for netdev@vger.kernel.org; Tue, 16 Mar 2021 09:21:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4DA235F6436
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:21:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 55E2F5F640F;
        Tue, 16 Mar 2021 08:21:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a1ff0722;
        Tue, 16 Mar 2021 08:21:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Martin Willi <martin@strongswan.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 01/11] can: dev: Move device back to init netns on owning netns delete
Date:   Tue, 16 Mar 2021 09:20:54 +0100
Message-Id: <20210316082104.4027260-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316082104.4027260-1-mkl@pengutronix.de>
References: <20210316082104.4027260-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

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
Link: https://lore.kernel.org/r/20210302122423.872326-1-martin@strongswan.org
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
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

base-commit: 13832ae2755395b2585500c85b64f5109a44227e
-- 
2.30.1


