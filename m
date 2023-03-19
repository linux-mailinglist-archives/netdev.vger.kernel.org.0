Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008C16C01E2
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 14:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjCSNAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 09:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCSNA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 09:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA113C16;
        Sun, 19 Mar 2023 05:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82EB560EF9;
        Sun, 19 Mar 2023 12:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C03C433D2;
        Sun, 19 Mar 2023 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679230794;
        bh=NI3wtryqR24WCtVjzVqBt5telCfPc5nDwSLvDaOU4Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVav8MbLJB5HK5glCss5oACIC3w32q0EMdDcOdCJyNzHqDD2x0TDZzbZZgTIf7TMg
         Hjz5I5SJQXtiIm9hMrfBwvyG9aHPtBtysqyVEkxnLzfawYo8K1s+8jFjKUPDlPDov6
         s+DJU4i9rDQVOWVa5irPo+EhNGkkYL+92qPQMXkQAAnnUqUB6FS+NNj6/L8KXv4CKL
         fKS2RvCfpk+899a/qP9K4g2001VwDAYlfSIz9CoXAWIzvjI+hlHIgFjdd38ZJEey5G
         nG+S79JK7b1yOpu9WTF9Jx+qj0cq1DKuOYL07vzCsLSRRccPw/04QF9OPLhLgFaaC/
         PdYsykeA05v0Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 3/3] net/mlx5: Set out of order (ooo) by default
Date:   Sun, 19 Mar 2023 14:59:32 +0200
Message-Id: <00bd14bfb002ed2338de3296bcd9af27d4770b70.1679230449.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679230449.git.leon@kernel.org>
References: <cover.1679230449.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Har-Toov <ohartoov@nvidia.com>

When FW supports ooo by default, enable the cap.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 540840e80493..564a82ac3787 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -684,6 +684,9 @@ static int handle_hca_cap_roce(struct mlx5_core_dev *dev, void *set_ctx)
 	       MLX5_ST_SZ_BYTES(roce_cap));
 	MLX5_SET(roce_cap, set_hca_cap, sw_r_roce_src_udp_port, 1);
 
+	if (MLX5_CAP_ROCE_MAX(dev, qp_ooo_transmit_default))
+		MLX5_SET(roce_cap, set_hca_cap, qp_ooo_transmit_default, 1);
+
 	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_ROCE);
 	return err;
 }
-- 
2.39.2

