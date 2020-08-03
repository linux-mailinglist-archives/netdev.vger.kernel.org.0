Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3208823A057
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgHCHdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:33:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43516 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725806AbgHCHdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 03:33:20 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 3 Aug 2020 10:33:13 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0737XCK1012882;
        Mon, 3 Aug 2020 10:33:13 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH net v2 1/2] netfilter: conntrack: Move nf_ct_offload_timeout to header file
Date:   Mon,  3 Aug 2020 10:33:04 +0300
Message-Id: <20200803073305.702079-2-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20200803073305.702079-1-roid@mellanox.com>
References: <20200803073305.702079-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be used by callers from other modules.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 include/net/netfilter/nf_conntrack.h | 12 ++++++++++++
 net/netfilter/nf_conntrack_core.c    | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 90690e37a56f..8481819ff632 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -279,6 +279,18 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 	       !nf_ct_is_dying(ct);
 }
 
+#define	DAY	(86400 * HZ)
+
+/* Set an arbitrary timeout large enough not to ever expire, this save
+ * us a check for the IPS_OFFLOAD_BIT from the packet path via
+ * nf_ct_is_expired().
+ */
+static inline void nf_ct_offload_timeout(struct nf_conn *ct)
+{
+	if (nf_ct_expires(ct) < DAY / 2)
+		ct->timeout = nfct_time_stamp + DAY;
+}
+
 struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 79cd9dde457b..947c6d9437c3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1344,18 +1344,6 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 	return false;
 }
 
-#define	DAY	(86400 * HZ)
-
-/* Set an arbitrary timeout large enough not to ever expire, this save
- * us a check for the IPS_OFFLOAD_BIT from the packet path via
- * nf_ct_is_expired().
- */
-static void nf_ct_offload_timeout(struct nf_conn *ct)
-{
-	if (nf_ct_expires(ct) < DAY / 2)
-		ct->timeout = nfct_time_stamp + DAY;
-}
-
 static void gc_worker(struct work_struct *work)
 {
 	unsigned int min_interval = max(HZ / GC_MAX_BUCKETS_DIV, 1u);
-- 
2.8.4

