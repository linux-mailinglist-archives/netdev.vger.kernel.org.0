Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E185363F599
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiLAQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiLAQqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:34 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298E8BB7F3
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:21 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fy37so5530448ejc.11
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CNPSlCrIDcuuFzvFx7UDX8BzvGAC3ERSLmueAm2Jm4w=;
        b=tbKEro8Nlo8qaesPtCltren2H0LgtuF5zV1MyQonM91wUHmu+OoM4u8HlRR/vzL8+E
         km+YQ3UoGRJ4rQvjN/vaBQWZG3bYkeRcv0cTVn5CupjArApjOsumz5DuAvd3hRagA0L9
         m3gYvpWpuhazsGuo/J3BMX2x7A66UsFdndnE58Sazae9Vau3H0sljt+QG7+49pI2EjiL
         82GGeDti42+h94Nn1Hp11SOjgMHAyUHUitVqDsaLMi166Rf913DZ2oRIrROAYbl1quMZ
         embgyb12+oWmFrP0Bja8RY2XZj/tvyfPRPB3T6uc/pPTCO5MuJ16abkNZrys32oo1xmb
         +VLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNPSlCrIDcuuFzvFx7UDX8BzvGAC3ERSLmueAm2Jm4w=;
        b=pSAKbW/1S9LUgoK31XemxFf/fuAWt5s/4FxB7Od3LCdZ+bdMJMGcdj2hEPA8xjv9Qs
         +W9FKPBmEZwsqF6KCBW5bMeN8eyWXrbv/aY8VdXPhEROSqnUPu8m82j7XZGxT+tYLhWb
         4higMUVnTa8XAc2tI4iK8v0Q6bQYdzsdMZgSEpKO7umEaZSCfx7NlGWaUZ+6foh6Sfcw
         R7G4GZMWcl/q7XOFOHgujfZsIv+LfPKZRuWrvnqKJ4kAr7HyGNWpIDcSCWZZJe4NUgkL
         TocyeY3C4X2RR+UI25JNpYbkRi0Y5Prt35z5c1rovAL3u49fR9EQo2BekjMhsejDOWda
         5E7Q==
X-Gm-Message-State: ANoB5pmhX6kTCdpMjfJipZw0JhFBX7AwCdcOyScl/+5V7FxyWDakqaZF
        WUJSFrcISou3RslF6FQh3dDFCVGi9kSINxKO
X-Google-Smtp-Source: AA0mqf4YJbcK3rV9hF5fKGTaiutPVVBVlXk9LZZjt1raKzIo51eRITzfaIhyjFhjyrg76ioaeh+7oQ==
X-Received: by 2002:a17:906:950a:b0:7ab:2559:8bc4 with SMTP id u10-20020a170906950a00b007ab25598bc4mr40343324ejx.682.1669913180685;
        Thu, 01 Dec 2022 08:46:20 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s17-20020a05640217d100b004585eba4baesm1899259edy.80.2022.12.01.08.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:20 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 6/7] mlx5: Reorder devl_port_register/unregister() calls to be done when devlink is registered
Date:   Thu,  1 Dec 2022 17:46:07 +0100
Message-Id: <20221201164608.209537-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221201164608.209537-1-jiri@resnulli.us>
References: <20221201164608.209537-1-jiri@resnulli.us>
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

Move the code so devl_port_register/unregister() are called only
then devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c   | 10 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c  | 17 ++++++++++-------
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c |  9 +++++++++
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 0571e40c6ee5..dd3801198898 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -444,11 +444,14 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 {
 	int ret;
 
-	devl_assert_locked(priv_to_devlink(dev));
+	devl_lock(priv_to_devlink(dev));
+	mutex_lock(&dev->intf_state_mutex);
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	ret = mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
+	mutex_unlock(&dev->intf_state_mutex);
+	devl_unlock(priv_to_devlink(dev));
 	if (ret)
 		mlx5_unregister_device(dev);
 
@@ -457,11 +460,14 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
-	devl_assert_locked(priv_to_devlink(dev));
+	devl_lock(priv_to_devlink(dev));
+	mutex_lock(&dev->intf_state_mutex);
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
+	mutex_unlock(&dev->intf_state_mutex);
+	devl_unlock(priv_to_devlink(dev));
 }
 
 static int add_drivers(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7f5db13e3550..f6f37289b49d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1392,16 +1392,10 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	if (err)
 		goto err_devlink_reg;
 
-	err = mlx5_register_device(dev);
-	if (err)
-		goto err_register;
-
 	mutex_unlock(&dev->intf_state_mutex);
 	devl_unlock(devlink);
 	return 0;
 
-err_register:
-	mlx5_devlink_unregister(priv_to_devlink(dev));
 err_devlink_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
@@ -1423,7 +1417,6 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	devl_lock(devlink);
 	mutex_lock(&dev->intf_state_mutex);
 
-	mlx5_unregister_device(dev);
 	mlx5_devlink_unregister(priv_to_devlink(dev));
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1747,8 +1740,17 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 	devlink_register(devlink);
+	err = mlx5_register_device(dev);
+	if (err) {
+		mlx5_core_err(dev, "mlx5_register_device failed with error code %d\n",
+			      err);
+		goto err_register_device;
+	}
+
 	return 0;
 
+err_register_device:
+	devlink_unregister(devlink);
 err_init_one:
 	mlx5_pci_close(dev);
 pci_init_err:
@@ -1771,6 +1773,7 @@ static void remove_one(struct pci_dev *pdev)
 	 */
 	mlx5_drain_fw_reset(dev);
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_unregister_device(dev);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 7b4783ce213e..90fcb30f7481 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -46,9 +46,17 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
 	}
+
 	devlink_register(devlink);
+
+	err = mlx5_register_device(mdev);
+	if (err)
+		goto register_device_err;
+
 	return 0;
 
+register_device_err:
+	devlink_unregister(devlink);
 init_one_err:
 	iounmap(mdev->iseg);
 remap_err:
@@ -63,6 +71,7 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
 
+	mlx5_unregister_device(sf_dev->mdev);
 	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
-- 
2.37.3

