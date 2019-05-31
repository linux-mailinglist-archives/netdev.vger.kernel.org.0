Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50BE31611
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfEaUWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:22:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59780 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727577AbfEaUWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:22:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VKHUwc012381
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:21:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Wt6sD2qSGKYkBS0QszOymKVaxgnbMMGtUJuBoNuqkAY=;
 b=GdqEIYun/5tf2LgsqsoSJxE7pOMSmbPOx5JJR5DDBZauz+YsvUzkTxXWGNaTh3j7njvV
 Tp5p9b3UGiucM0N+cF5/UP4YUth6k5uDM4DudJ1e5SZ+jjdCK8gr/dk9me8D0r/UBTr3
 P9arPmv+yPS3YVI/alieLL1xhTgcniLNbE8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2su26p9tsn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:21:58 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 31 May 2019 13:21:58 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B7D7C861799; Fri, 31 May 2019 13:21:55 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [RFC PATCH bpf-next 7/8] selftests/bpf: add test for BTF-defined maps
Date:   Fri, 31 May 2019 13:21:31 -0700
Message-ID: <20190531202132.379386-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190531202132.379386-1-andriin@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=972 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add file test for BTF-defined map definition.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/progs/test_btf_newkv.c      | 73 +++++++++++++++++++
 tools/testing/selftests/bpf/test_btf.c        | 10 +--
 2 files changed, 76 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_newkv.c

diff --git a/tools/testing/selftests/bpf/progs/test_btf_newkv.c b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
new file mode 100644
index 000000000000..28c16bb583b6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2018 Facebook */
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+int _version SEC("version") = 1;
+
+struct ipv_counts {
+	unsigned int v4;
+	unsigned int v6;
+};
+
+/* just to validate we can handle maps in multiple sections */
+struct bpf_map_def SEC("maps") btf_map_legacy = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(long long),
+	.max_entries = 4,
+};
+
+BPF_ANNOTATE_KV_PAIR(btf_map_legacy, int, struct ipv_counts);
+
+struct {
+	int *key;
+	struct ipv_counts *value;
+	unsigned int type;
+	unsigned int max_entries;
+} btf_map SEC(".maps") = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.max_entries = 4,
+};
+
+struct dummy_tracepoint_args {
+	unsigned long long pad;
+	struct sock *sock;
+};
+
+__attribute__((noinline))
+static int test_long_fname_2(struct dummy_tracepoint_args *arg)
+{
+	struct ipv_counts *counts;
+	int key = 0;
+
+	if (!arg->sock)
+		return 0;
+
+	counts = bpf_map_lookup_elem(&btf_map, &key);
+	if (!counts)
+		return 0;
+
+	counts->v6++;
+
+	/* just verify we can reference both maps */
+	counts = bpf_map_lookup_elem(&btf_map_legacy, &key);
+	if (!counts)
+		return 0;
+
+	return 0;
+}
+
+__attribute__((noinline))
+static int test_long_fname_1(struct dummy_tracepoint_args *arg)
+{
+	return test_long_fname_2(arg);
+}
+
+SEC("dummy_tracepoint")
+int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
+{
+	return test_long_fname_1(arg);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 289daf54dec4..8351cb5f4a20 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -4016,13 +4016,9 @@ struct btf_file_test {
 };
 
 static struct btf_file_test file_tests[] = {
-{
-	.file = "test_btf_haskv.o",
-},
-{
-	.file = "test_btf_nokv.o",
-	.btf_kv_notfound = true,
-},
+	{ .file = "test_btf_haskv.o", },
+	{ .file = "test_btf_newkv.o", },
+	{ .file = "test_btf_nokv.o", .btf_kv_notfound = true, },
 };
 
 static int do_test_file(unsigned int test_num)
-- 
2.17.1

