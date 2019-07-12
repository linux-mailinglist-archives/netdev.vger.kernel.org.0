Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28407670AD
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfGLN4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:56:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726945AbfGLN4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:56:45 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CDpVmd130769
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 09:56:44 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpu7w0vvf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 09:56:43 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 12 Jul 2019 14:56:41 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 14:56:39 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CDubMJ47710400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:56:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1D314C04E;
        Fri, 12 Jul 2019 13:56:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70D8B4C044;
        Fri, 12 Jul 2019 13:56:37 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 13:56:37 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf] selftests/bpf: make directory prerequisites order-only
Date:   Fri, 12 Jul 2019 15:56:31 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071213-0028-0000-0000-00000383C033
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071213-0029-0000-0000-00002443D86B
Message-Id: <20190712135631.91398-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When directories are used as prerequisites in Makefiles, they can cause
a lot of unnecessary rebuilds, because a directory is considered changed
whenever a file in this directory is added, removed or modified.

If the only thing a target is interested in is the existence of the
directory it depends on, which is the case for selftests/bpf, this
directory should be specified as an order-only prerequisite: it would
still be created in case it does not exist, but it would not trigger a
rebuild of a target in case it's considered changed.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/Makefile | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 277d8605e340..0e003fb6641b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -183,12 +183,12 @@ TEST_CUSTOM_PROGS += $(ALU32_BUILD_DIR)/test_progs_32
 $(ALU32_BUILD_DIR):
 	mkdir -p $@
 
-$(ALU32_BUILD_DIR)/urandom_read: $(OUTPUT)/urandom_read
+$(ALU32_BUILD_DIR)/urandom_read: $(OUTPUT)/urandom_read | $(ALU32_BUILD_DIR)
 	cp $< $@
 
 $(ALU32_BUILD_DIR)/test_progs_32: test_progs.c $(OUTPUT)/libbpf.a\
-						$(ALU32_BUILD_DIR) \
-						$(ALU32_BUILD_DIR)/urandom_read
+						$(ALU32_BUILD_DIR)/urandom_read \
+						| $(ALU32_BUILD_DIR)
 	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) \
 		-o $(ALU32_BUILD_DIR)/test_progs_32 \
 		test_progs.c test_stub.c trace_helpers.c prog_tests/*.c \
@@ -197,8 +197,8 @@ $(ALU32_BUILD_DIR)/test_progs_32: test_progs.c $(OUTPUT)/libbpf.a\
 $(ALU32_BUILD_DIR)/test_progs_32: $(PROG_TESTS_H)
 $(ALU32_BUILD_DIR)/test_progs_32: prog_tests/*.c
 
-$(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR) \
-					$(ALU32_BUILD_DIR)/test_progs_32
+$(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR)/test_progs_32 \
+					| $(ALU32_BUILD_DIR)
 	($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm -c $< -o - || \
 		echo "clang failed") | \
 	$(LLC) -march=bpf -mattr=+alu32 -mcpu=$(CPU) $(LLC_FLAGS) \
@@ -236,7 +236,7 @@ $(PROG_TESTS_DIR):
 	mkdir -p $@
 
 PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
-$(PROG_TESTS_H): $(PROG_TESTS_DIR) $(PROG_TESTS_FILES)
+$(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
 	$(shell ( cd prog_tests/; \
 		  echo '/* Generated header, do not edit */'; \
 		  echo '#ifdef DECLARE'; \
@@ -257,7 +257,7 @@ MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
 test_maps.c: $(MAP_TESTS_H)
 $(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
 MAP_TESTS_FILES := $(wildcard map_tests/*.c)
-$(MAP_TESTS_H): $(MAP_TESTS_DIR) $(MAP_TESTS_FILES)
+$(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
 	$(shell ( cd map_tests/; \
 		  echo '/* Generated header, do not edit */'; \
 		  echo '#ifdef DECLARE'; \
@@ -279,7 +279,7 @@ $(VERIFIER_TESTS_DIR):
 	mkdir -p $@
 
 VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
-$(OUTPUT)/verifier/tests.h: $(VERIFIER_TESTS_DIR) $(VERIFIER_TEST_FILES)
+$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
 	$(shell ( cd verifier/; \
 		  echo '/* Generated header, do not edit */'; \
 		  echo '#ifdef FILL_ARRAY'; \
-- 
2.21.0

