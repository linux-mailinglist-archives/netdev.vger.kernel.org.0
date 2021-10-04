Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10985421714
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238309AbhJDTQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238313AbhJDTQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B9C61354;
        Mon,  4 Oct 2021 19:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633374898;
        bh=mMJsJexkXYLqob05X/X6Ea4nd5H+6QYC0xzDIwpEZu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HreqGig83E8AoNDGTRY7RV0UiTDQrX2Bs5VeJBqz7m+7puRmM91vMQH3tQVFSgEIQ
         fvRT6+mt3nKZQA1iAWPQBoGdoHtMhhPbEORniCtQr/ctJWV+MWNwd7i+CCgKVXqllf
         Co1hnHmx8sdd4AGt9ceN21FZdeBuBTgXnJwMR31vYfuksYElxa75nMOO8LPj0InZHo
         GIjDwfzh0On/4ddH8Bt4Yw/pGH7fO/CNhDuprqE/wLBeVC5ybLRoJEo8bih+XES6qF
         f2/Iw3ACq+5SzdFsjaBvKWBoL96Ro5hAPYAcdYnZ5K/cLpN+W9ck1H/prV+HVVKmZK
         Y8Sac5t4UWpeA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/4] mlx4: replace mlx4_u64_to_mac() with u64_to_ether_addr()
Date:   Mon,  4 Oct 2021 12:14:44 -0700
Message-Id: <20211004191446.2127522-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211004191446.2127522-1-kuba@kernel.org>
References: <20211004191446.2127522-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx4_u64_to_mac() predates the common helper but doesn't
make the argument constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |  2 +-
 include/linux/mlx4/driver.h              | 10 ----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 9fadedfca41c..94ead263081f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -3195,7 +3195,7 @@ int mlx4_set_vf_spoofchk(struct mlx4_dev *dev, int port, int vf, bool setting)
 	port = mlx4_slaves_closest_port(dev, slave, port);
 	s_info = &priv->mfunc.master.vf_admin[slave].vport[port];
 
-	mlx4_u64_to_mac(mac, s_info->mac);
+	u64_to_ether_addr(s_info->mac, mac);
 	if (setting && !is_valid_ether_addr(mac)) {
 		mlx4_info(dev, "Illegal MAC with spoofchk\n");
 		return -EPERM;
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index b26b71f62fb4..1834c8fad12e 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -92,14 +92,4 @@ void *mlx4_get_protocol_dev(struct mlx4_dev *dev, enum mlx4_protocol proto, int
 
 struct devlink_port *mlx4_get_devlink_port(struct mlx4_dev *dev, int port);
 
-static inline void mlx4_u64_to_mac(u8 *addr, u64 mac)
-{
-	int i;
-
-	for (i = ETH_ALEN; i > 0; i--) {
-		addr[i - 1] = mac & 0xFF;
-		mac >>= 8;
-	}
-}
-
 #endif /* MLX4_DRIVER_H */
-- 
2.31.1

