Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E8D42FF77
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbhJPAlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239294AbhJPAlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D4936124A;
        Sat, 16 Oct 2021 00:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344745;
        bh=U/gMWP3k9KP6T8wgArPUVKrr5RVUkU8lrj+WDBeLMqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ipn7psOnRuLMZYB2V3J4xmVgi0tqPuf/j7OTaFct64nJUzv7vQKe4Yxy3dRv6oBjk
         laaXAdMY5DKo/D2n5QGQMBKK64ZLm7XiXyOF2+Tld06l9bt4yZTaUwwve/zMsHLcVg
         01c4QQQiM5wPr9OKNfznBGabWKq/yC2tlBwT+wcqIQZfMljYf88RqcZx/FGwcn+SrI
         TfKRD4uc0hzB+aWzDWRqOi6OZ+d6Srs/e3UCGNEC8sv7wlLH559gd2aYtAJcmywdMW
         xVhBskxpnnzzwujm7UiolvsIod4r8+rdNI4X8j0gyLS4/HHPCeG8EsnW8CroF232Au
         il3+Br5R0ie6Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/13] net/mlx5: Bridge, provide flow source hints
Date:   Fri, 15 Oct 2021 17:38:53 -0700
Message-Id: <20211016003902.57116-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Currently, SMFS mode doesn't support rx-loopback flows which causes bridge
egress rules to be rejected because without hint rules for both rx and tx
destinations are created by default. Provide explicit flow source hints for
compatibility with SMFS.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index ed72246d1d83..588622ba38c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -677,6 +677,10 @@ mlx5_esw_bridge_egress_flow_create(u16 vport_num, u16 esw_owner_vhca_id, const u
 	if (!rule_spec)
 		return ERR_PTR(-ENOMEM);
 
+	if (MLX5_CAP_ESW_FLOWTABLE(bridge->br_offloads->esw->dev, flow_source) &&
+	    vport_num == MLX5_VPORT_UPLINK)
+		rule_spec->flow_context.flow_source =
+			MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 
 	dmac_v = MLX5_ADDR_OF(fte_match_param, rule_spec->match_value,
-- 
2.31.1

