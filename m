Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A02F6B8ABC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCNFna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCNFnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CA5567A2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5792B615E9
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6172C433D2;
        Tue, 14 Mar 2023 05:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772577;
        bh=1DWFvG4YJzcY/X6dsBvMYiom0AvXRQy8+DSrTcywGpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8FOWfgV3iH4Aq8Z3EVlvh9u7pE/gmBxBLchfl8X4KKTTZvPlBTanReLkD1S4Ocx1
         YEHkGFMlE7UwN3wdpP4xmgSh0GbupKEvJovWZ/WDkhXqfOMdZsN35rCAV4o0ho3yMk
         Gjsu+a9Sm5aXNykvi/DlYxJN++oiSfsC4edFNkSWC42xnTCRpVeQmOsm6UcgQ5KFyO
         U87XuvsGP0CW6Etzk19wWZUDcBVzwj6QStEQ+XZPWBpibGQ+ZSyorM9bOiSA857DI1
         4RM0QqmyqP3s4R9++lUH2kLXFfVJYuLwQZAyDtOmdNpTTRBKffCChr1Plx3HM9kgYL
         GC8Acy59H/xfA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Enable TC offload for ingress MACVLAN over bond
Date:   Mon, 13 Mar 2023 22:42:33 -0700
Message-Id: <20230314054234.267365-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

Support offloading of TC rules that filter ingress traffic from a MACVLAN
device, which is attached to bond device.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b4af006dc494..19c4a83982ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -433,6 +433,7 @@ mlx5e_rep_check_indr_block_supported(struct mlx5e_rep_priv *rpriv,
 {
 	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct net_device *macvlan_real_dev;
 
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
 	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
@@ -450,7 +451,11 @@ mlx5e_rep_check_indr_block_supported(struct mlx5e_rep_priv *rpriv,
 			return false;
 		}
 
-		if (macvlan_dev_real_dev(netdev) == rpriv->netdev)
+		macvlan_real_dev = macvlan_dev_real_dev(netdev);
+
+		if (macvlan_real_dev == rpriv->netdev)
+			return true;
+		if (netif_is_bond_master(macvlan_real_dev))
 			return true;
 	}
 
-- 
2.39.2

