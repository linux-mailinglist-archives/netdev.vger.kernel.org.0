Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE70274C9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfEWD2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfEWD2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:04 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 771202177E;
        Thu, 23 May 2019 03:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582083;
        bh=9WXKOcacIm906RUnHjnfojADmMCVb+DL7qtGaYlgdmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxesTAS7Yrrbqzg7XGZxWc9od2uc+0362/TSg1qdnXBks98W/tzpAJSQR7o/FpcLu
         RdAdb5PNBsleG2Xm3kaT2DU0kqdnLkNifE9LTh7NU2WshJqd4GmxD4+csz5VzM0Kf2
         XMQ305Xpy0D7IiuNpVEUYVVcgHn+zhjdezzUhTXg=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 2/7] ipv6: Refactor fib6_drop_pcpu_from
Date:   Wed, 22 May 2019 20:27:56 -0700
Message-Id: <20190523032801.11122-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move the existing pcpu walk in fib6_drop_pcpu_from to a new
helper, __fib6_drop_pcpu_from, that can be invoked per fib6_nh with a
reference to the from entries that need to be evicted. If the passed
in 'from' is non-NULL then only entries associated with that fib6_info
are removed (e.g., case where fib entry is deleted); if the 'from' is
NULL are entries are flushed (e.g., fib6_nh is deleted).

For fib6_info entries with builtin fib6_nh (ie., current code) there
is no change in behavior.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/ip6_fib.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 274f1243866f..178a9c2d2d34 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -874,21 +874,15 @@ static struct fib6_node *fib6_add_1(struct net *net,
 	return ln;
 }
 
-static void fib6_drop_pcpu_from(struct fib6_info *f6i,
-				const struct fib6_table *table)
+static void __fib6_drop_pcpu_from(struct fib6_nh *fib6_nh,
+				  const struct fib6_info *match,
+				  const struct fib6_table *table)
 {
-	struct fib6_nh *fib6_nh = &f6i->fib6_nh;
 	int cpu;
 
 	if (!fib6_nh->rt6i_pcpu)
 		return;
 
-	/* Make sure rt6_make_pcpu_route() wont add other percpu routes
-	 * while we are cleaning them here.
-	 */
-	f6i->fib6_destroying = 1;
-	mb(); /* paired with the cmpxchg() in rt6_make_pcpu_route() */
-
 	/* release the reference to this fib entry from
 	 * all of its cached pcpu routes
 	 */
@@ -898,7 +892,13 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 
 		ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
 		pcpu_rt = *ppcpu_rt;
-		if (pcpu_rt) {
+
+		/* only dropping the 'from' reference if the cached route
+		 * is using 'match'. The cached pcpu_rt->from only changes
+		 * from a fib6_info to NULL (ip6_dst_destroy); it can never
+		 * change from one fib6_info reference to another
+		 */
+		if (pcpu_rt && rcu_access_pointer(pcpu_rt->from) == match) {
 			struct fib6_info *from;
 
 			from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
@@ -907,6 +907,21 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 	}
 }
 
+static void fib6_drop_pcpu_from(struct fib6_info *f6i,
+				const struct fib6_table *table)
+{
+	struct fib6_nh *fib6_nh;
+
+	/* Make sure rt6_make_pcpu_route() wont add other percpu routes
+	 * while we are cleaning them here.
+	 */
+	f6i->fib6_destroying = 1;
+	mb(); /* paired with the cmpxchg() in rt6_make_pcpu_route() */
+
+	fib6_nh = &f6i->fib6_nh;
+	__fib6_drop_pcpu_from(fib6_nh, f6i, table);
+}
+
 static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 			  struct net *net)
 {
-- 
2.11.0

