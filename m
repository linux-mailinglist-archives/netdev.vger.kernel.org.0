Return-Path: <netdev+bounces-8291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B84272389D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936141C20E13
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3435110971;
	Tue,  6 Jun 2023 07:12:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24393DF44
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D66C433EF;
	Tue,  6 Jun 2023 07:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035558;
	bh=TvvFLrdrNCJQMZKS4rYmyo47SA0euHg3Lv0phWxoJSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mttWdeBdd1VpAHz2HlrBKYJnEZqFT2UlE5l37EpUygZFV7A/XVtiUcbum/o8PEYU3
	 eVaJExPFr+D6Uv4xXxqu1Kwsd76TGP57oi/0N+GMtwu4WnHmthcyAIG0D2Y+fbwSm1
	 6onLlIHX6/JfK0dOdkiRgz4gkWWjeSe9z6Lgqqu1ieM48wLj7WCpeTilNcDfg7PFSg
	 u4eV6QvyldXQ1DDzaomFynplF1lZzUWR0D4Adn7J3GcenI/Rlb2yXtsidffCdXcets
	 xu4QMQ9MvhFr+8LHjMoqh85/6caymMMTjYYqLV3wljxXdzCrP/1qgP72LN5LUB8QT1
	 YieH+Hwm7rrrg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 07/15] net/mlx5: LAG, block multiport eswitch LAG in case ldev have more than 2 ports
Date: Tue,  6 Jun 2023 00:12:11 -0700
Message-Id: <20230606071219.483255-8-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606071219.483255-1-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

multiport eswitch LAG is not supported over more than two ports. Add a check in
order to block multiport eswitch LAG over such devices.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 0c0ef600f643..0e869a76dfe4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -65,6 +65,7 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 	return err;
 }
 
+#define MLX5_LAG_MPESW_OFFLOADS_SUPPORTED_PORTS 2
 static int enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
@@ -74,6 +75,9 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	if (ldev->mode != MLX5_LAG_MODE_NONE)
 		return -EINVAL;
 
+	if (ldev->ports > MLX5_LAG_MPESW_OFFLOADS_SUPPORTED_PORTS)
+		return -EOPNOTSUPP;
+
 	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
 	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
 	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
-- 
2.40.1


