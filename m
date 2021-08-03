Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56703DE464
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhHCC3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233732AbhHCC3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E51361051;
        Tue,  3 Aug 2021 02:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957744;
        bh=TlTfOn3YPWLZYDub0dDiPfrtkvr2O82vlLVq8ijJDK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPwagfTSdsTmlJ9n71r4jmXTrs2RFolbffMb7aFmfDaOSrXL3hPEnW3jYvqtINOHQ
         lb9Eej0rz7Es14XeyQ1EsDPYu2RRQPznKEOCx2IFynHAp+eeIOLMwXYDWc+j6ZXNfG
         lXOeeDQgNSXPOsKeHye0yajywzS2R7woMRtUWFOW5ebaYFcrfagK+vpXWnBQOLjx75
         Q8M69mOvHCGzq1GYVjyeGeHO+kl68sgY8GcEA1fWxintyyxwn9JQ0titv58kz+J8BE
         8wCJ4cpl/uK6wpuZuXyUUwpbeORB/hTWZT+XJFcYyKqz+M5yRMM9FsvRLmaWDcjqNe
         hGIq1+ebOapYg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5e: Remove redundant filter_dev arg from parse_tc_fdb_actions()
Date:   Mon,  2 Aug 2021 19:28:48 -0700
Message-Id: <20210803022853.106973-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

filter_dev is saved in parse_attr. and being used in other cases from
there. use it also for the leftover case.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9671fb0e1432..f4f8a6728e95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3707,8 +3707,7 @@ static int verify_uplink_forwarding(struct mlx5e_priv *priv,
 static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
 				struct mlx5e_tc_flow *flow,
-				struct netlink_ext_ack *extack,
-				struct net_device *filter_dev)
+				struct netlink_ext_ack *extack)
 {
 	struct pedit_headers_action hdrs[2] = {};
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -3773,7 +3772,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						   "mpls pop supported only as first action");
 				return -EOPNOTSUPP;
 			}
-			if (!netif_is_bareudp(filter_dev)) {
+			if (!netif_is_bareudp(parse_attr->filter_dev)) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "mpls pop supported only on bareudp devices");
 				return -EOPNOTSUPP;
@@ -4275,7 +4274,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack, filter_dev);
+	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack);
 	if (err)
 		goto err_free;
 
-- 
2.31.1

