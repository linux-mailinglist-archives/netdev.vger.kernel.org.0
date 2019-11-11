Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B382F8388
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfKKXet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:49 -0500
Received: from correo.us.es ([193.147.175.20]:43064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbfKKXes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B9452A2BCA
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B2CDDA72F
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5080D66DC; Tue, 12 Nov 2019 00:34:44 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52387DA72F;
        Tue, 12 Nov 2019 00:34:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 141CE42EF4E0;
        Tue, 12 Nov 2019 00:34:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 5/7] net/mlx5: Refactor creating fast path prio chains
Date:   Tue, 12 Nov 2019 00:34:28 +0100
Message-Id: <20191111233430.25120-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Next patch will re-use this to add a new chain but in a
different prio.

Issue: 1929510
Change-Id: I5489f23b4df52ffa47b5a6312815d66b3bf0b55e
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 118 +++++++++++++++-------
 1 file changed, 82 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0da932b6bae9..36bbd28086f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2599,60 +2599,106 @@ static int init_rdma_rx_root_ns(struct mlx5_flow_steering *steering)
 	steering->rdma_rx_root_ns = NULL;
 	return err;
 }
-static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
+
+/* FT and tc chains are stored in the same array so we can re-use the
+ * mlx5_get_fdb_sub_ns() and tc api for FT chains.
+ * When creating a new ns for each chain store it in the first available slot.
+ * Assume tc chains are created and stored first and only then the FT chain.
+ */
+static void store_fdb_sub_ns_prio_chain(struct mlx5_flow_steering *steering,
+					struct mlx5_flow_namespace *ns)
+{
+	int chain = 0;
+
+	while (steering->fdb_sub_ns[chain])
+		++chain;
+
+	steering->fdb_sub_ns[chain] = ns;
+}
+
+static int create_fdb_sub_ns_prio_chain(struct mlx5_flow_steering *steering,
+					struct fs_prio *maj_prio)
 {
 	struct mlx5_flow_namespace *ns;
-	struct fs_prio *maj_prio;
 	struct fs_prio *min_prio;
+	int prio;
+
+	ns = fs_create_namespace(maj_prio, MLX5_FLOW_TABLE_MISS_ACTION_DEF);
+	if (IS_ERR(ns))
+		return PTR_ERR(ns);
+
+	for (prio = 0; prio < FDB_TC_MAX_PRIO; prio++) {
+		min_prio = fs_create_prio(ns, prio, FDB_TC_LEVELS_PER_PRIO);
+		if (IS_ERR(min_prio))
+			return PTR_ERR(min_prio);
+	}
+
+	store_fdb_sub_ns_prio_chain(steering, ns);
+
+	return 0;
+}
+
+static int create_fdb_chains(struct mlx5_flow_steering *steering,
+			     int fs_prio,
+			     int chains)
+{
+	struct fs_prio *maj_prio;
 	int levels;
 	int chain;
-	int prio;
 	int err;
 
-	steering->fdb_root_ns = create_root_ns(steering, FS_FT_FDB);
-	if (!steering->fdb_root_ns)
-		return -ENOMEM;
+	levels = FDB_TC_LEVELS_PER_PRIO * FDB_TC_MAX_PRIO * chains;
+	maj_prio = fs_create_prio_chained(&steering->fdb_root_ns->ns,
+					  fs_prio,
+					  levels);
+	if (IS_ERR(maj_prio))
+		return PTR_ERR(maj_prio);
+
+	for (chain = 0; chain < chains; chain++) {
+		err = create_fdb_sub_ns_prio_chain(steering, maj_prio);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
 
-	steering->fdb_sub_ns = kzalloc(sizeof(steering->fdb_sub_ns) *
-				       (FDB_TC_MAX_CHAIN + 1), GFP_KERNEL);
+static int create_fdb_fast_path(struct mlx5_flow_steering *steering)
+{
+	const int total_chains = FDB_TC_MAX_CHAIN + 1;
+	int err;
+
+	steering->fdb_sub_ns = kcalloc(total_chains,
+				       sizeof(*steering->fdb_sub_ns),
+				       GFP_KERNEL);
 	if (!steering->fdb_sub_ns)
 		return -ENOMEM;
 
+	err = create_fdb_chains(steering, FDB_FAST_PATH, FDB_TC_MAX_CHAIN + 1);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
+{
+	struct fs_prio *maj_prio;
+	int err;
+
+	steering->fdb_root_ns = create_root_ns(steering, FS_FT_FDB);
+	if (!steering->fdb_root_ns)
+		return -ENOMEM;
+
 	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BYPASS_PATH,
 				  1);
 	if (IS_ERR(maj_prio)) {
 		err = PTR_ERR(maj_prio);
 		goto out_err;
 	}
-
-	levels = FDB_TC_LEVELS_PER_PRIO *
-		 FDB_TC_MAX_PRIO * (FDB_TC_MAX_CHAIN + 1);
-	maj_prio = fs_create_prio_chained(&steering->fdb_root_ns->ns,
-					  FDB_FAST_PATH,
-					  levels);
-	if (IS_ERR(maj_prio)) {
-		err = PTR_ERR(maj_prio);
+	err = create_fdb_fast_path(steering);
+	if (err)
 		goto out_err;
-	}
-
-	for (chain = 0; chain <= FDB_TC_MAX_CHAIN; chain++) {
-		ns = fs_create_namespace(maj_prio, MLX5_FLOW_TABLE_MISS_ACTION_DEF);
-		if (IS_ERR(ns)) {
-			err = PTR_ERR(ns);
-			goto out_err;
-		}
-
-		for (prio = 0; prio < FDB_TC_MAX_PRIO * (chain + 1); prio++) {
-			min_prio = fs_create_prio(ns, prio,
-						  FDB_TC_LEVELS_PER_PRIO);
-			if (IS_ERR(min_prio)) {
-				err = PTR_ERR(min_prio);
-				goto out_err;
-			}
-		}
-
-		steering->fdb_sub_ns[chain] = ns;
-	}
 
 	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_SLOW_PATH, 1);
 	if (IS_ERR(maj_prio)) {
-- 
2.11.0

