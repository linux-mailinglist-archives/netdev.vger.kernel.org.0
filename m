Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD1671691
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjARIwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjARIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC94A9AA9E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EBBD616FC
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B892FC43392;
        Wed, 18 Jan 2023 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029071;
        bh=FMqvL9QE9l7ezWvLJjyYowSptHhF9HlQ/SnoqbZbQQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S57e3cooDec0esvmoUkyjK9fJfRX5qeQqVmr+AP900VEdjTr4h3YLFspW9O8Rse19
         gq8HuAKV1/GtbxgorX2ki0ZMfIgNK9nU0wO3QWhxbAN4Ihbk/p9JmuvDw8uym8SSon
         7CJEnKB3vsgSRnD+L9HLpyz8y6Ffr+72Z21toixN4LFadbFOj2nGq6H9pqM7ZP52o+
         PcdKq7d04pstG+6KaIcavcOElu04jKJa3GKdDFw1VyNRRKO/zvkHgKBVEkzdw3UGcB
         cCVooT6UIi9fNSkJwR1lthYLmmNcBeDEjzviAyyQkuYwDR6j5ZSsyhDsNsoPzrmUf7
         X10uLwYs8+7Ag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [net 03/10] net/mlx5e: Remove redundant xsk pointer check in mlx5e_mpwrq_validate_xsk
Date:   Wed, 18 Jan 2023 00:04:07 -0800
Message-Id: <20230118080414.77902-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

This validation function is relevant only for XSK cases, hence it
assumes to be called only with xsk != NULL.
Thus checking for invalid xsk pointer is redundant and misleads static
code analyzers.
This commit removes redundant xsk pointer check.

This solves the following smatch warning:
drivers/net/ethernet/mellanox/mlx5/core/en/params.c:481
mlx5e_mpwrq_validate_xsk() error: we previously assumed 'xsk' could be
null (see line 478)

Fixes: 6470d2e7e8ed ("net/mlx5e: xsk: Use KSM for unaligned XSK")
Signed-off-by: Adham Faris <afaris@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 585bdc8383ee..4ad19c981294 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -578,7 +578,6 @@ int mlx5e_mpwrq_validate_xsk(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 {
 	enum mlx5e_mpwrq_umr_mode umr_mode = mlx5e_mpwrq_umr_mode(mdev, xsk);
 	u8 page_shift = mlx5e_mpwrq_page_shift(mdev, xsk);
-	bool unaligned = xsk ? xsk->unaligned : false;
 	u16 max_mtu_pkts;
 
 	if (!mlx5e_check_fragmented_striding_rq_cap(mdev, page_shift, umr_mode))
@@ -591,7 +590,7 @@ int mlx5e_mpwrq_validate_xsk(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 	 * needed number of WQEs exceeds the maximum.
 	 */
 	max_mtu_pkts = min_t(u8, MLX5E_PARAMS_MAXIMUM_LOG_RQ_SIZE,
-			     mlx5e_mpwrq_max_log_rq_pkts(mdev, page_shift, unaligned));
+			     mlx5e_mpwrq_max_log_rq_pkts(mdev, page_shift, xsk->unaligned));
 	if (params->log_rq_mtu_frames > max_mtu_pkts) {
 		mlx5_core_err(mdev, "Current RQ length %d is too big for XSK with given frame size %u\n",
 			      1 << params->log_rq_mtu_frames, xsk->chunk_size);
-- 
2.39.0

