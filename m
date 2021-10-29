Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574DA440480
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhJ2U7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhJ2U7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D1E26108F;
        Fri, 29 Oct 2021 20:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541007;
        bh=LT1wsVpr1JOZsbIB315BTLjNGdo7mTMnCkJdrJbTzE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wh/0+54dDnIA6+1fC4sGBmSLRm77JT9GFJy0pLkcsWvpsZQZ395ZrFuCMXbzhd254
         pm6U2aqb0YOwM84gYarqDUvmgsZxx9kMA6UP9PfEQ4+8kZ+ZppmCSoESLrX5PL7jJ2
         TqmoS6dmeTW7xsjK1erBgDNhUKQhhtmZ9f4LrMCZWMkzKo3J9eLf3dGYJYzutvxORo
         0y39v0+EfEbCLexcEY4tekT61Jv2H5WjrdCwKcGQLDoNX8zvVvLFrvGhNerlBGUxoK
         fv0wpTERXIR48nrXf4B/iMHLDXKbhZSeYIMnEbuILUVmLhYbhtVEYo1Cy98sf+dBLZ
         gqL/Cjt/emJ8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/14] net/mlx5e: Accept action skbedit in the tc actions list
Date:   Fri, 29 Oct 2021 13:56:27 -0700
Message-Id: <20211029205632.390403-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Setting the skb packet type field to host is usually
done when performing forwarding to ingress device.

This is required since the receive handling that is used
by the redirect to ingress action checks whether the packet
doesn't belong to this host and drops the packet in such case.

In order to be able to offload action redirect ingress, tc offload
code needs to accept the skbedit ptype action as well.

There's no special handling in HW for such action since it will
be followed by a redirect action and therefore, this code
only allows us to accept such action in the actions list but
not performing anything specific in HW for it.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2b2caff6c4e7..3242eba67047 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3856,6 +3856,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->flags |= MLX5_ESW_ATTR_FLAG_ACCEPT;
 			break;
+		case FLOW_ACTION_PTYPE:
+			if (act->ptype != PACKET_HOST) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "skbedit ptype is only supported with type host");
+				return -EOPNOTSUPP;
+			}
+			break;
 		case FLOW_ACTION_DROP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
-- 
2.31.1

