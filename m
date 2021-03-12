Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD4E339A0E
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhCLXj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:32834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235820AbhCLXjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:39:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3937C64F9F;
        Fri, 12 Mar 2021 23:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592340;
        bh=fA4SBX112QRnkigYDCmQVOKwZ219ewqWaxmNOxyX1aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUQMEqJe3YVgL2bAgZ2Je1/ollezjkcGPbQ/CMHjOtyzLbj1mtw7LTTwbQFS8efF8
         FRukXTI167323lgpasWO2i9gYhmc7hrt0o2L9hwyhmq8HdsbZJLjPwrAlxCBOExKcz
         5ocbwMZiERSHwfKbSPyPttxIAtK7vyC5331CEV90l/vV4UqoLM1hy2ywCMFKA/9KHN
         4Z2uAB0ERqmU2xkl1IGMgVmdOoMLnv7lYo113oRgqHEdabdL3XXH8G8rm6qOX0onBi
         KHw1riwIVWkEb5PYHpvnkn1od9je2ickq0TpE+QKkgmrDNdYC8WQLiYkottdXH0GjE
         EC/LYUxXLOpVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/13] net/mlx5: Display the command index in command mailbox dump
Date:   Fri, 12 Mar 2021 15:38:49 -0800
Message-Id: <20210312233851.494832-12-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

Multiple commands can be printed at the same time which can
lead to wrong order of their lines in dmesg output.
As a result, it's hard to match data dumps to the correct command
or which command was fully dumped at some point.

Fix this by displaying the corresponding command index, and also
indicate when a command was fully dumped.

Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 32 +++++++++++--------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index e8cecd50558d..9d79c5ec31e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -263,15 +263,15 @@ static int verify_signature(struct mlx5_cmd_work_ent *ent)
 	return 0;
 }
 
-static void dump_buf(void *buf, int size, int data_only, int offset)
+static void dump_buf(void *buf, int size, int data_only, int offset, int idx)
 {
 	__be32 *p = buf;
 	int i;
 
 	for (i = 0; i < size; i += 16) {
-		pr_debug("%03x: %08x %08x %08x %08x\n", offset, be32_to_cpu(p[0]),
-			 be32_to_cpu(p[1]), be32_to_cpu(p[2]),
-			 be32_to_cpu(p[3]));
+		pr_debug("cmd[%d]: %03x: %08x %08x %08x %08x\n", idx, offset,
+			 be32_to_cpu(p[0]), be32_to_cpu(p[1]),
+			 be32_to_cpu(p[2]), be32_to_cpu(p[3]));
 		p += 4;
 		offset += 16;
 	}
@@ -802,39 +802,41 @@ static void dump_command(struct mlx5_core_dev *dev,
 	int dump_len;
 	int i;
 
+	mlx5_core_dbg(dev, "cmd[%d]: start dump\n", ent->idx);
 	data_only = !!(mlx5_core_debug_mask & (1 << MLX5_CMD_DATA));
 
 	if (data_only)
 		mlx5_core_dbg_mask(dev, 1 << MLX5_CMD_DATA,
-				   "dump command data %s(0x%x) %s\n",
-				   mlx5_command_str(op), op,
+				   "cmd[%d]: dump command data %s(0x%x) %s\n",
+				   ent->idx, mlx5_command_str(op), op,
 				   input ? "INPUT" : "OUTPUT");
 	else
-		mlx5_core_dbg(dev, "dump command %s(0x%x) %s\n",
-			      mlx5_command_str(op), op,
+		mlx5_core_dbg(dev, "cmd[%d]: dump command %s(0x%x) %s\n",
+			      ent->idx, mlx5_command_str(op), op,
 			      input ? "INPUT" : "OUTPUT");
 
 	if (data_only) {
 		if (input) {
-			dump_buf(ent->lay->in, sizeof(ent->lay->in), 1, offset);
+			dump_buf(ent->lay->in, sizeof(ent->lay->in), 1, offset, ent->idx);
 			offset += sizeof(ent->lay->in);
 		} else {
-			dump_buf(ent->lay->out, sizeof(ent->lay->out), 1, offset);
+			dump_buf(ent->lay->out, sizeof(ent->lay->out), 1, offset, ent->idx);
 			offset += sizeof(ent->lay->out);
 		}
 	} else {
-		dump_buf(ent->lay, sizeof(*ent->lay), 0, offset);
+		dump_buf(ent->lay, sizeof(*ent->lay), 0, offset, ent->idx);
 		offset += sizeof(*ent->lay);
 	}
 
 	for (i = 0; i < n && next; i++)  {
 		if (data_only) {
 			dump_len = min_t(int, MLX5_CMD_DATA_BLOCK_SIZE, msg->len - offset);
-			dump_buf(next->buf, dump_len, 1, offset);
+			dump_buf(next->buf, dump_len, 1, offset, ent->idx);
 			offset += MLX5_CMD_DATA_BLOCK_SIZE;
 		} else {
-			mlx5_core_dbg(dev, "command block:\n");
-			dump_buf(next->buf, sizeof(struct mlx5_cmd_prot_block), 0, offset);
+			mlx5_core_dbg(dev, "cmd[%d]: command block:\n", ent->idx);
+			dump_buf(next->buf, sizeof(struct mlx5_cmd_prot_block), 0, offset,
+				 ent->idx);
 			offset += sizeof(struct mlx5_cmd_prot_block);
 		}
 		next = next->next;
@@ -842,6 +844,8 @@ static void dump_command(struct mlx5_core_dev *dev,
 
 	if (data_only)
 		pr_debug("\n");
+
+	mlx5_core_dbg(dev, "cmd[%d]: end dump\n", ent->idx);
 }
 
 static u16 msg_to_opcode(struct mlx5_cmd_msg *in)
-- 
2.29.2

