Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54217609A59
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 08:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiJXGPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 02:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiJXGOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 02:14:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24CF5E64A
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 23:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9445A6100F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 06:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A66AC433D7;
        Mon, 24 Oct 2022 06:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666592028;
        bh=xXKFW0mAjFSUFQ4l5IUczjHBUuE22iI2OD9/yp391Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/ZGQw6x7YGV9PxLvNWJIh6oTHiQePd4c3k6SdyrBQnTXHvrUQbBM5ScVCvp0Lkkv
         8yMdKXzOw2HGKcDVQTp0ZVqnqc5/ICE/5ATO6E7pjyo4oBtOyjG8K/f2EJ1AVWCzgl
         nZdtruGVotUMNFeIux9Hmixyxh04JlDj5ot9oN/JvymDTHcF2XGcsmiYzOq/dr8+lS
         kdlKaBIc8cdofkxupzZnq3WRBz9wqAyQexQNF1kILT8jRgWnKvyTJ3Bt0DpaiKpngk
         Lt8wyCeloVjV/Lx0+lltE7ZEiMCzSvx0Hq1XO92SV+fN/dPJhgUtIzElpCqCZBw7GN
         kMoHxpQClgL3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [V2 net 16/16] net/mlx5e: Fix macsec sci endianness at rx sa update
Date:   Mon, 24 Oct 2022 07:12:20 +0100
Message-Id: <20221024061220.81662-17-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024061220.81662-1-saeed@kernel.org>
References: <20221024061220.81662-1-saeed@kernel.org>
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

The cited commit at rx sa update operation passes the sci object
attribute, in the wrong endianness and not as expected by the HW
effectively create malformed hw sa context in case of update rx sa
consequently, HW produces unexpected MACsec packets which uses this
sa.

Fix by passing sci to create macsec object with the correct endianness,
while at it add __force u64 to prevent sparse check error of type
"sparse: error: incorrect type in assignment".

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 975fedf6bfd6..34c54c787f4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -444,7 +444,7 @@ static int mlx5e_macsec_update_rx_sa(struct mlx5e_macsec *macsec,
 		return 0;
 	}
 
-	attrs.sci = rx_sa->sci;
+	attrs.sci = cpu_to_be64((__force u64)rx_sa->sci);
 	attrs.enc_key_id = rx_sa->enc_key_id;
 	err = mlx5e_macsec_create_object(mdev, &attrs, false, &rx_sa->macsec_obj_id);
 	if (err)
-- 
2.37.3

