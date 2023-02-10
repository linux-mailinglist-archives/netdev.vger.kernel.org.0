Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BEF6929F8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbjBJWTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbjBJWS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258407E8F6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C779FB82600
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820D8C433EF;
        Fri, 10 Feb 2023 22:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067514;
        bh=4RylD1+QgEHlXROUt365Og+KQdvLIFdi3neuxri9Nu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVUZ5nE0MeUeSvQRvjOEwu8mL2ahCuQg09IdT8n3+kNOjp7xvnurHf6chk5WVVCVa
         DZYjtEDsT82xa71yx2IZ2kdndgQIUUzbHzD+5xbAedAxrdfMlzVd8Op55uw6FyXxyW
         btE+gpa00D2pXljHa3gmNaZx6OdOrJby7LG+a4hLAmRvW6whywGKRz5A2w94C6Epwi
         gofqdUg6XWsKfEYekVNru0MPfNwehYu8EPosbPw2i3NneEwu16zl4MUGlHqeWPsYdy
         PQV4CaicKR2VrVLSyEqH1MOchog91yjWbSO0ElvW3X/PQZQ+wrh4zuOy9hAeuJXUmw
         VsdiJDH5/5PAA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Use a simpler comparison for uplink rep
Date:   Fri, 10 Feb 2023 14:18:12 -0800
Message-Id: <20230210221821.271571-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

get_route_and_out_devs()  is uses the following condition
mlx5e_eswitch_rep() && mlx5e_is_uplink_rep() to check if a given netdev is the
uplink rep.

Alternatively we can just use the straight forward version
mlx5e_eswitch_uplink_rep() that only checks if a given netdev is uplink rep.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 684c0293a4d6..00a04fdd756f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -93,8 +93,7 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 	else
 		return -EOPNOTSUPP;
 
-	if (!(mlx5e_eswitch_rep(*out_dev) &&
-	      mlx5e_is_uplink_rep(netdev_priv(*out_dev))))
+	if (!mlx5e_eswitch_uplink_rep(*out_dev))
 		return -EOPNOTSUPP;
 
 	if (mlx5e_eswitch_uplink_rep(priv->netdev) && *out_dev != priv->netdev &&
-- 
2.39.1

