Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF6063334E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiKVC3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiKVC2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107D217A99
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A263661544
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED55BC433D6;
        Tue, 22 Nov 2022 02:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084112;
        bh=bGs7CV+Y2dNssitD997BmbOSEG4YePdv89mstWnmysc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2j465CdvnC5dlGM3Y/g+klZjgUWugbPucx26XvlmDwTBUu5EOc8RPnLGOhCai1Fg
         s3BVxaP5KJ9pWT4koU8BYuSa7+tVt2fCbjwp74OZxgXJkkn4o0GX/y+LJKYuNjvEuJ
         h9juXBXmFbjuQbNTfPJbknw2HRZzoFTN+OccWaC7B/pc97xd8qznrnSpE86uNxTYKD
         Ai72y7x69b7wnnVDMlW1J+nkl1WyXPibp7Q7/mqk5qoSEV80zBLlqpo9JeJf9CXD6B
         afsIxpVqrAl542Q6A1FIdYt5y25YXudJGVCOKgSqQgOw7dWWrLZ2W/FJfsRN6iKgQJ
         l8V5cqg/x5NVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net 09/14] net/mlx5e: Fix missing alignment in size of MTT/KLM entries
Date:   Mon, 21 Nov 2022 18:25:54 -0800
Message-Id: <20221122022559.89459-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

In the cited patch, an alignment required by the HW spec was mistakenly
dropped. Bring it back to fix error completions like the below:

mlx5_core 0000:00:08.0 eth2: Error cqe on cqn 0x40b, ci 0x0, qn 0x104f, opcode 0xd, syndrome 0x2, vendor syndrome 0x68
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000030: 00 00 00 00 86 00 68 02 25 00 10 4f 00 00 bb d2
WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0x0, len: 192
00000000: 00 00 00 25 00 10 4f 0c 00 00 00 00 00 18 2e 00
00000010: 90 00 00 00 00 02 00 00 00 00 00 00 20 00 00 00
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000080: 08 00 00 00 48 6a 00 02 08 00 00 00 0e 10 00 02
00000090: 08 00 00 00 0c db 00 02 08 00 00 00 0e 82 00 02
000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Fixes: 9f123f740428 ("net/mlx5e: Improve MTT/KSM alignment")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e3a4f01bcceb..5e41dfdf79c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -206,10 +206,11 @@ static void mlx5e_disable_blocking_events(struct mlx5e_priv *priv)
 static u16 mlx5e_mpwrq_umr_octowords(u32 entries, enum mlx5e_mpwrq_umr_mode umr_mode)
 {
 	u8 umr_entry_size = mlx5e_mpwrq_umr_entry_size(umr_mode);
+	u32 sz;
 
-	WARN_ON_ONCE(entries * umr_entry_size % MLX5_OCTWORD);
+	sz = ALIGN(entries * umr_entry_size, MLX5_UMR_MTT_ALIGNMENT);
 
-	return entries * umr_entry_size / MLX5_OCTWORD;
+	return sz / MLX5_OCTWORD;
 }
 
 static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
-- 
2.38.1

