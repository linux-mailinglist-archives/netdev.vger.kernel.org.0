Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A790D7B7A9
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfGaBic convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jul 2019 21:38:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24278 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726136AbfGaBic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:38:32 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V1WKMe000925
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:38:31 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2u2uy0s372-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:38:31 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 18:38:30 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C0A89760C3C; Tue, 30 Jul 2019 18:38:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/2] bpf: fix x64 JIT code generation for jmp to 1st insn
Date:   Tue, 30 Jul 2019 18:38:26 -0700
Message-ID: <20190731013827.2445262-2-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731013827.2445262-1-ast@kernel.org>
References: <20190731013827.2445262-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduction of bounded loops exposed old bug in x64 JIT.
JIT maintains the array of offsets to the end of all instructions to
compute jmp offsets.
addrs[0] - offset of the end of the 1st insn (that includes prologue).
addrs[1] - offset of the end of the 2nd insn.
JIT didn't keep the offset of the beginning of the 1st insn,
since classic BPF didn't have backward jumps and valid extended BPF
couldn't have a branch to 1st insn, because it didn't allow loops.
With bounded loops it's possible to construct a valid program that
jumps backwards to the 1st insn.
Fix JIT by computing:
addrs[0] - offset of the end of prologue == start of the 1st insn.
addrs[1] - offset of the end of 1st insn.

Reported-by: syzbot+35101610ff3e83119b1b@syzkaller.appspotmail.com
Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index eaaed5bfc4a4..a56c95805732 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -390,8 +390,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 	emit_prologue(&prog, bpf_prog->aux->stack_depth,
 		      bpf_prog_was_classic(bpf_prog));
+	addrs[0] = prog - temp;
 
-	for (i = 0; i < insn_cnt; i++, insn++) {
+	for (i = 1; i <= insn_cnt; i++, insn++) {
 		const s32 imm32 = insn->imm;
 		u32 dst_reg = insn->dst_reg;
 		u32 src_reg = insn->src_reg;
@@ -1105,7 +1106,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		extra_pass = true;
 		goto skip_init_addrs;
 	}
-	addrs = kmalloc_array(prog->len, sizeof(*addrs), GFP_KERNEL);
+	addrs = kmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
 	if (!addrs) {
 		prog = orig_prog;
 		goto out_addrs;
@@ -1115,7 +1116,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	 * Before first pass, make a rough estimation of addrs[]
 	 * each BPF instruction is translated to less than 64 bytes
 	 */
-	for (proglen = 0, i = 0; i < prog->len; i++) {
+	for (proglen = 0, i = 0; i <= prog->len; i++) {
 		proglen += 64;
 		addrs[i] = proglen;
 	}
-- 
2.20.0

