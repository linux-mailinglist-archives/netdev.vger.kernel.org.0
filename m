Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530BD5F0FFB
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiI3Q3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiI3Q3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4055B97
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF55B82976
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132DFC433B5;
        Fri, 30 Sep 2022 16:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555370;
        bh=QCGakGkdixx6kvUlm4t3/PGQl1llxl4i2SRQpfup3kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMte5UbsryM95ELyY5Dl816Cth1vcIOA3r8aRf+giZhGyIcDbQM934MSToX+OjrXF
         yJ6xfC/rscpg+BthvRReHV3F/kG+2Dl9Rssz8vAVA+oAXvYXX1tflz9ZhzH5iLZh3D
         cLu2eSaxtJIwljnJaPpoW/9XwF4txGDPYdyAwnaDvbAtpbAJxI2Koi9WNFHzgGzKzN
         tiur5ulRK1stlUyJpUgg9Mz7TDd0RKcOfNtIyrQ/+cHokm/3bl+/XXsvUU/DafwvH2
         simobFf20MDGtzgdlK365Rv28BaxtIoWncp8NuaVXGFBPYyyJu5a4lWMYCw6gBBORG
         bUZgvObUhSDTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 04/16] net/mlx5e: Make the wqe_index_mask calculation more exact
Date:   Fri, 30 Sep 2022 09:28:51 -0700
Message-Id: <20220930162903.62262-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The old calculation of wqe_index_mask may give false positives, i.e.
request bulking of pairs of WQEs when not strictly needed, for example,
when the first fragment size is equal to the PAGE_SIZE, bulking is not
needed, even if the number of fragments is odd.

Make the calculation more exact to cut false positives.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 49306a68b3b5..ac4d70bb21e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -648,7 +648,26 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	 * is not completed yet, WQE 2*N must not be allocated, as it's
 	 * responsible for allocating a new page.
 	 */
-	info->wqe_index_mask = info->num_frags % 2;
+	if (frag_size_max == PAGE_SIZE) {
+		/* No WQE can start in the middle of a page. */
+		info->wqe_index_mask = 0;
+	} else {
+		/* PAGE_SIZEs starting from 8192 don't use 2K-sized fragments,
+		 * because there would be more than MLX5E_MAX_RX_FRAGS of them.
+		 */
+		WARN_ON(PAGE_SIZE != 2 * DEFAULT_FRAG_SIZE);
+
+		/* Odd number of fragments allows to pack the last fragment of
+		 * the previous WQE and the first fragment of the next WQE into
+		 * the same page.
+		 * As long as DEFAULT_FRAG_SIZE is 2048, and MLX5E_MAX_RX_FRAGS
+		 * is 4, the last fragment can be bigger than the rest only if
+		 * it's the fourth one, so WQEs consisting of 3 fragments will
+		 * always share a page.
+		 * When a page is shared, WQE bulk size is 2, otherwise just 1.
+		 */
+		info->wqe_index_mask = info->num_frags % 2;
+	}
 
 out:
 	/* Bulking optimization to skip allocation until at least 8 WQEs can be
-- 
2.37.3

