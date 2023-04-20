Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632D06E8C05
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbjDTIDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbjDTIDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:03:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE44313E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 796BD64147
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32817C433EF;
        Thu, 20 Apr 2023 08:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681977793;
        bh=/K1V0+pfP3mIwP5JvgV2W/0jRkdY6odY07l3ViROM1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuR2sieqjMJfRvY+EZagBlo5H6oIDoazAkoIihytJDsGAS5aa3eui+SMKa4N6HNVu
         g+HvWq/3BWr1Y75dx9iEOKvjWZKiTBg5WKTJMWEFP+0KoZUXe5jVIdmkuKPclZ+clC
         GYT9ZjwV9RDMQmNYhWZIVapwBrxqDEYVaiY4MQ1aG48xC/WVSk5lRfG9qVnU95hncR
         0RuN5CbLkHtS4W/EFn0PU/g3tmSvCHq643um2n8uGcjn4NyxxXOY90TCEjZmnwP2AB
         YqC387sQLlpuCXSfRaOn1W68WrTvAg8LTdrubtOVff5ZByqhm+VeNI56FBA2TeN655
         iaVKHS7LKhfNA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/5] net/mlx5e: Fix FW error while setting IPsec policy block action
Date:   Thu, 20 Apr 2023 11:02:47 +0300
Message-Id: <da613106043586ef68984b12ac557cc59020714c.1681976818.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976818.git.leon@kernel.org>
References: <cover.1681976818.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

When trying to set IPsec policy block action the following error is
generated:

 mlx5_cmd_out_err:803:(pid 3426): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed,
	status bad parameter(0x3), syndrome (0x8708c3), err(-22)

This error means that drop action is not allowed when modify action is
set, so update the code to skip modify header for XFRM_POLICY_BLOCK action.

Fixes: 6721239672fe ("net/mlx5e: Skip IPsec encryption for TX path without matching policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c       | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 5a8fcd30fcb1..dbe87bf89c0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1252,16 +1252,16 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	setup_fte_no_frags(spec);
 	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
-	if (attrs->reqid) {
+	switch (attrs->action) {
+	case XFRM_POLICY_ALLOW:
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		if (!attrs->reqid)
+			break;
+
 		err = setup_modify_header(mdev, attrs->reqid,
 					  XFRM_DEV_OFFLOAD_OUT, &flow_act);
 		if (err)
 			goto err_mod_header;
-	}
-
-	switch (attrs->action) {
-	case XFRM_POLICY_ALLOW:
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 		break;
 	case XFRM_POLICY_BLOCK:
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
@@ -1273,7 +1273,7 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	default:
 		WARN_ON(true);
 		err = -EINVAL;
-		goto err_action;
+		goto err_mod_header;
 	}
 
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
@@ -1293,7 +1293,7 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	return 0;
 
 err_action:
-	if (attrs->reqid)
+	if (flow_act.modify_hdr)
 		mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
 err_mod_header:
 	kvfree(spec);
-- 
2.40.0

