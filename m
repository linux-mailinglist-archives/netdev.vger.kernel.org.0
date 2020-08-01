Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B691235080
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 06:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgHAE5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 00:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgHAE5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 00:57:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A38C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 21:57:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u206so3342725ybb.8
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 21:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0HSjKiu7FLMG9JODmmzMFPvijsZ8mJvDEnljEZc271M=;
        b=Wu7yScXQEMDiLIc5zbIgKKdMtd3rUN0iWufpGypAGJEY137KamBDhfNTeiGjPP8P/7
         bUQ6I8hexpnGbMBBBdp5GR0n+7efPq2Uix6tKByTI/c2jOn18/ZKm9yITDtFdQ6s6Iqn
         BfoKomvEsMo2v0GBrnw19ZVkmQaJ8JxRgaxlMoLHc2GiSCR2gdqeBqaQVAaZjEo5Jcom
         fMCycTQ5b0qari4hLY9JiSe1akNZVB2UNP2lNwPKSp1JuoPclIqochMKHHMxYlMhdCEr
         G7qZG7iy1J2LyVhB7+8WcJaz+pFfgX7YRwz3FBWjdVgi+IISuXjz9HVL9gKsl0UygPLD
         wYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0HSjKiu7FLMG9JODmmzMFPvijsZ8mJvDEnljEZc271M=;
        b=FnaGMUX3HWGFFqc9Go4bgVaIoAnYUY9XDcadULEY9x35JUDJlaEQMhXfFOVM5DZiX/
         hzK0d+l6sxjSbx45L3RKky0THolkQWIZMa7vbC5GWikyz8+vZpql7bFVp/fjWAScOCwp
         9APxWjTKKQWIL4+WuF6FVCe4kyXG7V6QIYhXj0WJPSyzcqUU4Uh4v3k3bsAGG+vziMBu
         MhvToZFRRi0a8oB7y1PYFsvviD3r+zUTLfsNQvz1vlq8juxKhU03mcs9n5nCtF20GCQf
         xuOJzeY88kqSb5wA87tJkMhVvxImWz0rFybWiAD7n1dXPGBjvuJmgfH/vz7pLL0sqSLw
         2G6Q==
X-Gm-Message-State: AOAM532wS25VmRIt0NfjAGyoC4C7YOCfuanSsleVayCaEBrd0jqe/pnA
        LUgQU5FnP1Z+lXq3IHxhDCcGBIdRTbJO
X-Google-Smtp-Source: ABdhPJyMMNfjiPciRO8cGcXWZ55eVAyoXJmehLJWq1ExSF7kkVgrXiulR0kmno59SFUfbHCpZG/2UoWdxSBg
X-Received: by 2002:a25:d44e:: with SMTP id m75mr10882380ybf.157.1596257849803;
 Fri, 31 Jul 2020 21:57:29 -0700 (PDT)
Date:   Fri, 31 Jul 2020 21:57:22 -0700
Message-Id: <20200801045722.877331-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH bpf-next] bpf: make __htab_lookup_and_delete_batch faster when
 map is almost empty
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running some experiments it was observed that map_lookup_batch was much
slower than get_next_key + lookup when the syscall overhead is minimal.
This was because the map_lookup_batch implementation was more expensive
traversing empty buckets, this can be really costly when the pre-allocated
map is too big.

This patch optimizes the case when the bucket is empty so we can move quickly
to next bucket.

The benchmark to exercise this is as follows:

-The map was populate with a single entry to make sure that the syscall overhead
is not helping the map_batch_lookup.
-The size of the preallocated map was increased to show the effect of
traversing empty buckets.

Results:

  Using get_next_key + lookup:

  Benchmark                Time(ns)        CPU(ns)     Iteration
  ---------------------------------------------------------------
  BM_DumpHashMap/1/1k          3593           3586         192680
  BM_DumpHashMap/1/4k          6004           5972         100000
  BM_DumpHashMap/1/16k        15755          15710          44341
  BM_DumpHashMap/1/64k        59525          59376          10000

  Using htab_lookup_batch before this patch:
  Benchmark                Time(ns)        CPU(ns)     Iterations
  ---------------------------------------------------------------
  BM_DumpHashMap/1/1k          3933           3927         177978
  BM_DumpHashMap/1/4k          9192           9177          73951
  BM_DumpHashMap/1/16k        42011          41970          16789
  BM_DumpHashMap/1/64k       117895         117661           6135

  Using htab_lookup_batch with this patch:
  Benchmark                Time(ns)        CPU(ns)     Iterations
  ---------------------------------------------------------------
  BM_DumpHashMap/1/1k          2809           2803         249212
  BM_DumpHashMap/1/4k          5318           5316         100000
  BM_DumpHashMap/1/16k        14925          14895          47448
  BM_DumpHashMap/1/64k        58870          58674          10000

Suggested-by: Luigi Rizzo <lrizzo@google.com>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/hashtab.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 2137e2200d95..150015ea6737 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1351,7 +1351,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	struct hlist_nulls_head *head;
 	struct hlist_nulls_node *n;
 	unsigned long flags = 0;
-	bool locked = false;
 	struct htab_elem *l;
 	struct bucket *b;
 	int ret = 0;
@@ -1410,19 +1409,19 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	dst_val = values;
 	b = &htab->buckets[batch];
 	head = &b->head;
-	/* do not grab the lock unless need it (bucket_cnt > 0). */
-	if (locked)
-		flags = htab_lock_bucket(htab, b);
 
+	l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
+					struct htab_elem, hash_node);
+	if (!l && (batch + 1 < htab->n_buckets)) {
+		batch++;
+		goto again_nocopy;
+	}
+
+	flags = htab_lock_bucket(htab, b);
 	bucket_cnt = 0;
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
 		bucket_cnt++;
 
-	if (bucket_cnt && !locked) {
-		locked = true;
-		goto again_nocopy;
-	}
-
 	if (bucket_cnt > (max_count - total)) {
 		if (total == 0)
 			ret = -ENOSPC;
@@ -1448,10 +1447,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		goto alloc;
 	}
 
-	/* Next block is only safe to run if you have grabbed the lock */
-	if (!locked)
-		goto next_batch;
-
 	hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
 		memcpy(dst_key, l->key, key_size);
 
@@ -1494,7 +1489,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	}
 
 	htab_unlock_bucket(htab, b, flags);
-	locked = false;
 
 	while (node_to_free) {
 		l = node_to_free;
@@ -1502,7 +1496,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		bpf_lru_push_free(&htab->lru, &l->lru_node);
 	}
 
-next_batch:
 	/* If we are not copying data, we can go to next bucket and avoid
 	 * unlocking the rcu.
 	 */
-- 
2.28.0.163.g6104cc2f0b6-goog

