Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C823823C068
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHDUCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:02:48 -0400
Received: from correo.us.es ([193.147.175.20]:49446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgHDUCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 16:02:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8FE63DA7F2
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E2B5DA561
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 73E48DA55C; Tue,  4 Aug 2020 22:02:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F1CEDA856;
        Tue,  4 Aug 2020 22:02:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 22:02:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8D9C94265A32;
        Tue,  4 Aug 2020 22:02:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] netfilter: conntrack: Move nf_ct_offload_timeout to header file
Date:   Tue,  4 Aug 2020 22:02:07 +0200
Message-Id: <20200804200208.18620-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804200208.18620-1-pablo@netfilter.org>
References: <20200804200208.18620-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

To be used by callers from other modules.

[ Rename DAY to NF_CT_DAY to avoid possible symbol name pollution
  issue --Pablo ]

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 12 ++++++++++++
 net/netfilter/nf_conntrack_core.c    | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 90690e37a56f..c7bfddfc65b0 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -279,6 +279,18 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 	       !nf_ct_is_dying(ct);
 }
 
+#define	NF_CT_DAY	(86400 * HZ)
+
+/* Set an arbitrary timeout large enough not to ever expire, this save
+ * us a check for the IPS_OFFLOAD_BIT from the packet path via
+ * nf_ct_is_expired().
+ */
+static inline void nf_ct_offload_timeout(struct nf_conn *ct)
+{
+	if (nf_ct_expires(ct) < NF_CT_DAY / 2)
+		ct->timeout = nfct_time_stamp + NF_CT_DAY;
+}
+
 struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f33d72c5b06e..c3cea50d1bcb 100644
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
2.20.1

