Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03622A1205
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfH2GpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2396 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727716AbfH2GpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:19 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6hSwB011086
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=B3Z5F86re8OO4U4U/f3LOS/DnORL5Wn2SgV+Z29/l3Y=;
 b=khD6Fvf1vbKapG3O8xSEgi4u2XxYrmO5J2D4n4VWn2UrVj24JAnvdRDQr0VFRyLTMkkw
 W8QQNWQFaTFIZvbCMVFyjbxQvUpgef98Wv+AHRuZY669/BpotAS6ZpsKkVh5L4t7UKUx
 zcRAw5EX0OtUY4ocoKVrnGESt4/N+wkqRUQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2unka1wp58-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:18 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 23:45:17 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id DDCD33702BA3; Wed, 28 Aug 2019 23:45:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 10/13] tools/bpf: add test for bpf_map_lookup_and_delete_batch()
Date:   Wed, 28 Aug 2019 23:45:13 -0700
Message-ID: <20190829064513.2751375-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test bpf_map_lookup_and_delete_batch() functionality.
  $ ./test_maps
  ...
  test_map_lookup_and_delete_batch:PASS
  ...

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../map_tests/map_lookup_and_delete_batch.c   | 164 ++++++++++++++++++
 1 file changed, 164 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
new file mode 100644
index 000000000000..b151513a0ab2
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
@@ -0,0 +1,164 @@
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
+	const __u32 max_entries = 10;
+	void *p_skey, *p_next_skey;
+	__u32 count, total;
+	int err, i, step;
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
+	p_next_skey = &key;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &p_next_skey, keys, values,
+					      &count, 0, 0);
+	CHECK(err, "empty map", "error: %s\n", strerror(errno));
+	CHECK(p_next_skey || count, "empty map",
+	      "p_next_skey = %p, count = %u\n", p_next_skey, count);
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries, keys, values);
+
+	/* test 2: lookup/delete with count = 0, success */
+	count = 0;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, NULL, keys, values,
+					      &count, 0, 0);
+	CHECK(err, "count = 0", "error: %s\n", strerror(errno));
+
+	/* test 3: lookup/delete with count = max_entries, skey && !nskey,
+	 * failure.
+	 */
+	count = max_entries;
+	key = 1;
+	err = bpf_map_lookup_and_delete_batch(map_fd, &key, NULL, keys, values,
+					      &count, 0, 0);
+	CHECK(!err, "skey && !nskey", "unexpected success\n");
+
+	/* test 4: lookup/delete with count = max_entries, success */
+	memset(keys, 0, max_entries * sizeof(*keys));
+	memset(values, 0, max_entries * sizeof(*values));
+	count = max_entries;
+	p_next_skey = &key;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &p_next_skey, keys,
+					      values, &count, 0, 0);
+	CHECK(err, "count = max_entries", "error: %s\n", strerror(errno));
+	CHECK(count != max_entries || p_next_skey != NULL, "count = max_entries",
+	      "count = %u, max_entries = %u, p_next_skey = %p\n",
+	      count, max_entries, p_next_skey);
+	map_batch_verify(visited, max_entries, keys, values);
+
+	/* bpf_map_get_next_key() should return -ENOENT for an empty map. */
+	err = bpf_map_get_next_key(map_fd, NULL, &key);
+	CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+	/* test 5: lookup/delete in a loop with various steps. */
+	for (step = 1; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries, keys, values);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * sizeof(*values));
+		p_skey = NULL;
+		p_next_skey = &key;
+		total = 0;
+		i = 0;
+		/* iteratively lookup/delete elements with 'step' elements each */
+		count = step;
+		while (true) {
+			err = bpf_map_lookup_and_delete_batch(map_fd, p_skey,
+							      &p_next_skey,
+							      keys + i * step,
+							      values + i * step,
+							      &count, 0, 0);
+			CHECK(err, "lookup/delete with steps", "error: %s\n",
+			      strerror(errno));
+
+			total += count;
+			if (!p_next_skey)
+				break;
+
+			CHECK(count != step, "lookup/delete with steps",
+			      "i = %d, count = %u, step = %d\n",
+			      i, count, step);
+
+			if (!p_skey)
+				p_skey = p_next_skey;
+			i++;
+		}
+
+		CHECK(total != max_entries, "lookup/delete with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values);
+		err = bpf_map_get_next_key(map_fd, NULL, &key);
+		CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+	}
+
+	/* test 6: lookup/delete with keys in keys[]. */
+	map_batch_update(map_fd, max_entries, keys, values);
+	memset(values, 0, max_entries * sizeof(*values));
+	count = max_entries;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, NULL, keys, values,
+					      &count, 0, 0);
+	CHECK(err, "lookup/delete key in keys[]", "error: %s\n", strerror(errno));
+	map_batch_verify(visited, max_entries, keys, values);
+	err = bpf_map_get_next_key(map_fd, NULL, &key);
+	CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.17.1

