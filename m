Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95EEA77B58
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 21:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbfG0TCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 15:02:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388161AbfG0TCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 15:02:05 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RIxv6q008446
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Ro1atBOQn0FoflswE2CRQID1FbEPRYZgHIZRtk7tSxE=;
 b=lEFIey7PbJW7eHpK70BV7mUVwi/Q/H9xh+BO1TAR8woixHRlf+p2uiAmIgW7TkfN5gPA
 ianLTFocVldRrzK6bvShiHP/3hlhVDhTQdUyXY4mYQ2ajDU8t7NWX4sxr1WnAJIwIv8/
 7Fsc3T0vIKcFvJxwiVhpTvpXm0WNg1vq4EY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0jn3hbtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:04 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 27 Jul 2019 12:01:56 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C4402861672; Sat, 27 Jul 2019 12:01:55 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 1/9] selftests/bpf: prevent headers to be compiled as C code
Date:   Sat, 27 Jul 2019 12:01:42 -0700
Message-ID: <20190727190150.649137-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190727190150.649137-1-andriin@fb.com>
References: <20190727190150.649137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270238
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apprently listing header as a normal dependency for a binary output
makes it go through compilation as if it was C code. This currently
works without a problem, but in subsequent commits causes problems for
differently generated test.h for test_progs. Marking those headers as
order-only dependency solves the issue.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 11c9c62c3362..bb66cc4a7f34 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -235,7 +235,7 @@ PROG_TESTS_H := $(PROG_TESTS_DIR)/tests.h
 PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
 test_progs.c: $(PROG_TESTS_H)
 $(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
-$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_H) $(PROG_TESTS_FILES)
+$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(PROG_TESTS_H)
 $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
 	$(shell ( cd prog_tests/; \
 		  echo '/* Generated header, do not edit */'; \
@@ -256,7 +256,7 @@ MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
 MAP_TESTS_FILES := $(wildcard map_tests/*.c)
 test_maps.c: $(MAP_TESTS_H)
 $(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
-$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_H) $(MAP_TESTS_FILES)
+$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_FILES) | $(MAP_TESTS_H)
 $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
 	$(shell ( cd map_tests/; \
 		  echo '/* Generated header, do not edit */'; \
@@ -277,7 +277,7 @@ VERIFIER_TESTS_H := $(VERIFIER_TESTS_DIR)/tests.h
 VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
 test_verifier.c: $(VERIFIER_TESTS_H)
 $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
-$(OUTPUT)/test_verifier: test_verifier.c $(VERIFIER_TESTS_H)
+$(OUTPUT)/test_verifier: test_verifier.c | $(VERIFIER_TEST_FILES) $(VERIFIER_TESTS_H)
 $(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
 	$(shell ( cd verifier/; \
 		  echo '/* Generated header, do not edit */'; \
-- 
2.17.1

