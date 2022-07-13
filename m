Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A47573FD5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiGMW7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiGMW7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417C02A730
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC6EB61651
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103D9C341C0;
        Wed, 13 Jul 2022 22:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753156;
        bh=Ky9Viq/FRcgY3rxv/tTzAyKr5KM7wARqd1OtZhDagdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsbYbaGOtBF5kfKx8sRmNJ85fS+CXxCV+IlGAyugTfQM4jq3n5IRLGU+XvqaaMYim
         cVSpLhY89LxpbJtOVKT/9GgG29X8zOO8U9kPgfPvueWmyMuI77FhUI0fVpNtMGokYy
         L34RENpS2BA8C3f3F4M+Qxfm3GoAd3r1WNUF5GK4B4E6a9bHI7h2RB8PArsRsT/XKH
         gxDge/ET+AntnIjIp8dJLpJv/WEopz1dDZOMegZokfKMHI4u4uoMwdDIaBGSxdTNRI
         PHMfQ6vv9Efpq4eEYx+RXdHs5WLGQtHut2eLan/XBDcGHDsMagnxZmnEBu+yTaHtcN
         V7o7ku9RGIzYQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 05/15] net/mlx5: debugfs, Add num of in-use FW command interface slots
Date:   Wed, 13 Jul 2022 15:58:49 -0700
Message-Id: <20220713225859.401241-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Expose the number of busy / in-use slots in the FW command interface via
a read-only debugfs entry. This improves observability and helps in the
performance bottleneck analysis.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 9caa1b52321b..3e232a65a0c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -166,6 +166,28 @@ static const struct file_operations stats_fops = {
 	.write	= average_write,
 };
 
+static ssize_t slots_read(struct file *filp, char __user *buf, size_t count,
+			  loff_t *pos)
+{
+	struct mlx5_cmd *cmd;
+	char tbuf[6];
+	int weight;
+	int field;
+	int ret;
+
+	cmd = filp->private_data;
+	weight = bitmap_weight(&cmd->bitmask, cmd->max_reg_cmds);
+	field = cmd->max_reg_cmds - weight;
+	ret = snprintf(tbuf, sizeof(tbuf), "%d\n", field);
+	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
+}
+
+static const struct file_operations slots_fops = {
+	.owner	= THIS_MODULE,
+	.open	= simple_open,
+	.read	= slots_read,
+};
+
 void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd_stats *stats;
@@ -176,6 +198,8 @@ void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 	cmd = &dev->priv.dbg.cmdif_debugfs;
 	*cmd = debugfs_create_dir("commands", dev->priv.dbg.dbg_root);
 
+	debugfs_create_file("slots_inuse", 0400, *cmd, &dev->cmd, &slots_fops);
+
 	for (i = 0; i < MLX5_CMD_OP_MAX; i++) {
 		stats = &dev->cmd.stats[i];
 		namep = mlx5_command_str(i);
-- 
2.36.1

