Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E0B184D88
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCMRYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:24:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727002AbgCMRYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:24:02 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DHB9Jq017165
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 10:24:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lmUyisaVt1J1rWbzpuTRIk5temsg1R2Pmq5bSV4gb3c=;
 b=dNiK4n9TrmL5jCUMdBL7DR89/vIcTPp7pGvXv/uQGh87OElsOAY4MLEJvyM+tL8mTGs2
 MWyL6gjVUEEogBT2XrQDXsHjaexXB2w77bE8TGrUK9vnHZv3z9ou51TiIfnHm4Fh4knY
 J0nACBekc11QVUQc+53TAHm+96QwcHZ1pZ8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7t59vw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 10:24:01 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 10:24:00 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2CBCA2EC2DE4; Fri, 13 Mar 2020 10:23:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/4] libbpf: provide CO-RE variants of PT_REGS macros
Date:   Fri, 13 Mar 2020 10:23:35 -0700
Message-ID: <20200313172336.1879637-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313172336.1879637-1-andriin@fb.com>
References: <20200313172336.1879637-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_06:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=8 priorityscore=1501
 phishscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=484
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syscall raw tracepoints have struct pt_regs pointer as tracepoint's first
argument. After that, reading any of pt_regs fields requires bpf_probe_read(),
even for tp_btf programs. Due to that, PT_REGS_PARMx macros are not usable as
is. This patch adds CO-RE variants of those macros that use BPF_CORE_READ() to
read necessary fields. This provides relocatable architecture-agnostic pt_regs
field accesses.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_tracing.h | 103 ++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 379d03b211ea..b0c9ae5c73b5 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -50,6 +50,7 @@
 #if defined(bpf_target_x86)
 
 #if defined(__KERNEL__) || defined(__VMLINUX_H__)
+
 #define PT_REGS_PARM1(x) ((x)->di)
 #define PT_REGS_PARM2(x) ((x)->si)
 #define PT_REGS_PARM3(x) ((x)->dx)
@@ -60,7 +61,20 @@
 #define PT_REGS_RC(x) ((x)->ax)
 #define PT_REGS_SP(x) ((x)->sp)
 #define PT_REGS_IP(x) ((x)->ip)
+
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((x), di)
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((x), si)
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((x), dx)
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((x), cx)
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((x), r8)
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((x), sp)
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((x), bp)
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((x), ax)
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((x), sp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), ip)
+
 #else
+
 #ifdef __i386__
 /* i386 kernel is built with -mregparm=3 */
 #define PT_REGS_PARM1(x) ((x)->eax)
@@ -73,7 +87,20 @@
 #define PT_REGS_RC(x) ((x)->eax)
 #define PT_REGS_SP(x) ((x)->esp)
 #define PT_REGS_IP(x) ((x)->eip)
+
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((x), eax)
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((x), edx)
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((x), ecx)
+#define PT_REGS_PARM4_CORE(x) 0
+#define PT_REGS_PARM5_CORE(x) 0
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((x), esp)
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((x), ebp)
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((x), eax)
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((x), esp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), eip)
+
 #else
+
 #define PT_REGS_PARM1(x) ((x)->rdi)
 #define PT_REGS_PARM2(x) ((x)->rsi)
 #define PT_REGS_PARM3(x) ((x)->rdx)
@@ -84,6 +111,18 @@
 #define PT_REGS_RC(x) ((x)->rax)
 #define PT_REGS_SP(x) ((x)->rsp)
 #define PT_REGS_IP(x) ((x)->rip)
+
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((x), rdi)
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((x), rsi)
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((x), rdx)
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((x), rcx)
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((x), r8)
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((x), rsp)
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((x), rbp)
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((x), rax)
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((x), rsp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), rip)
+
 #endif
 #endif
 
@@ -104,6 +143,17 @@ struct pt_regs;
 #define PT_REGS_SP(x) (((PT_REGS_S390 *)(x))->gprs[15])
 #define PT_REGS_IP(x) (((PT_REGS_S390 *)(x))->psw.addr)
 
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[2])
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[3])
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[4])
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[5])
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[6])
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), grps[14])
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[11])
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[2])
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[15])
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), pdw.addr)
+
 #elif defined(bpf_target_arm)
 
 #define PT_REGS_PARM1(x) ((x)->uregs[0])
@@ -117,6 +167,17 @@ struct pt_regs;
 #define PT_REGS_SP(x) ((x)->uregs[13])
 #define PT_REGS_IP(x) ((x)->uregs[12])
 
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((x), uregs[0])
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((x), uregs[1])
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((x), uregs[2])
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((x), uregs[3])
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((x), uregs[4])
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((x), uregs[14])
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((x), uregs[11])
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((x), uregs[0])
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((x), uregs[13])
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), uregs[12])
+
 #elif defined(bpf_target_arm64)
 
 /* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
@@ -134,6 +195,17 @@ struct pt_regs;
 #define PT_REGS_SP(x) (((PT_REGS_ARM64 *)(x))->sp)
 #define PT_REGS_IP(x) (((PT_REGS_ARM64 *)(x))->pc)
 
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[0])
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[1])
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[2])
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[3])
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[4])
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[30])
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[29])
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), regs[0])
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), sp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_ARM64 *)(x), pc)
+
 #elif defined(bpf_target_mips)
 
 #define PT_REGS_PARM1(x) ((x)->regs[4])
@@ -147,6 +219,17 @@ struct pt_regs;
 #define PT_REGS_SP(x) ((x)->regs[29])
 #define PT_REGS_IP(x) ((x)->cp0_epc)
 
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((x), regs[4])
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((x), regs[5])
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((x), regs[6])
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((x), regs[7])
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((x), regs[8])
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((x), regs[31])
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((x), regs[30])
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((x), regs[1])
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((x), regs[29])
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), cp0_epc)
+
 #elif defined(bpf_target_powerpc)
 
 #define PT_REGS_PARM1(x) ((x)->gpr[3])
@@ -158,6 +241,15 @@ struct pt_regs;
 #define PT_REGS_SP(x) ((x)->sp)
 #define PT_REGS_IP(x) ((x)->nip)
 
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((x), gpr[3])
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((x), gpr[4])
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((x), gpr[5])
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((x), gpr[6])
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((x), gpr[7])
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((x), gpr[3])
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((x), sp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), nip)
+
 #elif defined(bpf_target_sparc)
 
 #define PT_REGS_PARM1(x) ((x)->u_regs[UREG_I0])
@@ -169,11 +261,22 @@ struct pt_regs;
 #define PT_REGS_RC(x) ((x)->u_regs[UREG_I0])
 #define PT_REGS_SP(x) ((x)->u_regs[UREG_FP])
 
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((x), u_regs[UREG_I0])
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((x), u_regs[UREG_I1])
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((x), u_regs[UREG_I2])
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((x), u_regs[UREG_I3])
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((x), u_regs[UREG_I4])
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((x), u_regs[UREG_I7])
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((x), u_regs[UREG_I0])
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((x), u_regs[UREG_FP])
+
 /* Should this also be a bpf_target check for the sparc case? */
 #if defined(__arch64__)
 #define PT_REGS_IP(x) ((x)->tpc)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), tpc)
 #else
 #define PT_REGS_IP(x) ((x)->pc)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), pc)
 #endif
 
 #endif
-- 
2.17.1

