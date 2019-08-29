Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E66A1204
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfH2GpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59950 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727555AbfH2GpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6hJVZ008276
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=22f0U+Utr+GEn3oQF9cxkOlMTI7YWZ6RTdF+3ucMdtU=;
 b=nHY54FzOeJAZ2scx0dp8ikIu7qyvzcCB2HR2Frjy6L3iuyXncEiYntAPyydek6zxagfJ
 6ZRlcmCXzEF9sgLgfyr5H+Vl+2m/Vi+tyw3GSdGVR3bdjFZabIpxwJ+lzN311aQTzw91
 bBFVV7wwEgnxqLRCnY5TWnE7yjFigrn9xsg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2une016qut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:19 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 23:45:18 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 523C03702BA3; Wed, 28 Aug 2019 23:45:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 12/13] tools/bpf: add a multithreaded test for map batch operations
Date:   Wed, 28 Aug 2019 23:45:16 -0700
Message-ID: <20190829064516.2751550-1-yhs@fb.com>
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

A multithreaded test is added. Three threads repeatedly did:
  - batch update
  - batch lookup_and_delete
  - batch delete

It is totally possible each batch element operation in kernel
may find that the key, retrieved from bpf_map_get_next_key(),
may fail lookup and/or delete as some other threads in parallel
operates on the same map.

The default mode for new batch APIs is to ignore -ENOENT errors
in case of lookup and delete and move to the next element.
The test would otherwise fail if the kernel reacts as -ENOENT
as a real error and propogates it back to user space.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/map_tests/map_batch_mt.c    | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_batch_mt.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_batch_mt.c b/tools/testing/selftests/bpf/map_tests/map_batch_mt.c
new file mode 100644
index 000000000000..a0e2591d0079
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_batch_mt.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <pthread.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+/* Create three threads. Each thread will iteratively do:
+ *   . update constantly
+ *   . lookup and delete constantly
+ *   . delete constantly
+ * So this will make lookup and delete operations
+ * may fail as the elements may be deleted by another
+ * thread.
+ *
+ * By default, we should not see a problem as
+ * -ENOENT for bpf_map_delete_elem() and bpf_map_lookup_elem()
+ * will be ignored. But with flag, BPF_F_ENFORCE_ENOENT
+ * we may see errors.
+ */
+
+static int map_fd;
+static const __u32 max_entries = 10;
+static volatile bool stop = false;
+
+static void do_batch_update()
+{
+	int i, err, keys[max_entries], values[max_entries];
+	__u32 count;
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i] = i + 1;
+		values[i] = i + 2;
+	}
+
+	while (!stop) {
+		count = max_entries;
+		err = bpf_map_update_batch(map_fd, keys, values, &count, 0, 0);
+		CHECK(err, "bpf_map_update_batch()", "error:%s\n",
+		      strerror(errno));
+	}
+}
+
+static void do_batch_delete()
+{
+	__u32 count;
+	int err;
+
+	while (!stop) {
+		count = 0;
+		err = bpf_map_delete_batch(map_fd, NULL, NULL, NULL, &count,
+					   0, 0);
+		CHECK(err, "bpf_map_delete_batch()", "error:%s\n",
+		      strerror(errno));
+	}
+}
+
+static void do_batch_lookup_and_delete()
+{
+	int err, key, keys[max_entries], values[max_entries];
+	__u32 count;
+	void *p_key;
+
+	while (!stop) {
+		p_key = &key;
+		count = max_entries;
+		err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &p_key,
+						      keys, values, &count,
+						      0, 0);
+		CHECK(err, "bpf_map_lookup_and_delete_batch()", "error:%s\n",
+		      strerror(errno));
+	}
+}
+
+static void *do_work(void *arg)
+{
+	int work_index = (int)(long)arg;
+
+	if (work_index == 0)
+		do_batch_update();
+	else if (work_index == 1)
+		do_batch_delete();
+	else
+		do_batch_lookup_and_delete();
+
+	return NULL;
+}
+
+void test_map_batch_mt(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "hash_map",
+		.map_type = BPF_MAP_TYPE_HASH,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	const int nr_threads = 3;
+	pthread_t threads[nr_threads];
+	int i, err;
+
+	xattr.max_entries = max_entries;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1,
+	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
+
+	for (i = 0; i < nr_threads; i++) {
+		err = pthread_create(&threads[i], NULL, do_work,
+				     (void *)(long)i);
+		CHECK(err, "pthread_create", "error: %s\n", strerror(errno));
+	}
+
+	sleep(1);
+	stop = true;
+
+	for (i = 0; i < nr_threads; i++)
+		pthread_join(threads[i], NULL);
+
+	close(map_fd);
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.17.1

