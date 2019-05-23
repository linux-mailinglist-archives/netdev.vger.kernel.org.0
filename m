Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125882799C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfEWJp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:45:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39782 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730363AbfEWJp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:45:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so991917wma.4
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XsyipV2nm7850oQ6HrbcxJvkYIRy7UAiY//nsGFXsaM=;
        b=uhHpm5Da56Bc3J4xcMtspl0/hz5R1/Ry+1jIZ9tu7RVOo/p+YJlcg3Ipmlqwg5mkS/
         CrQbekJKiA4brXMcEX3ZNMMtr+SFJ/B2KC5NYiZoxBGQYKuU4uYkvkUPxAhDP9zNxYG8
         01gIBjbxajwEKvzbf2elc7JJJSZHmqOci/E0OBqMjaiWHll3PzBDgJFMNYjLDgZKclcN
         02vOAWkdOqEHv2VgpWjkxCWCQHYAgGZA2CD8UMVm6EPZ+eZp1d2Csc+EsDgY+BO2ZF4k
         zqfS8savnWgh0WkF0kIfCavypE5TaGWxnr6pSa7gSkgSA6ckws8DKQzHWFZ/ybcL4VGz
         LNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XsyipV2nm7850oQ6HrbcxJvkYIRy7UAiY//nsGFXsaM=;
        b=Zf1uLpTn+jage4hZuTO9kkIGJRffw/V2DaHdU8o69g5SXUi3gl/ppXSLLKdoBAH7sy
         MoA2+hO1AHt448XeJiHOxSDbpuPrJQmLPdxAPrJRNCfGSSpE+2xluBhSf82gPHAyI+tb
         d7bdkYj/4HHkZkP6HSj6BV+SVE6TeOO50v/IswUbxZKGTkYbhPseTG5gP6L1TG8RP/Pg
         Lfgs+bVpAswGF4W0ppiYZJSDdVxWxZ0vIqSBztJjDn1P/AGO5BieCCS2ANcZFAK0oL5l
         caJHz4fx5NEX6aWSZBWwUfUKgfyNQ+qcC3moyoxAD72rOYZqL9CVKz+CM8ZENrRRGW+j
         KTmw==
X-Gm-Message-State: APjAAAWUgNfZidYm2oZgj4686qQyV+0DGkbhBgM2FB8iDea14ci/Fvcs
        sNOgOxWb1vhYUKqQO2OWNy7ePW4wZSo=
X-Google-Smtp-Source: APXvYqx+0WWDpUPEO4FEasmvY5yxqzgPh79dB66mohfrAl3IgZwb/wudHmnTPM86d1I9i6xiH5kK9w==
X-Received: by 2002:a1c:1f47:: with SMTP id f68mr11448204wmf.57.1558604726530;
        Thu, 23 May 2019 02:45:26 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id s62sm4448637wmf.24.2019.05.23.02.45.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:45:26 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch net-next 6/7] mlxsw: Implement flash update status notifications
Date:   Thu, 23 May 2019 11:45:09 +0200
Message-Id: <20190523094510.2317-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
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

