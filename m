Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459A1665708
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbjAKJMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238480AbjAKJL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E3A15707
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso19300190pjp.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVe7EHPINNyxPaAeiJTdh82G3QazcC6SpxivECfgQo4=;
        b=vpv/DIyhBKQukauy9r0AZ4PU9oKSvnpbwNJa1jymVKPVo54yifkGFvqxPk9wQ+Z0Do
         KFyjLgi0efsSYostMR4FiSXMC8uzfgMOa2CSFMM6QdPRLTE9VRv+up0QnVaZp7ISFE7Z
         QVb/USP2wgHUtmodxXCoK5OgG2j9wx8Ktpt2NoXAr0g+LnUSDViHUGOaQ2fm35ktgRN+
         RF2ms3PVaZqBZUusZYDaWMFUFu/oiFjk08XBWabvf+QbrIptaAqzPVTY5kOXUjn2LRph
         plb6hFRHkF9t14pKQpPjhS2t08SG7sBhr80C0b7sPzXS81PzoDdMUkRsZy1E0GyodTu3
         A/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zVe7EHPINNyxPaAeiJTdh82G3QazcC6SpxivECfgQo4=;
        b=BYr/6Cz0spw5hgcyWpG8OBzEFic7lIONPtW5KW42/nBSSQJJgIgKfOehEFedHLALYc
         LfV9BM3qFf0hz5A0ZIUVps1ECwZjFFZqFjNbtzH/ToJnNJQ/ACppdVrCuR2P5/mqNcrz
         el3toZbhPkHfumOwxuFxnaayQnSwWw9Rf4KslYpdB8yKpC/JKD4letOXO8Flhy/nJtrs
         8WlAP/NusTDeNUqHDdJriuTOigos846rd/TxWZljvrznWhedpexNe6yGt9/Jv6R59WFB
         BMFAVxgs78XXLvVtXRm4sQvTDVksiaI/3a78oKzmrm1DufK0pmakGqwfxYS71h8iyzV4
         YtLg==
X-Gm-Message-State: AFqh2krvFZEIvHKUem4a5IfFVp0OHM/MQWfm1OHW+vovhsTz2UXRbRy8
        NATRmHBZDm4P76IYD8/CpM7Jnmc0ODRfKrmkMc2Asg==
X-Google-Smtp-Source: AMrXdXtIPQcXu745U9cMubMSk0yqoYEsFt/BhtikYojZ4JlHJ7QFwfLqDeE7xwrZkHB2yGHXTuyb+g==
X-Received: by 2002:a17:902:ecc1:b0:192:760f:c35e with SMTP id a1-20020a170902ecc100b00192760fc35emr77348781plh.53.1673428084814;
        Wed, 11 Jan 2023 01:08:04 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id u9-20020a170903124900b001926392adf9sm9555113plh.271.2023.01.11.01.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:08:04 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 04/10] devlink: remove reporters_lock
Date:   Wed, 11 Jan 2023 10:07:42 +0100
Message-Id: <20230111090748.751505-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
References: <20230111090748.751505-1-jiri@resnulli.us>
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

Similar to other devlink objects, rely on devlink instance lock
and remove object specific reporters_lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- split from v2 patch #4 - "devlink: remove reporters_lock", no change
---
 include/net/devlink.h       |  1 -
 net/devlink/core.c          |  2 --
 net/devlink/devl_internal.h |  1 -
 net/devlink/leftover.c      | 53 +++++++------------------------------
 4 files changed, 9 insertions(+), 48 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3e0536f46426..0b318a0209f2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -146,7 +146,6 @@ struct devlink_port {
 	   initialized:1;
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
-	struct mutex reporters_lock; /* Protects reporter_list */
 
 	struct devlink_rate *devlink_rate;
 	struct devlink_linecard *linecard;
diff --git a/net/devlink/core.c b/net/devlink/core.c
index e2b9fcb47e22..7e2332adb79d 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -234,7 +234,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	lockdep_register_key(&devlink->lock_key);
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
-	mutex_init(&devlink->reporters_lock);
 	refcount_set(&devlink->refcount, 1);
 
 	return devlink;
@@ -256,7 +255,6 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	lockdep_unregister_key(&devlink->lock_key);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index d5bc46984039..7eb32c35ad81 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -31,7 +31,6 @@ struct devlink {
 	struct list_head param_list;
 	struct list_head region_list;
 	struct list_head reporter_list;
-	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
 	struct list_head trap_list;
 	struct list_head trap_group_list;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index d17a8dda85ea..5af7e619fb12 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7281,12 +7281,10 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_priv);
 
 static struct devlink_health_reporter *
 __devlink_health_reporter_find_by_name(struct list_head *reporter_list,
-				       struct mutex *list_lock,
 				       const char *reporter_name)
 {
 	struct devlink_health_reporter *reporter;
 
-	lockdep_assert_held(list_lock);
 	list_for_each_entry(reporter, reporter_list, list)
 		if (!strcmp(reporter->ops->name, reporter_name))
 			return reporter;
@@ -7298,7 +7296,6 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
 				     const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink->reporter_list,
-						      &devlink->reporters_lock,
 						      reporter_name);
 }
 
@@ -7307,7 +7304,6 @@ devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
 					  const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink_port->reporter_list,
-						      &devlink_port->reporters_lock,
 						      reporter_name);
 }
 
@@ -7353,22 +7349,18 @@ devl_port_health_reporter_create(struct devlink_port *port,
 	struct devlink_health_reporter *reporter;
 
 	devl_assert_locked(port->devlink);
-	mutex_lock(&port->reporters_lock);
+
 	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
-						   &port->reporters_lock, ops->name)) {
-		reporter = ERR_PTR(-EEXIST);
-		goto unlock;
-	}
+						   ops->name))
+		return ERR_PTR(-EEXIST);
 
 	reporter = __devlink_health_reporter_create(port->devlink, ops,
 						    graceful_period, priv);
 	if (IS_ERR(reporter))
-		goto unlock;
+		return reporter;
 
 	reporter->devlink_port = port;
 	list_add_tail(&reporter->list, &port->reporter_list);
-unlock:
-	mutex_unlock(&port->reporters_lock);
 	return reporter;
 }
 EXPORT_SYMBOL_GPL(devl_port_health_reporter_create);
@@ -7389,20 +7381,16 @@ devl_health_reporter_create(struct devlink *devlink,
 	struct devlink_health_reporter *reporter;
 
 	devl_assert_locked(devlink);
-	mutex_lock(&devlink->reporters_lock);
-	if (devlink_health_reporter_find_by_name(devlink, ops->name)) {
-		reporter = ERR_PTR(-EEXIST);
-		goto unlock;
-	}
+
+	if (devlink_health_reporter_find_by_name(devlink, ops->name))
+		return ERR_PTR(-EEXIST);
 
 	reporter = __devlink_health_reporter_create(devlink, ops,
 						    graceful_period, priv);
 	if (IS_ERR(reporter))
-		goto unlock;
+		return reporter;
 
 	list_add_tail(&reporter->list, &devlink->reporter_list);
-unlock:
-	mutex_unlock(&devlink->reporters_lock);
 	return reporter;
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_create);
@@ -7453,13 +7441,9 @@ __devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 void
 devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	struct mutex *lock = &reporter->devlink->reporters_lock;
-
 	devl_assert_locked(reporter->devlink);
 
-	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(lock);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7482,13 +7466,9 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 void
 devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	struct mutex *lock = &reporter->devlink_port->reporters_lock;
-
 	devl_assert_locked(reporter->devlink);
 
-	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(lock);
 }
 EXPORT_SYMBOL_GPL(devl_port_health_reporter_destroy);
 
@@ -7731,17 +7711,13 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
 	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
 	if (IS_ERR(devlink_port)) {
-		mutex_lock(&devlink->reporters_lock);
 		reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
 		if (reporter)
 			refcount_inc(&reporter->refcount);
-		mutex_unlock(&devlink->reporters_lock);
 	} else {
-		mutex_lock(&devlink_port->reporters_lock);
 		reporter = devlink_port_health_reporter_find_by_name(devlink_port, reporter_name);
 		if (reporter)
 			refcount_inc(&reporter->refcount);
-		mutex_unlock(&devlink_port->reporters_lock);
 	}
 
 	return reporter;
@@ -7841,8 +7817,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!devl_is_registered(devlink))
 			goto next_devlink;
 
-		mutex_lock(&devlink->reporters_lock);
-
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
 			if (idx < state->idx) {
@@ -7854,7 +7828,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 				NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->reporters_lock);
 				devl_unlock(devlink);
 				devlink_put(devlink);
 				state->idx = idx;
@@ -7862,10 +7835,8 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->reporters_lock);
 
 		xa_for_each(&devlink->ports, port_index, port) {
-			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
 				if (idx < state->idx) {
 					idx++;
@@ -7877,7 +7848,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
-					mutex_unlock(&port->reporters_lock);
 					devl_unlock(devlink);
 					devlink_put(devlink);
 					state->idx = idx;
@@ -7885,7 +7855,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				}
 				idx++;
 			}
-			mutex_unlock(&port->reporters_lock);
 		}
 next_devlink:
 		devl_unlock(devlink);
@@ -9611,12 +9580,9 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
-	mutex_init(&devlink_port->reporters_lock);
 	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
-	if (err) {
-		mutex_destroy(&devlink_port->reporters_lock);
+	if (err)
 		return err;
-	}
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9667,7 +9633,6 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
 }
 EXPORT_SYMBOL_GPL(devl_port_unregister);
-- 
2.39.0

