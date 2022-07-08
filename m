Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01CC56B3D0
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237239AbiGHHux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiGHHur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:50:47 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5537D1FF
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:50:45 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id o25so36371145ejm.3
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 00:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wE1g86J/x0esBkTpoW2YF4YzJHzhJ8SqKdJnfd5Hv+A=;
        b=JZAr75DwhPM7Z8aK52PM8imChKTvRWWBw9V6MpYyyxEotF54ghJMiaDv+ocdC3olB2
         AEZ+BoOHEinh16FEMUG81/4Xy38M3c/OABNF8NSQymaMj3egyTKsEWzWmramAvcb9c2G
         /rN4gVbBMbQXBfuazmmEeY1XBg5Alu0174oZowxk22RMpuf/kXeQvCTE2UJatv2HCBQ7
         W4DBKpmewtIIANDjAiHwOJ9u9RL5nNHk2d/wTHrtmViU8rmzEfXGACKqjp4lyU8b2jio
         mAXiElIP5P53cB4V+cP5dPHMrhgyZmzSz91Q5Wnj0+dJtYy8MXazDKAAU6VYCeuW3b9N
         o8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wE1g86J/x0esBkTpoW2YF4YzJHzhJ8SqKdJnfd5Hv+A=;
        b=sGDrg79IzckYKoVL1WUPAF/pI/O1pjm9Sh4jNt1meiYKBNq0/xWtfSTuMeF7ODqgiq
         PZT8b8HlZqBOaphpqfO+aVPYV+u4KtH54doA9Jg/8YAAaphQIMnSxmDG9N85CbGw9tYN
         486yCFRiqMlUmr3QY8V0tWwkPukgYj8hHkXEWLY7yXANpQ3CVQQPI49qFAdX+pzOAZ8Q
         i6Yq9/7NwodWwGqF4+gWZ7HBuzikGSsBROUqJHB/gsjFOKUlGKPWIJawIcsbCQN1CyWC
         4kRwBgJ5xP97euZULnnW7uU0Fm9/0F7z7C1nhH4DpXtOmfmvi9lgSv9yrgTqsxld2GHH
         FsBA==
X-Gm-Message-State: AJIora/CLsbj8gBMvRxUbpOeMbJzq0Ej5+WrDXOVJ1sDM66j2RKDDJ0o
        7gpPoMBZmtR8wTd8AlZbQeTy58SZsaeTe4kwMCg=
X-Google-Smtp-Source: AGRyM1s/nhCd/BGi99Rv+1t7yMcoLdk/mdyp6oYsCF7KQWlBr1vv/xwVgYBZazNziYx9MasZx/WJ3w==
X-Received: by 2002:a17:906:6146:b0:722:f8c4:ec9b with SMTP id p6-20020a170906614600b00722f8c4ec9bmr2335088ejl.708.1657266643390;
        Fri, 08 Jul 2022 00:50:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l3-20020a170906078300b006feba31171bsm20183946ejc.11.2022.07.08.00.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 00:50:42 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3 2/3] net: devlink: use helpers to work with devlink->lock mutex
Date:   Fri,  8 Jul 2022 09:50:37 +0200
Message-Id: <20220708075038.2191948-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220708075038.2191948-1-jiri@resnulli.us>
References: <20220708074808.2191479-1-jiri@resnulli.us>
 <20220708075038.2191948-1-jiri@resnulli.us>
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

As far as the lock helpers exist as the drivers need to work with the
devlink->lock mutex, use the helpers internally in devlink.c in order to
be consistent.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- new patch
---
 net/core/devlink.c | 248 ++++++++++++++++++++++-----------------------
 1 file changed, 124 insertions(+), 124 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 46cd67b0ed6c..983acb2916e4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -724,7 +724,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 		return PTR_ERR(devlink);
 	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
@@ -767,7 +767,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 
 unlock:
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 	return err;
@@ -785,7 +785,7 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 		devlink_linecard_put(linecard);
 	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 }
@@ -1362,7 +1362,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
 			u32 id = NETLINK_CB(cb->skb).portid;
@@ -1375,13 +1375,13 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI, NULL);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -1535,7 +1535,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			if (idx < start) {
 				idx++;
@@ -1547,13 +1547,13 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI, cb->extack);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -1754,7 +1754,7 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 	if (!msg)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devlink_port = devlink_port_get_by_index(devlink, port_index);
 	if (!devlink_port) {
 		err = -ENODEV;
@@ -1767,11 +1767,11 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 		goto out;
 
 	err = genlmsg_reply(msg, info);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	nlmsg_free(msg);
 	return err;
 }
@@ -2504,7 +2504,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < start) {
 				idx++;
@@ -2516,13 +2516,13 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 						 cb->nlh->nlmsg_seq,
 						 NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -2661,7 +2661,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_pool_get_dumpit(msg, start, &idx, devlink,
 						   devlink_sb,
@@ -2670,12 +2670,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 			if (err == -EOPNOTSUPP) {
 				err = 0;
 			} else if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -2886,7 +2886,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_port_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_port_pool_get_dumpit(msg, start, &idx,
 							devlink, devlink_sb,
@@ -2895,12 +2895,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 			if (err == -EOPNOTSUPP) {
 				err = 0;
 			} else if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -3139,7 +3139,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_tc_pool_bind_get_dumpit(msg, start, &idx,
 							   devlink,
@@ -3149,12 +3149,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 			if (err == -EOPNOTSUPP) {
 				err = 0;
 			} else if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -5292,7 +5292,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
 			if (idx < start) {
 				idx++;
@@ -5306,13 +5306,13 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 			if (err == -EOPNOTSUPP) {
 				err = 0;
 			} else if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -5531,7 +5531,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
 					    &devlink_port->param_list, list) {
@@ -5549,14 +5549,14 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 				if (err == -EOPNOTSUPP) {
 					err = 0;
 				} else if (err) {
-					mutex_unlock(&devlink->lock);
+					devl_unlock(devlink);
 					devlink_put(devlink);
 					goto out;
 				}
 				idx++;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -5810,7 +5810,7 @@ static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
@@ -5846,7 +5846,7 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
@@ -5885,7 +5885,7 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
  */
 static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	if (xa_load(&devlink->snapshot_ids, id))
 		return -EEXIST;
@@ -5912,7 +5912,7 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
@@ -5940,7 +5940,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink_snapshot *snapshot;
 	int err;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
@@ -5978,7 +5978,7 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
@@ -6072,7 +6072,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	struct devlink_port *port;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	list_for_each_entry(region, &devlink->region_list, list) {
 		if (*idx < start) {
 			(*idx)++;
@@ -6096,7 +6096,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	}
 
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 
@@ -6390,7 +6390,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_dev;
 	}
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
 	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
@@ -6486,7 +6486,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	nla_nest_end(skb, chunks_attr);
 	genlmsg_end(skb, hdr);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 
@@ -6495,7 +6495,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 nla_put_failure:
 	genlmsg_cancel(skb, hdr);
 out_unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 out_dev:
 	mutex_unlock(&devlink_mutex);
@@ -6700,12 +6700,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		if (idx < start || !devlink->ops->info_get)
 			goto inc;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					   cb->extack);
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 		if (err == -EOPNOTSUPP)
 			err = 0;
 		else if (err) {
@@ -7913,7 +7913,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
@@ -7928,7 +7928,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
-					mutex_unlock(&devlink->lock);
+					devl_unlock(devlink);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -7936,7 +7936,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			mutex_unlock(&port->reporters_lock);
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry_port:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -8487,7 +8487,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < start) {
 				idx++;
@@ -8499,13 +8499,13 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -8718,7 +8718,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
 			if (idx < start) {
@@ -8731,13 +8731,13 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 							 cb->nlh->nlmsg_seq,
 							 NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -9036,7 +9036,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
 			if (idx < start) {
@@ -9049,13 +9049,13 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 							   cb->nlh->nlmsg_seq,
 							   NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
 		rcu_read_lock();
@@ -9894,7 +9894,7 @@ int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	if (devlink_port_index_exists(devlink, port_index))
 		return -EEXIST;
@@ -9937,9 +9937,9 @@ int devlink_port_register(struct devlink *devlink,
 {
 	int err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	err = devl_port_register(devlink, devlink_port, port_index);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
@@ -9973,9 +9973,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devl_port_unregister(devlink_port);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
@@ -10243,9 +10243,9 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	struct devlink *devlink = devlink_port->devlink;
 	int ret;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	ret = devl_rate_leaf_create(devlink_port, priv);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return ret;
 }
@@ -10288,9 +10288,9 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 	if (!devlink_rate)
 		return;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devl_rate_leaf_destroy(devlink_port);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
 
@@ -10343,9 +10343,9 @@ EXPORT_SYMBOL_GPL(devl_rate_nodes_destroy);
  */
 void devlink_rate_nodes_destroy(struct devlink *devlink)
 {
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devl_rate_nodes_destroy(devlink);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
 
@@ -10663,7 +10663,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	struct devlink_sb *devlink_sb;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	if (devlink_sb_index_exists(devlink, sb_index)) {
 		err = -EEXIST;
 		goto unlock;
@@ -10682,7 +10682,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	devlink_sb->egress_tc_count = egress_tc_count;
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
@@ -10691,11 +10691,11 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 {
 	struct devlink_sb *devlink_sb;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
 	list_del(&devlink_sb->list);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	kfree(devlink_sb);
 }
 EXPORT_SYMBOL_GPL(devlink_sb_unregister);
@@ -10711,9 +10711,9 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 int devlink_dpipe_headers_register(struct devlink *devlink,
 				   struct devlink_dpipe_headers *dpipe_headers)
 {
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devlink->dpipe_headers = dpipe_headers;
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
@@ -10727,9 +10727,9 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
  */
 void devlink_dpipe_headers_unregister(struct devlink *devlink)
 {
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devlink->dpipe_headers = NULL;
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_unregister);
 
@@ -10784,7 +10784,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name,
 				     devlink)) {
@@ -10805,7 +10805,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
@@ -10821,17 +10821,17 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 {
 	struct devlink_dpipe_table *table;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table)
 		goto unlock;
 	list_del_rcu(&table->list);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	kfree_rcu(table, rcu);
 	return;
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
 
@@ -10863,7 +10863,7 @@ int devlink_resource_register(struct devlink *devlink,
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (resource) {
 		err = -EINVAL;
@@ -10903,7 +10903,7 @@ int devlink_resource_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_register);
@@ -10930,7 +10930,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 {
 	struct devlink_resource *tmp, *child_resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
 				 list) {
@@ -10939,7 +10939,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 		kfree(child_resource);
 	}
 
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
@@ -10957,7 +10957,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	struct devlink_resource *resource;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (!resource) {
 		err = -EINVAL;
@@ -10966,7 +10966,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	*p_resource_size = resource->size_new;
 	resource->size = resource->size_new;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_size_get);
@@ -10986,7 +10986,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	struct devlink_dpipe_table *table;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table) {
@@ -10997,7 +10997,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	table->resource_units = resource_units;
 	table->resource_valid = true;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
@@ -11017,7 +11017,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -11026,7 +11026,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 	resource->occ_get = occ_get;
 	resource->occ_get_priv = occ_get_priv;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
 
@@ -11041,7 +11041,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -11050,7 +11050,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 	resource->occ_get = NULL;
 	resource->occ_get_priv = NULL;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
 
@@ -11289,7 +11289,7 @@ devlink_region_create(struct devlink *devlink,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_region_get_by_name(devlink, ops->name)) {
 		err = -EEXIST;
@@ -11310,11 +11310,11 @@ devlink_region_create(struct devlink *devlink,
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return region;
 
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(devlink_region_create);
@@ -11339,7 +11339,7 @@ devlink_port_region_create(struct devlink_port *port,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_port_region_get_by_name(port, ops->name)) {
 		err = -EEXIST;
@@ -11361,11 +11361,11 @@ devlink_port_region_create(struct devlink_port *port,
 	list_add_tail(&region->list, &port->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return region;
 
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(devlink_port_region_create);
@@ -11380,7 +11380,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -11389,7 +11389,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	kfree(region);
 }
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
@@ -11413,9 +11413,9 @@ int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	int err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	err = __devlink_region_snapshot_id_get(devlink, id);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return err;
 }
@@ -11433,9 +11433,9 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
  */
 void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id)
 {
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	__devlink_snapshot_id_decrement(devlink, id);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_put);
 
@@ -11457,9 +11457,9 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink *devlink = region->devlink;
 	int err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	err = __devlink_region_snapshot_create(region, data, snapshot_id);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return err;
 }
@@ -11842,7 +11842,7 @@ int devlink_traps_register(struct devlink *devlink,
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -11854,7 +11854,7 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -11862,7 +11862,7 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_traps_register);
@@ -11879,7 +11879,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -11888,7 +11888,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
 
@@ -12060,7 +12060,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -12072,7 +12072,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -12080,7 +12080,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
@@ -12097,10 +12097,10 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = groups_count - 1; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
 
@@ -12200,7 +12200,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -12215,7 +12215,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -12223,7 +12223,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
@@ -12241,10 +12241,10 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = policers_count - 1; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
 
@@ -12298,9 +12298,9 @@ void devlink_compat_running_version(struct devlink *devlink,
 	if (!devlink->ops->info_get)
 		return;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	__devlink_compat_running_version(devlink, buf, len);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 
 int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
@@ -12315,11 +12315,11 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 	if (ret)
 		return ret;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devlink_flash_update_begin_notify(devlink);
 	ret = devlink->ops->flash_update(devlink, &params, NULL);
 	devlink_flash_update_end_notify(devlink);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	release_firmware(params.fw);
 
-- 
2.35.3

