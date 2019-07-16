Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A351B6AFFA
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388710AbfGPTiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:38:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46636 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728858AbfGPTit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:38:49 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GJbkx4020518
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:38:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=/27MRGCdL4PbTbze4k7vf8xcAzDRmMW+MR/RJxqUMAk=;
 b=P8kSywXjq/PWVi8BPuf7GBwav78Q0bWcuGyu4c1KLhA786IMlJ967j7ZayRrkjUWFYrQ
 3oF0v0R4Yf4j8GoTnx9BSklEc5v/9hujIJUfTObwifU4pxziLgLV3+JJuwxvCYV094ID
 MjcYU7mZhS1UO1lXf4QCxGUsI41Ha+RQQSk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tsakpt9mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:38:48 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 16 Jul 2019 12:38:47 -0700
Received: by devvm1662.vll1.facebook.com (Postfix, from userid 137359)
        id 4066A13432DA; Tue, 16 Jul 2019 12:38:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devvm1662.vll1.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH bpf 2/2] selftests/bpf: structure test_{progs,maps,verifier} test runners uniformly
Date:   Tue, 16 Jul 2019 12:38:37 -0700
Message-ID: <20190716193837.2808971-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190716193837.2808971-1-andriin@fb.com>
References: <20190716193837.2808971-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=870 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160240
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's easier to follow the logic if it's structured the same.
There is just slight difference between test_progs/test_maps and
test_verifier. test_verifier's verifier/*.c files are not really compilable
C files (they are more of include headers), so they can't be specified as
explicit dependencies of test_verifier.

Cc: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 9bc68d8abc5f..11c9c62c3362 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -176,6 +176,7 @@ endif
 endif
 
 TEST_PROGS_CFLAGS := -I. -I$(OUTPUT)
+TEST_MAPS_CFLAGS := -I. -I$(OUTPUT)
 TEST_VERIFIER_CFLAGS := -I. -I$(OUTPUT) -Iverifier
 
 ifneq ($(SUBREG_CODEGEN),)
@@ -227,16 +228,14 @@ ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
 endif
 
-PROG_TESTS_H := $(OUTPUT)/prog_tests/tests.h
-test_progs.c: $(PROG_TESTS_H)
-$(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
-$(OUTPUT)/test_progs: prog_tests/*.c
-
 PROG_TESTS_DIR = $(OUTPUT)/prog_tests
 $(PROG_TESTS_DIR):
 	mkdir -p $@
-
+PROG_TESTS_H := $(PROG_TESTS_DIR)/tests.h
 PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
+test_progs.c: $(PROG_TESTS_H)
+$(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
+$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_H) $(PROG_TESTS_FILES)
 $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
 	$(shell ( cd prog_tests/; \
 		  echo '/* Generated header, do not edit */'; \
@@ -250,7 +249,6 @@ $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
 		  echo '#endif' \
 		 ) > $(PROG_TESTS_H))
 
-TEST_MAPS_CFLAGS := -I. -I$(OUTPUT)
 MAP_TESTS_DIR = $(OUTPUT)/map_tests
 $(MAP_TESTS_DIR):
 	mkdir -p $@
@@ -272,17 +270,15 @@ $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
 		  echo '#endif' \
 		 ) > $(MAP_TESTS_H))
 
-VERIFIER_TESTS_H := $(OUTPUT)/verifier/tests.h
-test_verifier.c: $(VERIFIER_TESTS_H)
-$(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
-$(OUTPUT)/test_verifier: test_verifier.c $(VERIFIER_TESTS_H)
-
 VERIFIER_TESTS_DIR = $(OUTPUT)/verifier
 $(VERIFIER_TESTS_DIR):
 	mkdir -p $@
-
+VERIFIER_TESTS_H := $(VERIFIER_TESTS_DIR)/tests.h
 VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
-$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
+test_verifier.c: $(VERIFIER_TESTS_H)
+$(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
+$(OUTPUT)/test_verifier: test_verifier.c $(VERIFIER_TESTS_H)
+$(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
 	$(shell ( cd verifier/; \
 		  echo '/* Generated header, do not edit */'; \
 		  echo '#ifdef FILL_ARRAY'; \
-- 
2.17.1

