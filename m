Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67BA183A0A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgCLT51 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:57:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726824AbgCLT5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:57:25 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-95c27OYnPc6S23i34kjVUg-1; Thu, 12 Mar 2020 15:57:19 -0400
X-MC-Unique: 95c27OYnPc6S23i34kjVUg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D82B01937FC2;
        Thu, 12 Mar 2020 19:57:16 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F12345D9C5;
        Thu, 12 Mar 2020 19:57:10 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 12/15] bpf: Remove bpf_image tree
Date:   Thu, 12 Mar 2020 20:56:07 +0100
Message-Id: <20200312195610.346362-13-jolsa@kernel.org>
In-Reply-To: <20200312195610.346362-1-jolsa@kernel.org>
References: <20200312195610.346362-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have all the objects (bpf_prog, bpf_trampoline,
bpf_dispatcher) linked in bpf_tree, there's no need to have
separate bpf_image tree for images.

Reverting the bpf_image tree together with struct bpf_image,
because it's no longer needed.

Also removing bpf_image_alloc function and adding the original
bpf_jit_alloc_exec_page interface instead.

The kernel_text_address function can now rely only on is_bpf_text_address,
because it checks the bpf_tree that contains all the objects.

Keeping bpf_image_ksym_add and bpf_image_ksym_del because they are
useful wrappers with perf's ksymbol interface calls.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  8 +---
 kernel/bpf/dispatcher.c |  4 +-
 kernel/bpf/trampoline.c | 83 +++++------------------------------------
 kernel/extable.c        |  2 -
 4 files changed, 13 insertions(+), 84 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 95e13efe658a..8c9175320d6c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -583,14 +583,8 @@ void bpf_trampoline_put(struct bpf_trampoline *tr);
 #define BPF_DISPATCHER_PTR(name) (&bpf_dispatcher_##name)
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 				struct bpf_prog *to);
-struct bpf_image {
-	struct latch_tree_node tnode;
-	unsigned char data[];
-};
-#define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
-bool is_bpf_image_address(unsigned long address);
-void *bpf_image_alloc(void);
 /* Called only from JIT-enabled code, so there's no need for stubs. */
+void *bpf_jit_alloc_exec_page(void);
 void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
 void bpf_image_ksym_del(struct bpf_ksym *ksym);
 void bpf_ksym_add(struct bpf_ksym *ksym);
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index a2679bae9e73..2444bd15cc2d 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -113,7 +113,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 		noff = 0;
 	} else {
 		old = d->image + d->image_off;
-		noff = d->image_off ^ (BPF_IMAGE_SIZE / 2);
+		noff = d->image_off ^ (PAGE_SIZE / 2);
 	}
 
 	new = d->num_progs ? d->image + noff : NULL;
@@ -140,7 +140,7 @@ void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 
 	mutex_lock(&d->mutex);
 	if (!d->image) {
-		d->image = bpf_image_alloc();
+		d->image = bpf_jit_alloc_exec_page();
 		if (!d->image)
 			goto out;
 		bpf_image_ksym_add(d->image, &d->ksym);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 36549c9afec4..f42f700c1d28 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -18,12 +18,11 @@ const struct bpf_prog_ops bpf_extension_prog_ops = {
 #define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
 
 static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
-static struct latch_tree_root image_tree __cacheline_aligned;
 
-/* serializes access to trampoline_table and image_tree */
+/* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
 
-static void *bpf_jit_alloc_exec_page(void)
+void *bpf_jit_alloc_exec_page(void)
 {
 	void *image;
 
@@ -39,78 +38,20 @@ static void *bpf_jit_alloc_exec_page(void)
 	return image;
 }
 
-static __always_inline bool image_tree_less(struct latch_tree_node *a,
-				      struct latch_tree_node *b)
-{
-	struct bpf_image *ia = container_of(a, struct bpf_image, tnode);
-	struct bpf_image *ib = container_of(b, struct bpf_image, tnode);
-
-	return ia < ib;
-}
-
-static __always_inline int image_tree_comp(void *addr, struct latch_tree_node *n)
-{
-	void *image = container_of(n, struct bpf_image, tnode);
-
-	if (addr < image)
-		return -1;
-	if (addr >= image + PAGE_SIZE)
-		return 1;
-
-	return 0;
-}
-
-static const struct latch_tree_ops image_tree_ops = {
-	.less	= image_tree_less,
-	.comp	= image_tree_comp,
-};
-
-static void *__bpf_image_alloc(bool lock)
-{
-	struct bpf_image *image;
-
-	image = bpf_jit_alloc_exec_page();
-	if (!image)
-		return NULL;
-
-	if (lock)
-		mutex_lock(&trampoline_mutex);
-	latch_tree_insert(&image->tnode, &image_tree, &image_tree_ops);
-	if (lock)
-		mutex_unlock(&trampoline_mutex);
-	return image->data;
-}
-
-void *bpf_image_alloc(void)
-{
-	return __bpf_image_alloc(true);
-}
-
-bool is_bpf_image_address(unsigned long addr)
-{
-	bool ret;
-
-	rcu_read_lock();
-	ret = latch_tree_find((void *) addr, &image_tree, &image_tree_ops) != NULL;
-	rcu_read_unlock();
-
-	return ret;
-}
-
 void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
 {
 	ksym->start = (unsigned long) data;
-	ksym->end = ksym->start + BPF_IMAGE_SIZE;
+	ksym->end = ksym->start + PAGE_SIZE;
 	bpf_ksym_add(ksym);
 	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF, ksym->start,
-			   BPF_IMAGE_SIZE, false, ksym->name);
+			   PAGE_SIZE, false, ksym->name);
 }
 
 void bpf_image_ksym_del(struct bpf_ksym *ksym)
 {
 	bpf_ksym_del(ksym);
 	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF, ksym->start,
-			   BPF_IMAGE_SIZE, true, ksym->name);
+			   PAGE_SIZE, true, ksym->name);
 }
 
 static void bpf_trampoline_ksym_add(struct bpf_trampoline *tr)
@@ -141,7 +82,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 		goto out;
 
 	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
-	image = __bpf_image_alloc(false);
+	image = bpf_jit_alloc_exec_page();
 	if (!image) {
 		kfree(tr);
 		tr = NULL;
@@ -243,8 +184,8 @@ bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total)
 
 static int bpf_trampoline_update(struct bpf_trampoline *tr)
 {
-	void *old_image = tr->image + ((tr->selector + 1) & 1) * BPF_IMAGE_SIZE/2;
-	void *new_image = tr->image + (tr->selector & 1) * BPF_IMAGE_SIZE/2;
+	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
+	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
 	struct bpf_tramp_progs *tprogs;
 	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
 	int err, total;
@@ -272,7 +213,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 
 	synchronize_rcu_tasks();
 
-	err = arch_prepare_bpf_trampoline(new_image, new_image + BPF_IMAGE_SIZE / 2,
+	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
 					  &tr->func.model, flags, tprogs,
 					  tr->func.addr);
 	if (err < 0)
@@ -383,8 +324,6 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
-	struct bpf_image *image;
-
 	if (!tr)
 		return;
 	mutex_lock(&trampoline_mutex);
@@ -396,11 +335,9 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
 	bpf_image_ksym_del(&tr->ksym);
-	image = container_of(tr->image, struct bpf_image, data);
-	latch_tree_erase(&image->tnode, &image_tree, &image_tree_ops);
 	/* wait for tasks to get out of trampoline before freeing it */
 	synchronize_rcu_tasks();
-	bpf_jit_free_exec(image);
+	bpf_jit_free_exec(tr->image);
 	hlist_del(&tr->hlist);
 	kfree(tr);
 out:
diff --git a/kernel/extable.c b/kernel/extable.c
index a0024f27d3a1..7681f87e89dd 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -149,8 +149,6 @@ int kernel_text_address(unsigned long addr)
 		goto out;
 	if (is_bpf_text_address(addr))
 		goto out;
-	if (is_bpf_image_address(addr))
-		goto out;
 	ret = 0;
 out:
 	if (no_rcu)
-- 
2.24.1

