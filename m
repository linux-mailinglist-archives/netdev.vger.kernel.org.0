Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C478B280819
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733056AbgJATxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732941AbgJATxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:14 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BE721D46;
        Thu,  1 Oct 2020 19:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581993;
        bh=qb7UNib9FU2TGtkTV3q7amIUdABOYTHZwcr+wSdpK8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXzjEe9U+Uj6Dz+V/zRJCs8RelmMfMGZeLX+P9xWOKCQ9SHpf4DTlNl53p3ObxnQo
         vNzF9b03Kip2dWPT69UuXz17TTmQYol06+rnINDdjbf+oVvnXYXboMCUDInjqAIf0q
         V+L+agImg0r6XAdWiNkWwYM8pONL+3ESW5a/RHZ4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net V2 06/15] net/mlx5: cmdif, Avoid skipping reclaim pages if FW is not accessible
Date:   Thu,  1 Oct 2020 12:52:38 -0700
Message-Id: <20201001195247.66636-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

In case of pci is offline reclaim_pages_cmd() will still try to call
the FW to release FW pages, cmd_exec() in this case will return a silent
success without actually calling the FW.

This is wrong and will cause page leaks, what we should do is to detect
pci offline or command interface un-available before tying to access the
FW and manually release the FW pages in the driver.

In this patch we share the code to check for FW command interface
availability and we call it in sensitive places e.g. reclaim_pages_cmd().

Alternative fix:
 1. Remove MLX5_CMD_OP_MANAGE_PAGES form mlx5_internal_err_ret_value,
    command success simulation list.
 2. Always Release FW pages even if cmd_exec fails in reclaim_pages_cmd().

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c   | 17 +++++++++--------
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c |  2 +-
 include/linux/mlx5/driver.h                     |  1 +
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 4b54c9241fd7..f9c44166e210 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -902,6 +902,13 @@ static int cmd_alloc_index_retry(struct mlx5_cmd *cmd)
 	return idx;
 }
 
+bool mlx5_cmd_is_down(struct mlx5_core_dev *dev)
+{
+	return pci_channel_offline(dev->pdev) ||
+	       dev->cmd.state != MLX5_CMDIF_STATE_UP ||
+	       dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR;
+}
+
 static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
@@ -967,10 +974,7 @@ static void cmd_work_handler(struct work_struct *work)
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
 	/* Skip sending command to fw if internal error */
-	if (pci_channel_offline(dev->pdev) ||
-	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
-	    cmd->state != MLX5_CMDIF_STATE_UP ||
-	    !opcode_allowed(&dev->cmd, ent->op)) {
+	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
 		u32 drv_synd;
 
@@ -1800,10 +1804,7 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	u8 token;
 
 	opcode = MLX5_GET(mbox_in, in, opcode);
-	if (pci_channel_offline(dev->pdev) ||
-	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
-	    dev->cmd.state != MLX5_CMDIF_STATE_UP ||
-	    !opcode_allowed(&dev->cmd, opcode)) {
+	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode)) {
 		err = mlx5_internal_err_ret_value(dev, opcode, &drv_synd, &status);
 		MLX5_SET(mbox_out, out, status, status);
 		MLX5_SET(mbox_out, out, syndrome, drv_synd);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index f9b798af6335..c0e18f2ade99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -432,7 +432,7 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	u32 npages;
 	u32 i = 0;
 
-	if (dev->state != MLX5_DEVICE_STATE_INTERNAL_ERROR)
+	if (!mlx5_cmd_is_down(dev))
 		return mlx5_cmd_exec(dev, in, in_size, out, out_size);
 
 	/* No hard feelings, we want our pages back! */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2437e8721b36..4a99d6ff1401 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -936,6 +936,7 @@ int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size);
 void mlx5_cmd_mbox_status(void *out, u8 *status, u32 *syndrome);
+bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
 int mlx5_cmd_alloc_uar(struct mlx5_core_dev *dev, u32 *uarn);
-- 
2.26.2

