Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C333C6268D1
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiKLKWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiKLKWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E6124F29
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3596E60B92
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8480FC433C1;
        Sat, 12 Nov 2022 10:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248522;
        bh=r4ka1jWrh4ZvtZ7oEy7jPrM6uUzsCiIoCv7HeKaz43o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeyuDHXy3rBk+uHQj2yh8K94rWjgpYIifdgYF8xTlAb3exFBP0YHxKoV9EUA0ZPmt
         xFqezqmxajCE20067QEr3hjSyQ7vyhxcFPGfv4IdIbuV+m4IZn5+joAZ/ZwOWeg0Ql
         9FryIQyrlntGfSss24h2cJ177kHq85/m4GbP3al2VSibDosPntR9y49in15SrUnalU
         OKTjfpaHTLu82ce3+sVrFRkrB+xwbrEq4V33T11uPVfCDPlJmDVE9MzJAtgEYhxLfc
         4hAqyot0Pzuf4o4xaNbMS1rxXiLpTmrHhMWQtRCPPprTdfA1yo9sB4OUT7KN3tusSQ
         YrAxWGTPY4TVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: TC, Remove redundant WARN_ON()
Date:   Sat, 12 Nov 2022 02:21:42 -0800
Message-Id: <20221112102147.496378-11-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The case where the packet is not offloaded and needs to be restored
to slow path and couldn't find expected tunnel information should not
dump a call trace to the user. there is a debug call.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index fac7e3ff2674..b08339d986d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -690,7 +690,6 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 
 	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
 	if (err) {
-		WARN_ON_ONCE(true);
 		netdev_dbg(priv->netdev,
 			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
 			   tun_id, err);
-- 
2.38.1

