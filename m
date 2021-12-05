Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DA2468A1A
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhLEI0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:26:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44406 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhLEI0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:26:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1688DB80DF3;
        Sun,  5 Dec 2021 08:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E5BC341C1;
        Sun,  5 Dec 2021 08:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638692550;
        bh=tvLe7VFl0RnLL2p8o3jPg7l6VG5q2Q6uAGRS4v9se00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUE7HhAKLpC2vPKacnyGBM9pSGcvZkZnNClxafJx7GFCBxLQbT2JUgxxva1M4zE8A
         rqao4g8XqEIBUjYh2fUaWutZ91m0lb2hM7DvaoDv7Yv6VRTAqBRqw+sk2ol7KdtOTr
         cMDwnp/D2eDomXdFAsUJZ7OKtp7fY3JE3SFXOFDAS5AJwFfv7ipA/WfXw79nKwE+qm
         UX4Uzk0y4/nanXk0gN9FNTCouFh73O5j6nF0UxfHjbu3RXpQinQRQxO4lTs35DYMVi
         h/7ZiTEFYG/QW2fvdp6A4QV62gZj1k6f8SZ/yG6uECctEAqUsLXgabihBIQ77Rl4bk
         AaTD0bs2xF4Gw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 5/6] devlink: Use xarray locking mechanism instead big devlink lock
Date:   Sun,  5 Dec 2021 10:22:05 +0200
Message-Id: <860a74b2a376db995fa978d0c7056cf2e54b4b30.1638690564.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1638690564.git.leonro@nvidia.com>
References: <cover.1638690564.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The conversion to XArray together with devlink reference counting
allows us reuse the following locking pattern:
 xa_lock()
  xa_for_each() {
   devlink_try_get()
   xa_unlock()
   ....
   xa_lock()
 }

This pattern gives us a way to run any commands between xa_unlock() and
xa_lock() without big devlink mutex, while making sure that devlink instance
won't be released.

Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 249 ++++++++++++++++++++++-----------------------
 1 file changed, 119 insertions(+), 130 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index cbffafc1776f..7666249b346f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -200,14 +200,6 @@ static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 #define ASSERT_DEVLINK_NOT_REGISTERED(d)                                       \
 	WARN_ON_ONCE(xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
 
-/* devlink_mutex
- *
- * An overall lock guarding every operation coming from userspace.
- * It also guards devlink devices list and it is taken when
- * driver registers/unregisters it.
- */
-static DEFINE_MUTEX(devlink_mutex);
-
 struct net *devlink_net(const struct devlink *devlink)
 {
 	return read_pnet(&devlink->_net);
@@ -264,8 +256,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	busname = nla_data(attrs[DEVLINK_ATTR_BUS_NAME]);
 	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
 
-	lockdep_assert_held(&devlink_mutex);
-
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0 &&
@@ -277,6 +268,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 
 	if (!found || !devlink_try_get(devlink))
 		devlink = ERR_PTR(-ENODEV);
+	xa_unlock(&devlinks);
 
 	return devlink;
 }
@@ -609,12 +601,6 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 #define DEVLINK_NL_FLAG_NEED_RATE		BIT(2)
 #define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
 
-/* The per devlink instance lock is taken by default in the pre-doit
- * operation, yet several commands do not require this. The global
- * devlink lock is taken and protects from disruption by user-calls.
- */
-#define DEVLINK_NL_FLAG_NO_LOCK			BIT(4)
-
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
 	__acquires(&devlink->lock)
@@ -623,16 +609,12 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	struct devlink *devlink;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(genl_info_net(info), info->attrs);
-	if (IS_ERR(devlink)) {
-		mutex_unlock(&devlink_mutex);
+	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
-	}
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK) {
-		mutex_lock(&devlink->lock);
-		xa_set_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
-	}
+
+	mutex_lock(&devlink->lock);
+	xa_set_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
@@ -667,12 +649,9 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	return 0;
 
 unlock:
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK) {
-		xa_clear_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
-		mutex_unlock(&devlink->lock);
-	}
+	xa_clear_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
+	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -680,15 +659,11 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 				 struct sk_buff *skb, struct genl_info *info)
 	__releases(&devlink->lock)
 {
-	struct devlink *devlink;
+	struct devlink *devlink = info->user_ptr[0];
 
-	devlink = info->user_ptr[0];
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK) {
-		xa_clear_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
-		mutex_unlock(&devlink->lock);
-	}
+	xa_clear_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
+	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 
 static struct genl_family devlink_nl_family;
@@ -1231,11 +1206,12 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -1253,6 +1229,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI, NULL);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -1260,10 +1237,11 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -1334,32 +1312,37 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk))) {
-			devlink_put(devlink);
-			continue;
-		}
+		xa_unlock(&devlinks);
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			goto retry;
 
 		if (idx < start) {
 			idx++;
-			devlink_put(devlink);
-			continue;
+			goto retry;
 		}
 
+		mutex_lock(&devlink->lock);
 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
 				      NETLINK_CB(cb->skb).portid,
 				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
-		devlink_put(devlink);
-		if (err)
+		mutex_unlock(&devlink->lock);
+		if (err) {
+			xa_lock(&devlinks);
+			devlink_put(devlink);
 			goto out;
+		}
 		idx++;
+retry:
+		xa_lock(&devlinks);
+		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -1397,11 +1380,12 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -1420,6 +1404,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				mutex_unlock(&devlink->port_list_lock);
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -1428,10 +1413,11 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->port_list_lock);
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -1650,7 +1636,6 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 	if (!msg)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
 	devlink_port = devlink_port_get_by_index(devlink, port_index);
 	if (!devlink_port) {
 		err = -ENODEV;
@@ -1662,12 +1647,9 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 	if (err)
 		goto out;
 
-	err = genlmsg_reply(msg, info);
-	mutex_unlock(&devlink->lock);
-	return err;
+	return genlmsg_reply(msg, info);
 
 out:
-	mutex_unlock(&devlink->lock);
 	nlmsg_free(msg);
 	return err;
 }
@@ -2066,11 +2048,12 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -2087,6 +2070,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 						 NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -2094,10 +2078,11 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -2218,11 +2203,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_pool_get)
 			goto retry;
@@ -2237,16 +2223,18 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -2439,11 +2427,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_port_pool_get)
 			goto retry;
@@ -2458,16 +2447,18 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -2688,11 +2679,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
@@ -2708,16 +2700,18 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -2895,15 +2889,11 @@ static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 {
 	struct devlink_rate *devlink_rate;
 
-	/* Take the lock to sync with devlink_rate_nodes_destroy() */
-	mutex_lock(&devlink->lock);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
 		if (devlink_rate_is_node(devlink_rate)) {
-			mutex_unlock(&devlink->lock);
 			NL_SET_ERR_MSG_MOD(extack, "Rate node(s) exists.");
 			return -EBUSY;
 		}
-	mutex_unlock(&devlink->lock);
 	return 0;
 }
 
@@ -4769,11 +4759,12 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -4792,6 +4783,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -4799,10 +4791,11 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -5004,11 +4997,12 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -5033,6 +5027,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 				} else if (err) {
 					mutex_unlock(&devlink->port_list_lock);
 					mutex_unlock(&devlink->lock);
+					xa_lock(&devlinks);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -5042,10 +5037,11 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->port_list_lock);
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -5554,7 +5550,6 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	struct devlink_port *port;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
 	list_for_each_entry(region, &devlink->region_list, list) {
 		if (*idx < start) {
 			(*idx)++;
@@ -5580,7 +5575,6 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 out_port:
 	mutex_unlock(&devlink->port_list_lock);
 out:
-	mutex_unlock(&devlink->lock);
 	return err;
 }
 
@@ -5593,23 +5587,27 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->lock);
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, start);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 		if (err)
 			goto out;
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -5863,12 +5861,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	start_offset = *((u64 *)&cb->args[0]);
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
-	if (IS_ERR(devlink)) {
-		err = PTR_ERR(devlink);
-		goto out_dev;
-	}
+	if (IS_ERR(devlink))
+		return PTR_ERR(devlink);
 
 	mutex_lock(&devlink->lock);
 
@@ -5968,7 +5963,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	genlmsg_end(skb, hdr);
 	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 
 	return skb->len;
 
@@ -5977,8 +5971,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 out_unlock:
 	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-out_dev:
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -6127,11 +6119,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -6147,15 +6140,17 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		if (err == -EOPNOTSUPP)
 			err = 0;
 		else if (err) {
+			xa_lock(&devlinks);
 			devlink_put(devlink);
 			break;
 		}
 inc:
 		idx++;
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -7230,18 +7225,15 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	struct nlattr **attrs = info->attrs;
 	struct devlink *devlink;
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
 	if (IS_ERR(devlink))
-		goto unlock;
+		return NULL;
 
+	mutex_lock(&devlink->lock);
 	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
+	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 	return reporter;
-unlock:
-	mutex_unlock(&devlink_mutex);
-	return NULL;
 }
 
 void
@@ -7307,14 +7299,16 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_rep;
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->reporters_lock);
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
@@ -7328,13 +7322,17 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->reporters_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->reporters_lock);
+		mutex_unlock(&devlink->lock);
 retry_rep:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 
@@ -7342,6 +7340,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
@@ -7360,9 +7359,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
-					mutex_unlock(&port->reporters_lock);
 					mutex_unlock(&devlink->port_list_lock);
 					mutex_unlock(&devlink->lock);
+					xa_lock(&devlinks);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -7373,10 +7372,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->port_list_lock);
 		mutex_unlock(&devlink->lock);
 retry_port:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -7906,11 +7906,12 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -7927,6 +7928,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -7934,10 +7936,11 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -8133,11 +8136,12 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -8155,6 +8159,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 							 NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -8162,10 +8167,11 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -8447,11 +8453,12 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -8469,6 +8476,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 							   NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -8476,10 +8484,11 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -8672,26 +8681,22 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_UNSPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_unsplit_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_NEW,
 		.doit = devlink_nl_cmd_port_new_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_DEL,
 		.doit = devlink_nl_cmd_port_del_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
@@ -8760,14 +8765,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_get_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_ESWITCH_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_TABLE_GET,
@@ -8877,8 +8880,7 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
 		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -8886,24 +8888,21 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_RECOVER,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_recover_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_diagnose_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET,
@@ -8917,16 +8916,14 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_dump_clear_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_TEST,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_test_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_FLASH_UPDATE,
@@ -9186,10 +9183,8 @@ void devlink_register(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
 
-	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
@@ -9206,10 +9201,8 @@ void devlink_unregister(struct devlink *devlink)
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
-	mutex_lock(&devlink_mutex);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -9561,8 +9554,6 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
  * Create devlink rate object of type leaf on provided @devlink_port.
  * Throws call trace if @devlink_port already has a devlink rate object.
  *
- * Context: Takes and release devlink->lock <mutex>.
- *
  * Return: -ENOMEM if failed to allocate rate object, 0 otherwise.
  */
 int
@@ -9594,8 +9585,6 @@ EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
  * devlink_rate_leaf_destroy - destroy devlink rate leaf
  *
  * @devlink_port: devlink port linked to the rate object
- *
- * Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 {
@@ -9623,8 +9612,6 @@ EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
  *
  * Unset parent for all rate objects and destroy all rate nodes
  * on specified device.
- *
- * Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_rate_nodes_destroy(struct devlink *devlink)
 {
@@ -11438,11 +11425,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	/* In case network namespace is getting destroyed, reload
 	 * all devlink instances from this namespace into init_net.
 	 */
-	mutex_lock(&devlink_mutex);
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
 
@@ -11459,9 +11447,10 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 }
 
 static struct pernet_operations devlink_pernet_ops __net_initdata = {
-- 
2.33.1

