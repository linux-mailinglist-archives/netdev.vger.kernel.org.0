Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01480350E13
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 06:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhDAE1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 00:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDAE0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 00:26:48 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B69C0613E6;
        Wed, 31 Mar 2021 21:26:44 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q5so510622pfh.10;
        Wed, 31 Mar 2021 21:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rTWtYl6RrXmuc+QuwlyOBa6YMGfVMr2Auea3BWxyaiY=;
        b=Zn/QygIHX7PvMg39XQG4cC/2yKtGc7ckS2dlLaUwnFxnsrhp6awvOIxAIky7YbnyKk
         tglqhrw0Cb3gW6tJpeO+s9JbxWslY6HhQwvte8KOE3J8OgMuo4JxJGmJ/HcXY01aYOhK
         OHEsYh30+VaoJ++plA30a07dbnTbF6BatjMSUjkq64s4eKUSiP8AR6gAxP6Y3Yz790wd
         LERwYgxL1UsZ8dU53zFPT5mBM81WK/x/Rkjuxwp6NV/qi50h7CeSHpV+qAHbEATTuwE9
         cTFetzXFd/XRxEQ5XRPW91rnQu5OIHHbvRu6gCmBpBWVqZTXhVuUA6i626Xa3fuh6siB
         lBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rTWtYl6RrXmuc+QuwlyOBa6YMGfVMr2Auea3BWxyaiY=;
        b=L1J8TJkAQSLtrrr52rhgzL5NCwqJ3B88geqXnh6B3YgkhlNy2jezGamD5Fl3aafd8f
         fP0d3HjKAzMsJiMP8bTdmp+CUW8rPw6vcAJWbpKWsry4dJjsjbTQVNbDu0wuvpm1Cm7P
         0VHd9kMzHnYtumPccnvbavPdQXKiVfNa+qP7sIlvDmuKDeMmZqY+PCkzF2BVa240WDec
         BygjYJaUyzcza5T+j0Mecmsl9jC8y9nH+cxBi4Gf1owa5g67itZcwnri3Jm+1atjxJzh
         gkItQZ7p1mgDHLlYP4rh6VGI+UDU55zSgE9iy+v4Nk+ZK3ybBgSuGioai/QIsM9Owgky
         61Jg==
X-Gm-Message-State: AOAM5338wipGgG94/RdA52rFmhThe9T7+EX9ISVZ4XPCdd8aLff0PJ0S
        Fk+h7EWA77FsnX629+GWhy1LI2Ik0rGKtA==
X-Google-Smtp-Source: ABdhPJynkxsp8XrvUVBj+YgDfPCIZIY1MojUGKfLmmE8g35yswzb+3KD6Af7vAc6WCG4XQ+kWxaWiA==
X-Received: by 2002:a63:614:: with SMTP id 20mr5943276pgg.406.1617251203976;
        Wed, 31 Mar 2021 21:26:43 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:8444:517d:2218:ebe7])
        by smtp.gmail.com with ESMTPSA id f16sm3225272pfj.220.2021.03.31.21.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 21:26:43 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, songmuchun@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: [RFC Patch bpf-next] bpf: introduce bpf timer
Date:   Wed, 31 Mar 2021 21:26:35 -0700
Message-Id: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

(This patch is still in early stage and obviously incomplete. I am sending
it out to get some high-level feedbacks. Please kindly ignore any coding
details for now and focus on the design.)

This patch introduces a bpf timer map and a syscall to create bpf timer
from user-space.

The reason why we have to use a map is because the lifetime of a timer,
without a map, we have to delete the timer before exiting the eBPF program,
this would significately limit its use cases. With a map, the timer can
stay as long as the map itself and can be actually updated via map update
API's too, where the key is the timer ID and the value is the timer expire
timer.

Timer creation is not easy either. In order to prevent users creating a
timer but not adding it to a map, we have to enforce this in the API which
takes a map parameter and adds the new timer into the map in one shot.

And because timer is asynchronous, we can not just use its callback like
bpf_for_each_map_elem(). More importantly, we have to properly reference
count its struct bpf_prog too. It seems impossible to do this either in
verifier or in JIT, so we have to make its callback code a separate eBPF
program and pass a program fd from user-space. Fortunately, timer callback
can still live in the same object file with the rest eBPF code and share
data too.

Here is a quick demo of the timer callback code:

static __u64
check_expired_elem(struct bpf_map *map, __u32 *key, __u64 *val,
                  int *data)
{
  u64 expires = *val;

  if (expires < bpf_jiffies64()) {
    bpf_map_delete_elem(map, key);
    *data++;
  }
  return 0;
}

SEC("timer")
u32 timer_callback(void)
{
  int count = 0;

  bpf_for_each_map_elem(&map, check_expired_elem, &count, 0);
  if (count)
     return 0; // not re-arm this timer
  else
     return 10; // reschedule this timer after 10 jiffies
}

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h       |   2 +
 include/linux/bpf_types.h |   1 +
 include/uapi/linux/bpf.h  |  15 +++
 kernel/bpf/Makefile       |   2 +-
 kernel/bpf/syscall.c      |  16 +++
 kernel/bpf/timer.c        | 238 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c     |   6 +
 7 files changed, 279 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/timer.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9fdd839b418c..196e8f2f8c12 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2078,4 +2078,6 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
 
+int bpf_timer_create(union bpf_attr *attr);
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index f883f01a5061..9e3afd2dbfc6 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -133,3 +133,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
 #ifdef CONFIG_NET
 BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
 #endif
+BPF_MAP_TYPE(BPF_MAP_TYPE_TIMER, timer_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 598716742593..627c0fbf9dac 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -841,6 +841,7 @@ enum bpf_cmd {
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
 	BPF_PROG_BIND_MAP,
+	BPF_TIMER_CREATE,
 };
 
 enum bpf_map_type {
@@ -874,6 +875,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_RINGBUF,
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
+	BPF_MAP_TYPE_TIMER,
 };
 
 /* Note that tracing related programs such as
@@ -916,6 +918,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_TIMER,
 };
 
 enum bpf_attach_type {
@@ -1436,6 +1439,12 @@ union bpf_attr {
 		__u32		flags;		/* extra flags */
 	} prog_bind_map;
 
+	struct { /* struct used by BPF_TIMER_CREATE command */
+		__u32		map_fd;
+		__u32		prog_fd;
+		__u32		flags;		/* timer flags */
+	} timer_create;
+
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
@@ -6013,4 +6022,10 @@ enum {
 	BTF_F_ZERO	=	(1ULL << 3),
 };
 
+/* bpf timer flags */
+enum {
+	BTF_TIMER_F_DEFERRABLE	= (1ULL << 0),
+	BTF_TIMER_F_PINNED	= (1ULL << 1),
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 7f33098ca63f..0215bfd1bcea 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -8,7 +8,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
-obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
+obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o timer.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9603de81811a..f423f0688bd5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4350,6 +4350,19 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
 	return ret;
 }
 
+#define BPF_TIMER_CREATE_LAST_FIELD timer_create.flags
+
+static int bpf_create_timer(union bpf_attr *attr)
+{
+	if (CHECK_ATTR(BPF_TIMER_CREATE))
+		return -EINVAL;
+
+	if (!bpf_capable())
+		return -EPERM;
+
+	return bpf_timer_create(attr);
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr;
@@ -4486,6 +4499,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_PROG_BIND_MAP:
 		err = bpf_prog_bind_map(&attr);
 		break;
+	case BPF_TIMER_CREATE:
+		err = bpf_create_timer(&attr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/kernel/bpf/timer.c b/kernel/bpf/timer.c
new file mode 100644
index 000000000000..0d7b5655e60a
--- /dev/null
+++ b/kernel/bpf/timer.c
@@ -0,0 +1,238 @@
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/err.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/filter.h>
+#include <uapi/linux/btf.h>
+
+struct bpf_timer_list {
+	struct timer_list timer;
+	struct bpf_prog *prog;
+	u64 expires;
+	s32 id;
+	struct rcu_head rcu;
+};
+
+struct bpf_timer_map {
+	struct bpf_map map;
+	struct idr timer_idr;
+	spinlock_t idr_lock;
+};
+
+static int timer_map_alloc_check(union bpf_attr *attr)
+{
+	if (attr->max_entries == 0 || attr->max_entries > INT_MAX ||
+	    attr->key_size != 4 || attr->value_size != 8)
+		return -EINVAL;
+
+	if (attr->map_flags & BPF_F_MMAPABLE)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct bpf_map *timer_map_alloc(union bpf_attr *attr)
+{
+	struct bpf_timer_map *tmap;
+
+	tmap = kzalloc(sizeof(*tmap), GFP_USER | __GFP_ACCOUNT);
+	if (!tmap)
+		return ERR_PTR(-ENOMEM);
+
+	bpf_map_init_from_attr(&tmap->map, attr);
+	spin_lock_init(&tmap->idr_lock);
+	idr_init(&tmap->timer_idr);
+	return &tmap->map;
+}
+
+static int bpf_timer_delete(int id, void *ptr, void *data)
+{
+	struct bpf_timer_list *t = ptr;
+
+	del_timer_sync(&t->timer);
+	kfree_rcu(t, rcu);
+	return 0;
+}
+
+static void timer_map_free(struct bpf_map *map)
+{
+	struct bpf_timer_map *tmap;
+
+	tmap = container_of(map, struct bpf_timer_map, map);
+	idr_for_each(&tmap->timer_idr, bpf_timer_delete, NULL);
+
+	rcu_barrier();
+	idr_destroy(&tmap->timer_idr);
+}
+
+static void *timer_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_timer_map *tmap;
+	s32 timer_id = *(s32 *)key;
+	struct bpf_timer_list *t;
+	void *ret = NULL;
+
+	tmap = container_of(map, struct bpf_timer_map, map);
+
+	rcu_read_lock();
+	t = idr_find(&tmap->timer_idr, timer_id);
+	if (t) {
+		t->expires = t->timer.expires;
+		ret = &t->expires;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static int timer_map_update_elem(struct bpf_map *map, void *key, void *value,
+				 u64 flags)
+{
+	u64 expires = *(u64 *)value;
+	s32 timer_id = *(s32 *)key;
+	struct bpf_timer_map *tmap;
+	struct bpf_timer_list *t;
+	int ret = 0;
+
+	tmap = container_of(map, struct bpf_timer_map, map);
+
+	rcu_read_lock();
+	t = idr_find(&tmap->timer_idr, timer_id);
+	if (!t)
+		ret = -ENOENT;
+	else
+		mod_timer(&t->timer, (unsigned long)expires);
+	rcu_read_unlock();
+	return ret;
+}
+
+static int timer_map_delete_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_timer_map *tmap;
+	s32 timer_id = *(s32 *)key;
+	struct bpf_timer_list *t;
+	unsigned long flags;
+
+	tmap = container_of(map, struct bpf_timer_map, map);
+	spin_lock_irqsave(&tmap->idr_lock, flags);
+	t = idr_remove(&tmap->timer_idr, timer_id);
+	spin_unlock_irqrestore(&tmap->idr_lock, flags);
+	if (!t)
+		return -ENOENT;
+	del_timer_sync(&t->timer);
+	bpf_prog_put(t->prog);
+	kfree_rcu(t, rcu);
+	return 0;
+}
+
+static int timer_map_get_next_key(struct bpf_map *map, void *key,
+				    void *next_key)
+{
+	struct bpf_timer_map *tmap;
+	s32 next_id = *(s32 *)key;
+	int ret = 0;
+
+	tmap = container_of(map, struct bpf_timer_map, map);
+	rcu_read_lock();
+	if (!idr_get_next(&tmap->timer_idr, &next_id))
+		ret = -ENOENT;
+	rcu_read_unlock();
+	*(s32 *)next_key = next_id;
+	return ret;
+}
+
+static int timer_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
+{
+	return -ENOTSUPP;
+}
+
+static int timer_map_btf_id;
+const struct bpf_map_ops timer_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = timer_map_alloc_check,
+	.map_alloc = timer_map_alloc,
+	.map_free = timer_map_free,
+	.map_mmap = timer_map_mmap,
+	.map_lookup_elem = timer_map_lookup_elem,
+	.map_update_elem = timer_map_update_elem,
+	.map_delete_elem = timer_map_delete_elem,
+	.map_get_next_key = timer_map_get_next_key,
+	.map_btf_name = "bpf_timer_map",
+	.map_btf_id = &timer_map_btf_id,
+};
+
+static void bpf_timer_callback(struct timer_list *t)
+{
+	struct bpf_timer_list *bt = from_timer(bt, t, timer);
+	u32 ret;
+
+	rcu_read_lock();
+	ret = BPF_PROG_RUN(bt->prog, NULL);
+	rcu_read_unlock();
+
+	if (ret)
+		mod_timer(&bt->timer, bt->timer.expires + ret);
+}
+
+int bpf_timer_create(union bpf_attr *attr)
+{
+	unsigned int flags, timer_flags = 0;
+	struct bpf_timer_map *tmap;
+	struct bpf_timer_list *t;
+	unsigned long irq_flags;
+	struct bpf_prog *prog;
+	struct bpf_map *map;
+	int ret = 0;
+
+	flags = attr->timer_create.flags;
+	if (flags & ~(BTF_TIMER_F_DEFERRABLE | BTF_TIMER_F_PINNED))
+		return -EINVAL;
+
+	prog = bpf_prog_get(attr->timer_create.prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+	if (prog->type != BPF_PROG_TYPE_TIMER) {
+		ret = -EINVAL;
+		goto out_prog_put;
+	}
+
+	map = bpf_map_get(attr->timer_create.map_fd);
+	if (IS_ERR(map)) {
+		ret = PTR_ERR(map);
+		goto out_prog_put;
+	}
+	if (map->map_type != BPF_MAP_TYPE_TIMER) {
+		ret = -EINVAL;
+		goto out_map_put;
+	}
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t) {
+		ret = -ENOMEM;
+		goto out_map_put;
+	}
+
+	if (flags & BTF_TIMER_F_DEFERRABLE)
+		timer_flags |= TIMER_DEFERRABLE;
+	if (flags & BTF_TIMER_F_PINNED)
+		timer_flags |= TIMER_PINNED;
+	timer_setup(&t->timer, bpf_timer_callback, timer_flags);
+	t->prog = prog;
+
+	tmap = container_of(map, struct bpf_timer_map, map);
+	spin_lock_irqsave(&tmap->idr_lock, irq_flags);
+	ret = idr_alloc_cyclic(&tmap->timer_idr, t, 0, INT_MAX, GFP_ATOMIC);
+	spin_unlock_irqrestore(&tmap->idr_lock, irq_flags);
+	if (ret < 0)
+		kfree(t);
+	else
+		t->id = ret;
+
+out_map_put:
+	bpf_map_put(map);
+out_prog_put:
+	if (ret)
+		bpf_prog_put(prog);
+	return ret;
+}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 852541a435ef..ed0cbce8dc4f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5991,6 +5991,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 	}
 
+	if (func_id == BPF_FUNC_map_delete_elem &&
+	    env->prog->type == BPF_PROG_TYPE_TIMER) {
+		verbose(env, "bpf_map_delete_elem() can't be called in a timer program\n");
+		return -EINVAL;
+	}
+
 	/* reset caller saved regs */
 	for (i = 0; i < CALLER_SAVED_REGS; i++) {
 		mark_reg_not_init(env, regs, caller_saved[i]);
-- 
2.25.1

