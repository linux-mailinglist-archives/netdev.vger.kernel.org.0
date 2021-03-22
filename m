Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F053450B0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhCVUZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhCVUZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4AFD6199F;
        Mon, 22 Mar 2021 20:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444734;
        bh=aHPgc33+AHGNs3q8SDrwa5+LQwCIXf/+56TPt0MJ/qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG8Umb9CPriCoGOjfMZVVg9aOCuHwE17NSbIOEHAvU5QIdmSXc8gweQQRvJ0/jY6K
         41viHZiQ7HWd86liLhsYjKHUlWvA+1+uNK84tyPh1ZAIJZRO0iisNhSUIQp6Pl6yT/
         8+vs5H6wKVVuy5xBZtEwAZppVMpPcqZmU7XCSOIurKRmrs0fc7LJuppFxm2e5p3kKi
         p7lk/lWgWsoIYwtF4zpTJy44LrWZiSmrQ+Bokdf/kqsCtmKDdjgP+UX64OFpHHv7GM
         lsTsbndgBrG1Ttnn4y/ZyPyTWM5sSBSb0Do6KehfgKGPkvm66v1KHeyd+YclGEBj/P
         C+zwcGvIiXncw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/6] net/mlx5e: Allow to match on MPLS parameters only for MPLS over UDP
Date:   Mon, 22 Mar 2021 13:25:20 -0700
Message-Id: <20210322202524.68886-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322202524.68886-1-saeed@kernel.org>
References: <20210322202524.68886-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

Currently, we support hardware offload only for MPLS over UDP.
However, rules matching on MPLS parameters are now wrongly offloaded
for regular MPLS, without actually taking the parameters into
consideration when doing the offload.
Fix it by rejecting such unsupported rules.

Fixes: 72046a91d134 ("net/mlx5e: Allow to match on mpls parameters")
Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0cacf46dc950..3359098c51d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2296,6 +2296,16 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			*match_level = MLX5_MATCH_L4;
 	}
 
+	/* Currenlty supported only for MPLS over UDP */
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS) &&
+	    !netif_is_bareudp(filter_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on MPLS is supported only for MPLS over UDP");
+		netdev_err(priv->netdev,
+			   "Matching on MPLS is supported only for MPLS over UDP\n");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 
-- 
2.30.2

