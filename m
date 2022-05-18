Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB352B280
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiERGfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiERGez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E558DE52A8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BA8CB81E9C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B76DC34100;
        Wed, 18 May 2022 06:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855687;
        bh=TGSIj/GwvgWo9uNpeIbNWCnxdvPyL6WrSmvz1CoAfWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkNcS13zmL0ROSxc/GwukgUKBEp1pyYWSwn1A49CWRESt7ImSEERpPbAYAQ5M671b
         OhN3Lzv5FoSoExZqKWS6ln5TnFHM9TUMCM/GwY0gKuMtbTiRhmMWf277HJeElMu53D
         z1bVUrnOdoMPnber2d2sX3iY0LztVwyVYHCxV7jmk/6Im0guSuhg3j2QzAp1E2/hda
         8DOxg9E5+QDh7smI7GjcRSBRvQH12IakDyYXaJhWkZcNq12K8WEnUgAktltQlsSbD6
         KdvCowUfsWZog5ox4nfThMLsHkgxlfdEOXV53J3cldu23A9qnuRcooVT1ChPBovhha
         cL6Q69pzRJKNQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/11] net/mlx5e: Remove HW-GRO from reported features
Date:   Tue, 17 May 2022 23:34:24 -0700
Message-Id: <20220518063427.123758-9-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518063427.123758-1-saeed@kernel.org>
References: <20220518063427.123758-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

We got reports of certain HW-GRO flows causing kernel call traces, which
might be related to firmware. To be on the safe side, disable the
feature for now and re-enable it once a driver/firmware fix is found.

Fixes: 83439f3c37aa ("net/mlx5e: Add HW-GRO offload")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6afd07901a10..fa229998606c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4873,10 +4873,6 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
 
-	if (!!MLX5_CAP_GEN(mdev, shampo) &&
-	    mlx5e_check_fragmented_striding_rq_cap(mdev))
-		netdev->hw_features    |= NETIF_F_GRO_HW;
-
 	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
 		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |= NETIF_F_TSO;
-- 
2.36.1

