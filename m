Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7AABF91
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406138AbfIFSo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:44:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35993 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406127AbfIFSo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:44:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so7608382wrd.3
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 11:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N2LrkRVvs2PR+tfGtFa9QDQzcTCt09WOrqEr77YS4yw=;
        b=fEdz1P5C8ymqs8P+Ae13N+Bp59D0idBrXrVGdOwS8Qsz+Dg1/XCnYIVBvWgzwJB0MA
         OvARgXeFjnvjpFlQNqOIg4UV1+r2PWqDr3MFKzYGpHQSmV8Wv1neM0Y79ELtKkdi1+tm
         1XnvdJKtifkvDvUNrrYr0v+KTZOLKiAnVJmuLm9SY5A7gjwezT6GpU5OWNsIOB4tI+m/
         XPrjhhdZVrlRcBRs2IfWTW+VLtXhbbxx8WxibfBDcxPfDtz7Wig2fsAgkkYbKgg1zPh8
         wUr/4PFpLxkcE5cEDHerqL4eVxQxKHtd4Gp16/NtQqElxRGmkq1P2osDQ144pH/3D2QR
         ETrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N2LrkRVvs2PR+tfGtFa9QDQzcTCt09WOrqEr77YS4yw=;
        b=BNsT940gHul8Xt5DobtdFi3YEnWQempdorkLwTQwQXhdVEaS0gTRi1ZTEB8bzKnyrX
         W/8udrW6mdYe5+aA67mP5FnsIGIas91vfhZqYfMOKr0L/kXXZnCcdDTOeSwyJVO8tGFC
         WtgSTssIJ+QVyupVb48gmapDxY0X/zPO4HewyFqGbQCa0H+q7M+SS1Ce6wdKOIRprfa6
         p59Y5JtIpjpvuPpMvRZKVzSH0aCUE/cELafwi/f9Xt4Yu78L4Bnj+fOaHcd3Zt0/42Gk
         +Ow4sCGR3JUf7OgCbCbE7hwrHt/dTgirZdx06786p+xM4hGPpne0A5dUo/Ax8xhrWzVX
         3DsA==
X-Gm-Message-State: APjAAAUxeipF5nxmYgDF9szaUuImHFC5o3g1uDI2I+I9lZZ2p0NhqSix
        dhi7A2AljfnON0isQ/Kg1HZXT99QSOU=
X-Google-Smtp-Source: APXvYqyjQc9CwjP/IZO7nhVPSIOoQRKNcj5J9QDUb+Rxm9M/1xLsVrmFlYVBXfHBitNCPkGCQojVcg==
X-Received: by 2002:adf:e945:: with SMTP id m5mr8547515wrn.25.1567795464107;
        Fri, 06 Sep 2019 11:44:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j26sm12884451wrd.2.2019.09.06.11.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 11:44:23 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 3/3] net: devlink: move reload fail indication to devlink core and expose to user
Date:   Fri,  6 Sep 2019 20:44:19 +0200
Message-Id: <20190906184419.5101-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906184419.5101-1-jiri@resnulli.us>
References: <20190906184419.5101-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the fact that devlink failed is stored in drivers. Move this
flag into devlink core. Also, expose it to the user.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
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

