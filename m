Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E738B65C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhETS5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236112AbhETS5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 14:57:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D6FC061574;
        Thu, 20 May 2021 11:55:54 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 6so12497048pgk.5;
        Thu, 20 May 2021 11:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mZfYo4KWcXivOyuRQ2aD8zkqVkHBzMKa9UDSnSF7cBU=;
        b=Jyx1zkmqnk59e0/a0BoVK2iO2oOiVwod78OomdTHIMbSf2f7vDCM76fYPXMhFXzk+A
         hGBV1PRh0r6HrtJ/Pgn7yJUqCtxzoQgdGNGeImky/3WgqmDZJI8jylz6HWPZuyrAtq9e
         QikGiFkBs68BU97HVGHxs0TSrc1+ecxIrL9lrk7iTskVZuc/GYtNz3uEVLX0ryEqdkX5
         Fjl9z3NMS7TeH5lAU/Qtt6lE/xxFdjvpK74x+vyN3KkKTrMoy8hahTl47wsjspNA4K6e
         AcPx2EbWSwDfgNpTfhDU1OwWiUZ47YbkBZwPLgcbIkicBUJ72TzGa28fEIXqgMUDt7Ja
         Zoow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mZfYo4KWcXivOyuRQ2aD8zkqVkHBzMKa9UDSnSF7cBU=;
        b=tcoEXNncNAyUm6V+QZvdt6E/hxrUWn2jHQBUWm+FH58QZHb8+fvb9FOD6CpLxy7g9E
         FmLVwFDXM2Mkn9UI5/C6v0GCDj5JTvQDEl59VCpq2FPmCV4bg0yIVLz91q7rSDG5unzK
         L+5chy3y+KbFANd219bJcJTOgKRE76Er/U0gi2RUl4r09t88zRxCFWrbhxj+tXEg8edY
         mrLGUzSxLDREOov36WcD+zMzFMQ53hu0hJJg7o26iYwTTGFCg/HustUlu321j1FKtlo2
         GaGnMdSPoyUCdQVBS6SexvAkQ0yJT+fCldbec/vnjkDWflL/+JNe9ZO9/PRO9LvN55pp
         nYEQ==
X-Gm-Message-State: AOAM531kwGxv8TDmiS31fnrUQ6iiacRaqrvsu+27TKNsdgMG7jnM67Fc
        fPXkpIRFO0P3qjrleSMZomC8zKI7Afc=
X-Google-Smtp-Source: ABdhPJwE+8noCZb8TS5MyEQziN1EsytcPesmarnMkbiu4Ai+YHL6VIwCj8QFVYS5qsROu5dB6cAOpQ==
X-Received: by 2002:a62:6491:0:b029:28e:8c90:6b16 with SMTP id y139-20020a6264910000b029028e8c906b16mr5704589pfb.24.1621536953580;
        Thu, 20 May 2021 11:55:53 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.4])
        by smtp.gmail.com with ESMTPSA id o2sm1793073pfu.80.2021.05.20.11.55.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 May 2021 11:55:53 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, john.fastabend@gmail.com,
        lmb@cloudflare.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
Date:   Thu, 20 May 2021 11:55:50 -0700
Message-Id: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Introduce 'struct bpf_timer' that can be embedded in most BPF map types
and helpers to operate on it:
long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
long bpf_timer_del(struct bpf_timer *timer)

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
This is work in progress, but gives an idea on how API will look.
---
 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  25 ++++
 kernel/bpf/helpers.c                          | 106 +++++++++++++++++
 kernel/bpf/verifier.c                         | 110 ++++++++++++++++++
 kernel/trace/bpf_trace.c                      |   2 +-
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  25 ++++
 .../testing/selftests/bpf/prog_tests/timer.c  |  42 +++++++
 tools/testing/selftests/bpf/progs/timer.c     |  53 +++++++++
 9 files changed, 365 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9dc44ba97584..18e09cc0c410 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -312,6 +312,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_FUNC,	/* pointer to a bpf program function */
 	ARG_PTR_TO_STACK_OR_NULL,	/* pointer to stack or NULL */
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
+	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
 	__BPF_ARG_TYPE_MAX,
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 418b9b813d65..c95d7854d9fb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4761,6 +4761,24 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
+ *	Description
+ *		Initialize the timer to call given static function.
+ *	Return
+ *		zero
+ *
+ * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
+ *	Description
+ *		Set the timer expiration N msecs from the current time.
+ *	Return
+ *		zero
+ *
+ * long bpf_timer_del(struct bpf_timer *timer)
+ *	Description
+ *		Deactivate the timer.
+ *	Return
+ *		zero
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4932,6 +4950,9 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(timer_init),			\
+	FN(timer_mod),			\
+	FN(timer_del),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -6038,6 +6059,10 @@ struct bpf_spin_lock {
 	__u32	val;
 };
 
+struct bpf_timer {
+	__u64 opaque;
+};
+
 struct bpf_sysctl {
 	__u32	write;		/* Sysctl is being read (= 0) or written (= 1).
 				 * Allows 1,2,4-byte read, but no write.
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 544773970dbc..8ef0ad23c991 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -985,6 +985,106 @@ const struct bpf_func_proto bpf_snprintf_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+struct bpf_timer_list {
+	struct timer_list tl;
+	struct bpf_map *map;
+	struct bpf_prog *prog;
+	void *callback_fn;
+	void *key;
+	void *value;
+};
+
+static void timer_cb(struct timer_list *timer)
+{
+	struct bpf_timer_list *tl = from_timer(tl, timer, tl);
+	struct bpf_map *map;
+	int ret;
+
+	ret = BPF_CAST_CALL(tl->callback_fn)((u64)(long)tl->map,
+					     (u64)(long)tl->key,
+					     (u64)(long)tl->value, 0, 0);
+	WARN_ON(ret != 0); /* todo: define 0 vs 1 or disallow 1 in the verifier */
+	bpf_prog_put(tl->prog);
+}
+
+BPF_CALL_5(bpf_timer_init, struct bpf_timer *, timer, void *, cb, int, flags,
+	   struct bpf_map *, map, struct bpf_prog *, prog)
+{
+	struct bpf_timer_list *tl;
+
+	if (timer->opaque)
+		return -EBUSY;
+	tl = kcalloc(1, sizeof(*tl), GFP_ATOMIC);
+	if (!tl)
+		return -ENOMEM;
+	tl->callback_fn = cb;
+	tl->value = (void *)timer /* - offset of bpf_timer inside elem */;
+	tl->key = tl->value - round_up(map->key_size, 8);
+	tl->map = map;
+	tl->prog = prog;
+	timer_setup(&tl->tl, timer_cb, 0);
+	timer->opaque = (long)tl;
+	return 0;
+}
+
+const struct bpf_func_proto bpf_timer_init_proto = {
+	.func		= bpf_timer_init,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_TIMER,
+	.arg2_type	= ARG_PTR_TO_FUNC,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_2(bpf_timer_mod, struct bpf_timer *, timer, u64, msecs)
+{
+	struct bpf_timer_list *tl;
+
+	tl = (struct bpf_timer_list *)timer->opaque;
+	if (!tl)
+		return -EINVAL;
+	/* keep the prog alive until callback is invoked */
+	if (!mod_timer(&tl->tl, jiffies + msecs_to_jiffies(msecs))) {
+		/* The timer was inactive.
+		 * Keep the prog alive until callback is invoked
+		 */
+		bpf_prog_inc(tl->prog);
+	}
+	return 0;
+}
+
+const struct bpf_func_proto bpf_timer_mod_proto = {
+	.func		= bpf_timer_mod,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_TIMER,
+	.arg2_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_1(bpf_timer_del, struct bpf_timer *, timer)
+{
+	struct bpf_timer_list *tl;
+
+	tl = (struct bpf_timer_list *)timer->opaque;
+	if (!tl)
+		return -EINVAL;
+	if (del_timer(&tl->tl)) {
+		/* The timer was active,
+		 * drop the prog refcnt, since callback
+		 * will not be invoked.
+		 */
+		bpf_prog_put(tl->prog);
+	}
+	return 0;
+}
+
+const struct bpf_func_proto bpf_timer_del_proto = {
+	.func		= bpf_timer_del,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_TIMER,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
@@ -1033,6 +1133,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ringbuf_query_proto;
 	case BPF_FUNC_for_each_map_elem:
 		return &bpf_for_each_map_elem_proto;
+	case BPF_FUNC_timer_init:
+		return &bpf_timer_init_proto;
+	case BPF_FUNC_timer_mod:
+		return &bpf_timer_mod_proto;
+	case BPF_FUNC_timer_del:
+		return &bpf_timer_del_proto;
 	default:
 		break;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9189eecb26dd..606c713be60a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4656,6 +4656,35 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno,
 	return 0;
 }
 
+static int process_timer_func(struct bpf_verifier_env *env, int regno,
+			      struct bpf_call_arg_meta *meta)
+{
+	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	bool is_const = tnum_is_const(reg->var_off);
+	struct bpf_map *map = reg->map_ptr;
+	u64 val = reg->var_off.value;
+
+	if (!is_const) {
+		verbose(env,
+			"R%d doesn't have constant offset. bpf_timer has to be at the constant offset\n",
+			regno);
+		return -EINVAL;
+	}
+	if (!map->btf) {
+		verbose(env, "map '%s' has to have BTF in order to use bpf_timer\n",
+			map->name);
+		return -EINVAL;
+	}
+	if (val) {
+		/* todo: relax this requirement */
+		verbose(env, "bpf_timer field can only be first in the map value element\n");
+		return -EINVAL;
+	}
+	WARN_ON(meta->map_ptr);
+	meta->map_ptr = map;
+	return 0;
+}
+
 static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
 {
 	return type == ARG_PTR_TO_MEM ||
@@ -4788,6 +4817,7 @@ static const struct bpf_reg_types percpu_btf_ptr_types = { .types = { PTR_TO_PER
 static const struct bpf_reg_types func_ptr_types = { .types = { PTR_TO_FUNC } };
 static const struct bpf_reg_types stack_ptr_types = { .types = { PTR_TO_STACK } };
 static const struct bpf_reg_types const_str_ptr_types = { .types = { PTR_TO_MAP_VALUE } };
+static const struct bpf_reg_types timer_types = { .types = { PTR_TO_MAP_VALUE } };
 
 static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
@@ -4819,6 +4849,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_FUNC]		= &func_ptr_types,
 	[ARG_PTR_TO_STACK_OR_NULL]	= &stack_ptr_types,
 	[ARG_PTR_TO_CONST_STR]		= &const_str_ptr_types,
+	[ARG_PTR_TO_TIMER]		= &timer_types,
 };
 
 static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
@@ -5000,6 +5031,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "verifier internal error\n");
 			return -EFAULT;
 		}
+	} else if (arg_type == ARG_PTR_TO_TIMER) {
+		if (process_timer_func(env, regno, meta))
+			return -EACCES;
 	} else if (arg_type == ARG_PTR_TO_FUNC) {
 		meta->subprogno = reg->subprogno;
 	} else if (arg_type_is_mem_ptr(arg_type)) {
@@ -5742,6 +5776,43 @@ static int set_map_elem_callback_state(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static int set_timer_init_callback_state(struct bpf_verifier_env *env,
+					 struct bpf_func_state *caller,
+					 struct bpf_func_state *callee,
+					 int insn_idx)
+{
+	struct bpf_insn_aux_data *insn_aux = &env->insn_aux_data[insn_idx];
+	struct bpf_map *map_ptr;
+
+	if (bpf_map_ptr_poisoned(insn_aux)) {
+		verbose(env, "bpf_timer_init abusing map_ptr\n");
+		return -EINVAL;
+	}
+
+	map_ptr = BPF_MAP_PTR(insn_aux->map_ptr_state);
+
+	/* bpf_timer_init(struct bpf_timer *timer, void *callback_fn, u64 flags);
+	 * callback_fn(struct bpf_map *map, void *key, void *value);
+	 */
+	callee->regs[BPF_REG_1].type = CONST_PTR_TO_MAP;
+	__mark_reg_known_zero(&callee->regs[BPF_REG_1]);
+	callee->regs[BPF_REG_1].map_ptr = map_ptr;
+
+	callee->regs[BPF_REG_2].type = PTR_TO_MAP_KEY;
+	__mark_reg_known_zero(&callee->regs[BPF_REG_2]);
+	callee->regs[BPF_REG_2].map_ptr = map_ptr;
+
+	callee->regs[BPF_REG_3].type = PTR_TO_MAP_VALUE;
+	__mark_reg_known_zero(&callee->regs[BPF_REG_3]);
+	callee->regs[BPF_REG_3].map_ptr = map_ptr;
+
+	/* unused */
+	__mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
+	__mark_reg_not_init(env, &callee->regs[BPF_REG_5]);
+	callee->in_callback_fn = true;
+	return 0;
+}
+
 static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 {
 	struct bpf_verifier_state *state = env->cur_state;
@@ -5837,6 +5908,7 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	    func_id != BPF_FUNC_map_pop_elem &&
 	    func_id != BPF_FUNC_map_peek_elem &&
 	    func_id != BPF_FUNC_for_each_map_elem &&
+	    func_id != BPF_FUNC_timer_init &&
 	    func_id != BPF_FUNC_redirect_map)
 		return 0;
 
@@ -6069,6 +6141,13 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 	}
 
+	if (func_id == BPF_FUNC_timer_init) {
+		err = __check_func_call(env, insn, insn_idx_p, meta.subprogno,
+					set_timer_init_callback_state);
+		if (err < 0)
+			return -EINVAL;
+	}
+
 	if (func_id == BPF_FUNC_snprintf) {
 		err = check_bpf_snprintf_call(env, regs);
 		if (err < 0)
@@ -12526,6 +12605,37 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
+		if (insn->imm == BPF_FUNC_timer_init) {
+
+			aux = &env->insn_aux_data[i + delta];
+			if (bpf_map_ptr_poisoned(aux)) {
+				verbose(env, "bpf_timer_init abusing map_ptr\n");
+				return -EINVAL;
+			}
+			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
+			{
+				struct bpf_insn ld_addrs[4] = {
+					BPF_LD_IMM64(BPF_REG_4, (long)map_ptr),
+					BPF_LD_IMM64(BPF_REG_5, (long)prog),
+				};
+
+				insn_buf[0] = ld_addrs[0];
+				insn_buf[1] = ld_addrs[1];
+				insn_buf[2] = ld_addrs[2];
+				insn_buf[3] = ld_addrs[3];
+			}
+			insn_buf[4] = *insn;
+			cnt = 5;
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			goto patch_call_imm;
+		}
 
 		/* BPF_EMIT_CALL() assumptions in some of the map_gen_lookup
 		 * and other inlining handlers are currently limited to 64 bit
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d2d7cf6cfe83..453a46c2d732 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1065,7 +1065,7 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_snprintf:
 		return &bpf_snprintf_proto;
 	default:
-		return NULL;
+		return bpf_base_func_proto(func_id);
 	}
 }
 
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 2d94025b38e9..00ac7b79cddb 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -547,6 +547,7 @@ COMMANDS
             'struct inode',
             'struct socket',
             'struct file',
+            'struct bpf_timer',
     ]
     known_types = {
             '...',
@@ -594,6 +595,7 @@ COMMANDS
             'struct inode',
             'struct socket',
             'struct file',
+            'struct bpf_timer',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 418b9b813d65..c95d7854d9fb 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4761,6 +4761,24 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
+ *	Description
+ *		Initialize the timer to call given static function.
+ *	Return
+ *		zero
+ *
+ * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
+ *	Description
+ *		Set the timer expiration N msecs from the current time.
+ *	Return
+ *		zero
+ *
+ * long bpf_timer_del(struct bpf_timer *timer)
+ *	Description
+ *		Deactivate the timer.
+ *	Return
+ *		zero
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4932,6 +4950,9 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(timer_init),			\
+	FN(timer_mod),			\
+	FN(timer_del),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -6038,6 +6059,10 @@ struct bpf_spin_lock {
 	__u32	val;
 };
 
+struct bpf_timer {
+	__u64 opaque;
+};
+
 struct bpf_sysctl {
 	__u32	write;		/* Sysctl is being read (= 0) or written (= 1).
 				 * Allows 1,2,4-byte read, but no write.
diff --git a/tools/testing/selftests/bpf/prog_tests/timer.c b/tools/testing/selftests/bpf/prog_tests/timer.c
new file mode 100644
index 000000000000..6b7a16a54e70
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/timer.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include "timer.skel.h"
+
+static int timer(struct timer *timer_skel)
+{
+	int err, prog_fd;
+	__u32 duration = 0, retval;
+
+	err = timer__attach(timer_skel);
+	if (!ASSERT_OK(err, "timer_attach"))
+		return err;
+
+	prog_fd = bpf_program__fd(timer_skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(timer_skel->data->callback_check, 52, "callback_check1");
+	usleep(50 * 1000); /* 10 msecs should be enough, but give it extra */
+	ASSERT_EQ(timer_skel->data->callback_check, 42, "callback_check2");
+
+	timer__detach(timer_skel);
+	return 0;
+}
+
+void test_timer(void)
+{
+	struct timer *timer_skel = NULL;
+	int err;
+
+	timer_skel = timer__open_and_load();
+	if (!ASSERT_OK_PTR(timer_skel, "timer_skel_load"))
+		goto cleanup;
+
+	err = timer(timer_skel);
+	ASSERT_OK(err, "timer");
+cleanup:
+	timer__destroy(timer_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/timer.c b/tools/testing/selftests/bpf/progs/timer.c
new file mode 100644
index 000000000000..2cf0634f10c9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/timer.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+struct map_elem {
+	struct bpf_timer timer;
+	int counter;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1000);
+	__type(key, int);
+	__type(value, struct map_elem);
+} hmap SEC(".maps");
+
+__u64 callback_check = 52;
+
+static int timer_cb(struct bpf_map *map, int *key, struct map_elem *val)
+{
+	callback_check--;
+	if (--val->counter)
+		/* re-arm the timer again to execute after 1 msec */
+		bpf_timer_mod(&val->timer, 1);
+	return 0;
+}
+
+int bpf_timer_test(void)
+{
+	struct map_elem *val;
+	int key = 0;
+
+	val = bpf_map_lookup_elem(&hmap, &key);
+	if (val) {
+		bpf_timer_init(&val->timer, timer_cb, 0);
+		bpf_timer_mod(&val->timer, 1);
+	}
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	struct map_elem val = {};
+	int key = 0;
+
+	val.counter = 10, /* number of times to trigger timer_cb */
+	bpf_map_update_elem(&hmap, &key, &val, 0);
+	return bpf_timer_test();
+}
-- 
2.30.2

