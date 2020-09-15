Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53D726AF38
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgIOVLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbgIOU1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:27:43 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8288221E3;
        Tue, 15 Sep 2020 20:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201561;
        bh=tmRY6384vWXJWL+5eMhLURimIGeF23La1ZXZtfc6+9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhQsG1tPlBC/gf01Zv4pc+VTUvugycYZreiy81LzvBc73TtXCA3vleDimf3fUlhzJ
         y7r/F+l9MOuEDa1YW+LPH5HVuCfVXmxhQ5XAhixkFebrrT6qZQBWlH3vkGjBtXxuG7
         ZT7Cmxv/EbUsbshXkLZ4io0fmqHt39K98TEUHLEE=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5e: Add support for tc trap
Date:   Tue, 15 Sep 2020 13:25:31 -0700
Message-Id: <20200915202533.64389-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Support tc trap such that packets can explicitly be forwarded to slow
path if they match a specific rule.

In the example below, we want packets with src IP equals 7.7.7.8 to be
forwarded to software, in which case it will get to the appropriate
representor net device.

$ tc filter add dev eth1 protocol ip prio 1 root flower skip_sw \
    src_ip 7.7.7.8 action trap

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fd53d101d8fd..2dded22a64a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3943,6 +3943,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			break;
+		case FLOW_ACTION_TRAP:
+			if (!flow_offload_has_one_action(flow_action)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "action trap is supported as a sole action only");
+				return -EOPNOTSUPP;
+			}
+			action |= (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				   MLX5_FLOW_CONTEXT_ACTION_COUNT);
+			attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+			break;
 		case FLOW_ACTION_MPLS_PUSH:
 			if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
 							reformat_l2_to_l3_tunnel) ||
-- 
2.26.2

