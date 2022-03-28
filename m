Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC41B4E9ECC
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245159AbiC1SSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245144AbiC1SSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:18:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327F25371C
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h16-20020a056902009000b00628a70584b2so11393108ybs.6
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=apmS/pMYUkmq6PPWy8yNQ4sW3lnxeuNzZj/ipaC9M2Y=;
        b=FyQNRwfbcR72mLMFAmmjTpT6d6zPli0AlSM7N7ncsFHZKrpDKcHlfmmbCy9/eC1kIE
         CGcYX04C6COevbzQ5WcFWiwbWbz8Vznj6VNGXIZOesV08yX10FkIW3qaYX66YcMPR7xy
         PukuUa6nR/Y3RMWvPCvqxbrwUIFhZic9TrtwfHHAP3drG722CoJyLnSuOgEzBCLJJyn4
         XMh0clemhm/GKwyD9Gzj7crpsiHY39rpmgM5fW3qJNSVldXIZcEFygOVxmhOzBYdKE57
         gELI0HrjFolDbWsPV9eFcgegcCR6rpfQfHO1yklLph9c3nlSRhXjNmlvf3AoqB+e4KNn
         cH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=apmS/pMYUkmq6PPWy8yNQ4sW3lnxeuNzZj/ipaC9M2Y=;
        b=S+xBalmFu0q9uo+4S3/4d1kwsxgGrgJpNwv26fhQXbbi40c798rDy86L47Zf9gWWgf
         oZk4o7aqul0VR+exIYBGU27t9hMvCuf6kip9DuxKuMRCo8J4SiFkchS6OBYLB3EM9QXG
         /lOjP/mS2FNkA/2x1wMjLEU+AleLSF1e4wH+e7+85eg7PWNu+P++VrqzF8u8MUOfhgSk
         BKZnfOE7738lWPaYJqTvzbRj54o1AR5Mi6UIGweweK/qinRaqk/M+hohCUSz+kpULvAL
         itaPqrX4npp83jzkO4gwNYIyAlNYMm4a3VA8lXpVp+MX+htnm3QfLyW1aXvle/PiAtVY
         /5hw==
X-Gm-Message-State: AOAM530mCOul+bzfUYrVwzy4nqxjrdk6W/Dtkkvbt8oub3IPpuk17amL
        dg9718AUsj1PAntwjHngTPeGWcBitmUkXA7vCeSNj9kX7kVEJylMN2KrsUcGcrBWAkkhZMOnpMT
        V49NFv9Pt+Sv0FDDuL6xoundMBWRSvoeDJLDO01tFAvwP6idSs/NNlQ==
X-Google-Smtp-Source: ABdhPJzDnmNtZ6i5pl2eW7uCwckigeFN3NUTzcH5bD3MQu7CZBuE+JgDE6E+TXAR130UcmPcFhTqEVg=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a900:e0f6:cf98:d8c8])
 (user=sdf job=sendgmr) by 2002:a5b:803:0:b0:633:749f:9acd with SMTP id
 x3-20020a5b0803000000b00633749f9acdmr24317084ybp.236.1648491411327; Mon, 28
 Mar 2022 11:16:51 -0700 (PDT)
Date:   Mon, 28 Mar 2022 11:16:39 -0700
In-Reply-To: <20220328181644.1748789-1-sdf@google.com>
Message-Id: <20220328181644.1748789-3-sdf@google.com>
Mime-Version: 1.0
References: <20220328181644.1748789-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH bpf-next 2/7] bpf: per-cgroup lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow attaching to lsm hooks in the cgroup context.

Attaching to per-cgroup LSM works exactly like attaching
to other per-cgroup hooks. New BPF_LSM_CGROUP is added
to trigger new mode; the actual lsm hook we attach to is
signaled via existing attach_btf_id.

For the hooks that have 'struct socket' as its first argument,
we use the cgroup associated with that socket. For the rest,
we use 'current' cgroup (this is all on default hierarchy == v2 only).
Note that for the hooks that work on 'struct sock' we still
take the cgroup from 'current' because most of the time,
the 'sock' argument is not properly initialized.

Behind the scenes, we allocate a shim program that is attached
to the trampoline and runs cgroup effective BPF programs array.
This shim has some rudimentary ref counting and can be shared
between several programs attaching to the same per-cgroup lsm hook.

Note that this patch bloats cgroup size because we add 211
cgroup_bpf_attach_type(s) for simplicity sake. This will be
addressed in the subsequent patch.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup-defs.h |   6 ++
 include/linux/bpf.h             |  14 ++++
 include/linux/bpf_lsm.h         |  14 ++++
 include/uapi/linux/bpf.h        |   1 +
 kernel/bpf/bpf_lsm.c            |  92 ++++++++++++++++++++
 kernel/bpf/btf.c                |  11 +++
 kernel/bpf/cgroup.c             | 102 +++++++++++++++++++---
 kernel/bpf/syscall.c            |  10 +++
 kernel/bpf/trampoline.c         | 144 ++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c           |   1 +
 tools/include/uapi/linux/bpf.h  |   1 +
 11 files changed, 384 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 695d1224a71b..6c661b4df9fa 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -10,6 +10,8 @@
 
 struct bpf_prog_array;
 
+#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
+
 enum cgroup_bpf_attach_type {
 	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
 	CGROUP_INET_INGRESS = 0,
@@ -35,6 +37,10 @@ enum cgroup_bpf_attach_type {
 	CGROUP_INET4_GETSOCKNAME,
 	CGROUP_INET6_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
+#ifdef CONFIG_BPF_LSM
+	CGROUP_LSM_START,
+	CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
+#endif
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 487aba40ce52..4e517ec51d65 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -807,6 +807,9 @@ static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 #ifdef CONFIG_BPF_JIT
 int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+				    struct bpf_attach_target_info *tgt_info);
+void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
@@ -865,6 +868,15 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
 {
 	return -ENOTSUPP;
 }
+static inline int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+						  struct bpf_attach_target_info *tgt_info)
+{
+	return -EOPNOTSUPP;
+}
+static inline void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
 static inline struct bpf_trampoline *bpf_trampoline_get(u64 key,
 							struct bpf_attach_target_info *tgt_info)
 {
@@ -980,6 +992,7 @@ struct bpf_prog_aux {
 	u64 load_time; /* ns since boottime */
 	u32 verified_insns;
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
+	int cgroup_atype; /* enum cgroup_bpf_attach_type */
 	char name[BPF_OBJ_NAME_LEN];
 #ifdef CONFIG_SECURITY
 	void *security;
@@ -2383,6 +2396,7 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len);
 
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
+int btf_id_set_index(const struct btf_id_set *set, u32 id);
 
 #define MAX_BPRINTF_VARARGS		12
 
diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 479c101546ad..7f0e59f5f9be 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -42,6 +42,9 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
 extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
 void bpf_inode_storage_free(struct inode *inode);
 
+int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
+int bpf_lsm_hook_idx(u32 btf_id);
+
 #else /* !CONFIG_BPF_LSM */
 
 static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
@@ -65,6 +68,17 @@ static inline void bpf_inode_storage_free(struct inode *inode)
 {
 }
 
+static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
+					   bpf_func_t *bpf_func)
+{
+	return -ENOENT;
+}
+
+static inline int bpf_lsm_hook_idx(u32 btf_id)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_BPF_LSM */
 
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d14b10b85e51..bbe48a2dd852 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -998,6 +998,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_TRACE_KPROBE_MULTI,
+	BPF_LSM_CGROUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 064eccba641d..7e4c2a4999de 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -35,6 +35,98 @@ BTF_SET_START(bpf_lsm_hooks)
 #undef LSM_HOOK
 BTF_SET_END(bpf_lsm_hooks)
 
+static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
+						const struct bpf_insn *insn)
+{
+	const struct bpf_prog *prog;
+	struct socket *sock;
+	struct cgroup *cgrp;
+	struct sock *sk;
+	int ret = 0;
+	u64 *regs;
+
+	regs = (u64 *)ctx;
+	sock = (void *)regs[BPF_REG_0];
+	/*prog = container_of(insn, struct bpf_prog, insnsi);*/
+	prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
+
+	if (unlikely(!sock))
+		return 0;
+
+	sk = sock->sk;
+	if (unlikely(!sk))
+		return 0;
+
+	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	if (likely(cgrp))
+		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
+					    ctx, bpf_prog_run, 0);
+	return ret;
+}
+
+static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
+						 const struct bpf_insn *insn)
+{
+	const struct bpf_prog *prog;
+	struct cgroup *cgrp;
+	int ret = 0;
+
+	if (unlikely(!current))
+		return 0;
+
+	/*prog = container_of(insn, struct bpf_prog, insnsi);*/
+	prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
+
+	rcu_read_lock();
+	cgrp = task_dfl_cgroup(current);
+	if (likely(cgrp))
+		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
+					    ctx, bpf_prog_run, 0);
+	rcu_read_unlock();
+	return ret;
+}
+
+int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
+			     bpf_func_t *bpf_func)
+{
+	const struct btf_type *first_arg_type;
+	const struct btf_type *sock_type;
+	const struct btf *btf_vmlinux;
+	const struct btf_param *args;
+	s32 type_id;
+
+	if (!prog->aux->attach_func_proto ||
+	    !btf_type_is_func_proto(prog->aux->attach_func_proto))
+		return -EINVAL;
+
+	if (btf_type_vlen(prog->aux->attach_func_proto) < 1)
+		return -EINVAL;
+
+	args = (const struct btf_param *)(prog->aux->attach_func_proto + 1);
+
+	btf_vmlinux = bpf_get_btf_vmlinux();
+	if (!btf_vmlinux)
+		return -EINVAL;
+
+	type_id = btf_find_by_name_kind(btf_vmlinux, "socket", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	sock_type = btf_type_by_id(btf_vmlinux, type_id);
+
+	first_arg_type = btf_type_resolve_ptr(btf_vmlinux, args[0].type, NULL);
+	if (first_arg_type == sock_type)
+		*bpf_func = __cgroup_bpf_run_lsm_socket;
+	else
+		*bpf_func = __cgroup_bpf_run_lsm_current;
+
+	return 0;
+}
+
+int bpf_lsm_hook_idx(u32 btf_id)
+{
+	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
+}
+
 int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 			const struct bpf_prog *prog)
 {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 24788ce564a0..dfe2f5402e8c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4971,6 +4971,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 	if (arg == nr_args) {
 		switch (prog->expected_attach_type) {
+		case BPF_LSM_CGROUP:
 		case BPF_LSM_MAC:
 		case BPF_TRACE_FEXIT:
 			/* When LSM programs are attached to void LSM hooks
@@ -6396,6 +6397,16 @@ static int btf_id_cmp_func(const void *a, const void *b)
 	return *pa - *pb;
 }
 
+int btf_id_set_index(const struct btf_id_set *set, u32 id)
+{
+	const u32 *p;
+
+	p = bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func);
+	if (!p)
+		return -1;
+	return p - set->ids;
+}
+
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 {
 	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 128028efda64..8fa70bc2aaf7 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -14,6 +14,9 @@
 #include <linux/string.h>
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/btf_ids.h>
+#include <linux/bpf_lsm.h>
+#include <linux/bpf_verifier.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
 
@@ -89,6 +92,14 @@ static void bpf_cgroup_storages_link(struct bpf_cgroup_storage *storages[],
 		bpf_cgroup_storage_link(storages[stype], cgrp, attach_type);
 }
 
+static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype)
+		bpf_cgroup_storage_unlink(storages[stype]);
+}
+
 /* Called when bpf_cgroup_link is auto-detached from dying cgroup.
  * It drops cgroup and bpf_prog refcounts, and marks bpf_link as defunct. It
  * doesn't free link memory, which will eventually be done by bpf_link's
@@ -100,6 +111,15 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
 	link->cgroup = NULL;
 }
 
+static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
+					enum cgroup_bpf_attach_type atype)
+{
+	if (!prog || atype != prog->aux->cgroup_atype)
+		return;
+
+	bpf_trampoline_unlink_cgroup_shim(prog);
+}
+
 /**
  * cgroup_bpf_release() - put references of all bpf programs and
  *                        release all cgroup bpf data
@@ -123,10 +143,16 @@ static void cgroup_bpf_release(struct work_struct *work)
 
 		list_for_each_entry_safe(pl, pltmp, progs, node) {
 			list_del(&pl->node);
-			if (pl->prog)
+			if (pl->prog) {
+				bpf_cgroup_lsm_shim_release(pl->prog,
+							    atype);
 				bpf_prog_put(pl->prog);
-			if (pl->link)
+			}
+			if (pl->link) {
+				bpf_cgroup_lsm_shim_release(pl->link->link.prog,
+							    atype);
 				bpf_cgroup_link_auto_detach(pl->link);
+			}
 			kfree(pl);
 			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
 		}
@@ -439,6 +465,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_attach_target_info tgt_info = {};
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_list *pl;
 	struct list_head *progs;
@@ -455,9 +482,29 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		/* replace_prog implies BPF_F_REPLACE, and vice versa */
 		return -EINVAL;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	if (type == BPF_LSM_CGROUP) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+
+		if (replace_prog) {
+			/* Reusing shim from the original program.
+			 */
+			atype = replace_prog->aux->cgroup_atype;
+		} else {
+			err = bpf_check_attach_target(NULL, p, NULL,
+						      p->aux->attach_btf_id,
+						      &tgt_info);
+			if (err)
+				return -EINVAL;
+
+			atype = CGROUP_LSM_START + bpf_lsm_hook_idx(p->aux->attach_btf_id);
+		}
+
+		p->aux->cgroup_atype = atype;
+	} else {
+		atype = to_cgroup_bpf_attach_type(type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 
@@ -503,13 +550,27 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (err)
 		goto cleanup;
 
+	bpf_cgroup_storages_link(new_storage, cgrp, type);
+
+	if (type == BPF_LSM_CGROUP && !old_prog) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+		int err;
+
+		err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
+		if (err)
+			goto cleanup_trampoline;
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 	else
 		static_branch_inc(&cgroup_bpf_enabled_key[atype]);
-	bpf_cgroup_storages_link(new_storage, cgrp, type);
+
 	return 0;
 
+cleanup_trampoline:
+	bpf_cgroup_storages_unlink(new_storage);
+
 cleanup:
 	if (old_prog) {
 		pl->prog = old_prog;
@@ -601,9 +662,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	struct list_head *progs;
 	bool found = false;
 
-	atype = to_cgroup_bpf_attach_type(link->type);
-	if (atype < 0)
-		return -EINVAL;
+	if (link->type == BPF_LSM_CGROUP) {
+		atype = link->link.prog->aux->cgroup_atype;
+	} else {
+		atype = to_cgroup_bpf_attach_type(link->type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 
@@ -619,6 +684,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	if (!found)
 		return -ENOENT;
 
+	if (link->type == BPF_LSM_CGROUP)
+		new_prog->aux->cgroup_atype = atype;
+
 	old_prog = xchg(&link->link.prog, new_prog);
 	replace_effective_prog(cgrp, atype, link);
 	bpf_prog_put(old_prog);
@@ -702,9 +770,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	u32 flags;
 	int err;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	if (type == BPF_LSM_CGROUP) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+
+		atype = p->aux->cgroup_atype;
+	} else {
+		atype = to_cgroup_bpf_attach_type(type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 	flags = cgrp->bpf.flags[atype];
@@ -726,6 +800,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (err)
 		goto cleanup;
 
+	if (type == BPF_LSM_CGROUP)
+		bpf_cgroup_lsm_shim_release(prog ? : link->link.prog,
+					    atype);
+
 	/* now can actually delete it from this cgroup list */
 	list_del(&pl->node);
 	kfree(pl);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cdaa1152436a..351166cea25c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3139,6 +3139,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 		return prog->enforce_expected_attach_type &&
 			prog->expected_attach_type != attach_type ?
 			-EINVAL : 0;
+	case BPF_PROG_TYPE_LSM:
+		if (prog->expected_attach_type != BPF_LSM_CGROUP)
+			return -EINVAL;
+		return 0;
+
 	default:
 		return 0;
 	}
@@ -3194,6 +3199,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_LSM_CGROUP:
+		return BPF_PROG_TYPE_LSM;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3247,6 +3254,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_LSM:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 		break;
 	default:
@@ -3284,6 +3292,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_LSM:
 		return cgroup_bpf_prog_detach(attr, ptype);
 	default:
 		return -EINVAL;
@@ -4317,6 +4326,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_LSM:
 		ret = cgroup_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_TRACING:
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 5f40358a739e..a56d680b1bfc 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -11,6 +11,8 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/module.h>
 #include <linux/static_call.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf_lsm.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -406,6 +408,7 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 		return BPF_TRAMP_MODIFY_RETURN;
 	case BPF_TRACE_FEXIT:
 		return BPF_TRAMP_FEXIT;
+	case BPF_LSM_CGROUP:
 	case BPF_LSM_MAC:
 		if (!prog->aux->attach_func_proto->type)
 			/* The function returns void, we cannot modify its
@@ -497,6 +500,147 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 	return err;
 }
 
+static struct bpf_prog *cgroup_shim_alloc(const struct bpf_prog *prog,
+					  bpf_func_t bpf_func)
+{
+	struct bpf_prog *p;
+
+	p = bpf_prog_alloc(1, 0);
+	if (!p)
+		return NULL;
+
+	p->jited = false;
+	p->bpf_func = bpf_func;
+
+	p->aux->cgroup_atype = prog->aux->cgroup_atype;
+	p->aux->attach_func_proto = prog->aux->attach_func_proto;
+	p->aux->attach_btf_id = prog->aux->attach_btf_id;
+	p->aux->attach_btf = prog->aux->attach_btf;
+	btf_get(p->aux->attach_btf);
+	p->type = BPF_PROG_TYPE_LSM;
+	p->expected_attach_type = BPF_LSM_MAC;
+
+	return p;
+}
+
+static struct bpf_prog *cgroup_shim_find(struct bpf_trampoline *tr,
+					 bpf_func_t bpf_func)
+{
+	const struct bpf_prog_aux *aux;
+	int kind;
+
+	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
+		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
+			struct bpf_prog *p = aux->prog;
+
+			if (!p->jited && p->bpf_func == bpf_func)
+				return p;
+		}
+	}
+
+	return NULL;
+}
+
+int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+				    struct bpf_attach_target_info *tgt_info)
+{
+	struct bpf_prog *shim_prog = NULL;
+	struct bpf_trampoline *tr;
+	bpf_func_t bpf_func;
+	u64 key;
+	int err;
+
+	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
+					 prog->aux->attach_btf_id);
+
+	err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
+	if (err)
+		return err;
+
+	tr = bpf_trampoline_get(key, tgt_info);
+	if (!tr)
+		return  -ENOMEM;
+
+	mutex_lock(&tr->mutex);
+
+	shim_prog = cgroup_shim_find(tr, bpf_func);
+	if (shim_prog) {
+		/* Reusing existing shim attached by the other cgroup.
+		 */
+		bpf_prog_inc(shim_prog);
+		mutex_unlock(&tr->mutex);
+		return 0;
+	}
+
+	/* Allocate and install new shim.
+	 */
+
+	shim_prog = cgroup_shim_alloc(prog, bpf_func);
+	if (!shim_prog) {
+		err = -ENOMEM;
+		goto out;
+	}
+	bpf_prog_inc(shim_prog);
+
+	err = __bpf_trampoline_link_prog(shim_prog, tr);
+	if (err)
+		goto out;
+
+	mutex_unlock(&tr->mutex);
+
+	return 0;
+out:
+	if (shim_prog)
+		bpf_prog_put(shim_prog);
+
+	mutex_unlock(&tr->mutex);
+	return err;
+}
+
+void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
+{
+	struct bpf_prog *shim_prog;
+	struct bpf_trampoline *tr;
+	bpf_func_t bpf_func;
+	u64 key;
+	int err;
+
+	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
+					 prog->aux->attach_btf_id);
+
+	err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
+	if (err)
+		return;
+
+	tr = bpf_trampoline_lookup(key);
+	if (!tr)
+		return;
+
+	mutex_lock(&tr->mutex);
+
+	shim_prog = cgroup_shim_find(tr, bpf_func);
+	if (shim_prog) {
+		/* We use shim_prog refcnt for tracking whether to
+		 * remove the shim program from the trampoline.
+		 * Trampoline's mutex is held while refcnt is
+		 * added/subtracted so we don't need to care about
+		 * potential races.
+		 */
+
+		if (atomic64_read(&shim_prog->aux->refcnt) == 1)
+			WARN_ON_ONCE(__bpf_trampoline_unlink_prog(shim_prog, tr));
+
+		bpf_prog_put(shim_prog);
+	}
+
+	mutex_unlock(&tr->mutex);
+
+	bpf_trampoline_put(tr); /* bpf_trampoline_lookup */
+
+	if (shim_prog)
+		bpf_trampoline_put(tr);
+}
+
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d175b70067b3..1d2f2e7babb2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14168,6 +14168,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		fallthrough;
 	case BPF_MODIFY_RETURN:
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
 		if (!btf_type_is_func(t)) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7604e7d5438f..32ebf618689c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -998,6 +998,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_TRACE_KPROBE_MULTI,
+	BPF_LSM_CGROUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.35.1.1021.g381101b075-goog

