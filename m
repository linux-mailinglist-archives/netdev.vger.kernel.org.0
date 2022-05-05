Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABEC51BCD3
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354912AbiEEKLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354904AbiEEKLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:11:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA34A5130F
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68948B82C1B
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F029C385A8;
        Thu,  5 May 2022 10:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651745244;
        bh=etd9v/VVGDpEbfVjS8WpMYDvZ5aU2wv0dTE3gJx7AzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAokdw2WNr8aN9sx4bKfD/i2uTs+wZjV3HRdl/Rw3Ab4W6oUHJnYGWxnwccVILv2X
         v/HoxtmuV0P0gHIcguqVNCxfQsCfeymTSO/tWx7Xj8p6kA0sU4C+ObpjjtztwdHMmq
         4DGzb9xNYg0EIG4Ghifgt0bet9RKbyjgumJ8XnDqK5XqWpoAOwdl4QxmIGZL6jyCwI
         NTVEb3FhYXOLZgAcngxN9whxx0o3O4pLK1D+YqqNmJ2RQsQ9skKQeD7ddHBG7FpA0H
         C6KOgY/3MIeSQW9l5YFYVmJu2TOdotec7EtsPX8/2gprNl2iHXueB9Wab3uRBp9QO6
         mXyi9u6QTlWSQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH ipsec-next 7/8] net/mlx5e: Use XFRM state direction instead of flags
Date:   Thu,  5 May 2022 13:06:44 +0300
Message-Id: <a8e511b7d8446e4c1c5414c44a6a81de62f116eb.1651743750.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Convert mlx5 driver to use XFRM state direction.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 35e2bb301c26..2a8fd7020622 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -172,9 +172,9 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	}
 
 	/* action */
-	attrs->action = (!(x->xso.flags & XFRM_OFFLOAD_INBOUND)) ?
-			MLX5_ACCEL_ESP_ACTION_ENCRYPT :
-			MLX5_ACCEL_ESP_ACTION_DECRYPT;
+	attrs->action = (x->xso.dir == XFRM_DEV_OFFLOAD_OUT) ?
+				MLX5_ACCEL_ESP_ACTION_ENCRYPT :
+				      MLX5_ACCEL_ESP_ACTION_DECRYPT;
 	/* flags */
 	attrs->flags |= (x->props.mode == XFRM_MODE_TRANSPORT) ?
 			MLX5_ACCEL_ESP_FLAGS_TRANSPORT :
@@ -306,7 +306,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	if (err)
 		goto err_hw_ctx;
 
-	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		err = mlx5e_ipsec_sadb_rx_add(sa_entry);
 		if (err)
 			goto err_add_rule;
@@ -333,7 +333,7 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 
-	if (x->xso.flags & XFRM_OFFLOAD_INBOUND)
+	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		mlx5e_ipsec_sadb_rx_del(sa_entry);
 }
 
-- 
2.35.1

