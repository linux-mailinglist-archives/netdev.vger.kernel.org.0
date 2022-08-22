Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C7959C976
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiHVUAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiHVT7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC0A4D4E8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE41AB8105A
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57874C433D6;
        Mon, 22 Aug 2022 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198371;
        bh=xkV0twbjQR50udq2bUH2HyDeN0Ibtxxq4KfhGxWxup0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjZQWMQe4B5vbjb0e7czcB8+wg7gmMDrOSChK73aPpCgTJ2nKr1KWvQumBuBaQ7Kk
         wIV730z5k0zQPzGQ5nzkJcJI7BWs0N7P1UHnp1vPb7Kb8h0KmGGVBiQ7Q4IvMy9sda
         8O2x7N7UvNQncdizcYMT7SKikaESlusb4EwOyBtY3Arl2Oo2LeqeN4hpabMH8FdX/o
         G5kM8ZjakRjHmMj4PbFChCzgSWf9If/vsnXHm64BOrFmfYhS1lYaRnLVOmF0bLEv60
         uBU/V9tCc546CKMAAUcSZ24hcTc75ppW1I1EoDRFjTTumLTknqhh6rGiKuENUlyXti
         7bchJkYnJv3yg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net 03/13] net/mlx5: Eswitch, Fix forwarding decision to uplink
Date:   Mon, 22 Aug 2022 12:59:07 -0700
Message-Id: <20220822195917.216025-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
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

From: Eli Cohen <elic@nvidia.com>

Make sure to modify the rule for uplink forwarding only for the case
where destination vport number is MLX5_VPORT_UPLINK.

Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ed73132129aa..10b0b260f02b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -427,7 +427,8 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 		dest[dest_idx].vport.vhca_id =
 			MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
 		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
-		if (mlx5_lag_mpesw_is_activated(esw->dev))
+		if (dest[dest_idx].vport.num == MLX5_VPORT_UPLINK &&
+		    mlx5_lag_mpesw_is_activated(esw->dev))
 			dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	}
 	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
-- 
2.37.1

