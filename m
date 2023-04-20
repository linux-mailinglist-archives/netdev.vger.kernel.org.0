Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF3A6E8C02
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbjDTIDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbjDTIDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB652D5A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:03:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0E8C64147
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD32C433D2;
        Thu, 20 Apr 2023 08:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681977781;
        bh=aVDk6ixFl8pnaVx8A4coreNuNqeLPPrwiKySjH6MFOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+fM9CLYDj89ht8cEjUnbU0wHra/KQK8cY2U1jHaijRzNrRZTUeVY+yvcwym6T0TB
         03oSqYFeI9k1waP6t1TBYYzaQqezID3pJvNCo0l6/78I46Bd6usj2Z9cBb24BW+evS
         bnTi+5s/FDTVqV7uo13xgzRnOgd7cjYT6bOXNnGvmvYiIcf1djpiJ8YWy66tJVMjcs
         RgxIWokIMqLRdUm9lKJINQIJhLcla2knFVpwrEbXAVIyGYFjtueVeRRRxwNfu/wCCi
         48id/DgeX/3/hcM1yWd01axy4P0Rab6enzIOx3g5kRKyV/HMCpUjjW40Uamj3aIt34
         F2iXnD+MKWr/g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/5] net/mlx5e: Don't overwrite extack message returned from IPsec SA validator
Date:   Thu, 20 Apr 2023 11:02:48 +0300
Message-Id: <c245ca90872db741429cc2a7e9862558f561c848.1681976818.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976818.git.leon@kernel.org>
References: <cover.1681976818.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Addition of new err_xfrm label caused to error messages be overwritten.
Fix it by using proper NL_SET_ERR_MSG_WEAK_MOD macro together with change
in a default message.

Fixes: aa8bd0c9518c ("net/mlx5e: Support IPsec acquire default SA")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 5fd609d1120e..1547d8cda133 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -712,7 +712,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	kfree(sa_entry->work);
 err_xfrm:
 	kfree(sa_entry);
-	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
+	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
 	return err;
 }
 
-- 
2.40.0

