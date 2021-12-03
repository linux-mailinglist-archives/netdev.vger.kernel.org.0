Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3C5466EDF
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245176AbhLCA77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344386AbhLCA75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83602C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 16:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 491EBB82025
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB41C53FD1;
        Fri,  3 Dec 2021 00:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492992;
        bh=3EovwRTRqmWViwDwxAoNfzV7Z8CCubRzNKrRH44Yn2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NudlJ7zROixOU3NM8XP1mkCyYhLUo010lBYQKWZCDjpyNLM7kTJMZItUGHEdHB2Us
         +hFEESMyy04HM+lS5RbK17Rof17gMbSY3pCxFbKV8TMJMpQKRdHsDaueRev1y5U3st
         qJoqr0UqSY77N1gOvarw7wrmIlJNqSyH2XAfTgtaCTZJz3wHCKkUn6SXjvSd4RUL5r
         zaddt3tx94SjeV7sltp6I15Hlt8+B7BuSVh3AwC+p34xYnwhU/HMwMAvrRlsCDxi8+
         PRwOHt1Bd4aNlGi2zbM4qtOfVSCyOU1X3TYHkaa4wEHbQYviJoJUD7k6Nv3MCOu2hL
         42ikD63LYQVFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 13/14] net/mlx5e: TC, Set flow attr ip_version earlier
Date:   Thu,  2 Dec 2021 16:56:21 -0800
Message-Id: <20211203005622.183325-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Setting flow attr ip_version is not related to parsing tc flow actions.
It needs to be set after parsing flower matches which changes the spec.
So move it outside parse_tc_fdb_actions() and set it in
__mlx5e_add_fdb_flow().

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c7f1c93709cd..3e3419190c55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4251,9 +4251,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	/* always set IP version for indirect table handling */
-	attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
-
 	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
 	    attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) {
 		/* For prio tag mode, replace vlan pop with rewrite vlan prio
@@ -4488,6 +4485,9 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
+	/* always set IP version for indirect table handling */
+	flow->attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
+
 	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack);
 	if (err)
 		goto err_free;
-- 
2.31.1

