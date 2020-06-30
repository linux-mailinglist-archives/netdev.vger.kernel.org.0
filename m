Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B811820EA48
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgF3Aeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgF3Aeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:34:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D436EC061755;
        Mon, 29 Jun 2020 17:34:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h22so8734371pjf.1;
        Mon, 29 Jun 2020 17:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/AjDip8wf++KNj9Pox9QN5T5DmTJlc3L+z0jWIOM48g=;
        b=HRcBkRwxr4iNQhUSM3NrO/cep3dM+/snO3GecDOkS2zWeOax87jS+FxpxqdVF10A9R
         7+/VQJiRTqQUusggJBOFUwI7IbkZU2w8HuqDCudacVC7UDrZEwyPTKYAjML7OVCoZR+q
         JuNcuZpLzOxfbjQFwUkMT3+V8D4Y2BEZecg/5/23Dz6PCuvr42emmcYftdl9vmHMi1aX
         0Lu5+DEyKegXK+0Fui5qQ2nIybneoiYRKLng7SmvoQ8l1N+Y8lGKRRthJsKG7W2pWQN0
         K8yrPWUV6vwvKyl12IfvCfpPrjtI+wCkNDSiBeVAkTE5TJL96CjcVfAxaNtoafs3kUw2
         12cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/AjDip8wf++KNj9Pox9QN5T5DmTJlc3L+z0jWIOM48g=;
        b=hYVJnXDA+sn5S1ATeKUjtos0fFIrFxQ0NgamKLPqDFG1mepTSRCTUdc7MjwXiAUb3L
         oAIsTAlfqsYgR7lybojOmAxajua5653NX8jXHguq3KOxzLw7CulqoxLgMAxFvHFKn07j
         byuBmJc3jlCnLBD9T5LUPa9G5WcHzfqrqAmHtuR1/znW04bHxQaX+rzBQnQ8gbkNv6JL
         l8o8uZOjDy3JSKS4XehljWtMYQrdlYcnlRtUukPUykYvVi5qV97+zV1cN+4CCAwBhMeR
         S+3AFnZl1Ur33CpmIUJ0faGBfSoJiC/IHbY5Ip7qTnqv7zqUlKwopOpfJFL9ogTPqKz/
         6TbQ==
X-Gm-Message-State: AOAM5324FUxrr5VDwasCR3sx6qduwuV2ihWrrY7+RQORLCcb+kaUeEGi
        esUZ8oqrgt2qsWnXeaJApXcy71on
X-Google-Smtp-Source: ABdhPJwdEAd/t49qyOYGpNZWnCH0FI/B+OCucmpsjIQWa5d+U4JiKEPtTUM7mVlDmC96TNzW9EP09A==
X-Received: by 2002:a17:90b:390e:: with SMTP id ob14mr18166169pjb.221.1593477285344;
        Mon, 29 Jun 2020 17:34:45 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id b4sm700658pfo.137.2020.06.29.17.34.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 17:34:44 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 1/5] bpf: Remove redundant synchronize_rcu.
Date:   Mon, 29 Jun 2020 17:34:37 -0700
Message-Id: <20200630003441.42616-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

bpf_free_used_maps() or close(map_fd) will trigger map_free callback.
bpf_free_used_maps() is called after bpf prog is no longer executing:
bpf_prog_put->call_rcu->bpf_prog_free->bpf_free_used_maps.
Hence there is no need to call synchronize_rcu() to protect map elements.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/arraymap.c         | 9 ---------
 kernel/bpf/hashtab.c          | 8 +++-----
 kernel/bpf/lpm_trie.c         | 5 -----
 kernel/bpf/queue_stack_maps.c | 7 -------
 kernel/bpf/reuseport_array.c  | 2 --
 kernel/bpf/ringbuf.c          | 7 -------
 kernel/bpf/stackmap.c         | 3 ---
 7 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index ec5cd11032aa..c66e8273fccd 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -386,13 +386,6 @@ static void array_map_free(struct bpf_map *map)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 
-	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
-	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding programs to complete
-	 * and free the array
-	 */
-	synchronize_rcu();
-
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
@@ -546,8 +539,6 @@ static void fd_array_map_free(struct bpf_map *map)
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	int i;
 
-	synchronize_rcu();
-
 	/* make sure it's empty */
 	for (i = 0; i < array->map.max_entries; i++)
 		BUG_ON(array->ptrs[i] != NULL);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index acd06081d81d..d4378d7d442b 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1290,12 +1290,10 @@ static void htab_map_free(struct bpf_map *map)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 
-	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
-	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding critical sections in
-	 * these programs to complete
+	/* bpf_free_used_maps() or close(map_fd) will trigger this map_free callback.
+	 * bpf_free_used_maps() is called after bpf prog is no longer executing.
+	 * There is no need to synchronize_rcu() here to protect map elements.
 	 */
-	synchronize_rcu();
 
 	/* some of free_htab_elem() callbacks for elements of this map may
 	 * not have executed. Wait for them.
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 1abd4e3f906d..44474bf3ab7a 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -589,11 +589,6 @@ static void trie_free(struct bpf_map *map)
 	struct lpm_trie_node __rcu **slot;
 	struct lpm_trie_node *node;
 
-	/* Wait for outstanding programs to complete
-	 * update/lookup/delete/get_next_key and free the trie.
-	 */
-	synchronize_rcu();
-
 	/* Always start at the root and walk down to a node that has no
 	 * children. Then free that node, nullify its reference in the parent
 	 * and start over.
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 80c66a6d7c54..44184f82916a 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -101,13 +101,6 @@ static void queue_stack_map_free(struct bpf_map *map)
 {
 	struct bpf_queue_stack *qs = bpf_queue_stack(map);
 
-	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
-	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding critical sections in
-	 * these programs to complete
-	 */
-	synchronize_rcu();
-
 	bpf_map_area_free(qs);
 }
 
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index a09922f656e4..3625c4fcc65c 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -96,8 +96,6 @@ static void reuseport_array_free(struct bpf_map *map)
 	struct sock *sk;
 	u32 i;
 
-	synchronize_rcu();
-
 	/*
 	 * ops->map_*_elem() will not be able to access this
 	 * array now. Hence, this function only races with
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index dbf37aff4827..13a8d3967e07 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -215,13 +215,6 @@ static void ringbuf_map_free(struct bpf_map *map)
 {
 	struct bpf_ringbuf_map *rb_map;
 
-	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
-	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding critical sections in
-	 * these programs to complete
-	 */
-	synchronize_rcu();
-
 	rb_map = container_of(map, struct bpf_ringbuf_map, map);
 	bpf_ringbuf_free(rb_map->rb);
 	kfree(rb_map);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 27dc9b1b08a5..071f98d0f7c6 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -604,9 +604,6 @@ static void stack_map_free(struct bpf_map *map)
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 
-	/* wait for bpf programs to complete before freeing stack map */
-	synchronize_rcu();
-
 	bpf_map_area_free(smap->elems);
 	pcpu_freelist_destroy(&smap->freelist);
 	bpf_map_area_free(smap);
-- 
2.23.0

