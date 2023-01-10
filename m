Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77F663912
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjAJGLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjAJGLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D5C1D0F7
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31FFBB8110A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA37C433D2;
        Tue, 10 Jan 2023 06:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331099;
        bh=OlGFNDUS0RselKTFBUQxwj6uvPi1bo2Jht1FgwmFmOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxT1ePBLN0veGPuS2X6qoUZ+4Emk4d5ggPTF6PgcQQVTSK7EgMY9g0FCOe3h2pBPC
         ZDVXLuaO9sBSawfJpWTQY9DbZyAH6+jiPbuWiMXsnOGnzO9GyqhByGe/seLXoSjunX
         4GZbv7Qz3Wi3hCQ0uQ73ueuMcrA/obmnCI3qtoQ6nWkNiRU+CQU7JVKpr2lRYo2V5Q
         rD9xRNG64A+OkOCyd9BHhztkDTBIPdIrARpNMoEFQP43J7RXjyG/tIEkrZ31hC3r96
         SH2hcXjikyIAXudXsZTsvEST6tQnmvV8yi6pbCgXkdlivPsA65hkQzOIFAW2TlJ7+0
         amx6sOyapCv/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net 03/16] net/mlx5e: TC, Keep mod hdr actions after mod hdr alloc
Date:   Mon,  9 Jan 2023 22:11:10 -0800
Message-Id: <20230110061123.338427-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Ariel Levkovich <lariel@nvidia.com>

When offloading TC NIC rule which has mod_hdr action, the
mod_hdr actions list is freed upon mod_hdr allocation.

In the new format of handling multi table actions and CT in
particular, the mod_hdr actions list is still relevant when
setting the pre and post rules and therefore, freeing the list
may cause adding rules which don't set the FTE_ID.

Therefore, the mod_hdr actions list needs to be kept for the
pre/post flows as well and should be left for these handler to
be freed.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9af2aa2922f5..dbadaf166487 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1301,7 +1301,6 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
-		mlx5e_mod_hdr_dealloc(&parse_attr->mod_hdr_acts);
 		if (err)
 			return err;
 	}
@@ -1359,8 +1358,10 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&tc->t_lock);
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
 		mlx5e_detach_mod_hdr(priv, flow);
+	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(priv->mdev, attr->counter);
-- 
2.39.0

