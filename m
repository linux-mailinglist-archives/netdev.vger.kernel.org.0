Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374225695AD
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiGFXNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiGFXN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406D8D88
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDD60B81F42
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5F6C3411C;
        Wed,  6 Jul 2022 23:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149202;
        bh=TRB+Oinex5Qhz4IIdRv22rUaxzhyBHFgBjbAG5w9DEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9lOHiepCik9QM1kqKmgxKaTOQHmAyTzdH5X5czkiTBfWRWrBUTFiWEmJXFKt6s+M
         qrBHk6utmfQRgsTFE5vZTZM7daPKS69BHMqmdJqkl1rXwbuVJh9mVE1qeWhQw8eJ0p
         TBo/hkw2G/Q0wlYX5rcGrllxs+FwPxXmwT4KlS7TlhU1U3kpK54FBhS6/DH8D7/boH
         pB8yZ++BL5VWScbCH84lQeT2KVOowhd35f3bdTlw+VffaQ97Xz3D6bBA2EV1s5UyMR
         xldqldirqcVF9GXln4e6vpkrfBV4F6ckFgWL7HWMcI7e6ukTVyJNPy5oODDwX6lBqM
         bRfcP3N1kUwWQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 5/9] net/mlx5e: Fix enabling sriov while tc nic rules are offloaded
Date:   Wed,  6 Jul 2022 16:13:05 -0700
Message-Id: <20220706231309.38579-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

There is a total of four 4M entries flow tables. In sriov disabled
mode, ct, ct_nat and post_act take three of them. When adding the
first tc nic rule in this mode, it will take another 4M table
for the tc <chain,prio> table. If user then enables sriov, the legacy
flow table tries to take another 4M and fails, and so enablement fails.

To fix that, have legacy fdb take the next available maximum
size from the fs ft pool.

Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 9d17206d1625..fabe49a35a5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -11,6 +11,7 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "fs_core.h"
+#include "fs_ft_pool.h"
 #include "esw/qos.h"
 
 enum {
@@ -95,8 +96,7 @@ static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 	if (!flow_group_in)
 		return -ENOMEM;
 
-	table_size = BIT(MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size));
-	ft_attr.max_fte = table_size;
+	ft_attr.max_fte = POOL_NEXT_SIZE;
 	ft_attr.prio = LEGACY_FDB_PRIO;
 	fdb = mlx5_create_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(fdb)) {
@@ -105,6 +105,7 @@ static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 		goto out;
 	}
 	esw->fdb_table.legacy.fdb = fdb;
+	table_size = fdb->max_fte;
 
 	/* Addresses group : Full match unicast/multicast addresses */
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-- 
2.36.1

