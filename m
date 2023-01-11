Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475776653CE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjAKFjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbjAKFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:37:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EDFB7D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39C8861A5A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C81C433EF;
        Wed, 11 Jan 2023 05:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415052;
        bh=vxUnR22dkaBf7JcyyWSkaIOzVNRJhEvqkPKrqlXBTe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxurnkUZKw0XlerPVC9X7jonBdJwuHPFUWwG/sQEDwwqffI9MsOWM8tZ5h8yb01x6
         BRsWHC5dceec5I8h5oG3DP0aKvC/ttIcA24BaIuZ4UUsm4TuEX1ss7cOo0gDbn5CHf
         RVz/pP8YRlEHaSYl3LZZCq5t+elIVeuFnAkO+RRXudrOW2OXaO3KL81q2OtC7EIQh8
         C7sL2Vm6NiRaLYBdifabyj6JBw+JUHf/+1qCkY6smbYoD3q9Ge8L0l0iCNsejxRtOH
         U3kZAxJp2A0dfi/kt0HZeGGeQWBGJ9VahZxGhwnGb+pasQkcipt9BCXluuosmsxgx7
         47tF0P55yqgig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Add Ethernet driver debugfs
Date:   Tue, 10 Jan 2023 21:30:34 -0800
Message-Id: <20230111053045.413133-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Similar to the mlx5_core debugfs, lay the groundwork for mlx5e debugfs
files under /sys/kernel/debug/mlx5/<pci>/nic/..

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2d77fb8a8a01..7cbd71f0b8ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -968,6 +968,7 @@ struct mlx5e_priv {
 	struct mlx5e_scratchpad    scratchpad;
 	struct mlx5e_htb          *htb;
 	struct mlx5e_mqprio_rl    *mqprio_rl;
+	struct dentry             *dfs_root;
 };
 
 struct mlx5e_rx_handlers {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cff5f2e29e1e..16c8bbad5b33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -35,6 +35,7 @@
 #include <net/vxlan.h>
 #include <net/geneve.h>
 #include <linux/bpf.h>
+#include <linux/debugfs.h>
 #include <linux/if_bridge.h>
 #include <linux/filter.h>
 #include <net/page_pool.h>
@@ -5931,6 +5932,9 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	priv->profile = profile;
 	priv->ppriv = NULL;
 
+	priv->dfs_root = debugfs_create_dir("nic",
+					    mlx5_debugfs_get_dev_root(priv->mdev));
+
 	err = mlx5e_devlink_port_register(priv);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
@@ -5968,6 +5972,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 err_devlink_cleanup:
 	mlx5e_devlink_port_unregister(priv);
 err_destroy_netdev:
+	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
 	return err;
 }
@@ -5982,6 +5987,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	mlx5e_suspend(adev, state);
 	priv->profile->cleanup(priv);
 	mlx5e_devlink_port_unregister(priv);
+	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
 }
 
-- 
2.39.0

