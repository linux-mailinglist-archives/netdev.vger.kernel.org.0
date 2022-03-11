Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3AF4D5CA0
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347259AbiCKHl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347184AbiCKHlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84051B7609
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0F95B82AE3
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B81C36AEC;
        Fri, 11 Mar 2022 07:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984446;
        bh=ofKJlI2MkMnCurJH/82YU17/epxBE/emTbAMHQ8csSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQRnxdbGxVyGbRx3DiMh6qpZwCZ3CyV18COgoHZm+QRr6guAZbs79ob45cnZHXX3b
         jMooTmojYlHNJB/zoZMRxuERFwqcSRa/h9XFqg8OTPx1GW6wYXuzhuuR/hruk8hEQ8
         mvMZhmi5D2xbUI95gfHS46/GDuVsYeYSDnGaB3QNJR7kpaSA46ZWXnaRd8+aq9xou1
         AERbprpRegurbF6Djlksbka9wH3WqszL2yE9sgYI+31gZLluKZDLNnhNm8hgRppHCC
         xsF+gSQcrHstLA2Xs9owaEtbr6mKSOshQUILglOjzBtyq1Gogh33s7yzjYT4ub5ihx
         O3Jk/qyCzL0vA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: DR, Add helper to get backing dr table from a mlx5 flow table
Date:   Thu, 10 Mar 2022 23:40:25 -0800
Message-Id: <20220311074031.645168-10-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

If sw steering was used to create the table, dr steeering fs creates
a backing dr table for the mlx5 flow table.

Add helper to return this table so it can be used to create matchers and
add rules on it directly instead of passing via eswitch_offloads/fs_core
insertion.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h   | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 8ca110643cc0..f5f2d356e75f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -305,3 +305,8 @@ u32 mlx5dr_table_get_id(struct mlx5dr_table *tbl)
 {
 	return tbl->table_id;
 }
+
+struct mlx5dr_table *mlx5dr_table_get_from_fs_ft(struct mlx5_flow_table *ft)
+{
+	return ft->fs_dr_table.dr_table;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 03efbdf3fec3..ec5cbec0d455 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -53,6 +53,9 @@ void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
 struct mlx5dr_table *
 mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level, u32 flags);
 
+struct mlx5dr_table *
+mlx5dr_table_get_from_fs_ft(struct mlx5_flow_table *ft);
+
 int mlx5dr_table_destroy(struct mlx5dr_table *table);
 
 u32 mlx5dr_table_get_id(struct mlx5dr_table *table);
-- 
2.35.1

