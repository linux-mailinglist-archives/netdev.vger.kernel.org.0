Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB08127CDC4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgI2Mqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:46:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387563AbgI2MqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:46:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601383567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbV+J9/KtxcaH+hTVWT3TUHtu7KMpcTHeUd/VbA6Vb0=;
        b=cjue1E8y8CeLWGnUgvkwQpVyU2f+hzTXPyf0q48h3CBDyxP1d+QcPW04L1aGytS7Ka+myd
        9tkCj2y6DJ7H2h6YEflIDg97KhePaLocytmd7XiyCXbzww//xK34CaDM1h+gAYU7DCmet4
        D43T2dttmaOP07+XuNrEmEA5wg1yC3Y=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-4a7ZP0YjMhigamJLUClkMQ-1; Tue, 29 Sep 2020 08:46:04 -0400
X-MC-Unique: 4a7ZP0YjMhigamJLUClkMQ-1
Received: by mail-ot1-f70.google.com with SMTP id a3so3140167oti.2
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QbV+J9/KtxcaH+hTVWT3TUHtu7KMpcTHeUd/VbA6Vb0=;
        b=UgDgnIJH5f1mN3NhsbYuEAp/BPU46iMAg2njrXrPbKwBgiO1jrTMS0xCkbMkTMUbOn
         fR2IJ+QutOY9L53U3AzwnJb/vDmgElIGZA9BTjndHUK4ZqzxCsVvVT11PHxvFKez+QsF
         r8YjAxqMmTKwpLYqGvOVaqJzPv6Nw92NLJS8+sr+CIiNTfTspmrsFICPArmekuLhQZB6
         D9OBlvMshn7dXIuE4gIdws1P1KO096oWGxTIeNYP8mdysf1rl0xz5wRr5Kyy1gAHTraa
         af3RbGVA50d41a7/PpuApZSutZc0v646nU6xafgj7GhP3AQ18fMvVb0rn7ovpRa8aXaD
         YtbQ==
X-Gm-Message-State: AOAM531ZfS2zxZZFxAB2bLyZXrfrCDfBMDguPaIGIa0FhRlT/R/TQr6n
        S+crUKHQ+VlMsFHz8//j2Ft5HCa1JdLuvzWSl2l8Imf8CdX4JiaQ5BaFCjCHUCeQSdTL6wu0CSi
        PGXTXoMdwqptKzRrf
X-Received: by 2002:a9d:4b19:: with SMTP id q25mr2796173otf.152.1601383558694;
        Tue, 29 Sep 2020 05:45:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzksNQIcCcgbGWUkHdwPjBUMnjjOD7FM7peGAr7xBklp2Y72BmCp80NN5MMnIZyFEaA7m9fiQ==
X-Received: by 2002:a9d:4b19:: with SMTP id q25mr2796131otf.152.1601383557801;
        Tue, 29 Sep 2020 05:45:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a4sm965106oif.3.2020.09.29.05.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:45:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A8DD9183C5C; Tue, 29 Sep 2020 14:45:50 +0200 (CEST)
Subject: [PATCH bpf-next v10 1/7] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 29 Sep 2020 14:45:50 +0200
Message-ID: <160138355059.48470.2503076992210324984.stgit@toke.dk>
In-Reply-To: <160138354947.48470.11523413403103182788.stgit@toke.dk>
References: <160138354947.48470.11523413403103182788.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

In preparation for allowing multiple attachments of freplace programs, move
the references to the target program and trampoline into the
bpf_tracing_link structure when that is created. To do this atomically,
introduce a new mutex in prog->aux to protect writing to the two pointers
to target prog and trampoline, and rename the members to make it clear that
they are related.

With this change, it is no longer possible to attach the same tracing
program multiple times (detaching in-between), since the reference from the
tracing program to the target disappears on the first attach. However,
since the next patch will let the caller supply an attach target, that will
also make it possible to attach to the same place multiple times.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h                           |   15 +
 kernel/bpf/btf.c                              |    6 
 kernel/bpf/core.c                             |    9 -
 kernel/bpf/preload/iterators/iterators.bpf.c  |    4 
 kernel/bpf/preload/iterators/iterators.skel.h |  444 +++++++++++++------------
 kernel/bpf/syscall.c                          |   56 ++-
 kernel/bpf/trampoline.c                       |   12 -
 kernel/bpf/verifier.c                         |   11 -
 8 files changed, 298 insertions(+), 259 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 768b533ba48e..839dd8670a7a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -640,8 +640,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
 #ifdef CONFIG_BPF_JIT
-int bpf_trampoline_link_prog(struct bpf_prog *prog);
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
@@ -688,11 +688,13 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym);
 void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
 #else
-static inline int bpf_trampoline_link_prog(struct bpf_prog *prog)
+static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
+					   struct bpf_trampoline *tr)
 {
 	return -ENOTSUPP;
 }
-static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
+static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
+					     struct bpf_trampoline *tr)
 {
 	return -ENOTSUPP;
 }
@@ -763,7 +765,9 @@ struct bpf_prog_aux {
 	u32 max_rdonly_access;
 	u32 max_rdwr_access;
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
-	struct bpf_prog *linked_prog;
+	struct mutex dst_mutex; /* protects dst_* pointers below, *after* prog becomes visible */
+	struct bpf_prog *dst_prog;
+	struct bpf_trampoline *dst_trampoline;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
@@ -771,7 +775,6 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	enum bpf_tramp_prog_type trampoline_prog_type;
-	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 498e5e553825..05816471bac6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4428,7 +4428,7 @@ struct btf *btf_parse_vmlinux(void)
 
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 {
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *tgt_prog = prog->aux->dst_prog;
 
 	if (tgt_prog) {
 		return tgt_prog->aux->btf;
@@ -4455,7 +4455,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    struct bpf_insn_access_aux *info)
 {
 	const struct btf_type *t = prog->aux->attach_func_proto;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *tgt_prog = prog->aux->dst_prog;
 	struct btf *btf = bpf_prog_get_target_btf(prog);
 	const char *tname = prog->aux->attach_func_name;
 	struct bpf_verifier_log *log = info->log;
@@ -5281,7 +5281,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 		return -EFAULT;
 	}
 	if (prog_type == BPF_PROG_TYPE_EXT)
-		prog_type = prog->aux->linked_prog->type;
+		prog_type = prog->aux->dst_prog->type;
 
 	t = btf_type_by_id(btf, t->type);
 	if (!t || !btf_type_is_func_proto(t)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c4ba45fa4fe1..cda674f1392f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -99,6 +99,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
+	mutex_init(&fp->aux->dst_mutex);
 
 	return fp;
 }
@@ -255,6 +256,7 @@ void __bpf_prog_free(struct bpf_prog *fp)
 {
 	if (fp->aux) {
 		mutex_destroy(&fp->aux->used_maps_mutex);
+		mutex_destroy(&fp->aux->dst_mutex);
 		free_percpu(fp->aux->stats);
 		kfree(fp->aux->poke_tab);
 		kfree(fp->aux);
@@ -2138,7 +2140,8 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
 #endif
-	bpf_trampoline_put(aux->trampoline);
+	if (aux->dst_trampoline)
+		bpf_trampoline_put(aux->dst_trampoline);
 	for (i = 0; i < aux->func_cnt; i++)
 		bpf_jit_free(aux->func[i]);
 	if (aux->func_cnt) {
@@ -2154,8 +2157,8 @@ void bpf_prog_free(struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
 
-	if (aux->linked_prog)
-		bpf_prog_put(aux->linked_prog);
+	if (aux->dst_prog)
+		bpf_prog_put(aux->dst_prog);
 	INIT_WORK(&aux->work, bpf_prog_free_deferred);
 	schedule_work(&aux->work);
 }
diff --git a/kernel/bpf/preload/iterators/iterators.bpf.c b/kernel/bpf/preload/iterators/iterators.bpf.c
index 5ded550b2ed6..52aa7b38e8b8 100644
--- a/kernel/bpf/preload/iterators/iterators.bpf.c
+++ b/kernel/bpf/preload/iterators/iterators.bpf.c
@@ -42,7 +42,7 @@ struct bpf_prog_aux {
 	__u32 id;
 	char name[16];
 	const char *attach_func_name;
-	struct bpf_prog *linked_prog;
+	struct bpf_prog *dst_prog;
 	struct bpf_func_info *func_info;
 	struct btf *btf;
 };
@@ -108,7 +108,7 @@ int dump_bpf_prog(struct bpf_iter__bpf_prog *ctx)
 
 	BPF_SEQ_PRINTF(seq, "%4u %-16s %s %s\n", aux->id,
 		       get_name(aux->btf, aux->func_info[0].type_id, aux->name),
-		       aux->attach_func_name, aux->linked_prog->aux->name);
+		       aux->attach_func_name, aux->dst_prog->aux->name);
 	return 0;
 }
 char LICENSE[] SEC("license") = "GPL";
diff --git a/kernel/bpf/preload/iterators/iterators.skel.h b/kernel/bpf/preload/iterators/iterators.skel.h
index c3171357dc4f..cf9a6a94b3a4 100644
--- a/kernel/bpf/preload/iterators/iterators.skel.h
+++ b/kernel/bpf/preload/iterators/iterators.skel.h
@@ -47,7 +47,7 @@ iterators_bpf__open_opts(const struct bpf_object_open_opts *opts)
 {
 	struct iterators_bpf *obj;
 
-	obj = (typeof(obj))calloc(1, sizeof(*obj));
+	obj = (struct iterators_bpf *)calloc(1, sizeof(*obj));
 	if (!obj)
 		return NULL;
 	if (iterators_bpf__create_skeleton(obj))
@@ -105,7 +105,7 @@ iterators_bpf__create_skeleton(struct iterators_bpf *obj)
 {
 	struct bpf_object_skeleton *s;
 
-	s = (typeof(s))calloc(1, sizeof(*s));
+	s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));
 	if (!s)
 		return -1;
 	obj->skeleton = s;
@@ -117,7 +117,7 @@ iterators_bpf__create_skeleton(struct iterators_bpf *obj)
 	/* maps */
 	s->map_cnt = 1;
 	s->map_skel_sz = sizeof(*s->maps);
-	s->maps = (typeof(s->maps))calloc(s->map_cnt, s->map_skel_sz);
+	s->maps = (struct bpf_map_skeleton *)calloc(s->map_cnt, s->map_skel_sz);
 	if (!s->maps)
 		goto err;
 
@@ -128,7 +128,7 @@ iterators_bpf__create_skeleton(struct iterators_bpf *obj)
 	/* programs */
 	s->prog_cnt = 2;
 	s->prog_skel_sz = sizeof(*s->progs);
-	s->progs = (typeof(s->progs))calloc(s->prog_cnt, s->prog_skel_sz);
+	s->progs = (struct bpf_prog_skeleton *)calloc(s->prog_cnt, s->prog_skel_sz);
 	if (!s->progs)
 		goto err;
 
@@ -140,10 +140,10 @@ iterators_bpf__create_skeleton(struct iterators_bpf *obj)
 	s->progs[1].prog = &obj->progs.dump_bpf_prog;
 	s->progs[1].link = &obj->links.dump_bpf_prog;
 
-	s->data_sz = 7128;
+	s->data_sz = 7176;
 	s->data = (void *)"\
 \x7f\x45\x4c\x46\x02\x01\x01\0\0\0\0\0\0\0\0\0\x01\0\xf7\0\x01\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\x18\x18\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\x40\0\x0f\0\
+\0\0\0\0\0\0\0\0\0\0\0\x48\x18\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\x40\0\x0f\0\
 \x0e\0\x79\x12\0\0\0\0\0\0\x79\x26\0\0\0\0\0\0\x79\x17\x08\0\0\0\0\0\x15\x07\
 \x1a\0\0\0\0\0\x79\x21\x10\0\0\0\0\0\x55\x01\x08\0\0\0\0\0\xbf\xa4\0\0\0\0\0\0\
 \x07\x04\0\0\xe8\xff\xff\xff\xbf\x61\0\0\0\0\0\0\x18\x02\0\0\0\0\0\0\0\0\0\0\0\
@@ -164,7 +164,7 @@ iterators_bpf__create_skeleton(struct iterators_bpf *obj)
 \x79\x86\0\0\0\0\0\0\xbf\xa1\0\0\0\0\0\0\x07\x01\0\0\xf8\xff\xff\xff\xb7\x02\0\
 \0\x08\0\0\0\x85\0\0\0\x71\0\0\0\xb7\x01\0\0\0\0\0\0\x79\xa3\xf8\xff\0\0\0\0\
 \x0f\x13\0\0\0\0\0\0\xbf\xa1\0\0\0\0\0\0\x07\x01\0\0\xf4\xff\xff\xff\xb7\x02\0\
-\0\x04\0\0\0\x85\0\0\0\x04\0\0\0\xb7\x03\0\0\x04\0\0\0\x61\xa1\xf4\xff\0\0\0\0\
+\0\x04\0\0\0\x85\0\0\0\x71\0\0\0\xb7\x03\0\0\x04\0\0\0\x61\xa1\xf4\xff\0\0\0\0\
 \x61\x82\x10\0\0\0\0\0\x3d\x21\x02\0\0\0\0\0\x0f\x16\0\0\0\0\0\0\xbf\x69\0\0\0\
 \0\0\0\x7b\x9a\xd8\xff\0\0\0\0\x79\x71\x18\0\0\0\0\0\x7b\x1a\xe0\xff\0\0\0\0\
 \x79\x71\x20\0\0\0\0\0\x79\x11\0\0\0\0\0\0\x0f\x31\0\0\0\0\0\0\x7b\x1a\xe8\xff\
@@ -176,230 +176,232 @@ iterators_bpf__create_skeleton(struct iterators_bpf *obj)
 \x73\x25\x36\x64\x0a\0\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\x20\x20\x20\x20\x20\
 \x20\x20\x20\x20\x20\x20\x20\x20\x61\x74\x74\x61\x63\x68\x65\x64\x0a\0\x25\x34\
 \x75\x20\x25\x2d\x31\x36\x73\x20\x25\x73\x20\x25\x73\x0a\0\x47\x50\x4c\0\x9f\
-\xeb\x01\0\x18\0\0\0\0\0\0\0\x1c\x04\0\0\x1c\x04\0\0\0\x05\0\0\0\0\0\0\0\0\0\
+\xeb\x01\0\x18\0\0\0\0\0\0\0\x1c\x04\0\0\x1c\x04\0\0\x09\x05\0\0\0\0\0\0\0\0\0\
 \x02\x02\0\0\0\x01\0\0\0\x02\0\0\x04\x10\0\0\0\x13\0\0\0\x03\0\0\0\0\0\0\0\x18\
 \0\0\0\x04\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\x08\0\0\0\0\0\0\0\0\0\0\x02\x0d\0\
 \0\0\0\0\0\0\x01\0\0\x0d\x06\0\0\0\x1c\0\0\0\x01\0\0\0\x20\0\0\0\0\0\0\x01\x04\
-\0\0\0\x20\0\0\x01\x24\0\0\0\x01\0\0\x0c\x05\0\0\0\xa3\0\0\0\x03\0\0\x04\x18\0\
-\0\0\xb1\0\0\0\x09\0\0\0\0\0\0\0\xb5\0\0\0\x0b\0\0\0\x40\0\0\0\xc0\0\0\0\x0b\0\
-\0\0\x80\0\0\0\0\0\0\0\0\0\0\x02\x0a\0\0\0\xc8\0\0\0\0\0\0\x07\0\0\0\0\xd1\0\0\
-\0\0\0\0\x08\x0c\0\0\0\xd7\0\0\0\0\0\0\x01\x08\0\0\0\x40\0\0\0\x98\x01\0\0\x03\
-\0\0\x04\x18\0\0\0\xa0\x01\0\0\x0e\0\0\0\0\0\0\0\xa3\x01\0\0\x11\0\0\0\x20\0\0\
-\0\xa8\x01\0\0\x0e\0\0\0\xa0\0\0\0\xb4\x01\0\0\0\0\0\x08\x0f\0\0\0\xba\x01\0\0\
-\0\0\0\x01\x04\0\0\0\x20\0\0\0\xc7\x01\0\0\0\0\0\x01\x01\0\0\0\x08\0\0\x01\0\0\
-\0\0\0\0\0\x03\0\0\0\0\x10\0\0\0\x12\0\0\0\x10\0\0\0\xcc\x01\0\0\0\0\0\x01\x04\
-\0\0\0\x20\0\0\0\0\0\0\0\0\0\0\x02\x14\0\0\0\x30\x02\0\0\x02\0\0\x04\x10\0\0\0\
-\x13\0\0\0\x03\0\0\0\0\0\0\0\x43\x02\0\0\x15\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\
-\x18\0\0\0\0\0\0\0\x01\0\0\x0d\x06\0\0\0\x1c\0\0\0\x13\0\0\0\x48\x02\0\0\x01\0\
-\0\x0c\x16\0\0\0\x94\x02\0\0\x01\0\0\x04\x08\0\0\0\x9d\x02\0\0\x19\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\x02\x1a\0\0\0\xee\x02\0\0\x06\0\0\x04\x38\0\0\0\xa0\x01\0\0\
-\x0e\0\0\0\0\0\0\0\xa3\x01\0\0\x11\0\0\0\x20\0\0\0\xfb\x02\0\0\x1b\0\0\0\xc0\0\
-\0\0\x0c\x03\0\0\x15\0\0\0\0\x01\0\0\x18\x03\0\0\x1d\0\0\0\x40\x01\0\0\x22\x03\
+\0\0\0\x20\0\0\x01\x24\0\0\0\x01\0\0\x0c\x05\0\0\0\xaf\0\0\0\x03\0\0\x04\x18\0\
+\0\0\xbd\0\0\0\x09\0\0\0\0\0\0\0\xc1\0\0\0\x0b\0\0\0\x40\0\0\0\xcc\0\0\0\x0b\0\
+\0\0\x80\0\0\0\0\0\0\0\0\0\0\x02\x0a\0\0\0\xd4\0\0\0\0\0\0\x07\0\0\0\0\xdd\0\0\
+\0\0\0\0\x08\x0c\0\0\0\xe3\0\0\0\0\0\0\x01\x08\0\0\0\x40\0\0\0\xa4\x01\0\0\x03\
+\0\0\x04\x18\0\0\0\xac\x01\0\0\x0e\0\0\0\0\0\0\0\xaf\x01\0\0\x11\0\0\0\x20\0\0\
+\0\xb4\x01\0\0\x0e\0\0\0\xa0\0\0\0\xc0\x01\0\0\0\0\0\x08\x0f\0\0\0\xc6\x01\0\0\
+\0\0\0\x01\x04\0\0\0\x20\0\0\0\xd3\x01\0\0\0\0\0\x01\x01\0\0\0\x08\0\0\x01\0\0\
+\0\0\0\0\0\x03\0\0\0\0\x10\0\0\0\x12\0\0\0\x10\0\0\0\xd8\x01\0\0\0\0\0\x01\x04\
+\0\0\0\x20\0\0\0\0\0\0\0\0\0\0\x02\x14\0\0\0\x3c\x02\0\0\x02\0\0\x04\x10\0\0\0\
+\x13\0\0\0\x03\0\0\0\0\0\0\0\x4f\x02\0\0\x15\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\
+\x18\0\0\0\0\0\0\0\x01\0\0\x0d\x06\0\0\0\x1c\0\0\0\x13\0\0\0\x54\x02\0\0\x01\0\
+\0\x0c\x16\0\0\0\xa0\x02\0\0\x01\0\0\x04\x08\0\0\0\xa9\x02\0\0\x19\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\x02\x1a\0\0\0\xfa\x02\0\0\x06\0\0\x04\x38\0\0\0\xac\x01\0\0\
+\x0e\0\0\0\0\0\0\0\xaf\x01\0\0\x11\0\0\0\x20\0\0\0\x07\x03\0\0\x1b\0\0\0\xc0\0\
+\0\0\x18\x03\0\0\x15\0\0\0\0\x01\0\0\x21\x03\0\0\x1d\0\0\0\x40\x01\0\0\x2b\x03\
 \0\0\x1e\0\0\0\x80\x01\0\0\0\0\0\0\0\0\0\x02\x1c\0\0\0\0\0\0\0\0\0\0\x0a\x10\0\
-\0\0\0\0\0\0\0\0\0\x02\x1f\0\0\0\0\0\0\0\0\0\0\x02\x20\0\0\0\x6c\x03\0\0\x02\0\
-\0\x04\x08\0\0\0\x7a\x03\0\0\x0e\0\0\0\0\0\0\0\x83\x03\0\0\x0e\0\0\0\x20\0\0\0\
-\x22\x03\0\0\x03\0\0\x04\x18\0\0\0\x8d\x03\0\0\x1b\0\0\0\0\0\0\0\x95\x03\0\0\
-\x21\0\0\0\x40\0\0\0\x9b\x03\0\0\x23\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\x02\x22\0\0\
-\0\0\0\0\0\0\0\0\x02\x24\0\0\0\x9f\x03\0\0\x01\0\0\x04\x04\0\0\0\xaa\x03\0\0\
-\x0e\0\0\0\0\0\0\0\x13\x04\0\0\x01\0\0\x04\x04\0\0\0\x1c\x04\0\0\x0e\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1c\0\0\0\x12\0\0\0\x23\0\0\0\x92\x04\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\x02\x1f\0\0\0\0\0\0\0\0\0\0\x02\x20\0\0\0\x75\x03\0\0\x02\0\
+\0\x04\x08\0\0\0\x83\x03\0\0\x0e\0\0\0\0\0\0\0\x8c\x03\0\0\x0e\0\0\0\x20\0\0\0\
+\x2b\x03\0\0\x03\0\0\x04\x18\0\0\0\x96\x03\0\0\x1b\0\0\0\0\0\0\0\x9e\x03\0\0\
+\x21\0\0\0\x40\0\0\0\xa4\x03\0\0\x23\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\x02\x22\0\0\
+\0\0\0\0\0\0\0\0\x02\x24\0\0\0\xa8\x03\0\0\x01\0\0\x04\x04\0\0\0\xb3\x03\0\0\
+\x0e\0\0\0\0\0\0\0\x1c\x04\0\0\x01\0\0\x04\x04\0\0\0\x25\x04\0\0\x0e\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1c\0\0\0\x12\0\0\0\x23\0\0\0\x9b\x04\0\0\0\0\0\
 \x0e\x25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1c\0\0\0\x12\0\0\0\x0e\0\0\0\
-\xa6\x04\0\0\0\0\0\x0e\x27\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1c\0\0\0\
-\x12\0\0\0\x20\0\0\0\xbc\x04\0\0\0\0\0\x0e\x29\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\
-\0\0\0\0\x1c\0\0\0\x12\0\0\0\x11\0\0\0\xd1\x04\0\0\0\0\0\x0e\x2b\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\x03\0\0\0\0\x10\0\0\0\x12\0\0\0\x04\0\0\0\xe8\x04\0\0\0\0\0\x0e\
-\x2d\0\0\0\x01\0\0\0\xf0\x04\0\0\x04\0\0\x0f\0\0\0\0\x26\0\0\0\0\0\0\0\x23\0\0\
+\xaf\x04\0\0\0\0\0\x0e\x27\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1c\0\0\0\
+\x12\0\0\0\x20\0\0\0\xc5\x04\0\0\0\0\0\x0e\x29\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\
+\0\0\0\0\x1c\0\0\0\x12\0\0\0\x11\0\0\0\xda\x04\0\0\0\0\0\x0e\x2b\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x03\0\0\0\0\x10\0\0\0\x12\0\0\0\x04\0\0\0\xf1\x04\0\0\0\0\0\x0e\
+\x2d\0\0\0\x01\0\0\0\xf9\x04\0\0\x04\0\0\x0f\0\0\0\0\x26\0\0\0\0\0\0\0\x23\0\0\
 \0\x28\0\0\0\x23\0\0\0\x0e\0\0\0\x2a\0\0\0\x31\0\0\0\x20\0\0\0\x2c\0\0\0\x51\0\
-\0\0\x11\0\0\0\xf8\x04\0\0\x01\0\0\x0f\0\0\0\0\x2e\0\0\0\0\0\0\0\x04\0\0\0\0\
+\0\0\x11\0\0\0\x01\x05\0\0\x01\0\0\x0f\0\0\0\0\x2e\0\0\0\0\0\0\0\x04\0\0\0\0\
 \x62\x70\x66\x5f\x69\x74\x65\x72\x5f\x5f\x62\x70\x66\x5f\x6d\x61\x70\0\x6d\x65\
 \x74\x61\0\x6d\x61\x70\0\x63\x74\x78\0\x69\x6e\x74\0\x64\x75\x6d\x70\x5f\x62\
 \x70\x66\x5f\x6d\x61\x70\0\x69\x74\x65\x72\x2f\x62\x70\x66\x5f\x6d\x61\x70\0\
-\x30\x3a\x30\0\x2f\x77\x2f\x6e\x65\x74\x2d\x6e\x65\x78\x74\x2f\x6b\x65\x72\x6e\
-\x65\x6c\x2f\x62\x70\x66\x2f\x70\x72\x65\x6c\x6f\x61\x64\x2f\x69\x74\x65\x72\
-\x61\x74\x6f\x72\x73\x2f\x69\x74\x65\x72\x61\x74\x6f\x72\x73\x2e\x62\x70\x66\
-\x2e\x63\0\x09\x73\x74\x72\x75\x63\x74\x20\x73\x65\x71\x5f\x66\x69\x6c\x65\x20\
-\x2a\x73\x65\x71\x20\x3d\x20\x63\x74\x78\x2d\x3e\x6d\x65\x74\x61\x2d\x3e\x73\
-\x65\x71\x3b\0\x62\x70\x66\x5f\x69\x74\x65\x72\x5f\x6d\x65\x74\x61\0\x73\x65\
-\x71\0\x73\x65\x73\x73\x69\x6f\x6e\x5f\x69\x64\0\x73\x65\x71\x5f\x6e\x75\x6d\0\
-\x73\x65\x71\x5f\x66\x69\x6c\x65\0\x5f\x5f\x75\x36\x34\0\x6c\x6f\x6e\x67\x20\
-\x6c\x6f\x6e\x67\x20\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x30\x3a\
-\x31\0\x09\x73\x74\x72\x75\x63\x74\x20\x62\x70\x66\x5f\x6d\x61\x70\x20\x2a\x6d\
-\x61\x70\x20\x3d\x20\x63\x74\x78\x2d\x3e\x6d\x61\x70\x3b\0\x09\x69\x66\x20\x28\
-\x21\x6d\x61\x70\x29\0\x30\x3a\x32\0\x09\x5f\x5f\x75\x36\x34\x20\x73\x65\x71\
-\x5f\x6e\x75\x6d\x20\x3d\x20\x63\x74\x78\x2d\x3e\x6d\x65\x74\x61\x2d\x3e\x73\
-\x65\x71\x5f\x6e\x75\x6d\x3b\0\x09\x69\x66\x20\x28\x73\x65\x71\x5f\x6e\x75\x6d\
-\x20\x3d\x3d\x20\x30\x29\0\x09\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\x50\x52\x49\
-\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\
-\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x6d\x61\x78\x5f\x65\x6e\
-\x74\x72\x69\x65\x73\x5c\x6e\x22\x29\x3b\0\x62\x70\x66\x5f\x6d\x61\x70\0\x69\
-\x64\0\x6e\x61\x6d\x65\0\x6d\x61\x78\x5f\x65\x6e\x74\x72\x69\x65\x73\0\x5f\x5f\
-\x75\x33\x32\0\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x63\x68\x61\
-\x72\0\x5f\x5f\x41\x52\x52\x41\x59\x5f\x53\x49\x5a\x45\x5f\x54\x59\x50\x45\x5f\
-\x5f\0\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\x50\x52\x49\x4e\x54\x46\x28\x73\x65\
-\x71\x2c\x20\x22\x25\x34\x75\x20\x25\x2d\x31\x36\x73\x25\x36\x64\x5c\x6e\x22\
-\x2c\x20\x6d\x61\x70\x2d\x3e\x69\x64\x2c\x20\x6d\x61\x70\x2d\x3e\x6e\x61\x6d\
-\x65\x2c\x20\x6d\x61\x70\x2d\x3e\x6d\x61\x78\x5f\x65\x6e\x74\x72\x69\x65\x73\
-\x29\x3b\0\x7d\0\x62\x70\x66\x5f\x69\x74\x65\x72\x5f\x5f\x62\x70\x66\x5f\x70\
-\x72\x6f\x67\0\x70\x72\x6f\x67\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\
-\x6f\x67\0\x69\x74\x65\x72\x2f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x09\x73\x74\
-\x72\x75\x63\x74\x20\x62\x70\x66\x5f\x70\x72\x6f\x67\x20\x2a\x70\x72\x6f\x67\
-\x20\x3d\x20\x63\x74\x78\x2d\x3e\x70\x72\x6f\x67\x3b\0\x09\x69\x66\x20\x28\x21\
-\x70\x72\x6f\x67\x29\0\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x61\x75\x78\0\x09\x61\
-\x75\x78\x20\x3d\x20\x70\x72\x6f\x67\x2d\x3e\x61\x75\x78\x3b\0\x09\x09\x42\x50\
-\x46\x5f\x53\x45\x51\x5f\x50\x52\x49\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\
-\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\
-\x20\x20\x20\x61\x74\x74\x61\x63\x68\x65\x64\x5c\x6e\x22\x29\x3b\0\x62\x70\x66\
-\x5f\x70\x72\x6f\x67\x5f\x61\x75\x78\0\x61\x74\x74\x61\x63\x68\x5f\x66\x75\x6e\
-\x63\x5f\x6e\x61\x6d\x65\0\x6c\x69\x6e\x6b\x65\x64\x5f\x70\x72\x6f\x67\0\x66\
-\x75\x6e\x63\x5f\x69\x6e\x66\x6f\0\x62\x74\x66\0\x09\x42\x50\x46\x5f\x53\x45\
-\x51\x5f\x50\x52\x49\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\x25\x34\x75\x20\
-\x25\x2d\x31\x36\x73\x20\x25\x73\x20\x25\x73\x5c\x6e\x22\x2c\x20\x61\x75\x78\
-\x2d\x3e\x69\x64\x2c\0\x30\x3a\x34\0\x30\x3a\x35\0\x09\x69\x66\x20\x28\x21\x62\
-\x74\x66\x29\0\x62\x70\x66\x5f\x66\x75\x6e\x63\x5f\x69\x6e\x66\x6f\0\x69\x6e\
-\x73\x6e\x5f\x6f\x66\x66\0\x74\x79\x70\x65\x5f\x69\x64\0\x30\0\x73\x74\x72\x69\
-\x6e\x67\x73\0\x74\x79\x70\x65\x73\0\x68\x64\x72\0\x62\x74\x66\x5f\x68\x65\x61\
-\x64\x65\x72\0\x73\x74\x72\x5f\x6c\x65\x6e\0\x09\x74\x79\x70\x65\x73\x20\x3d\
-\x20\x62\x74\x66\x2d\x3e\x74\x79\x70\x65\x73\x3b\0\x09\x62\x70\x66\x5f\x70\x72\
-\x6f\x62\x65\x5f\x72\x65\x61\x64\x5f\x6b\x65\x72\x6e\x65\x6c\x28\x26\x74\x2c\
-\x20\x73\x69\x7a\x65\x6f\x66\x28\x74\x29\x2c\x20\x74\x79\x70\x65\x73\x20\x2b\
-\x20\x62\x74\x66\x5f\x69\x64\x29\x3b\0\x09\x73\x74\x72\x20\x3d\x20\x62\x74\x66\
-\x2d\x3e\x73\x74\x72\x69\x6e\x67\x73\x3b\0\x62\x74\x66\x5f\x74\x79\x70\x65\0\
-\x6e\x61\x6d\x65\x5f\x6f\x66\x66\0\x09\x6e\x61\x6d\x65\x5f\x6f\x66\x66\x20\x3d\
-\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\x5f\x52\x45\x41\x44\x28\x74\x2c\x20\x6e\
-\x61\x6d\x65\x5f\x6f\x66\x66\x29\x3b\0\x30\x3a\x32\x3a\x30\0\x09\x69\x66\x20\
-\x28\x6e\x61\x6d\x65\x5f\x6f\x66\x66\x20\x3e\x3d\x20\x62\x74\x66\x2d\x3e\x68\
-\x64\x72\x2e\x73\x74\x72\x5f\x6c\x65\x6e\x29\0\x09\x72\x65\x74\x75\x72\x6e\x20\
-\x73\x74\x72\x20\x2b\x20\x6e\x61\x6d\x65\x5f\x6f\x66\x66\x3b\0\x30\x3a\x33\0\
-\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\0\
-\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\
-\x2e\x31\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\
-\x66\x6d\x74\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\
-\x5f\x66\x6d\x74\x2e\x32\0\x4c\x49\x43\x45\x4e\x53\x45\0\x2e\x72\x6f\x64\x61\
-\x74\x61\0\x6c\x69\x63\x65\x6e\x73\x65\0\x9f\xeb\x01\0\x20\0\0\0\0\0\0\0\x24\0\
-\0\0\x24\0\0\0\x44\x02\0\0\x68\x02\0\0\xa4\x01\0\0\x08\0\0\0\x31\0\0\0\x01\0\0\
-\0\0\0\0\0\x07\0\0\0\x56\x02\0\0\x01\0\0\0\0\0\0\0\x17\0\0\0\x10\0\0\0\x31\0\0\
-\0\x09\0\0\0\0\0\0\0\x42\0\0\0\x7b\0\0\0\x1e\x40\x01\0\x08\0\0\0\x42\0\0\0\x7b\
-\0\0\0\x24\x40\x01\0\x10\0\0\0\x42\0\0\0\xf2\0\0\0\x1d\x48\x01\0\x18\0\0\0\x42\
-\0\0\0\x13\x01\0\0\x06\x50\x01\0\x20\0\0\0\x42\0\0\0\x22\x01\0\0\x1d\x44\x01\0\
-\x28\0\0\0\x42\0\0\0\x47\x01\0\0\x06\x5c\x01\0\x38\0\0\0\x42\0\0\0\x5a\x01\0\0\
-\x03\x60\x01\0\x70\0\0\0\x42\0\0\0\xe0\x01\0\0\x02\x68\x01\0\xf0\0\0\0\x42\0\0\
-\0\x2e\x02\0\0\x01\x70\x01\0\x56\x02\0\0\x1a\0\0\0\0\0\0\0\x42\0\0\0\x7b\0\0\0\
-\x1e\x84\x01\0\x08\0\0\0\x42\0\0\0\x7b\0\0\0\x24\x84\x01\0\x10\0\0\0\x42\0\0\0\
-\x64\x02\0\0\x1f\x8c\x01\0\x18\0\0\0\x42\0\0\0\x88\x02\0\0\x06\x98\x01\0\x20\0\
-\0\0\x42\0\0\0\xa1\x02\0\0\x0e\xa4\x01\0\x28\0\0\0\x42\0\0\0\x22\x01\0\0\x1d\
-\x88\x01\0\x30\0\0\0\x42\0\0\0\x47\x01\0\0\x06\xa8\x01\0\x40\0\0\0\x42\0\0\0\
-\xb3\x02\0\0\x03\xac\x01\0\x80\0\0\0\x42\0\0\0\x26\x03\0\0\x02\xb4\x01\0\xb8\0\
-\0\0\x42\0\0\0\x61\x03\0\0\x06\x08\x01\0\xd0\0\0\0\x42\0\0\0\0\0\0\0\0\0\0\0\
-\xd8\0\0\0\x42\0\0\0\xb2\x03\0\0\x0f\x14\x01\0\xe0\0\0\0\x42\0\0\0\xc7\x03\0\0\
-\x2d\x18\x01\0\xf0\0\0\0\x42\0\0\0\xfe\x03\0\0\x0d\x10\x01\0\0\x01\0\0\x42\0\0\
-\0\0\0\0\0\0\0\0\0\x08\x01\0\0\x42\0\0\0\xc7\x03\0\0\x02\x18\x01\0\x20\x01\0\0\
-\x42\0\0\0\x25\x04\0\0\x0d\x1c\x01\0\x38\x01\0\0\x42\0\0\0\0\0\0\0\0\0\0\0\x40\
-\x01\0\0\x42\0\0\0\x25\x04\0\0\x0d\x1c\x01\0\x58\x01\0\0\x42\0\0\0\x25\x04\0\0\
-\x0d\x1c\x01\0\x60\x01\0\0\x42\0\0\0\x53\x04\0\0\x1b\x20\x01\0\x68\x01\0\0\x42\
-\0\0\0\x53\x04\0\0\x06\x20\x01\0\x70\x01\0\0\x42\0\0\0\x76\x04\0\0\x0d\x28\x01\
-\0\x78\x01\0\0\x42\0\0\0\0\0\0\0\0\0\0\0\x80\x01\0\0\x42\0\0\0\x26\x03\0\0\x02\
-\xb4\x01\0\xf8\x01\0\0\x42\0\0\0\x2e\x02\0\0\x01\xc4\x01\0\x10\0\0\0\x31\0\0\0\
-\x07\0\0\0\0\0\0\0\x02\0\0\0\x3e\0\0\0\0\0\0\0\x08\0\0\0\x08\0\0\0\x3e\0\0\0\0\
-\0\0\0\x10\0\0\0\x02\0\0\0\xee\0\0\0\0\0\0\0\x20\0\0\0\x08\0\0\0\x1e\x01\0\0\0\
-\0\0\0\x70\0\0\0\x0d\0\0\0\x3e\0\0\0\0\0\0\0\x80\0\0\0\x0d\0\0\0\xee\0\0\0\0\0\
-\0\0\xa0\0\0\0\x0d\0\0\0\x1e\x01\0\0\0\0\0\0\x56\x02\0\0\x12\0\0\0\0\0\0\0\x14\
-\0\0\0\x3e\0\0\0\0\0\0\0\x08\0\0\0\x08\0\0\0\x3e\0\0\0\0\0\0\0\x10\0\0\0\x14\0\
-\0\0\xee\0\0\0\0\0\0\0\x20\0\0\0\x18\0\0\0\x3e\0\0\0\0\0\0\0\x28\0\0\0\x08\0\0\
-\0\x1e\x01\0\0\0\0\0\0\x80\0\0\0\x1a\0\0\0\x3e\0\0\0\0\0\0\0\x90\0\0\0\x1a\0\0\
-\0\xee\0\0\0\0\0\0\0\xa8\0\0\0\x1a\0\0\0\x59\x03\0\0\0\0\0\0\xb0\0\0\0\x1a\0\0\
-\0\x5d\x03\0\0\0\0\0\0\xc0\0\0\0\x1f\0\0\0\x8b\x03\0\0\0\0\0\0\xd8\0\0\0\x20\0\
-\0\0\xee\0\0\0\0\0\0\0\xf0\0\0\0\x20\0\0\0\x3e\0\0\0\0\0\0\0\x18\x01\0\0\x24\0\
-\0\0\x3e\0\0\0\0\0\0\0\x50\x01\0\0\x1a\0\0\0\xee\0\0\0\0\0\0\0\x60\x01\0\0\x20\
-\0\0\0\x4d\x04\0\0\0\0\0\0\x88\x01\0\0\x1a\0\0\0\x1e\x01\0\0\0\0\0\0\x98\x01\0\
-\0\x1a\0\0\0\x8e\x04\0\0\0\0\0\0\xa0\x01\0\0\x18\0\0\0\x3e\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xd6\0\0\0\0\0\x02\0\x70\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\xc8\0\0\0\0\0\x02\0\xf0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\xcf\0\0\0\0\0\x03\0\x78\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xc1\0\0\0\0\0\x03\0\x80\
-\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xba\0\0\0\0\0\x03\0\xf8\x01\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\x14\0\0\0\x01\0\x04\0\0\0\0\0\0\0\0\0\x23\0\0\0\0\0\0\0\xf4\0\0\0\
-\x01\0\x04\0\x23\0\0\0\0\0\0\0\x0e\0\0\0\0\0\0\0\x28\0\0\0\x01\0\x04\0\x31\0\0\
-\0\0\0\0\0\x20\0\0\0\0\0\0\0\xdd\0\0\0\x01\0\x04\0\x51\0\0\0\0\0\0\0\x11\0\0\0\
-\0\0\0\0\0\0\0\0\x03\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\x03\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\xb2\0\0\0\x11\0\x05\0\0\0\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\x3d\0\0\0\x12\
-\0\x02\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\x5b\0\0\0\x12\0\x03\0\0\0\0\0\0\0\0\
-\0\x08\x02\0\0\0\0\0\0\x48\0\0\0\0\0\0\0\x01\0\0\0\x0c\0\0\0\xc8\0\0\0\0\0\0\0\
-\x01\0\0\0\x0c\0\0\0\x50\0\0\0\0\0\0\0\x01\0\0\0\x0c\0\0\0\xd0\x01\0\0\0\0\0\0\
-\x01\0\0\0\x0c\0\0\0\xf0\x03\0\0\0\0\0\0\x0a\0\0\0\x0c\0\0\0\xfc\x03\0\0\0\0\0\
-\0\x0a\0\0\0\x0c\0\0\0\x08\x04\0\0\0\0\0\0\x0a\0\0\0\x0c\0\0\0\x14\x04\0\0\0\0\
-\0\0\x0a\0\0\0\x0c\0\0\0\x2c\x04\0\0\0\0\0\0\0\0\0\0\x0d\0\0\0\x2c\0\0\0\0\0\0\
-\0\0\0\0\0\x0a\0\0\0\x3c\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x50\0\0\0\0\0\0\0\0\0\
-\0\0\x0a\0\0\0\x60\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x70\0\0\0\0\0\0\0\0\0\0\0\
-\x0a\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x90\0\0\0\0\0\0\0\0\0\0\0\x0a\0\
-\0\0\xa0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\xb0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\
-\xc0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\xd0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\xe8\0\
-\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xf8\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x08\x01\0\0\
-\0\0\0\0\0\0\0\0\x0b\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x28\x01\0\0\0\
-\0\0\0\0\0\0\0\x0b\0\0\0\x38\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x48\x01\0\0\0\0\
-\0\0\0\0\0\0\x0b\0\0\0\x58\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x68\x01\0\0\0\0\0\
-\0\0\0\0\0\x0b\0\0\0\x78\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x88\x01\0\0\0\0\0\0\
-\0\0\0\0\x0b\0\0\0\x98\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xa8\x01\0\0\0\0\0\0\0\
-\0\0\0\x0b\0\0\0\xb8\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xc8\x01\0\0\0\0\0\0\0\0\
-\0\0\x0b\0\0\0\xd8\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xe8\x01\0\0\0\0\0\0\0\0\0\
-\0\x0b\0\0\0\xf8\x01\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x08\x02\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x18\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x28\x02\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x38\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x48\x02\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x58\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x68\x02\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x78\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x94\x02\0\0\0\0\0\0\0\0\0\0\
-\x0a\0\0\0\xa4\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\xb4\x02\0\0\0\0\0\0\0\0\0\0\
-\x0a\0\0\0\xc4\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\xd4\x02\0\0\0\0\0\0\0\0\0\0\
-\x0a\0\0\0\xe4\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\xf4\x02\0\0\0\0\0\0\0\0\0\0\
-\x0a\0\0\0\x0c\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x1c\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x2c\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x3c\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x4c\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x5c\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x6c\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x7c\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x8c\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x9c\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\xac\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xbc\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\xcc\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xdc\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\xec\x03\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xfc\x03\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x0c\x04\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x1c\x04\0\0\0\0\0\0\0\0\0\0\
-\x0b\0\0\0\x4e\x4f\x41\x42\x43\x44\x4d\0\x2e\x74\x65\x78\x74\0\x2e\x72\x65\x6c\
-\x2e\x42\x54\x46\x2e\x65\x78\x74\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\x61\
-\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\
-\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\
-\x61\x70\0\x2e\x72\x65\x6c\x69\x74\x65\x72\x2f\x62\x70\x66\x5f\x6d\x61\x70\0\
-\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x2e\x72\x65\x6c\x69\x74\
-\x65\x72\x2f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x2e\x6c\x6c\x76\x6d\x5f\x61\x64\
-\x64\x72\x73\x69\x67\0\x6c\x69\x63\x65\x6e\x73\x65\0\x2e\x73\x74\x72\x74\x61\
-\x62\0\x2e\x73\x79\x6d\x74\x61\x62\0\x2e\x72\x6f\x64\x61\x74\x61\0\x2e\x72\x65\
-\x6c\x2e\x42\x54\x46\0\x4c\x49\x43\x45\x4e\x53\x45\0\x4c\x42\x42\x31\x5f\x37\0\
-\x4c\x42\x42\x31\x5f\x36\0\x4c\x42\x42\x30\x5f\x34\0\x4c\x42\x42\x31\x5f\x33\0\
-\x4c\x42\x42\x30\x5f\x33\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\
-\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x32\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\
-\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x31\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x30\x3a\x30\0\x2f\x68\x6f\x6d\x65\x2f\x61\x6c\x72\x75\x61\x2f\x62\x75\x69\x6c\
+\x64\x2f\x6c\x69\x6e\x75\x78\x2f\x6b\x65\x72\x6e\x65\x6c\x2f\x62\x70\x66\x2f\
+\x70\x72\x65\x6c\x6f\x61\x64\x2f\x69\x74\x65\x72\x61\x74\x6f\x72\x73\x2f\x69\
+\x74\x65\x72\x61\x74\x6f\x72\x73\x2e\x62\x70\x66\x2e\x63\0\x09\x73\x74\x72\x75\
+\x63\x74\x20\x73\x65\x71\x5f\x66\x69\x6c\x65\x20\x2a\x73\x65\x71\x20\x3d\x20\
+\x63\x74\x78\x2d\x3e\x6d\x65\x74\x61\x2d\x3e\x73\x65\x71\x3b\0\x62\x70\x66\x5f\
+\x69\x74\x65\x72\x5f\x6d\x65\x74\x61\0\x73\x65\x71\0\x73\x65\x73\x73\x69\x6f\
+\x6e\x5f\x69\x64\0\x73\x65\x71\x5f\x6e\x75\x6d\0\x73\x65\x71\x5f\x66\x69\x6c\
+\x65\0\x5f\x5f\x75\x36\x34\0\x6c\x6f\x6e\x67\x20\x6c\x6f\x6e\x67\x20\x75\x6e\
+\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x30\x3a\x31\0\x09\x73\x74\x72\x75\
+\x63\x74\x20\x62\x70\x66\x5f\x6d\x61\x70\x20\x2a\x6d\x61\x70\x20\x3d\x20\x63\
+\x74\x78\x2d\x3e\x6d\x61\x70\x3b\0\x09\x69\x66\x20\x28\x21\x6d\x61\x70\x29\0\
+\x30\x3a\x32\0\x09\x5f\x5f\x75\x36\x34\x20\x73\x65\x71\x5f\x6e\x75\x6d\x20\x3d\
+\x20\x63\x74\x78\x2d\x3e\x6d\x65\x74\x61\x2d\x3e\x73\x65\x71\x5f\x6e\x75\x6d\
+\x3b\0\x09\x69\x66\x20\x28\x73\x65\x71\x5f\x6e\x75\x6d\x20\x3d\x3d\x20\x30\x29\
+\0\x09\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\x50\x52\x49\x4e\x54\x46\x28\x73\x65\
+\x71\x2c\x20\x22\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\x20\x20\x20\x20\x20\x20\
+\x20\x20\x20\x20\x20\x20\x20\x6d\x61\x78\x5f\x65\x6e\x74\x72\x69\x65\x73\x5c\
+\x6e\x22\x29\x3b\0\x62\x70\x66\x5f\x6d\x61\x70\0\x69\x64\0\x6e\x61\x6d\x65\0\
+\x6d\x61\x78\x5f\x65\x6e\x74\x72\x69\x65\x73\0\x5f\x5f\x75\x33\x32\0\x75\x6e\
+\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x63\x68\x61\x72\0\x5f\x5f\x41\x52\
+\x52\x41\x59\x5f\x53\x49\x5a\x45\x5f\x54\x59\x50\x45\x5f\x5f\0\x09\x42\x50\x46\
+\x5f\x53\x45\x51\x5f\x50\x52\x49\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\x25\
+\x34\x75\x20\x25\x2d\x31\x36\x73\x25\x36\x64\x5c\x6e\x22\x2c\x20\x6d\x61\x70\
+\x2d\x3e\x69\x64\x2c\x20\x6d\x61\x70\x2d\x3e\x6e\x61\x6d\x65\x2c\x20\x6d\x61\
+\x70\x2d\x3e\x6d\x61\x78\x5f\x65\x6e\x74\x72\x69\x65\x73\x29\x3b\0\x7d\0\x62\
+\x70\x66\x5f\x69\x74\x65\x72\x5f\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x70\x72\
+\x6f\x67\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x69\x74\x65\
+\x72\x2f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x09\x73\x74\x72\x75\x63\x74\x20\x62\
+\x70\x66\x5f\x70\x72\x6f\x67\x20\x2a\x70\x72\x6f\x67\x20\x3d\x20\x63\x74\x78\
+\x2d\x3e\x70\x72\x6f\x67\x3b\0\x09\x69\x66\x20\x28\x21\x70\x72\x6f\x67\x29\0\
+\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x61\x75\x78\0\x09\x61\x75\x78\x20\x3d\x20\
+\x70\x72\x6f\x67\x2d\x3e\x61\x75\x78\x3b\0\x09\x09\x42\x50\x46\x5f\x53\x45\x51\
+\x5f\x50\x52\x49\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\x20\x20\x69\x64\x20\
+\x6e\x61\x6d\x65\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x61\x74\
+\x74\x61\x63\x68\x65\x64\x5c\x6e\x22\x29\x3b\0\x62\x70\x66\x5f\x70\x72\x6f\x67\
+\x5f\x61\x75\x78\0\x61\x74\x74\x61\x63\x68\x5f\x66\x75\x6e\x63\x5f\x6e\x61\x6d\
+\x65\0\x64\x73\x74\x5f\x70\x72\x6f\x67\0\x66\x75\x6e\x63\x5f\x69\x6e\x66\x6f\0\
+\x62\x74\x66\0\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\x50\x52\x49\x4e\x54\x46\x28\
+\x73\x65\x71\x2c\x20\x22\x25\x34\x75\x20\x25\x2d\x31\x36\x73\x20\x25\x73\x20\
+\x25\x73\x5c\x6e\x22\x2c\x20\x61\x75\x78\x2d\x3e\x69\x64\x2c\0\x30\x3a\x34\0\
+\x30\x3a\x35\0\x09\x69\x66\x20\x28\x21\x62\x74\x66\x29\0\x62\x70\x66\x5f\x66\
+\x75\x6e\x63\x5f\x69\x6e\x66\x6f\0\x69\x6e\x73\x6e\x5f\x6f\x66\x66\0\x74\x79\
+\x70\x65\x5f\x69\x64\0\x30\0\x73\x74\x72\x69\x6e\x67\x73\0\x74\x79\x70\x65\x73\
+\0\x68\x64\x72\0\x62\x74\x66\x5f\x68\x65\x61\x64\x65\x72\0\x73\x74\x72\x5f\x6c\
+\x65\x6e\0\x09\x74\x79\x70\x65\x73\x20\x3d\x20\x62\x74\x66\x2d\x3e\x74\x79\x70\
+\x65\x73\x3b\0\x09\x62\x70\x66\x5f\x70\x72\x6f\x62\x65\x5f\x72\x65\x61\x64\x5f\
+\x6b\x65\x72\x6e\x65\x6c\x28\x26\x74\x2c\x20\x73\x69\x7a\x65\x6f\x66\x28\x74\
+\x29\x2c\x20\x74\x79\x70\x65\x73\x20\x2b\x20\x62\x74\x66\x5f\x69\x64\x29\x3b\0\
+\x09\x73\x74\x72\x20\x3d\x20\x62\x74\x66\x2d\x3e\x73\x74\x72\x69\x6e\x67\x73\
+\x3b\0\x62\x74\x66\x5f\x74\x79\x70\x65\0\x6e\x61\x6d\x65\x5f\x6f\x66\x66\0\x09\
+\x6e\x61\x6d\x65\x5f\x6f\x66\x66\x20\x3d\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\
+\x5f\x52\x45\x41\x44\x28\x74\x2c\x20\x6e\x61\x6d\x65\x5f\x6f\x66\x66\x29\x3b\0\
+\x30\x3a\x32\x3a\x30\0\x09\x69\x66\x20\x28\x6e\x61\x6d\x65\x5f\x6f\x66\x66\x20\
+\x3e\x3d\x20\x62\x74\x66\x2d\x3e\x68\x64\x72\x2e\x73\x74\x72\x5f\x6c\x65\x6e\
+\x29\0\x09\x72\x65\x74\x75\x72\x6e\x20\x73\x74\x72\x20\x2b\x20\x6e\x61\x6d\x65\
+\x5f\x6f\x66\x66\x3b\0\x30\x3a\x33\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\
+\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\
+\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x31\0\x64\x75\x6d\x70\x5f\x62\x70\x66\
+\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\x75\x6d\x70\x5f\x62\x70\
+\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x32\0\x4c\x49\x43\x45\
+\x4e\x53\x45\0\x2e\x72\x6f\x64\x61\x74\x61\0\x6c\x69\x63\x65\x6e\x73\x65\0\x9f\
+\xeb\x01\0\x20\0\0\0\0\0\0\0\x24\0\0\0\x24\0\0\0\x44\x02\0\0\x68\x02\0\0\xa4\
+\x01\0\0\x08\0\0\0\x31\0\0\0\x01\0\0\0\0\0\0\0\x07\0\0\0\x62\x02\0\0\x01\0\0\0\
+\0\0\0\0\x17\0\0\0\x10\0\0\0\x31\0\0\0\x09\0\0\0\0\0\0\0\x42\0\0\0\x87\0\0\0\
+\x1e\x40\x01\0\x08\0\0\0\x42\0\0\0\x87\0\0\0\x24\x40\x01\0\x10\0\0\0\x42\0\0\0\
+\xfe\0\0\0\x1d\x48\x01\0\x18\0\0\0\x42\0\0\0\x1f\x01\0\0\x06\x50\x01\0\x20\0\0\
+\0\x42\0\0\0\x2e\x01\0\0\x1d\x44\x01\0\x28\0\0\0\x42\0\0\0\x53\x01\0\0\x06\x5c\
+\x01\0\x38\0\0\0\x42\0\0\0\x66\x01\0\0\x03\x60\x01\0\x70\0\0\0\x42\0\0\0\xec\
+\x01\0\0\x02\x68\x01\0\xf0\0\0\0\x42\0\0\0\x3a\x02\0\0\x01\x70\x01\0\x62\x02\0\
+\0\x1a\0\0\0\0\0\0\0\x42\0\0\0\x87\0\0\0\x1e\x84\x01\0\x08\0\0\0\x42\0\0\0\x87\
+\0\0\0\x24\x84\x01\0\x10\0\0\0\x42\0\0\0\x70\x02\0\0\x1f\x8c\x01\0\x18\0\0\0\
+\x42\0\0\0\x94\x02\0\0\x06\x98\x01\0\x20\0\0\0\x42\0\0\0\xad\x02\0\0\x0e\xa4\
+\x01\0\x28\0\0\0\x42\0\0\0\x2e\x01\0\0\x1d\x88\x01\0\x30\0\0\0\x42\0\0\0\x53\
+\x01\0\0\x06\xa8\x01\0\x40\0\0\0\x42\0\0\0\xbf\x02\0\0\x03\xac\x01\0\x80\0\0\0\
+\x42\0\0\0\x2f\x03\0\0\x02\xb4\x01\0\xb8\0\0\0\x42\0\0\0\x6a\x03\0\0\x06\x08\
+\x01\0\xd0\0\0\0\x42\0\0\0\0\0\0\0\0\0\0\0\xd8\0\0\0\x42\0\0\0\xbb\x03\0\0\x0f\
+\x14\x01\0\xe0\0\0\0\x42\0\0\0\xd0\x03\0\0\x2d\x18\x01\0\xf0\0\0\0\x42\0\0\0\
+\x07\x04\0\0\x0d\x10\x01\0\0\x01\0\0\x42\0\0\0\0\0\0\0\0\0\0\0\x08\x01\0\0\x42\
+\0\0\0\xd0\x03\0\0\x02\x18\x01\0\x20\x01\0\0\x42\0\0\0\x2e\x04\0\0\x0d\x1c\x01\
+\0\x38\x01\0\0\x42\0\0\0\0\0\0\0\0\0\0\0\x40\x01\0\0\x42\0\0\0\x2e\x04\0\0\x0d\
+\x1c\x01\0\x58\x01\0\0\x42\0\0\0\x2e\x04\0\0\x0d\x1c\x01\0\x60\x01\0\0\x42\0\0\
+\0\x5c\x04\0\0\x1b\x20\x01\0\x68\x01\0\0\x42\0\0\0\x5c\x04\0\0\x06\x20\x01\0\
+\x70\x01\0\0\x42\0\0\0\x7f\x04\0\0\x0d\x28\x01\0\x78\x01\0\0\x42\0\0\0\0\0\0\0\
+\0\0\0\0\x80\x01\0\0\x42\0\0\0\x2f\x03\0\0\x02\xb4\x01\0\xf8\x01\0\0\x42\0\0\0\
+\x3a\x02\0\0\x01\xc4\x01\0\x10\0\0\0\x31\0\0\0\x07\0\0\0\0\0\0\0\x02\0\0\0\x3e\
+\0\0\0\0\0\0\0\x08\0\0\0\x08\0\0\0\x3e\0\0\0\0\0\0\0\x10\0\0\0\x02\0\0\0\xfa\0\
+\0\0\0\0\0\0\x20\0\0\0\x08\0\0\0\x2a\x01\0\0\0\0\0\0\x70\0\0\0\x0d\0\0\0\x3e\0\
+\0\0\0\0\0\0\x80\0\0\0\x0d\0\0\0\xfa\0\0\0\0\0\0\0\xa0\0\0\0\x0d\0\0\0\x2a\x01\
+\0\0\0\0\0\0\x62\x02\0\0\x12\0\0\0\0\0\0\0\x14\0\0\0\x3e\0\0\0\0\0\0\0\x08\0\0\
+\0\x08\0\0\0\x3e\0\0\0\0\0\0\0\x10\0\0\0\x14\0\0\0\xfa\0\0\0\0\0\0\0\x20\0\0\0\
+\x18\0\0\0\x3e\0\0\0\0\0\0\0\x28\0\0\0\x08\0\0\0\x2a\x01\0\0\0\0\0\0\x80\0\0\0\
+\x1a\0\0\0\x3e\0\0\0\0\0\0\0\x90\0\0\0\x1a\0\0\0\xfa\0\0\0\0\0\0\0\xa8\0\0\0\
+\x1a\0\0\0\x62\x03\0\0\0\0\0\0\xb0\0\0\0\x1a\0\0\0\x66\x03\0\0\0\0\0\0\xc0\0\0\
+\0\x1f\0\0\0\x94\x03\0\0\0\0\0\0\xd8\0\0\0\x20\0\0\0\xfa\0\0\0\0\0\0\0\xf0\0\0\
+\0\x20\0\0\0\x3e\0\0\0\0\0\0\0\x18\x01\0\0\x24\0\0\0\x3e\0\0\0\0\0\0\0\x50\x01\
+\0\0\x1a\0\0\0\xfa\0\0\0\0\0\0\0\x60\x01\0\0\x20\0\0\0\x56\x04\0\0\0\0\0\0\x88\
+\x01\0\0\x1a\0\0\0\x2a\x01\0\0\0\0\0\0\x98\x01\0\0\x1a\0\0\0\x97\x04\0\0\0\0\0\
+\0\xa0\x01\0\0\x18\0\0\0\x3e\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x91\0\0\0\x04\0\xf1\xff\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xe6\0\0\
+\0\0\0\x02\0\x70\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xd8\0\0\0\0\0\x02\0\xf0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\xdf\0\0\0\0\0\x03\0\x78\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\xd1\0\0\0\0\0\x03\0\x80\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xca\0\0\0\0\0\x03\0\
+\xf8\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x14\0\0\0\x01\0\x04\0\0\0\0\0\0\0\0\0\x23\
+\0\0\0\0\0\0\0\x04\x01\0\0\x01\0\x04\0\x23\0\0\0\0\0\0\0\x0e\0\0\0\0\0\0\0\x28\
+\0\0\0\x01\0\x04\0\x31\0\0\0\0\0\0\0\x20\0\0\0\0\0\0\0\xed\0\0\0\x01\0\x04\0\
+\x51\0\0\0\0\0\0\0\x11\0\0\0\0\0\0\0\0\0\0\0\x03\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\x03\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\
+\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xc2\0\0\0\x11\0\x05\0\0\0\0\0\0\0\0\0\
+\x04\0\0\0\0\0\0\0\x3d\0\0\0\x12\0\x02\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\x5b\
+\0\0\0\x12\0\x03\0\0\0\0\0\0\0\0\0\x08\x02\0\0\0\0\0\0\x48\0\0\0\0\0\0\0\x01\0\
+\0\0\x0d\0\0\0\xc8\0\0\0\0\0\0\0\x01\0\0\0\x0d\0\0\0\x50\0\0\0\0\0\0\0\x01\0\0\
+\0\x0d\0\0\0\xd0\x01\0\0\0\0\0\0\x01\0\0\0\x0d\0\0\0\xf0\x03\0\0\0\0\0\0\x0a\0\
+\0\0\x0d\0\0\0\xfc\x03\0\0\0\0\0\0\x0a\0\0\0\x0d\0\0\0\x08\x04\0\0\0\0\0\0\x0a\
+\0\0\0\x0d\0\0\0\x14\x04\0\0\0\0\0\0\x0a\0\0\0\x0d\0\0\0\x2c\x04\0\0\0\0\0\0\0\
+\0\0\0\x0e\0\0\0\x2c\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x3c\0\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x50\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x60\0\0\0\0\0\0\0\0\0\0\0\x0b\0\
+\0\0\x70\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\
+\x90\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xa0\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xb0\0\
+\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xc0\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xd0\0\0\0\0\
+\0\0\0\0\0\0\0\x0b\0\0\0\xe8\0\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\xf8\0\0\0\0\0\0\0\
+\0\0\0\0\x0c\0\0\0\x08\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x18\x01\0\0\0\0\0\0\0\
+\0\0\0\x0c\0\0\0\x28\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x38\x01\0\0\0\0\0\0\0\0\
+\0\0\x0c\0\0\0\x48\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x58\x01\0\0\0\0\0\0\0\0\0\
+\0\x0c\0\0\0\x68\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x78\x01\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x88\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x98\x01\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\xa8\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\xb8\x01\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\xc8\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\xd8\x01\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\xe8\x01\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\xf8\x01\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x08\x02\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x18\x02\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x28\x02\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x38\x02\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x48\x02\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x58\x02\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x68\x02\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x78\x02\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x94\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xa4\x02\0\0\0\0\0\0\0\0\0\0\
+\x0b\0\0\0\xb4\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xc4\x02\0\0\0\0\0\0\0\0\0\0\
+\x0b\0\0\0\xd4\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\xe4\x02\0\0\0\0\0\0\0\0\0\0\
+\x0b\0\0\0\xf4\x02\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x0c\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x1c\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x2c\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x3c\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x4c\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x5c\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x6c\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x7c\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x8c\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x9c\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\xac\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\xbc\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\xcc\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\xdc\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\xec\x03\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\xfc\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x0c\x04\0\0\0\0\0\0\0\0\0\0\
+\x0c\0\0\0\x1c\x04\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x4d\x4e\x40\x41\x42\x43\x4c\0\
+\x2e\x74\x65\x78\x74\0\x2e\x72\x65\x6c\x2e\x42\x54\x46\x2e\x65\x78\x74\0\x64\
+\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\
+\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\0\
+\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\x61\x70\0\x2e\x72\x65\x6c\x69\x74\x65\
+\x72\x2f\x62\x70\x66\x5f\x6d\x61\x70\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\
+\x72\x6f\x67\0\x2e\x72\x65\x6c\x69\x74\x65\x72\x2f\x62\x70\x66\x5f\x70\x72\x6f\
+\x67\0\x2e\x6c\x6c\x76\x6d\x5f\x61\x64\x64\x72\x73\x69\x67\0\x6c\x69\x63\x65\
+\x6e\x73\x65\0\x69\x74\x65\x72\x61\x74\x6f\x72\x73\x2e\x62\x70\x66\x2e\x63\0\
+\x2e\x73\x74\x72\x74\x61\x62\0\x2e\x73\x79\x6d\x74\x61\x62\0\x2e\x72\x6f\x64\
+\x61\x74\x61\0\x2e\x72\x65\x6c\x2e\x42\x54\x46\0\x4c\x49\x43\x45\x4e\x53\x45\0\
+\x4c\x42\x42\x31\x5f\x37\0\x4c\x42\x42\x31\x5f\x36\0\x4c\x42\x42\x30\x5f\x34\0\
+\x4c\x42\x42\x31\x5f\x33\0\x4c\x42\x42\x30\x5f\x33\0\x64\x75\x6d\x70\x5f\x62\
+\x70\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x32\0\x64\x75\x6d\
+\x70\x5f\x62\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x31\0\0\0\
 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\x4e\0\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\
-\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\x6d\0\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x40\x01\0\0\0\0\0\0\x08\
-\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xa1\0\0\0\
-\x01\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x48\x03\0\0\0\0\0\0\x62\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x89\0\0\0\x01\0\0\0\x03\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xaa\x03\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xad\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\xae\x03\0\0\0\0\0\0\x34\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\xe2\x0c\0\0\0\0\0\0\x2c\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\x99\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x10\x11\0\0\0\
-\0\0\0\x80\x01\0\0\0\0\0\0\x0e\0\0\0\x0d\0\0\0\x08\0\0\0\0\0\0\0\x18\0\0\0\0\0\
-\0\0\x4a\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x12\0\0\0\0\0\0\
-\x20\0\0\0\0\0\0\0\x08\0\0\0\x02\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x69\
-\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xb0\x12\0\0\0\0\0\0\x20\0\0\0\
-\0\0\0\0\x08\0\0\0\x03\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\xa9\0\0\0\x09\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xd0\x12\0\0\0\0\0\0\x50\0\0\0\0\0\0\0\
-\x08\0\0\0\x06\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x07\0\0\0\x09\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x20\x13\0\0\0\0\0\0\xe0\x03\0\0\0\0\0\0\x08\0\0\
-\0\x07\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x7b\0\0\0\x03\x4c\xff\x6f\0\0\
-\0\x80\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\0\0\0\0\0\0\x07\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x91\0\0\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\x07\x17\0\0\0\0\0\0\x0a\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\0";
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x01\0\0\
+\0\x06\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x4e\0\0\0\x01\0\0\0\x06\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x6d\0\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x40\x01\0\0\0\0\0\0\x08\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\xb1\0\0\0\x01\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x48\x03\0\
+\0\0\0\0\0\x62\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x89\0\0\0\x01\0\0\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xaa\x03\0\0\0\0\0\0\x04\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xbd\0\0\0\x01\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xae\x03\0\0\0\0\0\0\x3d\x09\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x01\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\xeb\x0c\0\0\0\0\0\0\x2c\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xa9\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\x18\x11\0\0\0\0\0\0\x98\x01\0\0\0\0\0\0\x0e\0\0\0\x0e\0\0\0\x08\0\0\
+\0\0\0\0\0\x18\0\0\0\0\0\0\0\x4a\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\xb0\x12\0\0\0\0\0\0\x20\0\0\0\0\0\0\0\x08\0\0\0\x02\0\0\0\x08\0\0\0\0\0\0\0\
+\x10\0\0\0\0\0\0\0\x69\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xd0\x12\
+\0\0\0\0\0\0\x20\0\0\0\0\0\0\0\x08\0\0\0\x03\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\
+\0\0\0\0\xb9\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xf0\x12\0\0\0\0\0\
+\0\x50\0\0\0\0\0\0\0\x08\0\0\0\x06\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\
+\x07\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x40\x13\0\0\0\0\0\0\xe0\
+\x03\0\0\0\0\0\0\x08\0\0\0\x07\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x7b\0\
+\0\0\x03\x4c\xff\x6f\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\0\0\x20\x17\0\0\0\0\0\0\x07\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xa1\0\0\0\x03\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x27\x17\0\0\0\0\0\0\x1a\x01\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
 
 	return 0;
 err:
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3bc2ed2e171b..e6a0a948e30c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2154,14 +2154,14 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	prog->expected_attach_type = attr->expected_attach_type;
 	prog->aux->attach_btf_id = attr->attach_btf_id;
 	if (attr->attach_prog_fd) {
-		struct bpf_prog *tgt_prog;
+		struct bpf_prog *dst_prog;
 
-		tgt_prog = bpf_prog_get(attr->attach_prog_fd);
-		if (IS_ERR(tgt_prog)) {
-			err = PTR_ERR(tgt_prog);
+		dst_prog = bpf_prog_get(attr->attach_prog_fd);
+		if (IS_ERR(dst_prog)) {
+			err = PTR_ERR(dst_prog);
 			goto free_prog_nouncharge;
 		}
-		prog->aux->linked_prog = tgt_prog;
+		prog->aux->dst_prog = dst_prog;
 	}
 
 	prog->aux->offload_requested = !!attr->prog_ifindex;
@@ -2498,11 +2498,23 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
 struct bpf_tracing_link {
 	struct bpf_link link;
 	enum bpf_attach_type attach_type;
+	struct bpf_trampoline *trampoline;
+	struct bpf_prog *tgt_prog;
 };
 
 static void bpf_tracing_link_release(struct bpf_link *link)
 {
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
+	struct bpf_tracing_link *tr_link =
+		container_of(link, struct bpf_tracing_link, link);
+
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog,
+						tr_link->trampoline));
+
+	bpf_trampoline_put(tr_link->trampoline);
+
+	/* tgt_prog is NULL if target is a kernel function */
+	if (tr_link->tgt_prog)
+		bpf_prog_put(tr_link->tgt_prog);
 }
 
 static void bpf_tracing_link_dealloc(struct bpf_link *link)
@@ -2545,7 +2557,9 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
 static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 {
 	struct bpf_link_primer link_primer;
+	struct bpf_prog *tgt_prog = NULL;
 	struct bpf_tracing_link *link;
+	struct bpf_trampoline *tr;
 	int err;
 
 	switch (prog->type) {
@@ -2583,19 +2597,37 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		      &bpf_tracing_link_lops, prog);
 	link->attach_type = prog->expected_attach_type;
 
-	err = bpf_link_prime(&link->link, &link_primer);
-	if (err) {
-		kfree(link);
-		goto out_put_prog;
+	mutex_lock(&prog->aux->dst_mutex);
+
+	if (!prog->aux->dst_trampoline) {
+		err = -ENOENT;
+		goto out_unlock;
 	}
+	tr = prog->aux->dst_trampoline;
+	tgt_prog = prog->aux->dst_prog;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto out_unlock;
 
-	err = bpf_trampoline_link_prog(prog);
+	err = bpf_trampoline_link_prog(prog, tr);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
-		goto out_put_prog;
+		link = NULL;
+		goto out_unlock;
 	}
 
+	link->tgt_prog = tgt_prog;
+	link->trampoline = tr;
+
+	prog->aux->dst_prog = NULL;
+	prog->aux->dst_trampoline = NULL;
+	mutex_unlock(&prog->aux->dst_mutex);
+
 	return bpf_link_settle(&link_primer);
+out_unlock:
+	mutex_unlock(&prog->aux->dst_mutex);
+	kfree(link);
 out_put_prog:
 	bpf_prog_put(prog);
 	return err;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 28c1899949e0..35c5887d82ff 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -261,14 +261,12 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_prog *prog)
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
-	struct bpf_trampoline *tr;
 	int err = 0;
 	int cnt;
 
-	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
 	if (tr->extension_prog) {
@@ -301,7 +299,7 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 	}
 	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
-	err = bpf_trampoline_update(prog->aux->trampoline);
+	err = bpf_trampoline_update(tr);
 	if (err) {
 		hlist_del(&prog->aux->tramp_hlist);
 		tr->progs_cnt[kind]--;
@@ -312,13 +310,11 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
-	struct bpf_trampoline *tr;
 	int err;
 
-	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
 	if (kind == BPF_TRAMP_REPLACE) {
@@ -330,7 +326,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	}
 	hlist_del(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	err = bpf_trampoline_update(prog->aux->trampoline);
+	err = bpf_trampoline_update(tr);
 out:
 	mutex_unlock(&tr->mutex);
 	return err;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2ee343dda73a..a97a2f2964e3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2648,8 +2648,7 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 
 static enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
 {
-	return prog->aux->linked_prog ? prog->aux->linked_prog->type
-				      : prog->type;
+	return prog->aux->dst_prog ? prog->aux->dst_prog->type : prog->type;
 }
 
 static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
@@ -11475,7 +11474,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *tgt_prog = prog->aux->dst_prog;
 	struct bpf_attach_target_info tgt_info = {};
 	u32 btf_id = prog->aux->attach_btf_id;
 	struct bpf_trampoline *tr;
@@ -11501,6 +11500,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return ret;
 
 	if (tgt_prog && prog->type == BPF_PROG_TYPE_EXT) {
+		/* to make freplace equivalent to their targets, they need to
+		 * inherit env->ops and expected_attach_type for the rest of the
+		 * verification
+		 */
 		env->ops = bpf_verifier_ops[tgt_prog->type];
 		prog->expected_attach_type = tgt_prog->expected_attach_type;
 	}
@@ -11529,7 +11532,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	if (!tr)
 		return -ENOMEM;
 
-	prog->aux->trampoline = tr;
+	prog->aux->dst_trampoline = tr;
 	return 0;
 }
 

