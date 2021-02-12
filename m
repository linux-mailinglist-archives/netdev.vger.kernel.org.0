Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422DF319875
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhBLDAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhBLC7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:59:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AD0764E8A;
        Fri, 12 Feb 2021 02:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098648;
        bh=b4p0hOcA8hHH3Hmk0YMlVTChchwkig3KDaK0s46Gfdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoQQfQ3AXOjRdNKRNmTGdkGJVNnvkaKxdsladSsvcRliQL82y8GMgjX0J7IHyukJG
         eiKIAjRnoB+/egtVIps9hiAup+gBLbrC1W1deIKF6l8mKNVpJBcBUxfiFx77KPEIuD
         JgA7PUUPi7hwBkKM7cuddUd2HBjDSH2pbUFDbsMVL6JY74llcY+mpiZ77gnhdlxWWL
         ZNYzMJVZwZ3H6w1O4rF2kLleTktu10SBTzBTXtsaCzPnXTZRcstehot3qpM8t9rVsd
         GUkJx/WMyAwc/7YBr6vCeZF0jxJDvXRsoyY19Pr/binJcFEn7zFg4aAGVCNXSsRjCC
         xdqCA3x8Q092A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 15/15] net/mlx5e: Check tunnel offload is required before setting SWP
Date:   Thu, 11 Feb 2021 18:56:41 -0800
Message-Id: <20210212025641.323844-16-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Check that tunnel offload is required before setting Software Parser
offsets to get Geneve HW offload. In case of Geneve packet we check HW
offload support of SWP in mlx5e_tunnel_features_check() and set features
accordingly, this should be reflected in skb offload requested by the
kernel and we should add the Software Parser offsets only if requested.
Otherwise, in case HW doesn't support SWP for Geneve, data path will
mistakenly try to offload Geneve SKBs with skb->encapsulation set,
regardless of whether offload was requested or not on this specific SKB.

Fixes: e3cfc7e6b7bd ("net/mlx5e: TX, Add geneve tunnel stateless offload support")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 1fae7fab8297..ff81b69a59a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -173,7 +173,7 @@ static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
 #endif
 
 #if IS_ENABLED(CONFIG_GENEVE)
-	if (skb->encapsulation)
+	if (skb->encapsulation && skb->ip_summed == CHECKSUM_PARTIAL)
 		mlx5e_tx_tunnel_accel(skb, eseg, ihs);
 #endif
 
-- 
2.29.2

