Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE35E0A7A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbfJVRVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:21:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730186AbfJVRVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:21:09 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9MHIXfT017321
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 10:21:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=m9qAyElN1GBDWp30dzZfSfuu5wxLxC4ELahqTfLSzyA=;
 b=f77MNkgRxgmE7sv6/luF5ZgbBeHSkXR7G1I6e8dSbK0QhWrtJvqY+iJjNvZY+rpPdGdA
 T8bWQ4tR853lpWaUl9Pkd1pyxeTag0AaHTTi8PdKQ/OIdY2U+ydGoQaRSf7t0cu/U59S
 2FeGTvaO+6Xcs5BkxFcdJ8SiY90BL7J2L6M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vrj6su8an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 10:21:08 -0700
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Oct 2019 10:21:07 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 96A37861A05; Tue, 22 Oct 2019 10:21:01 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next] libbpf: make DECLARE_LIBBPF_OPTS macro strictly a variable declaration
Date:   Tue, 22 Oct 2019 10:21:00 -0700
Message-ID: <20191022172100.3281465-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-22_03:2019-10-22,2019-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 adultscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910220143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LIBBPF_OPTS is implemented as a mix of field declaration and memset
+ assignment. This makes it neither variable declaration nor purely
statements, which is a problem, because you can't mix it with either
other variable declarations nor other function statements, because C90
compiler mode emits warning on mixing all that together.

This patch changes LIBBPF_OPTS into a strictly declaration of variable
and solves this problem, as can be seen in case of bpftool, which
previously would emit compiler warning, if done this way (LIBBPF_OPTS as
part of function variables declaration block).

This patch also renames LIBBPF_OPTS into DECLARE_LIBBPF_OPTS to follow
kernel convention for similar macros more closely.

v1->v2:
- rename LIBBPF_OPTS into DECLARE_LIBBPF_OPTS (Jakub Sitnicki).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/prog.c                      |  8 ++++----
 tools/lib/bpf/libbpf.c                        |  4 ++--
 tools/lib/bpf/libbpf.h                        | 19 ++++++++++++-------
 .../selftests/bpf/prog_tests/attach_probe.c   |  2 +-
 .../selftests/bpf/prog_tests/core_reloc.c     |  2 +-
 .../bpf/prog_tests/reference_tracking.c       |  2 +-
 6 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 27da96a797ab..4535c863d2cd 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1091,8 +1091,11 @@ static int do_run(int argc, char **argv)
 
 static int load_with_options(int argc, char **argv, bool first_prog_only)
 {
-	struct bpf_object_load_attr load_attr = { 0 };
 	enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+		.relaxed_maps = relaxed_maps,
+	);
+	struct bpf_object_load_attr load_attr = { 0 };
 	enum bpf_attach_type expected_attach_type;
 	struct map_replace *map_replace = NULL;
 	struct bpf_program *prog = NULL, *pos;
@@ -1106,9 +1109,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	const char *file;
 	int idx, err;
 
-	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
-		.relaxed_maps = relaxed_maps,
-	);
 
 	if (!REQ_ARGS(2))
 		return -1;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 803219d6898c..8b4d765c422b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3678,7 +3678,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 static struct bpf_object *
 __bpf_object__open_xattr(struct bpf_object_open_attr *attr, int flags)
 {
-	LIBBPF_OPTS(bpf_object_open_opts, opts,
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
 		.relaxed_maps = flags & MAPS_RELAX_COMPAT,
 	);
 
@@ -3730,7 +3730,7 @@ struct bpf_object *
 bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz,
 			const char *name)
 {
-	LIBBPF_OPTS(bpf_object_open_opts, opts,
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
 		.object_name = name,
 		/* wrong default, but backwards-compatible */
 		.relaxed_maps = true,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0fdf086beba7..c63e2ff84abc 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -75,14 +75,19 @@ struct bpf_object_open_attr {
  * have all the padding bytes initialized to zero. It's not guaranteed though,
  * when copying literal, that compiler won't copy garbage in literal's padding
  * bytes, but that's the best way I've found and it seems to work in practice.
+ *
+ * Macro declares opts struct of given type and name, zero-initializes,
+ * including any extra padding, it with memset() and then assigns initial
+ * values provided by users in struct initializer-syntax as varargs.
  */
-#define LIBBPF_OPTS(TYPE, NAME, ...)					    \
-	struct TYPE NAME;						    \
-	memset(&NAME, 0, sizeof(struct TYPE));				    \
-	NAME = (struct TYPE) {						    \
-		.sz = sizeof(struct TYPE),				    \
-		__VA_ARGS__						    \
-	}
+#define DECLARE_LIBBPF_OPTS(TYPE, NAME, ...)				    \
+	struct TYPE NAME = ({ 						    \
+		memset(&NAME, 0, sizeof(struct TYPE));			    \
+		(struct TYPE) {						    \
+			.sz = sizeof(struct TYPE),			    \
+			__VA_ARGS__					    \
+		};							    \
+	})
 
 struct bpf_object_open_opts {
 	/* size of this struct, for forward/backward compatiblity */
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index 0ee1ce100a4a..a83111a32d4a 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -50,7 +50,7 @@ void test_attach_probe(void)
 	const int kprobe_idx = 0, kretprobe_idx = 1;
 	const int uprobe_idx = 2, uretprobe_idx = 3;
 	const char *obj_name = "attach_probe";
-	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
 		.object_name = obj_name,
 		.relaxed_maps = true,
 	);
diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 523dca82dc82..09dfa75fe948 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -377,7 +377,7 @@ void test_core_reloc(void)
 		if (!test__start_subtest(test_case->case_name))
 			continue;
 
-		LIBBPF_OPTS(bpf_object_open_opts, opts,
+		DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
 			.relaxed_core_relocs = test_case->relaxed_core_relocs,
 		);
 
diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index 4493ba277bd7..fc0d7f4f02cf 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -5,7 +5,7 @@ void test_reference_tracking(void)
 {
 	const char *file = "test_sk_lookup_kern.o";
 	const char *obj_name = "ref_track";
-	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
 		.object_name = obj_name,
 		.relaxed_maps = true,
 	);
-- 
2.17.1

