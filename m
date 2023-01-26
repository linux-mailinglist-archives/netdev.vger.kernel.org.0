Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366CF67C53B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbjAZH6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbjAZH6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:44 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7A966EF2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:42 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id h16so853094wrz.12
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2/aJ8EhPXWJDHJjMug2BHW5hCYqrn5DszcYGNPWtII=;
        b=grwNduedktCKhNRCANLAy3URZQ/eHkJEXipye1ey5DDEHtvlKkHnKRuj1WIhKTLN1E
         MbbsbnbP6L/ODzz/GygkqfWiviWJz6drhke5LiXNBu4ZsZSnZLuKx8+zGTZPFep20Na3
         806G5z1ocCTGlcBnIPOKNddEcZnPMRwUJtJ6SLhIycBRBlHwhGd7QAyhSGAH8wulj27K
         OF3/BjlF7Q40KH5BaO1E7c21EkZm/Wt5NSvNomhObpieAX7qyeUymJ1GyCvSRhDe8f4n
         g59U8OC1iyYHyJuXpMu3r/yy7gb/8xNk1UilH3BZvlcpqzNJiqsJ/T8gp1CalRDkfiSy
         cXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2/aJ8EhPXWJDHJjMug2BHW5hCYqrn5DszcYGNPWtII=;
        b=mlcLHXmMnPLb2FPJN8Txkgu1ST0o4RH8ttQ0qdajr7eMsTsc7MdhQ35PTTopSFP8Td
         +chTilw6coHvw8uViCXg7W/7JKOexrLb5fuhvfoFp9lexkuoR8KN/TsZvgrhQciSdgf/
         GrqY9PDkSGQVWlXKATXvgHb18nDPylONgclWUJHlkcBGt7phwmVgcBDINDXaV5TNlz7c
         NkSqcWnYk9GrNrK00uGtC95/LFO1AEzsHfnA3gKDXWDEFudQef39mWVMi4dNyFi00hcE
         YEcX8SfoKjVEfnoZ4G1972eRqudjc2CcZty5lJlT7qQqnsQQkaJFEBodATEhzFon1cbp
         XqxA==
X-Gm-Message-State: AFqh2kospWqeLvbeoyzWp5G4ag0hd3bMYVCmKPacF7zGkrOHdfnCM06U
        nDzM+GmCUGwovKQMQz0a5S39vg/uIwF5BWRQDj0tfA==
X-Google-Smtp-Source: AMrXdXuzAiv+U+OU9/u5DElQaTyJnKfTrOPR70wWrkTndA++/rxANgxGvz7rPDRMCAJcDk0BEfeFwQ==
X-Received: by 2002:a5d:4588:0:b0:242:844a:835d with SMTP id p8-20020a5d4588000000b00242844a835dmr30615517wrq.65.1674719921533;
        Wed, 25 Jan 2023 23:58:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm553928wrz.111.2023.01.25.23.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:41 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next v2 01/12] net/mlx5: Change devlink param register/unregister function names
Date:   Thu, 26 Jan 2023 08:58:27 +0100
Message-Id: <20230126075838.1643665-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230126075838.1643665-1-jiri@resnulli.us>
References: <20230126075838.1643665-1-jiri@resnulli.us>
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

The functions are registering and unregistering devlink params, so
change the names accordingly.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c    | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 5bd83c0275f8..91847a3d03a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -869,7 +869,7 @@ void mlx5_devlink_traps_unregister(struct devlink *devlink)
 				    ARRAY_SIZE(mlx5_trap_groups_arr));
 }
 
-int mlx5_devlink_register(struct devlink *devlink)
+int mlx5_devlink_params_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
@@ -902,7 +902,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 	return err;
 }
 
-void mlx5_devlink_unregister(struct devlink *devlink)
+void mlx5_devlink_params_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_max_uc_list_param_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index fd033df24856..1c1b62ee84bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -35,7 +35,7 @@ void mlx5_devlink_traps_unregister(struct devlink *devlink);
 
 struct devlink *mlx5_devlink_alloc(struct device *dev);
 void mlx5_devlink_free(struct devlink *devlink);
-int mlx5_devlink_register(struct devlink *devlink);
-void mlx5_devlink_unregister(struct devlink *devlink);
+int mlx5_devlink_params_register(struct devlink *devlink);
+void mlx5_devlink_params_unregister(struct devlink *devlink);
 
 #endif /* __MLX5_DEVLINK_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 3d5f2a4b1fed..65cd6c393c0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1390,9 +1390,9 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
-	err = mlx5_devlink_register(priv_to_devlink(dev));
+	err = mlx5_devlink_params_register(priv_to_devlink(dev));
 	if (err)
-		goto err_devlink_reg;
+		goto err_devlink_params_reg;
 
 	err = mlx5_register_device(dev);
 	if (err)
@@ -1403,8 +1403,8 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	return 0;
 
 err_register:
-	mlx5_devlink_unregister(priv_to_devlink(dev));
-err_devlink_reg:
+	mlx5_devlink_params_unregister(priv_to_devlink(dev));
+err_devlink_params_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
 err_load:
@@ -1426,7 +1426,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	mutex_lock(&dev->intf_state_mutex);
 
 	mlx5_unregister_device(dev);
-	mlx5_devlink_unregister(priv_to_devlink(dev));
+	mlx5_devlink_params_unregister(priv_to_devlink(dev));
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
-- 
2.39.0

