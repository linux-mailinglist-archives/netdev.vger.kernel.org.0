Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C61642BA1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiLEP0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiLEP0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:26:02 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8556C1F62D
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:21 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s5so16190547edc.12
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOFNZ9+P1OJPh5tiaCUdPCQ2B64/GXpoReTjh58BXUA=;
        b=55Sc71SnzujnrauDT5SPpdhmSzPKOeUYThxWRQG40Z03RR1NjUgkU6mvlgbcfgiSOE
         U658kJDcRTFfW1dxnenF4+1bySMz2MS6j6C18V/OGbWs3Mm5o3RA3GgDPN3kO2am0Bmw
         GLXbzVFZsvyY8he0h3SgG91B6m8RQfEwatk5y/euyQzLw24mzuH0B2qTN/4/JyT1eIr+
         9/HFoQbx0wdnKthCbYACrX5vjOw7eQEI85XitJ4S6q7tcU4WYh77ERuUPcl2VuqnVZBx
         IHJpYfb3phCCLSgCcKpJUEfvqomb9D2Z2McGNFHOJcymVQCxg54K7Q7AlggvK/cM1ceq
         GQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOFNZ9+P1OJPh5tiaCUdPCQ2B64/GXpoReTjh58BXUA=;
        b=RA13m4a/F2u3FywVz+tQSNdr6ck1ZvcIIOkWrkEZMz3ILM//r5PYbCKy0TUMUaPNVM
         1/xL2fiP7v3a2OWJ/I0nwM57rGvxolV5TGw49fTzkID2x0QfBHvq8BS1iOZrqHPbUs0e
         k1s/vsonCxZsiHxwriNyJDvfJTRt5bMzDSkypVTb+1a07SlIqfQlLq1tfl1DZe95Uxon
         BqHitgPO3sQwnW2pZv548DgVNk8qVt4cZOcHlOCQ+us0OHv2XJMtsXXurFs1L3ZNKi9a
         j5Edw3zc8ToZgh1QknrpFrQDvC4Wl1YH9TJQCEVA2khRTwelWGXtXCYKcfAD8GWls4ND
         BSBg==
X-Gm-Message-State: ANoB5pnmyuprjSomtsMIM6lSlSfeFZcsvDyrd0yL4LBiEGT9V0lDJFLz
        U0wWlukItojpydIJaL7APcQX5rbTalXIBKpsjB6jlA==
X-Google-Smtp-Source: AA0mqf54ADbJ8KPq2J6okxVBZqOt7Gkkz8PBYQhBgNI60HjD4ibzK7ZPmSHQXSBbqpGfJ0YtWx1jFg==
X-Received: by 2002:aa7:db47:0:b0:46b:1ed0:2702 with SMTP id n7-20020aa7db47000000b0046b1ed02702mr31550532edt.177.1670253790174;
        Mon, 05 Dec 2022 07:23:10 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 13-20020a170906328d00b007c0abe46deasm5521165ejw.81.2022.12.05.07.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:23:09 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 5/8] mlx4: call devl_port_register/unregister() on registered instance
Date:   Mon,  5 Dec 2022 16:22:54 +0100
Message-Id: <20221205152257.454610-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
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
RFC->v1:
- shortened patch subject
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

