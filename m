Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B6C5B107A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiIGXhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiIGXhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5336B7FFB3;
        Wed,  7 Sep 2022 16:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E39E061AEF;
        Wed,  7 Sep 2022 23:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD24C433B5;
        Wed,  7 Sep 2022 23:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593832;
        bh=mB2eUvh4l966XE7lRpvl0b1UaXKsu1b+2ZLq9CThMxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMwYkPSeRgMq+Wjl63Hrv5O4yF7b2+ZtKId0mn3RdpW5kB25ynY6KlEQO9dKgkfFd
         J1PW82fBXmDC1OeXqyqzayubvjtU8El3mnddvN32V7FEVmIP2hZXbgTJtZUEAOtPxr
         KC/EKdzELk9IPkHX3bvS+//CxHCYGG31pZNij8r77uK+LoLVjKJ6MF0rII4/mvyEs3
         TZi9PNT0ozhN9Sla128fp2iUd0Oj5w+Lx2cWavuvncWMR8Aps8mqyxUwc4TS6ssynE
         QawgrvWfkgfNDj/fH+vBcBISziPz9mnDXFilW43m5gqi1c8yBogObu2SvruGSFNQri
         e0E1MWPZSR77A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        "Liu, Changcheng" <jerrliu@nvidia.com>, Liu@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 03/14] net/mlx5: add IFC bits for bypassing port select flow table
Date:   Wed,  7 Sep 2022 16:36:25 -0700
Message-Id: <20220907233636.388475-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Liu, Changcheng" <jerrliu@nvidia.com>

port_select_flow_table_bypass - When set, device supports
bypass port select flow table.
active_port - Bitmask indicates the current active ports
in PORT_SELECT_FT LAG.
MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION - op_mod to operate
PORT_SELECTION_Capabilities.

Signed-off-by: Liu, Changcheng <jerrliu@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e2f71c8d9bd7..3c1756763e90 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -68,6 +68,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
+	MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION       = 0x25,
 };
 
 enum {
@@ -813,7 +814,9 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 struct mlx5_ifc_port_selection_cap_bits {
 	u8         reserved_at_0[0x10];
 	u8         port_select_flow_table[0x1];
-	u8         reserved_at_11[0xf];
+	u8         reserved_at_11[0x1];
+	u8         port_select_flow_table_bypass[0x1];
+	u8         reserved_at_13[0xd];
 
 	u8         reserved_at_20[0x1e0];
 
@@ -10930,7 +10933,9 @@ struct mlx5_ifc_lagc_bits {
 	u8         reserved_at_18[0x5];
 	u8         lag_state[0x3];
 
-	u8         reserved_at_20[0x14];
+	u8         reserved_at_20[0xc];
+	u8         active_port[0x4];
+	u8         reserved_at_30[0x4];
 	u8         tx_remap_affinity_2[0x4];
 	u8         reserved_at_38[0x4];
 	u8         tx_remap_affinity_1[0x4];
-- 
2.37.2

