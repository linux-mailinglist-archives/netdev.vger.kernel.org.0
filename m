Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7B67B3FF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbjAYOOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYOOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:20 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC544521E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:19 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mp20so47935709ejc.7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=texm64qkwn2eutNOQf+kT9c66NVFvH8Qhpt+9aZcEjI=;
        b=5vQm8QcNpt/Qw8ux7bkBOfxBodhKX1dLyPhQyNADwp6GswHoTmay8/rKinpCSm9uu/
         RHdGUhxC/XiCj/1pQ75jm1tkWK1I6lO+12T+/yoUnwvg+z/c3jc3uQqOx6Huf+rCY3d5
         MMQ3AH487NXglL6vXG3L9v81F38C46coTJ3qhiPQgTi7VeRIwqIGN9lyCTm3dagp0vNC
         ZvXTb53W5hOz0HjQSIPppDdo2fwvjmTNgDW/wjmOsgmYebjyX5uyDRu6VLDDh+r64Kp/
         45CL3250E2mYIIrBYh/+dCl8+xGYuu9c1YeOZgUfiFo9RgfCb+0UQ5quq3DEX+C57V30
         DgWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=texm64qkwn2eutNOQf+kT9c66NVFvH8Qhpt+9aZcEjI=;
        b=b6DsVce/E9WQBqt1cLZ84mBOTTn1ZanZAyuWZDtNtNcsWse64C5uwjcpcz7Ds2xueJ
         teASwt6pz3odSzLx3pAkxY2BmvFAS1S1UBGBx9Gi9SrixkanduS4TOPLmJ8hWJ1FsTLh
         0fg4aQE/fs5A55+gvNhy0sS9TmUvUISsee0NIXNAKeIQpThJcqeJDvmVEW9ed2nvPRe2
         jYR7YzOIK2I1USYsOAinbqSIdUYK1Go++OMjlSzdpl67292wJSEl9X5P5Km101C1H96b
         4+kjOGWq0lXIfeBpa0q8Y2qB/m/h2OBwxDB8Hd0vSR0v7gDRy31/1j/PDrKGaJtU1Sxe
         fknQ==
X-Gm-Message-State: AFqh2kp5QFsNvjynvPD+l0Sm3Ljwtk+o6yM396UXGoRAK8LilornPFiz
        xynBD3rINvYks90RawuzzdsS8LrM4WjQQWCGMzc=
X-Google-Smtp-Source: AMrXdXuDHulHEWksshgkl201oCq9Lo8vzztgs9CHR8r+XR0GWIRSbGaNKin4L/MNSRR/8wZpMPJH2w==
X-Received: by 2002:a17:906:4d0a:b0:84d:3e38:2f0c with SMTP id r10-20020a1709064d0a00b0084d3e382f0cmr47191900eju.67.1674656057979;
        Wed, 25 Jan 2023 06:14:17 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n3-20020a1709065e0300b0086ffe3a99f9sm2418780eju.82.2023.01.25.06.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:17 -0800 (PST)
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
Subject: [patch net-next 01/12] net/mlx5: Change devlink param register/unregister function names
Date:   Wed, 25 Jan 2023 15:14:01 +0100
Message-Id: <20230125141412.1592256-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
References: <20230125141412.1592256-1-jiri@resnulli.us>
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

