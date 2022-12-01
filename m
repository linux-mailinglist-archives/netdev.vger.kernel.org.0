Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD3163F598
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLAQrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiLAQq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:28 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D63EB0A34
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:20 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m19so3121271edj.8
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ygLtmrXreeOGJfTMICC9dLuZQkYOGBhSqOeROj74xaU=;
        b=LgMtIrSmjc52OY9p0EfDV2FXsMdt3mpB8vDif7g8h9hQaIf3Gkl/UqnTV6w3Ttozi7
         O5vY5w/EGmkV0pXsOCtWhOrcYIE2x+hUFlfO72b4xUwQksYrZTkUs1VLiuM3+9j7BtxA
         iLuTjwBc3GVqPz/5qY4LsHf0spuFooUlf0UYm5sJGQXewN4e6aZLz5+8TCuBF4y26zgF
         IBk2V68XCk1iSShlovVQIbeelhprhooZe+GSOIWef0gOoSxdEewV/LKSoUzoqkUUhEyT
         1znwB4QVQCrrIt4Ef2zGlDWQZ2coZQADHf1ZsDFYXdLEERyZ+G3QgxO+7w5vDsfXW8ST
         X0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ygLtmrXreeOGJfTMICC9dLuZQkYOGBhSqOeROj74xaU=;
        b=IfL7qPDbW19q+rttPb7YqksoWBfEfU68UPO5F22YumkUCka2mQnuEd+LTOHTCYquMk
         +A8sgx7dHHAWUzxMlhlS0kj2s9eFFJxrgmvvxXKl79xc0T/QxK8JYgqj4iflPh3FTbIf
         Tz8GHl6xWfD25Wv5AUQYoAAXLtdZZiGaqYSh2X5Uscn38rACZcSWqRttyy5CNPZFtAEm
         tPVGha7VZdyGfSAfrnGkg8gQXHNEAq9XGIWNKzca6Zsg2nGOsZCRGYoofN1n8QXAiEGt
         VnXAk2WyO6QJ4o4Krc9lqVTsRD3HO73mQLVMEd5vIQfIHGfpgH8EMyKGgUHef83W4IkO
         iWxg==
X-Gm-Message-State: ANoB5pnHiXqSAfhEBThk/9CYHnCNA4H1jAY8gZLWnzklsZo5GgKAn4E2
        sdHWFzI88zXU72hJ+SuwulnVDiuTEYNKsslc
X-Google-Smtp-Source: AA0mqf4F8Au6mif6pVf2xP0mfKd4eQAdOOkrKPkB8tJGl7YAzfLxV99wz44O6H7uLM+/orlOU/37mQ==
X-Received: by 2002:a05:6402:e0d:b0:466:4168:6ea7 with SMTP id h13-20020a0564020e0d00b0046641686ea7mr855238edh.273.1669913179093;
        Thu, 01 Dec 2022 08:46:19 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n22-20020a05640206d600b0046bada4b121sm1928118edy.54.2022.12.01.08.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:18 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 5/7] mlx4: Reorder devl_port_register/unregister() calls to be done when devlink is registered
Date:   Thu,  1 Dec 2022 17:46:06 +0100
Message-Id: <20221201164608.209537-6-jiri@resnulli.us>
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
 drivers/net/ethernet/mellanox/mlx4/main.c | 60 +++++++++++++----------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 3ae246391549..14f1c76a50eb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3730,14 +3730,13 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 }
 
 static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
-			   struct mlx4_priv *priv)
+			   unsigned int *total_vfs,
+			   int *nvfs, struct mlx4_priv *priv)
 {
 	int err;
-	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
 	int prb_vf[MLX4_MAX_PORTS + 1] = {0, 0, 0};
 	const int param_map[MLX4_MAX_PORTS + 1][MLX4_MAX_PORTS + 1] = {
 		{2, 0, 0}, {0, 1, 2}, {0, 1, 2} };
-	unsigned total_vfs = 0;
 	unsigned int i;
 
 	pr_info(DRV_NAME ": Initializing %s\n", pci_name(pdev));
@@ -3752,8 +3751,8 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	 * per port, we must limit the number of VFs to 63 (since their are
 	 * 128 MACs)
 	 */
-	for (i = 0; i < ARRAY_SIZE(nvfs) && i < num_vfs_argc;
-	     total_vfs += nvfs[param_map[num_vfs_argc - 1][i]], i++) {
+	for (i = 0; i <= MLX4_MAX_PORTS && i < num_vfs_argc;
+	     *total_vfs += nvfs[param_map[num_vfs_argc - 1][i]], i++) {
 		nvfs[param_map[num_vfs_argc - 1][i]] = num_vfs[i];
 		if (nvfs[i] < 0) {
 			dev_err(&pdev->dev, "num_vfs module parameter cannot be negative\n");
@@ -3770,10 +3769,10 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 			goto err_disable_pdev;
 		}
 	}
-	if (total_vfs > MLX4_MAX_NUM_VF) {
+	if (*total_vfs > MLX4_MAX_NUM_VF) {
 		dev_err(&pdev->dev,
 			"Requested more VF's (%d) than allowed by hw (%d)\n",
-			total_vfs, MLX4_MAX_NUM_VF);
+			*total_vfs, MLX4_MAX_NUM_VF);
 		err = -EINVAL;
 		goto err_disable_pdev;
 	}
@@ -3828,14 +3827,14 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 		/* When acting as pf, we normally skip vfs unless explicitly
 		 * requested to probe them.
 		 */
-		if (total_vfs) {
+		if (*total_vfs) {
 			unsigned vfs_offset = 0;
 
-			for (i = 0; i < ARRAY_SIZE(nvfs) &&
+			for (i = 0; i <= MLX4_MAX_PORTS &&
 			     vfs_offset + nvfs[i] < extended_func_num(pdev);
 			     vfs_offset += nvfs[i], i++)
 				;
-			if (i == ARRAY_SIZE(nvfs)) {
+			if (i == MLX4_MAX_PORTS + 1) {
 				err = -ENODEV;
 				goto err_release_regions;
 			}
@@ -3857,15 +3856,8 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	if (err)
 		goto err_crdump;
 
-	err = mlx4_load_one(pdev, pci_dev_data, total_vfs, nvfs, priv, 0);
-	if (err)
-		goto err_catas;
-
 	return 0;
 
-err_catas:
-	mlx4_catas_end(&priv->dev);
-
 err_crdump:
 	mlx4_crdump_end(&priv->dev);
 
@@ -3994,6 +3986,8 @@ static const struct devlink_ops mlx4_devlink_ops = {
 
 static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
+	unsigned int total_vfs = 0;
 	struct devlink *devlink;
 	struct mlx4_priv *priv;
 	struct mlx4_dev *dev;
@@ -4024,9 +4018,9 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = devlink_params_register(devlink, mlx4_devlink_params,
 				      ARRAY_SIZE(mlx4_devlink_params));
 	if (ret)
-		goto err_devlink_unregister;
+		goto err_persist_free;
 	mlx4_devlink_set_params_init_values(devlink);
-	ret =  __mlx4_init_one(pdev, id->driver_data, priv);
+	ret =  __mlx4_init_one(pdev, id->driver_data, &total_vfs, nvfs, priv);
 	if (ret)
 		goto err_params_unregister;
 
@@ -4034,12 +4028,21 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
 	devlink_register(devlink);
+	devl_lock(devlink);
+	ret = mlx4_load_one(pdev, priv->pci_dev_data, total_vfs, nvfs, priv, 0);
+	devl_unlock(devlink);
+	if (ret)
+		goto err_devlink_unregister;
+
 	return 0;
 
+err_devlink_unregister:
+	devlink_unregister(devlink);
+	devl_lock(devlink);
 err_params_unregister:
 	devlink_params_unregister(devlink, mlx4_devlink_params,
 				  ARRAY_SIZE(mlx4_devlink_params));
-err_devlink_unregister:
+err_persist_free:
 	kfree(dev->persist);
 err_devlink_free:
 	devl_unlock(devlink);
@@ -4146,6 +4149,16 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(priv);
 	int active_vfs = 0;
 
+	/* device marked to be under deletion running now without the lock
+	 * letting other tasks to be terminated
+	 */
+	devl_lock(devlink);
+	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
+		mlx4_unload_one(pdev);
+	else
+		mlx4_info(dev, "%s: interface is down\n", __func__);
+	devl_unlock(devlink);
+
 	devlink_unregister(devlink);
 
 	devl_lock(devlink);
@@ -4165,13 +4178,6 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 		}
 	}
 
-	/* device marked to be under deletion running now without the lock
-	 * letting other tasks to be terminated
-	 */
-	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
-		mlx4_unload_one(pdev);
-	else
-		mlx4_info(dev, "%s: interface is down\n", __func__);
 	mlx4_catas_end(dev);
 	mlx4_crdump_end(dev);
 	if (dev->flags & MLX4_FLAG_SRIOV && !active_vfs) {
-- 
2.37.3

