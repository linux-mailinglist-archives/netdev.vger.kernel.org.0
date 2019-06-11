Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6723C303
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbfFKEs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:48:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55256 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403903AbfFKEs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:48:27 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5B4hnph023069
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:48:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Wt6sD2qSGKYkBS0QszOymKVaxgnbMMGtUJuBoNuqkAY=;
 b=RmaW/6mz1G9ODcx1LtLFc5Owws7TqiAKQab7QrEZXrGPp67JHrqgGt5JXaSvUr10cx/w
 d4RVFkmp6wX87gZH5a4KoarlBxndVkgZG67AZsqVgygNwDVJpj1GgO41RIb0eR2n+n76
 S5Qrzo4WtDtTSGnhxYYH/ohLKUgWykn0vjk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2t1u4qt3bm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:48:25 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 21:48:25 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 4B5B186186A; Mon, 10 Jun 2019 21:48:24 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 7/8] selftests/bpf: add test for BTF-defined maps
Date:   Mon, 10 Jun 2019 21:47:46 -0700
Message-ID: <20190611044747.44839-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611044747.44839-1-andriin@fb.com>
References: <20190611044747.44839-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=971 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110033
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

