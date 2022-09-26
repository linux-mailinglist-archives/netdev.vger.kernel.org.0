Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B49F5E9C17
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiIZIcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiIZIcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:32:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCA736862;
        Mon, 26 Sep 2022 01:32:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ocjXL-00030q-0S; Mon, 26 Sep 2022 10:32:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     tgraf@suug.ch, urezki@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Florian Westphal <fw@strlen.de>,
        Martin Zaharinov <micron10@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH net] rhashtable: fix crash due to mm api change
Date:   Mon, 26 Sep 2022 10:31:39 +0200
Message-Id: <20220926083139.48069-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
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

bucket_table_alloc uses kvzalloc(GPF_ATOMIC).  If kmalloc fails, this now
falls through to vmalloc and hits code paths that assume GFP_KERNEL.

I sent a patch to restore GFP_ATOMIC support in kvmalloc but mm
maintainers rejected it.

This patch is partial revert of
commit 93f976b5190d ("lib/rhashtable: simplify bucket_table_alloc()"),
to avoid kvmalloc for ATOMIC case.

As kvmalloc doesn't warn when used with ATOMIC, kernel will only crash
once vmalloc fallback occurs, so we may see more crashes in other areas
in the future.

Most other callers seem ok but kvm_mmu_topup_memory_cache looks like it
might be affected by the same breakage, so Cc kvm@.

Reported-by: Martin Zaharinov <micron10@gmail.com>
Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc")
Link: https://lore.kernel.org/linux-mm/Yy3MS2uhSgjF47dy@pc636/T/#t
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 lib/rhashtable.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index e12bbfb240b8..9451f411bc71 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -181,7 +181,13 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 	int i;
 	static struct lock_class_key __key;
 
-	tbl = kvzalloc(struct_size(tbl, buckets, nbuckets), gfp);
+	size = struct_size(tbl, buckets, nbuckets);
+
+	/* kvmalloc API does not support GFP_KERNEL anymore */
+	if ((gfp & GFP_KERNEL) != GFP_KERNEL)
+		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
+	else
+		tbl = kvzalloc(size, gfp);
 
 	size = nbuckets;
 
-- 
2.37.3

