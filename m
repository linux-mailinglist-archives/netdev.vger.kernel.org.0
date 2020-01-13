Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CE4138E08
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAMJnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:43:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45570 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726985AbgAMJnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 04:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578908601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8hlSNSNVOKHGBACDCM6EbrYp53LzUwSDZSf/KnL0MI=;
        b=Hsg1KGZLILN9IJb4TZHTqO39o9fP4ETqDmo0X91nItfum20rEZZIuvFdWOstvWsf++nN9H
        JAO8o1LghVhWGV9Yu+Zf5ZnSysWA2MCvAyhU6z9x1+xLF/mKgrE5q0YYYBFXCLHVwHjOnm
        rg8S5OUcqjvKznJvzIzYJfQdbtn/eBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-YoRyoQFbOl-aY79bXXhRmw-1; Mon, 13 Jan 2020 04:43:17 -0500
X-MC-Unique: YoRyoQFbOl-aY79bXXhRmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD1CA18B5FA6;
        Mon, 13 Jan 2020 09:43:15 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41B4D5C28D;
        Mon, 13 Jan 2020 09:43:12 +0000 (UTC)
Date:   Mon, 13 Jan 2020 10:43:10 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
Message-ID: <20200113094310.GE35080@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp>
 <20200107130546.GI290055@krava>
 <76a10338-391a-ffca-9af8-f407265d146a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <76a10338-391a-ffca-9af8-f407265d146a@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 02:30:35PM +0100, Bj=F6rn T=F6pel wrote:
> On 2020-01-07 14:05, Jiri Olsa wrote:
> > On Mon, Jan 06, 2020 at 03:46:40PM -0800, Alexei Starovoitov wrote:
> > > On Sun, Dec 29, 2019 at 03:37:40PM +0100, Jiri Olsa wrote:
> > > > When unwinding the stack we need to identify each
> > > > address to successfully continue. Adding latch tree
> > > > to keep trampolines for quick lookup during the
> > > > unwind.
> > > >=20
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ...
> > > > +bool is_bpf_trampoline(void *addr)
> > > > +{
> > > > +	return latch_tree_find(addr, &tree, &tree_ops) !=3D NULL;
> > > > +}
> > > > +
> > > >   struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> > > >   {
> > > >   	struct bpf_trampoline *tr;
> > > > @@ -65,6 +98,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u6=
4 key)
> > > >   	for (i =3D 0; i < BPF_TRAMP_MAX; i++)
> > > >   		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> > > >   	tr->image =3D image;
> > > > +	latch_tree_insert(&tr->tnode, &tree, &tree_ops);
> > >=20
> > > Thanks for the fix. I was thinking to apply it, but then realized t=
hat bpf
> > > dispatcher logic has the same issue.
> > > Could you generalize the fix for both?
> > > May be bpf_jit_alloc_exec_page() can do latch_tree_insert() ?
> > > and new version of bpf_jit_free_exec() is needed that will do latch=
_tree_erase().
> > > Wdyt?
> >=20
> > I need to check the dispatcher code, but seems ok.. will check
> >=20
>=20
> Thanks Jiri! The trampoline and dispatcher share the image allocation, =
so
> putting it there would make sense.
>=20
> It's annoying that the dispatcher doesn't show up correctly in perf, an=
d
> it's been on my list to fix that. Hopefully you beat me to it! :-D

hi,
attached patch seems to work for me (trampoline usecase), but I don't kno=
w
how to test it for dispatcher.. also I need to check if we need to decrea=
se
BPF_TRAMP_MAX or BPF_DISPATCHER_MAX, it might take more time ;-)

jirka


---
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index aed2bc39d72b..e0ca8780dc7a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -510,7 +510,6 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)=
;
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
-void *bpf_jit_alloc_exec_page(void);
 #define BPF_DISPATCHER_INIT(name) {			\
 	.mutex =3D __MUTEX_INITIALIZER(name.mutex),	\
 	.func =3D &name##func,				\
@@ -542,6 +541,13 @@ void *bpf_jit_alloc_exec_page(void);
 #define BPF_DISPATCHER_PTR(name) (&name)
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_pro=
g *from,
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
@@ -563,6 +569,10 @@ static inline void bpf_trampoline_put(struct bpf_tra=
mpoline *tr) {}
 static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
 					      struct bpf_prog *from,
 					      struct bpf_prog *to) {}
+static inline bool is_bpf_image(void *addr)
+{
+	return false;
+}
 #endif
=20
 struct bpf_func_info_aux {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 29d47aae0dd1..53dc3adf6077 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -704,6 +704,8 @@ bool is_bpf_text_address(unsigned long addr)
=20
 	rcu_read_lock();
 	ret =3D bpf_prog_kallsyms_find(addr) !=3D NULL;
+	if (!ret)
+		ret =3D is_bpf_image((void*) addr);
 	rcu_read_unlock();
=20
 	return ret;
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index 204ee61a3904..b3e5b214fed8 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -113,7 +113,7 @@ static void bpf_dispatcher_update(struct bpf_dispatch=
er *d, int prev_num_progs)
 		noff =3D 0;
 	} else {
 		old =3D d->image + d->image_off;
-		noff =3D d->image_off ^ (PAGE_SIZE / 2);
+		noff =3D d->image_off ^ (BPF_IMAGE_SIZE / 2);
 	}
=20
 	new =3D d->num_progs ? d->image + noff : NULL;
@@ -140,7 +140,7 @@ void bpf_dispatcher_change_prog(struct bpf_dispatcher=
 *d, struct bpf_prog *from,
=20
 	mutex_lock(&d->mutex);
 	if (!d->image) {
-		d->image =3D bpf_jit_alloc_exec_page();
+		d->image =3D bpf_image_alloc();
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
=20
 /* btf_vmlinux has ~22k attachable functions. 1k htab is enough. */
 #define TRAMPOLINE_HASH_BITS 10
@@ -14,7 +15,12 @@ static struct hlist_head trampoline_table[TRAMPOLINE_T=
ABLE_SIZE];
 /* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
=20
-void *bpf_jit_alloc_exec_page(void)
+static struct latch_tree_root image_tree __cacheline_aligned;
+
+/* serializes access to image_tree */
+static DEFINE_MUTEX(image_mutex);
+
+static void *bpf_jit_alloc_exec_page(void)
 {
 	void *image;
=20
@@ -30,6 +36,62 @@ void *bpf_jit_alloc_exec_page(void)
 	return image;
 }
=20
+static __always_inline bool image_tree_less(struct latch_tree_node *a,
+				      struct latch_tree_node *b)
+{
+	struct bpf_image *ia =3D container_of(a, struct bpf_image, tnode);
+	struct bpf_image *ib =3D container_of(b, struct bpf_image, tnode);
+
+	return ia < ib;
+}
+
+static __always_inline int image_tree_comp(void *addr, struct latch_tree=
_node *n)
+{
+	void *image =3D container_of(n, struct bpf_image, tnode);
+
+	if (addr < image)
+		return -1;
+	if (addr >=3D image + PAGE_SIZE)
+		return 1;
+
+	return 0;
+}
+
+static const struct latch_tree_ops image_tree_ops =3D {
+	.less	=3D image_tree_less,
+	.comp	=3D image_tree_comp,
+};
+
+void *bpf_image_alloc(void)
+{
+	struct bpf_image *image;
+
+	image =3D bpf_jit_alloc_exec_page();
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
+	struct bpf_image *image =3D container_of(ptr, struct bpf_image, data);
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
+	return latch_tree_find(addr, &image_tree, &image_tree_ops) !=3D NULL;
+}
+
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -50,7 +112,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 		goto out;
=20
 	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
-	image =3D bpf_jit_alloc_exec_page();
+	image =3D bpf_image_alloc();
 	if (!image) {
 		kfree(tr);
 		tr =3D NULL;
@@ -125,14 +187,14 @@ static int register_fentry(struct bpf_trampoline *t=
r, void *new_addr)
 }
=20
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is =
~50
- * bytes on x86.  Pick a number to fit into PAGE_SIZE / 2
+ * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
  */
 #define BPF_MAX_TRAMP_PROGS 40
=20
 static int bpf_trampoline_update(struct bpf_trampoline *tr)
 {
-	void *old_image =3D tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
-	void *new_image =3D tr->image + (tr->selector & 1) * PAGE_SIZE/2;
+	void *old_image =3D tr->image + ((tr->selector + 1) & 1) * BPF_IMAGE_SI=
ZE/2;
+	void *new_image =3D tr->image + (tr->selector & 1) * BPF_IMAGE_SIZE/2;
 	struct bpf_prog *progs_to_run[BPF_MAX_TRAMP_PROGS];
 	int fentry_cnt =3D tr->progs_cnt[BPF_TRAMP_FENTRY];
 	int fexit_cnt =3D tr->progs_cnt[BPF_TRAMP_FEXIT];
@@ -160,7 +222,7 @@ static int bpf_trampoline_update(struct bpf_trampolin=
e *tr)
 	if (fexit_cnt)
 		flags =3D BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
=20
-	err =3D arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / =
2,
+	err =3D arch_prepare_bpf_trampoline(new_image, new_image + BPF_IMAGE_SI=
ZE / 2,
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

