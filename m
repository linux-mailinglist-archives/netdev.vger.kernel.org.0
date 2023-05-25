Return-Path: <netdev+bounces-5205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55767710373
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98B2F281313
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AE61FCF;
	Thu, 25 May 2023 03:49:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E7522C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA1AC433A1;
	Thu, 25 May 2023 03:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986544;
	bh=+8/dYIz2QFPNsGiDNZHF2qOkzIIsr1Zid2SbLWsHTZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWmo4u9E/cCBlFQqXI63rkHp6jUjgzC1+YT65TAcCeJwvcbxeXoRSp8bYBXdhsqzh
	 T6KSynJVkx1ubhkW/BFhpHFUT4RieSlhZ8yL1y1lg1jrpJbmzzyF4SmJzhfH6DD3oF
	 +pfXMPaW0yCRpHQbnSEN/3STdiZyCJ3u1tqbTGB3qM3KNfv5CnKbfhqxm1hiPcFcKB
	 ZD2xC1zb2vjIWZJAzpXtWAftRzlEBlEE+mZVK3nVKcUvdMCMSFH8SQQO5lxeeQ2F3R
	 c2i2V7QXkajrtTT0XEefeQNiRkO2MORlvhDBOHFcYsFTsWmN1MmUZfoOJTQwkUCBBG
	 KEB1pt6y2fwkQ==
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
Subject: [net 05/17] net/mlx5: Drain health before unregistering devlink
Date: Wed, 24 May 2023 20:48:35 -0700
Message-Id: <20230525034847.99268-6-saeed@kernel.org>
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

mlx5 health mechanism is using devlink APIs, which are using devlink
notify APIs. After the cited patch, using devlink notify APIs after
devlink is unregistered triggers a WARN_ON().
Hence, drain health WQ before devlink is unregistered.

Fixes: cf530217408e ("devlink: Notify users when objects are accessible")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a7eb65cd0bdd..2132a6510639 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1802,15 +1802,16 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
-	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
-	 * fw_reset before unregistering the devlink.
+	/* mlx5_drain_fw_reset() and mlx5_drain_health_wq() are using
+	 * devlink notify APIs.
+	 * Hence, we must drain them before unregistering the devlink.
 	 */
 	mlx5_drain_fw_reset(dev);
+	mlx5_drain_health_wq(dev);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_thermal_uninit(dev);
 	mlx5_crdump_disable(dev);
-	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
-- 
2.40.1


