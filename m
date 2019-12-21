Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889501287C6
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 07:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfLUG0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 01:26:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbfLUG0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 01:26:13 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBL6P1Ov029055
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=e/3tl+Vh5RP11qs/cJNyeIbHmQ/a5IxG+A72C1nZPg8=;
 b=PZofZr+nxK94U92nx+9BFikonvAx89NKT5Df9uxPfwP4oO/8jsBQ+itewLcZnSCrQ6we
 y/XPL6BIE+Z4/LsEPxVK/NmtxICQkzSPRYHlLfauZDlS7y3T9rbjmti9gl6xz2LC2kD8
 lxt73+zjuEQ8zm8AMjS5CO+wjXxILIjntUs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x0h4gqbxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:11 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 20 Dec 2019 22:26:10 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EDD142946127; Fri, 20 Dec 2019 22:26:08 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Date:   Fri, 20 Dec 2019 22:26:08 -0800
Message-ID: <20191221062608.1183091-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191221062556.1182261-1-kafai@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_01:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 clxscore=1015 suspectscore=43 malwarescore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912210054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
is a kernel struct with its func ptr implemented in bpf prog.
This new map is the interface to register/unregister/introspect
a bpf implemented kernel struct.

The kernel struct is actually embedded inside another new struct
(or called the "value" struct in the code).  For example,
"struct tcp_congestion_ops" is embbeded in:
struct bpf_struct_ops_tcp_congestion_ops {
	refcount_t refcnt;
	enum bpf_struct_ops_state state;
	struct tcp_congestion_ops data;  /* <-- kernel subsystem struct here */
}
The map value is "struct bpf_struct_ops_tcp_congestion_ops".
The "bpftool map dump" will then be able to show the
state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.g.
number of tcp_sock in the tcp_congestion_ops case).  This "value" struct
is created automatically by a macro.  Having a separate "value" struct
will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. adding
"void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
initialization works before registering the struct_ops to the kernel
subsystem).  The libbpf will take care of finding and populating the
"struct bpf_struct_ops_XYZ" from "struct XYZ".

Register a struct_ops to a kernel subsystem:
1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_id
   set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of the
   running kernel.
   Instead of reusing the attr->btf_value_type_id,
   btf_vmlinux_value_type_id s added such that attr->btf_fd can still be
   used as the "user" btf which could store other useful sysadmin/debug
   info that may be introduced in the furture,
   e.g. creation-date/compiler-details/map-creator...etc.
3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as described
   in the running kernel btf.  Populate the value of this object.
   The function ptr should be populated with the prog fds.
4. Call BPF_MAP_UPDATE with the object created in (3) as
   the map value.  The key is always "0".

During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
the specific struct_ops to do some final checks in "st_ops->init_member()"
(e.g. ensure all mandatory func ptrs are implemented).
If everything looks good, it will register this kernel struct
to the kernel subsystem.  The map will not allow further update
from this point.

Unregister a struct_ops from the kernel subsystem:
BPF_MAP_DELETE with key "0".

Introspect a struct_ops:
BPF_MAP_LOOKUP_ELEM with key "0".  The map value returned will
have the prog _id_ populated as the func ptr.

The map value state (enum bpf_struct_ops_state) will transit from:
INIT (map created) =>
INUSE (map updated, i.e. reg) =>
TOBEFREE (map value deleted, i.e. unreg)

The kernel subsystem needs to call bpf_struct_ops_get() and
bpf_struct_ops_put() to manage the "refcnt" in the
"struct bpf_struct_ops_XYZ".  This patch uses a separate refcnt
for the purose of tracking the subsystem usage.  Another approach
is to reuse the map->refcnt and then "show" (i.e. during map_lookup)
the subsystem's usage by doing map->refcnt - map->usercnt to filter out
the map-fd/pinned-map usage.  However, that will also tie down the
future semantics of map->refcnt and map->usercnt.

The very first subsystem's refcnt (during reg()) holds one
count to map->refcnt.  When the very last subsystem's refcnt
is gone, it will also release the map->refcnt.  All bpf_prog will be
freed when the map->refcnt reaches 0 (i.e. during map_free()).

Here is how the bpftool map command will look like:
[root@arch-fb-vm1 bpf]# bpftool map show
6: struct_ops  name dctcp  flags 0x0
	key 4B  value 256B  max_entries 1  memlock 4096B
	btf_id 6
[root@arch-fb-vm1 bpf]# bpftool map dump id 6
[{
        "value": {
            "refcnt": {
                "refs": {
                    "counter": 1
                }
            },
            "state": 1,
            "data": {
                "list": {
                    "next": 0,
                    "prev": 0
                },
                "key": 0,
                "flags": 2,
                "init": 24,
                "release": 0,
                "ssthresh": 25,
                "cong_avoid": 30,
                "set_state": 27,
                "cwnd_event": 28,
                "in_ack_event": 26,
                "undo_cwnd": 29,
                "pkts_acked": 0,
                "min_tso_segs": 0,
                "sndbuf_expand": 0,
                "cong_control": 0,
                "get_info": 0,
                "name": [98,112,102,95,100,99,116,99,112,0,0,0,0,0,0,0
                ],
                "owner": 0
            }
        }
    }
]

Misc Notes:
* bpf_struct_ops_map_sys_lookup_elem() is added for syscall lookup.
  It does an inplace update on "*value" instead returning a pointer
  to syscall.c.  Otherwise, it needs a separate copy of "zero" value
  for the BPF_STRUCT_OPS_STATE_INIT to avoid races.

* The bpf_struct_ops_map_delete_elem() is also called without
  preempt_disable() from map_delete_elem().  It is because
  the "->unreg()" may requires sleepable context, e.g.
  the "tcp_unregister_congestion_control()".

* "const" is added to some of the existing "struct btf_func_model *"
  function arg to avoid a compiler warning caused by this patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 arch/x86/net/bpf_jit_comp.c |  11 +-
 include/linux/bpf.h         |  49 +++-
 include/linux/bpf_types.h   |   3 +
 include/linux/btf.h         |  13 +
 include/uapi/linux/bpf.h    |   7 +-
 kernel/bpf/bpf_struct_ops.c | 468 +++++++++++++++++++++++++++++++++++-
 kernel/bpf/btf.c            |  20 +-
 kernel/bpf/map_in_map.c     |   3 +-
 kernel/bpf/syscall.c        |  49 ++--
 kernel/bpf/trampoline.c     |   5 +-
 kernel/bpf/verifier.c       |   5 +
 11 files changed, 593 insertions(+), 40 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 4c8a2d1f8470..775347c78947 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1328,7 +1328,7 @@ xadd:			if (is_imm8(insn->off))
 	return proglen;
 }
 
-static void save_regs(struct btf_func_model *m, u8 **prog, int nr_args,
+static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
 		      int stack_size)
 {
 	int i;
@@ -1344,7 +1344,7 @@ static void save_regs(struct btf_func_model *m, u8 **prog, int nr_args,
 			 -(stack_size - i * 8));
 }
 
-static void restore_regs(struct btf_func_model *m, u8 **prog, int nr_args,
+static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
 			 int stack_size)
 {
 	int i;
@@ -1361,7 +1361,7 @@ static void restore_regs(struct btf_func_model *m, u8 **prog, int nr_args,
 			 -(stack_size - i * 8));
 }
 
-static int invoke_bpf(struct btf_func_model *m, u8 **pprog,
+static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
 		      struct bpf_prog **progs, int prog_cnt, int stack_size)
 {
 	u8 *prog = *pprog;
@@ -1456,7 +1456,8 @@ static int invoke_bpf(struct btf_func_model *m, u8 **pprog,
  * add rsp, 8                      // skip eth_type_trans's frame
  * ret                             // return to its caller
  */
-int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags,
+int arch_prepare_bpf_trampoline(void *image,
+				const struct btf_func_model *m, u32 flags,
 				struct bpf_prog **fentry_progs, int fentry_cnt,
 				struct bpf_prog **fexit_progs, int fexit_cnt,
 				void *orig_call)
@@ -1529,7 +1530,7 @@ int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags
 	 */
 	if (WARN_ON_ONCE(prog - (u8 *)image > PAGE_SIZE / 2 - BPF_INSN_SAFETY))
 		return -EFAULT;
-	return 0;
+	return (void *)prog - image;
 }
 
 static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b8f087eb4bdf..4e6bdf15d33f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -17,6 +17,7 @@
 #include <linux/u64_stats_sync.h>
 #include <linux/refcount.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -106,6 +107,7 @@ struct bpf_map {
 	struct btf *btf;
 	struct bpf_map_memory memory;
 	char name[BPF_OBJ_NAME_LEN];
+	u32 btf_vmlinux_value_type_id;
 	bool unpriv_array;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	/* 22 bytes hole */
@@ -183,7 +185,8 @@ static inline bool bpf_map_offload_neutral(const struct bpf_map *map)
 
 static inline bool bpf_map_support_seq_show(const struct bpf_map *map)
 {
-	return map->btf && map->ops->map_seq_show_elem;
+	return (map->btf_value_type_id || map->btf_vmlinux_value_type_id) &&
+		map->ops->map_seq_show_elem;
 }
 
 int map_check_no_btf(const struct bpf_map *map,
@@ -441,7 +444,8 @@ struct btf_func_model {
  *      fentry = a set of program to run before calling original function
  *      fexit = a set of program to run after original function
  */
-int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags,
+int arch_prepare_bpf_trampoline(void *image,
+				const struct btf_func_model *m, u32 flags,
 				struct bpf_prog **fentry_progs, int fentry_cnt,
 				struct bpf_prog **fexit_progs, int fexit_cnt,
 				void *orig_call);
@@ -671,6 +675,7 @@ struct bpf_array_aux {
 	struct work_struct work;
 };
 
+struct bpf_struct_ops_value;
 struct btf_type;
 struct btf_member;
 
@@ -680,21 +685,61 @@ struct bpf_struct_ops {
 	int (*init)(struct btf *_btf_vmlinux);
 	int (*check_member)(const struct btf_type *t,
 			    const struct btf_member *member);
+	int (*init_member)(const struct btf_type *t,
+			   const struct btf_member *member,
+			   void *kdata, const void *udata);
+	int (*reg)(void *kdata);
+	void (*unreg)(void *kdata);
 	const struct btf_type *type;
+	const struct btf_type *value_type;
 	const char *name;
 	struct btf_func_model func_models[BPF_STRUCT_OPS_MAX_NR_MEMBERS];
 	u32 type_id;
+	u32 value_id;
 };
 
 #if defined(CONFIG_BPF_JIT)
+#define BPF_MODULE_OWNER ((void *)((0xeB9FUL << 2) + POISON_POINTER_DELTA))
 const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id);
 void bpf_struct_ops_init(struct btf *_btf_vmlinux);
+bool bpf_struct_ops_get(const void *kdata);
+void bpf_struct_ops_put(const void *kdata);
+int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
+				       void *value);
+static inline bool bpf_try_module_get(const void *data, struct module *owner)
+{
+	if (owner == BPF_MODULE_OWNER)
+		return bpf_struct_ops_get(data);
+	else
+		return try_module_get(owner);
+}
+static inline void bpf_module_put(const void *data, struct module *owner)
+{
+	if (owner == BPF_MODULE_OWNER)
+		bpf_struct_ops_put(data);
+	else
+		module_put(owner);
+}
 #else
 static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 {
 	return NULL;
 }
 static inline void bpf_struct_ops_init(struct btf *_btf_vmlinux) { }
+static inline bool bpf_try_module_get(const void *data, struct module *owner)
+{
+	return try_module_get(owner);
+}
+static inline void bpf_module_put(const void *data, struct module *owner)
+{
+	module_put(owner);
+}
+static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
+						     void *key,
+						     void *value)
+{
+	return -EINVAL;
+}
 #endif
 
 struct bpf_array {
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index fadd243ffa2d..9f326e6ef885 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -109,3 +109,6 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
+#if defined(CONFIG_BPF_JIT)
+BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
+#endif
diff --git a/include/linux/btf.h b/include/linux/btf.h
index f74a09a7120b..881e9b76ef49 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -7,6 +7,8 @@
 #include <linux/types.h>
 #include <uapi/linux/btf.h>
 
+#define BTF_TYPE_EMIT(type) ((void)(type *)0)
+
 struct btf;
 struct btf_member;
 struct btf_type;
@@ -60,6 +62,10 @@ const struct btf_type *btf_type_resolve_ptr(const struct btf *btf,
 					    u32 id, u32 *res_id);
 const struct btf_type *btf_type_resolve_func_ptr(const struct btf *btf,
 						 u32 id, u32 *res_id);
+const struct btf_type *
+btf_resolve_size(const struct btf *btf, const struct btf_type *type,
+		 u32 *type_size, const struct btf_type **elem_type,
+		 u32 *total_nelems);
 
 #define for_each_member(i, struct_type, member)			\
 	for (i = 0, member = btf_type_member(struct_type);	\
@@ -106,6 +112,13 @@ static inline bool btf_type_kflag(const struct btf_type *t)
 	return BTF_INFO_KFLAG(t->info);
 }
 
+static inline u32 btf_member_bit_offset(const struct btf_type *struct_type,
+					const struct btf_member *member)
+{
+	return btf_type_kflag(struct_type) ? BTF_MEMBER_BIT_OFFSET(member->offset)
+					   : member->offset;
+}
+
 static inline u32 btf_member_bitfield_size(const struct btf_type *struct_type,
 					   const struct btf_member *member)
 {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c1eeb3e0e116..38059880963e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -136,6 +136,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
 	BPF_MAP_TYPE_DEVMAP_HASH,
+	BPF_MAP_TYPE_STRUCT_OPS,
 };
 
 /* Note that tracing related programs such as
@@ -398,6 +399,10 @@ union bpf_attr {
 		__u32	btf_fd;		/* fd pointing to a BTF type data */
 		__u32	btf_key_type_id;	/* BTF type_id of the key */
 		__u32	btf_value_type_id;	/* BTF type_id of the value */
+		__u32	btf_vmlinux_value_type_id;/* BTF type_id of a kernel-
+						   * struct stored as the
+						   * map value
+						   */
 	};
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
@@ -3350,7 +3355,7 @@ struct bpf_map_info {
 	__u32 map_flags;
 	char  name[BPF_OBJ_NAME_LEN];
 	__u32 ifindex;
-	__u32 :32;
+	__u32 btf_vmlinux_value_type_id;
 	__u64 netns_dev;
 	__u64 netns_ino;
 	__u32 btf_id;
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index c9f81bd1df83..fb9a0b3e4580 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -10,8 +10,66 @@
 #include <linux/seq_file.h>
 #include <linux/refcount.h>
 
+enum bpf_struct_ops_state {
+	BPF_STRUCT_OPS_STATE_INIT,
+	BPF_STRUCT_OPS_STATE_INUSE,
+	BPF_STRUCT_OPS_STATE_TOBEFREE,
+};
+
+#define BPF_STRUCT_OPS_COMMON_VALUE			\
+	refcount_t refcnt;				\
+	enum bpf_struct_ops_state state
+
+struct bpf_struct_ops_value {
+	BPF_STRUCT_OPS_COMMON_VALUE;
+	char data[0] ____cacheline_aligned_in_smp;
+};
+
+struct bpf_struct_ops_map {
+	struct bpf_map map;
+	const struct bpf_struct_ops *st_ops;
+	/* protect map_update */
+	spinlock_t lock;
+	/* progs has all the bpf_prog that is populated
+	 * to the func ptr of the kernel's struct
+	 * (in kvalue.data).
+	 */
+	struct bpf_prog **progs;
+	/* image is a page that has all the trampolines
+	 * that stores the func args before calling the bpf_prog.
+	 * A PAGE_SIZE "image" is enough to store all trampoline for
+	 * "progs[]".
+	 */
+	void *image;
+	/* uvalue->data stores the kernel struct
+	 * (e.g. tcp_congestion_ops) that is more useful
+	 * to userspace than the kvalue.  For example,
+	 * the bpf_prog's id is stored instead of the kernel
+	 * address of a func ptr.
+	 */
+	struct bpf_struct_ops_value *uvalue;
+	/* kvalue.data stores the actual kernel's struct
+	 * (e.g. tcp_congestion_ops) that will be
+	 * registered to the kernel subsystem.
+	 */
+	struct bpf_struct_ops_value kvalue;
+};
+
+#define VALUE_PREFIX "bpf_struct_ops_"
+#define VALUE_PREFIX_LEN (sizeof(VALUE_PREFIX) - 1)
+
+/* bpf_struct_ops_##_name (e.g. bpf_struct_ops_tcp_congestion_ops) is
+ * the map's value exposed to the userspace and its btf-type-id is
+ * stored at the map->btf_vmlinux_value_type_id.
+ *
+ */
 #define BPF_STRUCT_OPS_TYPE(_name)				\
-extern struct bpf_struct_ops bpf_##_name;
+extern struct bpf_struct_ops bpf_##_name;			\
+								\
+struct bpf_struct_ops_##_name {						\
+	BPF_STRUCT_OPS_COMMON_VALUE;				\
+	struct _name data ____cacheline_aligned_in_smp;		\
+};
 #include "bpf_struct_ops_types.h"
 #undef BPF_STRUCT_OPS_TYPE
 
@@ -35,19 +93,51 @@ const struct bpf_verifier_ops bpf_struct_ops_verifier_ops = {
 const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
 };
 
+static const struct btf_type *module_type;
+
 void bpf_struct_ops_init(struct btf *_btf_vmlinux)
 {
+	s32 type_id, value_id, module_id;
 	const struct btf_member *member;
 	struct bpf_struct_ops *st_ops;
 	struct bpf_verifier_log log = {};
 	const struct btf_type *t;
+	char value_name[128];
 	const char *mname;
-	s32 type_id;
 	u32 i, j;
 
+	/* Ensure BTF type is emitted for "struct bpf_struct_ops_##_name" */
+#define BPF_STRUCT_OPS_TYPE(_name) BTF_TYPE_EMIT(struct bpf_struct_ops_##_name);
+#include "bpf_struct_ops_types.h"
+#undef BPF_STRUCT_OPS_TYPE
+
+	module_id = btf_find_by_name_kind(_btf_vmlinux, "module",
+					  BTF_KIND_STRUCT);
+	if (module_id < 0) {
+		pr_warn("Cannot find struct module in btf_vmlinux\n");
+		return;
+	}
+	module_type = btf_type_by_id(_btf_vmlinux, module_id);
+
 	for (i = 0; i < ARRAY_SIZE(bpf_struct_ops); i++) {
 		st_ops = bpf_struct_ops[i];
 
+		if (strlen(st_ops->name) + VALUE_PREFIX_LEN >=
+		    sizeof(value_name)) {
+			pr_warn("struct_ops name %s is too long\n",
+				st_ops->name);
+			continue;
+		}
+		sprintf(value_name, "%s%s", VALUE_PREFIX, st_ops->name);
+
+		value_id = btf_find_by_name_kind(_btf_vmlinux, value_name,
+						 BTF_KIND_STRUCT);
+		if (value_id < 0) {
+			pr_warn("Cannot find struct %s in btf_vmlinux\n",
+				value_name);
+			continue;
+		}
+
 		type_id = btf_find_by_name_kind(_btf_vmlinux, st_ops->name,
 						BTF_KIND_STRUCT);
 		if (type_id < 0) {
@@ -99,6 +189,9 @@ void bpf_struct_ops_init(struct btf *_btf_vmlinux)
 			} else {
 				st_ops->type_id = type_id;
 				st_ops->type = t;
+				st_ops->value_id = value_id;
+				st_ops->value_type =
+					btf_type_by_id(_btf_vmlinux, value_id);
 			}
 		}
 	}
@@ -106,6 +199,22 @@ void bpf_struct_ops_init(struct btf *_btf_vmlinux)
 
 extern struct btf *btf_vmlinux;
 
+static const struct bpf_struct_ops *
+bpf_struct_ops_find_value(u32 value_id)
+{
+	unsigned int i;
+
+	if (!value_id || !btf_vmlinux)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(bpf_struct_ops); i++) {
+		if (bpf_struct_ops[i]->value_id == value_id)
+			return bpf_struct_ops[i];
+	}
+
+	return NULL;
+}
+
 const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 {
 	unsigned int i;
@@ -120,3 +229,358 @@ const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 
 	return NULL;
 }
+
+static int bpf_struct_ops_map_get_next_key(struct bpf_map *map, void *key,
+					   void *next_key)
+{
+	if (key && *(u32 *)key == 0)
+		return -ENOENT;
+
+	*(u32 *)next_key = 0;
+	return 0;
+}
+
+int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
+				       void *value)
+{
+	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
+	struct bpf_struct_ops_value *uvalue, *kvalue;
+	enum bpf_struct_ops_state state;
+
+	if (unlikely(*(u32 *)key != 0))
+		return -ENOENT;
+
+	kvalue = &st_map->kvalue;
+	/* Pair with smp_store_release() during map_update */
+	state = smp_load_acquire(&kvalue->state);
+	if (state == BPF_STRUCT_OPS_STATE_INIT) {
+		memset(value, 0, map->value_size);
+		return 0;
+	}
+
+	/* No lock is needed.  state and refcnt do not need
+	 * to be updated together under atomic context.
+	 */
+	uvalue = (struct bpf_struct_ops_value *)value;
+	memcpy(uvalue, st_map->uvalue, map->value_size);
+	uvalue->state = state;
+	refcount_set(&uvalue->refcnt, refcount_read(&kvalue->refcnt));
+
+	return 0;
+}
+
+static void *bpf_struct_ops_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static void bpf_struct_ops_map_put_progs(struct bpf_struct_ops_map *st_map)
+{
+	const struct btf_type *t = st_map->st_ops->type;
+	u32 i;
+
+	for (i = 0; i < btf_type_vlen(t); i++) {
+		if (st_map->progs[i]) {
+			bpf_prog_put(st_map->progs[i]);
+			st_map->progs[i] = NULL;
+		}
+	}
+}
+
+static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
+					  void *value, u64 flags)
+{
+	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
+	const struct bpf_struct_ops *st_ops = st_map->st_ops;
+	struct bpf_struct_ops_value *uvalue, *kvalue;
+	const struct btf_member *member;
+	const struct btf_type *t = st_ops->type;
+	void *udata, *kdata;
+	int prog_fd, err = 0;
+	void *image;
+	u32 i;
+
+	if (flags)
+		return -EINVAL;
+
+	if (*(u32 *)key != 0)
+		return -E2BIG;
+
+	uvalue = (struct bpf_struct_ops_value *)value;
+	if (uvalue->state || refcount_read(&uvalue->refcnt))
+		return -EINVAL;
+
+	uvalue = (struct bpf_struct_ops_value *)st_map->uvalue;
+	kvalue = (struct bpf_struct_ops_value *)&st_map->kvalue;
+
+	spin_lock(&st_map->lock);
+
+	if (kvalue->state != BPF_STRUCT_OPS_STATE_INIT) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	memcpy(uvalue, value, map->value_size);
+
+	udata = &uvalue->data;
+	kdata = &kvalue->data;
+	image = st_map->image;
+
+	for_each_member(i, t, member) {
+		const struct btf_type *mtype, *ptype;
+		struct bpf_prog *prog;
+		u32 moff;
+
+		moff = btf_member_bit_offset(t, member) / 8;
+		mtype = btf_type_by_id(btf_vmlinux, member->type);
+		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
+		if (ptype == module_type) {
+			*(void **)(kdata + moff) = BPF_MODULE_OWNER;
+			continue;
+		}
+
+		err = st_ops->init_member(t, member, kdata, udata);
+		if (err < 0)
+			goto reset_unlock;
+
+		/* The ->init_member() has handled this member */
+		if (err > 0)
+			continue;
+
+		/* If st_ops->init_member does not handle it,
+		 * we will only handle func ptrs and zero-ed members
+		 * here.  Reject everything else.
+		 */
+
+		/* All non func ptr member must be 0 */
+		if (!btf_type_resolve_func_ptr(btf_vmlinux, member->type,
+					       NULL)) {
+			u32 msize;
+
+			mtype = btf_resolve_size(btf_vmlinux, mtype,
+						 &msize, NULL, NULL);
+			if (IS_ERR(mtype)) {
+				err = PTR_ERR(mtype);
+				goto reset_unlock;
+			}
+
+			if (memchr_inv(udata + moff, 0, msize)) {
+				err = -EINVAL;
+				goto reset_unlock;
+			}
+
+			continue;
+		}
+
+		prog_fd = (int)(*(unsigned long *)(udata + moff));
+		/* Similar check as the attr->attach_prog_fd */
+		if (!prog_fd)
+			continue;
+
+		prog = bpf_prog_get(prog_fd);
+		if (IS_ERR(prog)) {
+			err = PTR_ERR(prog);
+			goto reset_unlock;
+		}
+		st_map->progs[i] = prog;
+
+		if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
+		    prog->aux->attach_btf_id != st_ops->type_id ||
+		    prog->expected_attach_type != i) {
+			err = -EINVAL;
+			goto reset_unlock;
+		}
+
+		err = arch_prepare_bpf_trampoline(image,
+						  &st_ops->func_models[i], 0,
+						  &prog, 1, NULL, 0, NULL);
+		if (err < 0)
+			goto reset_unlock;
+
+		*(void **)(kdata + moff) = image;
+		image += err;
+
+		/* put prog_id to udata */
+		*(unsigned long *)(udata + moff) = prog->aux->id;
+	}
+
+	refcount_set(&kvalue->refcnt, 1);
+	bpf_map_inc(map);
+
+	err = st_ops->reg(kdata);
+	if (!err) {
+		/* Pair with smp_load_acquire() during lookup */
+		smp_store_release(&kvalue->state, BPF_STRUCT_OPS_STATE_INUSE);
+		goto unlock;
+	}
+
+	/* Error during st_ops->reg() */
+	bpf_map_put(map);
+
+reset_unlock:
+	bpf_struct_ops_map_put_progs(st_map);
+	memset(uvalue, 0, map->value_size);
+	memset(kvalue, 0, map->value_size);
+
+unlock:
+	spin_unlock(&st_map->lock);
+	return err;
+}
+
+static int bpf_struct_ops_map_delete_elem(struct bpf_map *map, void *key)
+{
+	enum bpf_struct_ops_state prev_state;
+	struct bpf_struct_ops_map *st_map;
+
+	st_map = (struct bpf_struct_ops_map *)map;
+	prev_state = cmpxchg(&st_map->kvalue.state,
+			     BPF_STRUCT_OPS_STATE_INUSE,
+			     BPF_STRUCT_OPS_STATE_TOBEFREE);
+	if (prev_state == BPF_STRUCT_OPS_STATE_INUSE) {
+		st_map->st_ops->unreg(&st_map->kvalue.data);
+		if (refcount_dec_and_test(&st_map->kvalue.refcnt))
+			bpf_map_put(map);
+	}
+
+	return 0;
+}
+
+static void bpf_struct_ops_map_seq_show_elem(struct bpf_map *map, void *key,
+					     struct seq_file *m)
+{
+	void *value;
+
+	value = bpf_struct_ops_map_lookup_elem(map, key);
+	if (!value)
+		return;
+
+	btf_type_seq_show(btf_vmlinux, map->btf_vmlinux_value_type_id,
+			  value, m);
+	seq_puts(m, "\n");
+}
+
+static void bpf_struct_ops_map_free(struct bpf_map *map)
+{
+	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
+
+	if (st_map->progs)
+		bpf_struct_ops_map_put_progs(st_map);
+	bpf_map_area_free(st_map->progs);
+	bpf_jit_free_exec(st_map->image);
+	bpf_map_area_free(st_map->uvalue);
+	bpf_map_area_free(st_map);
+}
+
+static int bpf_struct_ops_map_alloc_check(union bpf_attr *attr)
+{
+	if (attr->key_size != sizeof(unsigned int) || attr->max_entries != 1 ||
+	    attr->map_flags || !attr->btf_vmlinux_value_type_id)
+		return -EINVAL;
+	return 0;
+}
+
+static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
+{
+	const struct bpf_struct_ops *st_ops;
+	size_t map_total_size, st_map_size;
+	struct bpf_struct_ops_map *st_map;
+	const struct btf_type *t, *vt;
+	struct bpf_map_memory mem;
+	struct bpf_map *map;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	st_ops = bpf_struct_ops_find_value(attr->btf_vmlinux_value_type_id);
+	if (!st_ops)
+		return ERR_PTR(-ENOTSUPP);
+
+	vt = st_ops->value_type;
+	if (attr->value_size != vt->size)
+		return ERR_PTR(-EINVAL);
+
+	t = st_ops->type;
+
+	st_map_size = sizeof(*st_map) +
+		/* kvalue stores the
+		 * struct bpf_struct_ops_tcp_congestions_ops
+		 */
+		(vt->size - sizeof(struct bpf_struct_ops_value));
+	map_total_size = st_map_size +
+		/* uvalue */
+		sizeof(vt->size) +
+		/* struct bpf_progs **progs */
+		 btf_type_vlen(t) * sizeof(struct bpf_prog *);
+	err = bpf_map_charge_init(&mem, map_total_size);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	st_map = bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
+	if (!st_map) {
+		bpf_map_charge_finish(&mem);
+		return ERR_PTR(-ENOMEM);
+	}
+	st_map->st_ops = st_ops;
+	map = &st_map->map;
+
+	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
+	st_map->progs =
+		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_prog *),
+				   NUMA_NO_NODE);
+	/* Each trampoline costs < 64 bytes.  Ensure one page
+	 * is enough for max number of func ptrs.
+	 */
+	BUILD_BUG_ON(PAGE_SIZE / 64 < BPF_STRUCT_OPS_MAX_NR_MEMBERS);
+	st_map->image = bpf_jit_alloc_exec(PAGE_SIZE);
+	if (!st_map->uvalue || !st_map->progs || !st_map->image) {
+		bpf_struct_ops_map_free(map);
+		bpf_map_charge_finish(&mem);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	spin_lock_init(&st_map->lock);
+	set_vm_flush_reset_perms(st_map->image);
+	set_memory_x((long)st_map->image, 1);
+	bpf_map_init_from_attr(map, attr);
+	bpf_map_charge_move(&map->memory, &mem);
+
+	return map;
+}
+
+const struct bpf_map_ops bpf_struct_ops_map_ops = {
+	.map_alloc_check = bpf_struct_ops_map_alloc_check,
+	.map_alloc = bpf_struct_ops_map_alloc,
+	.map_free = bpf_struct_ops_map_free,
+	.map_get_next_key = bpf_struct_ops_map_get_next_key,
+	.map_lookup_elem = bpf_struct_ops_map_lookup_elem,
+	.map_delete_elem = bpf_struct_ops_map_delete_elem,
+	.map_update_elem = bpf_struct_ops_map_update_elem,
+	.map_seq_show_elem = bpf_struct_ops_map_seq_show_elem,
+};
+
+/* "const void *" because some subsystem is
+ * passing a const (e.g. const struct tcp_congestion_ops *)
+ */
+bool bpf_struct_ops_get(const void *kdata)
+{
+	struct bpf_struct_ops_value *kvalue;
+
+	kvalue = container_of(kdata, struct bpf_struct_ops_value, data);
+
+	return refcount_inc_not_zero(&kvalue->refcnt);
+}
+
+void bpf_struct_ops_put(const void *kdata)
+{
+	struct bpf_struct_ops_value *kvalue;
+
+	kvalue = container_of(kdata, struct bpf_struct_ops_value, data);
+	if (refcount_dec_and_test(&kvalue->refcnt)) {
+		struct bpf_struct_ops_map *st_map;
+
+		st_map = container_of(kvalue, struct bpf_struct_ops_map,
+				      kvalue);
+		bpf_map_put(&st_map->map);
+	}
+}
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0e879a512cf4..0ef265170e1e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -500,13 +500,6 @@ static const char *btf_int_encoding_str(u8 encoding)
 		return "UNKN";
 }
 
-static u32 btf_member_bit_offset(const struct btf_type *struct_type,
-			     const struct btf_member *member)
-{
-	return btf_type_kflag(struct_type) ? BTF_MEMBER_BIT_OFFSET(member->offset)
-					   : member->offset;
-}
-
 static u32 btf_type_int(const struct btf_type *t)
 {
 	return *(u32 *)(t + 1);
@@ -1089,7 +1082,7 @@ static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
  * *elem_type: same as return type ("struct X")
  * *total_nelems: 1
  */
-static const struct btf_type *
+const struct btf_type *
 btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 		 u32 *type_size, const struct btf_type **elem_type,
 		 u32 *total_nelems)
@@ -1143,8 +1136,10 @@ btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 		return ERR_PTR(-EINVAL);
 
 	*type_size = nelems * size;
-	*total_nelems = nelems;
-	*elem_type = type;
+	if (total_nelems)
+		*total_nelems = nelems;
+	if (elem_type)
+		*elem_type = type;
 
 	return array_type ? : type;
 }
@@ -1858,7 +1853,10 @@ static void btf_modifier_seq_show(const struct btf *btf,
 				  u32 type_id, void *data,
 				  u8 bits_offset, struct seq_file *m)
 {
-	t = btf_type_id_resolve(btf, &type_id);
+	if (btf->resolved_ids)
+		t = btf_type_id_resolve(btf, &type_id);
+	else
+		t = btf_type_skip_modifiers(btf, type_id, NULL);
 
 	btf_type_ops(t)->seq_show(btf, t, type_id, data, bits_offset, m);
 }
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 5e9366b33f0f..b3c48d1533cb 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -22,7 +22,8 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	 */
 	if (inner_map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
 	    inner_map->map_type == BPF_MAP_TYPE_CGROUP_STORAGE ||
-	    inner_map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
+	    inner_map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE ||
+	    inner_map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
 		fdput(f);
 		return ERR_PTR(-ENOTSUPP);
 	}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 03a02ef4c496..a07800ec5023 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -628,7 +628,7 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 	return ret;
 }
 
-#define BPF_MAP_CREATE_LAST_FIELD btf_value_type_id
+#define BPF_MAP_CREATE_LAST_FIELD btf_vmlinux_value_type_id
 /* called via syscall */
 static int map_create(union bpf_attr *attr)
 {
@@ -642,6 +642,14 @@ static int map_create(union bpf_attr *attr)
 	if (err)
 		return -EINVAL;
 
+	if (attr->btf_vmlinux_value_type_id) {
+		if (attr->map_type != BPF_MAP_TYPE_STRUCT_OPS ||
+		    attr->btf_key_type_id || attr->btf_value_type_id)
+			return -EINVAL;
+	} else if (attr->btf_key_type_id && !attr->btf_value_type_id) {
+		return -EINVAL;
+	}
+
 	f_flags = bpf_get_file_flag(attr->map_flags);
 	if (f_flags < 0)
 		return f_flags;
@@ -664,32 +672,35 @@ static int map_create(union bpf_attr *attr)
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
 
-	if (attr->btf_key_type_id || attr->btf_value_type_id) {
+	map->spin_lock_off = -EINVAL;
+	if (attr->btf_key_type_id || attr->btf_value_type_id ||
+	    /* Even the map's value is a kernel's struct,
+	     * the bpf_prog.o must have BTF to begin with
+	     * to figure out the corresponding kernel's
+	     * counter part.  Thus, attr->btf_fd has
+	     * to be valid also.
+	     */
+	    attr->btf_vmlinux_value_type_id) {
 		struct btf *btf;
 
-		if (!attr->btf_value_type_id) {
-			err = -EINVAL;
-			goto free_map;
-		}
-
 		btf = btf_get_by_fd(attr->btf_fd);
 		if (IS_ERR(btf)) {
 			err = PTR_ERR(btf);
 			goto free_map;
 		}
+		map->btf = btf;
 
-		err = map_check_btf(map, btf, attr->btf_key_type_id,
-				    attr->btf_value_type_id);
-		if (err) {
-			btf_put(btf);
-			goto free_map;
+		if (attr->btf_value_type_id) {
+			err = map_check_btf(map, btf, attr->btf_key_type_id,
+					    attr->btf_value_type_id);
+			if (err)
+				goto free_map;
 		}
 
-		map->btf = btf;
 		map->btf_key_type_id = attr->btf_key_type_id;
 		map->btf_value_type_id = attr->btf_value_type_id;
-	} else {
-		map->spin_lock_off = -EINVAL;
+		map->btf_vmlinux_value_type_id =
+			attr->btf_vmlinux_value_type_id;
 	}
 
 	err = security_bpf_map_alloc(map);
@@ -888,6 +899,9 @@ static int map_lookup_elem(union bpf_attr *attr)
 	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
 		   map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_peek_elem(map, value);
+	} else if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+		/* struct_ops map requires directly updating "value" */
+		err = bpf_struct_ops_map_sys_lookup_elem(map, key, value);
 	} else {
 		rcu_read_lock();
 		if (map->ops->map_lookup_elem_sys_only)
@@ -1092,7 +1106,9 @@ static int map_delete_elem(union bpf_attr *attr)
 	if (bpf_map_is_dev_bound(map)) {
 		err = bpf_map_offload_delete_elem(map, key);
 		goto out;
-	} else if (IS_FD_PROG_ARRAY(map)) {
+	} else if (IS_FD_PROG_ARRAY(map) ||
+		   map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+		/* These maps require sleepable context */
 		err = map->ops->map_delete_elem(map, key);
 		goto out;
 	}
@@ -2822,6 +2838,7 @@ static int bpf_map_get_info_by_fd(struct bpf_map *map,
 		info.btf_key_type_id = map->btf_key_type_id;
 		info.btf_value_type_id = map->btf_value_type_id;
 	}
+	info.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
 
 	if (bpf_map_is_dev_bound(map)) {
 		err = bpf_map_offload_info_fill(&info, map);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 5ee301ddbd00..610109cfc7a8 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -110,7 +110,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 					  fentry, fentry_cnt,
 					  fexit, fexit_cnt,
 					  tr->func.addr);
-	if (err)
+	if (err < 0)
 		goto out;
 
 	if (tr->selector)
@@ -244,7 +244,8 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
 }
 
 int __weak
-arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags,
+arch_prepare_bpf_trampoline(void *image,
+			    const struct btf_func_model *m, u32 flags,
 			    struct bpf_prog **fentry_progs, int fentry_cnt,
 			    struct bpf_prog **fexit_progs, int fexit_cnt,
 			    void *orig_call)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4c1eaa1a2965..990f13165c52 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8149,6 +8149,11 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+		verbose(env, "bpf_struct_ops map cannot be used in prog\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.17.1

