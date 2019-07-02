Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830195D30F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfGBPjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:39:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfGBPjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:39:24 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62Fc0N0012747
        for <netdev@vger.kernel.org>; Tue, 2 Jul 2019 11:39:23 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tg6phh6tm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 11:39:22 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 2 Jul 2019 16:39:20 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 2 Jul 2019 16:39:19 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62Fd78Q38404482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 15:39:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7EFAA4055;
        Tue,  2 Jul 2019 15:39:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0D48A4053;
        Tue,  2 Jul 2019 15:39:17 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.98])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 15:39:17 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf-next] selftests/bpf: fix compiling loop{1,2,3}.c on s390
Date:   Tue,  2 Jul 2019 17:39:08 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070215-0008-0000-0000-000002F92A8B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070215-0009-0000-0000-0000226674A5
Message-Id: <20190702153908.41562-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=799 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.

Pass -D__TARGET_ARCH_$(ARCH) to selftests in order to choose a proper
PT_REGS_RC variant.

Fix s930 -> s390 typo.

On s390, provide the forward declaration of struct pt_regs and cast it
to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
of the full struct pt_regs, s390 exposes only its first field
user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
(in selftests) and kernel (in samples) headers.

On x86, provide userspace versions of PT_REGS_* macros. Unlike s390, x86
provides struct pt_regs to both userspace and kernel, however, with
different field names.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/Makefile      |  4 +-
 tools/testing/selftests/bpf/bpf_helpers.h | 46 +++++++++++++++--------
 tools/testing/selftests/bpf/progs/loop1.c |  2 +-
 tools/testing/selftests/bpf/progs/loop2.c |  2 +-
 tools/testing/selftests/bpf/progs/loop3.c |  2 +-
 5 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index d60fee59fbd1..599b320bef65 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 include ../../../../scripts/Kbuild.include
+include ../../../scripts/Makefile.arch
 
 LIBDIR := ../../../lib
 BPFDIR := $(LIBDIR)/bpf
@@ -138,7 +139,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
 
 CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
 	      $(CLANG_SYS_INCLUDES) \
-	      -Wno-compare-distinct-pointer-types
+	      -Wno-compare-distinct-pointer-types \
+	      -D__TARGET_ARCH_$(ARCH)
 
 $(OUTPUT)/test_l4lb_noinline.o: CLANG_FLAGS += -fno-inline
 $(OUTPUT)/test_xdp_noinline.o: CLANG_FLAGS += -fno-inline
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 1a5b1accf091..faf86d83301a 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -312,8 +312,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 #if defined(__TARGET_ARCH_x86)
 	#define bpf_target_x86
 	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_s930x)
-	#define bpf_target_s930x
+#elif defined(__TARGET_ARCH_s390)
+	#define bpf_target_s390
 	#define bpf_target_defined
 #elif defined(__TARGET_ARCH_arm)
 	#define bpf_target_arm
@@ -338,8 +338,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 #ifndef bpf_target_defined
 #if defined(__x86_64__)
 	#define bpf_target_x86
-#elif defined(__s390x__)
-	#define bpf_target_s930x
+#elif defined(__s390__)
+	#define bpf_target_s390
 #elif defined(__arm__)
 	#define bpf_target_arm
 #elif defined(__aarch64__)
@@ -355,6 +355,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 
 #if defined(bpf_target_x86)
 
+#ifdef __KERNEL__
 #define PT_REGS_PARM1(x) ((x)->di)
 #define PT_REGS_PARM2(x) ((x)->si)
 #define PT_REGS_PARM3(x) ((x)->dx)
@@ -365,19 +366,34 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 #define PT_REGS_RC(x) ((x)->ax)
 #define PT_REGS_SP(x) ((x)->sp)
 #define PT_REGS_IP(x) ((x)->ip)
+#else
+#define PT_REGS_PARM1(x) ((x)->rdi)
+#define PT_REGS_PARM2(x) ((x)->rsi)
+#define PT_REGS_PARM3(x) ((x)->rdx)
+#define PT_REGS_PARM4(x) ((x)->rcx)
+#define PT_REGS_PARM5(x) ((x)->r8)
+#define PT_REGS_RET(x) ((x)->rsp)
+#define PT_REGS_FP(x) ((x)->rbp)
+#define PT_REGS_RC(x) ((x)->rax)
+#define PT_REGS_SP(x) ((x)->rsp)
+#define PT_REGS_IP(x) ((x)->rip)
+#endif
 
-#elif defined(bpf_target_s390x)
+#elif defined(bpf_target_s390)
 
-#define PT_REGS_PARM1(x) ((x)->gprs[2])
-#define PT_REGS_PARM2(x) ((x)->gprs[3])
-#define PT_REGS_PARM3(x) ((x)->gprs[4])
-#define PT_REGS_PARM4(x) ((x)->gprs[5])
-#define PT_REGS_PARM5(x) ((x)->gprs[6])
-#define PT_REGS_RET(x) ((x)->gprs[14])
-#define PT_REGS_FP(x) ((x)->gprs[11]) /* Works only with CONFIG_FRAME_POINTER */
-#define PT_REGS_RC(x) ((x)->gprs[2])
-#define PT_REGS_SP(x) ((x)->gprs[15])
-#define PT_REGS_IP(x) ((x)->psw.addr)
+/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
+struct pt_regs;
+#define PT_REGS_PARM1(x) (((const volatile user_pt_regs *)(x))->gprs[2])
+#define PT_REGS_PARM2(x) (((const volatile user_pt_regs *)(x))->gprs[3])
+#define PT_REGS_PARM3(x) (((const volatile user_pt_regs *)(x))->gprs[4])
+#define PT_REGS_PARM4(x) (((const volatile user_pt_regs *)(x))->gprs[5])
+#define PT_REGS_PARM5(x) (((const volatile user_pt_regs *)(x))->gprs[6])
+#define PT_REGS_RET(x) (((const volatile user_pt_regs *)(x))->gprs[14])
+/* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_FP(x) (((const volatile user_pt_regs *)(x))->gprs[11])
+#define PT_REGS_RC(x) (((const volatile user_pt_regs *)(x))->gprs[2])
+#define PT_REGS_SP(x) (((const volatile user_pt_regs *)(x))->gprs[15])
+#define PT_REGS_IP(x) (((const volatile user_pt_regs *)(x))->psw.addr)
 
 #elif defined(bpf_target_arm)
 
diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
index dea395af9ea9..7cdb7f878310 100644
--- a/tools/testing/selftests/bpf/progs/loop1.c
+++ b/tools/testing/selftests/bpf/progs/loop1.c
@@ -18,7 +18,7 @@ int nested_loops(volatile struct pt_regs* ctx)
 	for (j = 0; j < 300; j++)
 		for (i = 0; i < j; i++) {
 			if (j & 1)
-				m = ctx->rax;
+				m = PT_REGS_RC(ctx);
 			else
 				m = j;
 			sum += i * m;
diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
index 0637bd8e8bcf..9b2f808a2863 100644
--- a/tools/testing/selftests/bpf/progs/loop2.c
+++ b/tools/testing/selftests/bpf/progs/loop2.c
@@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
 	int i = 0;
 
 	while (true) {
-		if (ctx->rax & 1)
+		if (PT_REGS_RC(ctx) & 1)
 			i += 3;
 		else
 			i += 7;
diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
index 30a0f6cba080..d727657d51e2 100644
--- a/tools/testing/selftests/bpf/progs/loop3.c
+++ b/tools/testing/selftests/bpf/progs/loop3.c
@@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
 	__u64 i = 0, sum = 0;
 	do {
 		i++;
-		sum += ctx->rax;
+		sum += PT_REGS_RC(ctx);
 	} while (i < 0x100000000ULL);
 	return sum;
 }
-- 
2.21.0

