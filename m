Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764363DE465
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhHCC3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhHCC3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC0D46104F;
        Tue,  3 Aug 2021 02:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957745;
        bh=rFbkdESyCwjipUwFn+bp7eGWdVTP50w8+/uMZGp2bEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUpydPgzL8jaGw4drgNXA1H+cpoCkrLkhYuwJocXXt9dc9kYj6wEOXjwzJaSHM4Yx
         VhiSjgNmGIZrXbePA5f+qA3S5LeP4CRp+v1Khj1/u6mn9V/FuOcF/a05ayDc+UuxVY
         eKxHGLcmhSQdWoSHPQnGzj3GySL69xv+NbY4ABZzjWMT9e98LOUq4ihYzNuxoPTNC3
         E0TvDxf07MbnzwBPrUYiXw+1a9jqTayS53+uGA+4w/Mg50ZSAUEWjGvHCjQx30AWA5
         ol9WxuSF65DKi2YD3yyVz/2ZlWJ5Jp5vLxhZxWS0KW/ujiKbiEL5P8jMBqlWCIpbBK
         bUWjY3eAd1vaA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5e: Remove redundant cap check for flow counter
Date:   Mon,  2 Aug 2021 19:28:49 -0700
Message-Id: <20210803022853.106973-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The cap is very old and today will always exists.
The cap is not being checked anywhere else. Remove the check from
drop action when parsing tc rules in nic mode.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f4f8a6728e95..3453f37a0741 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3356,10 +3356,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			break;
 		case FLOW_ACTION_DROP:
-			action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
-			if (MLX5_CAP_FLOWTABLE(priv->mdev,
-					       flow_table_properties_nic_receive.flow_counter))
-				action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			break;
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
-- 
2.31.1

