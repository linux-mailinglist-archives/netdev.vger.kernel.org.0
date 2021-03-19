Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F3A3411F2
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhCSBGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhCSBGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:06:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC5AEC061760;
        Thu, 18 Mar 2021 18:06:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4A748630BE;
        Fri, 19 Mar 2021 02:06:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/9] netfilter: x_tables: Use correct memory barriers.
Date:   Fri, 19 Mar 2021 02:06:02 +0100
Message-Id: <20210319010608.9758-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210319010608.9758-1-pablo@netfilter.org>
References: <20210319010608.9758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

When a new table value was assigned, it was followed by a write memory
barrier. This ensured that all writes before this point would complete
before any writes after this point. However, to determine whether the
rules are unused, the sequence counter is read. To ensure that all
writes have been done before these reads, a full memory barrier is
needed, not just a write memory barrier. The same argument applies when
incrementing the counter, before the rules are read.

Changing to using smp_mb() instead of smp_wmb() fixes the kernel panic
reported in cc00bcaa5899 (which is still present), while still
maintaining the same speed of replacing tables.

The smb_mb() barriers potentially slow the packet path, however testing
has shown no measurable change in performance on a 4-core MIPS64
platform.

Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/netfilter/x_tables.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5deb099d156d..8ec48466410a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -376,7 +376,7 @@ static inline unsigned int xt_write_recseq_begin(void)
 	 * since addend is most likely 1
 	 */
 	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
+	smp_mb();
 
 	return addend;
 }
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 7df3aef39c5c..6bd31a7a27fc 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1389,7 +1389,7 @@ xt_replace_table(struct xt_table *table,
 	table->private = newinfo;
 
 	/* make sure all cpus see new ->private value */
-	smp_wmb();
+	smp_mb();
 
 	/*
 	 * Even though table entries have now been swapped, other CPU's
-- 
2.20.1

