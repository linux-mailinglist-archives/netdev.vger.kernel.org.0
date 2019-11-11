Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAC0F838F
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKKXe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:58 -0500
Received: from correo.us.es ([193.147.175.20]:43046 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfKKXer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5E752A2BCC
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A61F4D2B1E
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9B975DA8E8; Tue, 12 Nov 2019 00:34:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5D0AB7FF2;
        Tue, 12 Nov 2019 00:34:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 663EF42EF4E0;
        Tue, 12 Nov 2019 00:34:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 4/7] net/mlx5: Accumulate levels for chains prio namespaces
Date:   Tue, 12 Nov 2019 00:34:27 +0100
Message-Id: <20191111233430.25120-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Tc chains are implemented by creating a chained prio steering type, and
inside it there is a namespace for each chain (FDB_TC_MAX_CHAINS). Each
of those has a list of priorities.

Currently, all namespaces in a prio start at the parent prio level.
But since we can jump from chain (namespace) to another chain in the
same prio, we need the levels for higher chains to be higher as well.
So we created unused prios to account for levels in previous namespaces.

Fix that by accumulating the namespaces levels if we are inside a chained
type prio, and removing the unused prios.

Issue: 1929510
Change-Id: I73e106aeb81d8b534c6d17572d7148f26fc8aaf6
Fixes: 328edb499f99 ('net/mlx5: Split FDB fast path prio to multiple namespaces')
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e22366ecdf6c..2e69f7989747 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -952,7 +952,7 @@ esw_get_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int level)
 		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	table_prio = (chain * FDB_TC_MAX_PRIO) + prio - 1;
+	table_prio = prio - 1;
 
 	/* create earlier levels for correct fs_core lookup when
 	 * connecting tables
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 881fe85934b1..0da932b6bae9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2400,9 +2400,17 @@ static void set_prio_attrs_in_prio(struct fs_prio *prio, int acc_level)
 	int acc_level_ns = acc_level;
 
 	prio->start_level = acc_level;
-	fs_for_each_ns(ns, prio)
+	fs_for_each_ns(ns, prio) {
 		/* This updates start_level and num_levels of ns's priority descendants */
 		acc_level_ns = set_prio_attrs_in_ns(ns, acc_level);
+
+		/* If this a prio with chains, and we can jump from one chain
+		 * (namepsace) to another, so we accumulate the levels
+		 */
+		if (prio->node.type == FS_TYPE_PRIO_CHAINS)
+			acc_level = acc_level_ns;
+	}
+
 	if (!prio->num_levels)
 		prio->num_levels = acc_level_ns - prio->start_level;
 	WARN_ON(prio->num_levels < acc_level_ns - prio->start_level);
-- 
2.11.0

