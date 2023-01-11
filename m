Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36E76653D9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbjAKFja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjAKFiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55B110D6;
        Tue, 10 Jan 2023 21:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E73DB819CA;
        Wed, 11 Jan 2023 05:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC2FC433D2;
        Wed, 11 Jan 2023 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415062;
        bh=PNeIzQ0BnCCovzN26qdzCCU+T0YlKNW4vpIvPE3ZHSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SV9Se2yvGJJbFyAm5bX/oXyPlKZNWcETVgK1zz2U1W8FRiy+YBTnbSEhbS5XABTt7
         EbTTeF41N2p07sNIzQZmmv/jXzXyM62/PmLHJh7scz2RznV2tFKcfTqWyDOOP2CRGy
         z360IWf5Pus4cxkH/rYIhd/D/hQ+BCFyt5I+QWsmHqDM7qiP98LhXaiNv28G1lH/iG
         ZDCupRW2IgnxaeSPAcVPnanOFA8xc9GaEfhc4MrM9cs8vUNWL4MNK1jQjJUEappysT
         wKjNa5EqxHmtWv97WLEoH/+j/yC6UsMeCF+qdMWLT9Sj9/RzBoDxy9BTmVjbA7oJm4
         PRmf3eokfnfeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-rdma@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Replace 0-length array with flexible array
Date:   Tue, 10 Jan 2023 21:30:43 -0800
Message-Id: <20230111053045.413133-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: Kees Cook <keescook@chromium.org>

Zero-length arrays are deprecated[1]. Replace struct mlx5e_rx_wqe_cyc's
"data" 0-length array with a flexible array. Detected with GCC 13,
using -fstrict-flex-arrays=3:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_alloc_rq':
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:827:42: warning: array subscript f is outside array bounds of 'struct mlx5_wqe_data_seg[0]' [-Warray-bounds=]
  827 |                                 wqe->data[f].byte_count = 0;
      |                                 ~~~~~~~~~^~~
In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h:11,
                 from drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:48,
                 from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:42:
drivers/net/ethernet/mellanox/mlx5/core/en.h:250:39: note: while referencing 'data'
  250 |         struct mlx5_wqe_data_seg      data[0];
      |                                       ^~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7cbd71f0b8ae..82573ac722d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -247,7 +247,7 @@ struct mlx5e_rx_wqe_ll {
 };
 
 struct mlx5e_rx_wqe_cyc {
-	struct mlx5_wqe_data_seg      data[0];
+	DECLARE_FLEX_ARRAY(struct mlx5_wqe_data_seg, data);
 };
 
 struct mlx5e_umr_wqe {
-- 
2.39.0

