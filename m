Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925654B7BA5
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244836AbiBPANB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:13:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244562AbiBPAM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:12:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BCEDBD16
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:47 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 2-20020a251302000000b006118f867dadso777880ybt.12
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P44FlEc7gJrVQvKadmuBDZWZ/W5J02yJtKMnybc8l8E=;
        b=AG9RbZ1+yf+UtdaAxsfYfM+jezaKk8No1Vbz6Y4QvOFQP7SlByEUXnCV4OHp9WL63t
         6T/gDGSCScqXTqdnV0ozlWKSrJ97Vrq6j5SXlFvhBreSKHpD3FsuxIWQLO1gybZ95TCl
         osz6d84AmcryLsJEg41z9F2rLC82Rgp7zd36CTbshyJs80SI+tj6ATep0GHVhzfX2kVf
         wWsVZ1Kc34m7I18if97xmYyobNN/FgB1yo1f2bpA7KdBHLGIOltM7skfd2KZSgKVGdtw
         njcoDYkG0F13u2zvnWFNBE8fUj5oXZJPVPFvy5JeceVCu30zlrvVdlJz1XWSDWin+huZ
         LsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P44FlEc7gJrVQvKadmuBDZWZ/W5J02yJtKMnybc8l8E=;
        b=pGOwcJcdeZ8i0fyBsb/NwXRoidPVul7EOQe0UudRIxQMxPiyxyJ4ZRqQsHDLa8EREX
         BogvA3jBCzxGI1fnF+UXY/vIrNfHA712fDZbsmW3dFCjOeBF4djonj4cyJULDh6snLud
         Z/FnzmzAjY5nnKnB5t0Xs7N5y36Lzlew4rj6w6kyxiCQr6TxGEW4yK+66a3YMCbKvKyq
         HWh7STXXvBeSrL82TpCLfITcADjYMHlrMFqNq9MMVjkL7DGZ+1QOs3LTxGuUp5FW1Gd0
         R5Q6LNK0EtIEUnLqgSLeuc1AQJKPp1YWG6qKYvxBFDlfB5TizNdxQFDIeHP7IgZ1Y+87
         Vi6w==
X-Gm-Message-State: AOAM530GJFrXXimCeDWwQZvrApiuumg0kDx0RVRKiQfmiKaUTpu2ol+7
        aFZaka7r5Pqo43FYS1VNeP996Nub9f0x8EDN14sWA301YQrhxBb1rAVIL4wjoGjVtSDRcMzjA2Z
        5YWpTWU8EQ02Q+2OwLlZ96yXMEVtrU1vCIwKevNY7kwx/9erl76osJg==
X-Google-Smtp-Source: ABdhPJz29LG0x2YE5vdQn62LgmZCS3JGqOB8PsqWJjsmKsV4Y6QVGxTLnGlyBlCiIuTHADofiBOALDA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:754a:e17d:48a0:d1db])
 (user=sdf job=sendgmr) by 2002:a25:b905:0:b0:61e:23e4:949f with SMTP id
 x5-20020a25b905000000b0061e23e4949fmr87715ybj.373.1644970366429; Tue, 15 Feb
 2022 16:12:46 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:12:38 -0800
In-Reply-To: <20220216001241.2239703-1-sdf@google.com>
Message-Id: <20220216001241.2239703-2-sdf@google.com>
Mime-Version: 1.0
References: <20220216001241.2239703-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC bpf-next 1/4] bpf: cgroup_sock lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow per-cgroup lsm attachment of a subset of hooks that operate
on the 'struct sock'

Expected usage:

1. attach raw tracepoint hook with expected_attach=BPF_LSM_CGROUP_SOCK
2. this causes fmod_ret trampoline that invokes __cgroup_bpf_run_lsm_sock
3. __cgroup_bpf_run_lsm_sock relies on existing cgroup_bpf->effective
   array which is extended to include new slots for lsm hooks
4. attach same program to the cgroup_fd

Current limitation:
- abusing x86 jit, not generic
- no proper error handling (detach tracepoint first will probably cause
  problems)
- 2 hooks for now for demonstration purposes
- lsm specific, maybe can be extended fentry/fexit/fmod_ret

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 arch/x86/net/bpf_jit_comp.c     | 27 +++++++++++++++------
 include/linux/bpf-cgroup-defs.h |  4 +++
 include/linux/bpf.h             |  2 ++
 include/uapi/linux/bpf.h        |  1 +
 kernel/bpf/btf.c                | 10 ++++++++
 kernel/bpf/cgroup.c             | 43 ++++++++++++++++++++++++++++++---
 kernel/bpf/syscall.c            |  6 ++++-
 kernel/bpf/trampoline.c         |  1 +
 kernel/bpf/verifier.c           |  1 +
 tools/include/uapi/linux/bpf.h  |  1 +
 10 files changed, 84 insertions(+), 12 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index c7db0fe4de2f..a5225648d091 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1742,6 +1742,8 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
 			 -(stack_size - i * 8));
 }
 
+extern int __cgroup_bpf_run_lsm_sock(u64 *, const struct bpf_prog *);
+
 static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 			   struct bpf_prog *p, int stack_size, bool save_ret)
 {
@@ -1767,14 +1769,23 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 
 	/* arg1: lea rdi, [rbp - stack_size] */
 	EMIT4(0x48, 0x8D, 0x7D, -stack_size);
-	/* arg2: progs[i]->insnsi for interpreter */
-	if (!p->jited)
-		emit_mov_imm64(&prog, BPF_REG_2,
-			       (long) p->insnsi >> 32,
-			       (u32) (long) p->insnsi);
-	/* call JITed bpf program or interpreter */
-	if (emit_call(&prog, p->bpf_func, prog))
-		return -EINVAL;
+
+	if (p->expected_attach_type == BPF_LSM_CGROUP_SOCK) {
+		/* arg2: progs[i] */
+		emit_mov_imm64(&prog, BPF_REG_2, (long) p >> 32, (u32) (long) p);
+		if (emit_call(&prog, __cgroup_bpf_run_lsm_sock, prog))
+			return -EINVAL;
+	} else {
+		/* arg2: progs[i]->insnsi for interpreter */
+		if (!p->jited)
+			emit_mov_imm64(&prog, BPF_REG_2,
+				       (long) p->insnsi >> 32,
+				       (u32) (long) p->insnsi);
+
+		/* call JITed bpf program or interpreter */
+		if (emit_call(&prog, p->bpf_func, prog))
+			return -EINVAL;
+	}
 
 	/*
 	 * BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 695d1224a71b..72498d2c2552 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -10,6 +10,8 @@
 
 struct bpf_prog_array;
 
+#define CGROUP_LSM_SOCK_NUM 2
+
 enum cgroup_bpf_attach_type {
 	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
 	CGROUP_INET_INGRESS = 0,
@@ -35,6 +37,8 @@ enum cgroup_bpf_attach_type {
 	CGROUP_INET4_GETSOCKNAME,
 	CGROUP_INET6_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
+	CGROUP_LSM_SOCK_START,
+	CGROUP_LSM_SOCK_END = CGROUP_LSM_SOCK_START + CGROUP_LSM_SOCK_NUM,
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2fc7e5c5ef41..ed215e4440da 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -975,6 +975,7 @@ struct bpf_prog_aux {
 	u64 load_time; /* ns since boottime */
 	u32 verified_insns;
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
+	int cgroup_atype; /* enum cgroup_bpf_attach_type */
 	char name[BPF_OBJ_NAME_LEN];
 #ifdef CONFIG_SECURITY
 	void *security;
@@ -2367,6 +2368,7 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len);
 
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
+int btf_id_set_index(const struct btf_id_set *set, u32 id);
 
 #define MAX_BPRINTF_VARARGS		12
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index afe3d0d7f5f2..286e55a2a852 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -997,6 +997,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_LSM_CGROUP_SOCK,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 11740b300de9..74cf158117b6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4928,6 +4928,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 	if (arg == nr_args) {
 		switch (prog->expected_attach_type) {
+		case BPF_LSM_CGROUP_SOCK:
 		case BPF_LSM_MAC:
 		case BPF_TRACE_FEXIT:
 			/* When LSM programs are attached to void LSM hooks
@@ -6338,6 +6339,15 @@ static int btf_id_cmp_func(const void *a, const void *b)
 	return *pa - *pb;
 }
 
+int btf_id_set_index(const struct btf_id_set *set, u32 id)
+{
+	const u32 *p;
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
index 098632fdbc45..503603667842 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/btf_ids.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
 
@@ -417,6 +418,11 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
 	return NULL;
 }
 
+BTF_SET_START(lsm_cgroup_sock)
+BTF_ID(func, bpf_lsm_socket_post_create)
+BTF_ID(func, bpf_lsm_socket_bind)
+BTF_SET_END(lsm_cgroup_sock)
+
 /**
  * __cgroup_bpf_attach() - Attach the program or the link to a cgroup, and
  *                         propagate the change to descendants
@@ -455,9 +461,24 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		/* replace_prog implies BPF_F_REPLACE, and vice versa */
 		return -EINVAL;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	if (prog->type == BPF_PROG_TYPE_LSM &&
+	    prog->expected_attach_type == BPF_LSM_CGROUP_SOCK) {
+		int idx;
+
+		BUG_ON(lsm_cgroup_sock.cnt != CGROUP_LSM_SOCK_NUM);
+
+		idx = btf_id_set_index(&lsm_cgroup_sock, prog->aux->attach_btf_id);
+		if (idx < 0)
+			return -EINVAL;
+
+		atype = CGROUP_LSM_SOCK_START + idx;
+
+		prog->aux->cgroup_atype = atype;
+	} else {
+		atype = to_cgroup_bpf_attach_type(type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 
@@ -1091,6 +1112,22 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);
 
+int __cgroup_bpf_run_lsm_sock(u64 *regs, const struct bpf_prog *prog)
+{
+	struct socket *sock = (void *)regs[BPF_REG_0];
+	struct cgroup *cgrp;
+	struct sock *sk;
+
+	sk = sock->sk;
+	if (!sk)
+		return 0;
+
+	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+
+	return BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
+				     regs, bpf_prog_run, 0);
+}
+
 /**
  * __cgroup_bpf_run_filter_sk() - Run a program on a sock
  * @sk: sock structure to manipulate
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 35646db3d950..aacf17e3e3da 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2724,7 +2724,8 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		}
 		break;
 	case BPF_PROG_TYPE_LSM:
-		if (prog->expected_attach_type != BPF_LSM_MAC) {
+		if (prog->expected_attach_type != BPF_LSM_MAC &&
+		    prog->expected_attach_type != BPF_LSM_CGROUP_SOCK) {
 			err = -EINVAL;
 			goto out_put_prog;
 		}
@@ -3184,6 +3185,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_LSM_CGROUP_SOCK:
+		return BPF_PROG_TYPE_LSM;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3237,6 +3240,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_LSM:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 		break;
 	default:
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7224691df2ec..58b92d6edf1d 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -406,6 +406,7 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 		return BPF_TRAMP_MODIFY_RETURN;
 	case BPF_TRACE_FEXIT:
 		return BPF_TRAMP_FEXIT;
+	case BPF_LSM_CGROUP_SOCK:
 	case BPF_LSM_MAC:
 		if (!prog->aux->attach_func_proto->type)
 			/* The function returns void, we cannot modify its
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d7473fee247c..1563723759d9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14105,6 +14105,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		fallthrough;
 	case BPF_MODIFY_RETURN:
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP_SOCK:
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
 		if (!btf_type_is_func(t)) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index afe3d0d7f5f2..286e55a2a852 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -997,6 +997,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_LSM_CGROUP_SOCK,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.35.1.265.g69c8d7142f-goog

