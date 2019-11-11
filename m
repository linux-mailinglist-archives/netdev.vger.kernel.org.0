Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C5F8389
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKXev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:51 -0500
Received: from correo.us.es ([193.147.175.20]:43070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfKKXet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15CAE2A2BC4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 053A0D2B1E
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EE8B8DA801; Tue, 12 Nov 2019 00:34:44 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04762DA840;
        Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BA56842EF4E0;
        Tue, 12 Nov 2019 00:34:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 6/7] net/mlx5: Add new chain for netfilter flow table offload
Date:   Tue, 12 Nov 2019 00:34:29 +0100
Message-Id: <20191111233430.25120-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Netfilter tables (nftables) implements a software datapath that
comes after tc ingress datapath. The datapath supports offloading
such rules via the flow table offload API.

This API is currently only used by NFT and it doesn't provide the
global priority in regards to tc offload, so we assume offloading such
rules must come after tc. It does provide a flow table priority
parameter, so we need to provide some supported priority range.

For that, split fastpath prio to two, flow table offload and tc offload,
with one dedicated priority chain for flow table offload.

Next patch will re-use the multi chain API to access this chain by
allowing access to this chain by the fdb_sub_namespace.

Issue: 1929510
Change-Id: Ib9b048a67b1f982868439b06c229e69e88f8a7ce
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 9 ++++++---
 include/linux/mlx5/fs.h                           | 3 ++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 82c0647a75ae..2b2c1d0a4f8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -44,7 +44,12 @@
 #include "lib/mpfs.h"
 
 #define FDB_TC_MAX_CHAIN 3
-#define FDB_TC_SLOW_PATH_CHAIN (FDB_TC_MAX_CHAIN + 1)
+#define FDB_FT_CHAIN (FDB_TC_MAX_CHAIN + 1)
+#define FDB_TC_SLOW_PATH_CHAIN (FDB_FT_CHAIN + 1)
+
+/* The index of the last real chain (FT) + 1 as chain zero is valid as well */
+#define FDB_NUM_CHAINS (FDB_FT_CHAIN + 1)
+
 #define FDB_TC_MAX_PRIO 16
 #define FDB_TC_LEVELS_PER_PRIO 2
 
@@ -166,7 +171,7 @@ struct mlx5_eswitch_fdb {
 			struct {
 				struct mlx5_flow_table *fdb;
 				u32 num_rules;
-			} fdb_prio[FDB_TC_MAX_CHAIN + 1][FDB_TC_MAX_PRIO + 1][FDB_TC_LEVELS_PER_PRIO];
+			} fdb_prio[FDB_NUM_CHAINS][FDB_TC_MAX_PRIO + 1][FDB_TC_LEVELS_PER_PRIO];
 			/* Protects fdb_prio table */
 			struct mutex fdb_prio_lock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 36bbd28086f5..2c1dcb5084ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2665,16 +2665,19 @@ static int create_fdb_chains(struct mlx5_flow_steering *steering,
 
 static int create_fdb_fast_path(struct mlx5_flow_steering *steering)
 {
-	const int total_chains = FDB_TC_MAX_CHAIN + 1;
 	int err;
 
-	steering->fdb_sub_ns = kcalloc(total_chains,
+	steering->fdb_sub_ns = kcalloc(FDB_NUM_CHAINS,
 				       sizeof(*steering->fdb_sub_ns),
 				       GFP_KERNEL);
 	if (!steering->fdb_sub_ns)
 		return -ENOMEM;
 
-	err = create_fdb_chains(steering, FDB_FAST_PATH, FDB_TC_MAX_CHAIN + 1);
+	err = create_fdb_chains(steering, FDB_TC_OFFLOAD, FDB_TC_MAX_CHAIN + 1);
+	if (err)
+		return err;
+
+	err = create_fdb_chains(steering, FDB_FT_OFFLOAD, 1);
 	if (err)
 		return err;
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 724d276ea133..4e5b84e66822 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -80,7 +80,8 @@ enum mlx5_flow_namespace_type {
 
 enum {
 	FDB_BYPASS_PATH,
-	FDB_FAST_PATH,
+	FDB_TC_OFFLOAD,
+	FDB_FT_OFFLOAD,
 	FDB_SLOW_PATH,
 };
 
-- 
2.11.0

