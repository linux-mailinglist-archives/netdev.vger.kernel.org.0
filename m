Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD77319867
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBLC6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhBLC6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF0AB64E2A;
        Fri, 12 Feb 2021 02:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098641;
        bh=jWRKbjpiNdvGU6hawRX63dRFNhvCceHAz0hSbWH9Fw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZd7iKpspJTSmWIpCgvY62/vt2u1qMj9Z1EorLZ5kxY+Q92wvrrDff/xqgKf9BanR
         X7ueMjRH2kPKlPAcDn4F6FMu58ywWW6Q4rQoWBPJaRh6vmZvm07vqdiHmNkWwt6uxx
         rZev4er7bNTgqDJwjxXITf2189zA+h76eseGbwDd/QqNi6kvxgGXRhXngg8uLOZe/j
         FwjpAM2gc5bNlD9eMTLflxJ2R4fKPxZSQFh44LC/0FM4EvEXbh8Mb5qLIpWldJLXcx
         5QM5G51udkFnCYFRlJa24ys2LBmDAwBe15VLRspcfR5p24GH2VD1kNF5c+WZ0kOTx8
         cNoRpoHTMXLng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/15] net/mlx5e: E-switch, Fix rate calculation for overflow
Date:   Thu, 11 Feb 2021 18:56:27 -0800
Message-Id: <20210212025641.323844-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

rate_bytes_ps is a 64-bit field. It passed as 32-bit field to
apply_police_params(). Due to this when police rate is higher
than 4Gbps, 32-bit calculation ignores the carry. This results
in incorrect rate configurationn the device.

Fix it by performing 64-bit calculation.

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dd0bfbacad47..717fbaa6ce73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5040,7 +5040,7 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 	 */
 	if (rate) {
 		rate = (rate * BITS_PER_BYTE) + 500000;
-		rate_mbps = max_t(u32, do_div(rate, 1000000), 1);
+		rate_mbps = max_t(u64, do_div(rate, 1000000), 1);
 	}
 
 	err = mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
-- 
2.29.2

