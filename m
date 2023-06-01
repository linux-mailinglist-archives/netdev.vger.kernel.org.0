Return-Path: <netdev+bounces-6974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB03D719124
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4344F1C20FE6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC71BA36;
	Thu,  1 Jun 2023 03:11:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59073BA34
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E88C4339C;
	Thu,  1 Jun 2023 03:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685589059;
	bh=5aSqpaN4HEtfcP/rtOgb0QcV0uKM0RdU5NvrskHy3tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMfZQ9FLEX90RvRGZ3Ag8dkX83yvYtld8C7TwX44A1XAj+0Q2w56MVY6X/n1bw6gX
	 6LNF+lWOQqZSlyIiJ8QsN2MdPkGRL5XSkQeC75ZhdZ0wwfZZ6/UF22y2UXL8ETtQyc
	 WySe5LWZ/IZv4EHn/DlrH4DibGj1IL8rV6x5ZuL1xFPZpLT9C/cCRBBv4JsM55eIUY
	 KJHQ2ExrfZWqgryJ3aKx606aqhgAmVXmG4cUhktIt+0nJlkA9uhkL4Cd2/kphx0/e5
	 Hzgr5JXNCSBDTcW8fT4SE1QLgnbKCemSW4FOJtoOTrR1dXTa1aTlAf+ARPXA0M95Oc
	 xft8QnVujPB0g==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net 5/5] net/mlx5: Read embedded cpu after init bit cleared
Date: Wed, 31 May 2023 20:10:51 -0700
Message-Id: <20230601031051.131529-6-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601031051.131529-1-saeed@kernel.org>
References: <20230601031051.131529-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

During driver load it reads embedded_cpu bit from initialization
segment, but the initialization segment is readable only after
initialization bit is cleared.

Move the call to mlx5_read_embedded_cpu() right after initialization bit
cleared.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Fixes: 591905ba9679 ("net/mlx5: Introduce Mellanox SmartNIC and modify page management logic")
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2132a6510639..d6ee016deae1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -923,7 +923,6 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 	}
 
 	mlx5_pci_vsc_init(dev);
-	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	return 0;
 
 err_clr_master:
@@ -1155,6 +1154,7 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot, u64 timeout
 		goto err_cmd_cleanup;
 	}
 
+	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_UP);
 
 	mlx5_start_health_poll(dev);
-- 
2.40.1


