Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B8B20ECA4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgF3Edu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgF3Edu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:33:50 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC2DC061755;
        Mon, 29 Jun 2020 21:33:50 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f6so4885929pjq.5;
        Mon, 29 Jun 2020 21:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7OTv1ekDxOAnqvhvLmGu2MGZBJLyFM7F84Ei7ka2OxY=;
        b=Wnkog++K/Pwsv+TKBNIDdJfTnoPA8wv4Yxk62/EvCdKl6VKugl13cbdqT3JkRJA3/s
         UzBdl6mNHjWCB6+f8RdhLM2E8n64y16FU8KaLvQl57IvBC+4E/64o6uE/j3DimA7P4vw
         rrNohMZuZVxK7s91fhT/YlpD/Oo29OlyeOn2BA70UbjLtabCVKpuWmPTfbrlVrOC0i3l
         4oFOalceYAkGOTeasrrDQoT/28/S+pYY4f1NIdQNrhDawaUt1GlsnUR+10/g0poFLrH5
         i8IgdN8fiqJPSaCsgYInw6h+rr3RsnEJOkh7D85IA8orZm9ef8Ofhm2eSIXMNmRsG5U0
         ospQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7OTv1ekDxOAnqvhvLmGu2MGZBJLyFM7F84Ei7ka2OxY=;
        b=iSLj4S6AfzKWiRZEgk1vVVZA6qN0m7dk/yucLc90Oo2Bsgwe5CXbAE48ogY80tqJvD
         5EZ6KQXElpTqNvbUkHkFGMUbC1AyA4M466M/+Of1Bkit0qhEi1dPoRhiipegKhanpG2y
         GrbYonT4zI5Pt7vbH4eSe4WckdSRtwTJn31P0kaAqa5BeM8fnn+mLpriPeUWZRxUjxvE
         96nMzabTQyqToqRQ0MW1wyU+kEaotUMKS7PhQYtH/1OPpIFnIPASNxEffQYQiqMz0M7v
         guvJiz3Cmpu+dSIMo7jb/ErXNLkFJ8Eab3f2jZWw0a66+Xf2pJC0fPyvInn0iI7VUSMB
         e6KQ==
X-Gm-Message-State: AOAM533KWxTffxgWPnNhYLIeinDXINFz0rE0gPAFvsBhgVgJdc3+p/Q2
        uxIEaSEnqmbgapifrt/N4VE=
X-Google-Smtp-Source: ABdhPJw4ndWwIwDJ1NfzWndUi1csB+EhAyYpdIQGvl2303qKafRr437PWu4naoK2h1q/kkuy8NGL+g==
X-Received: by 2002:a17:902:c252:: with SMTP id 18mr9579984plg.39.1593491629653;
        Mon, 29 Jun 2020 21:33:49 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 21sm1111234pfv.43.2020.06.29.21.33.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 21:33:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 1/5] bpf: Remove redundant synchronize_rcu.
Date:   Mon, 29 Jun 2020 21:33:39 -0700
Message-Id: <20200630043343.53195-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

bpf_free_used_maps() or close(map_fd) will trigger map_free callback.
bpf_free_used_maps() is called after bpf prog is no longer executing:
bpf_prog_put->call_rcu->bpf_prog_free->bpf_free_used_maps.
Hence there is no need to call synchronize_rcu() to protect map elements.

Note that hash_of_maps and array_of_maps update/delete inner maps via
sys_bpf() that calls maybe_wait_bpf_programs() and synchronize_rcu().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
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

