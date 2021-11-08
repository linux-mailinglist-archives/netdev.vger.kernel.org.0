Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F5E449A7E
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241434AbhKHRJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241432AbhKHRJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF6961406;
        Mon,  8 Nov 2021 17:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391198;
        bh=aLl062/y7Xrk7Z+j2yODKrv7SLo9EcYD7JxZDQj2BGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ev4uMHP1/7gibNfhH8fodOTCzqtqGWQkqmRhaPQFh5XrkQa4oc/pSRyvfMwtp7Nvk
         Z6RLZu3wRM13aPRukQ/GquEM6VcfkkkbcWs2PP8LHu5galEfg1Uo/tO/QtxyPfFcEt
         +14yDso/IQ+7WR0Ra/KO0vpYWgq8ZHI233LqagBVwWxKQQE7H/iC04EyBC2rfWi3J4
         hrli2pVKnmsDL7x5ASL+il9wsurOW8dXSs6IF/wpEZeT+PokSmB9ODSKrEQBlsSXsn
         g+S+vITYcJGp3+2xL3YFf9JTTqqrB1iMaBG1cAkaN9SgZrbj73BxsVyjVO7jE2TYV2
         5+LDuRScvJPkA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 15/16] devlink: Use xarray locking mechanism instead big devlink lock
Date:   Mon,  8 Nov 2021 19:05:37 +0200
Message-Id: <d9b0368861c7edbeef3164143e9cba3651a2ef6c.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 256 ++++++++++++++++++++++++++-------------------
 1 file changed, 150 insertions(+), 106 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 32d274bfd049..147f606cac41 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -175,14 +175,6 @@ static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
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
@@ -215,8 +207,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	busname = nla_data(attrs[DEVLINK_ATTR_BUS_NAME]);
 	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
 
-	lockdep_assert_held(&devlink_mutex);
-
+	xa_lock(&devlinks);
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0 &&
@@ -228,6 +219,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 
 	if (!found || !devlink_try_get(devlink))
 		devlink = ERR_PTR(-ENODEV);
+	xa_unlock(&devlinks);
 
 	return devlink;
 }
@@ -524,12 +516,6 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
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
 {
@@ -537,14 +523,11 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	struct devlink *devlink;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(genl_info_net(info), info->attrs);
-	if (IS_ERR(devlink)) {
-		mutex_unlock(&devlink_mutex);
+	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
-	}
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_lock(&devlink->lock);
+
+	mutex_lock(&devlink->lock);
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
@@ -579,23 +562,18 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	return 0;
 
 unlock:
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
 static void devlink_nl_post_doit(const struct genl_ops *ops,
 				 struct sk_buff *skb, struct genl_info *info)
 {
-	struct devlink *devlink;
+	struct devlink *devlink = info->user_ptr[0];
 
-	devlink = info->user_ptr[0];
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 
 static struct genl_family devlink_nl_family;
@@ -1138,14 +1116,16 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
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
 		mutex_lock(&devlink->rate_list_lock);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
@@ -1160,17 +1140,20 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI, NULL);
 			if (err) {
 				mutex_unlock(&devlink->rate_list_lock);
+				mutex_unlock(&devlink->lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->rate_list_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -1241,32 +1224,37 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
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
@@ -1304,14 +1292,16 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			if (idx < start) {
@@ -1325,17 +1315,21 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI, cb->extack);
 			if (err) {
 				mutex_unlock(&devlink->port_list_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->port_list_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -1979,14 +1973,16 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < start) {
@@ -2000,17 +1996,21 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 						 NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->sb_list_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->sb_list_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -2131,15 +2131,17 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_pool_get_dumpit(msg, start, &idx, devlink,
@@ -2150,16 +2152,20 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->sb_list_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->sb_list_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -2352,15 +2358,17 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_port_pool_get_dumpit(msg, start, &idx,
@@ -2371,16 +2379,20 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->sb_list_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->sb_list_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -2604,15 +2616,17 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_tc_pool_bind_get_dumpit(msg, start, &idx,
@@ -2624,16 +2638,20 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->sb_list_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->sb_list_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -4704,11 +4722,12 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
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
 
@@ -4727,6 +4746,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
@@ -4734,10 +4754,11 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
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
@@ -4939,14 +4960,16 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
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
 		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
@@ -4966,6 +4989,8 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 					err = 0;
 				} else if (err) {
 					mutex_unlock(&devlink->port_list_lock);
+					mutex_unlock(&devlink->lock);
+					xa_lock(&devlinks);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -4973,11 +4998,13 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 			}
 		}
 		mutex_unlock(&devlink->port_list_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -5516,23 +5543,27 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
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
@@ -5786,13 +5817,11 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	start_offset = *((u64 *)&cb->args[0]);
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
-	if (IS_ERR(devlink)) {
-		err = PTR_ERR(devlink);
-		goto out_dev;
-	}
+	if (IS_ERR(devlink))
+		return PTR_ERR(devlink);
 
+	mutex_lock(&devlink->lock);
 	mutex_lock(&devlink->region_list_lock);
 
 	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
@@ -5890,8 +5919,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	nla_nest_end(skb, chunks_attr);
 	genlmsg_end(skb, hdr);
 	mutex_unlock(&devlink->region_list_lock);
+	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 
 	return skb->len;
 
@@ -5899,9 +5928,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	genlmsg_cancel(skb, hdr);
 out_unlock:
 	mutex_unlock(&devlink->region_list_lock);
+	mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
-out_dev:
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -6050,11 +6078,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
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
 
@@ -6070,15 +6099,17 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
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
@@ -7153,18 +7184,15 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
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
@@ -7230,14 +7258,16 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
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
@@ -7251,13 +7281,17 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
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
 
@@ -7265,9 +7299,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!devlink_try_get(devlink))
 			continue;
 
+		xa_unlock(&devlinks);
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
@@ -7284,6 +7320,8 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
 					mutex_unlock(&devlink->port_list_lock);
+					mutex_unlock(&devlink->lock);
+					xa_lock(&devlinks);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -7292,11 +7330,13 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			mutex_unlock(&port->reporters_lock);
 		}
 		mutex_unlock(&devlink->port_list_lock);
+		mutex_unlock(&devlink->lock);
 retry_port:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -7835,14 +7875,16 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->traps_lock);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < start) {
@@ -7856,17 +7898,21 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->traps_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->traps_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -8075,14 +8121,16 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->traps_lock);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
@@ -8097,17 +8145,21 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 							 NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->traps_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->traps_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -8402,14 +8454,16 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
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
 
+		mutex_lock(&devlink->lock);
 		mutex_lock(&devlink->traps_lock);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
@@ -8424,17 +8478,21 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 							   NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->traps_lock);
+				mutex_unlock(&devlink->lock);
+				xa_lock(&devlinks);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->traps_lock);
+		mutex_unlock(&devlink->lock);
 retry:
+		xa_lock(&devlinks);
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
+	xa_unlock(&devlinks);
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -8633,26 +8691,22 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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
@@ -8721,14 +8775,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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
@@ -8838,8 +8890,7 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
 		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -8847,24 +8898,21 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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
@@ -8878,16 +8926,14 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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
@@ -9180,10 +9226,8 @@ void devlink_register(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
 
-	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
@@ -9200,10 +9244,8 @@ void devlink_unregister(struct devlink *devlink)
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
-	mutex_lock(&devlink_mutex);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -11453,11 +11495,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
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
 
@@ -11471,9 +11514,10 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 		mutex_unlock(&devlink->lock);
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

