Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558A6AC94F
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406386AbfIGUyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:54:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32905 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406341AbfIGUyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:54:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so9890308wme.0
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l6kf0Bo7RMwp8MsF4i0nTYp7fcmofzgeJ+OuH6VUkCs=;
        b=rngcusHcn7SV1uO4APRl3BZLgQCtOpTB3D6WZlmHXT0XN2ADh49hccmy+pHw0Q0wGZ
         pgAF5gGH9NDWo5vbCDTXjyCB8gZKRNsheLP0dc9og0J+4OT2axm2PCpPM6hf4jT2gDsP
         bxgMRZilli8hNSkuiXUzRsip0lZhTuwIHwCaZwv2v3tHcgutdP4dfJCFmaFUS/6AIDso
         HXcAYdoekk+MjKCnH5TaLYPtZ7zOiXBgLORpGcngTiv70KROcy/2CpfQSdnxtAlb7HoG
         DQq1chQGevr/Ab5NGb95f6R7osUcKXlwjd85nNtOIoh6V5KK99nLs51TuM+AO3AoNEDN
         iyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l6kf0Bo7RMwp8MsF4i0nTYp7fcmofzgeJ+OuH6VUkCs=;
        b=oapRZIaGhVgStNxt0vOI4uK7O90znbswBXFdxyApYp95+60ObLnKq7ANLvGcw1gAV9
         w3KluESQu+r1NQUHQyk3vHx9dZ18redHISDO9m0r542gkXTtxCSmPdFyOW91QmHLoS/X
         0wRgGtEpvurnoEkNQvEhdMv7owEpFB9qVEhpAHVl+g6S6VXw69sqDS5+OLOpK2eFWVBU
         s78vYx0oWdU7MW72ebtUwNsKOKKATNTBqty0nsVw67gv3vXElUPGm4NN7pTWy9DdNRQ2
         4eXHDDrbdRwYaQnJvPS7QEAWj49LtTwOS0uXieOMls76IZdlLM9yg4fdI26lf6k44Cd9
         wguQ==
X-Gm-Message-State: APjAAAUXPgmg2ee/deHbCkDVZ9whG8KotBtyDKiPHWmXCfuz2q8Ac5RH
        4WW5xgNtYGDdFgOc/B8C54SHimyUBGw=
X-Google-Smtp-Source: APXvYqyYRXL62xqpWsaBgSBMlRd+8DiKRZCUUBClwpfKrZRPuTawyFpxnbLFlp+bULlZJ3DZhnbG4A==
X-Received: by 2002:a1c:f20d:: with SMTP id s13mr7228556wmc.132.1567889644247;
        Sat, 07 Sep 2019 13:54:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u6sm8871946wrr.26.2019.09.07.13.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:54:04 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 3/3] net: devlink: move reload fail indication to devlink core and expose to user
Date:   Sat,  7 Sep 2019 22:54:00 +0200
Message-Id: <20190907205400.14589-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190907205400.14589-1-jiri@resnulli.us>
References: <20190907205400.14589-1-jiri@resnulli.us>
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
index c17709c0d0ec..9c881dc25273 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,6 +38,7 @@ struct devlink {
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock;
+	bool reload_failed;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -940,6 +941,8 @@ void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 				     enum devlink_health_reporter_state state);
 
+bool devlink_is_reload_failed(struct devlink *devlink);
+
 void devlink_flash_update_begin_notify(struct devlink *devlink);
 void devlink_flash_update_end_notify(struct devlink *devlink);
 void devlink_flash_update_status_notify(struct devlink *devlink,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 546e75dd74ac..7cb5e8c5ae0d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -410,6 +410,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_METADATA,			/* nested */
 	DEVLINK_ATTR_TRAP_GROUP_NAME,			/* string */
 
+	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1e3a2288b0b2..e00a4a643d17 100644
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
+bool devlink_is_reload_failed(struct devlink *devlink)
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

