Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B6107941
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKVUIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:08:25 -0500
Received: from www62.your-server.de ([213.133.104.62]:37364 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfKVUIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 15:08:16 -0500
Received: from 30.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYFDx-0004ZF-Ie; Fri, 22 Nov 2019 21:08:13 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 6/8] bpf: constant map key tracking for prog array pokes
Date:   Fri, 22 Nov 2019 21:07:59 +0100
Message-Id: <e8db37f6b2ae60402fa40216c96738ee9b316c32.1574452833.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574452833.git.daniel@iogearbox.net>
References: <cover.1574452833.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tracking of constant keys into tail call maps. The signature of
bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
is a index key. The direct call approach for tail calls can be enabled
if the verifier asserted that for all branches leading to the tail call
helper invocation, the map pointer and index key were both constant
and the same.

Tracking of map pointers we already do from prior work via c93552c443eb
("bpf: properly enforce index mask to prevent out-of-bounds speculation")
and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/ delete calls
on maps").

Given the tail call map index key is not on stack but directly in the
register, we can add similar tracking approach and later in fixup_bpf_calls()
add a poke descriptor to the progs poke_tab with the relevant information
for the JITing phase.

We internally reuse insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL
instruction in order to point into the prog's poke_tab, and keep insn->imm
as 0 as indicator that current indirect tail call emission must be used.
Note that publishing to the tracker must happen at the end of fixup_bpf_calls()
since adding elements to the poke_tab reallocates its memory, so we need
to wait until its in final state.

Future work can generalize and add similar approach to optimize plain
array map lookups. Difference there is that we need to look into the key
value that sits on stack. For clarity in bpf_insn_aux_data, map_state
has been renamed into map_ptr_state, so we get map_{ptr,key}_state as
trackers.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf_verifier.h |   3 +-
 kernel/bpf/verifier.c        | 120 ++++++++++++++++++++++++++++++++---
 2 files changed, 113 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index cdd08bf0ec06..26e40de9ef55 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -293,7 +293,7 @@ struct bpf_verifier_state_list {
 struct bpf_insn_aux_data {
 	union {
 		enum bpf_reg_type ptr_type;	/* pointer type for load/store insns */
-		unsigned long map_state;	/* pointer/poison value for maps */
+		unsigned long map_ptr_state;	/* pointer/poison value for maps */
 		s32 call_imm;			/* saved imm field of call insn */
 		u32 alu_limit;			/* limit for add/sub register with pointer */
 		struct {
@@ -301,6 +301,7 @@ struct bpf_insn_aux_data {
 			u32 map_off;		/* offset from value base address */
 		};
 	};
+	u64 map_key_state; /* constant (32 bit) key tracking for maps */
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
 	int sanitize_stack_off; /* stack slot to be cleared */
 	bool seen; /* this insn was processed by the verifier */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9f59f7a19dd0..c4e17583b9bf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -171,6 +171,9 @@ struct bpf_verifier_stack_elem {
 #define BPF_COMPLEXITY_LIMIT_JMP_SEQ	8192
 #define BPF_COMPLEXITY_LIMIT_STATES	64
 
+#define BPF_MAP_KEY_POISON	(1ULL << 63)
+#define BPF_MAP_KEY_SEEN	(1ULL << 62)
+
 #define BPF_MAP_PTR_UNPRIV	1UL
 #define BPF_MAP_PTR_POISON	((void *)((0xeB9FUL << 1) +	\
 					  POISON_POINTER_DELTA))
@@ -178,12 +181,12 @@ struct bpf_verifier_stack_elem {
 
 static bool bpf_map_ptr_poisoned(const struct bpf_insn_aux_data *aux)
 {
-	return BPF_MAP_PTR(aux->map_state) == BPF_MAP_PTR_POISON;
+	return BPF_MAP_PTR(aux->map_ptr_state) == BPF_MAP_PTR_POISON;
 }
 
 static bool bpf_map_ptr_unpriv(const struct bpf_insn_aux_data *aux)
 {
-	return aux->map_state & BPF_MAP_PTR_UNPRIV;
+	return aux->map_ptr_state & BPF_MAP_PTR_UNPRIV;
 }
 
 static void bpf_map_ptr_store(struct bpf_insn_aux_data *aux,
@@ -191,8 +194,31 @@ static void bpf_map_ptr_store(struct bpf_insn_aux_data *aux,
 {
 	BUILD_BUG_ON((unsigned long)BPF_MAP_PTR_POISON & BPF_MAP_PTR_UNPRIV);
 	unpriv |= bpf_map_ptr_unpriv(aux);
-	aux->map_state = (unsigned long)map |
-			 (unpriv ? BPF_MAP_PTR_UNPRIV : 0UL);
+	aux->map_ptr_state = (unsigned long)map |
+			     (unpriv ? BPF_MAP_PTR_UNPRIV : 0UL);
+}
+
+static bool bpf_map_key_poisoned(const struct bpf_insn_aux_data *aux)
+{
+	return aux->map_key_state & BPF_MAP_KEY_POISON;
+}
+
+static bool bpf_map_key_unseen(const struct bpf_insn_aux_data *aux)
+{
+	return !(aux->map_key_state & BPF_MAP_KEY_SEEN);
+}
+
+static u64 bpf_map_key_immediate(const struct bpf_insn_aux_data *aux)
+{
+	return aux->map_key_state & ~(BPF_MAP_KEY_SEEN | BPF_MAP_KEY_POISON);
+}
+
+static void bpf_map_key_store(struct bpf_insn_aux_data *aux, u64 state)
+{
+	bool poisoned = bpf_map_key_poisoned(aux);
+
+	aux->map_key_state = state | BPF_MAP_KEY_SEEN |
+			     (poisoned ? BPF_MAP_KEY_POISON : 0ULL);
 }
 
 struct bpf_call_arg_meta {
@@ -4079,15 +4105,49 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 		return -EACCES;
 	}
 
-	if (!BPF_MAP_PTR(aux->map_state))
+	if (!BPF_MAP_PTR(aux->map_ptr_state))
 		bpf_map_ptr_store(aux, meta->map_ptr,
 				  meta->map_ptr->unpriv_array);
-	else if (BPF_MAP_PTR(aux->map_state) != meta->map_ptr)
+	else if (BPF_MAP_PTR(aux->map_ptr_state) != meta->map_ptr)
 		bpf_map_ptr_store(aux, BPF_MAP_PTR_POISON,
 				  meta->map_ptr->unpriv_array);
 	return 0;
 }
 
+static int
+record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
+		int func_id, int insn_idx)
+{
+	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
+	struct bpf_reg_state *regs = cur_regs(env), *reg;
+	struct bpf_map *map = meta->map_ptr;
+	struct tnum range;
+	u64 val;
+
+	if (func_id != BPF_FUNC_tail_call)
+		return 0;
+	if (!map || map->map_type != BPF_MAP_TYPE_PROG_ARRAY) {
+		verbose(env, "kernel subsystem misconfigured verifier\n");
+		return -EINVAL;
+	}
+
+	range = tnum_range(0, map->max_entries - 1);
+	reg = &regs[BPF_REG_3];
+
+	if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
+		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
+		return 0;
+	}
+
+	val = reg->var_off.value;
+	if (bpf_map_key_unseen(aux))
+		bpf_map_key_store(aux, val);
+	else if (!bpf_map_key_poisoned(aux) &&
+		  bpf_map_key_immediate(aux) != val)
+		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
+	return 0;
+}
+
 static int check_reference_leak(struct bpf_verifier_env *env)
 {
 	struct bpf_func_state *state = cur_func(env);
@@ -4162,6 +4222,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	if (err)
 		return err;
 
+	err = record_func_key(env, &meta, func_id, insn_idx);
+	if (err)
+		return err;
+
 	/* Mark slots with STACK_MISC in case of raw mode, stack offset
 	 * is inferred from register state.
 	 */
@@ -9046,6 +9110,7 @@ static int fixup_call_args(struct bpf_verifier_env *env)
 static int fixup_bpf_calls(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
+	bool expect_blinding = bpf_jit_blinding_enabled(prog);
 	struct bpf_insn *insn = prog->insnsi;
 	const struct bpf_func_proto *fn;
 	const int insn_cnt = prog->len;
@@ -9054,7 +9119,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 	struct bpf_insn insn_buf[16];
 	struct bpf_prog *new_prog;
 	struct bpf_map *map_ptr;
-	int i, cnt, delta = 0;
+	int i, ret, cnt, delta = 0;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		if (insn->code == (BPF_ALU64 | BPF_MOD | BPF_X) ||
@@ -9198,6 +9263,26 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			insn->code = BPF_JMP | BPF_TAIL_CALL;
 
 			aux = &env->insn_aux_data[i + delta];
+			if (prog->jit_requested && !expect_blinding &&
+			    !bpf_map_key_poisoned(aux) &&
+			    !bpf_map_ptr_poisoned(aux) &&
+			    !bpf_map_ptr_unpriv(aux)) {
+				struct bpf_jit_poke_descriptor desc = {
+					.reason = BPF_POKE_REASON_TAIL_CALL,
+					.tail_call.map = BPF_MAP_PTR(aux->map_ptr_state),
+					.tail_call.key = bpf_map_key_immediate(aux),
+				};
+
+				ret = bpf_jit_add_poke_descriptor(prog, &desc);
+				if (ret < 0) {
+					verbose(env, "adding tail call poke descriptor failed\n");
+					return ret;
+				}
+
+				insn->imm = ret + 1;
+				continue;
+			}
+
 			if (!bpf_map_ptr_unpriv(aux))
 				continue;
 
@@ -9212,7 +9297,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 				return -EINVAL;
 			}
 
-			map_ptr = BPF_MAP_PTR(aux->map_state);
+			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
 			insn_buf[0] = BPF_JMP_IMM(BPF_JGE, BPF_REG_3,
 						  map_ptr->max_entries, 2);
 			insn_buf[1] = BPF_ALU32_IMM(BPF_AND, BPF_REG_3,
@@ -9246,7 +9331,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			if (bpf_map_ptr_poisoned(aux))
 				goto patch_call_imm;
 
-			map_ptr = BPF_MAP_PTR(aux->map_state);
+			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
 			ops = map_ptr->ops;
 			if (insn->imm == BPF_FUNC_map_lookup_elem &&
 			    ops->map_gen_lookup) {
@@ -9326,6 +9411,23 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 		insn->imm = fn->func - __bpf_call_base;
 	}
 
+	/* Since poke tab is now finalized, publish aux to tracker. */
+	for (i = 0; i < prog->aux->size_poke_tab; i++) {
+		map_ptr = prog->aux->poke_tab[i].tail_call.map;
+		if (!map_ptr->ops->map_poke_track ||
+		    !map_ptr->ops->map_poke_untrack ||
+		    !map_ptr->ops->map_poke_run) {
+			verbose(env, "bpf verifier is misconfigured\n");
+			return -EINVAL;
+		}
+
+		ret = map_ptr->ops->map_poke_track(map_ptr, prog->aux);
+		if (ret < 0) {
+			verbose(env, "tracking tail call prog failed\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.21.0

