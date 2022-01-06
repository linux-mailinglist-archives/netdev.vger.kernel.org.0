Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FAD485EC2
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 03:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbiAFC1D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Jan 2022 21:27:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40968 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344864AbiAFC0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 21:26:08 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 205N7Tg5006853
        for <netdev@vger.kernel.org>; Wed, 5 Jan 2022 18:26:08 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ddmqsgt48-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 18:26:07 -0800
Received: from twshared29821.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 18:26:03 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C6D10273E542D; Wed,  5 Jan 2022 18:25:58 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Date:   Wed, 5 Jan 2022 18:25:33 -0800
Message-ID: <20220106022533.2950016-8-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220106022533.2950016-1-song@kernel.org>
References: <20220106022533.2950016-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WEuxxoSrUJRUguVWfs3NEIg7BFXb0QVT
X-Proofpoint-GUID: WEuxxoSrUJRUguVWfs3NEIg7BFXb0QVT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_08,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 clxscore=1034
 mlxlogscore=737 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

Use bpf_prog_pack allocator in x86_64 jit.

The program header from bpf_prog_pack is read only during the jit process.
Therefore, the binary is first written to a temporary buffer, and later
copied to final location with text_poke_jit().

Similarly, jit_fill_hole() is updated to fill the hole with 0xcc using
text_poke_jit().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 131 +++++++++++++++++++++++++++---------
 1 file changed, 100 insertions(+), 31 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index fe4f08e25a1d..ad69a64ee4fe 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -216,11 +216,33 @@ static u8 simple_alu_opcodes[] = {
 	[BPF_ARSH] = 0xF8,
 };
 
+static char jit_hole_buffer[PAGE_SIZE] = {};
+
 static void jit_fill_hole(void *area, unsigned int size)
+{
+	struct bpf_binary_header *hdr = area;
+	int i;
+
+	for (i = 0; i < roundup(size, PAGE_SIZE); i += PAGE_SIZE) {
+		int s;
+
+		s = min_t(int, PAGE_SIZE, size - i);
+		text_poke_jit(area + i, jit_hole_buffer, s);
+	}
+
+	/* bpf_jit_binary_alloc_pack cannot write size directly to the ro
+	 * mapping. Write it here with text_poke_jit().
+	 */
+	text_poke_jit(&hdr->size, &size, sizeof(size));
+}
+
+static int __init x86_jit_fill_hole_init(void)
 {
 	/* Fill whole space with INT3 instructions */
-	memset(area, 0xcc, size);
+	memset(jit_hole_buffer, 0xcc, PAGE_SIZE);
+	return 0;
 }
+pure_initcall(x86_jit_fill_hole_init);
 
 struct jit_context {
 	int cleanup_addr; /* Epilogue code offset */
@@ -361,14 +383,11 @@ static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 
 	ret = -EBUSY;
 	mutex_lock(&text_mutex);
-	if (memcmp(ip, old_insn, X86_PATCH_SIZE))
+	if (text_live && memcmp(ip, old_insn, X86_PATCH_SIZE))
 		goto out;
 	ret = 1;
 	if (memcmp(ip, new_insn, X86_PATCH_SIZE)) {
-		if (text_live)
-			text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
-		else
-			memcpy(ip, new_insn, X86_PATCH_SIZE);
+		text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
 		ret = 0;
 	}
 out:
@@ -537,7 +556,7 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	*pprog = prog;
 }
 
-static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
+static void bpf_tail_call_direct_fixup(struct bpf_prog *prog, bool text_live)
 {
 	struct bpf_jit_poke_descriptor *poke;
 	struct bpf_array *array;
@@ -558,24 +577,15 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
 		mutex_lock(&array->aux->poke_mutex);
 		target = array->ptrs[poke->tail_call.key];
 		if (target) {
-			/* Plain memcpy is used when image is not live yet
-			 * and still not locked as read-only. Once poke
-			 * location is active (poke->tailcall_target_stable),
-			 * any parallel bpf_arch_text_poke() might occur
-			 * still on the read-write image until we finally
-			 * locked it as read-only. Both modifications on
-			 * the given image are under text_mutex to avoid
-			 * interference.
-			 */
 			ret = __bpf_arch_text_poke(poke->tailcall_target,
 						   BPF_MOD_JUMP, NULL,
 						   (u8 *)target->bpf_func +
-						   poke->adj_off, false);
+						   poke->adj_off, text_live);
 			BUG_ON(ret < 0);
 			ret = __bpf_arch_text_poke(poke->tailcall_bypass,
 						   BPF_MOD_JUMP,
 						   (u8 *)poke->tailcall_target +
-						   X86_PATCH_SIZE, NULL, false);
+						   X86_PATCH_SIZE, NULL, text_live);
 			BUG_ON(ret < 0);
 		}
 		WRITE_ONCE(poke->tailcall_target_stable, true);
@@ -867,7 +877,7 @@ static void emit_nops(u8 **pprog, int len)
 
 #define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
 
-static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
+static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image, u8 *tmp_image,
 		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
 {
 	bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
@@ -894,8 +904,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	push_callee_regs(&prog, callee_regs_used);
 
 	ilen = prog - temp;
-	if (image)
-		memcpy(image + proglen, temp, ilen);
+	if (tmp_image)
+		memcpy(tmp_image + proglen, temp, ilen);
 	proglen += ilen;
 	addrs[0] = proglen;
 	prog = temp;
@@ -1324,8 +1334,10 @@ st:			if (is_imm8(insn->off))
 					pr_err("extable->insn doesn't fit into 32-bit\n");
 					return -EFAULT;
 				}
-				ex->insn = delta;
+				/* switch ex to temporary buffer for writes */
+				ex = (void *)tmp_image + ((void *)ex - (void *)image);
 
+				ex->insn = delta;
 				ex->type = EX_TYPE_BPF;
 
 				if (dst_reg > BPF_REG_9) {
@@ -1706,7 +1718,7 @@ st:			if (is_imm8(insn->off))
 				pr_err("bpf_jit: fatal error\n");
 				return -EFAULT;
 			}
-			memcpy(image + proglen, temp, ilen);
+			memcpy(tmp_image + proglen, temp, ilen);
 		}
 		proglen += ilen;
 		addrs[i] = proglen;
@@ -2248,8 +2260,10 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
 
 struct x64_jit_data {
 	struct bpf_binary_header *header;
+	struct bpf_binary_header *tmp_header;
 	int *addrs;
 	u8 *image;
+	u8 *tmp_image;
 	int proglen;
 	struct jit_context ctx;
 };
@@ -2259,6 +2273,7 @@ struct x64_jit_data {
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
+	struct bpf_binary_header *tmp_header = NULL;
 	struct bpf_binary_header *header = NULL;
 	struct bpf_prog *tmp, *orig_prog = prog;
 	struct x64_jit_data *jit_data;
@@ -2267,6 +2282,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bool tmp_blinded = false;
 	bool extra_pass = false;
 	bool padding = false;
+	u8 *tmp_image = NULL;
 	u8 *image = NULL;
 	int *addrs;
 	int pass;
@@ -2301,7 +2317,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		ctx = jit_data->ctx;
 		oldproglen = jit_data->proglen;
 		image = jit_data->image;
+		tmp_image = jit_data->tmp_image;
 		header = jit_data->header;
+		tmp_header = jit_data->tmp_header;
 		extra_pass = true;
 		padding = true;
 		goto skip_init_addrs;
@@ -2332,14 +2350,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	for (pass = 0; pass < MAX_PASSES || image; pass++) {
 		if (!padding && pass >= PADDING_PASSES)
 			padding = true;
-		proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
+		proglen = do_jit(prog, addrs, image, tmp_image, oldproglen, &ctx, padding);
 		if (proglen <= 0) {
 out_image:
 			image = NULL;
-			if (header)
-				bpf_jit_binary_free(header);
+			tmp_image = NULL;
+			if (header) {
+				bpf_jit_binary_free_pack(header);
+				kfree(tmp_header);
+			}
 			prog = orig_prog;
 			header = NULL;
+			tmp_header = NULL;
 			goto out_addrs;
 		}
 		if (image) {
@@ -2362,13 +2384,27 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 				sizeof(struct exception_table_entry);
 
 			/* allocate module memory for x86 insns and extable */
-			header = bpf_jit_binary_alloc(roundup(proglen, align) + extable_size,
-						      &image, align, jit_fill_hole);
+			header = bpf_jit_binary_alloc_pack(roundup(proglen, align) + extable_size,
+							   &image, align, jit_fill_hole);
 			if (!header) {
 				prog = orig_prog;
 				goto out_addrs;
 			}
-			prog->aux->extable = (void *) image + roundup(proglen, align);
+			if (header->size > bpf_prog_pack_max_size()) {
+				tmp_header = header;
+				tmp_image = image;
+			} else {
+				tmp_header = kzalloc(header->size, GFP_KERNEL);
+				if (!tmp_header) {
+					bpf_jit_binary_free_pack(header);
+					header = NULL;
+					prog = orig_prog;
+					goto out_addrs;
+				}
+				tmp_header->size = header->size;
+				tmp_image = (void *)tmp_header + ((void *)image - (void *)header);
+			}
+			prog->aux->extable = (void *)image + roundup(proglen, align);
 		}
 		oldproglen = proglen;
 		cond_resched();
@@ -2379,14 +2415,23 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	if (image) {
 		if (!prog->is_func || extra_pass) {
-			bpf_tail_call_direct_fixup(prog);
-			bpf_jit_binary_lock_ro(header);
+			if (header->size > bpf_prog_pack_max_size()) {
+				/* bpf_prog_pack cannot handle too big
+				 * program (> ~2MB). Fall back to regular
+				 * module_alloc(), and do the fixup and
+				 * lock_ro here.
+				 */
+				bpf_tail_call_direct_fixup(prog, false);
+				bpf_jit_binary_lock_ro(header);
+			}
 		} else {
 			jit_data->addrs = addrs;
 			jit_data->ctx = ctx;
 			jit_data->proglen = proglen;
 			jit_data->image = image;
+			jit_data->tmp_image = tmp_image;
 			jit_data->header = header;
+			jit_data->tmp_header = tmp_header;
 		}
 		prog->bpf_func = (void *)image;
 		prog->jited = 1;
@@ -2402,6 +2447,16 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		kvfree(addrs);
 		kfree(jit_data);
 		prog->aux->jit_data = NULL;
+		jit_data = NULL;
+		if (tmp_header != header) {
+			text_poke_jit(header, tmp_header, header->size);
+			kfree(tmp_header);
+			/* Do the fixup after final text_poke_jit().
+			 * Otherwise, the fix up will be overwritten by
+			 * text_poke_jit().
+			 */
+			bpf_tail_call_direct_fixup(prog, true);
+		}
 	}
 out:
 	if (tmp_blinded)
@@ -2415,3 +2470,17 @@ bool bpf_jit_supports_kfunc_call(void)
 {
 	return true;
 }
+
+void bpf_jit_free(struct bpf_prog *fp)
+{
+	if (fp->jited) {
+		struct bpf_binary_header *hdr = bpf_jit_binary_hdr(fp);
+
+		if (hdr->size > bpf_prog_pack_max_size())
+			bpf_jit_binary_free(hdr);
+		else
+			bpf_jit_binary_free_pack(hdr);
+	}
+
+	bpf_prog_unlock_free(fp);
+}
-- 
2.30.2

