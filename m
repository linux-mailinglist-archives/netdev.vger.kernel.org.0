Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE767E9FC
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjA0Pu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbjA0Puz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:50:55 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3932710E8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:50:52 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bk15so14830349ejb.9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bObgaqezqXUGw5r672J36v72+vS7i5YpPyQjTXITNVQ=;
        b=XDXFq9P8xrx8PTATWeeUHuThueMOLVCZMysYOmN+qhrFj9Xh1fNqOuhGwps0RqT2N8
         k9ewGh4zPYdOIWupMV9fh4y7WZV1QpEkn/Jq7h9gnmZWA3kjnTBjLcHyuWmuVNb0exDo
         XjzBc+XUUY3ZFCaYriBsxBK9K+oSlG24L3lCmVeYp+pOAvR1+02t6TbjJdujB/Xr2tcV
         o3nzNtDX7jP91OVmlSCwVop4SEc8+PHZChEVul1BjdxyZ/erfw35L2/5GZQq1OMSlWqG
         pWbmSDwISZz288im57w62nIfVpcEreIOpAtsk8Hn+2g737vOqptoj6jjip6BslKSRRlb
         Pbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bObgaqezqXUGw5r672J36v72+vS7i5YpPyQjTXITNVQ=;
        b=O7Q7GBuwccGI+ZbI+HlEypXjdqd8uwOCYe+x7aIRYuK15VUPlMaC7mPaoQXXpe3WRj
         r3KWb1zh82p2UUimOTARqiYK3Gywie5YOKFVTnmiAep+WI89vEC2lJ7CB9VSyHFgjl3a
         qtsR+MuJO1LiHgxAm1mtbr0t6yBgNLJ5xkf/gCvP+I9dZBAeyacAwn0zcFHrPfDBrKox
         H1TjaL1k+GRwUSJj6QOo3gSYcrNc7b7BRaR3xPH5eW+oMG2eDTXkOf7VT2MbtowzJ2gi
         CaCw4veWBgNMEIuV9HMdwcxe4du3ZvKMWTsT/MuFL3fmmcmzOKD9Y/unl1jXJdUPo+Wk
         h3ew==
X-Gm-Message-State: AFqh2kqBjIHq3FwDj6wUf7ryi/Z+tvEQI2WzW785Jq2E6CrZNwWZsLB6
        1zDlBNCJmbhZWuvHXIGD+c6lYzxR+mJOekGRmWI=
X-Google-Smtp-Source: AMrXdXucARrEWJgXwB/6KzTJLVSAexrJmUWxWx34I2gMQC6/2kaPLxBYIoPcEzzribXezqB3bbv9Rw==
X-Received: by 2002:a17:907:3f20:b0:7c0:f7b0:9aed with SMTP id hq32-20020a1709073f2000b007c0f7b09aedmr54422321ejc.55.1674834650518;
        Fri, 27 Jan 2023 07:50:50 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fx18-20020a170906b75200b0085bfa1b8daesm2422901ejb.83.2023.01.27.07.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:50:49 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, mailhol.vincent@wanadoo.fr
Subject: [patch net-next 3/3] devlink: remove devlink features
Date:   Fri, 27 Jan 2023 16:50:42 +0100
Message-Id: <20230127155042.1846608-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230127155042.1846608-1-jiri@resnulli.us>
References: <20230127155042.1846608-1-jiri@resnulli.us>
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

Devlink features were introduced to disallow devlink reload calls of
userspace before the devlink was fully initialized. The reason for this
workaround was the fact that devlink reload was originally called
without devlink instance lock held.

However, with recent changes that converted devlink reload to be
performed under devlink instance lock, this is redundant so remove
devlink features entirely.

Note that mlx5 used this to enable devlink reload conditionally only
when device didn't act as multi port slave. Move the multi port check
into mlx5_devlink_reload_down() callback alongside with the other
checks preventing the device from reload in certain states.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  1 -
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  1 -
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  1 -
 drivers/net/ethernet/mellanox/mlx4/main.c     |  1 -
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 +++++----
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  1 -
 drivers/net/netdevsim/dev.c                   |  1 -
 include/net/devlink.h                         |  2 +-
 net/devlink/core.c                            | 19 -------------------
 net/devlink/devl_internal.h                   |  1 -
 net/devlink/leftover.c                        |  3 ---
 12 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 26913dc816d3..8b3e7697390f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -1303,7 +1303,6 @@ int bnxt_dl_register(struct bnxt *bp)
 	if (rc)
 		goto err_dl_port_unreg;
 
-	devlink_set_features(dl, DEVLINK_F_RELOAD);
 out:
 	devlink_register(dl);
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 3d3b69605423..9a939c0b217f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -114,7 +114,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index a6c3c5e8f0ab..1b535142c65a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -116,7 +116,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index ce753d23aba9..88497363fc4c 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1376,7 +1376,6 @@ void ice_devlink_register(struct ice_pf *pf)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 6152f77dcfd8..277738c50c56 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4031,7 +4031,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_params_unregister;
 
 	pci_save_state(pdev);
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
 	devlink_register(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 95a69544a685..63fb7912b032 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -156,6 +156,11 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		return -EOPNOTSUPP;
 	}
 
+	if (mlx5_core_is_mp_slave(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported for multi port slave");
+		return -EOPNOTSUPP;
+	}
+
 	if (pci_num_vf(pdev)) {
 		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is unfavorable");
 	}
@@ -744,7 +749,6 @@ void mlx5_devlink_traps_unregister(struct devlink *devlink)
 
 int mlx5_devlink_params_register(struct devlink *devlink)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
 	err = devl_params_register(devlink, mlx5_devlink_params,
@@ -762,9 +766,6 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 	if (err)
 		goto max_uc_list_err;
 
-	if (!mlx5_core_is_mp_slave(dev))
-		devlink_set_features(devlink, DEVLINK_F_RELOAD);
-
 	return 0;
 
 max_uc_list_err:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f8623e8388c8..42422a106433 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2285,7 +2285,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	}
 
 	if (!reload) {
-		devlink_set_features(devlink, DEVLINK_F_RELOAD);
 		devl_unlock(devlink);
 		devlink_register(devlink);
 	}
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f88095b0f836..6045bece2654 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1609,7 +1609,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_hwstats_exit;
 
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
 	return 0;
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ab654cf552b8..2e85a5970a32 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1645,7 +1645,7 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 {
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
-void devlink_set_features(struct devlink *devlink, u64 features);
+
 int devl_register(struct devlink *devlink);
 void devl_unregister(struct devlink *devlink);
 void devlink_register(struct devlink *devlink);
diff --git a/net/devlink/core.c b/net/devlink/core.c
index 6c0e2fc57e45..aeffd1b8206d 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -125,23 +125,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
 	goto retry;
 }
 
-/**
- *	devlink_set_features - Set devlink supported features
- *
- *	@devlink: devlink
- *	@features: devlink support features
- *
- *	This interface allows us to set reload ops separatelly from
- *	the devlink_alloc.
- */
-void devlink_set_features(struct devlink *devlink, u64 features)
-{
-	WARN_ON(features & DEVLINK_F_RELOAD &&
-		!devlink_reload_supported(devlink->ops));
-	devlink->features = features;
-}
-EXPORT_SYMBOL_GPL(devlink_set_features);
-
 /**
  * devl_register - Register devlink instance
  * @devlink: devlink
@@ -303,7 +286,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 * all devlink instances from this namespace into init_net.
 	 */
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
-		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		devl_lock(devlink);
 		err = 0;
 		if (devl_is_registered(devlink))
@@ -313,7 +295,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 					     &actions_performed, NULL);
 		devl_unlock(devlink);
 		devlink_put(devlink);
-
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 	}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index d0d889038138..ba161de4120e 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -38,7 +38,6 @@ struct devlink {
 	struct list_head trap_policer_list;
 	struct list_head linecard_list;
 	const struct devlink_ops *ops;
-	u64 features;
 	struct xarray snapshot_ids;
 	struct devlink_dev_stats stats;
 	struct device *dev;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 4f78ef5a46af..92210587d349 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4387,9 +4387,6 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	u32 actions_performed;
 	int err;
 
-	if (!(devlink->features & DEVLINK_F_RELOAD))
-		return -EOPNOTSUPP;
-
 	err = devlink_resources_validate(devlink, NULL, info);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
-- 
2.39.0

