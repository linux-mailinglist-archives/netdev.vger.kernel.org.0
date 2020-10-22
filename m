Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2414E295A1C
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895322AbgJVIWk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:40 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:54690 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895301AbgJVIWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:38 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-69vaJIiIM3Wvq-Cx3DYGJQ-1; Thu, 22 Oct 2020 04:22:29 -0400
X-MC-Unique: 69vaJIiIM3Wvq-Cx3DYGJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1CFE1006CA3;
        Thu, 22 Oct 2020 08:22:27 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF45060BFA;
        Thu, 22 Oct 2020 08:22:24 +0000 (UTC)
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
Subject: [RFC bpf-next 10/16] bpf: Add BPF_TRAMPOLINE_BATCH_DETACH support
Date:   Thu, 22 Oct 2020 10:21:32 +0200
Message-Id: <20201022082138.2322434-11-jolsa@kernel.org>
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

Adding BPF_TRAMPOLINE_BATCH_DETACH support, that allows to detach
tracing multiple fentry/fexit pograms from trampolines within one
syscall.

The new BPF_TRAMPOLINE_BATCH_DETACH syscall command expects
following data in union bpf_attr:

  struct {
          __aligned_u64   in;
          __aligned_u64   out;
          __u32           count;
  } trampoline_batch;

  in    - pointer to user space array with link descrptors of attached
          bpf programs to detach
  out   - pointer to user space array for resulting error code
  count - number of 'in/out' file descriptors

Basically the new code gets programs from 'in' link descriptors and
detaches them the same way the current code does, apart from the last
step that unregisters probe ip with trampoline. This is done at the end
with new unregister_ftrace_direct function.

The resulting error codes are written in 'out' array and match 'in'
array link descriptors order.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h      |  3 ++-
 include/uapi/linux/bpf.h |  3 ++-
 kernel/bpf/syscall.c     | 28 ++++++++++++++++++++++++++--
 kernel/bpf/trampoline.c  | 25 ++++++++++++++++---------
 4 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d28c7ac3af3f..828a4e88224f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -653,7 +653,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 #ifdef CONFIG_BPF_JIT
 int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr,
 			     struct bpf_trampoline_batch *batch);
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr,
+			       struct bpf_trampoline_batch *batch);
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 04df4d576fd4..b6a08aa49aa4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -126,6 +126,7 @@ enum bpf_cmd {
 	BPF_LINK_DETACH,
 	BPF_PROG_BIND_MAP,
 	BPF_TRAMPOLINE_BATCH_ATTACH,
+	BPF_TRAMPOLINE_BATCH_DETACH,
 };
 
 enum bpf_map_type {
@@ -632,7 +633,7 @@ union bpf_attr {
 		__u32 prog_fd;
 	} raw_tracepoint;
 
-	struct { /* anonymous struct used by BPF_TRAMPOLINE_BATCH_ATTACH */
+	struct { /* anonymous struct used by BPF_TRAMPOLINE_BATCH_* */
 		__aligned_u64	in;
 		__aligned_u64	out;
 		__u32		count;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e370b37e3e8e..19fb608546c0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2505,7 +2505,7 @@ static void bpf_tracing_link_release(struct bpf_link *link)
 		container_of(link, struct bpf_tracing_link, link);
 
 	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog,
-						tr_link->trampoline));
+						tr_link->trampoline, NULL));
 
 	bpf_trampoline_put(tr_link->trampoline);
 
@@ -2940,10 +2940,33 @@ static int bpf_trampoline_batch(const union bpf_attr *attr, int cmd)
 				goto out_clean;
 
 			out[i] = fd;
+		} else {
+			struct bpf_tracing_link *tr_link;
+			struct bpf_link *link;
+
+			link = bpf_link_get_from_fd(in[i]);
+			if (IS_ERR(link)) {
+				ret = PTR_ERR(link);
+				goto out_clean;
+			}
+
+			if (link->type != BPF_LINK_TYPE_TRACING) {
+				ret = -EINVAL;
+				bpf_link_put(link);
+				goto out_clean;
+			}
+
+			tr_link = container_of(link, struct bpf_tracing_link, link);
+			bpf_trampoline_unlink_prog(link->prog, tr_link->trampoline, batch);
+			bpf_link_put(link);
 		}
 	}
 
-	ret = register_ftrace_direct_ips(batch->ips, batch->addrs, batch->idx);
+	if (cmd == BPF_TRAMPOLINE_BATCH_ATTACH)
+		ret = register_ftrace_direct_ips(batch->ips, batch->addrs, batch->idx);
+	else
+		ret = unregister_ftrace_direct_ips(batch->ips, batch->addrs, batch->idx);
+
 	if (!ret)
 		WARN_ON_ONCE(copy_to_user(uout, out, count * sizeof(u32)));
 
@@ -4515,6 +4538,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_raw_tracepoint_open(&attr);
 		break;
 	case BPF_TRAMPOLINE_BATCH_ATTACH:
+	case BPF_TRAMPOLINE_BATCH_DETACH:
 		err = bpf_trampoline_batch(&attr, cmd);
 		break;
 	case BPF_BTF_LOAD:
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 3383644eccc8..cdad87461e5d 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -164,14 +164,18 @@ static int is_ftrace_location(void *ip)
 	return 1;
 }
 
-static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
+static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr,
+			     struct bpf_trampoline_batch *batch)
 {
 	void *ip = tr->func.addr;
 	int ret;
 
-	if (tr->func.ftrace_managed)
-		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
-	else
+	if (tr->func.ftrace_managed) {
+		if (batch)
+			ret = bpf_trampoline_batch_add(batch, (long)ip, (long)old_addr);
+		else
+			ret = unregister_ftrace_direct((long)ip, (long)old_addr);
+	} else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
 	return ret;
 }
@@ -248,7 +252,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr,
 		return PTR_ERR(tprogs);
 
 	if (total == 0) {
-		err = unregister_fentry(tr, old_image);
+		err = unregister_fentry(tr, old_image, batch);
 		tr->selector = 0;
 		goto out;
 	}
@@ -361,13 +365,16 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr,
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr,
+			       struct bpf_trampoline_batch *batch)
 {
 	enum bpf_tramp_prog_type kind;
-	int err;
+	int err = 0;
 
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
+	if (hlist_unhashed(&prog->aux->tramp_hlist))
+		goto out;
 	if (kind == BPF_TRAMP_REPLACE) {
 		WARN_ON_ONCE(!tr->extension_prog);
 		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP,
@@ -375,9 +382,9 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		tr->extension_prog = NULL;
 		goto out;
 	}
-	hlist_del(&prog->aux->tramp_hlist);
+	hlist_del_init(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	err = bpf_trampoline_update(tr, NULL);
+	err = bpf_trampoline_update(tr, batch);
 out:
 	mutex_unlock(&tr->mutex);
 	return err;
-- 
2.26.2

