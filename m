Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959F5400354
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350020AbhICQbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:31:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58758 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349995AbhICQba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:31:30 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3F8D8600AA;
        Fri,  3 Sep 2021 18:29:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/5] netfilter: conntrack: sanitize table size default settings
Date:   Fri,  3 Sep 2021 18:30:17 +0200
Message-Id: <20210903163020.13741-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210903163020.13741-1-pablo@netfilter.org>
References: <20210903163020.13741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

conntrack has two distinct table size settings:
nf_conntrack_max and nf_conntrack_buckets.

The former limits how many conntrack objects are allowed to exist
in each namespace.

The second sets the size of the hashtable.

As all entries are inserted twice (once for original direction, once for
reply), there should be at least twice as many buckets in the table than
the maximum number of conntrack objects that can exist at the same time.

Change the default multiplier to 1 and increase the chosen bucket sizes.
This results in the same nf_conntrack_max settings as before but reduces
the average bucket list length.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../networking/nf_conntrack-sysctl.rst        | 13 ++++----
 net/netfilter/nf_conntrack_core.c             | 30 +++++++++----------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 024d784157c8..de3815dd4d49 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -17,9 +17,8 @@ nf_conntrack_acct - BOOLEAN
 nf_conntrack_buckets - INTEGER
 	Size of hash table. If not specified as parameter during module
 	loading, the default size is calculated by dividing total memory
-	by 16384 to determine the number of buckets but the hash table will
-	never have fewer than 32 and limited to 16384 buckets. For systems
-	with more than 4GB of memory it will be 65536 buckets.
+	by 16384 to determine the number of buckets. The hash table will
+	never have fewer than 1024 and never more than 262144 buckets.
 	This sysctl is only writeable in the initial net namespace.
 
 nf_conntrack_checksum - BOOLEAN
@@ -100,8 +99,12 @@ nf_conntrack_log_invalid - INTEGER
 	Log invalid packets of a type specified by value.
 
 nf_conntrack_max - INTEGER
-	Size of connection tracking table.  Default value is
-	nf_conntrack_buckets value * 4.
+        Maximum number of allowed connection tracking entries. This value is set
+        to nf_conntrack_buckets by default.
+        Note that connection tracking entries are added to the table twice -- once
+        for the original direction and once for the reply direction (i.e., with
+        the reversed address). This means that with default settings a maxed-out
+        table will have a average hash chain length of 2, not 1.
 
 nf_conntrack_tcp_be_liberal - BOOLEAN
 	- 0 - disabled (default)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d31dbccbe7bd..cdd8a1dc2275 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2594,26 +2594,24 @@ int nf_conntrack_init_start(void)
 		spin_lock_init(&nf_conntrack_locks[i]);
 
 	if (!nf_conntrack_htable_size) {
-		/* Idea from tcp.c: use 1/16384 of memory.
-		 * On i386: 32MB machine has 512 buckets.
-		 * >= 1GB machines have 16384 buckets.
-		 * >= 4GB machines have 65536 buckets.
-		 */
 		nf_conntrack_htable_size
 			= (((nr_pages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct hlist_head));
-		if (nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
-			nf_conntrack_htable_size = 65536;
+		if (BITS_PER_LONG >= 64 &&
+		    nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
+			nf_conntrack_htable_size = 262144;
 		else if (nr_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
-			nf_conntrack_htable_size = 16384;
-		if (nf_conntrack_htable_size < 32)
-			nf_conntrack_htable_size = 32;
-
-		/* Use a max. factor of four by default to get the same max as
-		 * with the old struct list_heads. When a table size is given
-		 * we use the old value of 8 to avoid reducing the max.
-		 * entries. */
-		max_factor = 4;
+			nf_conntrack_htable_size = 65536;
+
+		if (nf_conntrack_htable_size < 1024)
+			nf_conntrack_htable_size = 1024;
+		/* Use a max. factor of one by default to keep the average
+		 * hash chain length at 2 entries.  Each entry has to be added
+		 * twice (once for original direction, once for reply).
+		 * When a table size is given we use the old value of 8 to
+		 * avoid implicit reduction of the max entries setting.
+		 */
+		max_factor = 1;
 	}
 
 	nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size, 1);
-- 
2.20.1

