Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CFE6A1318
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBWWxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBWWxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:53:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA80193CD
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:53:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB6CCB81B58
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A66C4339B;
        Thu, 23 Feb 2023 22:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192785;
        bh=WKP6ruUbcNyu8tZohOWu+hFnIbAbyBrqkPI+HAxSAag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoAXQ1cOssqV2aqS8ggmWWlXa9mcniIqoV/uK/w5MHwwLEv+hJCxxI3x2OM+YFZjp
         BjjFHJDtU0TAOy30e8Hg23dW6gUAqItJG6gk2KqylgxFWbvwK7p4dOx1nnQfZr54hx
         lUso8jz5OAtX35viG5jD3YDbe2jkGduexwHdyuCXVQTMm+hqQ9eu0iPSsTYrbHQZfn
         cPVqTXgaIn52ac7helcs2drXwnXTJzdVmzu5s9sPI4rLcTjPrhXXejy1WA80sLm55V
         f2t3TA9ozAskbxgBjI/6qzboHMYWJ3XLX7fHO3sWUOFDPZXWN8TfMGCx2jLKpB33Kj
         OxxTWLcaVi4Nw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 10/10] net/mlx5: Geneve, Fix handling of Geneve object id as error code
Date:   Thu, 23 Feb 2023 14:52:47 -0800
Message-Id: <20230223225247.586552-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223225247.586552-1-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

On success, mlx5_geneve_tlv_option_create returns non negative
Geneve object id. In case the object id is positive value the
caller functions will handle it as an error (non zero) and
will fail to offload the Geneve rule.

Fix this by changing caller function ,mlx5_geneve_tlv_option_add,
to return 0 in case valid non negative object id was provided.

Fixes: 0ccc171ea6a2 ("net/mlx5: Geneve, Manage Geneve TLV options")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
index 23361a9ae4fa..6dc83e871cd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
@@ -105,6 +105,7 @@ int mlx5_geneve_tlv_option_add(struct mlx5_geneve *geneve, struct geneve_opt *op
 		geneve->opt_type = opt->type;
 		geneve->obj_id = res;
 		geneve->refcount++;
+		res = 0;
 	}
 
 unlock:
-- 
2.39.1

