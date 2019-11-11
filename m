Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507D0F8386
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKKXes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:48 -0500
Received: from correo.us.es ([193.147.175.20]:43032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbfKKXer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5D362A2BCB
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8327DA840
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CDCAEB8005; Tue, 12 Nov 2019 00:34:42 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8EF3DA3A9;
        Tue, 12 Nov 2019 00:34:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9931942EF4E0;
        Tue, 12 Nov 2019 00:34:40 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 3/7] net/mlx5: Define fdb tc levels per prio
Date:   Tue, 12 Nov 2019 00:34:26 +0100
Message-Id: <20191111233430.25120-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Define FDB_TC_LEVELS_PER_PRIO instead of magic number 2.
This is the number of levels used by each tc prio table in the fdb.

Issue: 1929510
Change-Id: I3a92a1e3d763c8f7496736fb9bd0ee317ec45ebd
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b54c30c33113..82c0647a75ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -46,6 +46,7 @@
 #define FDB_TC_MAX_CHAIN 3
 #define FDB_TC_SLOW_PATH_CHAIN (FDB_TC_MAX_CHAIN + 1)
 #define FDB_TC_MAX_PRIO 16
+#define FDB_TC_LEVELS_PER_PRIO 2
 
 #ifdef CONFIG_MLX5_ESWITCH
 
@@ -139,7 +140,6 @@ enum offloads_fdb_flags {
 
 extern const unsigned int ESW_POOLS[4];
 
-#define PRIO_LEVELS 2
 struct mlx5_eswitch_fdb {
 	union {
 		struct legacy_fdb {
@@ -166,7 +166,7 @@ struct mlx5_eswitch_fdb {
 			struct {
 				struct mlx5_flow_table *fdb;
 				u32 num_rules;
-			} fdb_prio[FDB_TC_MAX_CHAIN + 1][FDB_TC_MAX_PRIO + 1][PRIO_LEVELS];
+			} fdb_prio[FDB_TC_MAX_CHAIN + 1][FDB_TC_MAX_PRIO + 1][FDB_TC_LEVELS_PER_PRIO];
 			/* Protects fdb_prio table */
 			struct mutex fdb_prio_lock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index c9b023a99ba6..881fe85934b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2617,7 +2617,8 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		goto out_err;
 	}
 
-	levels = 2 * FDB_TC_MAX_PRIO * (FDB_TC_MAX_CHAIN + 1);
+	levels = FDB_TC_LEVELS_PER_PRIO *
+		 FDB_TC_MAX_PRIO * (FDB_TC_MAX_CHAIN + 1);
 	maj_prio = fs_create_prio_chained(&steering->fdb_root_ns->ns,
 					  FDB_FAST_PATH,
 					  levels);
@@ -2634,7 +2635,8 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		}
 
 		for (prio = 0; prio < FDB_TC_MAX_PRIO * (chain + 1); prio++) {
-			min_prio = fs_create_prio(ns, prio, 2);
+			min_prio = fs_create_prio(ns, prio,
+						  FDB_TC_LEVELS_PER_PRIO);
 			if (IS_ERR(min_prio)) {
 				err = PTR_ERR(min_prio);
 				goto out_err;
-- 
2.11.0

