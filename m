Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426EF6E8C09
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbjDTIDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjDTID2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:03:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150E0B4
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8796D60DFC
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BD7C433D2;
        Thu, 20 Apr 2023 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681977798;
        bh=gIT5bkkTgE/24g2w9ntfJh9WPb5Ipwwud3jGHFw2zr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CApa8nCcxh9ffJ9hOjtv/tzLfX8dEZ0FFc0pHasGjsyY4F6jxFUSPWqOWSCBjW77Y
         2heKz+z/iXy8mdZNKdfqcKGEE5MCGo7uXKKSPxTUjMDrNs3cg6un7KO2JC2YoGw5ve
         yQyv4ZwJKJVHVu0HXCOu9uNe9pNdf0FnzxF4ZLH44stQe6kPDIBtagAdqSPe58tRXs
         7OfzqWchbdTzRfTe3qfFoYcMbLRDlgCIyz68s8F64ECjEpg+thIvNesl5N6LH2VZq6
         R7xoHn/XddGQy843iq33j/V+qSE/bZSrcHqFg+JPYuLlTJv7DXTgZ3z+3gu1Wpb24E
         PL/dexfZfi2Mw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 5/5] net/mlx5e: Refactor duplicated code in mlx5e_ipsec_init_macs
Date:   Thu, 20 Apr 2023 11:02:51 +0300
Message-Id: <bac66f9dfa9b72ff606573fdba6f3ad2d28c8c88.1681976818.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976818.git.leon@kernel.org>
References: <cover.1681976818.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

ARP discovery code has same logic for RX and TX flows, but with
different source and destination fields. Instead of duplicating
same code in mlx5e_ipsec_init_macs, let's refactor.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 45 +++++++++----------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 59b9927ac90f..55b38544422f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -252,6 +252,8 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct net_device *netdev;
 	struct neighbour *n;
 	u8 addr[ETH_ALEN];
+	const void *pkey;
+	u8 *dst, *src;
 
 	if (attrs->mode != XFRM_MODE_TUNNEL ||
 	    attrs->type != XFRM_DEV_OFFLOAD_PACKET)
@@ -262,36 +264,31 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5_query_mac_address(mdev, addr);
 	switch (attrs->dir) {
 	case XFRM_DEV_OFFLOAD_IN:
-		ether_addr_copy(attrs->dmac, addr);
-		n = neigh_lookup(&arp_tbl, &attrs->saddr.a4, netdev);
-		if (!n) {
-			n = neigh_create(&arp_tbl, &attrs->saddr.a4, netdev);
-			if (IS_ERR(n))
-				return;
-			neigh_event_send(n, NULL);
-			attrs->drop = true;
-			break;
-		}
-		neigh_ha_snapshot(addr, n, netdev);
-		ether_addr_copy(attrs->smac, addr);
+		src = attrs->dmac;
+		dst = attrs->smac;
+		pkey = &attrs->saddr.a4;
 		break;
 	case XFRM_DEV_OFFLOAD_OUT:
-		ether_addr_copy(attrs->smac, addr);
-		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
-		if (!n) {
-			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
-			if (IS_ERR(n))
-				return;
-			neigh_event_send(n, NULL);
-			attrs->drop = true;
-			break;
-		}
-		neigh_ha_snapshot(addr, n, netdev);
-		ether_addr_copy(attrs->dmac, addr);
+		src = attrs->smac;
+		dst = attrs->dmac;
+		pkey = &attrs->daddr.a4;
 		break;
 	default:
 		return;
 	}
+
+	ether_addr_copy(src, addr);
+	n = neigh_lookup(&arp_tbl, pkey, netdev);
+	if (!n) {
+		n = neigh_create(&arp_tbl, pkey, netdev);
+		if (IS_ERR(n))
+			return;
+		neigh_event_send(n, NULL);
+		attrs->drop = true;
+	} else {
+		neigh_ha_snapshot(addr, n, netdev);
+		ether_addr_copy(dst, addr);
+	}
 	neigh_release(n);
 }
 
-- 
2.40.0

