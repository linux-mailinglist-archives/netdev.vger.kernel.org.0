Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E2C1E5682
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgE1Fdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgE1Fdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:33:40 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BE0C05BD1E;
        Wed, 27 May 2020 22:33:40 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s69so2559677pjb.4;
        Wed, 27 May 2020 22:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ufJvIVRppsai1C5oCi9xEbVmFxFytItok2aDdVtK+eA=;
        b=jLjRQ67m3tqC2hvLkz3V8mvrhATFWPPaUYgU80YuoMCmHCHEA4Z32SlLtTbviudllI
         fxxcuTRwxIOJQ7SHV+NvAaD7oKKLC6owlkAs9bc8uo5ql4pQ7Lkc0jsa0teUZhMd5mDn
         vNIEslfMoirJIteDMRNe1eXtDO5K2qq8mpOJh2fJp6kM5PbPn8ZyYsvIxxKSVYZylVwX
         Td5KTyR9oxCmV1xIYiRT8z8PsigDQOhKp67tScWYBS3INc4CiUpGx4qUHEeswQMEVYKX
         dLnpasvepsVrtWCmHG6cbCib6amTEVKRsTXH3R93GOK5R+cOobDq3hbMAX01EJt0vf70
         uliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ufJvIVRppsai1C5oCi9xEbVmFxFytItok2aDdVtK+eA=;
        b=syFqkbsuA7c4Onf+MwcNZgW6xfqlNTvu0ahEbzkc/kYE7T8I/kAbU5wSI2vmAyOPXb
         3JNH4MLHZTIhbjBriA1X7zWlNLlGLSczlNNXJ1mqhyGjD439/ybfjhFFzPAET0K8hMc4
         wpHCcXs1RoyNWk1yqlHI3JM7sA+61Sh2c9nvQqMSugP4M+nWezDB4m/AXiDdNBhvYDkl
         +oAtYSnUnVJiY6YWYIuN8d8gVLpyH8JR+vIN2H/5eZ5GG8q9VnzkUP/TDpJxmcxzz3Ba
         RmievbBXBzTi31oIDfggUAABfpBD0z1BiifCOZUmHzn0Hpt9Lu5Lu+mOCloHnr8E4y2J
         0VAw==
X-Gm-Message-State: AOAM531aicO++6GSR35YlyLsnMRwIVOtINte66cDbu74u6rX/01X02km
        0oulDZda7q01gko2rZmzTg2F1jwp
X-Google-Smtp-Source: ABdhPJx92Vv862U1NTAHja0tGtLbTcgJpgrcXlAxywaRJzKRysYiHc4HwmIfmXmy4Ro5OsPKeYHrTw==
X-Received: by 2002:a17:90a:2327:: with SMTP id f36mr1865161pje.220.1590644019380;
        Wed, 27 May 2020 22:33:39 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id o27sm3502461pgd.18.2020.05.27.22.33.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2020 22:33:38 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 1/3] bpf: Introduce sleepable BPF programs
Date:   Wed, 27 May 2020 22:33:32 -0700
Message-Id: <20200528053334.89293-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
References: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
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
should not be enclosed in migrate_disable() as well. Therefore bpf_srcu is used
to protect the life time of sleepable progs.

There are many networking and tracing program types. In many cases the
'struct bpf_prog *' pointer itself is rcu protected within some other kernel
data structure and the kernel code is using rcu_dereference() to load that
program pointer and call BPF_PROG_RUN() on it. All these cases are not touched.
Instead sleepable bpf programs are allowed with bpf trampoline only. The
program pointers are hard-coded into generated assembly of bpf trampoline and
synchronize_srcu(&bpf_srcu) is used to protect the life time of the program.
The same trampoline can hold both sleepable and non-sleepable progs.

When bpf_srcu lock is held it means that some sleepable bpf program is running
from bpf trampoline. Those programs can use bpf arrays and preallocated hash/lru
maps. These map types are waiting on programs to complete via
synchronize_srcu(&bpf_srcu);

Updates to trampoline now has to do synchronize_srcu + synchronize_rcu_tasks
to wait for sleepable progs to finish and for trampoline assembly to finish.

In the future srcu will be replaced with upcoming rcu_trace.
That will complete the first step of introducing sleepable progs.

After that dynamically allocated hash maps can be allowed. All map elements
would have to be srcu protected instead of normal rcu.
per-cpu maps will be allowed. Either via the following pattern:
void *elem = bpf_map_lookup_elem(map, key);
if (elem) {
   // access elem
   bpf_map_release_elem(map, elem);
}
where modified lookup() helper will do migrate_disable() and
new bpf_map_release_elem() will do corresponding migrate_enable().
Or explicit bpf_migrate_disable/enable() helpers will be introduced.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c    | 36 +++++++++++++++-------
 include/linux/bpf.h            |  4 +++
 include/uapi/linux/bpf.h       |  8 +++++
 kernel/bpf/arraymap.c          |  5 +++
 kernel/bpf/hashtab.c           | 19 ++++++++----
 kernel/bpf/syscall.c           | 12 ++++++--
 kernel/bpf/trampoline.c        | 33 +++++++++++++++++++-
 kernel/bpf/verifier.c          | 56 ++++++++++++++++++++++++++--------
 tools/include/uapi/linux/bpf.h |  8 +++++
 9 files changed, 147 insertions(+), 34 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 42b6709e6dc7..3fdb62c89d6f 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1379,10 +1379,17 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	if (emit_call(&prog, __bpf_prog_enter, prog))
-		return -EINVAL;
-	/* remember prog start time returned by __bpf_prog_enter */
-	emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
+	if (p->aux->sleepable) {
+		if (emit_call(&prog, __bpf_prog_enter_sleepable, prog))
+			return -EINVAL;
+		/* remember srcu idx returned by __bpf_prog_enter_sleepable */
+		emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
+	} else {
+		if (emit_call(&prog, __bpf_prog_enter, prog))
+			return -EINVAL;
+		/* remember prog start time returned by __bpf_prog_enter */
+		emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
+	}
 
 	/* arg1: lea rdi, [rbp - stack_size] */
 	EMIT4(0x48, 0x8D, 0x7D, -stack_size);
@@ -1402,13 +1409,20 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
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
+		/* arg1: mov rdi, rbx <- srcu idx */
+		emit_mov_reg(&prog, true, BPF_REG_1, BPF_REG_6);
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
index efe8836b5c48..7b8291a96838 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -36,6 +36,7 @@ struct seq_operations;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
+extern struct srcu_struct bpf_srcu;
 
 /* map is generic key/value storage optionally accesible by eBPF programs */
 struct bpf_map_ops {
@@ -476,6 +477,8 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
 /* these two functions are called from generated trampoline */
 u64 notrace __bpf_prog_enter(void);
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
+u64 notrace __bpf_prog_enter_sleepable(void);
+void notrace __bpf_prog_exit_sleepable(u64 idx);
 
 struct bpf_ksym {
 	unsigned long		 start;
@@ -668,6 +671,7 @@ struct bpf_prog_aux {
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool func_proto_unreliable;
+	bool sleepable;
 	enum bpf_tramp_prog_type trampoline_prog_type;
 	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54b93f8b49b8..cc08a2064d4e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -329,6 +329,14 @@ enum bpf_link_type {
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
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 11584618e861..26b18b6a3dbc 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -393,6 +393,11 @@ static void array_map_free(struct bpf_map *map)
 	 */
 	synchronize_rcu();
 
+	/* arrays could have been used by both sleepable and non-sleepable bpf
+	 * progs. Make sure to wait for both prog types to finish executing.
+	 */
+	synchronize_srcu(&bpf_srcu);
+
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index b4b288a3c3c9..b001957fdcbf 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -577,8 +577,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 	struct htab_elem *l;
 	u32 hash, key_size;
 
-	/* Must be called with rcu_read_lock. */
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	/* Must be called with s?rcu_read_lock. */
+	WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
 
 	key_size = map->key_size;
 
@@ -935,7 +935,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
 
 	key_size = map->key_size;
 
@@ -1026,7 +1026,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
 
 	key_size = map->key_size;
 
@@ -1214,7 +1214,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	u32 hash, key_size;
 	int ret = -ENOENT;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
 
 	key_size = map->key_size;
 
@@ -1246,7 +1246,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 	u32 hash, key_size;
 	int ret = -ENOENT;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
 
 	key_size = map->key_size;
 
@@ -1297,6 +1297,13 @@ static void htab_map_free(struct bpf_map *map)
 	 */
 	synchronize_rcu();
 
+	/* preallocated hash map could have been used by both sleepable and
+	 * non-sleepable bpf progs. Make sure to wait for both prog types
+	 * to finish executing.
+	 */
+	if (htab_is_prealloc(htab))
+		synchronize_srcu(&bpf_srcu);
+
 	/* some of free_htab_elem() callbacks for elements of this map may
 	 * not have executed. Wait for them.
 	 */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d13b804ff045..0820115315d1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1724,10 +1724,14 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 	btf_put(prog->aux->btf);
 	bpf_prog_free_linfo(prog);
 
-	if (deferred)
-		call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
-	else
+	if (deferred) {
+		if (prog->aux->sleepable)
+			call_srcu(&bpf_srcu, &prog->aux->rcu, __bpf_prog_put_rcu);
+		else
+			call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
+	} else {
 		__bpf_prog_put_rcu(&prog->aux->rcu);
+	}
 }
 
 static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
@@ -2092,6 +2096,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
+				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32))
 		return -EINVAL;
 
@@ -2147,6 +2152,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	}
 
 	prog->aux->offload_requested = !!attr->prog_ifindex;
+	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 9be85aa4ec5f..d35d26e9693d 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -205,13 +205,21 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
 
+	/* the same trampoline can hold both sleepable and non-sleepable progs.
+	 * synchronize_srcu() is cheap when sleepable progs are not running, so
+	 * just call it here to make sure all sleepable progs finish executing.
+	 * Then call synchronize_rcu_tasks() to make sure that the rest of
+	 * generated tramopline assembly finishes too before updating
+	 * trampoline.
+	 */
+	synchronize_srcu(&bpf_srcu);
+
 	/* Though the second half of trampoline page is unused a task could be
 	 * preempted in the middle of the first half of trampoline and two
 	 * updates to trampoline would change the code from underneath the
 	 * preempted task. Hence wait for tasks to voluntarily schedule or go
 	 * to userspace.
 	 */
-
 	synchronize_rcu_tasks();
 
 	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
@@ -344,6 +352,11 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
 	bpf_image_ksym_del(&tr->ksym);
+	/* This code will be executed when all bpf progs (both sleepable and
+	 * non-sleepable) went through
+	 * bpf_prog_put()->call_s?rcu()->bpf_prog_free_deferred().
+	 * Hence no need for another synchronize_srcu(&bpf_srcu) here.
+	 */
 	/* wait for tasks to get out of trampoline before freeing it */
 	synchronize_rcu_tasks();
 	bpf_jit_free_exec(tr->image);
@@ -394,6 +407,23 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
 	rcu_read_unlock();
 }
 
+/* when bpf_srcu lock is held it means that some sleepable bpf program is
+ * running. Those programs can use bpf arrays and preallocated hash maps. These
+ * map types are waiting on programs to complete via
+ * synchronize_srcu(&bpf_srcu);
+ */
+struct srcu_struct bpf_srcu;
+
+u64 notrace __bpf_prog_enter_sleepable(void)
+{
+	return srcu_read_lock(&bpf_srcu);
+}
+
+void notrace __bpf_prog_exit_sleepable(u64 idx)
+{
+	srcu_read_unlock(&bpf_srcu, idx);
+}
+
 int __weak
 arch_prepare_bpf_trampoline(void *image, void *image_end,
 			    const struct btf_func_model *m, u32 flags,
@@ -409,6 +439,7 @@ static int __init init_trampolines(void)
 
 	for (i = 0; i < TRAMPOLINE_TABLE_SIZE; i++)
 		INIT_HLIST_HEAD(&trampoline_table[i]);
+	init_srcu_struct(&bpf_srcu);
 	return 0;
 }
 late_initcall(init_trampolines);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d2e27dba4ac6..01c7d3634151 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8922,6 +8922,23 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
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
 
@@ -10522,22 +10539,13 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 }
 #define SECURITY_PREFIX "security_"
 
-static int check_attach_modify_return(struct bpf_verifier_env *env)
+static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
 {
-	struct bpf_prog *prog = env->prog;
-	unsigned long addr = (unsigned long) prog->aux->trampoline->func.addr;
-
-	/* This is expected to be cleaned up in the future with the KRSI effort
-	 * introducing the LSM_HOOK macro for cleaning up lsm_hooks.h.
-	 */
 	if (within_error_injection_list(addr) ||
 	    !strncmp(SECURITY_PREFIX, prog->aux->attach_func_name,
 		     sizeof(SECURITY_PREFIX) - 1))
 		return 0;
 
-	verbose(env, "fmod_ret attach_btf_id %u (%s) is not modifiable\n",
-		prog->aux->attach_btf_id, prog->aux->attach_func_name);
-
 	return -EINVAL;
 }
 
@@ -10558,6 +10566,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
 
@@ -10765,11 +10779,27 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				goto out;
 			}
 		}
+
+		if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
+			ret = check_attach_modify_return(prog, addr);
+			if (ret)
+				verbose(env, "%s() is not modifiable\n",
+					prog->aux->attach_func_name);
+		} else if (prog->aux->sleepable && prog->type == BPF_PROG_TYPE_TRACING) {
+			/* fentry/fexit progs can be sleepable only if they are
+			 * attached to ALLOW_ERROR_INJECTION or security_*() funcs.
+			 * LSM progs check that they are attached to bpf_lsm_*() funcs
+			 * which are sleepable too.
+			 */
+			ret = check_attach_modify_return(prog, addr);
+			if (ret)
+				verbose(env, "%s is not sleepable\n",
+					prog->aux->attach_func_name);
+		}
+		if (ret)
+			goto out;
 		tr->func.addr = (void *)addr;
 		prog->aux->trampoline = tr;
-
-		if (prog->expected_attach_type == BPF_MODIFY_RETURN)
-			ret = check_attach_modify_return(env);
 out:
 		mutex_unlock(&tr->mutex);
 		if (ret)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 54b93f8b49b8..cc08a2064d4e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -329,6 +329,14 @@ enum bpf_link_type {
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

