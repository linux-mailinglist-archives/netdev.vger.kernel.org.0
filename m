Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FE12F28BE
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391901AbhALHO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:14:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391826AbhALHOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:14:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A9E22D01;
        Tue, 12 Jan 2021 07:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435625;
        bh=3OMEF2lY2e3KG2yS3rlIrF/fVnWCck/jj3EHH6R2dXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6QdykkN0ObDOJ5+lJCPl0L7zeaic9qAxCIiTNmQdb6bKny8HJyOCcL8JL0rXNQCQ
         Brst9LmFrUiwj8BacX+EHj7XuUG7NEhdGi7hFvfZ14+BJ64bUwTOiNZljMWSEWM5XB
         gsIxkq1z7rWPkDQ74B9N3xy/GtYBU7EC/B9OdZpN2km4z+T1HQmXKvJBXl5IsSTlGZ
         9BTgdzDw/sWlHlFp9PFMR/Sn1feJgCqcWv79qK9IdpZ1tUIBhXjqBZPgVMb3ciG7U9
         HsU0omOakg2EEXnzNzOXmadauFyjHcLC4IimpBWWp6ETnwaRz6lq941Ftw3IPzFTx5
         EkEpzTkLM6pzw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 03/11] net/mlx5: E-Switch, use new cap as condition for mpls over udp
Date:   Mon, 11 Jan 2021 23:05:26 -0800
Message-Id: <20210112070534.136841-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Use tunnel_stateless_mpls_over_udp instead of
MLX5_FLEX_PROTO_CW_MPLS_UDP since new devices have native support for
mpls over udp and do not rely on flex parser.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
index 1f9526244222..3479672e84cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -81,8 +81,8 @@ static int parse_tunnel(struct mlx5e_priv *priv,
 	if (!enc_keyid.mask->keyid)
 		return 0;
 
-	if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
-	      MLX5_FLEX_PROTO_CW_MPLS_UDP))
+	if (!MLX5_CAP_ETH(priv->mdev, tunnel_stateless_mpls_over_udp) &&
+	    !(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) & MLX5_FLEX_PROTO_CW_MPLS_UDP))
 		return -EOPNOTSUPP;
 
 	flow_rule_match_mpls(rule, &match);
-- 
2.26.2

