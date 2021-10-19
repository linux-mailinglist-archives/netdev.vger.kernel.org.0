Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEBF432C2B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhJSDXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbhJSDXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B467F61354;
        Tue, 19 Oct 2021 03:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613650;
        bh=/hC86XNRle+Xek5GYa09JArnEEPCudRt7XuMrSGWWjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Do85RuytGTTzO5yYqxgwzb/a+fvElUwbzn7+rJWLt/WstH6beZy0nUU3uG5TQZhNG
         diwQFvTulRlV+D3+r6Q/Ae8yzVUbToxAZCv5k+w9ewmKRwq1nzfPEV7LnGM6sjKVYP
         kTRZxslPpcn0SP+HXDDV8Sa+vx2M408TLRyGv/BetVEhB827aB1kWTpFBSLIhdniR+
         2M/nEzGg/o5ukKjDw+P7Vv2qHkAsJ346bJAsjZAygsZl4wpo18sG2MGlSMbJIYAv0l
         1jDJ7e9hxf/63Q0QhS/4CMCe06L5rMe0KNk2ryiX3FAGGn5CJoGqQyssbD6zGM/oCQ
         9IpDZUQZ2Nb1w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/13] net/mlx5: Support partial TTC rules
Date:   Mon, 18 Oct 2021 20:20:35 -0700
Message-Id: <20211019032047.55660-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Add bitmasks to ttc_params to indicate if rule is valid or not.
It will allow to create TTC table with support only in part of the
traffic types.
In later patches which introduce the steering based LAG port selection,
TTC will be created with only part of the rules according to the hash
type.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
index 749d17c0057d..b63dec24747a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
@@ -247,6 +247,8 @@ static int mlx5_generate_ttc_table_rules(struct mlx5_core_dev *dev,
 	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
 		struct mlx5_ttc_rule *rule = &rules[tt];
 
+		if (test_bit(tt, params->ignore_dests))
+			continue;
 		rule->rule = mlx5_generate_ttc_rule(dev, ft, &params->dests[tt],
 						    ttc_rules[tt].etype,
 						    ttc_rules[tt].proto);
@@ -266,6 +268,8 @@ static int mlx5_generate_ttc_table_rules(struct mlx5_core_dev *dev,
 		if (!mlx5_tunnel_proto_supported_rx(dev,
 						    ttc_tunnel_rules[tt].proto))
 			continue;
+		if (test_bit(tt, params->ignore_tunnel_dests))
+			continue;
 		trules[tt] = mlx5_generate_ttc_rule(dev, ft,
 						    &params->tunnel_dests[tt],
 						    ttc_tunnel_rules[tt].etype,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
index ce95be8f8382..85fef0cd1c07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
@@ -43,7 +43,9 @@ struct ttc_params {
 	struct mlx5_flow_namespace *ns;
 	struct mlx5_flow_table_attr ft_attr;
 	struct mlx5_flow_destination dests[MLX5_NUM_TT];
+	DECLARE_BITMAP(ignore_dests, MLX5_NUM_TT);
 	bool   inner_ttc;
+	DECLARE_BITMAP(ignore_tunnel_dests, MLX5_NUM_TUNNEL_TT);
 	struct mlx5_flow_destination tunnel_dests[MLX5_NUM_TUNNEL_TT];
 };
 
-- 
2.31.1

