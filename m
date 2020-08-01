Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785772353F1
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 20:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgHASJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 14:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgHASJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 14:09:43 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024C6C06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 11:09:43 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x20so16905159plm.15
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 11:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KBK3iODiHqCfZW9cfD4X0Y+4sS0bjVew+4Qx1E5a8fw=;
        b=Npllj9n2Q669VxD0v/McKELqdTmGuLlT0ULCUEsQcW69X2g34NXPXQF05paRHixr6V
         bX70YTowWkT+yAUkFo4BfbmdtLljszspRuDpyhnjhQeyA08dgLlsUnMdRRGRgMG25ffx
         JZVTGsrYyVVBdh3x43ReVvKzjkpQyLruiRhnb/BEXLDVa5Larg9NLBza85P3A55nZTOK
         82MLnM4O9eg4Bx8M5eD0BcOpwfFDYUwBwLMhD+8CxcSvvOQhGOlmuQB0O74DxtZDvfDR
         klNw64Qm1qxWMS36ufDr9m24xrqnPOgzm66J80vuB/DcGNtj6bWEiyNwNBSPNrOupkGa
         F5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KBK3iODiHqCfZW9cfD4X0Y+4sS0bjVew+4Qx1E5a8fw=;
        b=VpHWxLTlNKy9G0uzlW0W7B5KLO+mdTa0K3saFfFUKIwh8YG25QuoB5DsfgC4A7WUsF
         hyqLUgv2WeiYOpYx8wcIPSOBems10uzldgbMbRfngdAVY0/b7kUT7MudyTbVXqzhnpsY
         oO4lma+EJrClHoPLqoCsWQEuH4YF/nS8Xc8MA4JX02+oUjwxtgHVcguVgZVlh0QeHujn
         5m31JgKsFtxAOYs73meLY71f1nuI03DEcOyvDf51v89SxRdqVzcAE28MBwXrhLhYWwIX
         z4HWm99S+rr4w7LQsUt9s5CQyzmsf9uh/ij5lCzj03TgQAujHrKfrby64JKHWyE57N4e
         Ga3w==
X-Gm-Message-State: AOAM530OVtV0aD/VeHpTONUlJHds0Kn9z7B5dFRhK1NpWV1DxuDD1O5/
        4cclaUzSGWxMRfeRm6l+Agw8h5kH2qt8
X-Google-Smtp-Source: ABdhPJy5jsU0pIobtxHllnUwJ+xvJEUWnzrK1fYorGZy0IGRzLNd0pSuOijyJ1eJIcTrqpd/Qfzj1BiHFSGa
X-Received: by 2002:a63:5821:: with SMTP id m33mr8888598pgb.43.1596305381999;
 Sat, 01 Aug 2020 11:09:41 -0700 (PDT)
Date:   Sat,  1 Aug 2020 11:09:27 -0700
Message-Id: <20200801180927.1003340-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH V2 bpf-next] bpf: make __htab_lookup_and_delete_batch faster
 when map is almost empty
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

While running some experiments it was observed that map_lookup_batch was 2x
slower than get_next_key + lookup when the syscall overhead is minimal.
This was because the map_lookup_batch implementation was more expensive
traversing empty buckets, this can be really costly when the pre-allocated
map is too big.

This patch optimizes the case when the bucket is empty so we can move
quickly to next bucket.

The Benchmark was generated using the google/benchmark library[1]. When
the benckmark is executed the number of iterations is governed by the
amount of time the benckmarks takes, the number of iterations is at
least 1 and not more than 1e9, until CPU time(of the entire binary, not
just the part to measure), is greater than 0.5s. Time and CPU reported
are the average of a single iteration over the iteration runs.

The experiments to exercise the empty buckets are as follows:

-The map was populated with a single entry to make sure that the syscall
overhead is not helping the map_batch_lookup.
-The size of the preallocated map was increased to show the effect of
traversing empty buckets.

To interpret the results, Benchmark is the name of the experiment where
the first number correspond to the number of elements in the map, and
the next one correspond to the size of the pre-allocated map. Time and
CPU are average and correspond to the time elapsed per iteration and the
system time consumtion per iteration.

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

[1] https://github.com/google/benchmark.git

Changelog:

v1 -> v2:
 - Add more information about how to interpret the results

Suggested-by: Luigi Rizzo <lrizzo@google.com>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/hashtab.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 024276787055..b6d28bd6345b 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1349,7 +1349,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	struct hlist_nulls_head *head;
 	struct hlist_nulls_node *n;
 	unsigned long flags = 0;
-	bool locked = false;
 	struct htab_elem *l;
 	struct bucket *b;
 	int ret = 0;
@@ -1408,19 +1407,19 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
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
@@ -1446,10 +1445,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		goto alloc;
 	}
 
-	/* Next block is only safe to run if you have grabbed the lock */
-	if (!locked)
-		goto next_batch;
-
 	hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
 		memcpy(dst_key, l->key, key_size);
 
@@ -1492,7 +1487,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	}
 
 	htab_unlock_bucket(htab, b, flags);
-	locked = false;
 
 	while (node_to_free) {
 		l = node_to_free;
@@ -1500,7 +1494,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		bpf_lru_push_free(&htab->lru, &l->lru_node);
 	}
 
-next_batch:
 	/* If we are not copying data, we can go to next bucket and avoid
 	 * unlocking the rcu.
 	 */
-- 
2.28.0.163.g6104cc2f0b6-goog

