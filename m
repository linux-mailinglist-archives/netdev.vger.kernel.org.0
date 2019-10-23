Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268D9E1F5E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406693AbfJWPb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:31:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392472AbfJWPb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:31:57 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9NFVcse030599
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:31:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=3gSEhCIBvjjkZbkrS5bUTT6nMURqZ9/bsxeKNWAC/h0=;
 b=SprUEobVJPrfMfVyPq5u54XXmVgDrNG3kM255VPJr4Lmnu99SvP6swVUc1Uq1FrB7AZa
 Oq+PqlbBJcgmBfTTLLSeUWUZVgtvEGE+Ni3XuhlP4UUZD/A63+qeh0eUg6H1x2p0mTTj
 wrrcN8gxUX58Lps50vMo+mT27m0bICVqyJA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9td3v0y-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:31:55 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 23 Oct 2019 08:31:43 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A62458619EE; Wed, 23 Oct 2019 08:31:41 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] selftests/bpf: fix LDLIBS order
Date:   Wed, 23 Oct 2019 08:31:28 -0700
Message-ID: <20191023153128.3486140-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_04:2019-10-23,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=8
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910230154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Order of $(LDLIBS) matters to linker, so put it after all the .o and .a
files.

Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 11ff34e7311b..ca40655edde7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -231,14 +231,14 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_EXTRA_HDRS)				\
 		      $(TRUNNER_BPF_OBJS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
-	cd $$(@D) && $$(CC) $$(CFLAGS) $$(LDLIBS) -c $(CURDIR)/$$< -o $$(@F)
+	cd $$(@D) && $$(CC) $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       %.c						\
 		       $(TRUNNER_EXTRA_HDRS)				\
 		       $(TRUNNER_TESTS_HDR)				\
 		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
-	$$(CC) $$(CFLAGS) $$(LDLIBS) -c $$< -o $$@
+	$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
 
 $(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
 ifneq ($2,)
@@ -249,7 +249,7 @@ endif
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     | $(TRUNNER_BINARY)-extras
-	$$(CC) $$(CFLAGS) $$(LDLIBS) $$(filter %.a %.o,$$^) -o $$@
+	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
 
 endef
 
@@ -303,7 +303,7 @@ verifier/tests.h: verifier/*.c
 		  echo '#endif' \
 		) > verifier/tests.h)
 $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
-	$(CC) $(CFLAGS) $(LDLIBS) $(filter %.a %.o %.c,$^) -o $@
+	$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
-- 
2.17.1

