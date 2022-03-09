Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96FC4D3C39
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiCIVjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiCIVjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298C97892D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B47C461995
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDE1C340F7;
        Wed,  9 Mar 2022 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861891;
        bh=bLBG9wDOy+SAk4pqi2lJ7DZKvCsGneQjNAJ7/rtRb+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfCXmczs8QBaSr3ScnuHdBbG5lxbkdkpcf5Y61Sf7BCRuSv1jd77eQzdU6Ueriy06
         lKV+ED31ckSNdcqd/DUOoInvK74oiG4SOtnqOEi1khUmXyz97iuDn3Vi2XAqHLioFA
         l1kdYNQZwngDZCvTAQM0Az3aPqiVa43MtrLlbHQLyAySSgjHghv1+c6RTB6qw18QLn
         NEhm27H3AEHuIbCp3/lVJHeVnY0E9oJWg1I/SvNdSSTjD9V4iqy5LBTbOj46XP/Lzg
         8wUN2oatsecY/NMh+MjGW+4S5pvk1haAyYIw1Lw5BBkeXAXt7UqQkA6J6XTCk2coeO
         jFyWFu+PS4Azw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shun Hao <shunh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/16] net/mlx5: DR, Align mlx5dv_dr API vport action with FW behavior
Date:   Wed,  9 Mar 2022 13:37:49 -0800
Message-Id: <20220309213755.610202-11-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
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

From: Shun Hao <shunh@nvidia.com>

This aligns the behavior with FW when creating an FDB rule with wire
vport destination but no source port matching. Until now such rules
would fail on internal DR RX rule creation since the source and
destination are the wire vport.
The new behavior is the same as done on FW steering, if destination is
wire, we will create both TX and RX rules, but the RX packet coming from
wire will be dropped due to loopback not supported.

Signed-off-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_action.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index c61a5e83c78c..743422acc3d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -669,15 +669,9 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		case DR_ACTION_TYP_VPORT:
 			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
 			dest_action = action;
-			if (rx_rule) {
-				if (action->vport->caps->num == MLX5_VPORT_UPLINK) {
-					mlx5dr_dbg(dmn, "Device doesn't support Loopback on WIRE vport\n");
-					return -EOPNOTSUPP;
-				}
-				attr.final_icm_addr = action->vport->caps->icm_address_rx;
-			} else {
-				attr.final_icm_addr = action->vport->caps->icm_address_tx;
-			}
+			attr.final_icm_addr = rx_rule ?
+				action->vport->caps->icm_address_rx :
+				action->vport->caps->icm_address_tx;
 			break;
 		case DR_ACTION_TYP_POP_VLAN:
 			if (!rx_rule && !(dmn->ste_ctx->actions_caps &
-- 
2.35.1

