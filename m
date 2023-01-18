Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9675672127
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjARPYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjARPXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:51 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824301CAD7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:26 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id kt14so25165751ejc.3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06eQ4ecK7MZQkmWCPPXkPy1meyk03G3e4fyXRAsTdFs=;
        b=lrL3RqtzHuANDGCVpcvUi99lxIAh36mLnJxKgLE45X5IxJoRoSOfJo1addphmeOGW6
         8LjWpGJKWthMfobysVQDH5NP/rF2UdvNVhkX3Vvrnzr+yEca20W4U7rmc4uZi4wvgODb
         88/FtmzEaQpi0L7nxcjxJX/NFNtJmcqoHdbGI7JNCjDrnhKjaI0unAx5+yaYlDbDVpvc
         yRfOV055V2tG9mAreookG315Bc1p0NEseeucWH8C0YS9MMJDjXF77sSDO6IOYqz6r32A
         Q27w5QaHLB249XIKF4JXnOJ43jTzZpwqB3cKFAmWrjIMq7tIgI/sJHfhg5DsPotyMHiC
         /nBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06eQ4ecK7MZQkmWCPPXkPy1meyk03G3e4fyXRAsTdFs=;
        b=KiBG5WugC4w9o7GrnIWkvmIvOqkrWfVy7uip1lFI/6xNG1zoPIz1W2H4tVh9WhBm/R
         ATXPsmQO4ZejvkIw+3FX+E0YY8HwHYzIi0s4ni2BAttxWe9b+SZqnYIWmpA6RHag6rcH
         f6Fp17gfx0I3jIaNdFMgZnblJdza3WfscKKK594MXCIG022DYzLmmLTRIHHCnazDNQSo
         25uFQ9iEOwklA9CaDJPpi7DMHDD6XTBm3Tw1WGKgJ6TDD6T/3Fqj+85TkbvW3GupTuL1
         OAgTmCfD2uF5MkVPz7zExpDXswTAe8w0eeebZ+q8ANIe7iH2DTX8cDDTyFEP/7SyOxxv
         EXkg==
X-Gm-Message-State: AFqh2kpLkQS7tYvMJ6nyFUH42rIOzIMqwfE5JJq9dU2SIHk7QECHxxTR
        7OCi883gFUoz0pea1USsndfKVJ26zEn4aTwHp3sdFg==
X-Google-Smtp-Source: AMrXdXt7uWuL2vv0tf+13Fj9m1fRJEKmwjk5GnvecYAmaUJD8nG1bDZl7wXIdUWa+OKfb1ATdOkZlg==
X-Received: by 2002:a17:906:81b:b0:869:a799:1f85 with SMTP id e27-20020a170906081b00b00869a7991f85mr20701560ejd.76.1674055285110;
        Wed, 18 Jan 2023 07:21:25 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709062bcc00b007ae38d837c5sm15152923ejg.174.2023.01.18.07.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:24 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 04/12] net/mlx5: Remove MLX5E_LOCKED_FLOW flag
Date:   Wed, 18 Jan 2023 16:21:07 +0100
Message-Id: <20230118152115.1113149-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
References: <20230118152115.1113149-1-jiri@resnulli.us>
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

The MLX5E_LOCKED_FLOW flag is not checked anywhere now so remove it
entirely.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v4->v5:
- new patch
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 14 ++------------
 include/linux/mlx5/driver.h                   |  4 ----
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 5b6b0b126e52..2b444fb12388 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -349,7 +349,6 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&mlx5_intf_mutex);
 	priv->flags &= ~MLX5_PRIV_FLAGS_DETACH;
-	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	for (i = 0; i < ARRAY_SIZE(mlx5_adev_devices); i++) {
 		if (!priv->adev[i]) {
 			bool is_supported = false;
@@ -397,7 +396,6 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 			break;
 		}
 	}
-	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	mutex_unlock(&mlx5_intf_mutex);
 	return ret;
 }
@@ -412,7 +410,6 @@ void mlx5_detach_device(struct mlx5_core_dev *dev)
 
 	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&mlx5_intf_mutex);
-	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	for (i = ARRAY_SIZE(mlx5_adev_devices) - 1; i >= 0; i--) {
 		if (!priv->adev[i])
 			continue;
@@ -441,7 +438,6 @@ void mlx5_detach_device(struct mlx5_core_dev *dev)
 		del_adev(&priv->adev[i]->adev);
 		priv->adev[i] = NULL;
 	}
-	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	priv->flags |= MLX5_PRIV_FLAGS_DETACH;
 	mutex_unlock(&mlx5_intf_mutex);
 }
@@ -540,22 +536,16 @@ static void delete_drivers(struct mlx5_core_dev *dev)
 int mlx5_rescan_drivers_locked(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
-	int err = 0;
 
 	lockdep_assert_held(&mlx5_intf_mutex);
 	if (priv->flags & MLX5_PRIV_FLAGS_DETACH)
 		return 0;
 
-	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	delete_drivers(dev);
 	if (priv->flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
-		goto out;
-
-	err = add_drivers(dev);
+		return 0;
 
-out:
-	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
-	return err;
+	return add_drivers(dev);
 }
 
 bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b957b8f22a6b..44167760ff29 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -554,10 +554,6 @@ enum {
 	 * creation/deletion on drivers rescan. Unset during device attach.
 	 */
 	MLX5_PRIV_FLAGS_DETACH = 1 << 2,
-	/* Distinguish between mlx5e_probe/remove called by module init/cleanup
-	 * and called by other flows which can already hold devlink lock
-	 */
-	MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW = 1 << 3,
 };
 
 struct mlx5_adev {
-- 
2.39.0

