Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C95152B2A1
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiERGtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiERGtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:49:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D592228C
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68F15B81E96
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE84C385A9;
        Wed, 18 May 2022 06:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856585;
        bh=kbpZHOS2FpGbrp0Uz1xaZajdj+bkCt8Ein4GBea4dZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzGrHjg+9NibQPj8tYEWyYWJ0BXBNu+BGTGGpcmYlQBhWjMtGNqTvWdtlDW9nmV4f
         juFvfYVzh0mVji6NMwBP/iqoAQZMLMGgbAfm384L5xQ+JNYcGOC/K8e9ezDiFGHQcA
         1WtVpadjkJMpmzvK09VfoDUYx8dUBbsUH1jXKDdIWiaQt+AFLmIQxDIUdBYc9RxqP/
         yJXhOKLF0Ub3TK4YprIuq7rOnDUAm/p42gkfPdtdE1cAlaHZ/0D34+6qDimFqnsuwq
         3E2NR4EauzI0qei3rPYI6O3Z9Re/TgLA0uRN1Yevy6ewoU/+zFHTCuItC8dxpdPr7U
         Dc2E+rLX8TRPg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5: Add last command failure syndrome to debugfs
Date:   Tue, 17 May 2022 23:49:24 -0700
Message-Id: <20220518064938.128220-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Add syndrome of last command failure per command type to debugfs to ease
debugging of such failure.
last_failed_syndrome - last command failed syndrome returned by FW.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c     | 7 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 2 ++
 include/linux/mlx5/driver.h                       | 2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 26ba94cb432e..0377392848d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1887,7 +1887,8 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	return err;
 }
 
-static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status, int err)
+static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
+			   u32 syndrome, int err)
 {
 	struct mlx5_cmd_stats *stats;
 
@@ -1902,6 +1903,7 @@ static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status, int
 	if (err == -EREMOTEIO) {
 		stats->failed_mbox_status++;
 		stats->last_failed_mbox_status = status;
+		stats->last_failed_syndrome = syndrome;
 	}
 	spin_unlock_irq(&stats->lock);
 }
@@ -1909,6 +1911,7 @@ static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status, int
 /* preserve -EREMOTEIO for outbox.status != OK, otherwise return err as is */
 static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, void *out)
 {
+	u32 syndrome = MLX5_GET(mbox_out, out, syndrome);
 	u8 status = MLX5_GET(mbox_out, out, status);
 
 	if (err == -EREMOTEIO) /* -EREMOTEIO is preserved */
@@ -1917,7 +1920,7 @@ static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, void *
 	if (!err && status != MLX5_CMD_STAT_OK)
 		err = -EREMOTEIO;
 
-	cmd_status_log(dev, opcode, status, err);
+	cmd_status_log(dev, opcode, status, syndrome, err);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 3d3e55a5cb11..9caa1b52321b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -192,6 +192,8 @@ void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 					   &stats->last_failed_errno);
 			debugfs_create_u8("last_failed_mbox_status", 0400, stats->root,
 					  &stats->last_failed_mbox_status);
+			debugfs_create_x32("last_failed_syndrome", 0400, stats->root,
+					   &stats->last_failed_syndrome);
 		}
 	}
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d6bac3976913..74c8cfb771a2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -272,6 +272,8 @@ struct mlx5_cmd_stats {
 	u32		last_failed_errno;
 	/* last bad status returned by FW */
 	u8		last_failed_mbox_status;
+	/* last command failed syndrome returned by FW */
+	u32		last_failed_syndrome;
 	struct dentry  *root;
 	/* protect command average calculations */
 	spinlock_t	lock;
-- 
2.36.1

