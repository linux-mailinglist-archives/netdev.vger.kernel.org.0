Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10430E41F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhBCUfe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Feb 2021 15:35:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232051AbhBCUfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:35:33 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 113KX2an026668
        for <netdev@vger.kernel.org>; Wed, 3 Feb 2021 12:34:52 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 36f3ej26mb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 12:34:52 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 12:34:50 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id ECC4F2ECF298; Wed,  3 Feb 2021 12:34:46 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH bpf-next] libbpf: stop using feature-detection Makefiles
Date:   Wed, 3 Feb 2021 12:34:45 -0800
Message-ID: <20210203203445.3356114-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_08:2021-02-03,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf's Makefile relies on Linux tools infrastructure's feature detection
framework, but libbpf's needs are very modest: it detects the presence of
libelf and libz, both of which are mandatory. So it doesn't benefit much from
the framework, but pays significant costs in terms of maintainability and
debugging experience, when something goes wrong. The other feature detector,
testing for the presernce of minimal BPF API in system headers is long
obsolete as well, providing no value.

So stop using feature detection and just assume the presence of libelf and
libz during build time. Worst case, user will get a clear and actionable
linker error, e.g.:

  /usr/bin/ld: cannot find -lelf

On the other hand, we completely bypass recurring issues various users
reported over time with false negatives of feature detection (libelf or libz
not being detected, while they are actually present in the system).

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/.gitignore |  1 -
 tools/lib/bpf/Makefile   | 47 ++++------------------------------------
 2 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
index 8a81b3679d2b..5d4cfac671d5 100644
--- a/tools/lib/bpf/.gitignore
+++ b/tools/lib/bpf/.gitignore
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 libbpf_version.h
 libbpf.pc
-FEATURE-DUMP.libbpf
 libbpf.so.*
 TAGS
 tags
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 55bd78b3496f..887a494ad5fc 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -58,28 +58,7 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
-FEATURE_USER = .libbpf
-FEATURE_TESTS = libelf zlib bpf
-FEATURE_DISPLAY = libelf zlib bpf
-
 INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi
-FEATURE_CHECK_CFLAGS-bpf = $(INCLUDES)
-
-check_feat := 1
-NON_CHECK_FEAT_TARGETS := clean TAGS tags cscope help
-ifdef MAKECMDGOALS
-ifeq ($(filter-out $(NON_CHECK_FEAT_TARGETS),$(MAKECMDGOALS)),)
-  check_feat := 0
-endif
-endif
-
-ifeq ($(check_feat),1)
-ifeq ($(FEATURES_DUMP),)
-include $(srctree)/tools/build/Makefile.feature
-else
-include $(FEATURES_DUMP)
-endif
-endif
 
 export prefix libdir src obj
 
@@ -157,7 +136,7 @@ all: fixdep
 
 all_cmd: $(CMD_TARGETS) check
 
-$(BPF_IN_SHARED): force elfdep zdep bpfdep $(BPF_HELPER_DEFS)
+$(BPF_IN_SHARED): force $(BPF_HELPER_DEFS)
 	@(test -f ../../include/uapi/linux/bpf.h -a -f ../../../include/uapi/linux/bpf.h && ( \
 	(diff -B ../../include/uapi/linux/bpf.h ../../../include/uapi/linux/bpf.h >/dev/null) || \
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'" >&2 )) || true
@@ -175,7 +154,7 @@ $(BPF_IN_SHARED): force elfdep zdep bpfdep $(BPF_HELPER_DEFS)
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(SHARED_OBJDIR) CFLAGS="$(CFLAGS) $(SHLIB_FLAGS)"
 
-$(BPF_IN_STATIC): force elfdep zdep bpfdep $(BPF_HELPER_DEFS)
+$(BPF_IN_STATIC): force $(BPF_HELPER_DEFS)
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
 
 $(BPF_HELPER_DEFS): $(srctree)/tools/include/uapi/linux/bpf.h
@@ -264,34 +243,16 @@ install_pkgconfig: $(PC_FILE)
 
 install: install_lib install_pkgconfig install_headers
 
-### Cleaning rules
-
-config-clean:
-	$(call QUIET_CLEAN, feature-detect)
-	$(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
-
-clean: config-clean
+clean:
 	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(CMD_TARGETS)		     \
 		*~ .*.d .*.cmd LIBBPF-CFLAGS $(BPF_HELPER_DEFS)		     \
 		$(SHARED_OBJDIR) $(STATIC_OBJDIR)			     \
 		$(addprefix $(OUTPUT),					     \
 			    *.o *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) *.pc)
-	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
-
-
 
-PHONY += force elfdep zdep bpfdep cscope tags
+PHONY += force cscope tags
 force:
 
-elfdep:
-	@if [ "$(feature-libelf)" != "1" ]; then echo "No libelf found"; exit 1 ; fi
-
-zdep:
-	@if [ "$(feature-zlib)" != "1" ]; then echo "No zlib found"; exit 1 ; fi
-
-bpfdep:
-	@if [ "$(feature-bpf)" != "1" ]; then echo "BPF API too old"; exit 1 ; fi
-
 cscope:
 	ls *.c *.h > cscope.files
 	cscope -b -q -I $(srctree)/include -f cscope.out
-- 
2.24.1

