Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6531417CD
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 14:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgARNuX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Jan 2020 08:50:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726465AbgARNuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 08:50:23 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-tltGxbIoOuaj8sMW9UJoBg-1; Sat, 18 Jan 2020 08:50:17 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18CEC107ACC4;
        Sat, 18 Jan 2020 13:50:16 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-18.brq.redhat.com [10.40.204.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C708984BD1;
        Sat, 18 Jan 2020 13:50:13 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5/6] bpf: Allow to resolve bpf trampoline and dispatcher in unwind
Date:   Sat, 18 Jan 2020 14:49:44 +0100
Message-Id: <20200118134945.493811-6-jolsa@kernel.org>
In-Reply-To: <20200118134945.493811-1-jolsa@kernel.org>
References: <20200118134945.493811-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: tltGxbIoOuaj8sMW9UJoBg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unwinding the stack we need to identify each address
to successfully continue. Adding latch tree to keep trampolines
for quick lookup during the unwind.

The patch uses first 48 bytes for latch tree node, leaving 4048
bytes from the rest of the page for trampoline or dispatcher
generated code.

It's still enough not to affect trampoline and dispatcher progs
maximum counts.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     | 12 ++++++-
 kernel/bpf/core.c       |  2 ++
 kernel/bpf/dispatcher.c |  4 +--
 kernel/bpf/trampoline.c | 76 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e3b8f4ad183..41eb0cf663e8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -519,7 +519,6 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
-void *bpf_jit_alloc_exec_page(void);
 #define BPF_DISPATCHER_INIT(name) {			\
 	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
 	.func = &name##func,				\
@@ -551,6 +550,13 @@ void *bpf_jit_alloc_exec_page(void);
 #define BPF_DISPATCHER_PTR(name) (&name)
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 				struct bpf_prog *to);
+struct bpf_image {
+	struct latch_tree_node tnode;
+	unsigned char data[];
+};
+#define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
+bool is_bpf_image(void *addr);
+void *bpf_image_alloc(void);
 #else
 static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
@@ -572,6 +578,10 @@ static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
 					      struct bpf_prog *from,
 					      struct bpf_prog *to) {}
+static inline bool is_bpf_image(void *addr)
+{
+	return false;
+}
 #endif
 
 struct bpf_func_info_aux {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 29d47aae0dd1..b3299dc9adda 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -704,6 +704,8 @@ bool is_bpf_text_address(unsigned long addr)
 
 	rcu_read_lock();
 	ret = bpf_prog_kallsyms_find(addr) != NULL;
+	if (!ret)
+		ret = is_bpf_image((void *) addr);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index 204ee61a3904..b3e5b214fed8 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -113,7 +113,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 		noff = 0;
 	} else {
 		old = d->image + d->image_off;
-		noff = d->image_off ^ (PAGE_SIZE / 2);
+		noff = d->image_off ^ (BPF_IMAGE_SIZE / 2);
 	}
 
 	new = d->num_progs ? d->image + noff : NULL;
@@ -140,7 +140,7 @@ void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 
 	mutex_lock(&d->mutex);
 	if (!d->image) {
-		d->image = bpf_jit_alloc_exec_page();
+		d->image = bpf_image_alloc();
 		if (!d->image)
 			goto out;
 	}
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 79a04417050d..3ea56f89c68a 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <linux/filter.h>
 #include <linux/ftrace.h>
+#include <linux/rbtree_latch.h>
 
 /* btf_vmlinux has ~22k attachable functions. 1k htab is enough. */
 #define TRAMPOLINE_HASH_BITS 10
@@ -14,7 +15,12 @@ static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
 /* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
 
-void *bpf_jit_alloc_exec_page(void)
+static struct latch_tree_root image_tree __cacheline_aligned;
+
+/* serializes access to image_tree */
+static DEFINE_MUTEX(image_mutex);
+
+static void *bpf_jit_alloc_exec_page(void)
 {
 	void *image;
 
@@ -30,6 +36,62 @@ void *bpf_jit_alloc_exec_page(void)
 	return image;
 }
 
+static __always_inline bool image_tree_less(struct latch_tree_node *a,
+				      struct latch_tree_node *b)
+{
+	struct bpf_image *ia = container_of(a, struct bpf_image, tnode);
+	struct bpf_image *ib = container_of(b, struct bpf_image, tnode);
+
+	return ia < ib;
+}
+
+static __always_inline int image_tree_comp(void *addr, struct latch_tree_node *n)
+{
+	void *image = container_of(n, struct bpf_image, tnode);
+
+	if (addr < image)
+		return -1;
+	if (addr >= image + PAGE_SIZE)
+		return 1;
+
+	return 0;
+}
+
+static const struct latch_tree_ops image_tree_ops = {
+	.less	= image_tree_less,
+	.comp	= image_tree_comp,
+};
+
+void *bpf_image_alloc(void)
+{
+	struct bpf_image *image;
+
+	image = bpf_jit_alloc_exec_page();
+	if (!image)
+		return NULL;
+
+	mutex_lock(&image_mutex);
+	latch_tree_insert(&image->tnode, &image_tree, &image_tree_ops);
+	mutex_unlock(&image_mutex);
+	return image->data;
+}
+
+void bpf_image_delete(void *ptr)
+{
+	struct bpf_image *image = container_of(ptr, struct bpf_image, data);
+
+	mutex_lock(&image_mutex);
+	latch_tree_erase(&image->tnode, &image_tree, &image_tree_ops);
+	synchronize_rcu();
+	bpf_jit_free_exec(image);
+	mutex_unlock(&image_mutex);
+}
+
+bool is_bpf_image(void *addr)
+{
+	return latch_tree_find(addr, &image_tree, &image_tree_ops) != NULL;
+}
+
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -50,7 +112,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 		goto out;
 
 	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
-	image = bpf_jit_alloc_exec_page();
+	image = bpf_image_alloc();
 	if (!image) {
 		kfree(tr);
 		tr = NULL;
@@ -125,14 +187,14 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 }
 
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
- * bytes on x86.  Pick a number to fit into PAGE_SIZE / 2
+ * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
  */
 #define BPF_MAX_TRAMP_PROGS 40
 
 static int bpf_trampoline_update(struct bpf_trampoline *tr)
 {
-	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
-	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
+	void *old_image = tr->image + ((tr->selector + 1) & 1) * BPF_IMAGE_SIZE/2;
+	void *new_image = tr->image + (tr->selector & 1) * BPF_IMAGE_SIZE/2;
 	struct bpf_prog *progs_to_run[BPF_MAX_TRAMP_PROGS];
 	int fentry_cnt = tr->progs_cnt[BPF_TRAMP_FENTRY];
 	int fexit_cnt = tr->progs_cnt[BPF_TRAMP_FEXIT];
@@ -160,7 +222,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	if (fexit_cnt)
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
 
-	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
+	err = arch_prepare_bpf_trampoline(new_image, new_image + BPF_IMAGE_SIZE / 2,
 					  &tr->func.model, flags,
 					  fentry, fentry_cnt,
 					  fexit, fexit_cnt,
@@ -251,7 +313,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 		goto out;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
-	bpf_jit_free_exec(tr->image);
+	bpf_image_delete(tr->image);
 	hlist_del(&tr->hlist);
 	kfree(tr);
 out:
-- 
2.24.1

