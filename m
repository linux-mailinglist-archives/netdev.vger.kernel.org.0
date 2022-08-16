Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6675959FD
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiHPLZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiHPLYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DE8EA88A
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B1BF60FBE
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BB6C433B5;
        Tue, 16 Aug 2022 10:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646345;
        bh=OtIIS7cJGiQYCzJ9ETdaEvVXVCv1hq6AzPYb0lNThaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwrOjk+9GBpiIEX7LFTVdGh/oyAUfzoPgfS0EQ3RiX5lvgFtSDT8nOM2IU9m2QTO1
         etDd+aRizfpvj+ek9bIuDYPxw4B+AJZSRVQvQccQvojx035iiaXSF3iphOs4dX3ZQ5
         5qKUx2xQYQ0nW4BpVEunzQ7+oXiBGNP8e2oRY27DMPeTua+N15MrOTv+WBFI/L5ftb
         vaXghNgyptTERo0LyjegPLkvq31KZ/7/b5+YeLrZ/zqAPFDSy51om5XheTMXHvDcZ1
         B4BNnPkeeYQT7J3fRpc8mhQZ3B6BXMhWixWFtdM6HBCSybzwGRJTXfLEucW4BfYgNd
         v8AbRrUMrrLCw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 10/26] net/mlx5e: Validate that IPsec full offload can handle packets
Date:   Tue, 16 Aug 2022 13:37:58 +0300
Message-Id: <f8b88b306ec18a32bd9ffd15e4ecadf537550da1.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

Add specific to IPsec full offload check to drop packets that are
larger than MTU and such are going to be fragmented.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c    | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 56d70bbb4b5c..f8ba2d7581e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -409,6 +409,8 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 
 static bool mlx5e_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
+	struct net_device *netdev = x->xso.real_dev;
+
 	if (x->props.family == AF_INET) {
 		/* Offload with IPv4 options is not supported yet */
 		if (ip_hdr(skb)->ihl > 5)
@@ -419,6 +421,17 @@ static bool mlx5e_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 			return false;
 	}
 
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
+		/* Fragmented packets */
+		if (skb_is_gso(skb)) {
+			if (!skb_gso_validate_network_len(skb, netdev->mtu))
+				return false;
+		} else {
+			if (skb->len > netdev->mtu)
+				return false;
+		}
+	}
+
 	return true;
 }
 
-- 
2.37.2

