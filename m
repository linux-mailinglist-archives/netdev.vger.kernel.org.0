Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC72146E1F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAWQP1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Jan 2020 11:15:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49054 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728767AbgAWQP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:15:26 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-9lZ3Uy2hMm67R-Hgd55K3w-1; Thu, 23 Jan 2020 11:15:18 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61DBB107ACC7;
        Thu, 23 Jan 2020 16:15:16 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1631784BBD;
        Thu, 23 Jan 2020 16:15:13 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 2/3] bpf: Allow to resolve bpf trampoline and dispatcher in unwind
Date:   Thu, 23 Jan 2020 17:15:07 +0100
Message-Id: <20200123161508.915203-3-jolsa@kernel.org>
In-Reply-To: <20200123161508.915203-1-jolsa@kernel.org>
References: <20200123161508.915203-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 9lZ3Uy2hMm67R-Hgd55K3w-1
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
 kernel/bpf/dispatcher.c |  4 +--
 kernel/bpf/trampoline.c | 80 ++++++++++++++++++++++++++++++++++++-----
 kernel/extable.c        |  7 ++--
 4 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a9687861fd7e..8e9ad3943cd9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -525,7 +525,6 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
-void *bpf_jit_alloc_exec_page(void);
 #define BPF_DISPATCHER_INIT(name) {			\
 	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
 	.func = &name##func,				\
@@ -557,6 +556,13 @@ void *bpf_jit_alloc_exec_page(void);
 #define BPF_DISPATCHER_PTR(name) (&name)
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 				struct bpf_prog *to);
+struct bpf_image {
+	struct latch_tree_node tnode;
+	unsigned char data[];
+};
+#define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
+bool is_bpf_image_address(unsigned long address);
+void *bpf_image_alloc(void);
 #else
 static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
@@ -578,6 +584,10 @@ static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
 					      struct bpf_prog *from,
 					      struct bpf_prog *to) {}
+static inline bool is_bpf_image_address(unsigned long address)
+{
+	return false;
+}
 #endif
 
 struct bpf_func_info_aux {
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
index eb64c245052b..6b264a92064b 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <linux/filter.h>
 #include <linux/ftrace.h>
+#include <linux/rbtree_latch.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -16,11 +17,12 @@ const struct bpf_prog_ops bpf_extension_prog_ops = {
 #define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
 
 static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
+static struct latch_tree_root image_tree __cacheline_aligned;
 
-/* serializes access to trampoline_table */
+/* serializes access to trampoline_table and image_tree */
 static DEFINE_MUTEX(trampoline_mutex);
 
-void *bpf_jit_alloc_exec_page(void)
+static void *bpf_jit_alloc_exec_page(void)
 {
 	void *image;
 
@@ -36,6 +38,64 @@ void *bpf_jit_alloc_exec_page(void)
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
+static void *__bpf_image_alloc(bool lock)
+{
+	struct bpf_image *image;
+
+	image = bpf_jit_alloc_exec_page();
+	if (!image)
+		return NULL;
+
+	if (lock)
+		mutex_lock(&trampoline_mutex);
+	latch_tree_insert(&image->tnode, &image_tree, &image_tree_ops);
+	if (lock)
+		mutex_unlock(&trampoline_mutex);
+	return image->data;
+}
+
+void *bpf_image_alloc(void)
+{
+	return __bpf_image_alloc(true);
+}
+
+bool is_bpf_image_address(unsigned long addr)
+{
+	bool ret;
+
+	rcu_read_lock();
+	ret = latch_tree_find((void *) addr, &image_tree, &image_tree_ops) != NULL;
+	rcu_read_unlock();
+
+	return ret;
+}
+
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -56,7 +116,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 		goto out;
 
 	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
-	image = bpf_jit_alloc_exec_page();
+	image = __bpf_image_alloc(false);
 	if (!image) {
 		kfree(tr);
 		tr = NULL;
@@ -131,14 +191,14 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
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
@@ -174,7 +234,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	 */
 	synchronize_rcu_tasks();
 
-	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
+	err = arch_prepare_bpf_trampoline(new_image, new_image + BPF_IMAGE_SIZE / 2,
 					  &tr->func.model, flags,
 					  fentry, fentry_cnt,
 					  fexit, fexit_cnt,
@@ -284,6 +344,8 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
+	struct bpf_image *image;
+
 	if (!tr)
 		return;
 	mutex_lock(&trampoline_mutex);
@@ -294,9 +356,11 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 		goto out;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
+	image = container_of(tr->image, struct bpf_image, data);
+	latch_tree_erase(&image->tnode, &image_tree, &image_tree_ops);
 	/* wait for tasks to get out of trampoline before freeing it */
 	synchronize_rcu_tasks();
-	bpf_jit_free_exec(tr->image);
+	bpf_jit_free_exec(image);
 	hlist_del(&tr->hlist);
 	kfree(tr);
 out:
diff --git a/kernel/extable.c b/kernel/extable.c
index f6920a11e28a..a0024f27d3a1 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -131,8 +131,9 @@ int kernel_text_address(unsigned long addr)
 	 * triggers a stack trace, or a WARN() that happens during
 	 * coming back from idle, or cpu on or offlining.
 	 *
-	 * is_module_text_address() as well as the kprobe slots
-	 * and is_bpf_text_address() require RCU to be watching.
+	 * is_module_text_address() as well as the kprobe slots,
+	 * is_bpf_text_address() and is_bpf_image_address require
+	 * RCU to be watching.
 	 */
 	no_rcu = !rcu_is_watching();
 
@@ -148,6 +149,8 @@ int kernel_text_address(unsigned long addr)
 		goto out;
 	if (is_bpf_text_address(addr))
 		goto out;
+	if (is_bpf_image_address(addr))
+		goto out;
 	ret = 0;
 out:
 	if (no_rcu)
-- 
2.24.1

