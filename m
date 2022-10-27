Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1085960FAF1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiJ0O5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbiJ0O5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B87108DF2
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0563B62364
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F248DC433C1;
        Thu, 27 Oct 2022 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882655;
        bh=/WwztP2djyXb+ZYaMdsJc6+8Xrzf0aFml/OMNuREf2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7wo3BTtJaknmNwSkRb6754OYyGQLD1lChdO3Rsbc2hedy6Y8GL9AXV5KSqOTqeDf
         QvaLeJJ1dT0guOtsFA47LRqiBq/Er897yrxID0Y/j5JTOBBSmOWpuGolW2F0kaWUGV
         iYaSt9n9Un8wTOwGvOyxfrX4gSHxnKvpgKGOvVk3ZybNxfcb3iglLZf8uOacZy/vEm
         mswygZtUnRSyk9Bs3AZrAWrSlFQGm8121ceXSRUYjvsjfZcgu5GNq6juWy9rGGzC4i
         jF0PAPmUbpO32uoMYSkpm7OfdzYxWDdDMxdRii4+iHJrccv0Z/MeS79pbMXFt8pTtW
         gG78bUljhYVjw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 08/14] net/mlx5: DR, In rehash write the line in the entry immediately
Date:   Thu, 27 Oct 2022 15:56:37 +0100
Message-Id: <20221027145643.6618-9-saeed@kernel.org>
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

Don't wait for the whole table to be ready - write each row immediately.
This way we save allocations of the ste_send_info structure and improve
performance.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_rule.c   | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 6cbc444ad791..22878dcd7c8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -358,6 +358,15 @@ static int dr_rule_rehash_copy_htbl(struct mlx5dr_matcher *matcher,
 						    update_list);
 		if (err)
 			goto clean_copy;
+
+		/* In order to decrease the number of allocated ste_send_info
+		 * structs, send the current table row now.
+		 */
+		err = dr_rule_send_update_list(update_list, matcher->tbl->dmn, false);
+		if (err) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Failed updating table to HW\n");
+			goto clean_copy;
+		}
 	}
 
 clean_copy:
-- 
2.37.3

