Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ECE6039E4
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJSGjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiJSGjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:39:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D74F6DACB
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B0FBB82239
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B23C433B5;
        Wed, 19 Oct 2022 06:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161527;
        bh=WPubR+9Ws5kN5Xtxg/TTUc0ewFULWqYNy4mi2Jha8E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsl9if20ocURXmMrVKz6gkSSj3NNkcyjRnf+ub4Vo145gCeNfPPhmA2kq/AYsDicc
         lAw9d6MK4TriBLGVXox0+y+F90sgcY58TgSKM+mRO9EaIaJnrkJdeuPb2aMpDgK4wj
         kv+Il2cQ99Va6YZkWmP8hF8eOfLhNLgA3Vb7R52NuNK8wb5x9T3u//Og8eG6/v15v5
         PoZXiOWDiKGC3q4wLvwJTU8E5CtNr7wkGySUysa3cZr39Ssv14TjowVgatmg8OS8Cc
         ov0TYqRVVgITZ/EswTRpodS5Q8VFBqZC9Z2WrNIJSUMWEVamSXTKjCjwJKECsIzWMr
         PTLDwW9mrC6ag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [net 13/16] net/mlx5e: Fix macsec coverity issue at rx sa update
Date:   Tue, 18 Oct 2022 23:38:10 -0700
Message-Id: <20221019063813.802772-14-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The cited commit at update rx sa operation passes object attributes
to MACsec object create function without initializing/setting all
attributes fields leaving some of them with garbage values, therefore
violating the implicit assumption at create object function, which
assumes that all input object attributes fields are set.

Fix by initializing the object attributes struct to zero, thus leaving
unset fields with the legal zero value.

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 41970067917b..d111e86afe72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -432,7 +432,7 @@ static int mlx5e_macsec_update_rx_sa(struct mlx5e_macsec *macsec,
 				     bool active)
 {
 	struct mlx5_core_dev *mdev = macsec->mdev;
-	struct mlx5_macsec_obj_attrs attrs;
+	struct mlx5_macsec_obj_attrs attrs = {};
 	int err = 0;
 
 	if (rx_sa->active != active)
-- 
2.37.3

