Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E724449A7D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbhKHRJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241438AbhKHRJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C7E6120A;
        Mon,  8 Nov 2021 17:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391194;
        bh=wSGp1BCht3MWcZxi804KOVuo0LOX/owlesMVLeFUUG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaBibDOkoKMilgbuvjmWt+rfGyOe5Dkbh/9m8Nw7upKv594D7KZ1zOreWj7sxkbC1
         9vr7ajI5u6jeqP93JZaeJw+U1Yp93Wh/USpbKCVgZCxoXdsUM/1PfhiFthXFIaTplm
         fxeUB3fEeTeLbDEd/rTCc8wBwH5O/r0uO19SMfhj2W+PR+nDX6lIhWN8ZhAKP03uTr
         TDMYeZT6+v9ZoFf9WdVusniaXGMZaLc3Ib1hKAqksIEs6BXe8qB2WRl8fj49yvvo99
         gLLiMDMNwI3vcQv12XmfHlih38PNcIjb5/arpLGUosSMCFRbnRIqnC/uFw1Fp7wvsy
         RlMpAH0lQFjcQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 12/16] devlink: Protect all sb operations with specialized lock
Date:   Mon,  8 Nov 2021 19:05:34 +0200
Message-Id: <8b8ef7aac1827f75714ea48c5d9b3898b49e4103.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Separate sb related list protection from main devlink instance lock
to rely on specialized lock.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 008826bc108d..19f1802f1e5d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -45,6 +45,7 @@ struct devlink {
 	struct list_head rate_list;
 	struct mutex rate_list_lock; /* protects rate_list */
 	struct list_head sb_list;
+	struct mutex sb_list_lock; /* protects sb_list */
 	struct list_head dpipe_table_list;
 	struct list_head resource_list;
 	struct mutex resource_list_lock; /* protects resource_list */
@@ -1985,7 +1986,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < start) {
 				idx++;
@@ -1997,13 +1998,13 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 						 cb->nlh->nlmsg_seq,
 						 NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->sb_list_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->sb_list_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -2138,7 +2139,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_pool_get_dumpit(msg, start, &idx, devlink,
 						   devlink_sb,
@@ -2147,12 +2148,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 			if (err == -EOPNOTSUPP) {
 				err = 0;
 			} else if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->sb_list_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->sb_list_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -2359,7 +2360,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_port_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_port_pool_get_dumpit(msg, start, &idx,
 							devlink, devlink_sb,
@@ -2368,12 +2369,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 			if (err == -EOPNOTSUPP) {
 				err = 0;
 			} else if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->sb_list_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->sb_list_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -2611,7 +2612,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->sb_list_lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_tc_pool_bind_get_dumpit(msg, start, &idx,
 							   devlink,
@@ -2621,12 +2622,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 			if (err == -EOPNOTSUPP) {
 				err = 0;
 			} else if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->sb_list_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->sb_list_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -9022,6 +9023,8 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->rate_list_lock);
 
 	INIT_LIST_HEAD(&devlink->sb_list);
+	mutex_init(&devlink->sb_list_lock);
+
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
 
 	INIT_LIST_HEAD(&devlink->resource_list);
@@ -9201,6 +9204,7 @@ void devlink_free(struct devlink *devlink)
 	mutex_destroy(&devlink->traps_lock);
 	mutex_destroy(&devlink->region_list_lock);
 	mutex_destroy(&devlink->rate_list_lock);
+	mutex_destroy(&devlink->sb_list_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -9715,9 +9719,9 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	devlink_sb->ingress_tc_count = ingress_tc_count;
 	devlink_sb->egress_tc_count = egress_tc_count;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->sb_list_lock);
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->sb_list_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
@@ -9729,9 +9733,9 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->sb_list_lock);
 	list_del(&devlink_sb->list);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->sb_list_lock);
 	kfree(devlink_sb);
 }
 EXPORT_SYMBOL_GPL(devlink_sb_unregister);
-- 
2.33.1

