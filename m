Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCB33F909A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243747AbhHZWTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243733AbhHZWTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:19:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78F1360FE7;
        Thu, 26 Aug 2021 22:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630016293;
        bh=gENWGUiHHk55X47jo5NYPEZkCzpOeQham4eDl9xtzVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdYgsTHb/1EtCVFfS2CKOSQqkD3SBy27xhlxEVRe3Db0qcPSYi3jYbGbMVEEoAk1C
         jJVybZUOyDDKKGjszZOC7ViOxsToFwMo++B4TblRzE69UHAueDk0qElEdnqj3r65Iq
         zyikVYeoAEboTrrGJ2SvdfcRYmeD2N0uPs6YDoFiQOPDVDEOiDuCNsubcG/sZx047l
         75iSJmQv9KBgQ2cl133W5kg0QaSRTIujpPBWKqKCoXmsO6Vvlmd26WQzJmMANgLSps
         thuKPTTRxuLZPkiyfvE0cO63igNEfdOXhJ3R9MXbW2grp0vUlRXpp+HgnDFY8ZKMyR
         Y0bN0wIrbsRMw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/6] net/mlx5e: Fix possible use-after-free deleting fdb rule
Date:   Thu, 26 Aug 2021 15:18:07 -0700
Message-Id: <20210826221810.215968-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826221810.215968-1-saeed@kernel.org>
References: <20210826221810.215968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

After neigh-update-add failure we are still with a slow path rule but
the driver always assume the rule is an fdb rule.
Fix neigh-update-del by checking slow path tc flag on the flow.
Also fix neigh-update-add for when neigh-update-del fails the same.

Fixes: 5dbe906ff1d5 ("net/mlx5e: Use a slow path rule instead if vxlan neighbour isn't available")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 2e846b741280..1c44c6c345f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -147,7 +147,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	mlx5e_rep_queue_neigh_stats_work(priv);
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow))
+		if (!mlx5e_is_offloaded_flow(flow) || !flow_flag_test(flow, SLOW))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
@@ -188,7 +188,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	int err;
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow))
+		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
-- 
2.31.1

