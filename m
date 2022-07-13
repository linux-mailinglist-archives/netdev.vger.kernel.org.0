Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB2D573FDE
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiGMW7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiGMW72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D582A97D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BE7A61A78
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A950C3411E;
        Wed, 13 Jul 2022 22:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753158;
        bh=ToV3XYzVwyRq3xXV70agum5Qbw2moApFlMBPAs4m0XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukZzlY8RS7Htxg/PiAIV926aU5yofE62L9w3EcbODzi4FFh0VclilBBGoYaDGQJIy
         PMvo55PWr6fv90JETbzo1P3fPX7et/wyuU9dp40r6kE5GqKRGeiWn0apKfXGFii+pF
         yKnNSpsyjMs3QMujiQYRaZ9mgPmvW//9xQPgRp3Xwx+kUCzqznP4DiDzWxZNyUNWeV
         6G/z9mBJuGiWYcmF00xlIK/rUM3Pxzt9rRpsFp44DtxSgOPc3HQCuLPRlsWcuJV0zu
         sB+GSiks4CzwEfJwfkSO+3fH+iOjpmNxGfoELuSn9t22Ks4y/YxWIXAQ9w6HXL6DNQ
         mOX3BJJoMVSbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Bridge, extract VLAN push/pop actions creation
Date:   Wed, 13 Jul 2022 15:58:52 -0700
Message-Id: <20220713225859.401241-9-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in series need to re-create VLAN actions when user
changes VLAN protocol. Extract the code that creates VLAN push/pop actions
into dedicated function in order to be reused in next patch.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 52 +++++++++++++------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 4e3197c0e92b..2b6e258279f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1025,36 +1025,58 @@ mlx5_esw_bridge_vlan_push_mark_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct
 	vlan->pkt_mod_hdr_push_mark = NULL;
 }
 
-static struct mlx5_esw_bridge_vlan *
-mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *port,
-			    struct mlx5_eswitch *esw)
+static int
+mlx5_esw_bridge_vlan_push_pop_create(u16 flags, struct mlx5_esw_bridge_vlan *vlan,
+				     struct mlx5_eswitch *esw)
 {
-	struct mlx5_esw_bridge_vlan *vlan;
 	int err;
 
-	vlan = kvzalloc(sizeof(*vlan), GFP_KERNEL);
-	if (!vlan)
-		return ERR_PTR(-ENOMEM);
-
-	vlan->vid = vid;
-	vlan->flags = flags;
-	INIT_LIST_HEAD(&vlan->fdb_list);
-
 	if (flags & BRIDGE_VLAN_INFO_PVID) {
 		err = mlx5_esw_bridge_vlan_push_create(vlan, esw);
 		if (err)
-			goto err_vlan_push;
+			return err;
 
 		err = mlx5_esw_bridge_vlan_push_mark_create(vlan, esw);
 		if (err)
 			goto err_vlan_push_mark;
 	}
+
 	if (flags & BRIDGE_VLAN_INFO_UNTAGGED) {
 		err = mlx5_esw_bridge_vlan_pop_create(vlan, esw);
 		if (err)
 			goto err_vlan_pop;
 	}
 
+	return 0;
+
+err_vlan_pop:
+	if (vlan->pkt_mod_hdr_push_mark)
+		mlx5_esw_bridge_vlan_push_mark_cleanup(vlan, esw);
+err_vlan_push_mark:
+	if (vlan->pkt_reformat_push)
+		mlx5_esw_bridge_vlan_push_cleanup(vlan, esw);
+	return err;
+}
+
+static struct mlx5_esw_bridge_vlan *
+mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *port,
+			    struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_bridge_vlan *vlan;
+	int err;
+
+	vlan = kvzalloc(sizeof(*vlan), GFP_KERNEL);
+	if (!vlan)
+		return ERR_PTR(-ENOMEM);
+
+	vlan->vid = vid;
+	vlan->flags = flags;
+	INIT_LIST_HEAD(&vlan->fdb_list);
+
+	err = mlx5_esw_bridge_vlan_push_pop_create(flags, vlan, esw);
+	if (err)
+		goto err_vlan_push_pop;
+
 	err = xa_insert(&port->vlans, vid, vlan, GFP_KERNEL);
 	if (err)
 		goto err_xa_insert;
@@ -1065,13 +1087,11 @@ mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *por
 err_xa_insert:
 	if (vlan->pkt_reformat_pop)
 		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
-err_vlan_pop:
 	if (vlan->pkt_mod_hdr_push_mark)
 		mlx5_esw_bridge_vlan_push_mark_cleanup(vlan, esw);
-err_vlan_push_mark:
 	if (vlan->pkt_reformat_push)
 		mlx5_esw_bridge_vlan_push_cleanup(vlan, esw);
-err_vlan_push:
+err_vlan_push_pop:
 	kvfree(vlan);
 	return ERR_PTR(err);
 }
-- 
2.36.1

