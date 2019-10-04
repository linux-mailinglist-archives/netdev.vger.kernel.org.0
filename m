Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32F9CBE54
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbfJDO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389043AbfJDO7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 10:59:13 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0EE92084D;
        Fri,  4 Oct 2019 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570201152;
        bh=L8C4Aa+U7ADyHjexBNbIvbPNV+ijlDg+iRTHCpTG2RI=;
        h=From:To:Cc:Subject:Date:From;
        b=2HZOGBLHmiIevD2aHouSn5HOMLvBcrdLcc3BLdbuFDxiVqExhakLXAv2NiHiXhtpN
         INBjwUdp1pPADut69dJskLhtYz1Kq+QtECEksVwCY8vl+5N8HO3O7ZnLh9NarJDLZL
         jvxkL1jOsA1Uz6f90YU5DWK766SbfN/pLJ1O9CDg=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com,
        eric.dumazet@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv6: Handle missing host route in __ipv6_ifa_notify
Date:   Fri,  4 Oct 2019 08:03:09 -0700
Message-Id: <20191004150309.4715-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Rajendra reported a kernel panic when a link was taken down:

    [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
    [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290

    <snip>

    [ 6870.570501] Call Trace:
    [ 6870.573238] [<ffffffff8efc58c6>] ? ipv6_ifa_notify+0x26/0x40
    [ 6870.579665] [<ffffffff8efc98ec>] ? addrconf_dad_completed+0x4c/0x2c0
    [ 6870.586869] [<ffffffff8efe70c6>] ? ipv6_dev_mc_inc+0x196/0x260
    [ 6870.593491] [<ffffffff8efc9c6a>] ? addrconf_dad_work+0x10a/0x430
    [ 6870.600305] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
    [ 6870.606732] [<ffffffff8ea93a7a>] ? process_one_work+0x18a/0x430
    [ 6870.613449] [<ffffffff8ea93d6d>] ? worker_thread+0x4d/0x490
    [ 6870.619778] [<ffffffff8ea93d20>] ? process_one_work+0x430/0x430
    [ 6870.626495] [<ffffffff8ea99dd9>] ? kthread+0xd9/0xf0
    [ 6870.632145] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
    [ 6870.638573] [<ffffffff8ea99d00>] ? kthread_park+0x60/0x60
    [ 6870.644707] [<ffffffff8f01ae77>] ? ret_from_fork+0x57/0x70
    [ 6870.650936] Code: 31 c0 31 d2 41 b9 20 00 08 02 b9 09 00 00 0

addrconf_dad_work is kicked to be scheduled when a device is brought
up. There is a race between addrcond_dad_work getting scheduled and
taking the rtnl lock and a process taking the link down (under rtnl).
The latter removes the host route from the inet6_addr as part of
addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
to use the host route in __ipv6_ifa_notify. If the down event removes
the host route due to the race to the rtnl, then the BUG listed above
occurs.

Since the DAD sequence can not be aborted, add a check for the missing
host route in __ipv6_ifa_notify. The only way this should happen is due
to the previously mentioned race. The host route is created when the
address is added to an interface; it is only removed on a down event
where the address is kept. Add a warning if the host route is missing
AND the device is up; this is a situation that should never happen.

Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/addrconf.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6a576ff92c39..34ccef18b40e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5964,13 +5964,20 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 	switch (event) {
 	case RTM_NEWADDR:
 		/*
-		 * If the address was optimistic
-		 * we inserted the route at the start of
-		 * our DAD process, so we don't need
-		 * to do it again
+		 * If the address was optimistic we inserted the route at the
+		 * start of our DAD process, so we don't need to do it again.
+		 * If the device was taken down in the middle of the DAD
+		 * cycle there is a race where we could get here without a
+		 * host route, so nothing to insert. That will be fixed when
+		 * the device is brought up.
 		 */
-		if (!rcu_access_pointer(ifp->rt->fib6_node))
+		if (ifp->rt && !rcu_access_pointer(ifp->rt->fib6_node)) {
 			ip6_ins_rt(net, ifp->rt);
+		} else if (!ifp->rt && (ifp->idev->dev->flags & IFF_UP)) {
+			pr_warn("BUG: Address %pI6c on device %s is missing its host route.\n",
+				&ifp->addr, ifp->idev->dev->name);
+		}
+
 		if (ifp->idev->cnf.forwarding)
 			addrconf_join_anycast(ifp);
 		if (!ipv6_addr_any(&ifp->peer_addr))
-- 
2.11.0

