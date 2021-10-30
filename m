Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA260440C45
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhJ3XPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhJ3XPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5768860F58;
        Sat, 30 Oct 2021 23:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635579;
        bh=B689u4FVLxFxmSpbC/937qPz503/GxP6v1KM8558S/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7X0u7R8U7X+oDVEtL/GpbZ4vcxvzSXVuDfcOqi0UsMW9Y7L3oJuP7nTXNCVSZ5Fj
         fobTJ0TNW1zLqXeWfFEGNgIcWQHEQJi16nJK4k1yvi0S79wSlGLT1RXgnK+QtJ5Ls9
         S9EWX7FeOPWrJWBpEPTNH57tC+EfAV/rU3CLW35rP9GLbzkQqPrBHIqJIdYOSulbI4
         9tp11rbp9UujDKLDWKCLQztMopsv6Vru21O6moZQs9aT6xevmfTb+vLyBDq/fJzjvw
         rLmhTFTnHrKWs5e84+7sbGf4fjtt20BM5RmPF8DrMS53WAMSvvs1E/EzrhufzBwJ1P
         OsG1SMoUR6zSw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     leon@kernel.org, idosch@idosch.org
Cc:     edwin.peer@broadcom.com, jiri@resnulli.us, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 3/5] devlink: allow locking of all ops
Date:   Sat, 30 Oct 2021 16:12:52 -0700
Message-Id: <20211030231254.2477599-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231254.2477599-1-kuba@kernel.org>
References: <20211030231254.2477599-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers using the "explicit locking" API can opt-in
to have all callbacks locked by the devlink instance
lock.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h | 12 +++++++++
 net/core/devlink.c    | 63 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 66c1951a6f0e..41ab6a2b63f0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1190,7 +1190,19 @@ enum {
 	DEVLINK_F_RELOAD = 1UL << 0,
 };
 
+enum {
+	DEVLINK_LOCK_REF_MODE	= 1UL << 0,
+	DEVLINK_LOCK_ESWITCH	= 1UL << 1,
+	DEVLINK_LOCK_PORT_OPS	= 1UL << 2,
+	DEVLINK_LOCK_HEALTH_OPS	= 1UL << 3,
+};
+#define DEVLINK_LOCK_ALL_OPS (DEVLINK_LOCK_REF_MODE |	\
+			      DEVLINK_LOCK_ESWITCH |	\
+			      DEVLINK_LOCK_PORT_OPS |	\
+			      DEVLINK_LOCK_HEALTH_OPS)
+
 struct devlink_ops {
+	u8 lock_flags;
 	struct module *owner;
 	/**
 	 * @supported_flash_update_params:
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6783b066f9a7..70b3f725cb53 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -256,6 +256,18 @@ void devlink_unlock(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_unlock);
 
+static void devlink_lock_cond(struct devlink *devlink, unsigned long flag)
+{
+	if (devlink->ops->lock_flags & flag)
+		mutex_lock(&devlink->lock);
+}
+
+static void devlink_unlock_cond(struct devlink *devlink, unsigned long flag)
+{
+	if (devlink->ops->lock_flags & flag)
+		mutex_unlock(&devlink->lock);
+}
+
 int lockdep_devlink_is_held(struct devlink *devlink)
 {
 	return lockdep_is_held(&devlink->lock);
@@ -1595,6 +1607,7 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 	struct devlink_port *devlink_port;
 	u32 port_index;
 	u32 count;
+	int ret;
 
 	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX] ||
 	    !info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT])
@@ -1621,7 +1634,10 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	return devlink_port_split(devlink, port_index, count, info->extack);
+	devlink_lock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
+	ret = devlink_port_split(devlink, port_index, count, info->extack);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
+	return ret;
 }
 
 static int devlink_port_unsplit(struct devlink *devlink, u32 port_index,
@@ -1638,12 +1654,17 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	u32 port_index;
+	int ret;
 
 	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX])
 		return -EINVAL;
 
 	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
-	return devlink_port_unsplit(devlink, port_index, info->extack);
+
+	devlink_lock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
+	ret = devlink_port_unsplit(devlink, port_index, info->extack);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
+	return ret;
 }
 
 static int devlink_port_new_notifiy(struct devlink *devlink,
@@ -1718,15 +1739,19 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 		new_attrs.sfnum_valid = true;
 	}
 
+	devlink_lock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
 	err = devlink->ops->port_new(devlink, &new_attrs, extack,
 				     &new_port_index);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
 	if (err)
 		return err;
 
 	err = devlink_port_new_notifiy(devlink, new_port_index, info);
 	if (err && err != -ENODEV) {
 		/* Fail to send the response; destroy newly created port. */
+		devlink_lock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
 		devlink->ops->port_del(devlink, new_port_index, extack);
+		devlink_unlock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
 	}
 	return err;
 }
@@ -1737,6 +1762,7 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	unsigned int port_index;
+	int ret;
 
 	if (!devlink->ops->port_del)
 		return -EOPNOTSUPP;
@@ -1747,7 +1773,10 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	}
 	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
 
-	return devlink->ops->port_del(devlink, port_index, extack);
+	devlink_lock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
+	ret = devlink->ops->port_del(devlink, port_index, extack);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_PORT_OPS);
+	return ret;
 }
 
 static int
@@ -2841,7 +2870,9 @@ static int devlink_nl_eswitch_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto nla_put_failure;
 
 	if (ops->eswitch_mode_get) {
+		devlink_lock_cond(devlink, DEVLINK_LOCK_ESWITCH);
 		err = ops->eswitch_mode_get(devlink, &mode);
+		devlink_unlock_cond(devlink, DEVLINK_LOCK_ESWITCH);
 		if (err)
 			goto nla_put_failure;
 		err = nla_put_u16(msg, DEVLINK_ATTR_ESWITCH_MODE, mode);
@@ -2932,7 +2963,9 @@ static int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb,
 		err = devlink_rate_nodes_check(devlink, mode, info->extack);
 		if (err)
 			return err;
+		devlink_lock_cond(devlink, DEVLINK_LOCK_ESWITCH);
 		err = ops->eswitch_mode_set(devlink, mode, info->extack);
+		devlink_unlock_cond(devlink, DEVLINK_LOCK_ESWITCH);
 		if (err)
 			return err;
 	}
@@ -4227,7 +4260,9 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		}
 	}
+	devlink_lock_cond(devlink, DEVLINK_LOCK_REF_MODE);
 	err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_REF_MODE);
 
 	if (dest_net)
 		put_net(dest_net);
@@ -7116,8 +7151,10 @@ static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 	if (err)
 		goto dump_err;
 
+	devlink_lock_cond(reporter->devlink, DEVLINK_LOCK_HEALTH_OPS);
 	err = reporter->ops->dump(reporter, reporter->dump_fmsg,
 				  priv_ctx, extack);
+	devlink_unlock_cond(reporter->devlink, DEVLINK_LOCK_HEALTH_OPS);
 	if (err)
 		goto dump_err;
 
@@ -7141,6 +7178,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	enum devlink_health_reporter_state prev_health_state;
 	struct devlink *devlink = reporter->devlink;
 	unsigned long recover_ts_threshold;
+	int ret;
 
 	/* write a log message of the current error */
 	WARN_ON(!msg);
@@ -7174,11 +7212,14 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 		mutex_unlock(&reporter->dump_lock);
 	}
 
-	if (reporter->auto_recover)
-		return devlink_health_reporter_recover(reporter,
-						       priv_ctx, NULL);
+	ret = 0;
+	if (reporter->auto_recover) {
+		devlink_lock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
+		ret = devlink_health_reporter_recover(reporter, priv_ctx, NULL);
+		devlink_unlock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
+	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(devlink_health_report);
 
@@ -7430,7 +7471,9 @@ static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
+	devlink_lock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
 	err = devlink_health_reporter_recover(reporter, NULL, info->extack);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
 
 	devlink_health_reporter_put(reporter);
 	return err;
@@ -7463,7 +7506,9 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 	if (err)
 		goto out;
 
+	devlink_lock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
 	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
 	if (err)
 		goto out;
 
@@ -7557,7 +7602,9 @@ static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
 		return -EOPNOTSUPP;
 	}
 
+	devlink_lock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
 	err = reporter->ops->test(reporter, info->extack);
+	devlink_unlock_cond(devlink, DEVLINK_LOCK_HEALTH_OPS);
 
 	devlink_health_reporter_put(reporter);
 	return err;
@@ -11690,10 +11737,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			goto retry;
 
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
+		devlink_lock_cond(devlink, DEVLINK_LOCK_REF_MODE);
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
 				     &actions_performed, NULL);
+		devlink_unlock_cond(devlink, DEVLINK_LOCK_REF_MODE);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 retry:
-- 
2.31.1

