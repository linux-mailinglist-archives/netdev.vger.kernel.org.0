Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8721FD22A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfKOBE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:50770 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbfKOBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:24 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ29-00081d-Vv; Fri, 15 Nov 2019 02:04:22 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 8/8] bpf: constant map key tracking for prog array pokes
Date:   Fri, 15 Nov 2019 02:04:02 +0100
Message-Id: <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573779287.git.daniel@iogearbox.net>
References: <cover.1573779287.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tracking of constant keys into tail call maps. The signature of
bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
is a index key. The direct call approach for tail calls can be enabled
if the verifier asserted that for all branches leading to the tail call
helper invocation, the map pointer and index key were both constant
and the same. Tracking of map pointers we already do from prior work
via c93552c443eb ("bpf: properly enforce index mask to prevent out-of-bounds
speculation") and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/
delete calls on maps"). Given the tail call map index key is not on
stack but directly in the register, we can add similar tracking approach
and later in fixup_bpf_calls() add a poke descriptor to the progs poke_tab
with the relevant information for the JITing phase. We internally reuse
insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL instruction in order
to point into the prog's poke_tab and keep insn->imm == 0 as indicator
that current indirect tail call emission must be used.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 98 ++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index cdd08bf0ec06..f494f0c9ac13 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -301,6 +301,7 @@ struct bpf_insn_aux_data {
 			u32 map_off;		/* offset from value base address */
 		};
 	};
+	u64 key_state; /* constant key tracking for maps */
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
 	int sanitize_stack_off; /* stack slot to be cleared */
 	bool seen; /* this insn was processed by the verifier */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e9dc95a18d44..48d5c9030d60 100644
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
@@ -195,6 +198,29 @@ static void bpf_map_ptr_store(struct bpf_insn_aux_data *aux,
 			 (unpriv ? BPF_MAP_PTR_UNPRIV : 0UL);
 }
 
+static bool bpf_map_key_poisoned(const struct bpf_insn_aux_data *aux)
+{
+	return aux->key_state & BPF_MAP_KEY_POISON;
+}
+
+static bool bpf_map_key_unseen(const struct bpf_insn_aux_data *aux)
+{
+	return !(aux->key_state & BPF_MAP_KEY_SEEN);
+}
+
+static u64 bpf_map_key_immediate(const struct bpf_insn_aux_data *aux)
+{
+	return aux->key_state & ~BPF_MAP_KEY_SEEN;
+}
+
+static void bpf_map_key_store(struct bpf_insn_aux_data *aux, u64 state)
+{
+	bool poisoned = bpf_map_key_poisoned(aux);
+
+	aux->key_state = state | BPF_MAP_KEY_SEEN |
+			 (poisoned ? BPF_MAP_KEY_POISON : 0ULL);
+}
+
 struct bpf_call_arg_meta {
 	struct bpf_map *map_ptr;
 	bool raw_mode;
@@ -4088,6 +4114,37 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	return 0;
 }
 
+static int
+record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
+		int func_id, int insn_idx)
+{
+	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
+	struct bpf_reg_state *regs = cur_regs(env), *reg;
+	struct tnum range = tnum_range(0, U32_MAX);
+	struct bpf_map *map = meta->map_ptr;
+	u64 val;
+
+	if (func_id != BPF_FUNC_tail_call)
+		return 0;
+	if (!map || map->map_type != BPF_MAP_TYPE_PROG_ARRAY) {
+		verbose(env, "kernel subsystem misconfigured verifier\n");
+		return -EINVAL;
+	}
+
+	reg = &regs[BPF_REG_3];
+	if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
+		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
+		return 0;
+	}
+
+	val = reg->var_off.value;
+	if (bpf_map_key_unseen(aux))
+		bpf_map_key_store(aux, val);
+	else if (bpf_map_key_immediate(aux) != val)
+		bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
+	return 0;
+}
+
 static int check_reference_leak(struct bpf_verifier_env *env)
 {
 	struct bpf_func_state *state = cur_func(env);
@@ -4162,6 +4219,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	if (err)
 		return err;
 
+	err = record_func_key(env, &meta, func_id, insn_idx);
+	if (err)
+		return err;
+
 	/* Mark slots with STACK_MISC in case of raw mode, stack offset
 	 * is inferred from register state.
 	 */
@@ -9202,6 +9263,43 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			insn->code = BPF_JMP | BPF_TAIL_CALL;
 
 			aux = &env->insn_aux_data[i + delta];
+			if (prog->jit_requested &&
+			    !bpf_map_key_poisoned(aux) &&
+			    !bpf_map_ptr_poisoned(aux) &&
+			    !bpf_map_ptr_unpriv(aux)) {
+				struct bpf_jit_poke_descriptor desc;
+				u32 map_key;
+				int ret;
+
+				map_key = bpf_map_key_immediate(aux);
+				map_ptr = BPF_MAP_PTR(aux->map_state);
+
+				if (map_key >= map_ptr->max_entries)
+					continue;
+				if (!map_ptr->ops->map_poke_track) {
+					verbose(env, "bpf verifier is misconfigured\n");
+					return -EINVAL;
+				}
+
+				memset(&desc, 0, sizeof(desc));
+				desc.reason = BPF_POKE_REASON_TAIL_CALL;
+				desc.tc.map = map_ptr;
+				desc.tc.key = map_key;
+
+				ret = bpf_jit_add_poke_descriptor(prog, &desc);
+				if (ret < 0) {
+					verbose(env, "adding tail call poke descriptor failed\n");
+					return ret;
+				}
+
+				insn->imm = ret + 1;
+
+				ret = map_ptr->ops->map_poke_track(map_ptr, prog->aux);
+				if (ret < 0) {
+					verbose(env, "tracking tail call prog failed\n");
+					return ret;
+				}
+			}
 			if (!bpf_map_ptr_unpriv(aux))
 				continue;
 
-- 
2.21.0

