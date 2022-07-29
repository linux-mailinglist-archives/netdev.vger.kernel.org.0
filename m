Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA7D584C6B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiG2HKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiG2HKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:10:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4245151A02
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s9so4726393edd.8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkvoAU4p+O3xprVgsRIdJBwQ3xShpIWACr2U5TdZH84=;
        b=TWqeFWQQbn7D+hnQ72cUCuB/2Ct8fKyPFa/YVW9t1x19kuwAqCEbo5uyDYzSnMJuZJ
         1X7sBz9dQMWpT5PVdf4NgV1rkNngEbrXNO5KIniKOyAFmED45Z7sKvBjj8Ueoy2OFdjM
         EZW6w6VmPL90KPn05WevF1zBZuQDN695WCHL2eFDQ0TTUyq80Ty6i3Qf07S8ddkrILFp
         8/7IKWTmqJdQJTh3Yko3gJpmAlZSEUUZ2ZtBm50dyv0cndfw3lJ3k5BmDoEoCVvujetq
         vtPPsx430PpjAgOxbaNdn8N/kspjiAUTWOzTXIsXAd/YIV6ROmD+mJztdmksvCBNNef3
         Qe4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkvoAU4p+O3xprVgsRIdJBwQ3xShpIWACr2U5TdZH84=;
        b=pHmz3NSdynxJyFcOOqyt4kYwNrYiEUI05xmvZtXEYKITGHIFX1rJSpQRboHKamKfSA
         yAEsFuE+Ad/xEhcmyF5MnpyBcnH0tLqPJQSdX8yV8DUJF40cz6LQ0Sn9dSgZVZHhF+cF
         b8cBIbQuTMYnbwYS9vyt7sjFsqQ7ciIFJLu4nPt+zSTxPE38zsqm+RyHkq4arBueu1E0
         lmXXmBz9d0Np472wLT6IAAyWbLPIA3suCbeg+rl14WAHGmtY6cOgdsesuxoBN0T+Mw0h
         Y3GzN0ZnZKTmy/pCwwo3wqaqhtgdSfvfFRfc3RgWUWqKVYnnDhEDZ4Bi5Q8XjTje2Ol+
         7Srg==
X-Gm-Message-State: AJIora+TTSVyAMpUpceWZfsfav2hRF2uOpwKBjjgC3fl8ucs83PhjM8f
        BCZR4A6NCBa6o8J0okvP2UFD6T5R1ZI5he/I
X-Google-Smtp-Source: AGRyM1ujY8CFGHGbkMTMo/06L0RfPt5bw/bNbO8Q2JLb/pkUY99oyWqpGsuDeceLPpsy/penNe6ZAA==
X-Received: by 2002:a05:6402:e0f:b0:43c:f9f9:37c4 with SMTP id h15-20020a0564020e0f00b0043cf9f937c4mr2247478edh.196.1659078642626;
        Fri, 29 Jul 2022 00:10:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709063d2100b0072f0a9a8e6dsm1315988ejf.194.2022.07.29.00.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:10:42 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: [patch net-next 2/4] net: devlink: convert reload command to take implicit devlink->lock
Date:   Fri, 29 Jul 2022 09:10:36 +0200
Message-Id: <20220729071038.983101-3-jiri@resnulli.us>
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

Convert reload command to behave the same way as the rest of the
commands and let if be called with devlink->lock held. Remove the
temporary devl_lock taking from drivers. As the DEVLINK_NL_FLAG_NO_LOCK
flag is no longer used, remove it alongside.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c      |  4 ----
 .../net/ethernet/mellanox/mlx5/core/devlink.c  |  4 ----
 drivers/net/ethernet/mellanox/mlxsw/core.c     |  4 ----
 drivers/net/netdevsim/dev.c                    |  6 ------
 net/core/devlink.c                             | 18 +++++-------------
 5 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 2c764d1d897d..78c5f40382c9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3958,11 +3958,9 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
 		return -EOPNOTSUPP;
 	}
-	devl_lock(devlink);
 	if (persist->num_vfs)
 		mlx4_warn(persist->dev, "Reload performed on PF, will cause reset on operating Virtual Functions\n");
 	mlx4_restart_one_down(persist->pdev);
-	devl_unlock(devlink);
 	return 0;
 }
 
@@ -3975,10 +3973,8 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	struct mlx4_dev_persistent *persist = dev->persist;
 	int err;
 
-	devl_lock(devlink);
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	err = mlx4_restart_one_up(persist->pdev, true, devlink);
-	devl_unlock(devlink);
 	if (err)
 		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
 			 err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1c05a7091698..66c6a7017695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -164,7 +164,6 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is unfavorable");
 	}
 
-	devl_lock(devlink);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
 		mlx5_unload_one_devl_locked(dev);
@@ -181,7 +180,6 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		ret = -EOPNOTSUPP;
 	}
 
-	devl_unlock(devlink);
 	return ret;
 }
 
@@ -192,7 +190,6 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int ret = 0;
 
-	devl_lock(devlink);
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
@@ -211,7 +208,6 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 		ret = -EOPNOTSUPP;
 	}
 
-	devl_unlock(devlink);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a48f893cf7b0..e12918b6baa1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1499,9 +1499,7 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_RESET))
 		return -EOPNOTSUPP;
 
-	devl_lock(devlink);
 	mlxsw_core_bus_device_unregister(mlxsw_core, true);
-	devl_unlock(devlink);
 	return 0;
 }
 
@@ -1515,12 +1513,10 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_re
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			     BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
-	devl_lock(devlink);
 	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
 					     mlxsw_core->bus,
 					     mlxsw_core->bus_priv, true,
 					     devlink, extack);
-	devl_unlock(devlink);
 	return err;
 }
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 5802e80e8fe1..e88f783c297e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -948,18 +948,15 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
-	devl_lock(devlink);
 	if (nsim_dev->dont_allow_reload) {
 		/* For testing purposes, user set debugfs dont_allow_reload
 		 * value to true. So forbid it.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User forbid the reload for testing purposes");
-		devl_unlock(devlink);
 		return -EOPNOTSUPP;
 	}
 
 	nsim_dev_reload_destroy(nsim_dev);
-	devl_unlock(devlink);
 	return 0;
 }
 
@@ -970,19 +967,16 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	int ret;
 
-	devl_lock(devlink);
 	if (nsim_dev->fail_reload) {
 		/* For testing purposes, user set debugfs fail_reload
 		 * value to true. Fail right away.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
-		devl_unlock(devlink);
 		return -EINVAL;
 	}
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	ret = nsim_dev_reload_create(nsim_dev, extack);
-	devl_unlock(devlink);
 	return ret;
 }
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6b20196ada1a..57865b231364 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -768,12 +768,6 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 #define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
 #define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
 
-/* The per devlink instance lock is taken by default in the pre-doit
- * operation, yet several commands do not require this. The global
- * devlink lock is taken and protects from disruption by user-calls.
- */
-#define DEVLINK_NL_FLAG_NO_LOCK			BIT(5)
-
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
 {
@@ -788,8 +782,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 		mutex_unlock(&devlink_mutex);
 		return PTR_ERR(devlink);
 	}
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		devl_lock(devlink);
+	devl_lock(devlink);
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
@@ -831,8 +824,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	return 0;
 
 unlock:
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		devl_unlock(devlink);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 	return err;
@@ -849,8 +841,7 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 		linecard = info->user_ptr[1];
 		devlink_linecard_put(linecard);
 	}
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-		devl_unlock(devlink);
+	devl_unlock(devlink);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 }
@@ -9414,7 +9405,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_reload,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
@@ -12507,10 +12497,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
+		mutex_lock(&devlink->lock);
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
 				     &actions_performed, NULL);
+		mutex_unlock(&devlink->lock);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 		devlink_put(devlink);
-- 
2.35.3

