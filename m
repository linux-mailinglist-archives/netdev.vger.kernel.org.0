Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CDC6A1317
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjBWWxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBWWxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:53:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C0E14228
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94356B81B5E
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D83C433D2;
        Thu, 23 Feb 2023 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192783;
        bh=pw/Ogl/eq/epEKvlQV+TB9F4B7AhAw8FNQIxAtfBasw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjhlvLi3GY6Nr5WuPBzwKtv+td5iDbbz+k9HBuV+8BefTBll1+pGWzGsHGhZvvXa9
         njyazvAJCMQpAesNEC/YuWf0ViuQFfpGWkgMVuekR1N4pCkvCiKCbItF7q9t7U18sA
         sPpE+nkiEDvdw7JNhkxmp61cZ9TxTqQrshfL9co3OBWFdE3EFDMTMPrhTjtfI6W7Ts
         s+1suzLtLHHMm0pccRbLFK+nyi/m/fe+wmCPZkTnYXioMaVG2ECnG4LzDiLbL64I1h
         pIKO6ivMANOFe0lN1gfXJ+kohZLh3dO9LnlOab1yjXKQp70mnWJmqDHjqYjXDU+vAg
         DzzrhgVcE8N8Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net 08/10] net/mlx5: ECPF, wait for VF pages only after disabling host PFs
Date:   Thu, 23 Feb 2023 14:52:45 -0800
Message-Id: <20230223225247.586552-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223225247.586552-1-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

Currently,  during the early stages of their unloading, particularly
during SRIOV disablement, PFs/ECPFs wait on the release of all of
their VFs memory pages. Furthermore, ECPFs are considered the page
supplier for host VFs, hence the host VFs memory pages are freed only
during ECPF cleanup when host interfaces get disabled.

Thus, disabling SRIOV early in unload timeline causes the DPU ECPF
to stall on driver unload while waiting on the release of host VF pages
that won't be freed before host interfaces get disabled later on.

Therefore, for ECPFs, wait on the release of VFs pages only after the
disablement of host PFs during ECPF cleanup flow. Then, host PFs and VFs
are disabled and their memory shall be freed accordingly.

Fixes: 143a41d7623d ("net/mlx5: Disable SRIOV before PF removal")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c  | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index 9a3878f9e582..7c9c4e40c019 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -98,4 +98,8 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_HOST_PF]);
 	if (err)
 		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n", err);
+
+	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]);
+	if (err)
+		mlx5_core_warn(dev, "Timeout reclaiming external host VFs pages err(%d)\n", err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 3008e9ce2bbf..20d7662c10fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -147,6 +147,10 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 
 	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
+	/* For ECPFs, skip waiting for host VF pages until ECPF is destroyed */
+	if (mlx5_core_is_ecpf(dev))
+		return;
+
 	if (mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
-- 
2.39.1

