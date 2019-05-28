Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13C2C5AF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfE1Ls6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:48:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44972 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbfE1Lsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:48:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so11505540wru.11
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XsyipV2nm7850oQ6HrbcxJvkYIRy7UAiY//nsGFXsaM=;
        b=Ct0thOece5+ga0BSSL6vx8ADJt7F/pLOl2VW3W1cKCMFbtoKpzVxa37eKy29zIvEdU
         POvPgqQItEfz4VExCbcJoA6APN4SWVN5daChJ7R2aGHBMJNr/XhqQwSs0Jdckg2lUGyQ
         g4senCH71BZSrtJjnjzkvP4nexktz5YOlRTUKAH6YrYng9+euByDHSTfQZXqDWrEu4L6
         Kw40r9D1/Q06D7aIVWbSotRMy013KmNw3Fp+9d6eDjdqAUoJINp9pgdfhJKRlr+LvuWB
         nqp1vHELtcO4AeD7UNWwl/Uou4z6/ChwcRJRK2j7iLobS8Wj54xI4g6mq1/rHb6Ia/dt
         BW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XsyipV2nm7850oQ6HrbcxJvkYIRy7UAiY//nsGFXsaM=;
        b=g3CBomr/ss+HZu9OjEM/gsuf0cz65QjjPejGkFV1EanW+O0QtM7IQluZMA5h2KFDos
         GEVT843etd+8VNqJDJw7onE2o8kmgJornqaf8hub9lbMSLFJ9lfwvZShJUytB4qYTYvh
         vov5KcsmxdfTQfSZE2QErs43Zs5IjQL3lb7rbwo9FE4otYA7XaF6aI/gyZPEGD35YraW
         exg3UK6w8CQ2g8nwl54acnkspUrwqKIVyScY2cOAEwzbFHFwrNV5aftyxCrekNGcr6yb
         CTPeuNwHyX5RxI1qcBfx/mqnqoKdDbdwd3EgrJIBUOq34fb7Pb7vVZIVj0vKqG3RMikg
         a9+w==
X-Gm-Message-State: APjAAAWLNetlfBFdWZxjm1xJPgqDbAhsfbt5snX8VzwLWejzAs2xiO6F
        0h2TDVTnJHmQ7XoWRqvDM+Dg2ExGEIs=
X-Google-Smtp-Source: APXvYqxkZf1gXipVmVcDN3ATeGijSFq2WtVrM3a3/wkrjm14WZ0G0tz499hDzJ+UDiwxOJDMtfP+Aw==
X-Received: by 2002:a5d:5590:: with SMTP id i16mr26522813wrv.307.1559044132918;
        Tue, 28 May 2019 04:48:52 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id u205sm2854108wmu.47.2019.05.28.04.48.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:48:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 6/7] mlxsw: Implement flash update status notifications
Date:   Tue, 28 May 2019 13:48:45 +0200
Message-Id: <20190528114846.1983-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement mlxfw status_notify op by passing notification down to
devlink. Also notify about flash update begin and end.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 639bb5778ff3..5ac893d9dd12 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -294,6 +294,19 @@ static void mlxsw_sp_fsm_release(struct mlxfw_dev *mlxfw_dev, u32 fwhandle)
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
 }
 
+static void mlxsw_sp_status_notify(struct mlxfw_dev *mlxfw_dev,
+				   const char *msg, const char *comp_name,
+				   u32 done_bytes, u32 total_bytes)
+{
+	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
+		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
+
+	devlink_flash_update_status_notify(priv_to_devlink(mlxsw_sp->core),
+					   msg, comp_name,
+					   done_bytes, total_bytes);
+}
+
 static const struct mlxfw_dev_ops mlxsw_sp_mlxfw_dev_ops = {
 	.component_query	= mlxsw_sp_component_query,
 	.fsm_lock		= mlxsw_sp_fsm_lock,
@@ -303,7 +316,8 @@ static const struct mlxfw_dev_ops mlxsw_sp_mlxfw_dev_ops = {
 	.fsm_activate		= mlxsw_sp_fsm_activate,
 	.fsm_query_state	= mlxsw_sp_fsm_query_state,
 	.fsm_cancel		= mlxsw_sp_fsm_cancel,
-	.fsm_release		= mlxsw_sp_fsm_release
+	.fsm_release		= mlxsw_sp_fsm_release,
+	.status_notify		= mlxsw_sp_status_notify,
 };
 
 static int mlxsw_sp_firmware_flash(struct mlxsw_sp *mlxsw_sp,
@@ -321,8 +335,10 @@ static int mlxsw_sp_firmware_flash(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	mlxsw_core_fw_flash_start(mlxsw_sp->core);
+	devlink_flash_update_begin_notify(priv_to_devlink(mlxsw_sp->core));
 	err = mlxfw_firmware_flash(&mlxsw_sp_mlxfw_dev.mlxfw_dev,
 				   firmware, extack);
+	devlink_flash_update_end_notify(priv_to_devlink(mlxsw_sp->core));
 	mlxsw_core_fw_flash_end(mlxsw_sp->core);
 
 	return err;
-- 
2.17.2

