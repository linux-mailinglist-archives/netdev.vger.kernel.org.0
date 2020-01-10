Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C082136681
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 06:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgAJFR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 00:17:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36932 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726655AbgAJFR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 00:17:28 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A5Fm1W027843
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 21:17:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=tzZi3YoTh1Gjv16xJRjcJOlQjkW3q33nmdTz3hwMZDY=;
 b=Hyu6AN7JrAg3cm7mo98P9I4UATJoeFj66wLZtEGmhY9S4K3ZxfvCE6lS5CB2Q5RgQvx4
 87gw/T1HklJuvOu+BrUihGqY8EVXs9sP6SoxieSeQ1aUAUSoOoG3hzmOhLJDro3yZamc
 aDXIBz9gUUMvQ0+WILwdKf3+rIS7nmNzJrU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xe2exw61y-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 21:17:27 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 9 Jan 2020 21:17:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1EF792EC158B; Thu,  9 Jan 2020 21:17:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] selftests/bpf: ensure bpf_helper_defs.h are taken from selftests dir
Date:   Thu, 9 Jan 2020 21:17:15 -0800
Message-ID: <20200110051716.1591485-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110051716.1591485-1-andriin@fb.com>
References: <20200110051716.1591485-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=8 malwarescore=0
 priorityscore=1501 mlxlogscore=727 mlxscore=0 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001100045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder includes search path to ensure $(OUTPUT) and $(CURDIR) go before
libbpf's directory. Also fix bpf_helpers.h to include bpf_helper_defs.h in
such a way as to leverage includes search path. This allows selftests to not
use libbpf's local and potentially stale bpf_helper_defs.h. It's important
because selftests/bpf's Makefile only re-generates bpf_helper_defs.h in
seltests' output directory, not the one in libbpf's directory.

Also force regeneration of bpf_helper_defs.h when libbpf.a is updated to
reduce staleness.

Fixes: fa633a0f8919 ("libbpf: Fix build on read-only filesystems")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_helpers.h          |  2 +-
 tools/testing/selftests/bpf/Makefile | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index f69cc208778a..050bb7bf5be6 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -2,7 +2,7 @@
 #ifndef __BPF_HELPERS__
 #define __BPF_HELPERS__
 
-#include "bpf_helper_defs.h"
+#include <bpf_helper_defs.h>
 
 #define __uint(name, val) int (*name)[val]
 #define __type(name, val) typeof(val) *name
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index cb9f18e4b98b..c0a18994db87 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -20,8 +20,8 @@ CLANG		?= clang
 LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
-CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR)	\
-	  -I$(GENDIR) -I$(TOOLSINCDIR) -I$(CURDIR)			\
+CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR) -I$(LIBDIR)  \
+	  -I$(BPFDIR) -I$(GENDIR) -I$(TOOLSINCDIR)			\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
 LDLIBS += -lcap -lelf -lz -lrt -lpthread
@@ -153,7 +153,7 @@ $(BPFOBJ): force
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
 BPF_HELPERS := $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
-$(OUTPUT)/bpf_helper_defs.h:
+$(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
 
 # Get Clang's default includes on this system, as opposed to those seen by
@@ -174,8 +174,8 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
-	     -I. -I./include/uapi -I$(APIDIR)				\
-	     -I$(BPFDIR) -I$(abspath $(OUTPUT)/../usr/include)
+	     -I$(OUTPUT) -I$(CURDIR) -I$(CURDIR)/include/uapi		\
+	     -I$(APIDIR) -I$(BPFDIR) -I$(abspath $(OUTPUT)/../usr/include)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
@@ -329,7 +329,7 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
-TRUNNER_BPF_CFLAGS := -I. -I$(OUTPUT) $(BPF_CFLAGS) $(CLANG_CFLAGS)
+TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS)
 TRUNNER_BPF_LDFLAGS := -mattr=+alu32
 $(eval $(call DEFINE_TEST_RUNNER,test_progs))
 
-- 
2.17.1

