Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA959310514
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhBEGpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhBEGor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:44:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE93064FB8;
        Fri,  5 Feb 2021 06:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507447;
        bh=KFfrXo1bFf+AqKfKQ4nDebK0MQPvta8m9egGvcCfhKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pF38Bz3pJoaZxPoOsUqooFRRgMY5Bk0cGf4T7UXfYgAm6qxMNy+o3pQyb/ls6N/cz
         9MIr9rSLS8gBagNmTnotwvbcEbiEzPTKWHOWaYTTbZKW7mbKAHMAP2Jb315CvRDJc4
         +pLFg37qgjYII2ZhmTfZfcZGnDaCJzgktdQhp/H5g2Fh/s8EmZ8MHGuv9E4zvM46Zc
         H1QOG5Bd54SPtr28OP7V5BOhPONBjYVCX7D92Rq3Q6lhnJ2R6yJrTsn3C1ycaAcI9S
         aNpySboFMsMT7ItqnXV0/3HGR6FPfpytmbm1d7kNy34mOBzRAYeOKO0KU13jmJezKn
         xyU8PsvoTjoOA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/17] net/mlx5e: Always set attr mdev pointer
Date:   Thu,  4 Feb 2021 22:40:37 -0800
Message-Id: <20210205064051.89592-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Eswitch offloads extensions in following patches in the series require
attr->esw_attr->in_mdev pointer to always be set. This is already the case
for all code paths except mlx5_tc_ct_entry_add_rule() function. Fix the
function to assign mdev pointer with priv->mdev value.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 40aaa105b2fc..3fb75dcdc68d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -711,6 +711,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->outer_match_level = MLX5_MATCH_L4;
 	attr->counter = entry->counter->counter;
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
+	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
+		attr->esw_attr->in_mdev = priv->mdev;
 
 	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
 	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
-- 
2.29.2

