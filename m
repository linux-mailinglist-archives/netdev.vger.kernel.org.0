Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA5868E509
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjBHAh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBHAhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6E43E626
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56D1A6145B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AEBC433EF;
        Wed,  8 Feb 2023 00:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816641;
        bh=ISgNSqlok+yD+QdbYqzbSd3FlmZPW0GKX8X97b5eSfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vxees5+nP1OHOyoehXT4t9QC/xwB8Ai9smxn2bzteDn+qRs6O0WeuvKY95IOGif5R
         jKJj5JqQXdGQ5POeDBNa46XzVWoah5Y3YQK/w3hZptp+Ffx79io7Q0R6KgxQjnzBHc
         nhOYUVPJxi5doeBgoboMsRK1553wzu9RBznp3Cm2Btra1XQIPVwP127u896CGObPuf
         UaKKPLp9fdEP3NKMlAKMGcpFMMzcCp0q/flyd4xHMzYTGSdXX8qtEDeh6kBJh76XFL
         JgzTuU1B5TtR5TPgczOjEL3OZOK4A7ZCg6OSy54i8SIDQmVxV+9sbMuFBr/a9lkxJG
         mYev2cg8gp0Lw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Don't listen to remove flows event
Date:   Tue,  7 Feb 2023 16:37:01 -0800
Message-Id: <20230208003712.68386-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

remove_flow_enable event isn't really needed as it will be
triggered once user and/or XFRM core explicitly asked to delete
state. In such situation, we won't be interested in any event
at all.

So don't trigger and listen to remove_flow_enable event.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c  | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 57ac0f663fcd..7fb3835befbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -92,7 +92,6 @@ static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
 		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_pkt_cnt,
 			 lower_32_bits(attrs->hard_packet_limit));
 		MLX5_SET(ipsec_aso, aso_ctx, hard_lft_arm, 1);
-		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_enable, 1);
 	}
 
 	if (attrs->soft_packet_limit != XFRM_INF) {
@@ -329,8 +328,7 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 
 	if (attrs->soft_packet_limit != XFRM_INF)
 		if (!MLX5_GET(ipsec_aso, aso->ctx, soft_lft_arm) ||
-		    !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm) ||
-		    !MLX5_GET(ipsec_aso, aso->ctx, remove_flow_enable))
+		    !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm))
 			xfrm_state_check_expire(sa_entry->x);
 
 unlock:
-- 
2.39.1

