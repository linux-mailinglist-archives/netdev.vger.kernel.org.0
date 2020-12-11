Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256EF2D6DEA
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391696AbgLKCBO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Dec 2020 21:01:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56576 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395027AbgLKCAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 21:00:40 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BB1oAkM000677
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:59:59 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35b68sgwbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:59:59 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 17:59:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7C7132ECB180; Thu, 10 Dec 2020 17:59:48 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next] selftests/bpf: fix bpf_testmod.ko recompilation logic
Date:   Thu, 10 Dec 2020 17:59:46 -0800
Message-ID: <20201211015946.4062098-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_11:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 suspectscore=9 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_testmod.ko build rule declared dependency on VMLINUX_BTF, but the variable
itself was initialized after the rule was declared, which often caused
bpf_testmod.ko to not be re-compiled. Fix by moving VMLINUX_BTF determination
sooner.

Also enforce bpf_testmod.ko recompilation when we detect that vmlinux image
changed by removing bpf_testmod/bpf_testmod.ko. This is necessary to generate
correct module's split BTF. Without it, Kbuild's module build logic might
determine that nothing changed on the kernel side and thus bpf_testmod.ko
shouldn't be rebuilt, so won't re-generate module BTF, which often leads to
module's BTF with wrong string offsets against vmlinux BTF. Removing .ko file
forces Kbuild to re-build the module.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Fixes: 9f7fa225894c ("selftests/bpf: Add bpf_testmod kernel module for testing")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 50b3495d7ddf..8b515a17f44b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -116,6 +116,13 @@ INCLUDE_DIR := $(SCRATCH_DIR)/include
 BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
 RESOLVE_BTFIDS := $(BUILD_DIR)/resolve_btfids/resolve_btfids
 
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     ../../../../vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+
 # Define simple and short `make test_progs`, `make test_sysctl`, etc targets
 # to build individual tests.
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
@@ -140,6 +147,7 @@ $(OUTPUT)/urandom_read: urandom_read.c
 
 $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
 	$(call msg,MOD,,$@)
+	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
 	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
 
@@ -147,13 +155,6 @@ $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
 	$(Q)$(CC) -c $(CFLAGS) -o $@ $<
 
-VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
-		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
-		     ../../../../vmlinux				\
-		     /sys/kernel/btf/vmlinux				\
-		     /boot/vmlinux-$(shell uname -r)
-VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
-
 DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
 
 $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
-- 
2.24.1

