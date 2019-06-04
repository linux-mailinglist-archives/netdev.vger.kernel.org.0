Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E9834920
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfFDNlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:41:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52565 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbfFDNky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so108209wms.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/leEv2mzGHvxa9YEiVlZTZiXxrmKUeG0RJBc9wNq0+c=;
        b=1Jq1gG5ZTilkCnxes16hGozm1M68uxxPO4r1B/WFmZu4H11pHiCVozZ8LGkkFLRpfQ
         wmhADVCFK1gMfvP43IM4GnnAFejKY3YceMlV7o/bsT5rUk+chybCimZhovVIL2kdLuCN
         Mv+p2tSQxXxjbK+1XRSQBY9pcWwaBT/KRa8G3atAn7Ak+pw5RkfcEg3ztNytTEq5Zt84
         8bKBXkQQLPPKCRnLYhjOBWv2R029mDn3MKkjc53yCnd6DLd0BWQ2djdZhC3YE79U8hVN
         g+jBfDOVoJRYUeSmagOysH0HNutAJxxslwi9ZCMlbGfwYJbnjGEUE8Jo1Y8cjh7gvsXU
         4V3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/leEv2mzGHvxa9YEiVlZTZiXxrmKUeG0RJBc9wNq0+c=;
        b=cU/vvtJ6PeQP0DgdThiABJPcVj8LOKDkZ0q+QO+sfIS8AQSfq9zjRfPAoo2KOIjV3i
         0CVt3YbskPycaNFAERyHyHBYdQaH3NKFyTZgZFQGxsPZItHvOMeCZElPDhBQS7V/1GEK
         zqvkcsFtloWzuvV4T7ZqlnQ2G3JSTsQi+PccK7v88B3Odo5+LHN1qeYpxYftfdiDzn7D
         Eb958o65L2iOQUMiHjDB7W6xdf2CQsJoJLH9iIlI5DSm/N/mNo+icVzLz9hVK3jfmLG+
         zE8io2NmVT8dKrMzUy5PR9jwEwTdpwhRTO9435x6OUxvt/tK3VNzhy8ogea7RKZayxXQ
         wLrg==
X-Gm-Message-State: APjAAAVHvDyNw3HnnFpQwEPjj46Ul86q/rUmrJZf/SuKQ3QYF/PrrmJh
        zEQGJUrfnYgS5IxCEMiR6Xo9l8MI9WmwT6PP
X-Google-Smtp-Source: APXvYqwmKtjgsly49AlSSxPGggSE4ppr1E1vuGHJLhXVZgFD0SO93R0DR/3wnbHy803o8kRZ6+B5IQ==
X-Received: by 2002:a7b:c344:: with SMTP id l4mr17464942wmj.59.1559655652101;
        Tue, 04 Jun 2019 06:40:52 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id 65sm34199952wro.85.2019.06.04.06.40.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 6/8] mlxsw: Implement flash update status notifications
Date:   Tue,  4 Jun 2019 15:40:42 +0200
Message-Id: <20190604134044.2613-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement mlxfw status_notify op by passing notification down to
devlink. Also notify about flash update begin and end.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 2cba678863bd..417e7c9273ef 100644
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

