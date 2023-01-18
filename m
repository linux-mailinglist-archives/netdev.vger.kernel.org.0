Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633E26716A4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjARIxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjARIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615089CBB8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A780FB81B3E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F96C433EF;
        Wed, 18 Jan 2023 08:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029075;
        bh=p8DXLAw+TfuddrSfQTIBi4TMaVOw0NhwQveU0Agktxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNxlxLSiTgFLUe40iOlOkHtTnujkVmpRaDUspb/GQHtMDfAvP3rL71BiF4zsFp7Bw
         wjW0ccA864yZspp9Am9UWpiObLCM56rP732L/qm/P8gQ0MKc662o/fXMfDpEJbSo5s
         8DiwBVCX18LkGKGwZLVlvVbzvi2IYmQf3p/PNHS2N3A3NWc8l4fd6xBxIvWTgbMJI2
         e35HzeA5af5Xq6q6pEybyuiVRWyRdGDdeskXtJchXdbeaIcFFa0ncDOviuQcYSg05n
         0S177J8uF3t4spsKoN8F01wEXD6VBY+J7cOAx93sFTRaBxSPcaCE/OEKOD87bP5n7o
         sgCyYPSV5mt0A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 06/10] net/mlx5e: Set decap action based on attr for sample
Date:   Wed, 18 Jan 2023 00:04:10 -0800
Message-Id: <20230118080414.77902-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently decap action is set based on tunnel_id. That means it is
set unconditionally. But for decap, ct and sample actions, decap is
done before ct. No need to decap again in sample.

And the actions are set correctly when parsing. So set decap action
based on attr instead of tunnel_id.

Fixes: 2741f2230905 ("net/mlx5e: TC, Support sample offload action for tunneled traffic")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 1cbd2eb9d04f..f2c2c752bd1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -477,7 +477,6 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	struct mlx5e_sample_flow *sample_flow;
 	struct mlx5e_sample_attr *sample_attr;
 	struct mlx5_flow_attr *pre_attr;
-	u32 tunnel_id = attr->tunnel_id;
 	struct mlx5_eswitch *esw;
 	u32 default_tbl_id;
 	u32 obj_id;
@@ -522,7 +521,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	restore_obj.sample.group_id = sample_attr->group_num;
 	restore_obj.sample.rate = sample_attr->rate;
 	restore_obj.sample.trunc_size = sample_attr->trunc_size;
-	restore_obj.sample.tunnel_id = tunnel_id;
+	restore_obj.sample.tunnel_id = attr->tunnel_id;
 	err = mapping_add(esw->offloads.reg_c0_obj_pool, &restore_obj, &obj_id);
 	if (err)
 		goto err_obj_id;
@@ -548,7 +547,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	/* For decap action, do decap in the original flow table instead of the
 	 * default flow table.
 	 */
-	if (tunnel_id)
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP)
 		pre_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	pre_attr->modify_hdr = sample_flow->restore->modify_hdr;
 	pre_attr->flags = MLX5_ATTR_FLAG_SAMPLE;
-- 
2.39.0

