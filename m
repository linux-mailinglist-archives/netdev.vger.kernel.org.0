Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28D052B2B6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiERGuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiERGuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5F322B0B
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A092BB81EA0
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C4AC385A5;
        Wed, 18 May 2022 06:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856591;
        bh=qQ6frae71rXmUO661MLezVBpsW0L8FazObOB7m25oKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0rLhbO6Q0eBMq5ABis79cdFW36CbhfCNv0KsS87k+t9x9GoX+dgyPg36hD9EVL+k
         x2Rm33uwhAAFeHS5YrTvbtGkUQnsDDW9Xtuyn9Wr6824XWyf80MBTzH3gff6W+KBeu
         Snk3MKm/tQbb0dOhw0I2A19GG7hqzWQpqlF+DZbwvpm2otDU/sq9RgDBups/9GPn7x
         ioWORTfnywnxVaaLYdxZ7nBp5HchnyQ9p+G1w945OMIbxebezlnxae7Shqwd1SKN34
         Do0PMAPy9fXgh+q0BFjJOM4/gISf87hfSJVD/P48rVPmfIpGswg03F7kTRwAdjScIT
         dTxN8wBtH2jYg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5e: Support partial GSO for tunnels over vlans
Date:   Tue, 17 May 2022 23:49:31 -0700
Message-Id: <20220518064938.128220-10-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
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

Offloading outer checksum on tunnels requires GSO partial, add it to
'vlan_features' to allow offloading tunnels over vlans.
For example, running GENEVE over vlan & ipv6 (mandatory UDP checksum)
now allows for hardware TSO instead of software segmentation in GSO
only.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bf3bca79e160..29e1e1f8f49e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4812,6 +4812,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->vlan_features    |= NETIF_F_TSO6;
 	netdev->vlan_features    |= NETIF_F_RXCSUM;
 	netdev->vlan_features    |= NETIF_F_RXHASH;
+	netdev->vlan_features    |= NETIF_F_GSO_PARTIAL;
 
 	netdev->mpls_features    |= NETIF_F_SG;
 	netdev->mpls_features    |= NETIF_F_HW_CSUM;
@@ -4877,7 +4878,6 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 						NETIF_F_GSO_IPXIP6;
 	}
 
-	netdev->hw_features	                 |= NETIF_F_GSO_PARTIAL;
 	netdev->gso_partial_features             |= NETIF_F_GSO_UDP_L4;
 	netdev->hw_features                      |= NETIF_F_GSO_UDP_L4;
 	netdev->features                         |= NETIF_F_GSO_UDP_L4;
-- 
2.36.1

