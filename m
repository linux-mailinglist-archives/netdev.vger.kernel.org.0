Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD16590A
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfGKOal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:30:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728904AbfGKOal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 10:30:41 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BESuO1001796
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:30:41 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp5a15cu6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:30:40 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 11 Jul 2019 15:30:38 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 15:30:34 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BEUXRJ43909374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:30:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE9454203F;
        Thu, 11 Jul 2019 14:30:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A41D242045;
        Thu, 11 Jul 2019 14:30:32 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 14:30:32 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ys114321@gmail.com, daniel@iogearbox.net, sdf@fomichev.me,
        davem@davemloft.net, ast@kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 bpf-next 3/4] selftests/bpf: make PT_REGS_* work in userspace
Date:   Thu, 11 Jul 2019 16:29:29 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711142930.68809-1-iii@linux.ibm.com>
References: <20190711142930.68809-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071114-0008-0000-0000-000002FC7509
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071114-0009-0000-0000-00002269DDA1
Message-Id: <20190711142930.68809-4-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, on certain architectures, these macros are usable only with
kernel headers. This patch makes it possible to use them with userspace
headers and, as a consequence, not only in BPF samples, but also in BPF
selftests.

On s390, provide the forward declaration of struct pt_regs and cast it
to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
of the full struct pt_regs, s390 exposes only its first member
user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
(in selftests) and kernel (in samples) headers. It was added in commit
466698e654e8 ("s390/bpf: correct broken uapi for
BPF_PROG_TYPE_PERF_EVENT program type").

Ditto on arm64.

On x86, provide userspace versions of PT_REGS_* macros. Unlike s390 and
arm64, x86 provides struct pt_regs to both userspace and kernel, however,
with different member names.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 75 +++++++++++++++++------
 1 file changed, 55 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 73071a94769a..27090d94afb6 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -358,6 +358,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 
 #if defined(bpf_target_x86)
 
+#ifdef __KERNEL__
 #define PT_REGS_PARM1(x) ((x)->di)
 #define PT_REGS_PARM2(x) ((x)->si)
 #define PT_REGS_PARM3(x) ((x)->dx)
@@ -368,19 +369,49 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 #define PT_REGS_RC(x) ((x)->ax)
 #define PT_REGS_SP(x) ((x)->sp)
 #define PT_REGS_IP(x) ((x)->ip)
+#else
+#ifdef __i386__
+/* i386 kernel is built with -mregparm=3 */
+#define PT_REGS_PARM1(x) ((x)->eax)
+#define PT_REGS_PARM2(x) ((x)->edx)
+#define PT_REGS_PARM3(x) ((x)->ecx)
+#define PT_REGS_PARM4(x) 0
+#define PT_REGS_PARM5(x) 0
+#define PT_REGS_RET(x) ((x)->esp)
+#define PT_REGS_FP(x) ((x)->ebp)
+#define PT_REGS_RC(x) ((x)->eax)
+#define PT_REGS_SP(x) ((x)->esp)
+#define PT_REGS_IP(x) ((x)->eip)
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
+#endif
 
 #elif defined(bpf_target_s390)
 
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
+#define PT_REGS_S390 const volatile user_pt_regs
+#define PT_REGS_PARM1(x) (((PT_REGS_S390 *)(x))->gprs[2])
+#define PT_REGS_PARM2(x) (((PT_REGS_S390 *)(x))->gprs[3])
+#define PT_REGS_PARM3(x) (((PT_REGS_S390 *)(x))->gprs[4])
+#define PT_REGS_PARM4(x) (((PT_REGS_S390 *)(x))->gprs[5])
+#define PT_REGS_PARM5(x) (((PT_REGS_S390 *)(x))->gprs[6])
+#define PT_REGS_RET(x) (((PT_REGS_S390 *)(x))->gprs[14])
+/* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_FP(x) (((PT_REGS_S390 *)(x))->gprs[11])
+#define PT_REGS_RC(x) (((PT_REGS_S390 *)(x))->gprs[2])
+#define PT_REGS_SP(x) (((PT_REGS_S390 *)(x))->gprs[15])
+#define PT_REGS_IP(x) (((PT_REGS_S390 *)(x))->psw.addr)
 
 #elif defined(bpf_target_arm)
 
@@ -397,16 +428,20 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 
 #elif defined(bpf_target_arm64)
 
-#define PT_REGS_PARM1(x) ((x)->regs[0])
-#define PT_REGS_PARM2(x) ((x)->regs[1])
-#define PT_REGS_PARM3(x) ((x)->regs[2])
-#define PT_REGS_PARM4(x) ((x)->regs[3])
-#define PT_REGS_PARM5(x) ((x)->regs[4])
-#define PT_REGS_RET(x) ((x)->regs[30])
-#define PT_REGS_FP(x) ((x)->regs[29]) /* Works only with CONFIG_FRAME_POINTER */
-#define PT_REGS_RC(x) ((x)->regs[0])
-#define PT_REGS_SP(x) ((x)->sp)
-#define PT_REGS_IP(x) ((x)->pc)
+/* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
+struct pt_regs;
+#define PT_REGS_ARM64 const volatile struct user_pt_regs
+#define PT_REGS_PARM1(x) (((PT_REGS_ARM64 *)(x))->regs[0])
+#define PT_REGS_PARM2(x) (((PT_REGS_ARM64 *)(x))->regs[1])
+#define PT_REGS_PARM3(x) (((PT_REGS_ARM64 *)(x))->regs[2])
+#define PT_REGS_PARM4(x) (((PT_REGS_ARM64 *)(x))->regs[3])
+#define PT_REGS_PARM5(x) (((PT_REGS_ARM64 *)(x))->regs[4])
+#define PT_REGS_RET(x) (((PT_REGS_ARM64 *)(x))->regs[30])
+/* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_FP(x) (((PT_REGS_ARM64 *)(x))->regs[29])
+#define PT_REGS_RC(x) (((PT_REGS_ARM64 *)(x))->regs[0])
+#define PT_REGS_SP(x) (((PT_REGS_ARM64 *)(x))->sp)
+#define PT_REGS_IP(x) (((PT_REGS_ARM64 *)(x))->pc)
 
 #elif defined(bpf_target_mips)
 
-- 
2.21.0

