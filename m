Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BAE50688F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350614AbiDSKR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350591AbiDSKRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2B713CFB
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:15:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E34DCB81651
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F27C385A7;
        Tue, 19 Apr 2022 10:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363302;
        bh=RzNVrIlb72ynOl7Enk1/ch5qBhk/Dwwk6Cey1dPF/wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQbji+yM+CNUnL8A7xXYDOaf/WUt3WzutM6I5UMpV2sVWi4wDO0AMsyD63TwscTuX
         1KYyvAgEfAoJs7jX6IziQlayUsT2/qpA3hRE6X/XvRlnl2B+2QzpW4SXUNmrDOaVA3
         sK5FJ5QFku+uJjTTivHBU/3XQU/nGXO89ueFXIbvI8W1QmYZtHyKv+7D3Q2c8XuDBM
         PL1HbOWyGU7Jt8qddgD9+6KcO2CeOD+kLuYqWVoPDuHhlwUNQU9+pVjz01BNYy+2hz
         f29JybuMcAzUS6+U2xyzskZR19zwh6e2sEK9Ya/IiDaCksHYJ7FTA623B85hX/8IJD
         VSnMjS+1H8w5A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 17/17] net/mlx5: Don't perform lookup after already known sec_path
Date:   Tue, 19 Apr 2022 13:13:53 +0300
Message-Id: <094fd1122067e9c52c4792951d26e9644864bb19.1650363043.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363043.git.leonro@nvidia.com>
References: <cover.1650363043.git.leonro@nvidia.com>
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

There is no need to perform extra lookup in order to get already
known sec_path that was set a couple of lines above. Simply reuse it.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index d30922e1b60f..6859f1c1a831 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -332,7 +332,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 		return;
 	}
 
-	sp = skb_sec_path(skb);
 	sp->xvec[sp->len++] = xs;
 	sp->olen++;
 
-- 
2.35.1

