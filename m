Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA955695A9
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiGFXN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiGFXNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DA120B
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2130CE2114
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FF9C3411C;
        Wed,  6 Jul 2022 23:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149198;
        bh=/7Z2wAifQZLj8I9vXQFW1L8Rs8kHrY2bo+I9bF85Tlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toHvukS3fJbqSYC9rVHF9Fak2zAcSfNJ2NQRcWj1OV5j/qs5ua5aEP49iSHQkhGbU
         K3jGdRGFFXS63kDm4OzSO7YnEV0UurwxIyp43Xfa/CQo7j4eiTxEALT1lZLA7ueKKp
         PBiLzNxv3E/F5tInaksObD5qzZWM1igrCMOFFVNgBp/SOsIthKhsoQ5TKZq4jooM+C
         aJxbS+0DsNnxqz7VOCipbRm0ppYIIxgWb+tXjFZiP5s7ApjjkvvLoTzunxCAjX4nY/
         ddVbQT/EjrcpK5as1BLs7Z9otXCnF1N/sHrodYktAzNs1tpz5PEQWuhEPDjAHHjabw
         KDZwctHbcV1CA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net 1/9] net/mlx5: TC, allow offload from uplink to other PF's VF
Date:   Wed,  6 Jul 2022 16:13:01 -0700
Message-Id: <20220706231309.38579-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Redirecting traffic from uplink to a VF is a legal operation of
mulitport eswitch mode. Remove the limitation.

Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3a39a50146dd..9ca2c8763237 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3793,7 +3793,7 @@ static bool is_lag_dev(struct mlx5e_priv *priv,
 
 static bool is_multiport_eligible(struct mlx5e_priv *priv, struct net_device *out_dev)
 {
-	if (mlx5e_eswitch_uplink_rep(out_dev) &&
+	if (same_hw_reps(priv, out_dev) &&
 	    MLX5_CAP_PORT_SELECTION(priv->mdev, port_select_flow_table) &&
 	    MLX5_CAP_GEN(priv->mdev, create_lag_when_not_master_up))
 		return true;
-- 
2.36.1

