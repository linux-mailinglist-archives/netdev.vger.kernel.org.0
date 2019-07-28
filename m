Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B037477D78
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 05:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfG1DZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 23:25:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8664 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbfG1DZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 23:25:42 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6S3PHuZ003702
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 20:25:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Ro1atBOQn0FoflswE2CRQID1FbEPRYZgHIZRtk7tSxE=;
 b=LH1fhSecnYmaHHK2Dg+snv3pZIjsx0SjSOdELLyAR8tGFlc0TcGpGflxPOwst1t8qJAZ
 2nCnRvFQfkYbDYWa13vkN8A9quwyxhcvGZmIWDaTWJe7K1FGw3nlHh0QyKoIK+dG6hMy
 moULaSzDirAybG6aVWYn9U/wShTTIQyU9II= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0hx2tbtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 20:25:41 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 27 Jul 2019 20:25:40 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 91F0F8615B1; Sat, 27 Jul 2019 20:25:38 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 1/9] selftests/bpf: prevent headers to be compiled as C code
Date:   Sat, 27 Jul 2019 20:25:23 -0700
Message-ID: <20190728032531.2358749-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190728032531.2358749-1-andriin@fb.com>
References: <20190728032531.2358749-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-28_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907280042
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

