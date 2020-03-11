Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184AD180CE8
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 01:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgCKAjM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Mar 2020 20:39:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61190 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgCKAjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 20:39:11 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02B0Z0Oa001850
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 17:39:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yp25fnndf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 17:39:10 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 10 Mar 2020 17:39:09 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 3B27B760F6E; Tue, 10 Mar 2020 17:39:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <kpsingh@google.com>, <jannh@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: Fix trampoline generation for fmod_ret programs
Date:   Tue, 10 Mar 2020 17:39:06 -0700
Message-ID: <20200311003906.3643037-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_17:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 suspectscore=1 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=622
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fmod_ret progs are emitted as:

start = __bpf_prog_enter();
call fmod_ret
*(u64 *)(rbp - 8) = rax
__bpf_prog_exit(, start);
test eax, eax
jne do_fexit

That 'test eax, eax' is working by accident. The compiler is free to use rax
inside __bpf_prog_exit() or inside functions that __bpf_prog_exit() is calling.
Which caused "test_progs -t modify_return" to sporadically fail depending on
compiler version and kconfig. Fix it by using 'cmp [rbp - 8], 0' instead of
'test eax, eax'.

Fixes: ae24082331d9 ("bpf: Introduce BPF_MODIFY_RETURN")
Reported-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index b1fd000feb89..5ea7c2cf7ab4 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1449,23 +1449,6 @@ static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
 	return 0;
 }
 
-static int emit_mod_ret_check_imm8(u8 **pprog, int value)
-{
-	u8 *prog = *pprog;
-	int cnt = 0;
-
-	if (!is_imm8(value))
-		return -EINVAL;
-
-	if (value == 0)
-		EMIT2(0x85, add_2reg(0xC0, BPF_REG_0, BPF_REG_0));
-	else
-		EMIT3(0x83, add_1reg(0xF8, BPF_REG_0), value);
-
-	*pprog = prog;
-	return 0;
-}
-
 static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
 		      struct bpf_tramp_progs *tp, int stack_size)
 {
@@ -1485,7 +1468,7 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 			      u8 **branches)
 {
 	u8 *prog = *pprog;
-	int i;
+	int i, cnt = 0;
 
 	/* The first fmod_ret program will receive a garbage return value.
 	 * Set this to 0 to avoid confusing the program.
@@ -1496,16 +1479,12 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, true))
 			return -EINVAL;
 
-		/* Generate a branch:
-		 *
-		 * if (ret !=  0)
+		/* mod_ret prog stored return value into [rbp - 8]. Emit:
+		 * if (*(u64 *)(rbp - 8) !=  0)
 		 *	goto do_fexit;
-		 *
-		 * If needed this can be extended to any integer value which can
-		 * be passed by user-space when the program is loaded.
 		 */
-		if (emit_mod_ret_check_imm8(&prog, 0))
-			return -EINVAL;
+		/* cmp QWORD PTR [rbp - 0x8], 0x0 */
+		EMIT4(0x48, 0x83, 0x7d, 0xf8); EMIT1(0x00);
 
 		/* Save the location of the branch and Generate 6 nops
 		 * (4 bytes for an offset and 2 bytes for the jump) These nops
-- 
2.23.0

