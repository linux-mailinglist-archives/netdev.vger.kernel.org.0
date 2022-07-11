Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E8457043D
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiGKN0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiGKN0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:26:17 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180D7326DD
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d16so6981949wrv.10
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5GxyW8w0KbpWO5OoNTsYsUT9e0nqiIAdjthXAlgma0w=;
        b=DRRNv5gLuHYiKyrp8hWh1HFDcY4G6/7/ohsTIyqqDJ7ZyZR4tDYA69g0EyZ4TsSrPB
         6SdfQdvDvhCeEuvxPZjb4wSF6Qusop69RFGFVjRJElDRe+EzqUKjAZtckGDQ1JgnaWf/
         F667hmh5slLziL6SxAJKYM3UOhrMf6qG6HHsX7RxivjQnqtSJIbeThtI9pbS8eo8qU2r
         uRnDTNbx9YIhRtucSdexnUpWZdyO4+aSvlxtoJxdu6No/hD6X7W2HIn101IHRbz4/Bv0
         hq7iyu6D/Dkdi/kXPMHjpd3FtDub7u73UFu5IBbyPULqx0ajaT87D0SqQHmBTCJFwqp1
         EFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5GxyW8w0KbpWO5OoNTsYsUT9e0nqiIAdjthXAlgma0w=;
        b=cqVRIAur87E3tt08cJHWQCJgLNHDpFWCd1+x1Hq9mdAaTVECsPop1YLJEVLAwyk7w4
         YKcSfJ1wQEru8LNKAiqCau1pBHsJtxrrtJbvW3PjuIuJu8cNjXzd+lFDD2M4c8GrnrRD
         7YXP5rLeZiO7ZtW3Xq5RLd25D2TVJp5xHUsv3iIWRAZG73O0Nsz7d7qv0km2Ui6Rt7/e
         OSskPv8edeyraO3Boe8+CkjCflsmNdCqmsi/QYlrHl6jC+D1zq6/V0Iuwt8IRDLDVKqq
         yp4NDxi6dwgTAKsXgveB34oGnlLowcKkIaEgHdw5W6frao2wo5qflnVx7QoXvXtwT+7C
         kHbA==
X-Gm-Message-State: AJIora9CXqrJk3vIkfa6vI8hAPrIWcNA9waeJ1kRXFRqTtGV5qFEm4wp
        X0Buhwfw2kmiVEo8iZhB3K3tRWabPrl74YdFBdY=
X-Google-Smtp-Source: AGRyM1s+3mdJAMyiCFKjRyOfCSsJ4bwpdc6kJR0Jh9digEIGJipl+GwSZWq30lO9YNEc/whx6O5XKQ==
X-Received: by 2002:adf:f946:0:b0:21d:6433:a7bb with SMTP id q6-20020adff946000000b0021d6433a7bbmr17432171wrr.518.1657545972450;
        Mon, 11 Jul 2022 06:26:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w2-20020adfde82000000b00213ba3384aesm5841725wrl.35.2022.07.11.06.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:26:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3/repost 2/3] net: devlink: use helpers to work with devlink->lock mutex
Date:   Mon, 11 Jul 2022 15:26:06 +0200
Message-Id: <20220711132607.2654337-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220711132607.2654337-1-jiri@resnulli.us>
References: <20220711132607.2654337-1-jiri@resnulli.us>
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
v2->v3:
- new patch
---
 net/core/devlink.c | 248 ++++++++++++++++++++++-----------------------
 1 file changed, 124 insertions(+), 124 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0bb9b1f497c7..09a6f4fbedd5 100644
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
@@ -1712,7 +1712,7 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 	if (!msg)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devlink_port = devlink_port_get_by_index(devlink, port_index);
 	if (!devlink_port) {
 		err = -ENODEV;
@@ -1725,11 +1725,11 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
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
@@ -2452,7 +2452,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < start) {
 				idx++;
@@ -2464,13 +2464,13 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
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
@@ -2605,7 +2605,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_pool_get_dumpit(msg, start, &idx, devlink,
 						   devlink_sb,
@@ -2614,12 +2614,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
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
@@ -2826,7 +2826,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_port_pool_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_port_pool_get_dumpit(msg, start, &idx,
 							devlink, devlink_sb,
@@ -2835,12 +2835,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
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
@@ -3075,7 +3075,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		    !devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			err = __sb_tc_pool_bind_get_dumpit(msg, start, &idx,
 							   devlink,
@@ -3085,12 +3085,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
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
@@ -5161,7 +5161,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
 			if (idx < start) {
 				idx++;
@@ -5175,13 +5175,13 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
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
@@ -5396,7 +5396,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
 					    &devlink_port->param_list, list) {
@@ -5414,14 +5414,14 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
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
@@ -5673,7 +5673,7 @@ static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
@@ -5709,7 +5709,7 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
@@ -5748,7 +5748,7 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
  */
 static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	if (xa_load(&devlink->snapshot_ids, id))
 		return -EEXIST;
@@ -5775,7 +5775,7 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
@@ -5803,7 +5803,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink_snapshot *snapshot;
 	int err;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
@@ -5841,7 +5841,7 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
@@ -5935,7 +5935,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	struct devlink_port *port;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	list_for_each_entry(region, &devlink->region_list, list) {
 		if (*idx < start) {
 			(*idx)++;
@@ -5959,7 +5959,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	}
 
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 
@@ -6249,7 +6249,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_dev;
 	}
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
 	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
@@ -6345,7 +6345,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	nla_nest_end(skb, chunks_attr);
 	genlmsg_end(skb, hdr);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 
@@ -6354,7 +6354,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 nla_put_failure:
 	genlmsg_cancel(skb, hdr);
 out_unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 out_dev:
 	mutex_unlock(&devlink_mutex);
@@ -6517,12 +6517,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
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
@@ -7724,7 +7724,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
@@ -7739,7 +7739,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
-					mutex_unlock(&devlink->lock);
+					devl_unlock(devlink);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -7747,7 +7747,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			mutex_unlock(&port->reporters_lock);
 		}
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
 retry_port:
 		devlink_put(devlink);
 	}
@@ -8294,7 +8294,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < start) {
 				idx++;
@@ -8306,13 +8306,13 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
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
@@ -8521,7 +8521,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
 			if (idx < start) {
@@ -8534,13 +8534,13 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
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
@@ -8835,7 +8835,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
 			if (idx < start) {
@@ -8848,13 +8848,13 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
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
@@ -9694,7 +9694,7 @@ int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
 {
-	lockdep_assert_held(&devlink->lock);
+	devl_assert_locked(devlink);
 
 	if (devlink_port_index_exists(devlink, port_index))
 		return -EEXIST;
@@ -9737,9 +9737,9 @@ int devlink_port_register(struct devlink *devlink,
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
@@ -9773,9 +9773,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devl_port_unregister(devlink_port);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
@@ -10043,9 +10043,9 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	struct devlink *devlink = devlink_port->devlink;
 	int ret;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	ret = devl_rate_leaf_create(devlink_port, priv);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return ret;
 }
@@ -10088,9 +10088,9 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 	if (!devlink_rate)
 		return;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	devl_rate_leaf_destroy(devlink_port);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
 
@@ -10143,9 +10143,9 @@ EXPORT_SYMBOL_GPL(devl_rate_nodes_destroy);
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
 
@@ -10444,7 +10444,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	struct devlink_sb *devlink_sb;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	if (devlink_sb_index_exists(devlink, sb_index)) {
 		err = -EEXIST;
 		goto unlock;
@@ -10463,7 +10463,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	devlink_sb->egress_tc_count = egress_tc_count;
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
@@ -10472,11 +10472,11 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
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
@@ -10492,9 +10492,9 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
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
@@ -10508,9 +10508,9 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
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
 
@@ -10565,7 +10565,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name,
 				     devlink)) {
@@ -10586,7 +10586,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
@@ -10602,17 +10602,17 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
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
 
@@ -10644,7 +10644,7 @@ int devlink_resource_register(struct devlink *devlink,
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (resource) {
 		err = -EINVAL;
@@ -10684,7 +10684,7 @@ int devlink_resource_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_register);
@@ -10711,7 +10711,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 {
 	struct devlink_resource *tmp, *child_resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
 				 list) {
@@ -10720,7 +10720,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 		kfree(child_resource);
 	}
 
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
@@ -10738,7 +10738,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	struct devlink_resource *resource;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (!resource) {
 		err = -EINVAL;
@@ -10747,7 +10747,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	*p_resource_size = resource->size_new;
 	resource->size = resource->size_new;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_size_get);
@@ -10767,7 +10767,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	struct devlink_dpipe_table *table;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table) {
@@ -10778,7 +10778,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	table->resource_units = resource_units;
 	table->resource_valid = true;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
@@ -10798,7 +10798,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10807,7 +10807,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 	resource->occ_get = occ_get;
 	resource->occ_get_priv = occ_get_priv;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
 
@@ -10822,7 +10822,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10831,7 +10831,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 	resource->occ_get = NULL;
 	resource->occ_get_priv = NULL;
 out:
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
 
@@ -11070,7 +11070,7 @@ devlink_region_create(struct devlink *devlink,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_region_get_by_name(devlink, ops->name)) {
 		err = -EEXIST;
@@ -11091,11 +11091,11 @@ devlink_region_create(struct devlink *devlink,
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
@@ -11120,7 +11120,7 @@ devlink_port_region_create(struct devlink_port *port,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	if (devlink_port_region_get_by_name(port, ops->name)) {
 		err = -EEXIST;
@@ -11142,11 +11142,11 @@ devlink_port_region_create(struct devlink_port *port,
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
@@ -11161,7 +11161,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -11170,7 +11170,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	kfree(region);
 }
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
@@ -11194,9 +11194,9 @@ int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	int err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	err = __devlink_region_snapshot_id_get(devlink, id);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return err;
 }
@@ -11214,9 +11214,9 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
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
 
@@ -11238,9 +11238,9 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink *devlink = region->devlink;
 	int err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	err = __devlink_region_snapshot_create(region, data, snapshot_id);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return err;
 }
@@ -11623,7 +11623,7 @@ int devlink_traps_register(struct devlink *devlink,
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -11635,7 +11635,7 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -11643,7 +11643,7 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_traps_register);
@@ -11660,7 +11660,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -11669,7 +11669,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
 
@@ -11841,7 +11841,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11853,7 +11853,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -11861,7 +11861,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
@@ -11878,10 +11878,10 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
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
 
@@ -11981,7 +11981,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -11996,7 +11996,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -12004,7 +12004,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
@@ -12022,10 +12022,10 @@ devlink_trap_policers_unregister(struct devlink *devlink,
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
 
@@ -12079,9 +12079,9 @@ void devlink_compat_running_version(struct devlink *devlink,
 	if (!devlink->ops->info_get)
 		return;
 
-	mutex_lock(&devlink->lock);
+	devl_lock(devlink);
 	__devlink_compat_running_version(devlink, buf, len);
-	mutex_unlock(&devlink->lock);
+	devl_unlock(devlink);
 }
 
 int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
@@ -12096,11 +12096,11 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
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

