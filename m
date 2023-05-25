Return-Path: <netdev+bounces-5206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A88F5710374
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63C62280AB0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B16B5250;
	Thu, 25 May 2023 03:49:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E50522D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9487EC433D2;
	Thu, 25 May 2023 03:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986545;
	bh=ualQWcFRT2sDreGjTpQIpsgE31I133gyU1V9dNf7MTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mREioYtlevD+jkH57gB/JWf4vN7K0TP83lNpgzr+hiRQVrQe/GntiaWRbdLM6ne4u
	 IpIJAEBkSNGo2AYR+RD6836f/iqFkfW2qSmFWnHhLjtZcMp+qlrvInPEItbzFDFdYf
	 pgtO8GSdunWxlAkLgeLcKZbVSyKRsVYnsJ4FVmf8au71tRB36rzjdkLgm2pFsI2xoV
	 9y023f6wXWf4gnjU4CcSfPgDKtKifRloiYThxv60W6iMZ/0/OEu2/MyWnDnNte/EOY
	 62Q0Nj+Kw3RX6IGV2prEqWfVu72xLCOKdVQ0UYX6JP5sDriqyBtG2JN2JmVOanf7vG
	 2332gpH9gkEEw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [net 06/17] net/mlx5: SF, Drain health before removing device
Date: Wed, 24 May 2023 20:48:36 -0700
Message-Id: <20230525034847.99268-7-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

There is no point in recovery during device removal. Also, if health
work started need to wait for it to avoid races and NULL pointer
access.

Hence, drain health WQ before removing device.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index e2f26d0bc615..0692363cf80e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -63,6 +63,7 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
 
+	mlx5_drain_health_wq(sf_dev->mdev);
 	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
-- 
2.40.1


