Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3FACEDCC
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfJGUmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:42:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18288 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729461AbfJGUmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 16:42:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x97KbV84017400
        for <netdev@vger.kernel.org>; Mon, 7 Oct 2019 13:42:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=PlT+a3sf9wJ+tzBWqAKg0k0RAKfw0mhwC7ijrJMosGg=;
 b=TUanhm+GCujz81/Us8kGI0NwTjQTanUDSkJZ4Vl0K59J4/g+bi7uP7bZIllvXNbNq37c
 3/arl2K88GImd/PyWoeot981QUdIyV4FAqERLS3zm0M2GsqLQ0pDhV43/v8H5WHZwyM0
 mspdDWPSN2AALIUsGj8U05OrsxYicxqFZm0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2vepunt60n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 13:42:08 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 13:41:52 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CEF5D8618F1; Mon,  7 Oct 2019 13:41:50 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next] selftests/bpf: fix dependency ordering for attach_probe test
Date:   Mon, 7 Oct 2019 13:41:49 -0700
Message-ID: <20191007204149.1575990-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_03:2019-10-07,2019-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=8 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910070181
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current Makefile dependency chain is not strict enough and allows
test_attach_probe.o to be built before test_progs's
prog_test/attach_probe.o is built, which leads to assembler complaining
about missing included binary.

This patch is a minimal fix to fix this issue by enforcing that
test_attach_probe.o (BPF object file) is built before
prog_tests/attach_probe.c is attempted to be compiled.

Fixes: 928ca75e59d7 ("selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b59fb4e8afaf..771a4e82128b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -164,7 +164,7 @@ $(OUTPUT)/test_queue_map.o: test_queue_stack_map.h
 $(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
 
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
-$(OUTPUT)/test_progs.o: flow_dissector_load.h $(OUTPUT)/test_attach_probe.o
+$(OUTPUT)/test_progs.o: flow_dissector_load.h
 
 BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
 BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
@@ -275,7 +275,7 @@ PROG_TESTS_H := $(PROG_TESTS_DIR)/tests.h
 PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
 test_progs.c: $(PROG_TESTS_H)
 $(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
-$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(PROG_TESTS_H)
+$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(OUTPUT)/test_attach_probe.o $(PROG_TESTS_H)
 $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
 	$(shell ( cd prog_tests/; \
 		  echo '/* Generated header, do not edit */'; \
-- 
2.17.1

