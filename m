Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325B560FAEB
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiJ0O5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbiJ0O5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BE5B56C2
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A209BB8267E
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB7FC433D6;
        Thu, 27 Oct 2022 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882632;
        bh=RKphfuFEND5H3il0xztnmbmz++ltSaGRZlxxeqpNybY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F45pytP4iSUvfFpDAj6fWzyyhVWUgrGAwv3fqZvj/MlS4dcDGZOGBzEgiVAiAYS54
         82WVhFy8Q2S/s0gjAmjCISSsM2pMXY3c57xmNCJSBcki1qDxO0gPf3vhqeKgebINId
         aCF6TDcbKMOamPyqFzTNLH+8wbbPwJQGVN4kSUGw/5rTzNCJJVqM5zYs/fCIIGh6GT
         zZNxs5n+V+AvcwFIG3At5Nl8V6Tm8xQOrH2eY4SYtT8PVAWTWHE6FXAb4R50dWyUX0
         iDo86br51oEOvom0Cmfoz+YFWJwAyRC1jdw4o+Gt3yM18UG97OfkcRYZiMX01WaePS
         Eenfrgo4LobDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 02/14] net/mlx5: DR, Fix the SMFS sync_steering for fast teardown
Date:   Thu, 27 Oct 2022 15:56:31 +0100
Message-Id: <20221027145643.6618-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027145643.6618-1-saeed@kernel.org>
References: <20221027145643.6618-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

If sync happens when the device is in fast teardown, just bail
and don't do anything, because the PCI device is not there any more.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 16d65fe4f654..b4739eafc180 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -271,6 +271,13 @@ int mlx5dr_cmd_sync_steering(struct mlx5_core_dev *mdev)
 {
 	u32 in[MLX5_ST_SZ_DW(sync_steering_in)] = {};
 
+	/* Skip SYNC in case the device is internal error state.
+	 * Besides a device error, this also happens when we're
+	 * in fast teardown
+	 */
+	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		return 0;
+
 	MLX5_SET(sync_steering_in, in, opcode, MLX5_CMD_OP_SYNC_STEERING);
 
 	return mlx5_cmd_exec_in(mdev, sync_steering, in);
-- 
2.37.3

