Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EDA2CA992
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 18:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgLARY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 12:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgLARYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 12:24:55 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D78C0613CF;
        Tue,  1 Dec 2020 09:24:14 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id r2so1528588pls.3;
        Tue, 01 Dec 2020 09:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S8l4sjPOYg9rXEcyAyEf6XtqYnJV0I5XG+0cw5t1rI=;
        b=AlHZg0M3u3gJp2Ywbb8cVfayPzCJ9eh/Yc3qbjSk1vtfTnTvZJOt45xzla8kvzYDV7
         n+LYd5eum217P1/RizSL4ssXrCDFj+M08TCnftjVXfJfykNjcNXBx5pMYq9tg99OmvYH
         rbZ88LlzsX0sdfLx2KM4BrU8cTJ6/VaqUKfri+mc8/jdhotxKnZUBMN5yjxFQ8w3cV9x
         cgKjCxJQZkB5PxoPcumCaWtoGTpkiLEVcoySIva9Zhn6huhVUxF9YLOEuEQDu4VLFPdS
         1FQnnwwVnzePZcxyTxGcIwFT8FcmyRFskA8ZYx42eFgGZO4KvzRYS2OmLiCDKGq4EPxE
         Bpnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S8l4sjPOYg9rXEcyAyEf6XtqYnJV0I5XG+0cw5t1rI=;
        b=n0fmvtXh7LyiLRaLUu+L71WqBy6ru0d3y9S0+v6W4OgRxNgxJCA/BATN6NaT82vpM3
         mtgaLYzmzWQaTDOiB3AyTFa8jGNShs12HyNx0unHer/a1FaOtTUO9UQTzJFuI1w3ag1B
         Jw8RLHLyXS2fJ45Y1TjnDppwPZXvM89AdpWeZ8PShT8BNtPuW8tXO5uKV4VRzTn2TAMq
         E38KSfRtIOQWtVxZU9Fo4F0LuvCdh12vV33vwdE/sD/9LNPBfRo1fsowqCgm68caOunE
         10bLYLvuvakd5uwFbR4U4NCaiVR+x30hmsq+RF/Mf04TL4tUbwBEquZq0xJijG1IjRrm
         vfZQ==
X-Gm-Message-State: AOAM531/0RreIPMOSF7Ub0s1ZLwBLJ6YxH27Xg4n1/+jDgGLZoXSMFSL
        0mdmChj4TP6+MFGF2xEuQsg=
X-Google-Smtp-Source: ABdhPJzpRdUyQIadmjlT+980Jpgg4KhPTHdFqxyzCOIOCWIkZyDUZhXeMuIM80iMYEpRPeSqcuiccQ==
X-Received: by 2002:a17:90a:5d17:: with SMTP id s23mr3822778pji.208.1606843454219;
        Tue, 01 Dec 2020 09:24:14 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id m204sm377778pfd.118.2020.12.01.09.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 09:24:13 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, hawk@kernel.org, kuba@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next] bpf, xdp: add bpf_redirect{,_map}() leaf node detection and optimization
Date:   Tue,  1 Dec 2020 18:23:45 +0100
Message-Id: <20201201172345.264053-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Teach the verifier to detect if all calls to bpf_redirect{,_map}() are
leaf nodes, i.e.:

  return bpf_redirect_map(...);
or
  ret = bpf_redirect_map(...);
  if (ret != 0)
     return ret;

If so, we can apply an optimization to the XDP path. Instead of
calling bpf_redirect_map() followed by xdp_do_redirect(), we simply
perform the work of xdp_do_redirect() from bpf_redirect_map(). By
doing so we can do fewer loads/stores/checks and save some cycles.

The XDP core will introspect the XDP program to check whether the
optimization can be performed, by checking the "redirect_opt" bit in
the bpf_prog structure.

The bpf_redirect_info structure is extended with some new members:
xdp_prog_redirect_opt and xdp. The xdp_prog_redirect_opt member is the
current program executing the helper. This is also used as a flag in
the XDP core to determine if the optimization is turned on. The xdp
member is the current xdp_buff/context executing.

The verifier detection is currently very simplistic, and aimed for
very simple XDP programs such as the libbpf AF_XDP XDP program. If BPF
tail calls or bpf2bpf calls are used, the optimization will be
disabled.

Performance up ~5% Mpps for the xdp_redirect_map and xdpsock samples,
and ~3% for bpf_redirect() programs.

An interesting extension would be to support an indirect jump
instruction/proper tail calls (only for helpers) in BPF, so the call
could be elided in favor for a jump.

Thanks to Maciej for the internal code review.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf_verifier.h |   3 ++
 include/linux/filter.h       |  30 +++++++++--
 kernel/bpf/verifier.c        |  68 ++++++++++++++++++++++++
 net/core/dev.c               |   2 +-
 net/core/filter.c            | 100 +++++++++++++++++++++++++++++++++--
 5 files changed, 195 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 306869d4743b..74e7e2f89251 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -423,6 +423,9 @@ struct bpf_verifier_env {
 	u32 peak_states;
 	/* longest register parentage chain walked for liveness marking */
 	u32 longest_mark_read_walk;
+	/* Are all leaf nodes redirect_map? */
+	bool all_leaves_redirect;
+	u32 redirect_call_cnt;
 };
 
 __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1b62397bd124..6509ced898a2 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -534,7 +534,8 @@ struct bpf_prog {
 				kprobe_override:1, /* Do we override a kprobe? */
 				has_callchain_buf:1, /* callchain buffer allocated? */
 				enforce_expected_attach_type:1, /* Enforce expected_attach_type checking at attach time */
-				call_get_stack:1; /* Do we call bpf_get_stack() or bpf_get_stackid() */
+				call_get_stack:1, /* Do we call bpf_get_stack() or bpf_get_stackid() */
+				redirect_opt:1; /* All bpf_redirect{,_map}() are leaf calls */
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
@@ -622,6 +623,8 @@ struct bpf_redirect_info {
 	struct bpf_map *map;
 	u32 kern_flags;
 	struct bpf_nh_params nh;
+	const struct bpf_prog *xdp_prog_redirect_opt;
+	struct xdp_buff *xdp;
 };
 
 DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
@@ -734,6 +737,13 @@ DECLARE_BPF_DISPATCHER(xdp)
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
+	if (prog->redirect_opt) {
+		struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+		ri->xdp_prog_redirect_opt = prog;
+		ri->xdp = xdp;
+	}
+
 	/* Caller needs to hold rcu_read_lock() (!), otherwise program
 	 * can be released while still running, or map elements could be
 	 * freed early while still having concurrent users. XDP fastpath
@@ -743,6 +753,11 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 }
 
+static __always_inline u32 bpf_prog_run_xdp_skb(const struct bpf_prog *prog, struct xdp_buff *xdp)
+{
+	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+}
+
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog);
 
 static inline u32 bpf_prog_insn_size(const struct bpf_prog *prog)
@@ -951,9 +966,16 @@ static inline int xdp_ok_fwd_dev(const struct net_device *fwd,
  */
 int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 			    struct xdp_buff *xdp, struct bpf_prog *prog);
-int xdp_do_redirect(struct net_device *dev,
-		    struct xdp_buff *xdp,
-		    struct bpf_prog *prog);
+int __xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp, struct bpf_prog *prog);
+static inline int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
+				  struct bpf_prog *prog)
+{
+	if (prog->redirect_opt)
+		return 0;
+
+	return __xdp_do_redirect(dev, xdp, prog);
+}
+
 void xdp_do_flush(void);
 
 /* The xdp_do_flush_map() helper has been renamed to drop the _map suffix, as
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e333ce43f281..9ede6f1bca37 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5032,6 +5032,58 @@ static int check_reference_leak(struct bpf_verifier_env *env)
 	return state->acquired_refs ? -EINVAL : 0;
 }
 
+static void check_redirect_opt(struct bpf_verifier_env *env, int func_id, int insn_idx)
+{
+	struct bpf_insn *insns = env->prog->insnsi;
+	int insn_cnt = env->prog->len;
+	struct bpf_insn *insn;
+	bool is_leaf = false;
+
+	if (!(func_id == BPF_FUNC_redirect || func_id == BPF_FUNC_redirect_map))
+		return;
+
+	/* Naive peephole leaf node checking */
+	insn_idx++;
+	if (insn_idx >= insn_cnt)
+		return;
+
+	insn = &insns[insn_idx];
+	switch (insn->code) {
+	/* Is the instruction following the call, an exit? */
+	case BPF_JMP | BPF_EXIT:
+		is_leaf = true;
+		break;
+	/* Follow the true branch of "if return value (r/w0) is not
+	 * zero", and look for exit.
+	 */
+	case BPF_JMP | BPF_JSGT | BPF_K:
+	case BPF_JMP32 | BPF_JSGT | BPF_K:
+	case BPF_JMP | BPF_JGT | BPF_K:
+	case BPF_JMP32 | BPF_JGT | BPF_K:
+	case BPF_JMP | BPF_JNE | BPF_K:
+	case BPF_JMP32 | BPF_JNE | BPF_K:
+		if (insn->dst_reg == BPF_REG_0 && insn->imm == 0) {
+			insn_idx += insn->off + 1;
+			if (insn_idx >= insn_cnt)
+				break;
+
+			insn = &insns[insn_idx];
+			is_leaf = insn->code == (BPF_JMP | BPF_EXIT);
+		}
+		break;
+	default:
+		break;
+	}
+
+	if (!env->redirect_call_cnt++) {
+		env->all_leaves_redirect = is_leaf;
+		return;
+	}
+
+	if (!is_leaf)
+		env->all_leaves_redirect = false;
+}
+
 static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn_idx)
 {
 	const struct bpf_func_proto *fn = NULL;
@@ -5125,6 +5177,8 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		}
 	}
 
+	check_redirect_opt(env, func_id, insn_idx);
+
 	regs = cur_regs(env);
 
 	/* check that flags argument in get_local_storage(map, flags) is 0,
@@ -11894,6 +11948,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	return 0;
 }
 
+static void validate_redirect_opt(struct bpf_verifier_env *env)
+{
+	if (env->subprog_cnt != 1)
+		return;
+
+	if (env->subprog_info[0].has_tail_call)
+		return;
+
+	env->prog->redirect_opt = env->all_leaves_redirect;
+}
+
 struct btf *bpf_get_btf_vmlinux(void)
 {
 	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
@@ -12092,6 +12157,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret == 0)
 		adjust_btf_func(env);
 
+	if (ret == 0)
+		validate_redirect_opt(env);
+
 err_release_maps:
 	if (!env->prog->aux->used_maps)
 		/* if we didn't copy map pointers into bpf_prog_info, release
diff --git a/net/core/dev.c b/net/core/dev.c
index 3b6b0e175fe7..d31f97ea955b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4654,7 +4654,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	rxqueue = netif_get_rxqueue(skb);
 	xdp->rxq = &rxqueue->xdp_rxq;
 
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	act = bpf_prog_run_xdp_skb(xdp_prog, xdp);
 
 	/* check if bpf_xdp_adjust_head was used */
 	off = xdp->data - orig_data;
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..f5a0d29aa272 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3981,8 +3981,8 @@ void bpf_clear_redirect_map(struct bpf_map *map)
 	}
 }
 
-int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
-		    struct bpf_prog *xdp_prog)
+int __xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
+		      struct bpf_prog *xdp_prog)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	struct bpf_map *map = READ_ONCE(ri->map);
@@ -4015,7 +4015,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
 	return err;
 }
-EXPORT_SYMBOL_GPL(xdp_do_redirect);
+EXPORT_SYMBOL_GPL(__xdp_do_redirect);
 
 static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
@@ -4091,6 +4091,36 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 	return err;
 }
 
+static u64 __bpf_xdp_redirect_opt(u32 index, struct bpf_redirect_info *ri)
+{
+	const struct bpf_prog *xdp_prog;
+	struct net_device *fwd, *dev;
+	struct xdp_buff *xdp;
+	int err;
+
+	xdp_prog = ri->xdp_prog_redirect_opt;
+	xdp = ri->xdp;
+	dev = xdp->rxq->dev;
+
+	ri->xdp_prog_redirect_opt = NULL;
+
+	fwd = dev_get_by_index_rcu(dev_net(dev), index);
+	if (unlikely(!fwd)) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	err = dev_xdp_enqueue(fwd, xdp, dev);
+	if (unlikely(err))
+		goto err;
+
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, NULL, index);
+	return XDP_REDIRECT;
+err:
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, NULL, index, err);
+	return XDP_ABORTED;
+}
+
 BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
@@ -4098,6 +4128,9 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 	if (unlikely(flags))
 		return XDP_ABORTED;
 
+	if (ri->xdp_prog_redirect_opt)
+		return __bpf_xdp_redirect_opt(ifindex, ri);
+
 	ri->flags = flags;
 	ri->tgt_index = ifindex;
 	ri->tgt_value = NULL;
@@ -4114,6 +4147,64 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
+static u64 __bpf_xdp_redirect_map_opt(struct bpf_map *map, u32 index, u64 flags,
+				      struct bpf_redirect_info *ri)
+{
+	const struct bpf_prog *xdp_prog;
+	struct net_device *dev;
+	struct xdp_buff *xdp;
+	void *val;
+	int err;
+
+	xdp_prog = ri->xdp_prog_redirect_opt;
+	xdp = ri->xdp;
+	dev = xdp->rxq->dev;
+
+	ri->xdp_prog_redirect_opt = NULL;
+
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_DEVMAP: {
+		val = __dev_map_lookup_elem(map, index);
+		if (unlikely(!val))
+			return flags;
+		err = dev_map_enqueue(val, xdp, dev);
+		break;
+	}
+	case BPF_MAP_TYPE_DEVMAP_HASH: {
+		val = __dev_map_hash_lookup_elem(map, index);
+		if (unlikely(!val))
+			return flags;
+		err = dev_map_enqueue(val, xdp, dev);
+		break;
+	}
+	case BPF_MAP_TYPE_CPUMAP: {
+		val = __cpu_map_lookup_elem(map, index);
+		if (unlikely(!val))
+			return flags;
+		err = cpu_map_enqueue(val, xdp, dev);
+		break;
+	}
+	case BPF_MAP_TYPE_XSKMAP: {
+		val = __xsk_map_lookup_elem(map, index);
+		if (unlikely(!val))
+			return flags;
+		err = __xsk_map_redirect(val, xdp);
+		break;
+	}
+	default:
+		return flags;
+	}
+
+	if (unlikely(err))
+		goto err;
+
+	_trace_xdp_redirect_map(dev, xdp_prog, val, map, index);
+	return XDP_REDIRECT;
+err:
+	_trace_xdp_redirect_map_err(dev, xdp_prog, val, map, index, err);
+	return XDP_ABORTED;
+}
+
 BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	   u64, flags)
 {
@@ -4123,6 +4214,9 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	if (unlikely(flags > XDP_TX))
 		return XDP_ABORTED;
 
+	if (ri->xdp_prog_redirect_opt)
+		return __bpf_xdp_redirect_map_opt(map, ifindex, flags, ri);
+
 	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
 	if (unlikely(!ri->tgt_value)) {
 		/* If the lookup fails we want to clear out the state in the

base-commit: ba0581749fec389e55c9d761f2716f8fcbefced5
-- 
2.27.0

