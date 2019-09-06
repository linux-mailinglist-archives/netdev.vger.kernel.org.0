Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213B4AC2B9
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 00:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392662AbfIFWyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 18:54:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392593AbfIFWyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 18:54:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86MUsPj004585
        for <netdev@vger.kernel.org>; Fri, 6 Sep 2019 15:54:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=T4IzyB1CEKA5ygjG+soPjKRHBhv6Na7s0tKRO2UNMZw=;
 b=iT2Hl5NoCm1UljhKniTqrDj7AAdN/KwsplSa6fmXllrEN37yPogHHJpCOr8riSpVGzXQ
 K5d2DNqHZZlzIC4u1DtYhbEO3VKlAHYSR8rHQ5BxU9eUldpKFPBy4vOjWtpc/K72+ciE
 J+mcqSKIlKSKrxpkFcLRHw6ffhGv5WQMlY0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uus7cjdk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 15:54:37 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 6 Sep 2019 15:54:36 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id CE884370311B; Fri,  6 Sep 2019 15:54:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <ast@fb.com>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Brian Vazquez <brianvv@google.com>,
        Stanislav Fomichev <sdf@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 2/2] tools/bpf: test bpf_map_lookup_and_delete_batch()
Date:   Fri, 6 Sep 2019 15:54:34 -0700
Message-ID: <20190906225434.3635421-3-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190906225434.3635421-1-yhs@fb.com>
References: <20190906225434.3635421-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_10:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 bulkscore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909060222
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 5d2fb183ee2d..9d4f76073dd9 100644
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
@@ -396,6 +400,24 @@ union bpf_attr {
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
index cbb933532981..367bdcb3c62b 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -438,6 +438,65 @@ int bpf_map_freeze(int fd)
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
index 0db01334740f..37211840f345 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -120,6 +120,19 @@ LIBBPF_API int bpf_map_lookup_and_delete_elem(int fd, const void *key,
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
index d04c7cb623ed..739bd9f76e50 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -189,4 +189,8 @@ LIBBPF_0.0.4 {
 LIBBPF_0.0.5 {
 	global:
 		bpf_btf_get_next_id;
+		bpf_map_delete_batch;
+		bpf_map_lookup_and_delete_batch;
+		bpf_map_lookup_batch;
+		bpf_map_update_batch;
 } LIBBPF_0.0.4;
diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
new file mode 100644
index 000000000000..dd906b1de595
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
2.17.1

