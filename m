Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92D8584C6C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiG2HKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiG2HKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:10:47 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B882C52DE9
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id l23so6977088ejr.5
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BLQvNIHohDUPYHm+QVUykFu9Zv9WKcTmadeEsTSqF3Y=;
        b=tivanmdJtYCVsoNxlAinzmltxU3F0T9lZcjIUXKFtaiBuQdSqnZgtnqG2P+Reu/Yis
         4pUzp7RLVgN0eHnfrbr2I4kRArPsM3ibCL7ldnCY7JEIoGhauJsITAbSS1ZM9jdwEu6h
         UwxUy3EVDo+m/5cjk7cwjfWJ8JUpeN963CS+JyWrP9SKo+DWRAAzHRKwEUH1JjEhHkTg
         BizroevMtcIyOg+mieiLb9W3hXUQYE9VbMcUCxLQKTHnqUeIY77kd8MHz2rJbhyhFV2w
         LEyoewmBjX5KPclLij9J8BSjwnVwd7jqaNfRLEVEpqxlsyF7bJfhdeKfmrkzmkPJdwUE
         Z2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BLQvNIHohDUPYHm+QVUykFu9Zv9WKcTmadeEsTSqF3Y=;
        b=ec2hBfRd2LsX6RVR59a3u/DeC00pjlXYKP21YjMCXJ4AUilUmLD8Id081fJ15EUl/Z
         Wo6OXOlkcafd5tEKPfCjh6nTp13ix9Ljg/GKui0xl48X07QXBChqzxS+t8WCw4mZLeDu
         JOiQCSZY6B+UNlr0TANBOH+VZ3fHwmbrKGq9GeZDgkqzRoHUgP9HUH698M0mMUvVlH/p
         5ZaaFhKjbOzmmys7jfQHbAv316JLpdxauUR7Uf7oLxYRQQQ7mXQMvXrKhXR3DLXuXX8n
         IsLrjg9x2/Tx/b8Ei001Ko9l7jhwQq1FYOo9CF18JxXioOPQ3pD8E1xYxWqJREiMmi6B
         XbPw==
X-Gm-Message-State: AJIora+AxJGtjWo9iRLpvNcpSt6Z8qnBggY6p2RRF+GXsCGtBRfM2xab
        7UzsEReVu/cU2A/4MRPA8gKHi8ELXtv5gMVf
X-Google-Smtp-Source: AGRyM1vWgmDdfCDFgUZJ3qDCKSjy1lrM39aHUZcc6Qd0RL1r6LD2H0o825t4sGeEcrKd3fXZ696kaw==
X-Received: by 2002:a17:906:cc52:b0:72b:114e:c56c with SMTP id mm18-20020a170906cc5200b0072b114ec56cmr1949903ejb.144.1659078644181;
        Fri, 29 Jul 2022 00:10:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bm4-20020a0564020b0400b0043ac761db43sm1859888edb.55.2022.07.29.00.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:10:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: [patch net-next 3/4] net: devlink: remove devlink_mutex
Date:   Fri, 29 Jul 2022 09:10:37 +0200
Message-Id: <20220729071038.983101-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220729071038.983101-1-jiri@resnulli.us>
References: <20220729071038.983101-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

All accesses to devlink structure from userspace and drivers are locked
with devlink->lock instance mutex. Also, devlinks xa_array iteration is
taken care of by iteration helpers taking devlink reference.

Therefore, remove devlink_mutex as it is no longer needed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 80 +++-------------------------------------------
 1 file changed, 4 insertions(+), 76 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 57865b231364..06cd7c1a1f0a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -225,12 +225,6 @@ static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
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
@@ -776,12 +770,9 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	struct devlink *devlink;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(genl_info_net(info), info->attrs);
-	if (IS_ERR(devlink)) {
-		mutex_unlock(&devlink_mutex);
+	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
-	}
 	devl_lock(devlink);
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
@@ -826,7 +817,6 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 unlock:
 	devl_unlock(devlink);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -843,7 +833,6 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 	}
 	devl_unlock(devlink);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 
 static struct genl_family devlink_nl_family;
@@ -1408,7 +1397,6 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
@@ -1433,7 +1421,6 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -1504,7 +1491,6 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (idx < start) {
 			idx++;
@@ -1521,8 +1507,6 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 		idx++;
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -1559,7 +1543,6 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
@@ -1583,8 +1566,6 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -2238,7 +2219,6 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		mutex_lock(&devlink->linecards_lock);
 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
@@ -2265,8 +2245,6 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -2503,7 +2481,6 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
@@ -2527,8 +2504,6 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -2648,7 +2623,6 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (!devlink->ops->sb_pool_get)
 			goto retry;
@@ -2672,8 +2646,6 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -2865,7 +2837,6 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (!devlink->ops->sb_port_pool_get)
 			goto retry;
@@ -2889,8 +2860,6 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -3110,7 +3079,6 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (!devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
@@ -3135,8 +3103,6 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -4908,7 +4874,6 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (idx < start || !devlink->ops->selftest_check)
 			goto inc;
@@ -4927,7 +4892,6 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
 		idx++;
 		devlink_put(devlink);
 	}
-	mutex_unlock(&devlink_mutex);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -5393,7 +5357,6 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
@@ -5419,8 +5382,6 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -5621,7 +5582,6 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
@@ -5652,8 +5612,6 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	if (err != -EMSGSIZE)
 		return err;
 
@@ -6208,7 +6166,6 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, start);
@@ -6217,7 +6174,6 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 			goto out;
 	}
 out:
-	mutex_unlock(&devlink_mutex);
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -6483,12 +6439,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	start_offset = *((u64 *)&cb->args[0]);
 
-	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
-	if (IS_ERR(devlink)) {
-		err = PTR_ERR(devlink);
-		goto out_dev;
-	}
+	if (IS_ERR(devlink))
+		return PTR_ERR(devlink);
 
 	devl_lock(devlink);
 
@@ -6588,8 +6541,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	genlmsg_end(skb, hdr);
 	devl_unlock(devlink);
 	devlink_put(devlink);
-	mutex_unlock(&devlink_mutex);
-
 	return skb->len;
 
 nla_put_failure:
@@ -6597,8 +6548,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 out_unlock:
 	devl_unlock(devlink);
 	devlink_put(devlink);
-out_dev:
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -6747,7 +6696,6 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err = 0;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (idx < start || !devlink->ops->info_get)
 			goto inc;
@@ -6768,7 +6716,6 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		idx++;
 		devlink_put(devlink);
 	}
-	mutex_unlock(&devlink_mutex);
 
 	if (err != -EMSGSIZE)
 		return err;
@@ -7847,18 +7794,13 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
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
@@ -7924,7 +7866,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		mutex_lock(&devlink->reporters_lock);
 		list_for_each_entry(reporter, &devlink->reporter_list,
@@ -7976,8 +7917,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -8510,7 +8449,6 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
@@ -8534,8 +8472,6 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -8730,7 +8666,6 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
@@ -8755,8 +8690,6 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -9037,7 +8970,6 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
@@ -9062,8 +8994,6 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	mutex_unlock(&devlink_mutex);
-
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -12494,7 +12424,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	/* In case network namespace is getting destroyed, reload
 	 * all devlink instances from this namespace into init_net.
 	 */
-	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		mutex_lock(&devlink->lock);
@@ -12507,7 +12436,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 		devlink_put(devlink);
 	}
-	mutex_unlock(&devlink_mutex);
 }
 
 static struct pernet_operations devlink_pernet_ops __net_initdata = {
-- 
2.35.3

