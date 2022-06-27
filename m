Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098BF55CA5D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiF0NzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbiF0NzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:55:12 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E5BAE68
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:55:07 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id fd6so13150042edb.5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BEqzxiDAs/X5si+YmvCouItm0e8tV9qBF7LsnhX9L3Q=;
        b=xuVEJpW6ZnNYrmo/3baCFVsQBzDw9k4oQIxMZ5gPJ9q67dUU5hfMHdqoTzlptsGiei
         rUdGIevZj9ZViihrPkX83E7fFdlCcGo3cGSBOv/TNWofoqfuLCPkeUDvPEDAhpBICeP0
         6NSnZJVH15sNLS17S+x8Y+iyqzsNoxLx3A55kuSVF+qaGQJMoWJzTlVW39qojioK0puf
         9nMxyxuPSQjbgylad5C3HSYolZAqUA+SgOID+Yk6XpduoPHEqE4dVyk+NTqXv7+rjIka
         fVznjgof1uPmuqpX4mb0wFzR2Qzw2/Y/LT5NUfMe2mJmHQWMK7GGOLbcgHbyXrTa4MaE
         hYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BEqzxiDAs/X5si+YmvCouItm0e8tV9qBF7LsnhX9L3Q=;
        b=JISlMUfDfWzMfsS0yeIBYnC0Q8vIBzXzPQD0LC1DGEjK1IQn+ZKXYrBBIWU4+4QLRF
         hwm2L+4nik5+r8VsBB0efxyxgUH8hQbCL0zxjKzFy1Y/i7cpEKa2UBCXaY0zfiTFCxsC
         BRV5yK41Vz3Kif6XtE32gkY/MAv/yBEyOGi9lyzsP7yDZKJzE3eV8n4X6OyxmblK2Jlj
         ZoRhilJnKyCM7bKmixJ012mHegiz20Ey4lIIuDtM7mVesospcR+jEYeP5w6KHIsMeWN0
         cVyr7AcKvSpAQjBhsweQq0PLqC9U2a0HRP4I8vxYfYVKAeKef0MhHj8Sivelok0NP/nz
         GvjQ==
X-Gm-Message-State: AJIora/Xg31jwN9a1en93ufHk9TrJd+t50olSUmtl8gKBaF5WvfagIHy
        HOlHwuBkzKcOnpvfS84URPJOZevpj5vgle97MXw=
X-Google-Smtp-Source: AGRyM1twZI5bxSn8OpctnZ234mSvyJkbhe9YGxMahXJIq7gE9du5dDTVp8TaeXme3Znj0GJ9rmVJaQ==
X-Received: by 2002:a05:6402:4244:b0:437:726c:e1a with SMTP id g4-20020a056402424400b00437726c0e1amr14235328edb.107.1656338106067;
        Mon, 27 Jun 2022 06:55:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j12-20020a1709064b4c00b00722e7e48dfdsm5036664ejv.218.2022.06.27.06.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 06:55:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next RFC 2/2] net: devlink: replace devlink_mutex by per-devlink lock
Date:   Mon, 27 Jun 2022 15:55:01 +0200
Message-Id: <20220627135501.713980-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220627135501.713980-1-jiri@resnulli.us>
References: <20220627135501.713980-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently devlink_mutex enforces user commands to not run in parallel.
However not only per-devlink instance, but globally.

Break this big lock into per-devlink instance mutex.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 143 +++++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 77 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9e34b4b9b19b..966749aa3158 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -66,6 +66,8 @@ struct devlink {
 	 * port, sb, dpipe, resource, params, region, traps and more.
 	 */
 	struct mutex lock;
+	/* Makes sure only one user cmd is in execution at a time. */
+	struct mutex cmd_mutex;
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct completion comp;
@@ -218,12 +220,6 @@ static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 #define ASSERT_DEVLINK_NOT_REGISTERED(d)                                       \
 	WARN_ON_ONCE(xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
 
-/* devlink_mutex
- *
- * An overall lock guarding every operation coming from userspace.
- */
-static DEFINE_MUTEX(devlink_mutex);
-
 struct net *devlink_net(const struct devlink *devlink)
 {
 	return read_pnet(&devlink->_net);
@@ -296,8 +292,6 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	busname = nla_data(attrs[DEVLINK_ATTR_BUS_NAME]);
 	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
 
-	lockdep_assert_held(&devlink_mutex);
-
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
@@ -703,8 +697,8 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 #define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
 
 /* The per devlink instance lock is taken by default in the pre-doit
- * operation, yet several commands do not require this. The global
- * devlink lock is taken and protects from disruption by user-calls.
+ * operation, yet several commands do not require this. The devlink
+ * command mutex is taken and protects from disruption by user-calls.
  */
 #define DEVLINK_NL_FLAG_NO_LOCK			BIT(5)
 
@@ -716,12 +710,10 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	struct devlink *devlink;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(genl_info_net(info), info->attrs);
-	if (IS_ERR(devlink)) {
-		mutex_unlock(&devlink_mutex);
+	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
-	}
+	mutex_lock(&devlink->cmd_mutex);
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_lock(&devlink->lock);
 	info->user_ptr[0] = devlink;
@@ -767,8 +759,8 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 unlock:
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->cmd_mutex);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -785,8 +777,8 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->cmd_mutex);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 
 static struct genl_family devlink_nl_family;
@@ -1333,7 +1325,6 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -1343,6 +1334,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
@@ -1357,19 +1349,20 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI, NULL);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -1440,7 +1433,6 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -1453,9 +1445,11 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 		if (idx < start)
 			goto inc;
 
+		mutex_lock(&devlink->cmd_mutex);
 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
 				      NETLINK_CB(cb->skb).portid,
 				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
+		mutex_unlock(&devlink->cmd_mutex);
 		if (err) {
 			devlink_put(devlink);
 			goto out;
@@ -1468,8 +1462,6 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -1506,7 +1498,6 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -1516,6 +1507,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			if (idx < start) {
@@ -1529,20 +1521,20 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI, cb->extack);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -2195,7 +2187,6 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -2205,6 +2196,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->linecards_lock);
 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
 			if (idx < start) {
@@ -2221,20 +2213,20 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 			mutex_unlock(&linecard->state_lock);
 			if (err) {
 				mutex_unlock(&devlink->linecards_lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->linecards_lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -2471,7 +2463,6 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -2481,6 +2472,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < start) {
@@ -2494,20 +2486,20 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 						 NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -2627,7 +2619,6 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -2638,6 +2629,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_pool_get)
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_pool_get_dumpit(msg, start, &idx, devlink,
@@ -2648,19 +2640,19 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -2852,7 +2844,6 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -2863,6 +2854,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_port_pool_get)
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_port_pool_get_dumpit(msg, start, &idx,
@@ -2873,19 +2865,19 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -3105,7 +3097,6 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -3116,6 +3107,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_tc_pool_bind_get_dumpit(msg, start, &idx,
@@ -3127,19 +3119,19 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -5196,7 +5188,6 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -5206,6 +5197,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
 			if (idx < start) {
@@ -5221,20 +5213,20 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 				err = 0;
 			} else if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -5435,7 +5427,6 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -5445,6 +5436,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
@@ -5464,6 +5456,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 					err = 0;
 				} else if (err) {
 					mutex_unlock(&devlink->lock);
+					mutex_unlock(&devlink->cmd_mutex);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -5471,14 +5464,13 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 			}
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -6023,7 +6015,6 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -6033,8 +6024,10 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, start);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		if (err)
@@ -6043,7 +6036,6 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -6297,13 +6289,11 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	start_offset = *((u64 *)&cb->args[0]);
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
-	if (IS_ERR(devlink)) {
-		err = PTR_ERR(devlink);
-		goto out_dev;
-	}
+	if (IS_ERR(devlink))
+		return PTR_ERR(devlink);
 
+	mutex_lock(&devlink->cmd_mutex);
 	mutex_lock(&devlink->lock);
 
 	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
@@ -6401,8 +6391,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	nla_nest_end(skb, chunks_attr);
 	genlmsg_end(skb, hdr);
 	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->cmd_mutex);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 
 	return skb->len;
 
@@ -6410,9 +6400,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	genlmsg_cancel(skb, hdr);
 out_unlock:
 	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->cmd_mutex);
 	devlink_put(devlink);
-out_dev:
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -6561,7 +6550,6 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -6574,12 +6562,14 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		if (idx < start || !devlink->ops->info_get)
 			goto inc;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					   cb->extack);
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 		if (err == -EOPNOTSUPP)
 			err = 0;
 		else if (err) {
@@ -6593,7 +6583,6 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-	mutex_unlock(&devlink_mutex);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -7668,18 +7657,13 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	struct nlattr **attrs = info->attrs;
 	struct devlink *devlink;
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
 	if (IS_ERR(devlink))
-		goto unlock;
+		return NULL;
 
 	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 	return reporter;
-unlock:
-	mutex_unlock(&devlink_mutex);
-	return NULL;
 }
 
 void
@@ -7745,7 +7729,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -7755,6 +7738,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_rep;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->reporters_lock);
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
@@ -7768,12 +7752,14 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->reporters_lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->reporters_lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry_rep:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -7787,6 +7773,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
@@ -7803,6 +7790,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
 					mutex_unlock(&devlink->lock);
+					mutex_unlock(&devlink->cmd_mutex);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -7811,14 +7799,13 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			mutex_unlock(&port->reporters_lock);
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry_port:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -8351,7 +8338,6 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -8361,6 +8347,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < start) {
@@ -8374,20 +8361,20 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 						   NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -8582,7 +8569,6 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -8592,6 +8578,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
@@ -8606,20 +8593,20 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 							 NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -8900,7 +8887,6 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -8910,6 +8896,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
+		mutex_lock(&devlink->cmd_mutex);
 		mutex_lock(&devlink->lock);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
@@ -8924,20 +8911,20 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 							   NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->cmd_mutex);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
 		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->cmd_mutex);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -9555,6 +9542,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	INIT_LIST_HEAD(&devlink->trap_group_list);
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
 	mutex_init(&devlink->lock);
+	mutex_init(&devlink->cmd_mutex);
 	mutex_init(&devlink->reporters_lock);
 	mutex_init(&devlink->linecards_lock);
 	refcount_set(&devlink->refcount, 1);
@@ -9696,6 +9684,7 @@ void devlink_free(struct devlink *devlink)
 
 	mutex_destroy(&devlink->linecards_lock);
 	mutex_destroy(&devlink->reporters_lock);
+	mutex_destroy(&devlink->cmd_mutex);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -12190,7 +12179,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	/* In case network namespace is getting destroyed, reload
 	 * all devlink instances from this namespace into init_net.
 	 */
-	mutex_lock(&devlink_mutex);
 	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
@@ -12201,10 +12189,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			goto retry;
 
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
+		mutex_lock(&devlink->cmd_mutex);
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
 				     &actions_performed, NULL);
+		mutex_unlock(&devlink->cmd_mutex);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 retry:
@@ -12212,7 +12202,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-	mutex_unlock(&devlink_mutex);
 }
 
 static struct pernet_operations devlink_pernet_ops __net_initdata = {
-- 
2.35.3

