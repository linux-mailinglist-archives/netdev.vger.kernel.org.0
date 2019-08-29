Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1AFA11F9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfH2GpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63904 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727715AbfH2GpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:18 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6hJEF008268
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=jetQnO8HAxQ7GZMZuHqQ3sKTGoOOmJlPX84fFhZEPEI=;
 b=K+Dm6RtJNoW8UP7136qPnsJEimFpcZ4G9Oph96c99I+FuGYBfz+rRm0FwEXOP0tdKcjv
 kWJ/E063n4vSBoL4y+HxcqcYdC8HwmNwzNTY2W81yI28PCCJWIRKd3DwJ+4opl0yvXdp
 3eFzq5xO0uF5+hMvXKbnX1y3NixaSU1qhFA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2une016qup-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:18 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 23:45:16 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 20EE33702BA3; Wed, 28 Aug 2019 23:45:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 11/13] tools/bpf: add test for bpf_map_delete_batch()
Date:   Wed, 28 Aug 2019 23:45:15 -0700
Message-ID: <20190829064515.2751440-1-yhs@fb.com>
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

Test bpf_map_delete_batch() functionality.
  $ ./test_maps
  ...
  test_map_delete_batch:PASS
  ...
---
 .../bpf/map_tests/map_delete_batch.c          | 139 ++++++++++++++++++
 1 file changed, 139 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_delete_batch.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_delete_batch.c b/tools/testing/selftests/bpf/map_tests/map_delete_batch.c
new file mode 100644
index 000000000000..459495a6d9fc
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_delete_batch.c
@@ -0,0 +1,139 @@
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
+void test_map_delete_batch(void)
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
+	/* test 1: delete an empty hash table, success */
+	for (i = 0; i < 2; i++) {
+		if (i == 0) {
+			count = 0;
+			p_next_skey = NULL;
+		} else {
+			count = max_entries;
+			p_next_skey = &key;
+		}
+		err = bpf_map_delete_batch(map_fd, NULL, &p_next_skey, keys,
+					   &count, 0, 0);
+		CHECK(err, "empty map", "error: %s\n", strerror(errno));
+		CHECK(p_next_skey || count, "empty map",
+		      "i = %d, p_next_skey = %p, count = %u\n", i, p_next_skey,
+		      count);
+	}
+
+	/* test 2: delete with count = 0, success */
+	for (i = 0; i < 2; i++) {
+		/* populate elements to the map */
+		map_batch_update(map_fd, max_entries, keys, values);
+
+		count = 0;
+		if (i == 0) {
+			/* all elements in the map */
+			p_skey = NULL;
+		} else {
+			/* all elements starting from p_skey */
+			p_skey = &key;
+			err = bpf_map_get_next_key(map_fd, NULL, p_skey);
+			CHECK(err, "bpf_map_get_next_key()", "error: %s\n",
+			      strerror(errno));
+		}
+		err = bpf_map_delete_batch(map_fd, p_skey, NULL, NULL,
+				    &count, 0, 0);
+		CHECK(err, "count = 0", "error: %s\n", strerror(errno));
+		/* all elements should be gone. */
+		err = bpf_map_get_next_key(map_fd, NULL, &key);
+		CHECK(!err, "bpf_map_get_next_key()", "unexpected success\n");
+	}
+
+	/* test 3: delete in a loop with various steps. */
+	for (step = 1; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries, keys, values);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * sizeof(*values));
+		p_skey = NULL;
+		p_next_skey = &key;
+		total = 0;
+		i = 0;
+		/* iteratively delete elements with 'step' elements each */
+		count = step;
+		while (true) {
+			err = bpf_map_delete_batch(map_fd, p_skey, &p_next_skey,
+					      keys + i * step, &count, 0, 0);
+			CHECK(err, "delete with steps", "error: %s\n",
+			      strerror(errno));
+
+			total += count;
+			if (!p_next_skey)
+				break;
+
+			CHECK(count != step, "delete with steps",
+			      "i = %d, count = %u, step = %d\n",
+			      i, count, step);
+
+			if (!p_skey)
+				p_skey = p_next_skey;
+			i++;
+		}
+
+		CHECK(total != max_entries, "delete with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		err = bpf_map_get_next_key(map_fd, NULL, &key);
+		CHECK(!err, "bpf_map_get_next_key()", "error: %s\n",
+		      strerror(errno));
+	}
+
+	/* test 4: delete with keys in keys[]. */
+	map_batch_update(map_fd, max_entries, keys, values);
+	memset(values, 0, max_entries * sizeof(*values));
+	count = max_entries;
+	err = bpf_map_delete_batch(map_fd, NULL, NULL, keys, &count, 0, 0);
+	CHECK(err, "delete key in keys[]", "error: %s\n", strerror(errno));
+	err = bpf_map_get_next_key(map_fd, NULL, &key);
+	CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.17.1

