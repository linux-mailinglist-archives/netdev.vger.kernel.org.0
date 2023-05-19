Return-Path: <netdev+bounces-3987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BDA709EB1
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:00:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDCE41C21314
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C54114AAA;
	Fri, 19 May 2023 17:56:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0588414A8A
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1568C4331D;
	Fri, 19 May 2023 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518982;
	bh=f6Rm+pb3qllqU+BRphEHqkIyYZp+VdDx5HrqKIqwyfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUOdpNYyuYTtBlvHEDK9BKfYuySeuKzdk3UTts9O/TEio9NNI/vQyteGFC+JKiz60
	 RrACatoc1WzPdxw/N5lB2dAmXHUjq6Hnl5Tf6YSM3cYFvpsHhVqrIE8OgLzasBtP+z
	 I7T824+byf2IODNlMaX7CY/O1BXKH+Sxp2LSWwFNnAFYkfWtpKNCYFdGX82eLEzgu3
	 N8joBt3sdss2gzRT7DediS3XszJw7elr/iCGjihKQdlwDy/uWwK7FuRRJqxkwlTgqW
	 H+5ob5ZIsnxi2MmsdXgNXQjtl03Hm622fg5Ea0ClEFb39gsT4cZQcNtWxtCqktPKIO
	 C9VFtRMN/ErgA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: E-Switch, Initialize E-Switch for eswitch manager
Date: Fri, 19 May 2023 10:55:57 -0700
Message-Id: <20230519175557.15683-16-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

Initialize eswitch instance for a function which is eswitch manager
but not a vport group manager.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9b71819e049a..31956cd9d1bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1622,7 +1622,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	struct mlx5_eswitch *esw;
 	int err;
 
-	if (!MLX5_VPORT_MANAGER(dev))
+	if (!MLX5_VPORT_MANAGER(dev) && !MLX5_ESWITCH_MANAGER(dev))
 		return 0;
 
 	esw = kzalloc(sizeof(*esw), GFP_KERNEL);
@@ -1692,7 +1692,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 
 void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 {
-	if (!esw || !MLX5_VPORT_MANAGER(esw->dev))
+	if (!esw)
 		return;
 
 	esw_info(esw->dev, "cleanup\n");
-- 
2.40.1


