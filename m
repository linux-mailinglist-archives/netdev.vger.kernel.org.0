Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F998A11FA
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfH2GpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8320 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727756AbfH2GpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:21 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6hX2h008802
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=QcD+xzehrsGWynwjx8GMuhPjifB/orlX39UiHZHPblc=;
 b=bCqN6u6Jboo+awFWwKm0OomG/zWoqDgVsRUXTItXMF68/mC4ZyaIde7Xc+3QMJJvsQt3
 wfsq9pV4iriN9OsYBROhWLulDKJr2/ct9sPofAeozN3JNsfyyppSnaiEVsTxu39TIQoL
 ZCFmQbMG0R0oNWg6m7OagcQRgCNON+vkgEA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2une016quu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:19 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 23:45:18 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 855403702BA3; Wed, 28 Aug 2019 23:45:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 13/13] tools/bpf: measure map batching perf
Date:   Wed, 28 Aug 2019 23:45:17 -0700
Message-ID: <20190829064517.2751629-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290072
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test program run result:
  $ ./test_maps
  ...
  measure_lookup: max_entries 1000000, batch 10, time 342
  measure_lookup: max_entries 1000000, batch 1000, time 295
  measure_lookup: max_entries 1000000, batch 1000000, time 270
  measure_lookup: max_entries 1000000, no batching, time 1346
  measure_lookup_delete: max_entries 1000000, batch 10, time 433
  measure_lookup_delete: max_entries 1000000, batch 1000, time 363
  measure_lookup_delete: max_entries 1000000, batch 1000000, time 357
  measure_lookup_delete: max_entries 1000000, not batch, time 1894
  measure_delete: max_entries 1000000, batch, time 220
  measure_delete: max_entries 1000000, not batch, time 1289
  test_map_batch_perf:PASS
  ...

  The test is running on a qemu VM environment. The time
  unit is millisecond. A simple hash table with 1M elements
  is created.

  For lookup and lookup_and_deletion, since buffer allocation
  is needed to hold the lookup results, three different
  batch sizes (10, 1000, and 1M) are tried. The performance
  without batching is also measured. A batch size of 10
  can already improves performance dramatically, more than 70%,
  and increasing batch size may continue to improve performance,
  but with diminishing returns.

  For delete, the batch API provides a mechanism to delete all elements
  in the map, which is used here. The deletion of the whole map
  improves performance by 80% compared to non-batch mechanism.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/map_tests/map_batch_perf.c  | 242 ++++++++++++++++++
 1 file changed, 242 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_batch_perf.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_batch_perf.c b/tools/testing/selftests/bpf/map_tests/map_batch_perf.c
new file mode 100644
index 000000000000..42d95651e1ac
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_batch_perf.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook  */
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <sys/time.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+/* Test map batch performance.
+ * Test three common scenarios:
+ *    - batched lookup
+ *    - batched lookup and delete
+ *    - batched deletion
+ */
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
+static unsigned long util_gettime(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+static void measure_lookup(int map_fd, __u32 max_entries, int *keys,
+			   int *values)
+{
+	__u32 batches[3] = {10, 1000};
+	int err, key, value, option;
+	unsigned long start, end;
+	void *p_key, *p_next_key;
+	__u32 count, total;
+
+	map_batch_update(map_fd, max_entries, keys, values);
+
+	/* batched */
+	batches[2] = max_entries;
+	for (option = 0; option < 3; option++) {
+		p_key = NULL;
+		p_next_key = &key;
+		count = batches[option];
+		start = util_gettime();
+		total = 0;
+
+		while (true) {
+			err = bpf_map_lookup_batch(map_fd, p_key, &p_next_key,
+						   keys, values, &count, 0, 0);
+			CHECK(err, "bpf_map_lookup_batch()", "error: %s\n",
+			      strerror(errno));
+
+			total += count;
+			if (!p_next_key)
+				break;
+
+			if (!p_key)
+				p_key = p_next_key;
+		}
+
+		end = util_gettime();
+		CHECK(total != max_entries,
+		      "checking total", "total %u, max_entries %u\n",
+		      total, max_entries);
+		printf("%s: max_entries %u, batch %u, time %ld\n", __func__,
+		       max_entries, batches[option], end - start);
+	}
+
+	/* not batched */
+	start = util_gettime();
+	p_key = NULL;
+	p_next_key = &key;
+	while (!bpf_map_get_next_key(map_fd, p_key, p_next_key)) {
+		err = bpf_map_lookup_elem(map_fd, p_next_key, &value);
+		CHECK(err, "bpf_map_lookup_elem()", "error: %s\n",
+		      strerror(errno));
+		p_key = p_next_key;
+	}
+	end = util_gettime();
+	printf("%s: max_entries %u, no batching, time %ld\n", __func__,
+	       max_entries, end - start);
+}
+
+static void measure_lookup_delete(int map_fd, __u32 max_entries, int *keys,
+				  int *values)
+{
+	int err, key, next_key, value, option;
+	__u32 batches[3] = {10, 1000};
+	unsigned long start, end;
+	void *p_key, *p_next_key;
+	__u32 count, total;
+
+	/* batched */
+	batches[2] = max_entries;
+	for (option = 0; option < 3; option++) {
+		map_batch_update(map_fd, max_entries, keys, values);
+		p_key = NULL;
+		p_next_key = &key;
+		count = batches[option];
+		start = util_gettime();
+		total = 0;
+
+		while (true) {
+			err = bpf_map_lookup_and_delete_batch(map_fd, p_key,
+				&p_next_key, keys, values, &count, 0, 0);
+			CHECK(err, "bpf_map_lookup_and_delete_batch()",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (!p_next_key)
+				break;
+
+			if (!p_key)
+				p_key = p_next_key;
+		}
+
+		end = util_gettime();
+		CHECK(total != max_entries,
+		      "checking total", "total %u, max_entries %u\n",
+		      total, max_entries);
+		printf("%s: max_entries %u, batch %u, time %ld\n", __func__,
+		       max_entries, batches[option], end - start);
+	}
+
+	/* not batched */
+	map_batch_update(map_fd, max_entries, keys, values);
+	start = util_gettime();
+	p_key = NULL;
+	p_next_key = &key;
+	err = bpf_map_get_next_key(map_fd, p_key, p_next_key);
+	CHECK(err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+	err = bpf_map_lookup_elem(map_fd, p_next_key, &value);
+	CHECK(err, "bpf_map_lookup_elem()", "error: %s\n", strerror(errno));
+
+	p_key = p_next_key;
+	p_next_key = &next_key;
+	while (!bpf_map_get_next_key(map_fd, p_key, p_next_key)) {
+		err = bpf_map_delete_elem(map_fd, p_key);
+		CHECK(err, "bpf_map_delete_elem()", "error: %s\n",
+		      strerror(errno));
+
+		err = bpf_map_lookup_elem(map_fd, p_next_key, &value);
+		CHECK(err, "bpf_map_lookup_elem()", "error: %s\n",
+		      strerror(errno));
+
+		p_key = p_next_key;
+		p_next_key = (p_next_key == &key) ? &next_key : &key;
+	}
+	err = bpf_map_delete_elem(map_fd, p_key);
+	CHECK(err, "bpf_map_delete_elem()", "error: %s\n",
+	      strerror(errno));
+	end = util_gettime();
+	printf("%s: max_entries %u, not batch, time %ld\n", __func__,
+	       max_entries, end - start);
+}
+
+static void measure_delete(int map_fd, __u32 max_entries, int *keys,
+			   int *values)
+{
+	unsigned long start, end;
+	void *p_key, *p_next_key;
+	int err, key, next_key;
+	__u32 count;
+
+	/* batched */
+	map_batch_update(map_fd, max_entries, keys, values);
+	count = 0;
+	p_next_key = &key;
+	start = util_gettime();
+	err = bpf_map_delete_batch(map_fd, NULL, NULL, NULL, &count, 0, 0);
+	end = util_gettime();
+	CHECK(err, "bpf_map_delete_batch()", "error: %s\n", strerror(errno));
+	CHECK(count != max_entries, "bpf_map_delete_batch()",
+	      "count = %u, max_entries = %u\n", count, max_entries);
+
+	printf("%s: max_entries %u, batch, time %ld\n", __func__,
+	       max_entries, end - start);
+
+	map_batch_update(map_fd, max_entries, keys, values);
+	p_key = NULL;
+	p_next_key = &key;
+	start = util_gettime();
+	err = bpf_map_get_next_key(map_fd, p_key, p_next_key);
+	CHECK(err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+	p_key = p_next_key;
+	p_next_key = &next_key;
+	while (!bpf_map_get_next_key(map_fd, p_key, p_next_key)) {
+		err = bpf_map_delete_elem(map_fd, p_key);
+		CHECK(err, "bpf_map_delete_elem()", "error: %s\n",
+		      strerror(errno));
+		p_key = p_next_key;
+		p_next_key = (p_next_key == &key) ? &next_key : &key;
+	}
+	err = bpf_map_delete_elem(map_fd, p_key);
+	CHECK(err, "bpf_map_delete_elem()", "error: %s\n",
+	      strerror(errno));
+	end = util_gettime();
+	printf("%s: max_entries %u, not batch, time %ld\n", __func__,
+	       max_entries, end - start);
+}
+
+void test_map_batch_perf(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "hash_map",
+		.map_type = BPF_MAP_TYPE_HASH,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	const __u32 max_entries = 1000000;  // 1M entries for the hash table
+	int map_fd, *keys, *values;
+
+	xattr.max_entries = max_entries;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1,
+	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
+
+	keys = malloc(max_entries * sizeof(int));
+	values = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values, "malloc()", "error:%s\n", strerror(errno));
+
+	measure_lookup(map_fd, max_entries, keys, values);
+	measure_lookup_delete(map_fd, max_entries, keys, values);
+	measure_delete(map_fd, max_entries, keys, values);
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.17.1

