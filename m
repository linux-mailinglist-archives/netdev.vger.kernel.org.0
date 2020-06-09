Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854D41F4228
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731730AbgFIR0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgFIR0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:26:42 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8ECC05BD1E;
        Tue,  9 Jun 2020 10:26:42 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id n9so8312692plk.1;
        Tue, 09 Jun 2020 10:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xdiuyaT4q5ifNZgwkk2eoy6a+eyBMSIgKVWGTekNeNI=;
        b=abdFKGlsVSDGF7HKzBIdGCAbqWpxQbcToJGapD2DGn4SvXoaqIA9HobdTvtxaM6WpX
         HNJGlcLoyRvtm9cCspC4awzoRUMnRRjGqTa1P90A+6NGeL6nZSLyawsObKwYXHuBhMnI
         HNvcGyHIho1qtAkXjUqyhljzImalb3ernVzJQBdmOJ1GxVITbNiOWy5V6NbL3PHW7KcR
         DwdMY0fZHGuwfxannCpVnmZ/IpP4idbbMd8R0XAGdLDRkMqVx3XsNDMboclLjYMTEzTG
         MTxS/D0fDOhTLiSIO9zAKuBvpHNIdiqVK3upql6H9D8/ilGXVUZQmJ4LgYR4kbL4v8KV
         aTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xdiuyaT4q5ifNZgwkk2eoy6a+eyBMSIgKVWGTekNeNI=;
        b=t3CXpcJz/ICyh0ryMZyqQa7ObjvMojdNN1foCJakQcRRcfNY18NtOYPWAYQLZmz/9t
         C7xNp24Ig0RE9DanUkOaVr3SIVb3R5coywVYqR63PuSfJ3PYnU2SX2Cpa1/pPKbiFlPC
         VPWpZCEEmC11U8salhZBqTPRty5NB0qqvPjSX2wUTn46Gtg8Q9Uu9Y59E01S68K/stfv
         T4ir5/eZW342LL+K+YaNIw8ym+pbLurCeQTuiW80QlMMOz1QvkmVyevfrCGmzjRGC2rQ
         qy/J32B+pRecnoNDeoHBsJrKBOLPG1IpfgFq6u7l+pJKESn2wnI9B359+RzQjL7sVGR+
         Fiig==
X-Gm-Message-State: AOAM533lBQBB45hEkqAl74QOICLuHp8oFhWamcIekEOUYR4VpnuYpPED
        y/3Fq24S23IEXRo/BXo+Kvc=
X-Google-Smtp-Source: ABdhPJwpB0ergjxQdCAtFDzwLdPg9G0RMr3TWW+1niPB5PmV37mAljEBYSAnWROjMsvVs2qe2jzJWA==
X-Received: by 2002:a17:90a:7401:: with SMTP id a1mr5683557pjg.218.1591723601635;
        Tue, 09 Jun 2020 10:26:41 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id w190sm10390387pfw.35.2020.06.09.10.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 10:26:40 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        john.fastabend@gmail.com, toke@redhat.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        brouer@redhat.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next 1/2] bpf, xdp: add naive bpf_redirect_map() tail call detection
Date:   Tue,  9 Jun 2020 19:26:21 +0200
Message-Id: <20200609172622.37990-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200609172622.37990-1-bjorn.topel@gmail.com>
References: <20200609172622.37990-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The bpf_redirect_map() BPF helper is used to redirect a packet to the
endpoint referenced by a map element. Currently, there is no
restrictment how the helper is called, e.g.

  ret = bpf_redirect_map(...);
  ...
  ret = bpf_redirect_map(...);
  ... // e.g. modify packet
  return ret;

is a valid, albeit weird, program.

The unconstrained nature of BPF (redirect) helpers has implications
for the implementation of the XDP_REDIRECT call. Today, the redirect
flow for a packet is along the lines of:

  for_each_packet() {
    act = bpf_prog_run_xdp(xdp_prog, xdp); // does bpf_redirect_map() call
    if (act == XDP_REDIRECT)
      ret = xdp_do_redirect(...);
  }
  xdp_do_flush();

The bpf_redirect_map() helper populates a per-cpu structure, which is
picked up by the xdp_do_redirect() function that also performs the
redirect action.

What if the verifier could detect that certain programs have certain
constraints, so the functiontionality performed by xdp_do_redirect()
could be done directly from bpf_redirect_map()?

Here, the verifier is taught to detect program where all
bpf_redirect_map() calls, are tail calls. If a function call is a last
action performed in another function, it is said to be a tail call --
not to be confused with the BPF tail call helper.

This implementation is just a PoC, and not complete. It manages to
detect tail calls by a naive peephole scheme.

For the following program (the built in AF_XDP libbpf program):

  ...
  call bpf_redirect_map
  if w0 != 0 goto pc+X (goto exit)
  ...
  call bpf_redirect_map
  exit

the verifier detects that all calls are tail calls.

TODO:
 * Stateful tail call detection, instead of the current peephole one.
 * Add all helpers capable of returning XDP_REDIRECT, and not just
   bpf_redirect_map().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf_verifier.h |  2 ++
 include/linux/filter.h       | 19 +++++++++++-
 kernel/bpf/verifier.c        | 53 +++++++++++++++++++++++++++++++++
 net/core/filter.c            | 57 ++++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index ca08db4ffb5f..e41fd9264c94 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -411,6 +411,8 @@ struct bpf_verifier_env {
 	u32 peak_states;
 	/* longest register parentage chain walked for liveness marking */
 	u32 longest_mark_read_walk;
+	bool all_redirect_map_tail;
+	u32 redirect_map_call_cnt;
 };
 
 __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 259377723603..cdbc2ca8db4f 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -534,7 +534,8 @@ struct bpf_prog {
 				is_func:1,	/* program is a bpf function */
 				kprobe_override:1, /* Do we override a kprobe? */
 				has_callchain_buf:1, /* callchain buffer allocated? */
-				enforce_expected_attach_type:1; /* Enforce expected_attach_type checking at attach time */
+				enforce_expected_attach_type:1, /* Enforce expected_attach_type checking at attach time */
+				redirect_tail_call:1;
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
@@ -613,6 +614,9 @@ struct bpf_redirect_info {
 	void *tgt_value;
 	struct bpf_map *map;
 	u32 kern_flags;
+	struct bpf_prog *xdp_prog_redirect_tailcall; // if !NULL, we can do "everything" from BPF context.
+	struct xdp_buff *xdp;
+	struct net_device *dev;
 };
 
 DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
@@ -620,6 +624,19 @@ DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
 /* flags for bpf_redirect_info kern_flags */
 #define BPF_RI_F_RF_NO_DIRECT	BIT(0)	/* no napi_direct on return_frame */
 
+
+static inline void xdp_set_redirect_tailcall(struct bpf_prog *xdp_prog,
+					     struct xdp_buff *xdp,
+					     struct net_device *dev)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	ri->xdp_prog_redirect_tailcall = xdp_prog;
+	ri->xdp = xdp;
+	ri->dev = dev;
+}
+
+
 /* Compute the linear packet data range [data, data_end) which
  * will be accessed by various program types (cls_bpf, act_bpf,
  * lwt, ...). Subsystems allowing direct data access must (!)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5c7bbaac81ef..27a4fd5c8b8b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4594,6 +4594,54 @@ static int check_reference_leak(struct bpf_verifier_env *env)
 	return state->acquired_refs ? -EINVAL : 0;
 }
 
+static void check_redirect_map_tail_call(struct bpf_verifier_env *env, int func_id,
+					 int insn_idx)
+{
+	struct bpf_insn *insns = env->prog->insnsi;
+	int insn_cnt = env->prog->len;
+	bool is_tail_call = false;
+	struct bpf_insn *insn;
+
+	if (func_id != 	BPF_FUNC_redirect_map)
+		return;
+
+	/* Naive peephole tail call checking */
+	insn_idx++;
+again:
+	if (insn_idx >= insn_cnt)
+		goto out;
+
+	insn = &insns[insn_idx];
+	insn_idx++;
+
+	switch (insn->code) {
+	/* 1. Is the instruction following the call, an exit? */
+	case BPF_JMP | BPF_EXIT:
+		is_tail_call = true;
+		break;
+	/* 2. True branch of "if w0 != 0 goto pc+X", an exit? */
+	case BPF_JMP | BPF_JSGT | BPF_K:
+	case BPF_JMP32 | BPF_JSGT | BPF_K:
+		if (insn->dst_reg == BPF_REG_0 && insn->imm == 0) {
+			insn_idx += insn->off;
+			goto again;
+		}
+		break;
+	/* 3... more checks. XXX */
+	default:
+		break;
+	}
+
+out:
+	if (!env->redirect_map_call_cnt++) {
+		env->all_redirect_map_tail = is_tail_call;
+		return;
+	}
+
+	if (!is_tail_call)
+		env->all_redirect_map_tail = false;
+}
+
 static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn_idx)
 {
 	const struct bpf_func_proto *fn = NULL;
@@ -4685,6 +4733,8 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		}
 	}
 
+	check_redirect_map_tail_call(env, func_id, insn_idx);
+
 	regs = cur_regs(env);
 
 	/* check that flags argument in get_local_storage(map, flags) is 0,
@@ -11064,6 +11114,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret == 0)
 		adjust_btf_func(env);
 
+	if (ret == 0)
+		env->prog->redirect_tail_call = env->all_redirect_map_tail;
+
 err_release_maps:
 	if (!env->prog->aux->used_maps)
 		/* if we didn't copy map pointers into bpf_prog_info, release
diff --git a/net/core/filter.c b/net/core/filter.c
index d01a244b5087..8cd8dee9359a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3701,6 +3701,60 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
+static u64 __bpf_xdp_redirect_map_tailcall(struct bpf_map *map, u32 index,
+					   u64 flags,
+					   struct bpf_redirect_info *ri)
+{
+	struct xdp_buff *xdp = ri->xdp;
+	struct net_device *d = ri->dev;
+	struct bpf_prog *xdp_prog;
+	void *val;
+	int err;
+
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_DEVMAP: {
+		val = __dev_map_lookup_elem(map, index);
+		if (unlikely(!val))
+			return flags;
+		err = dev_map_enqueue(val, xdp, d);
+		break;
+	}
+	case BPF_MAP_TYPE_DEVMAP_HASH: {
+		val = __dev_map_hash_lookup_elem(map, index);
+		if (unlikely(!val))
+			return flags;
+		err = dev_map_enqueue(val, xdp, d);
+		break;
+	}
+	case BPF_MAP_TYPE_CPUMAP: {
+		val = __cpu_map_lookup_elem(map, index);
+		if (unlikely(!val))
+			return flags;
+		err = cpu_map_enqueue(val, xdp, d);
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
+	xdp_prog = ri->xdp_prog_redirect_tailcall;
+	if (unlikely(err))
+		goto err;
+
+	_trace_xdp_redirect_map(d, xdp_prog, val, map, index);
+	return XDP_REDIRECT;
+err:
+	_trace_xdp_redirect_map_err(d, xdp_prog, val, map, index, err);
+	return XDP_DROP;
+}
+
 BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	   u64, flags)
 {
@@ -3710,6 +3764,9 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	if (unlikely(flags > XDP_TX))
 		return XDP_ABORTED;
 
+	if (ri->xdp_prog_redirect_tailcall)
+		return __bpf_xdp_redirect_map_tailcall(map, ifindex, flags, ri);
+
 	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
 	if (unlikely(!ri->tgt_value)) {
 		/* If the lookup fails we want to clear out the state in the
-- 
2.25.1

