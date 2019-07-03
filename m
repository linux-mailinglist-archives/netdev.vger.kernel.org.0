Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8105E578
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGCN2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:28:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726966AbfGCN2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:28:01 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63DRhjt079226
        for <netdev@vger.kernel.org>; Wed, 3 Jul 2019 09:28:00 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tgufuvqjj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 09:27:59 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 3 Jul 2019 14:27:57 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 3 Jul 2019 14:27:55 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x63DRhC337159366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jul 2019 13:27:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 000374C052;
        Wed,  3 Jul 2019 13:27:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD2CF4C040;
        Wed,  3 Jul 2019 13:27:53 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.248])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jul 2019 13:27:53 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com,
        daniel@iogearbox.net
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 bpf-next 3/4] selftests/bpf: make PT_REGS_* work in userspace
Date:   Wed,  3 Jul 2019 15:27:10 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703132711.57169-1-iii@linux.ibm.com>
References: <20190703132711.57169-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070313-0016-0000-0000-0000028ECC48
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070313-0017-0000-0000-000032EC6665
Message-Id: <20190703132711.57169-4-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, at least on s390 and x86_64, these macros are usable only
with kernel headers. This patch makes it possible to use them with
userspace headers and, as a consequence, in BPF selftests.

On s390, provide the forward declaration of struct pt_regs and cast it
to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
of the full struct pt_regs, s390 exposes only its first member
user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
(in selftests) and kernel (in samples) headers. It was added in commit
466698e654e8 ("s390/bpf: correct broken uapi for
BPF_PROG_TYPE_PERF_EVENT program type").

On x86, provide userspace versions of PT_REGS_* macros. Unlike s390, x86
provides struct pt_regs to both userspace and kernel, however, with
different member names.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 36 ++++++++++++++++-------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 622dc4af0c65..faf86d83301a 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
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
 
-- 
2.21.0

