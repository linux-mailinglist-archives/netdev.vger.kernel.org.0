Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA12550DB
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgH0WBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgH0WBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:01:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E46C061264;
        Thu, 27 Aug 2020 15:01:22 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q93so3226007pjq.0;
        Thu, 27 Aug 2020 15:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1UJuKA8AHLcYVI4hvStDCsouMfH2VYqoEH/nBOSpg8U=;
        b=RwS26cKpDMgD6klzCeF1kfbWKkZvjy2muUMP4EuNB3MkA5WdP6ddBQqrAk5SSOWMlv
         UCvk1zoRbhindw9T5ZeQk0mDVNnLSfCHciBXpSi/xpcmFd1FEIH/rR0hjajtDzvTsw5L
         IcLyGcR/lpGh/UEkF2juo6qUoJcvCuKiYNqvDEdZap5RwH4nhFfg2+WarbSJJdkgodSG
         3WnyzI3GU87Eoi7S7jfaLGAqdHtflaK97Li5MhC4A/xdlJUfKapcAwR+3MBIHEGmlUQN
         1GJ62aR+1ouVZbwn81MV41hDorWwAxkYszwKhm1zeHES39U/WrX1yeFjMS8I65eSGW3M
         gdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1UJuKA8AHLcYVI4hvStDCsouMfH2VYqoEH/nBOSpg8U=;
        b=umDoOjmxamt/ivOlWIOjLKomyJmsl6AUfC2WzRaEn+m4DQORH3Co5K8RP3J4gGFzW7
         mTwJA4hBrFAYuQb4foQTrytkKdPXFsPzsTqqCjVmtx9XbbXyHSL3eTvmRUpB0jaoO27D
         UX8Ds017nPPTqqpVYOSPrNJv5WfyCWMvpMW6KQmMkWh54kIyZ43wCZ8pOkGfu0xApjgi
         W9X8QPXQyd0cf4lSzbM/x5eaxvrGXHdhQoxBGwXmdkAp24/u1F0A+Zs8ovT14ww9KzLg
         bvya5Q8A+WRnQt5FHczCbTf0oKkWDmbtspq3C1la+3CjdjrGFl3t/v3Q9H0/vTOgsYY1
         Ljtg==
X-Gm-Message-State: AOAM532G6cKbG3Li6M79NsaqVwO3V2Kwvs/t4xzuYIIcMATwWI1qxkpi
        ROe2P7HwYHYolKPx5mmYa+I=
X-Google-Smtp-Source: ABdhPJwchRPuspWvvuhzeOimEfToLnxehzg0U0LC3vSIkGSHZDeFBYp8s1YQdwmb2tSGg18N6QhKPA==
X-Received: by 2002:a17:90a:850b:: with SMTP id l11mr760776pjn.15.1598565681981;
        Thu, 27 Aug 2020 15:01:21 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id x28sm3997564pfq.62.2020.08.27.15.01.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 15:01:21 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, josef@toxicpanda.com, bpoirier@suse.com,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 2/5] bpf: Introduce sleepable BPF programs
Date:   Thu, 27 Aug 2020 15:01:11 -0700
Message-Id: <20200827220114.69225-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Introduce sleepable BPF programs that can request such property for themselves
via BPF_F_SLEEPABLE flag at program load time. In such case they will be able
to use helpers like bpf_copy_from_user() that might sleep. At present only
fentry/fexit/fmod_ret and lsm programs can request to be sleepable and only
when they are attached to kernel functions that are known to allow sleeping.

The non-sleepable programs are relying on implicit rcu_read_lock() and
migrate_disable() to protect life time of programs, maps that they use and
per-cpu kernel structures used to pass info between bpf programs and the
kernel. The sleepable programs cannot be enclosed into rcu_read_lock().
migrate_disable() maps to preempt_disable() in non-RT kernels, so the progs
should not be enclosed in migrate_disable() as well. Therefore
rcu_read_lock_trace is used to protect the life time of sleepable progs.

There are many networking and tracing program types. In many cases the
'struct bpf_prog *' pointer itself is rcu protected within some other kernel
data structure and the kernel code is using rcu_dereference() to load that
program pointer and call BPF_PROG_RUN() on it. All these cases are not touched.
Instead sleepable bpf programs are allowed with bpf trampoline only. The
program pointers are hard-coded into generated assembly of bpf trampoline and
synchronize_rcu_tasks_trace() is used to protect the life time of the program.
The same trampoline can hold both sleepable and non-sleepable progs.

When rcu_read_lock_trace is held it means that some sleepable bpf program is
running from bpf trampoline. Those programs can use bpf arrays and preallocated
hash/lru maps. These map types are waiting on programs to complete via
synchronize_rcu_tasks_trace();

Updates to trampoline now has to do synchronize_rcu_tasks_trace() and
synchronize_rcu_tasks() to wait for sleepable progs to finish and for
trampoline assembly to finish.

This is the first step of introducing sleepable progs. Eventually dynamically
allocated hash maps can be allowed and networking program types can become
sleepable too.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 arch/x86/net/bpf_jit_comp.c    | 32 +++++++++-----
 include/linux/bpf.h            |  3 ++
 include/uapi/linux/bpf.h       |  8 ++++
 init/Kconfig                   |  1 +
 kernel/bpf/arraymap.c          |  1 +
 kernel/bpf/hashtab.c           | 12 ++---
 kernel/bpf/syscall.c           | 13 ++++--
 kernel/bpf/trampoline.c        | 28 ++++++++++--
 kernel/bpf/verifier.c          | 81 +++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  8 ++++
 10 files changed, 162 insertions(+), 25 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 42b6709e6dc7..7d9ea7b41c71 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1379,10 +1379,15 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	if (emit_call(&prog, __bpf_prog_enter, prog))
-		return -EINVAL;
-	/* remember prog start time returned by __bpf_prog_enter */
-	emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
+	if (p->aux->sleepable) {
+		if (emit_call(&prog, __bpf_prog_enter_sleepable, prog))
+			return -EINVAL;
+	} else {
+		if (emit_call(&prog, __bpf_prog_enter, prog))
+			return -EINVAL;
+		/* remember prog start time returned by __bpf_prog_enter */
+		emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
+	}
 
 	/* arg1: lea rdi, [rbp - stack_size] */
 	EMIT4(0x48, 0x8D, 0x7D, -stack_size);
@@ -1402,13 +1407,18 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	if (mod_ret)
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
 
-	/* arg1: mov rdi, progs[i] */
-	emit_mov_imm64(&prog, BPF_REG_1, (long) p >> 32,
-		       (u32) (long) p);
-	/* arg2: mov rsi, rbx <- start time in nsec */
-	emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
-	if (emit_call(&prog, __bpf_prog_exit, prog))
-		return -EINVAL;
+	if (p->aux->sleepable) {
+		if (emit_call(&prog, __bpf_prog_exit_sleepable, prog))
+			return -EINVAL;
+	} else {
+		/* arg1: mov rdi, progs[i] */
+		emit_mov_imm64(&prog, BPF_REG_1, (long) p >> 32,
+			       (u32) (long) p);
+		/* arg2: mov rsi, rbx <- start time in nsec */
+		emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
+		if (emit_call(&prog, __bpf_prog_exit, prog))
+			return -EINVAL;
+	}
 
 	*pprog = prog;
 	return 0;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a6131d95e31e..1485f22b9e9b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -523,6 +523,8 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
 /* these two functions are called from generated trampoline */
 u64 notrace __bpf_prog_enter(void);
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
+void notrace __bpf_prog_enter_sleepable(void);
+void notrace __bpf_prog_exit_sleepable(void);
 
 struct bpf_ksym {
 	unsigned long		 start;
@@ -718,6 +720,7 @@ struct bpf_prog_aux {
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool func_proto_unreliable;
+	bool sleepable;
 	enum bpf_tramp_prog_type trampoline_prog_type;
 	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0388bc0200b0..aec01dee6aed 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -346,6 +346,14 @@ enum bpf_link_type {
 /* The verifier internal test flag. Behavior is undefined */
 #define BPF_F_TEST_STATE_FREQ	(1U << 3)
 
+/* If BPF_F_SLEEPABLE is used in BPF_PROG_LOAD command, the verifier will
+ * restrict map and helper usage for such programs. Sleepable BPF programs can
+ * only be attached to hooks where kernel execution context allows sleeping.
+ * Such programs are allowed to use helpers that may sleep like
+ * bpf_copy_from_user().
+ */
+#define BPF_F_SLEEPABLE		(1U << 4)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
diff --git a/init/Kconfig b/init/Kconfig
index fc10f7ede5f6..6ecc00e130ff 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1691,6 +1691,7 @@ config BPF_SYSCALL
 	bool "Enable bpf() system call"
 	select BPF
 	select IRQ_WORK
+	select TASKS_TRACE_RCU
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate eBPF
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 8ff419b632a6..77ead245a099 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -10,6 +10,7 @@
 #include <linux/filter.h>
 #include <linux/perf_event.h>
 #include <uapi/linux/btf.h>
+#include <linux/rcupdate_trace.h>
 
 #include "map_in_map.h"
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 78dfff6a501b..b69b8c60a01b 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -9,6 +9,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
 #include <uapi/linux/btf.h>
+#include <linux/rcupdate_trace.h>
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
 #include "map_in_map.h"
@@ -577,8 +578,7 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 	struct htab_elem *l;
 	u32 hash, key_size;
 
-	/* Must be called with rcu_read_lock. */
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 
 	key_size = map->key_size;
 
@@ -941,7 +941,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 
 	key_size = map->key_size;
 
@@ -1032,7 +1032,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 
 	key_size = map->key_size;
 
@@ -1220,7 +1220,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	u32 hash, key_size;
 	int ret = -ENOENT;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 
 	key_size = map->key_size;
 
@@ -1252,7 +1252,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 	u32 hash, key_size;
 	int ret = -ENOENT;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 
 	key_size = map->key_size;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5443cea86cef..26cc8902732c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -29,6 +29,7 @@
 #include <linux/bpf_lsm.h>
 #include <linux/poll.h>
 #include <linux/bpf-netns.h>
+#include <linux/rcupdate_trace.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -1730,10 +1731,14 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 	btf_put(prog->aux->btf);
 	bpf_prog_free_linfo(prog);
 
-	if (deferred)
-		call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
-	else
+	if (deferred) {
+		if (prog->aux->sleepable)
+			call_rcu_tasks_trace(&prog->aux->rcu, __bpf_prog_put_rcu);
+		else
+			call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
+	} else {
 		__bpf_prog_put_rcu(&prog->aux->rcu);
+	}
 }
 
 static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
@@ -2103,6 +2108,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
+				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32))
 		return -EINVAL;
 
@@ -2158,6 +2164,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	}
 
 	prog->aux->offload_requested = !!attr->prog_ifindex;
+	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 9be85aa4ec5f..c2b76545153c 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -7,6 +7,8 @@
 #include <linux/rbtree_latch.h>
 #include <linux/perf_event.h>
 #include <linux/btf.h>
+#include <linux/rcupdate_trace.h>
+#include <linux/rcupdate_wait.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -210,9 +212,12 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	 * updates to trampoline would change the code from underneath the
 	 * preempted task. Hence wait for tasks to voluntarily schedule or go
 	 * to userspace.
+	 * The same trampoline can hold both sleepable and non-sleepable progs.
+	 * synchronize_rcu_tasks_trace() is needed to make sure all sleepable
+	 * programs finish executing.
+	 * Wait for these two grace periods together.
 	 */
-
-	synchronize_rcu_tasks();
+	synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
 
 	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
 					  &tr->func.model, flags, tprogs,
@@ -344,7 +349,14 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
 	bpf_image_ksym_del(&tr->ksym);
-	/* wait for tasks to get out of trampoline before freeing it */
+	/* This code will be executed when all bpf progs (both sleepable and
+	 * non-sleepable) went through
+	 * bpf_prog_put()->call_rcu[_tasks_trace]()->bpf_prog_free_deferred().
+	 * Hence no need for another synchronize_rcu_tasks_trace() here,
+	 * but synchronize_rcu_tasks() is still needed, since trampoline
+	 * may not have had any sleepable programs and we need to wait
+	 * for tasks to get out of trampoline code before freeing it.
+	 */
 	synchronize_rcu_tasks();
 	bpf_jit_free_exec(tr->image);
 	hlist_del(&tr->hlist);
@@ -394,6 +406,16 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
 	rcu_read_unlock();
 }
 
+void notrace __bpf_prog_enter_sleepable(void)
+{
+	rcu_read_lock_trace();
+}
+
+void notrace __bpf_prog_exit_sleepable(void)
+{
+	rcu_read_unlock_trace();
+}
+
 int __weak
 arch_prepare_bpf_trampoline(void *image, void *image_end,
 			    const struct btf_func_model *m, u32 flags,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6f5a9f51cc03..3ebfdb7bd427 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 #include <linux/error-injection.h>
 #include <linux/bpf_lsm.h>
+#include <linux/btf_ids.h>
 
 #include "disasm.h"
 
@@ -9367,6 +9368,23 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	if (prog->aux->sleepable)
+		switch (map->map_type) {
+		case BPF_MAP_TYPE_HASH:
+		case BPF_MAP_TYPE_LRU_HASH:
+		case BPF_MAP_TYPE_ARRAY:
+			if (!is_preallocated_map(map)) {
+				verbose(env,
+					"Sleepable programs can only use preallocated hash maps\n");
+				return -EINVAL;
+			}
+			break;
+		default:
+			verbose(env,
+				"Sleepable programs can only use array and hash maps\n");
+			return -EINVAL;
+		}
+
 	return 0;
 }
 
@@ -10985,6 +11003,36 @@ static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
 	return -EINVAL;
 }
 
+/* non exhaustive list of sleepable bpf_lsm_*() functions */
+BTF_SET_START(btf_sleepable_lsm_hooks)
+#ifdef CONFIG_BPF_LSM
+BTF_ID(func, bpf_lsm_file_mprotect)
+BTF_ID(func, bpf_lsm_bprm_committed_creds)
+#endif
+BTF_SET_END(btf_sleepable_lsm_hooks)
+
+static int check_sleepable_lsm_hook(u32 btf_id)
+{
+	return btf_id_set_contains(&btf_sleepable_lsm_hooks, btf_id);
+}
+
+/* list of non-sleepable functions that are otherwise on
+ * ALLOW_ERROR_INJECTION list
+ */
+BTF_SET_START(btf_non_sleepable_error_inject)
+/* Three functions below can be called from sleepable and non-sleepable context.
+ * Assume non-sleepable from bpf safety point of view.
+ */
+BTF_ID(func, __add_to_page_cache_locked)
+BTF_ID(func, should_fail_alloc_page)
+BTF_ID(func, should_failslab)
+BTF_SET_END(btf_non_sleepable_error_inject)
+
+static int check_non_sleepable_error_inject(u32 btf_id)
+{
+	return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_id);
+}
+
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
@@ -11002,6 +11050,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	long addr;
 	u64 key;
 
+	if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
+	    prog->type != BPF_PROG_TYPE_LSM) {
+		verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
+		return -EINVAL;
+	}
+
 	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
 		return check_struct_ops_btf_id(env);
 
@@ -11210,13 +11264,36 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			}
 		}
 
-		if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
+		if (prog->aux->sleepable) {
+			ret = -EINVAL;
+			switch (prog->type) {
+			case BPF_PROG_TYPE_TRACING:
+				/* fentry/fexit/fmod_ret progs can be sleepable only if they are
+				 * attached to ALLOW_ERROR_INJECTION and are not in denylist.
+				 */
+				if (!check_non_sleepable_error_inject(btf_id) &&
+				    within_error_injection_list(addr))
+					ret = 0;
+				break;
+			case BPF_PROG_TYPE_LSM:
+				/* LSM progs check that they are attached to bpf_lsm_*() funcs.
+				 * Only some of them are sleepable.
+				 */
+				if (check_sleepable_lsm_hook(btf_id))
+					ret = 0;
+				break;
+			default:
+				break;
+			}
+			if (ret)
+				verbose(env, "%s is not sleepable\n",
+					prog->aux->attach_func_name);
+		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
 			ret = check_attach_modify_return(prog, addr);
 			if (ret)
 				verbose(env, "%s() is not modifiable\n",
 					prog->aux->attach_func_name);
 		}
-
 		if (ret)
 			goto out;
 		tr->func.addr = (void *)addr;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0388bc0200b0..aec01dee6aed 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -346,6 +346,14 @@ enum bpf_link_type {
 /* The verifier internal test flag. Behavior is undefined */
 #define BPF_F_TEST_STATE_FREQ	(1U << 3)
 
+/* If BPF_F_SLEEPABLE is used in BPF_PROG_LOAD command, the verifier will
+ * restrict map and helper usage for such programs. Sleepable BPF programs can
+ * only be attached to hooks where kernel execution context allows sleeping.
+ * Such programs are allowed to use helpers that may sleep like
+ * bpf_copy_from_user().
+ */
+#define BPF_F_SLEEPABLE		(1U << 4)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
-- 
2.23.0

