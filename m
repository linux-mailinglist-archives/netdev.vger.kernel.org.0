Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060AF108141
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 01:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfKXAjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 19:39:55 -0500
Received: from www62.your-server.de ([213.133.104.62]:43814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfKXAjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 19:39:55 -0500
Received: from 11.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.11] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYfwN-00041I-2g; Sun, 24 Nov 2019 01:39:51 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next] bpf: simplify __bpf_arch_text_poke poke type handling
Date:   Sun, 24 Nov 2019 01:39:42 +0100
Message-Id: <fcb00a2b0b288d6c73de4ef58116a821c8fe8f2f.1574555798.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25642/Sat Nov 23 10:55:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that we have BPF_MOD_NOP_TO_{CALL,JUMP}, BPF_MOD_{CALL,JUMP}_TO_NOP
and BPF_MOD_{CALL,JUMP}_TO_{CALL,JUMP} poke types and that we also pass in
old_addr as well as new_addr, it's a bit redundant and unnecessarily
complicates __bpf_arch_text_poke() itself since we can derive the same from
the *_addr that were passed in. Hence simplify and use BPF_MOD_{CALL,JUMP}
as types which also allows to clean up call-sites.

In addition to that, __bpf_arch_text_poke() currently verifies that text
matches expected old_insn before we invoke text_poke_bp(). Also add a check
on new_insn and skip rewrite if it already matches. Reason why this is rather
useful is that it avoids making any special casing in prog_array_map_poke_run()
when old and new prog were NULL and has the benefit that also for this case
we perform a check on text whether it really matches our expectations.

Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 arch/x86/net/bpf_jit_comp.c | 85 +++++++++++--------------------------
 include/linux/bpf.h         | 10 +----
 kernel/bpf/arraymap.c       | 12 +-----
 kernel/bpf/trampoline.c     |  8 ++--
 4 files changed, 32 insertions(+), 83 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 15615c94804f..b8be18427277 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -269,76 +269,42 @@ static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 				void *old_addr, void *new_addr,
 				const bool text_live)
 {
-	int (*emit_patch_fn)(u8 **pprog, void *func, void *ip);
 	const u8 *nop_insn = ideal_nops[NOP_ATOMIC5];
-	u8 old_insn[X86_PATCH_SIZE] = {};
-	u8 new_insn[X86_PATCH_SIZE] = {};
+	u8 old_insn[X86_PATCH_SIZE];
+	u8 new_insn[X86_PATCH_SIZE];
 	u8 *prog;
 	int ret;
 
-	switch (t) {
-	case BPF_MOD_NOP_TO_CALL ... BPF_MOD_CALL_TO_NOP:
-		emit_patch_fn = emit_call;
-		break;
-	case BPF_MOD_NOP_TO_JUMP ... BPF_MOD_JUMP_TO_NOP:
-		emit_patch_fn = emit_jump;
-		break;
-	default:
-		return -ENOTSUPP;
+	memcpy(old_insn, nop_insn, X86_PATCH_SIZE);
+	if (old_addr) {
+		prog = old_insn;
+		ret = t == BPF_MOD_CALL ?
+		      emit_call(&prog, old_addr, ip) :
+		      emit_jump(&prog, old_addr, ip);
+		if (ret)
+			return ret;
 	}
 
-	switch (t) {
-	case BPF_MOD_NOP_TO_CALL:
-	case BPF_MOD_NOP_TO_JUMP:
-		if (!old_addr && new_addr) {
-			memcpy(old_insn, nop_insn, X86_PATCH_SIZE);
-
-			prog = new_insn;
-			ret = emit_patch_fn(&prog, new_addr, ip);
-			if (ret)
-				return ret;
-			break;
-		}
-		return -ENXIO;
-	case BPF_MOD_CALL_TO_CALL:
-	case BPF_MOD_JUMP_TO_JUMP:
-		if (old_addr && new_addr) {
-			prog = old_insn;
-			ret = emit_patch_fn(&prog, old_addr, ip);
-			if (ret)
-				return ret;
-
-			prog = new_insn;
-			ret = emit_patch_fn(&prog, new_addr, ip);
-			if (ret)
-				return ret;
-			break;
-		}
-		return -ENXIO;
-	case BPF_MOD_CALL_TO_NOP:
-	case BPF_MOD_JUMP_TO_NOP:
-		if (old_addr && !new_addr) {
-			memcpy(new_insn, nop_insn, X86_PATCH_SIZE);
-
-			prog = old_insn;
-			ret = emit_patch_fn(&prog, old_addr, ip);
-			if (ret)
-				return ret;
-			break;
-		}
-		return -ENXIO;
-	default:
-		return -ENOTSUPP;
+	memcpy(new_insn, nop_insn, X86_PATCH_SIZE);
+	if (new_addr) {
+		prog = new_insn;
+		ret = t == BPF_MOD_CALL ?
+		      emit_call(&prog, new_addr, ip) :
+		      emit_jump(&prog, new_addr, ip);
+		if (ret)
+			return ret;
 	}
 
 	ret = -EBUSY;
 	mutex_lock(&text_mutex);
 	if (memcmp(ip, old_insn, X86_PATCH_SIZE))
 		goto out;
-	if (text_live)
-		text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
-	else
-		memcpy(ip, new_insn, X86_PATCH_SIZE);
+	if (memcmp(ip, new_insn, X86_PATCH_SIZE)) {
+		if (text_live)
+			text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
+		else
+			memcpy(ip, new_insn, X86_PATCH_SIZE);
+	}
 	ret = 0;
 out:
 	mutex_unlock(&text_mutex);
@@ -465,7 +431,6 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 
 static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
 {
-	static const enum bpf_text_poke_type type = BPF_MOD_NOP_TO_JUMP;
 	struct bpf_jit_poke_descriptor *poke;
 	struct bpf_array *array;
 	struct bpf_prog *target;
@@ -490,7 +455,7 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
 			 * read-only. Both modifications on the given image
 			 * are under text_mutex to avoid interference.
 			 */
-			ret = __bpf_arch_text_poke(poke->ip, type, NULL,
+			ret = __bpf_arch_text_poke(poke->ip, BPF_MOD_JUMP, NULL,
 						   (u8 *)target->bpf_func +
 						   poke->adj_off, false);
 			BUG_ON(ret < 0);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c2f07fd410c1..35903f148be5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1324,14 +1324,8 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 #endif /* CONFIG_INET */
 
 enum bpf_text_poke_type {
-	/* All call-related pokes. */
-	BPF_MOD_NOP_TO_CALL,
-	BPF_MOD_CALL_TO_CALL,
-	BPF_MOD_CALL_TO_NOP,
-	/* All jump-related pokes. */
-	BPF_MOD_NOP_TO_JUMP,
-	BPF_MOD_JUMP_TO_JUMP,
-	BPF_MOD_JUMP_TO_NOP,
+	BPF_MOD_CALL,
+	BPF_MOD_JUMP,
 };
 
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 58bdf5fd24cc..f0d19bbb9211 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -746,19 +746,9 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
 				    struct bpf_prog *old,
 				    struct bpf_prog *new)
 {
-	enum bpf_text_poke_type type;
 	struct prog_poke_elem *elem;
 	struct bpf_array_aux *aux;
 
-	if (!old && new)
-		type = BPF_MOD_NOP_TO_JUMP;
-	else if (old && !new)
-		type = BPF_MOD_JUMP_TO_NOP;
-	else if (old && new)
-		type = BPF_MOD_JUMP_TO_JUMP;
-	else
-		return;
-
 	aux = container_of(map, struct bpf_array, map)->aux;
 	WARN_ON_ONCE(!mutex_is_locked(&aux->poke_mutex));
 
@@ -806,7 +796,7 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
 			    poke->tail_call.key != key)
 				continue;
 
-			ret = bpf_arch_text_poke(poke->ip, type,
+			ret = bpf_arch_text_poke(poke->ip, BPF_MOD_JUMP,
 						 old ? (u8 *)old->bpf_func +
 						 poke->adj_off : NULL,
 						 new ? (u8 *)new->bpf_func +
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 10ae59d65f13..7e89f1f49d77 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -77,7 +77,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	int err;
 
 	if (fentry_cnt + fexit_cnt == 0) {
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL_TO_NOP,
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL,
 					 old_image, NULL);
 		tr->selector = 0;
 		goto out;
@@ -105,12 +105,12 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 
 	if (tr->selector)
 		/* progs already running at this address */
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL_TO_CALL,
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL,
 					 old_image, new_image);
 	else
 		/* first time registering */
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_NOP_TO_CALL,
-					 NULL, new_image);
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL, NULL,
+					 new_image);
 	if (err)
 		goto out;
 	tr->selector++;
-- 
2.21.0

