Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8962FCE51
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfKNS5w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7962 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727226AbfKNS5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:49 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEIhPnf030208
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:48 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8qj9e1ac-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:48 -0800
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 10:57:47 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 7FA6676071B; Thu, 14 Nov 2019 10:57:47 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 13/20] bpf: Reserve space for BPF trampoline in BPF programs
Date:   Thu, 14 Nov 2019 10:57:13 -0800
Message-ID: <20191114185720.1641606-14-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1034 mlxlogscore=587 suspectscore=1 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
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
Acked-by: Song Liu <songliubraving@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index be2b43a894f6..c06096df9118 100644
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

