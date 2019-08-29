Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC57AA11FF
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfH2GpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727544AbfH2GpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x7T6ik7l031718
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zySreUdnAkoKX4rB4C6BA1z5bPcefPQKIcLMnMdoBkQ=;
 b=fciFlu6yFQv1lLuvAuphNdgMcSdtZ4YtakojGMEVrw8Y+BH0fPLQXxCUbDPo1V5OiYIn
 prVujF6zzHaz1pvneVTJHXw+vmH7s5T5CclkIP6rAOvBk6RRqXFTRLc0+XOr5aR12+dh
 2xofgM8vzPN2RemGS5nLIeA8uuXAQ2+P5wk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2up2dxsewu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:15 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 23:45:13 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 75C573702BA3; Wed, 28 Aug 2019 23:45:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 08/13] tools/bpf: add test for bpf_map_update_batch()
Date:   Wed, 28 Aug 2019 23:45:11 -0700
Message-ID: <20190829064511.2751174-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 mlxlogscore=981 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908290073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for bpf_map_update_batch().
  $ ./test_maps
  ...
  test_map_update_batch:PASS
  ...
---
 .../bpf/map_tests/map_update_batch.c          | 115 ++++++++++++++++++
 1 file changed, 115 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_update_batch.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_update_batch.c b/tools/testing/selftests/bpf/map_tests/map_update_batch.c
new file mode 100644
index 000000000000..67c1e11fc911
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_update_batch.c
@@ -0,0 +1,115 @@
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
+void test_map_update_batch(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "hash_map",
+		.map_type = BPF_MAP_TYPE_HASH,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	int map_fd, *keys, *values, key, value;
+	const int max_entries = 10;
+	__u32 count, max_count;
+	int err, i;
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
+	/* do not fill in the whole hash table, so we could test
+	 * update with new elements.
+	 */
+	max_count = max_entries - 2;
+
+	for (i = 0; i < max_count; i++) {
+		keys[i] = i + 1;
+		values[i] = i + 2;
+	}
+
+	/* test 1: count == 0, expect success. */
+	count = 0;
+	err = bpf_map_update_batch(map_fd, keys, values, &count, 0, 0);
+	CHECK(err, "count = 0", "error:%s\n", strerror(errno));
+
+	/* test 2: update initial map with BPF_NOEXIST, expect success. */
+	count = max_count;
+	err = bpf_map_update_batch(map_fd, keys, values,
+				   &count, BPF_NOEXIST, 0);
+	CHECK(err, "elem_flags = BPF_NOEXIST",
+	      "error:%s\n", strerror(errno));
+
+	/* use bpf_map_get_next_key to ensure all keys/values are indeed
+	 * covered.
+	 */
+	err = bpf_map_get_next_key(map_fd, NULL, &key);
+	CHECK(err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+	err = bpf_map_lookup_elem(map_fd, &key, &value);
+	CHECK(err, "bpf_map_lookup_elem()", "error: %s\n", strerror(errno));
+	CHECK(key + 1 != value, "key/value checking",
+	      "error: key %d value %d\n", key, value);
+	i = 1;
+	while (!bpf_map_get_next_key(map_fd, &key, &key)) {
+		err = bpf_map_lookup_elem(map_fd, &key, &value);
+		CHECK(err, "bpf_map_lookup_elem()", "error: %s\n",
+		      strerror(errno));
+		CHECK(key + 1 != value,
+		      "key/value checking", "error: key %d value %d\n",
+		      key, value);
+		i++;
+	}
+	CHECK(i != max_count, "checking number of entries",
+	      "err: i %u max_count %u\n", i, max_count);
+
+	/* test 3: elem_flags = BPF_NOEXIST, already exists, expect failure */
+	err = bpf_map_update_batch(map_fd, keys, values,
+				   &count, BPF_NOEXIST, 0);
+	/* failure to due to flag BPF_NOEXIST, count is set to 0 */
+	CHECK(!err || count, "elem_flags = BPF_NOEXIST again",
+	      "unexpected success\n");
+
+	/* test 4: elem_flags = 0, expect success */
+	count = max_count;
+	err = bpf_map_update_batch(map_fd, keys, values,
+				   &count, 0, 0);
+	CHECK(err, "elem_flags = 0", "error %s\n", strerror(errno));
+
+	/* test 5: keys = NULL, expect failure */
+	count = max_count;
+	err = bpf_map_update_batch(map_fd, NULL, values,
+				   &count, 0, 0);
+	CHECK(!err, "keys = NULL", "unexpected success\n");
+
+	/* test 6: values = NULL, expect failure */
+	count = max_count;
+	err = bpf_map_update_batch(map_fd, keys, NULL, &count, 0, 0);
+	CHECK(!err, "values = NULL", "unexpected success\n");
+
+	/* test 7: modify the first key to be max_count + 10,
+	 * elem_flags = BPF_NOEXIST,
+	 * expect failure, the return count = 1.
+	 */
+	count = max_count;
+	keys[0] = max_count + 10;
+	err = bpf_map_update_batch(map_fd, keys, values,
+				   &count, BPF_NOEXIST, 0);
+	CHECK(!err, "keys[0] = max_count + 10", "unexpected success\n");
+	CHECK(count != 1, "keys[0] = max_count + 10",
+	      "error: %s, incorrect count %u\n", strerror(errno), count);
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.17.1

