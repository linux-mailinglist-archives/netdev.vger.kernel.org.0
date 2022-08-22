Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B3059C974
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiHVUAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiHVT7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4521E4F1B7
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C781D61274
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF14C433D6;
        Mon, 22 Aug 2022 19:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198377;
        bh=QxWggh2glKOf3N8D4zIt02VQ7APjnoXvrI0k+rmmpMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMosyn8cARC0nk5M0bWeFkIYgENP9R6M53KQgB9Pm/XEhPz50QVDF/X8FYdpTb4oY
         qvgVVQdFZz1BRVpv+t8onWZpQzvzHnRVYydlzqhgdeylcAufDlaigzuhSLLZ0ONrlf
         n9x76oa9mNkAJOERtlkrpU0uyTfOQ3xzgLirw7pV2m80pLodSmu0jI6goITyPXAj1a
         cA/KReZ/lknZnn3l/CQRdx6BpNoTp/ePt/uKJm8AVNr2zxfsdAWlUlk/XAq8sHnqpl
         g1b1zboz/0pWIsvc1GX32VwYdHfPeUJ8ejdOnMzzVCPXQoHa0ObRS2feEDKOY5NIrN
         GLhiM/izxvQ+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Maor Dickman <maord@nvidia.com>
Subject: [net 09/13] net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off
Date:   Mon, 22 Aug 2022 12:59:13 -0700
Message-Id: <20220822195917.216025-10-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

The cited commit reintroduced the ability to set hw-tc-offload
in switchdev mode by reusing NIC mode calls without modifying it
to support both modes, this can cause an illegal memory access
when trying to turn hw-tc-offload off.

Fix this by using the right TC_FLAG when checking if tc rules
are installed while disabling hw-tc-offload.

Fixes: d3cbd4254df8 ("net/mlx5e: Add ndo_set_feature for uplink representor")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c65b6a2883d3..02eb2f0fa2ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3682,7 +3682,9 @@ static int set_feature_hw_tc(struct net_device *netdev, bool enable)
 	int err = 0;
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-	if (!enable && mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD))) {
+	int tc_flag = mlx5e_is_uplink_rep(priv) ? MLX5_TC_FLAG(ESW_OFFLOAD) :
+						  MLX5_TC_FLAG(NIC_OFFLOAD);
+	if (!enable && mlx5e_tc_num_filters(priv, tc_flag)) {
 		netdev_err(netdev,
 			   "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 		return -EINVAL;
-- 
2.37.1

