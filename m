Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B966960E2B3
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiJZNy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiJZNxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33D110A7D9
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 838BCB82256
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B72C433D7;
        Wed, 26 Oct 2022 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792385;
        bh=Fb0pkpYXR559oBSHzj9ICqgfckZddz7MTbsku91saIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1n1xZgcv7QKrPOJQEKigC1cFHnBpOmvVUvO2ocGkHn3FEF6mJ5DIKqkr+eqSqPWT
         jmWxASKjMCzZUzWiapbZun4Ad3CS4UBKbplNh79Z7kSwlBW/UO/0vQoFjaZ+wkcE05
         bfFWj4EEurHEL4GqaPsZJHdGLBL22uXgcs6+6UrJ0QF1x+ep+TrOZKlTg0nx8AOW1+
         B9YWhvGge66eeZPzTL+qSqzFLvstGaFaq8vgJvKHhLahGuRc+/pygDZemVOO8BpD7R
         H4gsZd3Bd41FgoAHS9skBttsFXjWtq6HISodkel2brWovvCchwQnE0KTeYdRHfg0NB
         39klvJS5boOVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [V4 net 15/15] net/mlx5e: Fix macsec sci endianness at rx sa update
Date:   Wed, 26 Oct 2022 14:51:53 +0100
Message-Id: <20221026135153.154807-16-saeed@kernel.org>
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

