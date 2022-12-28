Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1043765867C
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiL1ToG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiL1Tnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C6E12A93
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09F78B818EF
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02F0C433D2;
        Wed, 28 Dec 2022 19:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256628;
        bh=CyxulKxH0iXlTzlL/8dzwjQMH1mMEtWqeorEIFDJ5Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C37kd7a99rWHkiQtIxTbNPx7fanGO+pnrNQaFIzOtNV0lAesUBkHrc/rMjpnIAM4w
         GlhKoQtjwGkFRVxT1qNM9Yp7usmCTU53k4gVA+1eSQVT4QaOgNDOWrnIuVHBpTXFX1
         grETyPXWyYvTthMQgln6dn+B9gVZRfbyz0e4y8YDJkmMX55RrKqu5JwCmJfvQXRKKU
         k7DWRX5RnYZPtOlX4GCcymDSostjtU3wH9LkUEyAIVoUghZDLWt9y/SIsrvUJ4/Hz8
         TP270Q2XH0ET6H0hFDnJzwjDLetofJua3SQorYq25BIQ45tzmKDZMTwtRZJdlyjwD4
         uBfU0OYJXjVpw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net 10/12] net/mlx5e: Fix hw mtu initializing at XDP SQ allocation
Date:   Wed, 28 Dec 2022 11:43:29 -0800
Message-Id: <20221228194331.70419-11-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

From: Adham Faris <afaris@nvidia.com>

Current xdp xmit functions logic (mlx5e_xmit_xdp_frame_mpwqe or
mlx5e_xmit_xdp_frame), validates xdp packet length by comparing it to
hw mtu (configured at xdp sq allocation) before xmiting it. This check
does not account for ethernet fcs length (calculated and filled by the
nic). Hence, when we try sending packets with length > (hw-mtu -
ethernet-fcs-size), the device port drops it and tx_errors_phy is
incremented. Desired behavior is to catch these packets and drop them
by the driver.

Fix this behavior in XDP SQ allocation function (mlx5e_alloc_xdpsq) by
subtracting ethernet FCS header size (4 Bytes) from current hw mtu
value, since ethernet FCS is calculated and written to ethernet frames
by the nic.

Fixes: d8bec2b29a82 ("net/mlx5e: Support bpf_xdp_adjust_head()")
Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8d36e2de53a9..cff5f2e29e1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1305,7 +1305,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
-	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN;
 	sq->xsk_pool  = xsk_pool;
 
 	sq->stats = sq->xsk_pool ?
-- 
2.38.1

