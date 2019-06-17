Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB91748EA1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfFQT11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729009AbfFQT1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:23 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJF6bs031856
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=hgd2GaT4vQMfwGIz1HWqKwT3GJCU6mIcemu94Xay3gc=;
 b=SuwXrW/ghjsWNueKVme1FaqnqZa4+iUPPwWzFIRt9BvujKFSlnaonCGgRmDg0eUd5IY9
 lvyLZDYTLs7eXCZLS9Am+CppG7MwLMyFoTMYH4GWEepWqS9L4Jm6sdDYnpT1xHmvCj8t
 HWmFu9cBZjHpjeakPGmwupk1p1pMPiDr9+0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6a3hsm4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:22 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:21 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id EA2C486173A; Mon, 17 Jun 2019 12:27:17 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 08/11] selftests/bpf: add test for BTF-defined maps
Date:   Mon, 17 Jun 2019 12:26:57 -0700
Message-ID: <20190617192700.2313445-9-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617192700.2313445-1-andriin@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add file test for BTF-defined map definition.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
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

