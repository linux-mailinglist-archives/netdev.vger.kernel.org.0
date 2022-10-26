Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ACE60E2AF
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiJZNyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiJZNxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60821057F3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7261161EB1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6B8C433D6;
        Wed, 26 Oct 2022 13:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792376;
        bh=vMTytB8KWWJwDUtV3bvD7tARArHNPnZCQkCiChnoRbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrALpICyUPzH8ljRa8ZxjOW5PMq6AWHEEreVd5TcEOHpkxYkS945Fzim126xoqQg5
         Tt8GCWK+JxhGnMfR//MwJ8utR5ORDWzso+zokPY8mi/XmBO8LPkwfweFVsvN0pLtP2
         aRyBZ5WGMObU4hMMbb62rAmf0v188p/LhmDQOUaOg0zRdPPXHB8SPEiP7BP0nuCOaN
         bgVRZItXarP+GGQlZadheyk7pZVOOGyvhDT7Zq4l0tTG7B9ZmEggmy88PpjYUS+zaf
         g+UYTqt2NvT+3oY9BJZyl937zN9gNzQqQuPAPciHRJSzjZmKae9FLJ3MCIbXaUiGYy
         KxjcprBMZ1R2A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [V4 net 13/15] net/mlx5e: Fix macsec rx security association (SA) update/delete
Date:   Wed, 26 Oct 2022 14:51:51 +0100
Message-Id: <20221026135153.154807-14-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The cited commit adds the support for update/delete MACsec Rx SA,
naturally, these operations need to check if the SA in question exists
to update/delete the SA and return error code otherwise, however they
do just the opposite i.e. return with error if the SA exists

Fix by change the check to return error in case the SA in question does
not exist, adjust error message and code accordingly.

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 250c878ba2c9..6ae9fcdbda07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -999,11 +999,11 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 	}
 
 	rx_sa = rx_sc->rx_sa[assoc_num];
-	if (rx_sa) {
+	if (!rx_sa) {
 		netdev_err(ctx->netdev,
-			   "MACsec offload rx_sc sci %lld rx_sa %d already exist\n",
+			   "MACsec offload rx_sc sci %lld rx_sa %d doesn't exist\n",
 			   sci, assoc_num);
-		err = -EEXIST;
+		err = -EINVAL;
 		goto out;
 	}
 
@@ -1055,11 +1055,11 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 	}
 
 	rx_sa = rx_sc->rx_sa[assoc_num];
-	if (rx_sa) {
+	if (!rx_sa) {
 		netdev_err(ctx->netdev,
-			   "MACsec offload rx_sc sci %lld rx_sa %d already exist\n",
+			   "MACsec offload rx_sc sci %lld rx_sa %d doesn't exist\n",
 			   sci, assoc_num);
-		err = -EEXIST;
+		err = -EINVAL;
 		goto out;
 	}
 
-- 
2.37.3

