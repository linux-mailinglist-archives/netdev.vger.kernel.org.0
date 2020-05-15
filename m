Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F2B1D5C33
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgEOWRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgEOWRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:17:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3108CC05BD0A
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:17:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w15so4273326ybp.16
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u+YBZl1oFvqA9RRYbB/vDCttvSd/4GCz9r56r/w+pEg=;
        b=a8v4BCO97XVJDaY5jN23CcHz4y2mvAgHOJVTEqf+ZLCPJf0cuKyLpdsEZ6nmAcPEmG
         wlzYYPjZlPJ6178RzFKnK7TRaNqnngJnPnrij42gsgTZgwxCt3GZMI05Al+AbD/xmLMc
         nVdoJCeiGS+nOtHXtmWbKacNzu3RMJshk7UhdWErL2oifC1L+ZYdWIZy5OqJRtBiDQVc
         WgfhrXDLnAxZ0uAIrqfB3RHYcRVcDqir2ELJJC8w4acHG6Jcp5lRP+HyPnVAozGTMd36
         H1Ht/zM5WUVkl6ukWg9r6SqWKqTLu0jXLGNqfSr38G2zlXsIBFWayvf2cBYht2UkBoXq
         D07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u+YBZl1oFvqA9RRYbB/vDCttvSd/4GCz9r56r/w+pEg=;
        b=t/LZmM2XzNWjp5VTlLt71Mz+tgzV9DpugKp8DxyGtYHKZshyFVqYy6DyRP/0HGQyRM
         4Z2GhPXPlh5vlIi0azXkgEIVEmNhi9MsOGlwjWropE7J0gHUHeiUvY2C65G6f9Jp9a05
         v88fu9Se+InJiLJ84lPz0QEfl4LGgDvLNJJKtGK50kttIxQI/e8GJC6wj2tnIE1X/jaT
         Hc64qzh2rc7zEdiVOtkbyL8erw2BWu1fx78Yjp0OwbCxFSi+2CJgHJ7fB16eS9mbU/Qm
         L2WDAy9QuDVVHxY85HtguYUztE+ZztFpdGpa1CbrLr1UkWta4c8XFc8fIp79cw4f/O4S
         gYkw==
X-Gm-Message-State: AOAM5321gcBKGjaQmmSXyP/qaZoKCkx2JoqUu3rHwznTdGyxU3gbVtb6
        IfwtqZGe3XNOQwdYZy5IpYxaVim/jGDj
X-Google-Smtp-Source: ABdhPJzd98yEE0sZ9Gtx5b8xcWCnas+wKLPJTNzu8vBaqqfuEafwRYwyTpx3br0QAPOV6THU0sInp3OIwaa4
X-Received: by 2002:a5b:4f:: with SMTP id e15mr8939222ybp.509.1589581065312;
 Fri, 15 May 2020 15:17:45 -0700 (PDT)
Date:   Fri, 15 May 2020 15:17:29 -0700
In-Reply-To: <20200515221732.44078-1-irogers@google.com>
Message-Id: <20200515221732.44078-5-irogers@google.com>
Mime-Version: 1.0
References: <20200515221732.44078-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v3 4/7] tools lib/api: Copy libbpf hashmap to tools/perf/util
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow use of hashmap in perf. Modify perf's check-headers.sh script to
check that the files are kept in sync, in the same way kernel headers are
checked. This will warn if they are out of sync at the start of a perf
build.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/check-headers.sh |   4 +
 tools/perf/util/Build       |   4 +
 tools/perf/util/hashmap.c   | 238 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/hashmap.h   | 177 +++++++++++++++++++++++++++
 4 files changed, 423 insertions(+)
 create mode 100644 tools/perf/util/hashmap.c
 create mode 100644 tools/perf/util/hashmap.h

diff --git a/tools/perf/check-headers.sh b/tools/perf/check-headers.sh
index cf147db4e5ca..94c2bc22c2bb 100755
--- a/tools/perf/check-headers.sh
+++ b/tools/perf/check-headers.sh
@@ -128,4 +128,8 @@ check arch/x86/lib/insn.c             '-I "^#include [\"<]\(../include/\)*asm/in
 # diff non-symmetric files
 check_2 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl arch/x86/entry/syscalls/syscall_64.tbl
 
+# check duplicated library files
+check_2 tools/perf/util/hashmap.h tools/lib/bpf/hashmap.h
+check_2 tools/perf/util/hashmap.c tools/lib/bpf/hashmap.c
+
 cd tools/perf
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index ca07a162d602..880fcdd1ab11 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -136,6 +136,10 @@ perf-$(CONFIG_LIBELF) += symbol-elf.o
 perf-$(CONFIG_LIBELF) += probe-file.o
 perf-$(CONFIG_LIBELF) += probe-event.o
 
+ifndef CONFIG_LIBBPF
+perf-y += hashmap.o
+endif
+
 ifndef CONFIG_LIBELF
 perf-y += symbol-minimal.o
 endif
diff --git a/tools/perf/util/hashmap.c b/tools/perf/util/hashmap.c
new file mode 100644
index 000000000000..a405dad068f5
--- /dev/null
+++ b/tools/perf/util/hashmap.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * Generic non-thread safe hash map implementation.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+#include <stdint.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <errno.h>
+#include <linux/err.h>
+#include "hashmap.h"
+
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
+/* start with 4 buckets */
+#define HASHMAP_MIN_CAP_BITS 2
+
+static void hashmap_add_entry(struct hashmap_entry **pprev,
+			      struct hashmap_entry *entry)
+{
+	entry->next = *pprev;
+	*pprev = entry;
+}
+
+static void hashmap_del_entry(struct hashmap_entry **pprev,
+			      struct hashmap_entry *entry)
+{
+	*pprev = entry->next;
+	entry->next = NULL;
+}
+
+void hashmap__init(struct hashmap *map, hashmap_hash_fn hash_fn,
+		   hashmap_equal_fn equal_fn, void *ctx)
+{
+	map->hash_fn = hash_fn;
+	map->equal_fn = equal_fn;
+	map->ctx = ctx;
+
+	map->buckets = NULL;
+	map->cap = 0;
+	map->cap_bits = 0;
+	map->sz = 0;
+}
+
+struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
+			     hashmap_equal_fn equal_fn,
+			     void *ctx)
+{
+	struct hashmap *map = malloc(sizeof(struct hashmap));
+
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+	hashmap__init(map, hash_fn, equal_fn, ctx);
+	return map;
+}
+
+void hashmap__clear(struct hashmap *map)
+{
+	struct hashmap_entry *cur, *tmp;
+	size_t bkt;
+
+	hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
+		free(cur);
+	}
+	free(map->buckets);
+	map->buckets = NULL;
+	map->cap = map->cap_bits = map->sz = 0;
+}
+
+void hashmap__free(struct hashmap *map)
+{
+	if (!map)
+		return;
+
+	hashmap__clear(map);
+	free(map);
+}
+
+size_t hashmap__size(const struct hashmap *map)
+{
+	return map->sz;
+}
+
+size_t hashmap__capacity(const struct hashmap *map)
+{
+	return map->cap;
+}
+
+static bool hashmap_needs_to_grow(struct hashmap *map)
+{
+	/* grow if empty or more than 75% filled */
+	return (map->cap == 0) || ((map->sz + 1) * 4 / 3 > map->cap);
+}
+
+static int hashmap_grow(struct hashmap *map)
+{
+	struct hashmap_entry **new_buckets;
+	struct hashmap_entry *cur, *tmp;
+	size_t new_cap_bits, new_cap;
+	size_t h, bkt;
+
+	new_cap_bits = map->cap_bits + 1;
+	if (new_cap_bits < HASHMAP_MIN_CAP_BITS)
+		new_cap_bits = HASHMAP_MIN_CAP_BITS;
+
+	new_cap = 1UL << new_cap_bits;
+	new_buckets = calloc(new_cap, sizeof(new_buckets[0]));
+	if (!new_buckets)
+		return -ENOMEM;
+
+	hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
+		h = hash_bits(map->hash_fn(cur->key, map->ctx), new_cap_bits);
+		hashmap_add_entry(&new_buckets[h], cur);
+	}
+
+	map->cap = new_cap;
+	map->cap_bits = new_cap_bits;
+	free(map->buckets);
+	map->buckets = new_buckets;
+
+	return 0;
+}
+
+static bool hashmap_find_entry(const struct hashmap *map,
+			       const void *key, size_t hash,
+			       struct hashmap_entry ***pprev,
+			       struct hashmap_entry **entry)
+{
+	struct hashmap_entry *cur, **prev_ptr;
+
+	if (!map->buckets)
+		return false;
+
+	for (prev_ptr = &map->buckets[hash], cur = *prev_ptr;
+	     cur;
+	     prev_ptr = &cur->next, cur = cur->next) {
+		if (map->equal_fn(cur->key, key, map->ctx)) {
+			if (pprev)
+				*pprev = prev_ptr;
+			*entry = cur;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+int hashmap__insert(struct hashmap *map, const void *key, void *value,
+		    enum hashmap_insert_strategy strategy,
+		    const void **old_key, void **old_value)
+{
+	struct hashmap_entry *entry;
+	size_t h;
+	int err;
+
+	if (old_key)
+		*old_key = NULL;
+	if (old_value)
+		*old_value = NULL;
+
+	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
+	if (strategy != HASHMAP_APPEND &&
+	    hashmap_find_entry(map, key, h, NULL, &entry)) {
+		if (old_key)
+			*old_key = entry->key;
+		if (old_value)
+			*old_value = entry->value;
+
+		if (strategy == HASHMAP_SET || strategy == HASHMAP_UPDATE) {
+			entry->key = key;
+			entry->value = value;
+			return 0;
+		} else if (strategy == HASHMAP_ADD) {
+			return -EEXIST;
+		}
+	}
+
+	if (strategy == HASHMAP_UPDATE)
+		return -ENOENT;
+
+	if (hashmap_needs_to_grow(map)) {
+		err = hashmap_grow(map);
+		if (err)
+			return err;
+		h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
+	}
+
+	entry = malloc(sizeof(struct hashmap_entry));
+	if (!entry)
+		return -ENOMEM;
+
+	entry->key = key;
+	entry->value = value;
+	hashmap_add_entry(&map->buckets[h], entry);
+	map->sz++;
+
+	return 0;
+}
+
+bool hashmap__find(const struct hashmap *map, const void *key, void **value)
+{
+	struct hashmap_entry *entry;
+	size_t h;
+
+	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
+	if (!hashmap_find_entry(map, key, h, NULL, &entry))
+		return false;
+
+	if (value)
+		*value = entry->value;
+	return true;
+}
+
+bool hashmap__delete(struct hashmap *map, const void *key,
+		     const void **old_key, void **old_value)
+{
+	struct hashmap_entry **pprev, *entry;
+	size_t h;
+
+	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
+	if (!hashmap_find_entry(map, key, h, &pprev, &entry))
+		return false;
+
+	if (old_key)
+		*old_key = entry->key;
+	if (old_value)
+		*old_value = entry->value;
+
+	hashmap_del_entry(pprev, entry);
+	free(entry);
+	map->sz--;
+
+	return true;
+}
+
diff --git a/tools/perf/util/hashmap.h b/tools/perf/util/hashmap.h
new file mode 100644
index 000000000000..e823b35e7371
--- /dev/null
+++ b/tools/perf/util/hashmap.h
@@ -0,0 +1,177 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/*
+ * Generic non-thread safe hash map implementation.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+#ifndef __LIBBPF_HASHMAP_H
+#define __LIBBPF_HASHMAP_H
+
+#include <stdbool.h>
+#include <stddef.h>
+#ifdef __GLIBC__
+#include <bits/wordsize.h>
+#else
+#include <bits/reg.h>
+#endif
+
+static inline size_t hash_bits(size_t h, int bits)
+{
+	/* shuffle bits and return requested number of upper bits */
+	return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
+}
+
+typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);
+typedef bool (*hashmap_equal_fn)(const void *key1, const void *key2, void *ctx);
+
+struct hashmap_entry {
+	const void *key;
+	void *value;
+	struct hashmap_entry *next;
+};
+
+struct hashmap {
+	hashmap_hash_fn hash_fn;
+	hashmap_equal_fn equal_fn;
+	void *ctx;
+
+	struct hashmap_entry **buckets;
+	size_t cap;
+	size_t cap_bits;
+	size_t sz;
+};
+
+#define HASHMAP_INIT(hash_fn, equal_fn, ctx) {	\
+	.hash_fn = (hash_fn),			\
+	.equal_fn = (equal_fn),			\
+	.ctx = (ctx),				\
+	.buckets = NULL,			\
+	.cap = 0,				\
+	.cap_bits = 0,				\
+	.sz = 0,				\
+}
+
+void hashmap__init(struct hashmap *map, hashmap_hash_fn hash_fn,
+		   hashmap_equal_fn equal_fn, void *ctx);
+struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
+			     hashmap_equal_fn equal_fn,
+			     void *ctx);
+void hashmap__clear(struct hashmap *map);
+void hashmap__free(struct hashmap *map);
+
+size_t hashmap__size(const struct hashmap *map);
+size_t hashmap__capacity(const struct hashmap *map);
+
+/*
+ * Hashmap insertion strategy:
+ * - HASHMAP_ADD - only add key/value if key doesn't exist yet;
+ * - HASHMAP_SET - add key/value pair if key doesn't exist yet; otherwise,
+ *   update value;
+ * - HASHMAP_UPDATE - update value, if key already exists; otherwise, do
+ *   nothing and return -ENOENT;
+ * - HASHMAP_APPEND - always add key/value pair, even if key already exists.
+ *   This turns hashmap into a multimap by allowing multiple values to be
+ *   associated with the same key. Most useful read API for such hashmap is
+ *   hashmap__for_each_key_entry() iteration. If hashmap__find() is still
+ *   used, it will return last inserted key/value entry (first in a bucket
+ *   chain).
+ */
+enum hashmap_insert_strategy {
+	HASHMAP_ADD,
+	HASHMAP_SET,
+	HASHMAP_UPDATE,
+	HASHMAP_APPEND,
+};
+
+/*
+ * hashmap__insert() adds key/value entry w/ various semantics, depending on
+ * provided strategy value. If a given key/value pair replaced already
+ * existing key/value pair, both old key and old value will be returned
+ * through old_key and old_value to allow calling code do proper memory
+ * management.
+ */
+int hashmap__insert(struct hashmap *map, const void *key, void *value,
+		    enum hashmap_insert_strategy strategy,
+		    const void **old_key, void **old_value);
+
+static inline int hashmap__add(struct hashmap *map,
+			       const void *key, void *value)
+{
+	return hashmap__insert(map, key, value, HASHMAP_ADD, NULL, NULL);
+}
+
+static inline int hashmap__set(struct hashmap *map,
+			       const void *key, void *value,
+			       const void **old_key, void **old_value)
+{
+	return hashmap__insert(map, key, value, HASHMAP_SET,
+			       old_key, old_value);
+}
+
+static inline int hashmap__update(struct hashmap *map,
+				  const void *key, void *value,
+				  const void **old_key, void **old_value)
+{
+	return hashmap__insert(map, key, value, HASHMAP_UPDATE,
+			       old_key, old_value);
+}
+
+static inline int hashmap__append(struct hashmap *map,
+				  const void *key, void *value)
+{
+	return hashmap__insert(map, key, value, HASHMAP_APPEND, NULL, NULL);
+}
+
+bool hashmap__delete(struct hashmap *map, const void *key,
+		     const void **old_key, void **old_value);
+
+bool hashmap__find(const struct hashmap *map, const void *key, void **value);
+
+/*
+ * hashmap__for_each_entry - iterate over all entries in hashmap
+ * @map: hashmap to iterate
+ * @cur: struct hashmap_entry * used as a loop cursor
+ * @bkt: integer used as a bucket loop cursor
+ */
+#define hashmap__for_each_entry(map, cur, bkt)				    \
+	for (bkt = 0; bkt < map->cap; bkt++)				    \
+		for (cur = map->buckets[bkt]; cur; cur = cur->next)
+
+/*
+ * hashmap__for_each_entry_safe - iterate over all entries in hashmap, safe
+ * against removals
+ * @map: hashmap to iterate
+ * @cur: struct hashmap_entry * used as a loop cursor
+ * @tmp: struct hashmap_entry * used as a temporary next cursor storage
+ * @bkt: integer used as a bucket loop cursor
+ */
+#define hashmap__for_each_entry_safe(map, cur, tmp, bkt)		    \
+	for (bkt = 0; bkt < map->cap; bkt++)				    \
+		for (cur = map->buckets[bkt];				    \
+		     cur && ({tmp = cur->next; true; });		    \
+		     cur = tmp)
+
+/*
+ * hashmap__for_each_key_entry - iterate over entries associated with given key
+ * @map: hashmap to iterate
+ * @cur: struct hashmap_entry * used as a loop cursor
+ * @key: key to iterate entries for
+ */
+#define hashmap__for_each_key_entry(map, cur, _key)			    \
+	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
+					     map->cap_bits);		    \
+		     map->buckets ? map->buckets[bkt] : NULL; });	    \
+	     cur;							    \
+	     cur = cur->next)						    \
+		if (map->equal_fn(cur->key, (_key), map->ctx))
+
+#define hashmap__for_each_key_entry_safe(map, cur, tmp, _key)		    \
+	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
+					     map->cap_bits);		    \
+		     cur = map->buckets ? map->buckets[bkt] : NULL; });	    \
+	     cur && ({ tmp = cur->next; true; });			    \
+	     cur = tmp)							    \
+		if (map->equal_fn(cur->key, (_key), map->ctx))
+
+#endif /* __LIBBPF_HASHMAP_H */
-- 
2.26.2.761.g0e0b3e54be-goog

