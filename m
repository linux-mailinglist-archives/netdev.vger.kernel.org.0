Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B71960B651
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiJXSy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiJXSyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:54:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEC1FE93D
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2EE961274
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F76C433D6;
        Mon, 24 Oct 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620016;
        bh=RKphfuFEND5H3il0xztnmbmz++ltSaGRZlxxeqpNybY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFIcUpolztCsRX7dWujdu1kGSdcq1N1YYXyTkZNQm6JSoY22aHmAFPaA82gN/ME+Z
         +a9xyh5BSlUgPAcrB4SqasNqA4Q/aRmAkGFHEN2EYLRyyWRMbJpj5AtAGKj6+EO9k9
         ZDeD2c7fD3azlQNt7VQ+VCxXLo3B3gAoV+PMYIvEQ/2IzMC0P1D3uZJFOQ2A/U81rd
         Rzqz2zGZFB4yVV7t0ss+JKaB4XP3+r5l04VOJQyOOKCkyWajBbJZAGeTQj4BQnkECL
         uLcfnoA0Rx998kI9vf0dgCMCxEoaahU+fu+qJM4fsEt0suqVadsySCTZ5x33r5BpO/
         5GNCnx+tacLxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 02/14] net/mlx5: DR, Fix the SMFS sync_steering for fast teardown
Date:   Mon, 24 Oct 2022 14:57:22 +0100
Message-Id: <20221024135734.69673-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
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

