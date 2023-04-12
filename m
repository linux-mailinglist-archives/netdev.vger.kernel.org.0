Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042E36DEA24
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDLEIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDLEIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B5C1BE4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3EEE62DAA
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005DEC433EF;
        Wed, 12 Apr 2023 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272482;
        bh=YXnu5cBzzvPnpfvtlHJowrOqXeA6jnYskEGJjsSyqBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2jqDyI9QiUlO2uRQWLuHQFlwmda4iP++mJqeFc5Xmg+xNGO6ym+QUNo2uiUy6lCr
         jBA1kq+fvyL+thmC91MjEDikMi+lpFRzxXebWAwLynxopdaFIhs7dNLUK2ztZUGgsI
         YcTwkWKSEsC1bx2raksHfWieYQTjLmln37I5UITEYhL1TcDpxPmE/zOGsy8cPInHd6
         i9mGDI+YKGv6P5EUCnPbK9eeELA5q4u9lmIXclAyaBRbLadKkR716MHeyU2X0tC/l/
         ufkvhxHme5eKug6pMfxV410W3EBFG0iVOY/N2rUFdCA8Ya+P87TxfvMJ8aTalN6zJY
         QrON9xrTxC4Bw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Bridge, increase bridge tables sizes
Date:   Tue, 11 Apr 2023 21:07:39 -0700
Message-Id: <20230412040752.14220-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

Bridge ingress and egress tables got more flow groups recently for QinQ
support and will get more in following patches of this series. Increase the
sizes of the tables to allow offloading more flows in each mode.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 3cdcb0e0b20f..e45f9bb80535 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -13,8 +13,8 @@
 #define CREATE_TRACE_POINTS
 #include "diag/bridge_tracepoint.h"
 
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 12000
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 16000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 524288
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
@@ -40,10 +40,10 @@
 	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE			\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 64000);
+static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 1048576);
 
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 16000
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (32000 - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (262144 - 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
@@ -63,7 +63,7 @@ static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 64000);
 	MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE			\
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 64000);
+static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
 
 #define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
 
-- 
2.39.2

