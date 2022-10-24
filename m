Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028E760A4BC
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 14:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiJXMPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 08:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiJXMPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 08:15:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2771679603
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710A7612DC
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714F3C433D7;
        Mon, 24 Oct 2022 11:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612522;
        bh=Fb0pkpYXR559oBSHzj9ICqgfckZddz7MTbsku91saIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHoPhHCkHRJRL9TgA+Oy5yR9Gd5PhGhuHy2ekBIKyVvTt/nATJpgLF+NO4DlxPozT
         ANNWZ1eAknajrVOiRNcl34YEqzZI+kUyYQwL1bvWgG71Wv7k5glPs+F5LerVIZsKCo
         YMecKCZu70olZ/lJ1oPF4d6VFoMhR+2izj/6LcgK32bQpdJHs0m+BQdIKpqZRNlZGZ
         4/hLengtikJddHnDH4SWZWaRfq96WYUahXB8rE8+01wEN3uICPzuy27xM/zxg9/Uoe
         Nxekd3khIcq//J1/9h2nGbO6iWUA4RWye8CGanUSUv4zeOt736wc0leWWSqvIrZpBU
         OyJcafIw4tYuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [V3 net 16/16] net/mlx5e: Fix macsec sci endianness at rx sa update
Date:   Mon, 24 Oct 2022 12:53:57 +0100
Message-Id: <20221024115357.37278-17-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024115357.37278-1-saeed@kernel.org>
References: <20221024115357.37278-1-saeed@kernel.org>
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
index 6ae9fcdbda07..2ef36cb9555a 100644
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

