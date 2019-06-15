Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A752547059
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfFOOKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:10:00 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34111 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0889221B84;
        Sat, 15 Jun 2019 10:09:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gRmWw8su7TX+u52rD/OyiRbhgZNMhNgrYT7t0UnW4tY=; b=budS4CwM
        u1ES9YGrM04dL+rvcfyluuYeXJ/nK/wdWyOYJbCeJRDC7BNI+3ADn2OHd2WVvQxR
        E3p2X8BqDlXbDI8qenhhRusEwc0xNoO4t0Op/iyiaCBuuXptdohtEFbYglV5B0WI
        TVL1RBSINkObRkzG/dF0j8sZmF+rE5w4N8h6xGcsG934GDNlgz8Du8s9iTaVxhEy
        RVSO9Wey4UTwZUb/ZBZsdthvyopHT6AbPmJuKJffXGQjeQ255JzPSik3jO1tJs80
        qJ/lqdGyXYJFpJnq/MWlPNSmaL2gB6a7AlYw31yv/ISqcbkwgd2EMcm/FKsXDZ7b
        jaRLRykSldYYLg==
X-ME-Sender: <xms:NvwEXUPL0yxU0zCoNnLDBdoNUM58t0kfW-hkn0cvMXy7mR8cUfO9cA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepge
X-ME-Proxy: <xmx:NvwEXXy9IdYE65kGPFGHlFcWzfsq06s5KjkWrr-xud7DaFg355-KXw>
    <xmx:NvwEXdjz7Bb8AuZI9LYCwi0Klnx4aG7g9KGdoNVqh7jEUSPW-_f-Nw>
    <xmx:NvwEXc3jaoWBmPtnLWOlqOe5phdVvMFg_J0SINLbmR9FqC7YwMPziA>
    <xmx:N_wEXVnUf0p0EZm3toOGT7AMscLe8eOzjeKArP3A1gAVNDgKc-CuJw>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id D99D2380086;
        Sat, 15 Jun 2019 10:09:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 16/17] ipv6: Stop sending in-kernel notifications for each nexthop
Date:   Sat, 15 Jun 2019 17:07:50 +0300
Message-Id: <20190615140751.17661-17-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Both listeners - mlxsw and netdevsim - of IPv6 FIB notifications are now
ready to handle IPv6 multipath notifications.

Therefore, stop ignoring such notifications in both drivers and stop
sending notification for each added / deleted nexthop.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  2 --
 drivers/net/netdevsim/fib.c                   |  7 -----
 net/ipv6/ip6_fib.c                            | 28 +++++++++++--------
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2f5fa1fac825..1ad3bb88f85f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6228,8 +6228,6 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
 				return notifier_from_errno(-EINVAL);
 			}
-			if (fen6_info->multipath_rt)
-				return NOTIFY_DONE;
 		}
 		break;
 	}
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 6e5498ef3855..2acef70f93db 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -197,13 +197,6 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 
 	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
-		if (info->family == AF_INET6) {
-			struct fib6_entry_notifier_info *fen6_info = ptr;
-
-			if (fen6_info->multipath_rt)
-				return NOTIFY_DONE;
-		}
-
 		err = nsim_fib_event(data, info,
 				     event == FIB_EVENT_ENTRY_ADD);
 		break;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index df08ba8fe6fc..e08f2a502d09 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1140,11 +1140,13 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 add:
 		nlflags |= NLM_F_CREATE;
 
-		err = call_fib6_entry_notifiers(info->nl_net,
-						FIB_EVENT_ENTRY_ADD,
-						rt, extack);
-		if (err)
-			return err;
+		if (!info->skip_notify_kernel) {
+			err = call_fib6_entry_notifiers(info->nl_net,
+							FIB_EVENT_ENTRY_ADD,
+							rt, extack);
+			if (err)
+				return err;
+		}
 
 		rcu_assign_pointer(rt->fib6_next, iter);
 		fib6_info_hold(rt);
@@ -1169,11 +1171,13 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			return -ENOENT;
 		}
 
-		err = call_fib6_entry_notifiers(info->nl_net,
-						FIB_EVENT_ENTRY_REPLACE,
-						rt, extack);
-		if (err)
-			return err;
+		if (!info->skip_notify_kernel) {
+			err = call_fib6_entry_notifiers(info->nl_net,
+							FIB_EVENT_ENTRY_REPLACE,
+							rt, extack);
+			if (err)
+				return err;
+		}
 
 		fib6_info_hold(rt);
 		rcu_assign_pointer(rt->fib6_node, fn);
@@ -1856,9 +1860,11 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 
 	fib6_purge_rt(rt, fn, net);
 
-	call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, rt, NULL);
+	if (!info->skip_notify_kernel)
+		call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, rt, NULL);
 	if (!info->skip_notify)
 		inet6_rt_notify(RTM_DELROUTE, rt, info, 0);
+
 	fib6_info_release(rt);
 }
 
-- 
2.20.1

