Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1F827936C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgIYVZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:25:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729653AbgIYVZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:25:17 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3jjKHuMX8t1zjXf7u6oXsrWnud6VT3++qbL9QRYcY4=;
        b=cepTPKr0HjkefgX4sypvDm+aSdecNY7vVA5fceY6XJohRvXlSu14Vxffn3b3lN9/QmITce
        luGRagGzkQ3+SmqDEtNw8+/PldmwlG1YKbtELKRURPee4CYBJ7Cfg5cnU/BtxNFseS3H6n
        wrl6OexKRwMpIxtUJQkhHKD3cgw3Ifs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-NbIQk0vJO-eR7imhdn3ZeA-1; Fri, 25 Sep 2020 17:25:10 -0400
X-MC-Unique: NbIQk0vJO-eR7imhdn3ZeA-1
Received: by mail-wr1-f69.google.com with SMTP id l17so1568556wrw.11
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 14:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=P3jjKHuMX8t1zjXf7u6oXsrWnud6VT3++qbL9QRYcY4=;
        b=XC8wOOhxfv2zUOPyv+BcF6bCLzQFlWudTkcNx5ta+qDKEmAzVKlT7wKFlE4UtRgeEe
         NAHl9cx4xD9FE0kvZRlg2fbt1ASxCHCZV104q0o1CQD/ho7lSEBMbf6h9Km/vsCaKGFl
         oqt5L2LMVHXJRDyet13lvVBtolRAf5WNqLAKECvg3lhdI+DSPDg1EKWGW+DjUSn+PQFK
         d8z1b+2J91IGGNDf2zuyJkMQMpAxDwxVmW7FyWzXyNTtHASKOHwjbbyg/g8WrxL1OZu5
         GOm3+1yKuSIpw2sol0gZg6Df4jgclau4xRlMAlR3fPDZb2kbVFmOCeBz4Jp1JZm6G6AO
         nUDQ==
X-Gm-Message-State: AOAM531XZom4lTS99I3TaLgDa0/QWwZ1ywyn/WqwcgyUHqQc3Zhfn4Fc
        xwbJoVfRCcXOqi1pEhLyReV/Z8ZJqyaJQSzig722xMrPPdCOVMTl4Ycc3hOQ9ynlsugIehKsbWl
        HXMzzFDhCJ1XqlWwj
X-Received: by 2002:a5d:540a:: with SMTP id g10mr6168810wrv.138.1601069106234;
        Fri, 25 Sep 2020 14:25:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzL4FZstGLSS93e5/yE3bZUdGv1EP635k9oeMLztTbBIX1GG6xR/VHb/oUbYZxIp1wzClx6dw==
X-Received: by 2002:a5d:540a:: with SMTP id g10mr6168738wrv.138.1601069104979;
        Fri, 25 Sep 2020 14:25:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f14sm4528423wrt.53.2020.09.25.14.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:25:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D4DB9183C5B; Fri, 25 Sep 2020 23:25:03 +0200 (CEST)
Subject: [PATCH bpf-next v9 04/11] bpf: move prog->aux->linked_prog and
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
Date:   Fri, 25 Sep 2020 23:25:03 +0200
Message-ID: <160106910382.27725.8204173893583455016.stgit@toke.dk>
In-Reply-To: <160106909952.27725.8383447127582216829.stgit@toke.dk>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
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
 include/linux/bpf_verifier.h                  |    2 
 kernel/bpf/btf.c                              |   14 -
 kernel/bpf/core.c                             |    9 -
 kernel/bpf/preload/iterators/iterators.bpf.c  |    4 
 kernel/bpf/preload/iterators/iterators.skel.h |  444 +++++++++++++------------
 kernel/bpf/syscall.c                          |   56 ++-
 kernel/bpf/trampoline.c                       |   12 -
 kernel/bpf/verifier.c                         |   51 ++-
 9 files changed, 323 insertions(+), 284 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f5974c49804b..8f80dd3ed5ed 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -625,8 +625,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
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
@@ -673,11 +673,13 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym);
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
@@ -748,7 +750,9 @@ struct bpf_prog_aux {
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
@@ -756,7 +760,6 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	enum bpf_tramp_prog_type trampoline_prog_type;
-	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 363b4f1c562a..35ae9ed687a3 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -459,7 +459,7 @@ static inline u64 bpf_trampoline_compute_key(const struct bpf_prog *tgt_prog,
 
 int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *prog,
-			    const struct bpf_prog *tgt_prog,
+			    const struct bpf_prog *dst_prog,
 			    u32 btf_id,
 			    struct bpf_attach_target_info *tgt_info);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 868c03a24d0a..faf57c6f8804 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3706,10 +3706,10 @@ struct btf *btf_parse_vmlinux(void)
 
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 {
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *dst_prog = prog->aux->dst_prog;
 
-	if (tgt_prog) {
-		return tgt_prog->aux->btf;
+	if (dst_prog) {
+		return dst_prog->aux->btf;
 	} else {
 		return btf_vmlinux;
 	}
@@ -3733,7 +3733,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    struct bpf_insn_access_aux *info)
 {
 	const struct btf_type *t = prog->aux->attach_func_proto;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *dst_prog = prog->aux->dst_prog;
 	struct btf *btf = bpf_prog_get_target_btf(prog);
 	const char *tname = prog->aux->attach_func_name;
 	struct bpf_verifier_log *log = info->log;
@@ -3859,8 +3859,8 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	}
 
 	info->reg_type = PTR_TO_BTF_ID;
-	if (tgt_prog) {
-		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
+	if (dst_prog) {
+		ret = btf_translate_to_vmlinux(log, btf, t, dst_prog->type, arg);
 		if (ret > 0) {
 			info->btf_id = ret;
 			return true;
@@ -4559,7 +4559,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 		return -EFAULT;
 	}
 	if (prog_type == BPF_PROG_TYPE_EXT)
-		prog_type = prog->aux->linked_prog->type;
+		prog_type = prog->aux->dst_prog->type;
 
 	t = btf_type_by_id(btf, t->type);
 	if (!t || !btf_type_is_func_proto(t)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c4811b139caa..b5a8029fd927 100644
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
index 2740df19f55e..099a651efe8b 100644
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
index 0883822b91b4..8fe93c84df90 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2643,8 +2643,7 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 
 static enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
 {
-	return prog->aux->linked_prog ? prog->aux->linked_prog->type
-				      : prog->type;
+	return prog->aux->dst_prog ? prog->aux->dst_prog->type : prog->type;
 }
 
 static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
@@ -11215,7 +11214,7 @@ static int check_non_sleepable_error_inject(u32 btf_id)
 
 int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *prog,
-			    const struct bpf_prog *tgt_prog,
+			    const struct bpf_prog *dst_prog,
 			    u32 btf_id,
 			    struct bpf_attach_target_info *tgt_info)
 {
@@ -11232,7 +11231,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		bpf_log(log, "Tracing programs must provide btf_id\n");
 		return -EINVAL;
 	}
-	btf = tgt_prog ? tgt_prog->aux->btf : btf_vmlinux;
+	btf = dst_prog ? dst_prog->aux->btf : btf_vmlinux;
 	if (!btf) {
 		bpf_log(log,
 			"FENTRY/FEXIT program can only be attached to another program annotated with BTF\n");
@@ -11248,8 +11247,8 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		bpf_log(log, "attach_btf_id %u doesn't have a name\n", btf_id);
 		return -EINVAL;
 	}
-	if (tgt_prog) {
-		struct bpf_prog_aux *aux = tgt_prog->aux;
+	if (dst_prog) {
+		struct bpf_prog_aux *aux = dst_prog->aux;
 
 		for (i = 0; i < aux->func_info_cnt; i++)
 			if (aux->func_info[i].type_id == btf_id) {
@@ -11273,11 +11272,11 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 				return -EINVAL;
 			}
 		}
-		if (!tgt_prog->jited) {
+		if (!dst_prog->jited) {
 			bpf_log(log, "Can attach to only JITed progs\n");
 			return -EINVAL;
 		}
-		if (tgt_prog->type == prog->type) {
+		if (dst_prog->type == prog->type) {
 			/* Cannot fentry/fexit another fentry/fexit program.
 			 * Cannot attach program extension to another extension.
 			 * It's ok to attach fentry/fexit to extension program.
@@ -11285,10 +11284,10 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			bpf_log(log, "Cannot recursively attach\n");
 			return -EINVAL;
 		}
-		if (tgt_prog->type == BPF_PROG_TYPE_TRACING &&
+		if (dst_prog->type == BPF_PROG_TYPE_TRACING &&
 		    prog_extension &&
-		    (tgt_prog->expected_attach_type == BPF_TRACE_FENTRY ||
-		     tgt_prog->expected_attach_type == BPF_TRACE_FEXIT)) {
+		    (dst_prog->expected_attach_type == BPF_TRACE_FENTRY ||
+		     dst_prog->expected_attach_type == BPF_TRACE_FEXIT)) {
 			/* Program extensions can extend all program types
 			 * except fentry/fexit. The reason is the following.
 			 * The fentry/fexit programs are used for performance
@@ -11316,7 +11315,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 
 	switch (prog->expected_attach_type) {
 	case BPF_TRACE_RAW_TP:
-		if (tgt_prog) {
+		if (dst_prog) {
 			bpf_log(log,
 				"Only FENTRY/FEXIT progs are attachable to another BPF prog\n");
 			return -EINVAL;
@@ -11375,18 +11374,18 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
 
-		if (tgt_prog && conservative)
+		if (dst_prog && conservative)
 			t = NULL;
 
 		ret = btf_distill_func_proto(log, btf, t, tname, &tgt_info->fmodel);
 		if (ret < 0)
 			return ret;
 
-		if (tgt_prog) {
+		if (dst_prog) {
 			if (subprog == 0)
-				addr = (long) tgt_prog->bpf_func;
+				addr = (long) dst_prog->bpf_func;
 			else
-				addr = (long) tgt_prog->aux->func[subprog]->bpf_func;
+				addr = (long) dst_prog->aux->func[subprog]->bpf_func;
 		} else {
 			addr = kallsyms_lookup_name(tname);
 			if (!addr) {
@@ -11423,7 +11422,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 				return ret;
 			}
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
-			if (tgt_prog) {
+			if (dst_prog) {
 				bpf_log(log, "can't modify return codes of BPF programs\n");
 				return -EINVAL;
 			}
@@ -11445,7 +11444,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *dst_prog = prog->aux->dst_prog;
 	struct bpf_attach_target_info tgt_info = {};
 	u32 btf_id = prog->aux->attach_btf_id;
 	struct bpf_trampoline *tr;
@@ -11466,13 +11465,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	    prog->type != BPF_PROG_TYPE_EXT)
 		return 0;
 
-	ret = bpf_check_attach_target(&env->log, prog, tgt_prog, btf_id, &tgt_info);
+	ret = bpf_check_attach_target(&env->log, prog, dst_prog, btf_id, &tgt_info);
 	if (ret)
 		return ret;
 
-	if (tgt_prog && prog->type == BPF_PROG_TYPE_EXT) {
-		env->ops = bpf_verifier_ops[tgt_prog->type];
-		prog->expected_attach_type = tgt_prog->expected_attach_type;
+	if (dst_prog && prog->type == BPF_PROG_TYPE_EXT) {
+		/* to make freplace equivalent to their targets, they need to
+		 * inherit env->ops and expected_attach_type for the rest of the
+		 * verification
+		 */
+		env->ops = bpf_verifier_ops[dst_prog->type];
+		prog->expected_attach_type = dst_prog->expected_attach_type;
 	}
 
 	/* store info about the attachment target that will be used later */
@@ -11494,12 +11497,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			return ret;
 	}
 
-	key = bpf_trampoline_compute_key(tgt_prog, btf_id);
+	key = bpf_trampoline_compute_key(dst_prog, btf_id);
 	tr = bpf_trampoline_get(key, &tgt_info);
 	if (!tr)
 		return -ENOMEM;
 
-	prog->aux->trampoline = tr;
+	prog->aux->dst_trampoline = tr;
 	return 0;
 }
 

