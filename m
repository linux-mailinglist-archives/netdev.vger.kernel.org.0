Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29C9F3A5E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfKGVVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:21:36 -0500
Received: from mail-qt1-f201.google.com ([209.85.160.201]:43161 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfKGVVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:21:33 -0500
Received: by mail-qt1-f201.google.com with SMTP id f5so4306301qtm.10
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 13:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TDm3MpB3X1mH6jqmE65/8KU2B8ktjRAH2K39j+QMtPo=;
        b=aiP9CtCXZ8DvFPhT4dkBgxtQ/7hU5ZKi/BNG0Akvkq92znqzwGKanP2JQ312GuUcqb
         YX2K2gpUOhQQM28qohsNm1oKPuHzitD65AmarrCg2hrTLClSu+tSXawUAe8A1nIeyIjN
         OwBlTMBoFdEKb6Lz7nzX0IS1Tk4a7EgMOcI+0WRK0myzKu18eUu9+h99E7nHrkE01Ay1
         14Ptr2WFbSg8PlPnCpcn07qHsSB4qi2gaD7/hQEMCBR7kE4DUktnHphBe/NS45dN5K0/
         xAgxUlPWMI2K38ZW2AYtoGu1g67s21K3MdlDVvKYx+G5+X5wxIVebohLwQRZaV1uQ541
         baTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TDm3MpB3X1mH6jqmE65/8KU2B8ktjRAH2K39j+QMtPo=;
        b=OOhu0ZnVot1RrMThXKyGj2yaVfFNv2eYM6Q/sQZ+/JFYp2Zb6Jgy52VPif5/ESHrF8
         pFneVjm2nSsbcwKzxjhC/lb1vON8iGSB+7/FrQ7+0KiWqlZf+pkMMkKmYp32OFqfg2eC
         PuOgRPHhqPiPb4ydYfCazNUA1p5yWIdOQSHYvMhB2WkA0zrCjNHUQDZV592yBeDl0OSx
         gDw5De6cu+YzRmuCMakcWWWAdFB6gquFJ9wD+Sd4p01BL8WcUtzIy9wY5cr/JO0aPVZ6
         J0NlDCzz6Wdre58PlZCYuvIkkTfjk5g/HilpX/TYx3x0h5ezDgzXVjj6IMqcrGX7NSiz
         e+Cg==
X-Gm-Message-State: APjAAAUhqztCtpFRX1S7ZyqDlzq4bx7Z6ceS1qL36wkr6KDsjVtXlGow
        TpUTps6JtL6lvmXgq3nHntFuwvvIGWmN
X-Google-Smtp-Source: APXvYqxhOhE9CvUNgvk5q4/zqhfj/Gia5/KVfx0itYlGuOtLUkCQ6cik/NRQ6wtS4D82EcCf+PpzCM0cFAuK
X-Received: by 2002:a0c:b91e:: with SMTP id u30mr5805267qvf.31.1573161691713;
 Thu, 07 Nov 2019 13:21:31 -0800 (PST)
Date:   Thu,  7 Nov 2019 13:20:22 -0800
In-Reply-To: <20191107212023.171208-1-brianvv@google.com>
Message-Id: <20191107212023.171208-3-brianvv@google.com>
Mime-Version: 1.0
References: <20191107212023.171208-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [RFC bpf-next 2/3] tools/bpf: test bpf_map_lookup_and_delete_batch()
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

Added four libbpf API functions to support map batch operations:
  . int bpf_map_delete_batch( ... )
  . int bpf_map_lookup_batch( ... )
  . int bpf_map_lookup_and_delete_batch( ... )
  . int bpf_map_update_batch( ... )

Tested bpf_map_lookup_and_delete_batch() and bpf_map_update_batch()
functionality.
  $ ./test_maps
  ...
  test_map_lookup_and_delete_batch:PASS
  ...

Note that I clumped uapi header sync patch, libbpf patch
and tests patch together considering this is a RFC patch.
Will do proper formating once it is out of RFC stage.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/include/uapi/linux/bpf.h                |  22 +++
 tools/lib/bpf/bpf.c                           |  59 +++++++
 tools/lib/bpf/bpf.h                           |  13 ++
 tools/lib/bpf/libbpf.map                      |   4 +
 .../map_tests/map_lookup_and_delete_batch.c   | 155 ++++++++++++++++++
 5 files changed, 253 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index df6809a764046..2d647fa6476cb 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -107,6 +107,10 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
+	BPF_MAP_LOOKUP_BATCH,
+	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+	BPF_MAP_UPDATE_BATCH,
+	BPF_MAP_DELETE_BATCH,
 };
 
 enum bpf_map_type {
@@ -398,6 +402,24 @@ union bpf_attr {
 		__u64		flags;
 	};
 
+	struct { /* struct used by BPF_MAP_*_BATCH commands */
+		__u64		batch;	/* input/output:
+					 * input: start batch,
+					 *        0 to start from beginning.
+					 * output: next start batch,
+					 *         0 to end batching.
+					 */
+		__aligned_u64	keys;
+		__aligned_u64	values;
+		__u32		count;	/* input/output:
+					 * input: # of elements keys/values.
+					 * output: # of filled elements.
+					 */
+		__u32		map_fd;
+		__u64		elem_flags;
+		__u64		flags;
+	} batch;
+
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
 		__u32		insn_cnt;
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index ca0d635b1d5ea..8b7e773003ddd 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -441,6 +441,65 @@ int bpf_map_freeze(int fd)
 	return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
 }
 
+static int bpf_map_batch_common(int cmd, int fd, __u64 *batch,
+				void *keys, void *values,
+				__u32 *count, __u64 elem_flags,
+				__u64 flags)
+{
+	union bpf_attr attr = {};
+	int ret;
+
+	attr.batch.map_fd = fd;
+	if (batch)
+		attr.batch.batch = *batch;
+	attr.batch.keys = ptr_to_u64(keys);
+	attr.batch.values = ptr_to_u64(values);
+	if (count)
+		attr.batch.count = *count;
+	attr.batch.elem_flags = elem_flags;
+	attr.batch.flags = flags;
+
+	ret = sys_bpf(cmd, &attr, sizeof(attr));
+	if (batch)
+		*batch = attr.batch.batch;
+	if (count)
+		*count = attr.batch.count;
+
+	return ret;
+}
+
+int bpf_map_delete_batch(int fd, __u64 *batch, __u32 *count, __u64 elem_flags,
+			 __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_DELETE_BATCH, fd, batch,
+				    NULL, NULL, count, elem_flags, flags);
+}
+
+int bpf_map_lookup_batch(int fd, __u64 *batch, void *keys, void *values,
+			 __u32 *count, __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_BATCH, fd, batch,
+				    keys, values, count, elem_flags, flags);
+}
+
+int bpf_map_lookup_and_delete_batch(int fd, __u64 *batch,
+				    void *keys, void *values,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+				    fd, batch, keys, values,
+				    count, elem_flags, flags);
+}
+
+int bpf_map_update_batch(int fd, void *keys, void *values, __u32 *count,
+			 __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_UPDATE_BATCH,
+				    fd, NULL, keys, values,
+				    count, elem_flags, flags);
+}
+
 int bpf_obj_pin(int fd, const char *pathname)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 1c53bc5b4b3c7..e61da7a92a414 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -123,6 +123,19 @@ LIBBPF_API int bpf_map_lookup_and_delete_elem(int fd, const void *key,
 LIBBPF_API int bpf_map_delete_elem(int fd, const void *key);
 LIBBPF_API int bpf_map_get_next_key(int fd, const void *key, void *next_key);
 LIBBPF_API int bpf_map_freeze(int fd);
+LIBBPF_API int bpf_map_delete_batch(int fd, __u64 *batch, __u32 *count,
+				    __u64 elem_flags, __u64 flags);
+LIBBPF_API int bpf_map_lookup_batch(int fd, __u64 *batch, void *keys,
+				    void *values, __u32 *count,
+				    __u64 elem_flags, __u64 flags);
+LIBBPF_API int bpf_map_lookup_and_delete_batch(int fd, __u64 *batch,
+					       void *keys, void *values,
+					       __u32 *count, __u64 elem_flags,
+					       __u64 flags);
+LIBBPF_API int bpf_map_update_batch(int fd, void *keys, void *values,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags);
+
 LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
 LIBBPF_API int bpf_obj_get(const char *pathname);
 LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 86173cbb159d3..0529a770a04eb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -189,6 +189,10 @@ LIBBPF_0.0.4 {
 LIBBPF_0.0.5 {
 	global:
 		bpf_btf_get_next_id;
+		bpf_map_delete_batch;
+		bpf_map_lookup_and_delete_batch;
+		bpf_map_lookup_batch;
+		bpf_map_update_batch;
 } LIBBPF_0.0.4;
 
 LIBBPF_0.0.6 {
diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
new file mode 100644
index 0000000000000..dd906b1de5950
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook  */
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
+			     int *values)
+{
+	int i, err;
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i] = i + 1;
+		values[i] = i + 2;
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, 0, 0);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     int *keys, int *values)
+{
+	int i;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	for (i = 0; i < max_entries; i++) {
+		CHECK(keys[i] + 1 != values[i], "key/value checking",
+		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+		visited[i] = 1;
+	}
+	for (i = 0; i < max_entries; i++) {
+		CHECK(visited[i] != 1, "visited checking",
+		      "error: keys array at index %d missing\n", i);
+	}
+}
+
+void test_map_lookup_and_delete_batch(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "hash_map",
+		.map_type = BPF_MAP_TYPE_HASH,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	int map_fd, *keys, *values, *visited, key;
+	__u32 count, total, total_success;
+	const __u32 max_entries = 10;
+	int err, i, step;
+	bool nospace_err;
+	__u64 batch = 0;
+
+	xattr.max_entries = max_entries;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1,
+	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
+
+	keys = malloc(max_entries * sizeof(int));
+	values = malloc(max_entries * sizeof(int));
+	visited = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n", strerror(errno));
+
+	/* test 1: lookup/delete an empty hash table, success */
+	count = max_entries;
+	err = bpf_map_lookup_and_delete_batch(map_fd, &batch, keys, values,
+					      &count, 0, 0);
+	CHECK(err, "empty map", "error: %s\n", strerror(errno));
+	CHECK(batch || count, "empty map", "batch = %lld, count = %u\n", batch, count);
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries, keys, values);
+
+	/* test 2: lookup/delete with count = 0, success */
+	batch = 0;
+	count = 0;
+	err = bpf_map_lookup_and_delete_batch(map_fd, &batch, keys, values,
+					      &count, 0, 0);
+	CHECK(err, "count = 0", "error: %s\n", strerror(errno));
+
+	/* test 3: lookup/delete with count = max_entries, success */
+	memset(keys, 0, max_entries * sizeof(*keys));
+	memset(values, 0, max_entries * sizeof(*values));
+	count = max_entries;
+	batch = 0;
+	err = bpf_map_lookup_and_delete_batch(map_fd, &batch, keys,
+					      values, &count, 0, 0);
+	CHECK(err, "count = max_entries", "error: %s\n", strerror(errno));
+	CHECK(count != max_entries || batch != 0, "count = max_entries",
+	      "count = %u, max_entries = %u, batch = %lld\n",
+	      count, max_entries, batch);
+	map_batch_verify(visited, max_entries, keys, values);
+
+	/* bpf_map_get_next_key() should return -ENOENT for an empty map. */
+	err = bpf_map_get_next_key(map_fd, NULL, &key);
+	CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+	/* test 4: lookup/delete in a loop with various steps. */
+	total_success = 0;
+	for (step = 1; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries, keys, values);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * sizeof(*values));
+		batch = 0;
+		total = 0;
+		i = 0;
+		/* iteratively lookup/delete elements with 'step' elements each */
+		count = step;
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_and_delete_batch(map_fd, &batch,
+							      keys + total,
+							      values + total,
+							      &count, 0, 0);
+			/* It is possible that we are failing due to buffer size
+			 * not big enough. In such cases, let us just exit and
+			 * go with large steps. Not that a buffer size with
+			 * max_entries should always work.
+			 */
+			if (err && errno == ENOSPC) {
+				nospace_err = true;
+				break;
+			}
+
+			CHECK(err, "lookup/delete with steps", "error: %s\n",
+			      strerror(errno));
+
+			total += count;
+			if (batch == 0)
+				break;
+
+			i++;
+		}
+
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup/delete with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values);
+		err = bpf_map_get_next_key(map_fd, NULL, &key);
+		CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+		total_success++;
+	}
+
+	CHECK(total_success == 0, "check total_success", "unexpected failure\n");
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.24.0.432.g9d3f5f5b63-goog

