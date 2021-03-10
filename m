Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D683933477F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhCJTEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233759AbhCJTEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9289964FD2;
        Wed, 10 Mar 2021 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403041;
        bh=KXMqkv/A3Hb66bVwb+TH6QbXSw6iCvrTNVbCOy5u81U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sevqrd7YIo35UDxY1BLkZetXSw5XThekIzSdsdirkv2LoQzSSW727uvgIP5Xznt8N
         Fer3a1v3LOtSRxOtJT19IHtPHUTTpD+YeBhrAFXG0QKx81MPQwQFplF+7k+EKF+JHI
         a9nFAsOriuMHhkhshQueqwSkFRBc51Xbm5PkmsIGVBjDdqYDVzxE11jaTH6syqmcej
         rYW2YNqQ/tPJRJy0Q2A5Ki+1PBNiJKHiExS9+lZoYUjFa89PQhVptVBSWK2FWkILS3
         a76gi8uu6tac+8MMNMPIh/FbED86PlNcBeehxIHiYZsUF9D3i+VCrgH/oYEAfD4r59
         f6KVHgeEQ9TFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 14/18] net/mlx5e: E-switch, Fix rate calculation division
Date:   Wed, 10 Mar 2021 11:03:38 -0800
Message-Id: <20210310190342.238957-15-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

do_div() returns reminder, while cited patch wanted to use
quotient.
Fix it by using quotient.

Fixes: 0e22bfb7c046 ("net/mlx5e: E-switch, Fix rate calculation for overflow")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0da69b98f38f..0cacf46dc950 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4445,7 +4445,8 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 	 */
 	if (rate) {
 		rate = (rate * BITS_PER_BYTE) + 500000;
-		rate_mbps = max_t(u64, do_div(rate, 1000000), 1);
+		do_div(rate, 1000000);
+		rate_mbps = max_t(u32, rate, 1);
 	}
 
 	err = mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
-- 
2.29.2

