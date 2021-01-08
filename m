Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE32EED0B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbhAHFbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:31:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbhAHFbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:31:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920742343B;
        Fri,  8 Jan 2021 05:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083857;
        bh=3OMEF2lY2e3KG2yS3rlIrF/fVnWCck/jj3EHH6R2dXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFD6hPO0n3ztFBLmtpcFWGTevFFTvels+L0F9j5sqTA/JikuuFaXff0iyZXQeabOy
         Ho03DXGmH0jyM3I5uybVWwH4Yqlt8msi264SNu7ouZkLIStHAZ7SNs4LIrU25Ow8dm
         wh5ImN84iD01AyzJq0hVp0OyuvEl/0IPF8stPUPa9vg3GEE5rhPrKUJHg1ZzyuJ8vr
         xFapE/uiTApJKV6/4hMFTOfkzO8lzc5wsAqGnE2SaysfaIeDV6XmzEkH4hGfNtFv8b
         5Kk70EBf4FiYSGZZqp2PDX3vHbartKeBuDQBVFFxdcG7+WjldJE9C0WtXnLsCtNDJ5
         SGn76RL9JjY3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: E-Switch, use new cap as condition for mpls over udp
Date:   Thu,  7 Jan 2021 21:30:42 -0800
Message-Id: <20210108053054.660499-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
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

