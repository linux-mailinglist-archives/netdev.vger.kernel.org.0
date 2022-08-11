Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73096590221
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbiHKQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237200AbiHKQDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:03:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD704883FA;
        Thu, 11 Aug 2022 08:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61B85B82150;
        Thu, 11 Aug 2022 15:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88DFC433C1;
        Thu, 11 Aug 2022 15:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232998;
        bh=mMH6qpaC9VMovi109PGok2WfrbsocmL7vKDlSBoj8bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aooe246DNixh8RJAMv4vvN54GADn1mQOaB1/EaeB36Y+Qt18HtBkq5qIcNH1AFXU3
         hYmsgRc1sMJpykIaGizV/K9RqhjdhM3orbSTQ/TljZRVjzTGNZCUMXVyLhOFNUnOMw
         kvSy0tzovu8DErI1jps9LF7vY4HYs8s4M1p/8Htsv+CWYXO4Odjvx/79O3Nbq0FisY
         X1r4Q+zo7ykTKrp6hC3jmGp1owU1ozQlVY6aphz/kUzAMxolsoS0TFw+b37+HXjbfX
         3R3CTLyHKGTD581Daqy76H47iPA765+avwCL53htHxxj69VXZxsPUsOTDNx8eImyHn
         D/9kZpH6gsyvw==
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
Subject: [PATCH AUTOSEL 5.18 61/93] bpf: Make non-preallocated allocation low priority
Date:   Thu, 11 Aug 2022 11:41:55 -0400
Message-Id: <20220811154237.1531313-61-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index 038f6d7a83e4..bdb8ccab4be2 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -844,7 +844,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	struct bpf_dtab_netdev *dev;
 
 	dev = bpf_map_kmalloc_node(&dtab->map, sizeof(*dev),
-				   GFP_ATOMIC | __GFP_NOWARN,
+				   GFP_NOWAIT | __GFP_NOWARN,
 				   dtab->map.numa_node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 65877967f414..f8b5a4a86827 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -60,7 +60,7 @@
  *
  * As regular device interrupt handlers and soft interrupts are forced into
  * thread context, the existing code which does
- *   spin_lock*(); alloc(GPF_ATOMIC); spin_unlock*();
+ *   spin_lock*(); alloc(GFP_ATOMIC); spin_unlock*();
  * just works.
  *
  * In theory the BPF locks could be converted to regular spinlocks as well,
@@ -955,7 +955,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 				goto dec_count;
 			}
 		l_new = bpf_map_kmalloc_node(&htab->map, htab->elem_size,
-					     GFP_ATOMIC | __GFP_NOWARN,
+					     GFP_NOWAIT | __GFP_NOWARN,
 					     htab->map.numa_node);
 		if (!l_new) {
 			l_new = ERR_PTR(-ENOMEM);
@@ -973,7 +973,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 		} else {
 			/* alloc_percpu zero-fills */
 			pptr = bpf_map_alloc_percpu(&htab->map, size, 8,
-						    GFP_ATOMIC | __GFP_NOWARN);
+						    GFP_NOWAIT | __GFP_NOWARN);
 			if (!pptr) {
 				kfree(l_new);
 				l_new = ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 497916060ac7..ba6716903816 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -164,7 +164,7 @@ static int cgroup_storage_update_elem(struct bpf_map *map, void *key,
 	}
 
 	new = bpf_map_kmalloc_node(map, struct_size(new, data, map->value_size),
-				   __GFP_ZERO | GFP_ATOMIC | __GFP_NOWARN,
+				   __GFP_ZERO | GFP_NOWAIT | __GFP_NOWARN,
 				   map->numa_node);
 	if (!new)
 		return -ENOMEM;
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 5763cc7ac4f1..f0b3e1552923 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -284,7 +284,7 @@ static struct lpm_trie_node *lpm_trie_node_alloc(const struct lpm_trie *trie,
 	if (value)
 		size += trie->map.value_size;
 
-	node = bpf_map_kmalloc_node(&trie->map, size, GFP_ATOMIC | __GFP_NOWARN,
+	node = bpf_map_kmalloc_node(&trie->map, size, GFP_NOWAIT | __GFP_NOWARN,
 				    trie->map.numa_node);
 	if (!node)
 		return NULL;
-- 
2.35.1

