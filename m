Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B0FD37C6
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfJKDNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:13:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27840 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbfJKDNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:13:32 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9B3944a017796
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:13:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=DxctI/0Q2o5+fHOxePTwhBmGqAEpYoTdWSsh0qjKcwM=;
 b=GYg8Kt7odPG6/bmeVhZAEOqOScI0+P+Dbiy1hpYEf/QrGCSJVfofal+yPUjCDIga/2d8
 yB2ZNwIS/vYEooM7cKUrDxj/uTt+IN+pyUCPhjN7TTNZ6msOGKaIUnIyEV0HuJbJ5Ewx
 EP+nKRSILbBd+ehJpGeiwQ1EXLE3/Rnw6Io= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vjekprr5t-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:13:31 -0700
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 10 Oct 2019 20:13:29 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B2287861907; Thu, 10 Oct 2019 20:13:28 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/2] selftests/bpf: remove obsolete pahole/BTF support detection
Date:   Thu, 10 Oct 2019 20:13:18 -0700
Message-ID: <20191011031318.388493-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011031318.388493-1-andriin@fb.com>
References: <20191011031318.388493-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_01:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 spamscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given lots of selftests won't work without recent enough Clang/LLVM that
fully supports BTF, there is no point in maintaining outdated BTF
support detection and fall-back to pahole logic. Just assume we have
everything we need.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 44 ++++------------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f958643d36da..d1770da2da70 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -15,8 +15,6 @@ endif
 CLANG		?= clang
 LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
-LLVM_READELF	?= llvm-readelf
-BTF_PAHOLE	?= pahole
 BPF_GCC		?= $(shell command -v bpf-gcc;)
 CFLAGS += -g -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include \
 	  -Dbpf_prog_load=bpf_prog_test_load \
@@ -147,8 +145,9 @@ $(shell $(1) -v -E - </dev/null 2>&1 \
 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
 endef
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
-BPF_CFLAGS = -I. -I./include/uapi -I../../../include/uapi \
-	     -I$(BPFDIR) -I$(OUTPUT)/../usr/include -D__TARGET_ARCH_$(SRCARCH)
+BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) 				\
+	     -I. -I./include/uapi -I../../../include/uapi 		\
+	     -I$(BPFDIR) -I$(OUTPUT)/../usr/include
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
@@ -162,28 +161,6 @@ $(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 $(OUTPUT)/test_progs.o: flow_dissector_load.h
 
-BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
-BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
-BTF_OBJCOPY_PROBE := $(shell $(LLVM_OBJCOPY) --help 2>&1 | grep -i 'usage.*llvm')
-BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
-			  $(CLANG) -target bpf -O2 -g -c -x c - -o ./llvm_btf_verify.o; \
-			  $(LLVM_READELF) -S ./llvm_btf_verify.o | grep BTF; \
-			  /bin/rm -f ./llvm_btf_verify.o)
-
-ifneq ($(BTF_LLVM_PROBE),)
-	BPF_CFLAGS += -g
-else
-ifneq ($(BTF_LLC_PROBE),)
-ifneq ($(BTF_PAHOLE_PROBE),)
-ifneq ($(BTF_OBJCOPY_PROBE),)
-	BPF_CFLAGS += -g
-	LLC_FLAGS += -mattr=dwarfris
-	DWARF2BTF = y
-endif
-endif
-endif
-endif
-
 TEST_PROGS_CFLAGS := -I. -I$(OUTPUT)
 TEST_MAPS_CFLAGS := -I. -I$(OUTPUT)
 TEST_VERIFIER_CFLAGS := -I. -I$(OUTPUT) -Iverifier
@@ -212,11 +189,8 @@ $(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR)/test_progs_32 \
 					| $(ALU32_BUILD_DIR)
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
 		-c $< -o - || echo "clang failed") | \
-	$(LLC) -march=bpf -mattr=+alu32 -mcpu=$(CPU) $(LLC_FLAGS) \
+	$(LLC) -march=bpf -mcpu=probe -mattr=+alu32 $(LLC_FLAGS) \
 		-filetype=obj -o $@
-ifeq ($(DWARF2BTF),y)
-	$(BTF_PAHOLE) -J $@
-endif
 endif
 
 ifneq ($(BPF_GCC),)
@@ -251,19 +225,13 @@ endif
 $(OUTPUT)/test_xdp.o: progs/test_xdp.c
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -emit-llvm -c $< -o - || \
 		echo "clang failed") | \
-	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
-ifeq ($(DWARF2BTF),y)
-	$(BTF_PAHOLE) -J $@
-endif
+	$(LLC) -march=bpf -mcpu=probe $(LLC_FLAGS) -filetype=obj -o $@
 
 # libbpf has to be built before BPF programs due to bpf_helper_defs.h
 $(OUTPUT)/%.o: progs/%.c | $(BPFOBJ)
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
 		-c $< -o - || echo "clang failed") | \
-	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
-ifeq ($(DWARF2BTF),y)
-	$(BTF_PAHOLE) -J $@
-endif
+	$(LLC) -march=bpf -mcpu=probe $(LLC_FLAGS) -filetype=obj -o $@
 
 PROG_TESTS_DIR = $(OUTPUT)/prog_tests
 $(PROG_TESTS_DIR):
-- 
2.17.1

