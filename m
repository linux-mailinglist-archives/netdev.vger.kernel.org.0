Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25522672128
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjARPYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjARPXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:52 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3720E234C8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:32 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qx13so25687460ejb.13
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+v+ljnAZIqf6DLtGNKKMGQkrRt/mSk8P4aJZcppwUk=;
        b=LEWVSnCOR/jup7H/fbvl3OWRmQMbNYP2JimhQELcE4UvD+nSYwAGno12PbzMmfmdCo
         CG/3yAq2sDPbC/aCmFh9cZjB+EMzL/G8iroJ1DjnnHCr09uQVzbSjiAtpaY4nQ71C2KU
         y6d/QBZQKrs2+fZJxbmJR/irW6saU/O5BYzDC/3swkiv8hFlrwP7eMqtQjeb/l3llfWp
         m5iZgVm10KMg4v7Agoefri71WL5fzv6pLBApxCdpu+WBxt/Hd0qejPnQdQfYZyq0oIvR
         UlDEOnNvi5SBWfUc4nHo3a3sNPoftrfyzPnu7k60i0+oBWCH1NxuHmPRjZ/qsaEuMxdl
         jioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+v+ljnAZIqf6DLtGNKKMGQkrRt/mSk8P4aJZcppwUk=;
        b=IViXEdnJSMKwWQpaDLrV7MYUDRvvggXZI3/7tlLSPHsmIs8JV9WxrCD42viSrAgB5W
         E/28m96CiXuOgtFcENK+pgZqwK198/Wpx4ecLxRz1xe4yMDBXqw5n6tLRFW6AX1qgRJo
         0vV+Nm8MgaWpF/pNv2aBFOBFFU/iQOgLlHyQ4SbeDpQWfzGVxCYXF/lcIkDHL/7GBn0I
         ilGUqLNadbNJC73j3eBJiQQGHaKFXrrl3YYKm16qR5Ex4Yam70QS8a5HcnFSFFgSfneh
         ToZD+OKajjD9/OoHM1ng8xC3lGQkYViivEyfK3TXe830xdb3M8X8ubmnxM/ukOEaOLUl
         vMXA==
X-Gm-Message-State: AFqh2krJ2ESJ8CV5yo95lfbww/RJAaCPQSxxIJKJIK8cEy5d18xgNKJb
        HpeR9LRDP4vrqG38iVoqPadkVastl16tCrxaEYscbA==
X-Google-Smtp-Source: AMrXdXt1WycGvX3CU2HE01MeUyhyWYy6nP+LyiuMok9h8F6BV0Dzils7JtmcBUyHqok1un4pGYQVgw==
X-Received: by 2002:a17:906:71a:b0:7c1:6344:84a with SMTP id y26-20020a170906071a00b007c16344084amr7440961ejb.5.1674055290796;
        Wed, 18 Jan 2023 07:21:30 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id ss5-20020a170907038500b00856ad9108e7sm10594967ejb.70.2023.01.18.07.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:30 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 07/12] devlink: remove devl*_port_health_reporter_destroy()
Date:   Wed, 18 Jan 2023 16:21:10 +0100
Message-Id: <20230118152115.1113149-8-jiri@resnulli.us>
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

Remove port-specific health reporter destroy function as it is
currently the same as the instance one so no longer needed. Inline
__devlink_health_reporter_destroy() as it is no longer called from
multiple places.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v4->v5:
- changed mlx5 bits a bit due to changed locking scheme
- added removal of locked port reporter destroy function
v2->v3:
- split from v2 patch #4 - "devlink: remove reporters_lock", no change
---
 .../mellanox/mlx5/core/en/reporter_rx.c       |  2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |  2 +-
 include/net/devlink.h                         |  6 ----
 net/devlink/leftover.c                        | 35 ++-----------------
 4 files changed, 4 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 1ae15b8536a8..95edab4a1732 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -754,6 +754,6 @@ void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
 	if (!priv->rx_reporter)
 		return;
 
-	devlink_port_health_reporter_destroy(priv->rx_reporter);
+	devlink_health_reporter_destroy(priv->rx_reporter);
 	priv->rx_reporter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 60bc5b577ab9..b195dbbf6c90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -609,6 +609,6 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
 	if (!priv->tx_reporter)
 		return;
 
-	devlink_port_health_reporter_destroy(priv->tx_reporter);
+	devlink_health_reporter_destroy(priv->tx_reporter);
 	priv->tx_reporter = NULL;
 }
diff --git a/include/net/devlink.h b/include/net/devlink.h
index d9ea76bea36e..608a0c198be8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1889,12 +1889,6 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter);
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
-void
-devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
-
-void
-devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
-
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter);
 int devlink_health_report(struct devlink_health_reporter *reporter,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 29e2351ee752..a56dd70a10e0 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7442,13 +7442,6 @@ devlink_health_reporter_put(struct devlink_health_reporter *reporter)
 		devlink_health_reporter_free(reporter);
 }
 
-static void
-__devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	list_del(&reporter->list);
-	devlink_health_reporter_put(reporter);
-}
-
 /**
  *	devl_health_reporter_destroy - destroy devlink health reporter
  *
@@ -7459,7 +7452,8 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
 	devl_assert_locked(reporter->devlink);
 
-	__devlink_health_reporter_destroy(reporter);
+	list_del(&reporter->list);
+	devlink_health_reporter_put(reporter);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7474,31 +7468,6 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
-/**
- *	devl_port_health_reporter_destroy - destroy devlink port health reporter
- *
- *	@reporter: devlink health reporter to destroy
- */
-void
-devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	devl_assert_locked(reporter->devlink);
-
-	__devlink_health_reporter_destroy(reporter);
-}
-EXPORT_SYMBOL_GPL(devl_port_health_reporter_destroy);
-
-void
-devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	struct devlink *devlink = reporter->devlink;
-
-	devl_lock(devlink);
-	devl_port_health_reporter_destroy(reporter);
-	devl_unlock(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
-
 static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
 				struct devlink_health_reporter *reporter,
-- 
2.39.0

