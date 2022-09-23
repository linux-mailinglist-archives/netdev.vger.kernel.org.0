Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0E45E7883
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 12:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiIWKjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 06:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiIWKjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 06:39:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7B112EDA0;
        Fri, 23 Sep 2022 03:39:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1obg5L-0004UW-7n; Fri, 23 Sep 2022 12:39:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        akpm@linux-foundation.org, urezki@gmail.com,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Martin Zaharinov <micron10@gmail.com>
Subject: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Date:   Fri, 23 Sep 2022 12:38:58 +0200
Message-Id: <20220923103858.26729-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
 kernel BUG at mm/vmalloc.c:2437!
 invalid opcode: 0000 [#1] SMP
 CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
 [..]
 RIP: 0010:__get_vm_area_node+0x120/0x130
  __vmalloc_node_range+0x96/0x1e0
  kvmalloc_node+0x92/0xb0
  bucket_table_alloc.isra.0+0x47/0x140
  rhashtable_try_insert+0x3a4/0x440
  rhashtable_insert_slow+0x1b/0x30
 [..]

bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
falls through to vmalloc and hits code paths that assume GFP_KERNEL.

Revert the problematic change and stay with slab allocator.

Reported-by: Martin Zaharinov <micron10@gmail.com>
Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc")
Cc: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/netdev/09BE0B8A-3ADF-458E-B75E-931B74996355@gmail.com/T/#u

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 mm/util.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/util.c b/mm/util.c
index c9439c66d8cf..ba7fe1cb6846 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -593,6 +593,13 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	gfp_t kmalloc_flags = flags;
 	void *ret;
 
+	/*
+	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
+	 * so the given set of flags has to be compatible.
+	 */
+	if ((flags & GFP_KERNEL) != GFP_KERNEL)
+		return kmalloc_node(size, flags, node);
+
 	/*
 	 * We want to attempt a large physically contiguous block first because
 	 * it is less likely to fragment multiple larger blocks and therefore
-- 
2.35.1

