Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9746F8383
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfKKXep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:45 -0500
Received: from correo.us.es ([193.147.175.20]:43008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfKKXep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 42CC32A2BBE
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34DE5DA7B6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2AA8CD2B1E; Tue, 12 Nov 2019 00:34:41 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29915CA0F3;
        Tue, 12 Nov 2019 00:34:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DC48C42EF4E0;
        Tue, 12 Nov 2019 00:34:38 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 1/7] net/mlx5: Simplify fdb chain and prio eswitch defines
Date:   Tue, 12 Nov 2019 00:34:24 +0100
Message-Id: <20191111233430.25120-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

FDB_MAX_CHAIN and FDB_MAX_PRIO were defined differently depending
on if CONFIG_MLX5_ESWITCH is enabled to save space on allocations.

This is a minor space saving, and there is no real need for it.
Simplify things instead, and define them the same in both cases.

Issue: 1929510
Change-Id: Ib8123cc14ac73fa532df466156e326ce3587d509
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 804a7ed2b969..25ecf0c516d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -43,6 +43,10 @@
 #include <linux/mlx5/fs.h>
 #include "lib/mpfs.h"
 
+#define FDB_MAX_CHAIN 3
+#define FDB_SLOW_PATH_CHAIN (FDB_MAX_CHAIN + 1)
+#define FDB_MAX_PRIO 16
+
 #ifdef CONFIG_MLX5_ESWITCH
 
 #define MLX5_MAX_UC_PER_VPORT(dev) \
@@ -59,10 +63,6 @@
 #define mlx5_esw_has_fwd_fdb(dev) \
 	MLX5_CAP_ESW_FLOWTABLE(dev, fdb_multi_path_to_table)
 
-#define FDB_MAX_CHAIN 3
-#define FDB_SLOW_PATH_CHAIN (FDB_MAX_CHAIN + 1)
-#define FDB_MAX_PRIO 16
-
 struct vport_ingress {
 	struct mlx5_flow_table *acl;
 	struct mlx5_flow_group *allow_untagged_spoofchk_grp;
@@ -613,10 +613,6 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 
 static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs) {}
 
-#define FDB_MAX_CHAIN 1
-#define FDB_SLOW_PATH_CHAIN (FDB_MAX_CHAIN + 1)
-#define FDB_MAX_PRIO 1
-
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
-- 
2.11.0

