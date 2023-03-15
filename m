Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9A96BC045
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjCOW6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCOW6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8A512BED
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A2B761EA8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5DBC4339C;
        Wed, 15 Mar 2023 22:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921130;
        bh=mdETvqf2oL9oH+IfFZXIEosb/DcnJaIJ/GXWT2owDYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZWJqtRYSF7yflldkiZNpephskotBcAkVg4xKf0CP4Szq84YiNAxPDhA65R141M32
         ifhEcW+irY3xfxVNMcLDvwllex0GTwt8/B/nsLcx6ZAlIKyKqXMhL8ytf82RCZW+1n
         y8fLbYe/UuY6T+ca2V98BQQiuvS9f7SfMNBUEcSZWsxvleOiKLoIWib5lYwPCAKHy5
         0xs0qJMrM1xjU8Q20/AuvvC9TIcYG5ymDvnzE6iW8ElyRWjeOB3u4ttC6DNDbBsD+Y
         NvvwTnGXyX2z2PubZ/JX9f4D8f7Ks8TsWYJ+vMCX/npN36tOz403EausaWQMhSeAgq
         kg943vI5xiM4A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net V2 01/14] net/mlx5e: Fix macsec ASO context alignment
Date:   Wed, 15 Mar 2023 15:58:34 -0700
Message-Id: <20230315225847.360083-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently mlx5e_macsec_umr struct does not satisfy hardware memory
alignment requirement. Hence the result of querying advanced steering
operation (ASO) is not copied to the memory region as expected.

Fix by satisfying hardware memory alignment requirement and move
context to be first field in struct for better readability.

Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 08d0929e8260..8af53178e40d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -89,8 +89,8 @@ struct mlx5e_macsec_rx_sc {
 };
 
 struct mlx5e_macsec_umr {
+	u8 __aligned(64) ctx[MLX5_ST_SZ_BYTES(macsec_aso)];
 	dma_addr_t dma_addr;
-	u8 ctx[MLX5_ST_SZ_BYTES(macsec_aso)];
 	u32 mkey;
 };
 
-- 
2.39.2

