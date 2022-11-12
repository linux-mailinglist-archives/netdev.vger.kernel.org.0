Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A866268CD
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbiKLKWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbiKLKV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:21:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091E0186D8
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:21:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC8F8B8069E
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B2CC433C1;
        Sat, 12 Nov 2022 10:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248516;
        bh=zY67By3Pm0mIUQfokBDRjcxRS0ulGZvaf74I3wfk+Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dplwAxST6+tLIuvBmjIXFOKQcgbJdbp1u9Sv/6i6016T7lOMdFSFUqyCPr42O5pXJ
         0R1QdXTv9MoGng7LP2jZWAHSbXGAMkEyFdmhHlEJnwSkYbiPB+LGTLMZCj7n+vacEW
         hDrdTsQgl+f8pINTDJSqKExqJ9bO3NtZTWq3wW2WdvB/GcOrgcRErktHms+hCJeHRh
         95TbX3aUMO4HwG5eChzDdcNYwuabORPiusOvoxouC24zmGoPoc7ExLvwvwXe6RBD+U
         0WWtXP2+6To+rYBt/hV5cPxKhacDNS47l8xuQT2I/jNVIa6QaFffcVdKKNLph3p1Hf
         +XUdQ1jZrGWuQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Expose vhca_id to debugfs
Date:   Sat, 12 Nov 2022 02:21:36 -0800
Message-Id: <20221112102147.496378-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Eli Cohen <elic@nvidia.com>

hca_id is an identifier of an mlx5_core instance within the hardware.
This identifier may be required for troubleshooting.

Expose it to debugfs.

Example:

$ cat /sys/kernel/debug/mlx5/mlx5_core.sf.2/vhca_id
0x12

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 9e6da51b7481..6d7c102861ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1588,6 +1588,16 @@ static int mlx5_hca_caps_alloc(struct mlx5_core_dev *dev)
 	return -ENOMEM;
 }
 
+static int vhca_id_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+
+	seq_printf(file, "0x%x\n", MLX5_CAP_GEN(dev, vhca_id));
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(vhca_id);
+
 int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 {
 	struct mlx5_priv *priv = &dev->priv;
@@ -1612,6 +1622,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	priv->numa_node = dev_to_node(mlx5_core_dma_dev(dev));
 	priv->dbg.dbg_root = debugfs_create_dir(dev_name(dev->device),
 						mlx5_debugfs_root);
+	debugfs_create_file("vhca_id", 0400, priv->dbg.dbg_root, dev, &vhca_id_fops);
 	INIT_LIST_HEAD(&priv->traps);
 
 	err = mlx5_tout_init(dev);
-- 
2.38.1

