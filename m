Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C5CB0AA4
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbfILItz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 04:49:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35527 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfILItw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 04:49:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id n10so6605797wmj.0
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 01:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WjMvQUpkNfMt20M9QSj9cvMCAWuUDnSuiwIUrNshSeM=;
        b=uv+Eq2Ndl6MWl59L46D+PWaA1X19XM+CzJYUrn/y0A+qAZ6NNsAWVhORCa3db44nCN
         rV0022ZyW5nv3pLTuxzta7XhWJaalZOYivmAPxUz9mX3Z+qUlyVBGAMqZ8sZmsSQfiTg
         FtOSG5d/vMzm0lRh0FyhXt/M8TnKdvthvL11B47mJEK0KeNUjCZyp81ESOlrD4qf0zM9
         P2w2vygRBqS8b8dWsXa8xQzSOM40ePZEWxQfhHNcQSMJSyfWFCwBJFlYBwYYCv1JJISw
         bnZvOPb5pltKvvvs9Ah3sPp8vbIWqWX0o5fI1CQRHAoItaZiyMdcOTN1VvNpf699CLWD
         15Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WjMvQUpkNfMt20M9QSj9cvMCAWuUDnSuiwIUrNshSeM=;
        b=NS01SdQDi0F8MA8iERNz7ZI/u8EoCRoYfSlZ4X+DoVU8CXAQtEPlncxGdUzdp2OxZL
         1+DdbUJG0x7LpvyPi/5WBjxKKnY7nVLexJImFKeRsvew6dpcnV6qem0nGJiUwp5/Edme
         mAqKT8b+AeBSDMIJGusjaypbU1d8XdI+ob4vvu2ADr0Tbr/DFbl8cEg0JXHQq2hN4XP+
         HScKZrAgqEjB78jUUo5STjUVx3vQlOFPjqGEx371TYdUowD3crUrao27+vWKdrg9VFGV
         U5GyhTxgLdw9odctp6s7jysPhIW8v46JsxL46DwJRBdzaBcxxr4zfCmx1GfwTgSC6r6z
         rHHg==
X-Gm-Message-State: APjAAAU3i5CB9W9KvEZ6dAIz7iH2/g9/La+t0BLsHaEV6gE/uXAXxpm+
        LrB9XNT+urSvF12Lo0NDXmXxBBP5Pws=
X-Google-Smtp-Source: APXvYqwSGbsrPONaJ2bQz6cRs/NbhdCMUWPa+1ErXjrwa4rS3Rm9fodf1fYLElupB1dK9kG4W7E4vQ==
X-Received: by 2002:a7b:cc0a:: with SMTP id f10mr7846705wmh.6.1568278190147;
        Thu, 12 Sep 2019 01:49:50 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g15sm4334326wmk.17.2019.09.12.01.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 01:49:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 3/3] net: devlink: move reload fail indication to devlink core and expose to user
Date:   Thu, 12 Sep 2019 10:49:46 +0200
Message-Id: <20190912084946.7468-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190912084946.7468-1-jiri@resnulli.us>
References: <20190912084946.7468-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the fact that devlink reload failed is stored in drivers.
Move this flag into devlink core. Also, expose it to the user.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- make arg of devlink_is_reload_failed const
v1->v2:
- s/devlink failed/devlink reload failed/ in description
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 15 +++++----------
 include/net/devlink.h                      |  3 +++
 include/uapi/linux/devlink.h               |  2 ++
 net/core/devlink.c                         | 21 ++++++++++++++++++++-
 4 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index c71a1d9ea17b..3fa96076e8a5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -80,7 +80,6 @@ struct mlxsw_core {
 	struct mlxsw_thermal *thermal;
 	struct mlxsw_core_port *ports;
 	unsigned int max_ports;
-	bool reload_fail;
 	bool fw_flash_in_progress;
 	unsigned long driver_priv[0];
 	/* driver_priv has to be always the last item */
@@ -1002,15 +1001,11 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
 					struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
-	int err;
-
-	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
-					     mlxsw_core->bus,
-					     mlxsw_core->bus_priv, true,
-					     devlink);
-	mlxsw_core->reload_fail = !!err;
 
-	return err;
+	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
+					      mlxsw_core->bus,
+					      mlxsw_core->bus_priv, true,
+					      devlink);
 }
 
 static int mlxsw_devlink_flash_update(struct devlink *devlink,
@@ -1254,7 +1249,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	if (mlxsw_core->reload_fail) {
+	if (devlink_is_reload_failed(devlink)) {
 		if (!reload)
 			/* Only the parts that were not de-initialized in the
 			 * failed reload attempt need to be de-initialized.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ab8d56d12ffd..23e4b65ec9df 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,6 +38,7 @@ struct devlink {
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock;
+	bool reload_failed;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -945,6 +946,8 @@ void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 				     enum devlink_health_reporter_state state);
 
+bool devlink_is_reload_failed(const struct devlink *devlink);
+
 void devlink_flash_update_begin_notify(struct devlink *devlink);
 void devlink_flash_update_end_notify(struct devlink *devlink);
 void devlink_flash_update_status_notify(struct devlink *devlink,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 8da5365850cd..580b7a2e40e1 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -419,6 +419,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_METADATA,			/* nested */
 	DEVLINK_ATTR_TRAP_GROUP_NAME,			/* string */
 
+	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9e522639693d..e48680efe54a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -471,6 +471,8 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 
 	if (devlink_nl_put_handle(msg, devlink))
 		goto nla_put_failure;
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
+		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
 	return 0;
@@ -2677,6 +2679,21 @@ static bool devlink_reload_supported(struct devlink *devlink)
 	return devlink->ops->reload_down && devlink->ops->reload_up;
 }
 
+static void devlink_reload_failed_set(struct devlink *devlink,
+				      bool reload_failed)
+{
+	if (devlink->reload_failed == reload_failed)
+		return;
+	devlink->reload_failed = reload_failed;
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+}
+
+bool devlink_is_reload_failed(const struct devlink *devlink)
+{
+	return devlink->reload_failed;
+}
+EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
+
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
@@ -2693,7 +2710,9 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	err = devlink->ops->reload_down(devlink, info->extack);
 	if (err)
 		return err;
-	return devlink->ops->reload_up(devlink, info->extack);
+	err = devlink->ops->reload_up(devlink, info->extack);
+	devlink_reload_failed_set(devlink, !!err);
+	return err;
 }
 
 static int devlink_nl_flash_update_fill(struct sk_buff *msg,
-- 
2.21.0

