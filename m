Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC131319868
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhBLC6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhBLC6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C35C164E6F;
        Fri, 12 Feb 2021 02:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098642;
        bh=FKtvOkWPBpIaLFEuRwJ/5Ua34Ac4BXiQw5P1hupDraw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mf8J5RPdkaJzmEVVhTL7XKoyO0ywOWiMTNxn0GQXBdNAtNE8jJ5+Qijn5hLh0Jak6
         WoBDWnMmFAIOZUzFaGMtN4rXb0HeXxk+rO2M2mv1TaAgXT4iV+t959sQqioJaSJsfb
         O1VJqv4cx9MbPVX3yz96QEZec/Zo7DagAfZc5O1ANm+NktMb4gAkGtDrfWTfZBaMju
         QTP7n/86WI4n7POlgRF6nQnW5D6hqPQ8HMP1Q5bI/0RxiRiYl0v0DIvgBe0d8H1qf5
         yH3hnWBMpW/TDCPCDja3OImMJe5fK5jAHCoYzaU9Zhn4WhZUOX4RbO7m811+/FYpzx
         wyL+JQ8NKCqhg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/15] net/mlx5e: Enable XDP for Connect-X IPsec capable devices
Date:   Thu, 11 Feb 2021 18:56:29 -0800
Message-Id: <20210212025641.323844-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

This limitation was inherited by previous Innova (FPGA) IPsec
implementation, it uses its private set of RQ handlers which
does not support XDP, for Connect-X this is no longer true.

Fix by keeping this limitation only for Innova IPsec supporting devices,
as otherwise this limitation effectively wrongly blocks XDP for all
future Connect-X devices for all flows even if IPsec offload is not
used.

Fixes: 2d64663cd559 ("net/mlx5: IPsec: Add HW crypto offload support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0ae22a018dc2..5052820f7a51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4456,8 +4456,9 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 		return -EINVAL;
 	}
 
-	if (MLX5_IPSEC_DEV(priv->mdev)) {
-		netdev_warn(netdev, "can't set XDP with IPSec offload\n");
+	if (mlx5_fpga_is_ipsec_device(priv->mdev)) {
+		netdev_warn(netdev,
+			    "XDP is not available on Innova cards with IPsec support\n");
 		return -EINVAL;
 	}
 
-- 
2.29.2

