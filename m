Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281754E44EE
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiCVRYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 13:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbiCVRYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 13:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D1975628
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 10:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A838A614D0
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF4BC340EC;
        Tue, 22 Mar 2022 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647969751;
        bh=CBuZg8t0JAfyduiqIxoJtH79qjEI9wfXXU/yeL+6kMI=;
        h=From:To:Cc:Subject:Date:From;
        b=phWHlboICHnpo0ailJpLWXNszMAga7FQKfLNNx1eMWmGyzCSgTLoZQcCEggVH057N
         MMn29XHaywdVQ1QlqkHtROyjNxbCsvwjZ0cRB4m/rfuOcWZAqat8nx7cXXbjaOeItg
         83k4B8WxvmoCH9C9UHMjrkKUWBWbp48CWSYVAjwuABG67i6bwc3OPHqLEsxDZbqb+/
         2LrHpUXuqCCdwHbSsgPKh8gpeipxjuMKk/VWMVXT8jfqY0GSohw4Wlcj0POL+OxAGs
         aSxAjP4H0bGba/BTo2Mzdk5wcwI+2nGg5OL7x1FT3n3LJ3YbW052dFhn9ggPf6z2KH
         vj/YbAvxg9enw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, keescook@chromium.org, maximmi@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] net/mlx5e: Fix build warning, detected write beyond size of field
Date:   Tue, 22 Mar 2022 10:22:24 -0700
Message-Id: <20220322172224.31849-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

When merged with Linus tree, the cited patch below will cause the
following build warning:

In function 'fortify_memset_chk',
    inlined from 'mlx5e_xmit_xdp_frame' at drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:438:3:
include/linux/fortify-string.h:242:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  242 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix that by grouping the fields to memeset in struct_group() to avoid
the false alarm.

Fixes: 9ded70fa1d81 ("net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 3 +--
 include/linux/mlx5/qp.h                          | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f35b62ce4c07..8f321a6c0809 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -435,8 +435,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 		u8 num_pkts = 1 + num_frags;
 		int i;
 
-		memset(&cseg->signature, 0, sizeof(*cseg) -
-		       sizeof(cseg->opmod_idx_opcode) - sizeof(cseg->qpn_ds));
+		memset(&cseg->trailer, 0, sizeof(cseg->trailer));
 		memset(eseg, 0, sizeof(*eseg) - sizeof(eseg->trailer));
 
 		eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 61e48d459b23..8bda3ba5b109 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -202,6 +202,9 @@ struct mlx5_wqe_fmr_seg {
 struct mlx5_wqe_ctrl_seg {
 	__be32			opmod_idx_opcode;
 	__be32			qpn_ds;
+
+	struct_group(trailer,
+
 	u8			signature;
 	u8			rsvd[2];
 	u8			fm_ce_se;
@@ -211,6 +214,8 @@ struct mlx5_wqe_ctrl_seg {
 		__be32		umr_mkey;
 		__be32		tis_tir_num;
 	};
+
+	); /* end of trailer group */
 };
 
 #define MLX5_WQE_CTRL_DS_MASK 0x3f
-- 
2.35.1

