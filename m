Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794C54A4EE
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbfFRPN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53561 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729603AbfFRPNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 68C5B22476;
        Tue, 18 Jun 2019 11:13:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=T+YfHIG3IOIGK3UY211wKXJo4gMlP7Y66ctNpjXtPhM=; b=RNt+ArKD
        PE8JKaKZ83VAqUECMDkB51qWY3X2ZwLye2wJ0BPLXxXmK9K/QGbjM5T17ME2Ve2+
        w4OWtMr85OelsB5N3zUZI7rJ3/PAcvSfgnl7KoXHYDleLFLqAILBxIXV2bRrRozM
        nOe/NsYwqy8qq1UlaGypMfXy1DVjb6XsKcgqFHSw5tpAwI9F5qVpXMmjqPKigiIr
        aznSFfsFR6eWlTgFuN21KZjok5SCgC+v+AfIJ1R8wD75YqA8LrZpN3BvSb5dyxlu
        GgymwN2fPEZewg0Ye5exUXzUsxs+CLK2Fz2mfETmsGr9zwzCmUHcXin5YfjigIdV
        WOjtzIFjv35S4A==
X-ME-Sender: <xms:sP8IXSr3A7LcD9Hpr7SofqWU3znriSLwXZDo4Xc0UVwDSg0NyziMKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepudef
X-ME-Proxy: <xmx:sP8IXW88NnfajESCMty8stZyuR9ZbyFU-SmDUvHfeiEnKiyZeZs8Rg>
    <xmx:sP8IXT7M74pMh9pr_pERNJRQylOmFDDNoxYFye3uijlo4H7MP_0nIA>
    <xmx:sP8IXQgjeZ7jP_yBz7bxai6JUpCRH6DmltlZjimWX0rN8i5UoeOOlw>
    <xmx:sP8IXZRG2y5ldx9SaNuvNkkK2DrD9N7HOqnLcp6GJkvbRkH750RUpA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 813AE380087;
        Tue, 18 Jun 2019 11:13:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 15/16] ipv6: Stop sending in-kernel notifications for each nexthop
Date:   Tue, 18 Jun 2019 18:12:57 +0300
Message-Id: <20190618151258.23023-16-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
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

v2:
* Remove 'multipath_rt' from 'struct fib6_entry_notifier_info'

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  2 --
 drivers/net/netdevsim/fib.c                   |  7 -----
 include/net/ip6_fib.h                         |  1 -
 net/ipv6/ip6_fib.c                            | 29 +++++++++++--------
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 92ec65188e9a..e618be7ce6c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6294,8 +6294,6 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
 				return notifier_from_errno(-EINVAL);
 			}
-			if (fen6_info->multipath_rt)
-				return NOTIFY_DONE;
 		}
 		break;
 	}
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 83ba5113210d..8c57ba747772 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -190,13 +190,6 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 
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
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 7c3d5ab05879..87331f2c4af0 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -378,7 +378,6 @@ struct fib6_entry_notifier_info {
 	struct fib_notifier_info info; /* must be first */
 	struct fib6_info *rt;
 	unsigned int nsiblings;
-	bool multipath_rt;
 };
 
 /*
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index df08ba8fe6fc..1d16a01eccf5 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -391,7 +391,6 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
 		.info.extack = extack,
 		.rt = rt,
 		.nsiblings = nsiblings,
-		.multipath_rt = true,
 	};
 
 	rt->fib6_table->fib_seq++;
@@ -1140,11 +1139,13 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
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
@@ -1169,11 +1170,13 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
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
@@ -1856,9 +1859,11 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 
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

