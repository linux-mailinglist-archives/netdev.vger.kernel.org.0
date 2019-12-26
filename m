Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890AD12AEB0
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfLZVDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:03:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbfLZVDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:03:32 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBQL3U41018696
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:03:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=cJpNZWCyyfBEFM+om0DA7usCdi4S18G/uiTBeL4GCmc=;
 b=b2j6RYoJQQ3dlk9/EicLAzpf7WU02A4ylWKV3wP6/truaXOKdX0Wb9BtYwY8tXbW/uyQ
 Mk4EujedXIA5ZWUbbjKuEJP7fmXPEM1Wpxua5Tbg/1bLpaFVeIx0wFPGD9LsvyVDPnae
 AKsYvWkn6ZzfpnF0qIArKry8CsAYIocrJa0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2x3mexfvbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:03:31 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 26 Dec 2019 13:02:55 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5F2812EC1BD4; Thu, 26 Dec 2019 13:02:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpftool: make skeleton C code compilable with C++ compiler
Date:   Thu, 26 Dec 2019 13:02:53 -0800
Message-ID: <20191226210253.3132060-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-26_05:2019-12-24,2019-12-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 priorityscore=1501 suspectscore=8 bulkscore=0
 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=770
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912260187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When auto-generated BPF skeleton C code is included from C++ application, it
triggers compilation error due to void * being implicitly casted to whatever
target pointer type. This is supported by C, but not C++. To solve this
problem, add explicit casts, where necessary.

To ensure issues like this are captured going forward, add skeleton usage in
test_cpp test.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c                  | 10 +++++-----
 tools/testing/selftests/bpf/Makefile     |  2 +-
 tools/testing/selftests/bpf/test_cpp.cpp | 10 ++++++++++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index a14d8bc5d31d..7ce09a9a6999 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -397,7 +397,7 @@ static int do_skeleton(int argc, char **argv)
 		{							    \n\
 			struct %1$s *obj;				    \n\
 									    \n\
-			obj = calloc(1, sizeof(*obj));			    \n\
+			obj = (typeof(obj))calloc(1, sizeof(*obj));	    \n\
 			if (!obj)					    \n\
 				return NULL;				    \n\
 			if (%1$s__create_skeleton(obj))			    \n\
@@ -461,7 +461,7 @@ static int do_skeleton(int argc, char **argv)
 		{							    \n\
 			struct bpf_object_skeleton *s;			    \n\
 									    \n\
-			s = calloc(1, sizeof(*s));			    \n\
+			s = (typeof(s))calloc(1, sizeof(*s));		    \n\
 			if (!s)						    \n\
 				return -1;				    \n\
 			obj->skeleton = s;				    \n\
@@ -479,7 +479,7 @@ static int do_skeleton(int argc, char **argv)
 				/* maps */				    \n\
 				s->map_cnt = %zu;			    \n\
 				s->map_skel_sz = sizeof(*s->maps);	    \n\
-				s->maps = calloc(s->map_cnt, s->map_skel_sz);\n\
+				s->maps = (typeof(s->maps))calloc(s->map_cnt, s->map_skel_sz);\n\
 				if (!s->maps)				    \n\
 					goto err;			    \n\
 			",
@@ -515,7 +515,7 @@ static int do_skeleton(int argc, char **argv)
 				/* programs */				    \n\
 				s->prog_cnt = %zu;			    \n\
 				s->prog_skel_sz = sizeof(*s->progs);	    \n\
-				s->progs = calloc(s->prog_cnt, s->prog_skel_sz);\n\
+				s->progs = (typeof(s->progs))calloc(s->prog_cnt, s->prog_skel_sz);\n\
 				if (!s->progs)				    \n\
 					goto err;			    \n\
 			",
@@ -538,7 +538,7 @@ static int do_skeleton(int argc, char **argv)
 		\n\
 									    \n\
 			s->data_sz = %d;				    \n\
-			s->data = \"\\					    \n\
+			s->data = (void *)\"\\				    \n\
 		",
 		file_sz);
 
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 866fc1cadd7c..41691fb067da 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -371,7 +371,7 @@ $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
 	$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
 # Make sure we are able to include and link libbpf against c++.
-$(OUTPUT)/test_cpp: test_cpp.cpp $(BPFOBJ)
+$(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
 	$(call msg,        CXX,,$@)
 	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/bpf/test_cpp.cpp b/tools/testing/selftests/bpf/test_cpp.cpp
index f0eb2727b766..6fe23a10d48a 100644
--- a/tools/testing/selftests/bpf/test_cpp.cpp
+++ b/tools/testing/selftests/bpf/test_cpp.cpp
@@ -1,12 +1,16 @@
 /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#include <iostream>
 #include "libbpf.h"
 #include "bpf.h"
 #include "btf.h"
+#include "test_core_extern.skel.h"
 
 /* do nothing, just make sure we can link successfully */
 
 int main(int argc, char *argv[])
 {
+	struct test_core_extern *skel;
+
 	/* libbpf.h */
 	libbpf_set_print(NULL);
 
@@ -16,5 +20,11 @@ int main(int argc, char *argv[])
 	/* btf.h */
 	btf__new(NULL, 0);
 
+	/* BPF skeleton */
+	skel = test_core_extern__open_and_load();
+	test_core_extern__destroy(skel);
+
+	std::cout << "DONE!" << std::endl;
+
 	return 0;
 }
-- 
2.17.1

