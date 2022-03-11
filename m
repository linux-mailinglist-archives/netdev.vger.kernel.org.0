Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4B4D5C94
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347257AbiCKHl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346474AbiCKHls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F4E1B7574
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0CFEB82AE3
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38225C340F5;
        Fri, 11 Mar 2022 07:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984443;
        bh=8d1rrW7I+KWp+Ab6BqmCmgG1ABO9DQnystI6iscpLZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCPdXm4llOYv3oAT4JBzRdgniubYASh5Zd8ww0ySe8tRh/84olQ3x9DCB4V3e1nV1
         J3Bvzv2LKnvweMx+CSL7Z71lCdZt633Ncx0scmYc3BNTQAXR0IjxWI8Qnx6A/CVo5Z
         FKeGlL69UJt9Fwwk2jHwYSYKct8qd34Dbgt97b5Ii6W7KpXpY8hAj1kvx6697jZWL2
         Q9t6oes23jfpNeTkvZSPz8iWbEWqOOV/ac9KSpUtA17RacNQlDVy+mDZBXQDcSj2ug
         qt6NYc7TiIob6NYE1EQtp9b3Id1p0vKJwGFJx1lnMyZPCt+oC//AXhFQB1sHYPqcOa
         ghkFjBPG7Queg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Node-aware allocation for the EQs
Date:   Thu, 10 Mar 2022 23:40:21 -0800
Message-Id: <20220311074031.645168-6-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Prefer the aware allocation, use the device NUMA node.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 316105378188..229728c80233 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -728,7 +728,8 @@ struct mlx5_eq *
 mlx5_eq_create_generic(struct mlx5_core_dev *dev,
 		       struct mlx5_eq_param *param)
 {
-	struct mlx5_eq *eq = kvzalloc(sizeof(*eq), GFP_KERNEL);
+	struct mlx5_eq *eq = kvzalloc_node(sizeof(*eq), GFP_KERNEL,
+					   dev->priv.numa_node);
 	int err;
 
 	if (!eq)
@@ -888,10 +889,11 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 		return ncomp_eqs;
 	INIT_LIST_HEAD(&table->comp_eqs_list);
 	nent = comp_eq_depth_devlink_param_get(dev);
+
 	for (i = 0; i < ncomp_eqs; i++) {
 		struct mlx5_eq_param param = {};
 
-		eq = kzalloc(sizeof(*eq), GFP_KERNEL);
+		eq = kzalloc_node(sizeof(*eq), GFP_KERNEL, dev->priv.numa_node);
 		if (!eq) {
 			err = -ENOMEM;
 			goto clean;
-- 
2.35.1

