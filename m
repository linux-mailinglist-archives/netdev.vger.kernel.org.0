Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EEB295A18
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895296AbgJVIWd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:33 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:50552 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895288AbgJVIWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:32 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-mrIbtscfP7ye1OFsRsMfmQ-1; Thu, 22 Oct 2020 04:22:26 -0400
X-MC-Unique: mrIbtscfP7ye1OFsRsMfmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 783AE186DD32;
        Thu, 22 Oct 2020 08:22:24 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C53760BFA;
        Thu, 22 Oct 2020 08:22:18 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFC bpf-next 09/16] bpf: Add BPF_TRAMPOLINE_BATCH_ATTACH support
Date:   Thu, 22 Oct 2020 10:21:31 +0200
Message-Id: <20201022082138.2322434-10-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding BPF_TRAMPOLINE_BATCH_ATTACH support, that allows to attach
tracing multiple fentry/fexit pograms to trampolines within one
syscall.

Currently each tracing program is attached in seprate bpf syscall
and more importantly by separate register_ftrace_direct call, which
registers trampoline in ftrace subsystem. We can save some cycles
by simple using its batch variant register_ftrace_direct_ips.

Before:

 Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):

     2,199,433,771      cycles:k               ( +-  0.55% )
       936,105,469      cycles:u               ( +-  0.37% )

             26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )

After:

 Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):

     1,456,854,867      cycles:k               ( +-  0.57% )
       937,737,431      cycles:u               ( +-  0.13% )

             12.44 +- 2.98 seconds time elapsed  ( +- 23.95% )

The new BPF_TRAMPOLINE_BATCH_ATTACH syscall command expects
following data in union bpf_attr:

  struct {
          __aligned_u64   in;
          __aligned_u64   out;
          __u32           count;
  } trampoline_batch;

  in    - pointer to user space array with file descrptors of loaded bpf
          programs to attach
  out   - pointer to user space array for resulting link descriptor
  count - number of 'in/out' file descriptors

Basically the new code gets programs from 'in' file descriptors and
attaches them the same way the current code does, apart from the last
step that registers probe ip with trampoline. This is done at the end
with new register_ftrace_direct_ips function.

The resulting link descriptors are written in 'out' array and match
'in' array file descriptors order.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h      | 15 ++++++-
 include/uapi/linux/bpf.h |  7 ++++
 kernel/bpf/syscall.c     | 88 ++++++++++++++++++++++++++++++++++++++--
 kernel/bpf/trampoline.c  | 69 +++++++++++++++++++++++++++----
 4 files changed, 164 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b16bf48aab6..d28c7ac3af3f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -583,6 +583,13 @@ enum bpf_tramp_prog_type {
 	BPF_TRAMP_REPLACE, /* more than MAX */
 };
 
+struct bpf_trampoline_batch {
+	int count;
+	int idx;
+	unsigned long *ips;
+	unsigned long *addrs;
+};
+
 struct bpf_trampoline {
 	/* hlist for trampoline_table */
 	struct hlist_node hlist;
@@ -644,11 +651,14 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
 #ifdef CONFIG_BPF_JIT
-int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr,
+			     struct bpf_trampoline_batch *batch);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+struct bpf_trampoline_batch *bpf_trampoline_batch_alloc(int count);
+void bpf_trampoline_batch_free(struct bpf_trampoline_batch *batch);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
@@ -693,7 +703,8 @@ void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
 #else
 static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
-					   struct bpf_trampoline *tr)
+					   struct bpf_trampoline *tr,
+					   struct bpf_trampoline_batch *batch)
 {
 	return -ENOTSUPP;
 }
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bf5a99d803e4..04df4d576fd4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -125,6 +125,7 @@ enum bpf_cmd {
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
 	BPF_PROG_BIND_MAP,
+	BPF_TRAMPOLINE_BATCH_ATTACH,
 };
 
 enum bpf_map_type {
@@ -631,6 +632,12 @@ union bpf_attr {
 		__u32 prog_fd;
 	} raw_tracepoint;
 
+	struct { /* anonymous struct used by BPF_TRAMPOLINE_BATCH_ATTACH */
+		__aligned_u64	in;
+		__aligned_u64	out;
+		__u32		count;
+	} trampoline_batch;
+
 	struct { /* anonymous struct for BPF_BTF_LOAD */
 		__aligned_u64	btf;
 		__aligned_u64	btf_log_buf;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 61ef29f9177d..e370b37e3e8e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2553,7 +2553,8 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
 
 static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 				   int tgt_prog_fd,
-				   u32 btf_id)
+				   u32 btf_id,
+				   struct bpf_trampoline_batch *batch)
 {
 	struct bpf_link_primer link_primer;
 	struct bpf_prog *tgt_prog = NULL;
@@ -2678,7 +2679,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	if (err)
 		goto out_unlock;
 
-	err = bpf_trampoline_link_prog(prog, tr);
+	err = bpf_trampoline_link_prog(prog, tr, batch);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
@@ -2826,7 +2827,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog, 0, 0);
+		return bpf_tracing_prog_attach(prog, 0, 0, NULL);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
@@ -2879,6 +2880,81 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	return err;
 }
 
+#define BPF_RAW_TRACEPOINT_OPEN_BATCH_LAST_FIELD trampoline_batch.count
+
+static int bpf_trampoline_batch(const union bpf_attr *attr, int cmd)
+{
+	void __user *uout = u64_to_user_ptr(attr->trampoline_batch.out);
+	void __user *uin = u64_to_user_ptr(attr->trampoline_batch.in);
+	struct bpf_trampoline_batch *batch = NULL;
+	struct bpf_prog *prog;
+	int count, ret, i, fd;
+	u32 *in, *out;
+
+	if (CHECK_ATTR(BPF_RAW_TRACEPOINT_OPEN_BATCH))
+		return -EINVAL;
+
+	if (!uin || !uout)
+		return -EINVAL;
+
+	count = attr->trampoline_batch.count;
+
+	in = kcalloc(count, sizeof(u32), GFP_KERNEL);
+	out = kcalloc(count, sizeof(u32), GFP_KERNEL);
+	if (!in || !out) {
+		kfree(in);
+		kfree(out);
+		return -ENOMEM;
+	}
+
+	ret = copy_from_user(in, uin, count * sizeof(u32));
+	if (ret)
+		goto out_clean;
+
+	/* test read out array */
+	ret = copy_to_user(uout, out, count * sizeof(u32));
+	if (ret)
+		goto out_clean;
+
+	batch = bpf_trampoline_batch_alloc(count);
+	if (!batch)
+		goto out_clean;
+
+	for (i = 0; i < count; i++) {
+		if (cmd == BPF_TRAMPOLINE_BATCH_ATTACH) {
+			prog = bpf_prog_get(in[i]);
+			if (IS_ERR(prog)) {
+				ret = PTR_ERR(prog);
+				goto out_clean;
+			}
+
+			ret = -EINVAL;
+			if (prog->type != BPF_PROG_TYPE_TRACING)
+				goto out_clean;
+			if (prog->type == BPF_PROG_TYPE_TRACING &&
+			    prog->expected_attach_type == BPF_TRACE_RAW_TP)
+				goto out_clean;
+
+			fd = bpf_tracing_prog_attach(prog, 0, 0, batch);
+			if (fd < 0)
+				goto out_clean;
+
+			out[i] = fd;
+		}
+	}
+
+	ret = register_ftrace_direct_ips(batch->ips, batch->addrs, batch->idx);
+	if (!ret)
+		WARN_ON_ONCE(copy_to_user(uout, out, count * sizeof(u32)));
+
+out_clean:
+	/* XXX cleanup partialy attached array */
+	bpf_trampoline_batch_free(batch);
+	kfree(in);
+	kfree(out);
+	return ret;
+}
+
 static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 					     enum bpf_attach_type attach_type)
 {
@@ -4018,7 +4094,8 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *
 	else if (prog->type == BPF_PROG_TYPE_EXT)
 		return bpf_tracing_prog_attach(prog,
 					       attr->link_create.target_fd,
-					       attr->link_create.target_btf_id);
+					       attr->link_create.target_btf_id,
+					       NULL);
 	return -EINVAL;
 }
 
@@ -4437,6 +4514,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_RAW_TRACEPOINT_OPEN:
 		err = bpf_raw_tracepoint_open(&attr);
 		break;
+	case BPF_TRAMPOLINE_BATCH_ATTACH:
+		err = bpf_trampoline_batch(&attr, cmd);
+		break;
 	case BPF_BTF_LOAD:
 		err = bpf_btf_load(&attr);
 		break;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 35c5887d82ff..3383644eccc8 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -107,6 +107,51 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	return tr;
 }
 
+static int bpf_trampoline_batch_add(struct bpf_trampoline_batch *batch,
+				    unsigned long ip, unsigned long addr)
+{
+	int idx = batch->idx;
+
+	if (idx >= batch->count)
+		return -EINVAL;
+
+	batch->ips[idx] = ip;
+	batch->addrs[idx] = addr;
+	batch->idx++;
+	return 0;
+}
+
+struct bpf_trampoline_batch *bpf_trampoline_batch_alloc(int count)
+{
+	struct bpf_trampoline_batch *batch;
+
+	batch = kmalloc(sizeof(*batch), GFP_KERNEL);
+	if (!batch)
+		return NULL;
+
+	batch->ips = kcalloc(count, sizeof(batch->ips[0]), GFP_KERNEL);
+	batch->addrs = kcalloc(count, sizeof(batch->addrs[0]), GFP_KERNEL);
+	if (!batch->ips || !batch->addrs) {
+		kfree(batch->ips);
+		kfree(batch->addrs);
+		kfree(batch);
+		return NULL;
+	}
+
+	batch->count = count;
+	batch->idx = 0;
+	return batch;
+}
+
+void bpf_trampoline_batch_free(struct bpf_trampoline_batch *batch)
+{
+	if (!batch)
+		return;
+	kfree(batch->ips);
+	kfree(batch->addrs);
+	kfree(batch);
+}
+
 static int is_ftrace_location(void *ip)
 {
 	long addr;
@@ -144,7 +189,8 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
 }
 
 /* first time registering */
-static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
+static int register_fentry(struct bpf_trampoline *tr, void *new_addr,
+			   struct bpf_trampoline_batch *batch)
 {
 	void *ip = tr->func.addr;
 	int ret;
@@ -154,9 +200,12 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 		return ret;
 	tr->func.ftrace_managed = ret;
 
-	if (tr->func.ftrace_managed)
-		ret = register_ftrace_direct((long)ip, (long)new_addr);
-	else
+	if (tr->func.ftrace_managed) {
+		if (batch)
+			ret = bpf_trampoline_batch_add(batch, (long)ip, (long)new_addr);
+		else
+			ret = register_ftrace_direct((long)ip, (long)new_addr);
+	} else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
 	return ret;
 }
@@ -185,7 +234,8 @@ bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total)
 	return tprogs;
 }
 
-static int bpf_trampoline_update(struct bpf_trampoline *tr)
+static int bpf_trampoline_update(struct bpf_trampoline *tr,
+				 struct bpf_trampoline_batch *batch)
 {
 	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
 	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
@@ -230,7 +280,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 		err = modify_fentry(tr, old_image, new_image);
 	else
 		/* first time registering */
-		err = register_fentry(tr, new_image);
+		err = register_fentry(tr, new_image, batch);
 	if (err)
 		goto out;
 	tr->selector++;
@@ -261,7 +311,8 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr,
+			     struct bpf_trampoline_batch *batch)
 {
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
@@ -299,7 +350,7 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 	}
 	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
-	err = bpf_trampoline_update(tr);
+	err = bpf_trampoline_update(tr, batch);
 	if (err) {
 		hlist_del(&prog->aux->tramp_hlist);
 		tr->progs_cnt[kind]--;
@@ -326,7 +377,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 	}
 	hlist_del(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	err = bpf_trampoline_update(tr);
+	err = bpf_trampoline_update(tr, NULL);
 out:
 	mutex_unlock(&tr->mutex);
 	return err;
-- 
2.26.2

