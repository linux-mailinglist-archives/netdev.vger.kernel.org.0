Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8756257173F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiGLKYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiGLKYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:24:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB585ADD6A
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:31 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id h23so13451894ejj.12
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TPK6lhZugreZKhG0ettpMU95Nsl7aiO1Zmz22yJ1oQE=;
        b=Nldjo7Rud14XxAJ6PaWF1RZSM92Rty4m5SlsPEgM2nM4Z1vIyzJI3pKKnSrWpX8x2/
         22AaYnuFFEwlPiWeMPC95faS/KOy4gNSWcR8pH9o90V8vAanlg6NYZhbE9Wb4yn3rXqB
         SpjPjNNHU51Mn1m73DMt22O6b6jPVfVJjowIcuoLGpPasHdMBACv/IhY9XrzCMXyZ5e+
         B3we+z0CTa4fPzSdG+UjW/VoPXuMnqsW+YpOVlK43fhyyDEeLakwuwDW6fjOt+YDk51O
         nb1Qq7GxmHilT5GIkAapIsv5wsjEHnjDeJULzN9bBr+zeYHCPQFc0sviAFZzIRRXiMvL
         8bVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPK6lhZugreZKhG0ettpMU95Nsl7aiO1Zmz22yJ1oQE=;
        b=b9c+wUlxQOkoIC5PVlXxmNDXn5t4Npj163Jlq/fVC42VU9hLNGRMmvVwr4CygcV1z9
         ntQaen1fednRA+3Ev5vdRaZ+L12RMMQUzUUc51q512yF9yoqJVSbr5YOWrF+Mg1dsDrM
         QKmRAyNL/lE8jE1Jn/Kc8yKe43kUdxSonSPcXeQD5pAxStOgWtv/+UDNz2sPNot8NZk5
         fnr4D+m+6mHNLQBniOXKMFT6A44+eKpIlu7fqsUo4V6sDxDZFyXhIraic3p3P6Hchkpr
         mThmMDBV6tjHF2RaK0/tKdTK2IL7CzlnhDvbRiH20YFsDQ9GlD7fax7l0jzl6H6DUs8Q
         O/ew==
X-Gm-Message-State: AJIora/kfyGOsnYVaVQ8EayyzlDEVSdICkuwhQnIuJWNJvZLWFLdW19T
        mOG33v/sPgg8OCCg4Dp7/tG1aTMbDRb/weLOReU=
X-Google-Smtp-Source: AGRyM1sc87BGn8KCoMMHpZV/LiwmOFncDFDReczZYFHcWH9iRWUF1O4mxWSaPCC2+6pLao528dHr2A==
X-Received: by 2002:a17:906:8443:b0:72b:67a6:a42f with SMTP id e3-20020a170906844300b0072b67a6a42fmr6814430ejy.309.1657621470029;
        Tue, 12 Jul 2022 03:24:30 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id lc25-20020a170906f91900b006ff802baf5dsm3672461ejb.54.2022.07.12.03.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:24:29 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v4 2/3] net: devlink: use helpers to work with devlink->lock mutex
Date:   Tue, 12 Jul 2022 12:24:23 +0200
Message-Id: <20220712102424.2774011-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712102424.2774011-1-jiri@resnulli.us>
References: <20220712102424.2774011-1-jiri@resnulli.us>
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
v3->v4:
- rebased on top of Mosche's patchset (trivial)
v2->v3:
- new patch
---
 net/core/devlink.c | 230 ++++++++++++++++++++++-----------------------
 1 file changed, 115 insertions(+), 115 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8cef65a6934d..2b2e454ebd78 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -711,7 +711,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 		return PTR_ERR(devlink);
 	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
@@ -754,7 +754,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 
 unlock:
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 	return err;
@@ -772,7 +772,7 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 		devlink_linecard_put(linecard);
 	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 }
@@ -1329,7 +1329,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
 			u32 id = NETLINK_CB(cb->skb).portid;
@@ -1342,13 +1342,13 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -1495,7 +1495,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			if (idx < start) {
 				idx++;
@@ -1507,13 +1507,13 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -2450,7 +2450,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < start) {
 				idx++;
@@ -2462,13 +2462,13 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -2603,7 +2603,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_pool_get_dumpit(msg, start, &idx, devlink,
 						   devlink_sb,
@@ -2612,12 +2612,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -2824,7 +2824,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_port_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_port_pool_get_dumpit(msg, start, &idx,
 							devlink, devlink_sb,
@@ -2833,12 +2833,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -3073,7 +3073,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_tc_pool_bind_get_dumpit(msg, start, &idx,
 							   devlink,
@@ -3083,12 +3083,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -5159,7 +5159,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
 			if (idx < start) {
 				idx++;
@@ -5173,13 +5173,13 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -5394,7 +5394,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
 					    &devlink_port->param_list, list) {
@@ -5412,14 +5412,14 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -5671,7 +5671,7 @@ static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
@@ -5707,7 +5707,7 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
@@ -5746,7 +5746,7 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
  */
 static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	if (xa_load(&devlink->snapshot_ids, id))
 		return -EEXIST;
@@ -5773,7 +5773,7 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
@@ -5801,7 +5801,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink_snapshot *snapshot;
 	int err;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
@@ -5839,7 +5839,7 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
@@ -5933,7 +5933,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	struct devlink_port *port;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	list_for_each_entry(region, &devlink->region_list, list) {
 		if (*idx < start) {
 			(*idx)++;
@@ -5957,7 +5957,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	}
 
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 
@@ -6247,7 +6247,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_dev;
 	}
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
 	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
@@ -6343,7 +6343,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	nla_nest_end(skb, chunks_attr);
 	genlmsg_end(skb, hdr);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 
@@ -6352,7 +6352,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 nla_put_failure:
 	genlmsg_cancel(skb, hdr);
 out_unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 out_dev:
 	mutex_unlock(&devlink_mutex);
@@ -6515,12 +6515,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
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
@@ -7722,7 +7722,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
@@ -7737,7 +7737,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
-					mutex_unlock(&devlink->lock);
+					devl_unlock(devlink);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -7745,7 +7745,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			mutex_unlock(&port->reporters_lock);
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry_port:
 		devlink_put(devlink);
 	}
@@ -8292,7 +8292,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < start) {
 				idx++;
@@ -8304,13 +8304,13 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -8519,7 +8519,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
 			if (idx < start) {
@@ -8532,13 +8532,13 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -8833,7 +8833,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
 			if (idx < start) {
@@ -8846,13 +8846,13 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
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
 	}
@@ -9690,7 +9690,7 @@ int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	if (devlink_port_index_exists(devlink, port_index))
 		return -EEXIST;
@@ -9733,9 +9733,9 @@ int devlink_port_register(struct devlink *devlink,
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
@@ -9769,9 +9769,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devl_port_unregister(devlink_port);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
@@ -10380,7 +10380,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	struct devlink_sb *devlink_sb;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	if (devlink_sb_index_exists(devlink, sb_index)) {
 		err = -EEXIST;
 		goto unlock;
@@ -10399,7 +10399,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	devlink_sb->egress_tc_count = egress_tc_count;
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
@@ -10408,11 +10408,11 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
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
@@ -10428,9 +10428,9 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
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
@@ -10444,9 +10444,9 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
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
 
@@ -10501,7 +10501,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name,
 				     devlink)) {
@@ -10522,7 +10522,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
@@ -10538,17 +10538,17 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
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
 
@@ -10580,7 +10580,7 @@ int devlink_resource_register(struct devlink *devlink,
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (resource) {
 		err = -EINVAL;
@@ -10620,7 +10620,7 @@ int devlink_resource_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_register);
@@ -10647,7 +10647,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 {
 	struct devlink_resource *tmp, *child_resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
 				 list) {
@@ -10656,7 +10656,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 		kfree(child_resource);
 	}
 
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
@@ -10674,7 +10674,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	struct devlink_resource *resource;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (!resource) {
 		err = -EINVAL;
@@ -10683,7 +10683,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	*p_resource_size = resource->size_new;
 	resource->size = resource->size_new;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_size_get);
@@ -10703,7 +10703,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	struct devlink_dpipe_table *table;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table) {
@@ -10714,7 +10714,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	table->resource_units = resource_units;
 	table->resource_valid = true;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
@@ -10734,7 +10734,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10743,7 +10743,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 	resource->occ_get = occ_get;
 	resource->occ_get_priv = occ_get_priv;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
 
@@ -10758,7 +10758,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10767,7 +10767,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 	resource->occ_get = NULL;
 	resource->occ_get_priv = NULL;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
 
@@ -11006,7 +11006,7 @@ devlink_region_create(struct devlink *devlink,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_region_get_by_name(devlink, ops->name)) {
 		err = -EEXIST;
@@ -11027,11 +11027,11 @@ devlink_region_create(struct devlink *devlink,
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
@@ -11056,7 +11056,7 @@ devlink_port_region_create(struct devlink_port *port,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_port_region_get_by_name(port, ops->name)) {
 		err = -EEXIST;
@@ -11078,11 +11078,11 @@ devlink_port_region_create(struct devlink_port *port,
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
@@ -11097,7 +11097,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -11106,7 +11106,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	kfree(region);
 }
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
@@ -11130,9 +11130,9 @@ int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	int err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	err = __devlink_region_snapshot_id_get(devlink, id);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return err;
 }
@@ -11150,9 +11150,9 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
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
 
@@ -11174,9 +11174,9 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink *devlink = region->devlink;
 	int err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	err = __devlink_region_snapshot_create(region, data, snapshot_id);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return err;
 }
@@ -11559,7 +11559,7 @@ int devlink_traps_register(struct devlink *devlink,
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -11571,7 +11571,7 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -11579,7 +11579,7 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_traps_register);
@@ -11596,7 +11596,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -11605,7 +11605,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
 
@@ -11777,7 +11777,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11789,7 +11789,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -11797,7 +11797,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
@@ -11814,10 +11814,10 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
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
 
@@ -11917,7 +11917,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -11932,7 +11932,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -11940,7 +11940,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
@@ -11958,10 +11958,10 @@ devlink_trap_policers_unregister(struct devlink *devlink,
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
 
@@ -12015,9 +12015,9 @@ void devlink_compat_running_version(struct devlink *devlink,
 	if (!devlink->ops->info_get)
 		return;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	__devlink_compat_running_version(devlink, buf, len);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 
 int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
@@ -12032,11 +12032,11 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
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

