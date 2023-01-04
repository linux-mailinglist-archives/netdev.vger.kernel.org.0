Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254E565DF6B
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbjADWAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240319AbjADV74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:59:56 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A48913D67
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:59:55 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id k1-20020a17090a9d8100b00225af21197dso12877300pjp.1
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 13:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=awkKVapHYpsM9ESR7Zb3HZXykTE/u1nulzEDhYTUeos=;
        b=nBWxgIEr14IyxZkfasstHi/MO4b+Twt3bZgSqDYf4/XtLmV+XH6MX6wWgt/GXCPpH8
         kkwLH+NtqcddCffOwWhg1GXeAYeeRg5TxHTjp9mElpBsyzf9Z3UjiLKnvDXQGoM09KG3
         eqJaZ9u+jGOa3oEYywiT9Lyj9XicN/IFQ9uI8L6pySaOCL7VtstuPyYBItpioyUDrbAA
         /K0/CO4bzst9RdeKast3Eb4BKcw5vd1CQsizW8QO6oq1QLk2om9C9xo/tKbxpjg6fllw
         9LVKHYiVMD3tyQvlc+chp92XLIbHNW3kXK0Vg0fvdv20rVaHlNYUxFhaBv71LVOlVAZA
         Vamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=awkKVapHYpsM9ESR7Zb3HZXykTE/u1nulzEDhYTUeos=;
        b=MHpfEdhWl+0/FUsvjpegLxJV2QoMupqIN+TeJXIOudvqAqaiIR0bVRdGHJdpmqCDc1
         DQn3Wlzywt3X6MCExRNngo2rkrOoG0eiyWrhjwngjk3VKY7Tc9Ujygz8UNx9rKfAnn9T
         rUQeYgVrcsvxERKUcR060ylyL4CD8X6n/e5LtsFwsTuZwu8y8ByiY+geiHMI5GKobIWQ
         /dGzrm0EQnpS490gW5Dae+aYSMi0FPyneNSKqPVy5C4pPuSaasZbV5tkU5fVqsFCfGU6
         rIUm1+4ErPdaWvMSr6iSA5QVflcqqJYCe/qiT4l5M1OFn3AGIIzrMFVmgt9KF5eu1Pny
         Awug==
X-Gm-Message-State: AFqh2krDT7tpaA1O8sfbIS0BjVgl59Z+CKYTnmLT9DMdasges0+vG7i0
        T0xN7Yv/N5riwHmx4PtlittN3Z0=
X-Google-Smtp-Source: AMrXdXvY/6ftvIc28HG8iwXH1fU/mqQh5nACW2i0/n0CLim6zHGDcut2ejBaSA8i3baMcvFjTLty9OI=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:4086:b0:581:8afc:2a00 with SMTP id
 bw6-20020a056a00408600b005818afc2a00mr1912112pfb.76.1672869594456; Wed, 04
 Jan 2023 13:59:54 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:34 -0800
In-Reply-To: <20230104215949.529093-1-sdf@google.com>
Mime-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-3-sdf@google.com>
Subject: [PATCH bpf-next v6 02/17] bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF offloading infra will be reused to implement
bound-but-not-offloaded bpf programs. Rename existing
helpers for clarity. No functional changes.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf.h   |  8 ++++----
 kernel/bpf/core.c     |  4 ++--
 kernel/bpf/offload.c  |  4 ++--
 kernel/bpf/syscall.c  | 22 +++++++++++-----------
 kernel/bpf/verifier.c | 18 +++++++++---------
 net/core/dev.c        |  4 ++--
 net/core/filter.c     |  2 +-
 7 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1697bd87fc06..87eacbefda05 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2481,12 +2481,12 @@ void unpriv_ebpf_notify(int new_state);
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
 int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
 
-static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
+static inline bool bpf_prog_is_offloaded(const struct bpf_prog_aux *aux)
 {
 	return aux->offload_requested;
 }
 
-static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
+static inline bool bpf_map_is_offloaded(struct bpf_map *map)
 {
 	return unlikely(map->ops == &bpf_map_offload_ops);
 }
@@ -2513,12 +2513,12 @@ static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 	return -EOPNOTSUPP;
 }
 
-static inline bool bpf_prog_is_dev_bound(struct bpf_prog_aux *aux)
+static inline bool bpf_prog_is_offloaded(struct bpf_prog_aux *aux)
 {
 	return false;
 }
 
-static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
+static inline bool bpf_map_is_offloaded(struct bpf_map *map)
 {
 	return false;
 }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7f98dec6e90f..e9d64e26ef5b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2183,7 +2183,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	 * valid program, which in this case would simply not
 	 * be JITed, but falls back to the interpreter.
 	 */
-	if (!bpf_prog_is_dev_bound(fp->aux)) {
+	if (!bpf_prog_is_offloaded(fp->aux)) {
 		*err = bpf_prog_alloc_jited_linfo(fp);
 		if (*err)
 			return fp;
@@ -2554,7 +2554,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 #endif
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
-	if (bpf_prog_is_dev_bound(aux))
+	if (bpf_prog_is_offloaded(aux))
 		bpf_prog_offload_destroy(aux->prog);
 #ifdef CONFIG_PERF_EVENTS
 	if (aux->prog->has_callchain_buf)
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 13e4efc971e6..f5769a8ecbee 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -549,7 +549,7 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 	struct bpf_offload_netdev *ondev1, *ondev2;
 	struct bpf_prog_offload *offload;
 
-	if (!bpf_prog_is_dev_bound(prog->aux))
+	if (!bpf_prog_is_offloaded(prog->aux))
 		return false;
 
 	offload = prog->aux->offload;
@@ -581,7 +581,7 @@ bool bpf_offload_prog_map_match(struct bpf_prog *prog, struct bpf_map *map)
 	struct bpf_offloaded_map *offmap;
 	bool ret;
 
-	if (!bpf_map_is_dev_bound(map))
+	if (!bpf_map_is_offloaded(map))
 		return bpf_map_offload_neutral(map);
 	offmap = map_to_offmap(map);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8e55456bd648..5f7eac057cdc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -181,7 +181,7 @@ static int bpf_map_update_value(struct bpf_map *map, struct file *map_file,
 	int err;
 
 	/* Need to create a kthread, thus must support schedule */
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		return bpf_map_offload_update_elem(map, key, value, flags);
 	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
 		   map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
@@ -238,7 +238,7 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 	void *ptr;
 	int err;
 
-	if (bpf_map_is_dev_bound(map))
+	if (bpf_map_is_offloaded(map))
 		return bpf_map_offload_lookup_elem(map, key, value);
 
 	bpf_disable_instrumentation();
@@ -1483,7 +1483,7 @@ static int map_delete_elem(union bpf_attr *attr, bpfptr_t uattr)
 		goto err_put;
 	}
 
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		err = bpf_map_offload_delete_elem(map, key);
 		goto out;
 	} else if (IS_FD_PROG_ARRAY(map) ||
@@ -1547,7 +1547,7 @@ static int map_get_next_key(union bpf_attr *attr)
 	if (!next_key)
 		goto free_key;
 
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		err = bpf_map_offload_get_next_key(map, key, next_key);
 		goto out;
 	}
@@ -1605,7 +1605,7 @@ int generic_map_delete_batch(struct bpf_map *map,
 				   map->key_size))
 			break;
 
-		if (bpf_map_is_dev_bound(map)) {
+		if (bpf_map_is_offloaded(map)) {
 			err = bpf_map_offload_delete_elem(map, key);
 			break;
 		}
@@ -1851,7 +1851,7 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 		   map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 		   map->map_type == BPF_MAP_TYPE_LRU_HASH ||
 		   map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
-		if (!bpf_map_is_dev_bound(map)) {
+		if (!bpf_map_is_offloaded(map)) {
 			bpf_disable_instrumentation();
 			rcu_read_lock();
 			err = map->ops->map_lookup_and_delete_elem(map, key, value, attr->flags);
@@ -1944,7 +1944,7 @@ static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog)
 	if (!ops)
 		return -EINVAL;
 
-	if (!bpf_prog_is_dev_bound(prog->aux))
+	if (!bpf_prog_is_offloaded(prog->aux))
 		prog->aux->ops = ops;
 	else
 		prog->aux->ops = &bpf_offload_prog_ops;
@@ -2255,7 +2255,7 @@ bool bpf_prog_get_ok(struct bpf_prog *prog,
 
 	if (prog->type != *attach_type)
 		return false;
-	if (bpf_prog_is_dev_bound(prog->aux) && !attach_drv)
+	if (bpf_prog_is_offloaded(prog->aux) && !attach_drv)
 		return false;
 
 	return true;
@@ -2598,7 +2598,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	atomic64_set(&prog->aux->refcnt, 1);
 	prog->gpl_compatible = is_gpl ? 1 : 0;
 
-	if (bpf_prog_is_dev_bound(prog->aux)) {
+	if (bpf_prog_is_offloaded(prog->aux)) {
 		err = bpf_prog_offload_init(prog, attr);
 		if (err)
 			goto free_prog_sec;
@@ -3997,7 +3997,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 			return -EFAULT;
 	}
 
-	if (bpf_prog_is_dev_bound(prog->aux)) {
+	if (bpf_prog_is_offloaded(prog->aux)) {
 		err = bpf_prog_offload_info_fill(&info, prog);
 		if (err)
 			return err;
@@ -4225,7 +4225,7 @@ static int bpf_map_get_info_by_fd(struct file *file,
 	}
 	info.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
 
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		err = bpf_map_offload_info_fill(&info, map);
 		if (err)
 			return err;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4a25375ebb0d..095b55989660 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13817,7 +13817,7 @@ static int do_check(struct bpf_verifier_env *env)
 			env->prev_log_len = env->log.len_used;
 		}
 
-		if (bpf_prog_is_dev_bound(env->prog->aux)) {
+		if (bpf_prog_is_offloaded(env->prog->aux)) {
 			err = bpf_prog_offload_verify_insn(env, env->insn_idx,
 							   env->prev_insn_idx);
 			if (err)
@@ -14297,7 +14297,7 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
 		}
 	}
 
-	if ((bpf_prog_is_dev_bound(prog->aux) || bpf_map_is_dev_bound(map)) &&
+	if ((bpf_prog_is_offloaded(prog->aux) || bpf_map_is_offloaded(map)) &&
 	    !bpf_offload_prog_map_match(prog, map)) {
 		verbose(env, "offload device mismatch between prog and map\n");
 		return -EINVAL;
@@ -14778,7 +14778,7 @@ static int verifier_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
 	unsigned int orig_prog_len = env->prog->len;
 	int err;
 
-	if (bpf_prog_is_dev_bound(env->prog->aux))
+	if (bpf_prog_is_offloaded(env->prog->aux))
 		bpf_prog_offload_remove_insns(env, off, cnt);
 
 	err = bpf_remove_insns(env->prog, off, cnt);
@@ -14859,7 +14859,7 @@ static void opt_hard_wire_dead_code_branches(struct bpf_verifier_env *env)
 		else
 			continue;
 
-		if (bpf_prog_is_dev_bound(env->prog->aux))
+		if (bpf_prog_is_offloaded(env->prog->aux))
 			bpf_prog_offload_replace_insn(env, i, &ja);
 
 		memcpy(insn, &ja, sizeof(ja));
@@ -15046,7 +15046,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		}
 	}
 
-	if (bpf_prog_is_dev_bound(env->prog->aux))
+	if (bpf_prog_is_offloaded(env->prog->aux))
 		return 0;
 
 	insn = env->prog->insnsi + delta;
@@ -15446,7 +15446,7 @@ static int fixup_call_args(struct bpf_verifier_env *env)
 	int err = 0;
 
 	if (env->prog->jit_requested &&
-	    !bpf_prog_is_dev_bound(env->prog->aux)) {
+	    !bpf_prog_is_offloaded(env->prog->aux)) {
 		err = jit_subprogs(env);
 		if (err == 0)
 			return 0;
@@ -16933,7 +16933,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 	if (ret < 0)
 		goto skip_full_check;
 
-	if (bpf_prog_is_dev_bound(env->prog->aux)) {
+	if (bpf_prog_is_offloaded(env->prog->aux)) {
 		ret = bpf_prog_offload_verifier_prep(env->prog);
 		if (ret)
 			goto skip_full_check;
@@ -16946,7 +16946,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 	ret = do_check_subprogs(env);
 	ret = ret ?: do_check_main(env);
 
-	if (ret == 0 && bpf_prog_is_dev_bound(env->prog->aux))
+	if (ret == 0 && bpf_prog_is_offloaded(env->prog->aux))
 		ret = bpf_prog_offload_finalize(env);
 
 skip_full_check:
@@ -16981,7 +16981,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 	/* do 32-bit optimization after insn patching has done so those patched
 	 * insns could be handled correctly.
 	 */
-	if (ret == 0 && !bpf_prog_is_dev_bound(env->prog->aux)) {
+	if (ret == 0 && !bpf_prog_is_offloaded(env->prog->aux)) {
 		ret = opt_subreg_zext_lo32_rnd_hi32(env, attr);
 		env->prog->aux->verifier_zext = bpf_jit_needs_zext() ? !ret
 								     : false;
diff --git a/net/core/dev.c b/net/core/dev.c
index b76fb37b381e..7d31c57ddd7e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9224,8 +9224,8 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
-		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
-			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
+		if (!offload && bpf_prog_is_offloaded(new_prog->aux)) {
+			NL_SET_ERR_MSG(extack, "Using offloaded program without HW_MODE flag is not supported");
 			return -EINVAL;
 		}
 		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
diff --git a/net/core/filter.c b/net/core/filter.c
index c746e4d77214..6579ddd20325 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8731,7 +8731,7 @@ static bool xdp_is_valid_access(int off, int size,
 	}
 
 	if (type == BPF_WRITE) {
-		if (bpf_prog_is_dev_bound(prog->aux)) {
+		if (bpf_prog_is_offloaded(prog->aux)) {
 			switch (off) {
 			case offsetof(struct xdp_md, rx_queue_index):
 				return __is_valid_xdp_access(off, size);
-- 
2.39.0.314.g84b9a713c41-goog

