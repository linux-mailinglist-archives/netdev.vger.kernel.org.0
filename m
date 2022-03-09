Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238354D3C37
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbiCIVjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbiCIVjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797F16D944
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9A8ECE212A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE8DC340EC;
        Wed,  9 Mar 2022 21:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861893;
        bh=PyRl6nqzlTZEYxCT5aGiZsdVMdVnRXIqZ5igCjL2eoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2FA1FpVBhWdzNEzE2QJR4aV/tpnE+FpjF7MxurQIhbBPhxF+RGErf0T4tG/ZQtCI
         k8aRoLbMJWOnMZDV4hwpDnFHv0anuvmE6i5VCxZ38O0yb0wNncKRwrxtAK1K3CnP1z
         Vb+70dHF1pEG6EGWSFdPmRoz2/hLFOwDrIwpbt7cjLyUdTVPhegpmkVibyUrZc3weo
         r4EQKtdpty1RgvaOyOi1zSC3QRDMUr1/8rGis1/02x+qZhkzDJ7iIkH0RkG8bWvMyz
         aapADuMsGAAzwxVIMrNNCCVrDr69aYmzC89lH3oLgH7hA1ho4/8zNqQstYA11C320P
         lc1Q/0YZxrERw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5: DR, Fix handling of different actions on the same STE in STEv1
Date:   Wed,  9 Mar 2022 13:37:52 -0800
Message-Id: <20220309213755.610202-14-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Fix handling of various conditions in set_actions_rx/tx that check
whether different actions can be on the same STE.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c    | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 0326ab67c978..d273d3b4fb1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -533,7 +533,6 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 		dr_ste_v1_set_pop_vlan(last_ste, action, attr->vlans.count);
 		action_sz -= DR_STE_ACTION_SINGLE_SZ;
 		action += DR_STE_ACTION_SINGLE_SZ;
-		allow_modify_hdr = false;
 	}
 
 	if (action_type_set[DR_ACTION_TYP_CTR])
@@ -677,13 +676,12 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
 			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
 			action_sz = DR_STE_ACTION_TRIPLE_SZ;
-			allow_modify_hdr = false;
-			allow_ctr = false;
 		}
 
 		dr_ste_v1_set_pop_vlan(last_ste, action, attr->vlans.count);
 		action_sz -= DR_STE_ACTION_SINGLE_SZ;
 		action += DR_STE_ACTION_SINGLE_SZ;
+		allow_ctr = false;
 	}
 
 	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
@@ -731,9 +729,9 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
 			action_sz = DR_STE_ACTION_TRIPLE_SZ;
 			allow_modify_hdr = true;
-			allow_ctr = false;
 		}
 		dr_ste_v1_set_counter_id(last_ste, attr->ctr_id);
+		allow_ctr = false;
 	}
 
 	if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2]) {
-- 
2.35.1

