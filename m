Return-Path: <netdev+bounces-4538-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E9870D343
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7054F281273
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FCC1C74C;
	Tue, 23 May 2023 05:42:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F71C742
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3DDC433A0;
	Tue, 23 May 2023 05:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820576;
	bh=kDMgFiABLVSY1/2ZltihwYIbKu4x/zb/5JwZTYIzNUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQyno0DVjSLD5E7l6JnnAC8ZwSuG8bpBhZMXVFMWbe4qhQeswsyFp238yNmXHDRmw
	 XNnPdHYXGNGgEX6ssJ3IfISDYdh3vKzDTaBMDty4u1UTFhIair/mmvZqeBPsKHwSSc
	 YZiDWoXz3yMDchl3bAIdnU5Xo8irKb0qAocB+xJgzKPwH9CFH76zHyrwhm3oyCZEhR
	 5hGHtpP3ngvKnid3vjhHP328qdQtT3xJVZ0bHnkxq422eS7KPYv63WfeERKTjuMe9O
	 p55STW7V+w9DTB5T5jQRAU53BcG+qJ2d4aWK9CEJoX59bUOdD+miaBZVoNqk0DucIY
	 JkvtuKQQrrtMw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Itamar Gozlan <igozlan@nvidia.com>
Subject: [net 04/15] net/mlx5: DR, Check force-loopback RC QP capability independently from RoCE
Date: Mon, 22 May 2023 22:42:31 -0700
Message-Id: <20230523054242.21596-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

SW Steering uses RC QP for writing STEs to ICM. This writingis done in LB
(loopback), and FL (force-loopback) QP is preferred for performance. FL is
available when RoCE is enabled or disabled based on RoCE caps.
This patch adds reading of FL capability from HCA caps in addition to the
existing reading from RoCE caps, thus fixing the case where we didn't
have loopback enabled when RoCE was disabled.

Fixes: 7304d603a57a ("net/mlx5: DR, Add support for force-loopback QP")
Signed-off-by: Itamar Gozlan <igozlan@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c | 4 +++-
 include/linux/mlx5/mlx5_ifc.h                             | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 3835ba3f4dda..1aa525e509f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -117,6 +117,8 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 	caps->gvmi		= MLX5_CAP_GEN(mdev, vhca_id);
 	caps->flex_protocols	= MLX5_CAP_GEN(mdev, flex_parser_protocols);
 	caps->sw_format_ver	= MLX5_CAP_GEN(mdev, steering_format_version);
+	caps->roce_caps.fl_rc_qp_when_roce_disabled =
+		MLX5_CAP_GEN(mdev, fl_rc_qp_when_roce_disabled);
 
 	if (MLX5_CAP_GEN(mdev, roce)) {
 		err = dr_cmd_query_nic_vport_roce_en(mdev, 0, &roce_en);
@@ -124,7 +126,7 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 			return err;
 
 		caps->roce_caps.roce_en = roce_en;
-		caps->roce_caps.fl_rc_qp_when_roce_disabled =
+		caps->roce_caps.fl_rc_qp_when_roce_disabled |=
 			MLX5_CAP_ROCE(mdev, fl_rc_qp_when_roce_disabled);
 		caps->roce_caps.fl_rc_qp_when_roce_enabled =
 			MLX5_CAP_ROCE(mdev, fl_rc_qp_when_roce_enabled);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index dc5e2cb302a5..b89778d0d326 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1705,7 +1705,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         rc[0x1];
 
 	u8         uar_4k[0x1];
-	u8         reserved_at_241[0x9];
+	u8         reserved_at_241[0x7];
+	u8         fl_rc_qp_when_roce_disabled[0x1];
+	u8         regexp_params[0x1];
 	u8         uar_sz[0x6];
 	u8         port_selection_cap[0x1];
 	u8         reserved_at_248[0x1];
-- 
2.40.1


