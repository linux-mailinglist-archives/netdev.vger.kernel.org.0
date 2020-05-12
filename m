Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048951CFE9D
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgELTrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:47:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgELTrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:47:05 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04CJgFSs007940
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:47:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=o2eOq6zTVUFAZHwnnUAVzjeidF+TGCxJlYR/wc1Q+y0=;
 b=GNew9T5IrMr5CHMfL27HYOzklq1RIrrGve33Hrgy1qk46dgF5IcPT8j5c9FSf5/z+XsP
 dYiYXOU2cGsadnm6Y3g1Raj1ZdYQG+wF3KCO7yfkzP5vFOsVhP5QrgD/bmLTLtrcfoVC
 VeIp6NoLaRW4GJ1yMF9132YD8XDeVYqzJmI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3100vygg4q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:47:04 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 12:47:03 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4EE8A2EC317E; Tue, 12 May 2020 12:46:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/4] selftests/bpf: extract parse_num_list into generic testing_helpers.c
Date:   Tue, 12 May 2020 12:24:42 -0700
Message-ID: <20200512192445.2351848-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512192445.2351848-1-andriin@fb.com>
References: <20200512192445.2351848-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_07:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 cotscore=-2147483648 priorityscore=1501 suspectscore=25
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add testing_helpers.c, which will contain generic helpers for test runner=
s and
tests needing some common generic functionality, like parsing a set of
numbers.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 tools/testing/selftests/bpf/test_progs.c      | 67 ++-----------------
 tools/testing/selftests/bpf/test_progs.h      |  1 +
 tools/testing/selftests/bpf/testing_helpers.c | 66 ++++++++++++++++++
 tools/testing/selftests/bpf/testing_helpers.h |  5 ++
 5 files changed, 78 insertions(+), 64 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/testing_helpers.c
 create mode 100644 tools/testing/selftests/bpf/testing_helpers.h

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 8f25966b500b..52556712aad4 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -354,7 +354,8 @@ endef
 TRUNNER_TESTS_DIR :=3D prog_tests
 TRUNNER_BPF_PROGS_DIR :=3D progs
 TRUNNER_EXTRA_SOURCES :=3D test_progs.c cgroup_helpers.c trace_helpers.c=
	\
-			 network_helpers.c flow_dissector_load.h
+			 network_helpers.c testing_helpers.c		\
+			 flow_dissector_load.h
 TRUNNER_EXTRA_FILES :=3D $(OUTPUT)/urandom_read				\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE :=3D CLANG_BPF_BUILD_RULE
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/sel=
ftests/bpf/test_progs.c
index 0f411fdc4f6d..54fa5fa688ce 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -438,67 +438,6 @@ static int parse_str_list(const char *s, struct str_=
set *set)
 	return -ENOMEM;
 }
=20
-int parse_num_list(const char *s, struct test_selector *sel)
-{
-	int i, set_len =3D 0, new_len, num, start =3D 0, end =3D -1;
-	bool *set =3D NULL, *tmp, parsing_end =3D false;
-	char *next;
-
-	while (s[0]) {
-		errno =3D 0;
-		num =3D strtol(s, &next, 10);
-		if (errno)
-			return -errno;
-
-		if (parsing_end)
-			end =3D num;
-		else
-			start =3D num;
-
-		if (!parsing_end && *next =3D=3D '-') {
-			s =3D next + 1;
-			parsing_end =3D true;
-			continue;
-		} else if (*next =3D=3D ',') {
-			parsing_end =3D false;
-			s =3D next + 1;
-			end =3D num;
-		} else if (*next =3D=3D '\0') {
-			parsing_end =3D false;
-			s =3D next;
-			end =3D num;
-		} else {
-			return -EINVAL;
-		}
-
-		if (start > end)
-			return -EINVAL;
-
-		if (end + 1 > set_len) {
-			new_len =3D end + 1;
-			tmp =3D realloc(set, new_len);
-			if (!tmp) {
-				free(set);
-				return -ENOMEM;
-			}
-			for (i =3D set_len; i < start; i++)
-				tmp[i] =3D false;
-			set =3D tmp;
-			set_len =3D new_len;
-		}
-		for (i =3D start; i <=3D end; i++)
-			set[i] =3D true;
-	}
-
-	if (!set)
-		return -EINVAL;
-
-	sel->num_set =3D set;
-	sel->num_set_len =3D set_len;
-
-	return 0;
-}
-
 extern int extra_prog_load_log_flags;
=20
 static error_t parse_arg(int key, char *arg, struct argp_state *state)
@@ -512,13 +451,15 @@ static error_t parse_arg(int key, char *arg, struct=
 argp_state *state)
 		if (subtest_str) {
 			*subtest_str =3D '\0';
 			if (parse_num_list(subtest_str + 1,
-					   &env->subtest_selector)) {
+					   &env->subtest_selector.num_set,
+					   &env->subtest_selector.num_set_len)) {
 				fprintf(stderr,
 					"Failed to parse subtest numbers.\n");
 				return -EINVAL;
 			}
 		}
-		if (parse_num_list(arg, &env->test_selector)) {
+		if (parse_num_list(arg, &env->test_selector.num_set,
+				   &env->test_selector.num_set_len)) {
 			fprintf(stderr, "Failed to parse test numbers.\n");
 			return -EINVAL;
 		}
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/sel=
ftests/bpf/test_progs.h
index 83287c76332b..f4503c926aca 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -37,6 +37,7 @@ typedef __u16 __sum16;
 #include "bpf_util.h"
 #include <bpf/bpf_endian.h>
 #include "trace_helpers.h"
+#include "testing_helpers.h"
 #include "flow_dissector_load.h"
=20
 enum verbosity {
diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testin=
g/selftests/bpf/testing_helpers.c
new file mode 100644
index 000000000000..0af6337a8962
--- /dev/null
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+/* Copyright (C) 2020 Facebook, Inc. */
+#include <stdlib.h>
+#include <errno.h>
+#include "testing_helpers.h"
+
+int parse_num_list(const char *s, bool **num_set, int *num_set_len)
+{
+	int i, set_len =3D 0, new_len, num, start =3D 0, end =3D -1;
+	bool *set =3D NULL, *tmp, parsing_end =3D false;
+	char *next;
+
+	while (s[0]) {
+		errno =3D 0;
+		num =3D strtol(s, &next, 10);
+		if (errno)
+			return -errno;
+
+		if (parsing_end)
+			end =3D num;
+		else
+			start =3D num;
+
+		if (!parsing_end && *next =3D=3D '-') {
+			s =3D next + 1;
+			parsing_end =3D true;
+			continue;
+		} else if (*next =3D=3D ',') {
+			parsing_end =3D false;
+			s =3D next + 1;
+			end =3D num;
+		} else if (*next =3D=3D '\0') {
+			parsing_end =3D false;
+			s =3D next;
+			end =3D num;
+		} else {
+			return -EINVAL;
+		}
+
+		if (start > end)
+			return -EINVAL;
+
+		if (end + 1 > set_len) {
+			new_len =3D end + 1;
+			tmp =3D realloc(set, new_len);
+			if (!tmp) {
+				free(set);
+				return -ENOMEM;
+			}
+			for (i =3D set_len; i < start; i++)
+				tmp[i] =3D false;
+			set =3D tmp;
+			set_len =3D new_len;
+		}
+		for (i =3D start; i <=3D end; i++)
+			set[i] =3D true;
+	}
+
+	if (!set)
+		return -EINVAL;
+
+	*num_set =3D set;
+	*num_set_len =3D set_len;
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/testing_helpers.h b/tools/testin=
g/selftests/bpf/testing_helpers.h
new file mode 100644
index 000000000000..923b51762759
--- /dev/null
+++ b/tools/testing/selftests/bpf/testing_helpers.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+/* Copyright (C) 2020 Facebook, Inc. */
+#include <stdbool.h>
+
+int parse_num_list(const char *s, bool **set, int *set_len);
--=20
2.24.1

