Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7168260FAEA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbiJ0O5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbiJ0O5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9CBB40F1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AD4862367
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF925C433D6;
        Thu, 27 Oct 2022 14:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882628;
        bh=pUIJr3od4lzsGcng9IWY+FNxYIrvxUgzQ3l80dlLSoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bog+YGhZfQuUyJXMEY22UdKh6m8Th8np5loQkiE/Wl+HB6+ptzV4u5RUlwex8WJmV
         uegHzcTjRJ/CQSOj8Ng163NexectmzTFLyMv+LGZ9FDInZ+O8zUphrKB6aLLYwknkf
         j62bnNQ+/e0CqO/lf6RX+0GGSuwroDxQAfKA+nVKM50fw0kuhcjUmXQlCdni5vxn+k
         GbwsullafOc5BID/Z3g481y83tVYaKE4ce3KWAObxsNokjnZsz5Qf8OOxy3EH3srcL
         g2+86eso1n3A6xuUA3RewQdfQOkGQ/ReAhG5pyJcgiUl67Yc7al6IpqgvQz4kuYh4T
         fDc6igdM5l/eg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 01/14] net/mlx5: DR, In destroy flow, free resources even if FW command failed
Date:   Thu, 27 Oct 2022 15:56:30 +0100
Message-Id: <20221027145643.6618-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027145643.6618-1-saeed@kernel.org>
References: <20221027145643.6618-1-saeed@kernel.org>
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

Otherwise resources will never be freed and refcount will not be decreased.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 31d443dd8386..eb81759244d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -292,7 +292,7 @@ int mlx5dr_table_destroy(struct mlx5dr_table *tbl)
 	mlx5dr_dbg_tbl_del(tbl);
 	ret = dr_table_destroy_sw_owned_tbl(tbl);
 	if (ret)
-		return ret;
+		mlx5dr_err(tbl->dmn, "Failed to destoy sw owned table\n");
 
 	dr_table_uninit(tbl);
 
-- 
2.37.3

