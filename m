Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF9C136682
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 06:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgAJFR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 00:17:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726096AbgAJFR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 00:17:28 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00A5CF1f015571
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 21:17:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=txqmJIqlHsOc36cq5ydkzS2eCkiJYJAMAKiaTvkuyek=;
 b=emR47p3EWrjUWdzKqR2/gMhCQ0lTu2oozHChr81MIVvaEZbM0cHSVzEW8pWSCQHUkHd7
 eG3WPEu8nBj0OSln0hUcbR3EldEbZHcDL8dkL092BWwz7jLVwdCDmJH/G1ryppwWy60L
 5r2qfPOZMtaERB8bB/v4dPNiOyFtaLmNxg4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2xdrhwymkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 21:17:27 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 9 Jan 2020 21:17:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DA6042EC158B; Thu,  9 Jan 2020 21:17:19 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] libbpf,selftests/bpf: fix clean targets
Date:   Thu, 9 Jan 2020 21:17:14 -0800
Message-ID: <20200110051716.1591485-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110051716.1591485-1-andriin@fb.com>
References: <20200110051716.1591485-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=895 malwarescore=0 adultscore=0 suspectscore=9
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf's clean target should clean out generated files in $(OUTPUT) directory
and not make assumption that $(OUTPUT) directory is current working directory.

Selftest's Makefile should delegate cleaning of libbpf-generated files to
libbpf's Makefile. This ensures more robust clean up.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Makefile               | 9 +++++----
 tools/testing/selftests/bpf/Makefile | 5 +++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index d87830e7ea63..db2afccde757 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -273,10 +273,11 @@ config-clean:
 	$(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
 
 clean:
-	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(CMD_TARGETS) \
-		*.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
-		*.pc LIBBPF-CFLAGS $(BPF_HELPER_DEFS) \
-		$(SHARED_OBJDIR) $(STATIC_OBJDIR)
+	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(CMD_TARGETS)		     \
+		*~ .*.d .*.cmd LIBBPF-CFLAGS $(BPF_HELPER_DEFS)		     \
+		$(SHARED_OBJDIR) $(STATIC_OBJDIR)			     \
+		$(addprefix $(OUTPUT),					     \
+			    *.o *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) *.pc)
 	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
 
 
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f1f949cd8ed9..cb9f18e4b98b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -93,6 +93,7 @@ OVERRIDE_TARGETS := 1
 override define CLEAN
 	$(call msg,    CLEAN)
 	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
+	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ clean
 endef
 
 include ../lib.mk
@@ -377,5 +378,5 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
-	feature $(OUTPUT)/*.o $(OUTPUT)/no_alu32 $(OUTPUT)/bpf_gcc	\
-	tools *.skel.h
+	feature								\
+	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc tools)
-- 
2.17.1

