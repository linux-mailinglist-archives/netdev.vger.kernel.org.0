Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0BF6DEA2C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDLEId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDLEIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44854ECD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B556262DAE
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14609C433EF;
        Wed, 12 Apr 2023 04:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272490;
        bh=vcijwLJLYxksmAzd2HY6o0VW0kdGSFz/N1Mh45n+HNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5+EZf/xSl9h47H+35JwsfoAIVXksLfHWp/We0YiOZYmtj9VDLMVTLqEXyXf0EYtF
         OG3c9tAYlXcrvxbVTuscKQ25F8e2aDHZnl8dZSpMtExyWU0tDkqDOe2lQfJWjEVwd7
         YPpMq+F35ucp4M5ZM9p8PpvADlRSweN0FMGXgEUfpo/AbO1tf1a+iOVzUQD4KSasES
         MeavoVbog3bHgu7jKCfMJFjOhnXV8OaCpEk8IxNiWh8TD+3fcLozQ1cHGu18CuYpxR
         QiYM3lCdjDuscCyLpvtpvUwwt0dWKt7Ohwjq8bFsM7If4ssAZ2Ppx01rlDxSqA4QED
         hfSjTsmloutWA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 11/15] net/mlx5: DR, Set counter ID on the last STE for STEv1 TX
Date:   Tue, 11 Apr 2023 21:07:48 -0700
Message-Id: <20230412040752.14220-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

In STEv1 counter action can be set either by filling counter ID on STE, in
which case it is executed before other actions on this STE, or as a single
action, in which case it is executed in accordance with the actions order.
FW steering on STEv1 devices implements counter as counter ID on STE, and
this counter is set on the last STE.
Fix SMFS to be consistent with this behaviour - move TX counter to the
last STE, this way the counter will include all actions of the previous STEs
that might have changed packet headers length, e.g. encap, vlan push, etc.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c   | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 084145f18084..27cc6931bbde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -604,9 +604,6 @@ void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 			allow_modify_hdr = false;
 	}
 
-	if (action_type_set[DR_ACTION_TYP_CTR])
-		dr_ste_v1_set_counter_id(last_ste, attr->ctr_id);
-
 	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
 		if (!allow_modify_hdr || action_sz < DR_STE_ACTION_DOUBLE_SZ) {
 			dr_ste_v1_arr_init_next_match(&last_ste, added_stes,
@@ -724,6 +721,10 @@ void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 						  attr->range.max);
 	}
 
+	/* set counter ID on the last STE to adhere to DMFS behavior */
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		dr_ste_v1_set_counter_id(last_ste, attr->ctr_id);
+
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
 	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
-- 
2.39.2

