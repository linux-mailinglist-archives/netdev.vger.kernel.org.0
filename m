Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF7F4098
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfKHGlO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 01:41:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730112AbfKHGlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:41:12 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86Y3IN024076
        for <netdev@vger.kernel.org>; Thu, 7 Nov 2019 22:41:11 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vy1w4h-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 22:41:11 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 7 Nov 2019 22:41:08 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id DCB25760F61; Thu,  7 Nov 2019 22:41:03 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 12/18] bpf: Reserve space for BPF trampoline in BPF programs
Date:   Thu, 7 Nov 2019 22:40:33 -0800
Message-ID: <20191108064039.2041889-13-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108064039.2041889-1-ast@kernel.org>
References: <20191108064039.2041889-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1034 mlxscore=0
 suspectscore=1 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=607
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF trampoline can be made to work with existing 5 bytes of BPF program
prologue, but let's add 5 bytes of NOPs to the beginning of every JITed BPF
program to make BPF trampoline job easier. They can be removed in the future.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 9ccf7cd51a21..3123d4ddc6ca 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -206,7 +206,7 @@ struct jit_context {
 /* number of bytes emit_call() needs to generate call instruction */
 #define X86_CALL_SIZE		5
 
-#define PROLOGUE_SIZE		20
+#define PROLOGUE_SIZE		25
 
 /*
  * Emit x86-64 prologue code for BPF program and check its size.
@@ -215,8 +215,13 @@ struct jit_context {
 static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
+	int cnt = X86_CALL_SIZE;
 
+	/* BPF trampoline can be made to work without these nops,
+	 * but let's waste 5 bytes for now and optimize later
+	 */
+	memcpy(prog, ideal_nops[NOP_ATOMIC5], cnt);
+	prog += cnt;
 	EMIT1(0x55);             /* push rbp */
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
 	/* sub rsp, rounded_stack_depth */
-- 
2.23.0

