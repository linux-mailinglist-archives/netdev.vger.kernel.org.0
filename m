Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BF31C71BA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgEFNaY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 09:30:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728668AbgEFNaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:30:23 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-UvnxjWGxN3Wur39OBX0BsQ-1; Wed, 06 May 2020 09:30:16 -0400
X-MC-Unique: UvnxjWGxN3Wur39OBX0BsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E4CD1902EB7;
        Wed,  6 May 2020 13:30:14 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7A40605F7;
        Wed,  6 May 2020 13:30:09 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5/9] bpf: Add support to check on BTF id whitelist for d_path helper
Date:   Wed,  6 May 2020 15:29:42 +0200
Message-Id: <20200506132946.2164578-6-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-1-jolsa@kernel.org>
References: <20200506132946.2164578-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF helper whitelist checking works as follows:

  - helper's whitelist is defined as list of functions in file:
    kernel/bpf/helpers-whitelist/helper

  - at vmlinux linking time, the bpfwl tool reads the whitelist
    and translates functions into BTF IDs, which are compiled as
    following data section into vmlinux object:

      .BTF_whitelist
          BTF_whitelist_<helper1>
          BTF_whitelist_<helper2>
          BTF_whitelist_<helper3>

    Each BTF_whitelist_<helperX> data is a sorted array of BTF ids.

  - new 'allowed' function is added to 'struct bpf_func_proto',
    which is used by verifier code to check (if defined) on whether
    the helper is called from allowed function (from whitelist).

Currently it's needed and implemented only for d_path helper,
but it's easy to add for another helper.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  5 +++++
 include/linux/bpf.h               |  1 +
 kernel/bpf/verifier.c             |  5 +++++
 kernel/trace/bpf_trace.c          | 23 +++++++++++++++++++++++
 4 files changed, 34 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 71e387a5fe90..6f7ca4f36ed7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -631,6 +631,11 @@
 		__start_BTF = .;					\
 		*(.BTF)							\
 		__stop_BTF = .;						\
+	}								\
+	.BTF_whitelist : AT(ADDR(.BTF_whitelist) - LOAD_OFFSET) {	\
+		__start_BTF_whitelist_d_path = .;			\
+		*(.BTF_whitelist_d_path)				\
+		__stop_BTF_whitelist_d_path = .;			\
 	}
 #else
 #define BTF
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bc589cdd8c34..ccacf488429f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -275,6 +275,7 @@ struct bpf_func_proto {
 		enum bpf_arg_type arg_type[5];
 	};
 	int *btf_id; /* BTF ids of arguments */
+	bool (*allowed)(const struct bpf_prog *prog);
 };
 
 /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b988df5ada20..55995de954a0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4525,6 +4525,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		return -EINVAL;
 	}
 
+	if (fn->allowed && !fn->allowed(env->prog)) {
+		verbose(env, "helper call is not allowed in probe\n");
+		return -EINVAL;
+	}
+
 	/* With LD_ABS/IND some JITs save/restore skb from r1. */
 	changes_data = bpf_helper_changes_pkt_data(fn->func);
 	if (changes_data && fn->arg1_type != ARG_PTR_TO_CTX) {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3097ab04bdc4..55682d610534 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -13,6 +13,7 @@
 #include <linux/kprobes.h>
 #include <linux/syscalls.h>
 #include <linux/error-injection.h>
+#include <linux/bsearch.h>
 
 #include <asm/tlb.h>
 
@@ -797,6 +798,27 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
 	return len;
 }
 
+extern char __weak __start_BTF_whitelist_d_path[];
+extern char __weak __stop_BTF_whitelist_d_path[];
+
+static int btf_id_cmp_func(const void *a, const void *b)
+{
+	const unsigned long *pa = a;
+	const unsigned long *pb = b;
+
+	return *pa - *pb;
+}
+
+static bool bpf_d_path_allowed(const struct bpf_prog *prog)
+{
+	unsigned long *start = (unsigned long *) __start_BTF_whitelist_d_path;
+	unsigned long *stop  = (unsigned long *) __stop_BTF_whitelist_d_path;
+	unsigned long id = prog->aux->attach_btf_id;
+
+	return bsearch(&id, start, stop - start, sizeof(unsigned long),
+		       btf_id_cmp_func) != NULL;
+}
+
 static u32 bpf_d_path_btf_ids[3];
 static const struct bpf_func_proto bpf_d_path_proto = {
 	.func		= bpf_d_path,
@@ -806,6 +828,7 @@ static const struct bpf_func_proto bpf_d_path_proto = {
 	.arg2_type	= ARG_PTR_TO_MEM,
 	.arg3_type	= ARG_CONST_SIZE,
 	.btf_id		= bpf_d_path_btf_ids,
+	.allowed	= bpf_d_path_allowed,
 };
 
 const struct bpf_func_proto *
-- 
2.25.4

