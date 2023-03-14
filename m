Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7887B6B8DF4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCNI7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCNI7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:59:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A87592BEB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC924B818B8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028DCC433D2;
        Tue, 14 Mar 2023 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784345;
        bh=3WnwZ8XK7rc+0y8BGe40gQK/z0cAyBLb12XUbQ4R8gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/F7srCnzCXeI1sBhzAXmHjYcoKQCt7kme+VUoR6oS5YNhLCDchr/i8az90Xd8XFC
         zhs17BmXwGufZ1grkzY4iKzJHhIpr4X2i5dNDbp/O6h9z1WKKNBhFy+0esrxrcNArZ
         J2kwUuto1H0QjIf7Bm2sle6thGP3Z68Q49WNL5az7WuBvDgiQNpIq4J9G1xxHeLvou
         BFOZlArIWdUzi4TzVToMKFKJuTzfEAxS9APBYK3tEVjPlSZNaA1mmRcIsvdFNOG19I
         /f3nO4wm4MLcban6TgDJlg7m+bzZH+h5NIK68d7mTzrLlG1uzeTH9lkoLdReDKP3WY
         hJqHCkWmND6MA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next 2/9] net/mlx5: fs_core: Allow ignore_flow_level on TX dest
Date:   Tue, 14 Mar 2023 10:58:37 +0200
Message-Id: <d0025722bfac0a82da758eb540fbf1ff3cacdf74.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
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

From: Paul Blakey <paulb@nvidia.com>

ignore_flow_level is also supported by firmware on TX,
remove this limitation.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 731acbe22dc7..3ade166073fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1762,7 +1762,8 @@ static bool dest_is_valid(struct mlx5_flow_destination *dest,
 
 	if (ignore_level) {
 		if (ft->type != FS_FT_FDB &&
-		    ft->type != FS_FT_NIC_RX)
+		    ft->type != FS_FT_NIC_RX &&
+		    ft->type != FS_FT_NIC_TX)
 			return false;
 
 		if (dest->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
-- 
2.39.2

