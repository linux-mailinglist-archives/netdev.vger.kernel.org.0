Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF22590066
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbiHKPlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbiHKPky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:40:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4089C20A;
        Thu, 11 Aug 2022 08:36:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D42B361689;
        Thu, 11 Aug 2022 15:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659DBC433D7;
        Thu, 11 Aug 2022 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232187;
        bh=v4gP1CPwAs+y2Qsyjp0bkq9yER44jjMYz1Kh2ZiPq0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nm8H7BPusWGMmhIR5itA9x3XgngZdtofzixx6E8F8OU3Hgr6/V8lDgILlZ/dqTSfB
         BDx1HtXO1PeWlEeBamT0bLdlLC0TzJazXSvqJqBtTalfApi+qLpaXGNte/d0fz2qBI
         HJhXvSAvRqkhF68Z3pKVO5a7fhwFtgbK8hHCpH8939zMTg4Ssh4LJIkPo10c2cGo01
         U3oWZRmLHcwjKNnt4kkyLrjYf2k4EXldBgwI4c7k4JGN/teCGCrjpMEu52KJH7I2aQ
         uEx8sxgg4NdPQzhDBVXVnApDtxyHRR2Gzi34Re2s9UdgafSZauQnGlRyzF2KxkzJPO
         11vU+eacpQsOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>, NeilBrown <neilb@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 068/105] bpf: Make non-preallocated allocation low priority
Date:   Thu, 11 Aug 2022 11:27:52 -0400
Message-Id: <20220811152851.1520029-68-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit ace2bee839e08df324cb320763258dfd72e6120e ]

GFP_ATOMIC doesn't cooperate well with memcg pressure so far, especially
if we allocate too much GFP_ATOMIC memory. For example, when we set the
memcg limit to limit a non-preallocated bpf memory, the GFP_ATOMIC can
easily break the memcg limit by force charge. So it is very dangerous to
use GFP_ATOMIC in non-preallocated case. One way to make it safe is to
remove __GFP_HIGH from GFP_ATOMIC, IOW, use (__GFP_ATOMIC |
__GFP_KSWAPD_RECLAIM) instead, then it will be limited if we allocate
too much memory. There's a plan to completely remove __GFP_ATOMIC in the
mm side[1], so let's use GFP_NOWAIT instead.

We introduced BPF_F_NO_PREALLOC is because full map pre-allocation is
too memory expensive for some cases. That means removing __GFP_HIGH
doesn't break the rule of BPF_F_NO_PREALLOC, but has the same goal with
it-avoiding issues caused by too much memory. So let's remove it.

This fix can also apply to other run-time allocations, for example, the
allocation in lpm trie, local storage and devmap. So let fix it
consistently over the bpf code

It also fixes a typo in the comment.

[1]. https://lore.kernel.org/linux-mm/163712397076.13692.4727608274002939094@noble.neil.brown.name/

Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Link: https://lore.kernel.org/r/20220709154457.57379-2-laoar.shao@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c        | 2 +-
 kernel/bpf/hashtab.c       | 6 +++---
 kernel/bpf/local_storage.c | 2 +-
 kernel/bpf/lpm_trie.c      | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index c2867068e5bd..1400561efb15 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -845,7 +845,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	struct bpf_dtab_netdev *dev;
 
 	dev = bpf_map_kmalloc_node(&dtab->map, sizeof(*dev),
-				   GFP_ATOMIC | __GFP_NOWARN,
+				   GFP_NOWAIT | __GFP_NOWARN,
 				   dtab->map.numa_node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 17fb69c0e0dc..da7578426a46 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -61,7 +61,7 @@
  *
  * As regular device interrupt handlers and soft interrupts are forced into
  * thread context, the existing code which does
- *   spin_lock*(); alloc(GPF_ATOMIC); spin_unlock*();
+ *   spin_lock*(); alloc(GFP_ATOMIC); spin_unlock*();
  * just works.
  *
  * In theory the BPF locks could be converted to regular spinlocks as well,
@@ -978,7 +978,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 				goto dec_count;
 			}
 		l_new = bpf_map_kmalloc_node(&htab->map, htab->elem_size,
-					     GFP_ATOMIC | __GFP_NOWARN,
+					     GFP_NOWAIT | __GFP_NOWARN,
 					     htab->map.numa_node);
 		if (!l_new) {
 			l_new = ERR_PTR(-ENOMEM);
@@ -996,7 +996,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 		} else {
 			/* alloc_percpu zero-fills */
 			pptr = bpf_map_alloc_percpu(&htab->map, size, 8,
-						    GFP_ATOMIC | __GFP_NOWARN);
+						    GFP_NOWAIT | __GFP_NOWARN);
 			if (!pptr) {
 				kfree(l_new);
 				l_new = ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 8654fc97f5fe..49ef0ce040c7 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -165,7 +165,7 @@ static int cgroup_storage_update_elem(struct bpf_map *map, void *key,
 	}
 
 	new = bpf_map_kmalloc_node(map, struct_size(new, data, map->value_size),
-				   __GFP_ZERO | GFP_ATOMIC | __GFP_NOWARN,
+				   __GFP_ZERO | GFP_NOWAIT | __GFP_NOWARN,
 				   map->numa_node);
 	if (!new)
 		return -ENOMEM;
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index f0d05a3cc4b9..d789e3b831ad 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -285,7 +285,7 @@ static struct lpm_trie_node *lpm_trie_node_alloc(const struct lpm_trie *trie,
 	if (value)
 		size += trie->map.value_size;
 
-	node = bpf_map_kmalloc_node(&trie->map, size, GFP_ATOMIC | __GFP_NOWARN,
+	node = bpf_map_kmalloc_node(&trie->map, size, GFP_NOWAIT | __GFP_NOWARN,
 				    trie->map.numa_node);
 	if (!node)
 		return NULL;
-- 
2.35.1

