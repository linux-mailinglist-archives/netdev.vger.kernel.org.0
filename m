Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F052A543D49
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbiFHUFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbiFHUFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA99D374263;
        Wed,  8 Jun 2022 13:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4373761C67;
        Wed,  8 Jun 2022 20:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D34C3411C;
        Wed,  8 Jun 2022 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654718728;
        bh=rQOZdTGUzVpAQ8lvgTxnLrp3uf90qnRhjfVxe0pcF3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ps8vaCPUrkr0pHOk16eTTHngqKVwyA5d2GAeGPAFXMTC8So5w05eP+Z3SLVOPQFxL
         dQu5kFShGdczZaT5G0quXeznNkgNJFAbFVdeaBcs7YA/V7NT+Iat0zcUTXSXZiscdM
         zQUOAWJ9hZHsLw57ft/7VoMoBRMMHTuKN/GkUIIuzh49QIhlgjdxoBM3XCp0A6nssr
         YttcNY6zK6cTG7/lVHuoskjTZ8QvJfW77Vr+/c5XnZSmD+EqTmNpjQW3KlpoUriscE
         zL0zL9FG5dogjR5xGQWdeajO7KWH85d7CO/KftWPiUcKDl5wMPVqceb4v5c2kqABIw
         8QBkyDhMbqcKQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 4/6] net/mlx5: group fdb cleanup to single function
Date:   Wed,  8 Jun 2022 13:04:50 -0700
Message-Id: <20220608200452.43880-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608200452.43880-1-saeed@kernel.org>
References: <20220608200452.43880-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, the allocation of fdb software objects are done is single
function, oppose to the cleanup of them.
Group the cleanup of fdb software objects to single function.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c  | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fdcf7f529330..14187e50e2f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2866,6 +2866,14 @@ static int create_fdb_bypass(struct mlx5_flow_steering *steering)
 	return 0;
 }
 
+static void cleanup_fdb_root_ns(struct mlx5_flow_steering *steering)
+{
+	cleanup_root_ns(steering->fdb_root_ns);
+	steering->fdb_root_ns = NULL;
+	kfree(steering->fdb_sub_ns);
+	steering->fdb_sub_ns = NULL;
+}
+
 static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 {
 	struct fs_prio *maj_prio;
@@ -2916,10 +2924,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 	return 0;
 
 out_err:
-	cleanup_root_ns(steering->fdb_root_ns);
-	kfree(steering->fdb_sub_ns);
-	steering->fdb_sub_ns = NULL;
-	steering->fdb_root_ns = NULL;
+	cleanup_fdb_root_ns(steering);
 	return err;
 }
 
@@ -3079,10 +3084,7 @@ void mlx5_fs_core_cleanup(struct mlx5_core_dev *dev)
 	struct mlx5_flow_steering *steering = dev->priv.steering;
 
 	cleanup_root_ns(steering->root_ns);
-	cleanup_root_ns(steering->fdb_root_ns);
-	steering->fdb_root_ns = NULL;
-	kfree(steering->fdb_sub_ns);
-	steering->fdb_sub_ns = NULL;
+	cleanup_fdb_root_ns(steering);
 	cleanup_root_ns(steering->port_sel_root_ns);
 	cleanup_root_ns(steering->sniffer_rx_root_ns);
 	cleanup_root_ns(steering->sniffer_tx_root_ns);
-- 
2.36.1

