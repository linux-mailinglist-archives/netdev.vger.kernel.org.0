Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C974DCE34
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbiCQSz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237721AbiCQSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5F3164D17
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76CAD617B0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CF6C340E9;
        Thu, 17 Mar 2022 18:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543271;
        bh=xTV79Lu5EkDTIIDARb75ej1ubVKZNLty4F6pXJMMWgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjaF6GrdvD+ecOowkrSh013OOM01Gy3ymhan6hikEJLBmLqA13O9MtbuieDW+Q3WN
         3lXGOBq+vKc3TW0FqUb/1mLFiltRm+rataIydfAtHgEzZTzCI0ZZX1UZpoIOpfavXv
         RH0i2YpVjD7pN3Hc1OQyUsK5GTZoHpnqLge0vf+RT8NXk6z/MlFbPaHAxu5TUKx2UP
         GZZs0J7N21102f2pC9kLF67vMmIn690pv1gn+R3i+zj1RQcsbzRe7wi/njfwGguHDD
         UAMNm7PMsHi0xx7QmhGM5ic5S4d6luD43UlsQoyElkfgcEPAGEl81k95GgTPsX5Sd6
         uojKOzrPVt5qQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Shun Hao <shunh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: DR, Adjust structure member to reduce memory hole
Date:   Thu, 17 Mar 2022 11:54:16 -0700
Message-Id: <20220317185424.287982-8-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

Accord to profiling, mlx5dr_ste/mlx5dr_icm_chunk are the two
hot structures. Their memory layout can be optimized by
adjusting member sequences.

Struct mlx5dr_ste size changes from 64 bytes to 56 bytes.

In the upcoming commits, struct mlx5dr_icm_chunk memory layout
will change automatically after removing some members.
Keep it untouched here.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 88092fabf55b..e906fef615a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -151,6 +151,9 @@ struct mlx5dr_ste {
 	/* refcount: indicates the num of rules that using this ste */
 	u32 refcount;
 
+	/* this ste is part of a rule, located in ste's chain */
+	u8 ste_chain_location;
+
 	/* attached to the miss_list head at each htbl entry */
 	struct list_head miss_list_node;
 
@@ -161,9 +164,6 @@ struct mlx5dr_ste {
 
 	/* The rule this STE belongs to */
 	struct mlx5dr_rule_rx_tx *rule_rx_tx;
-
-	/* this ste is part of a rule, located in ste's chain */
-	u8 ste_chain_location;
 };
 
 struct mlx5dr_ste_htbl_ctrl {
-- 
2.35.1

