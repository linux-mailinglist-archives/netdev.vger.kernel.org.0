Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF7C1FAD7F
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgFPKGO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:06:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45973 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728329AbgFPKGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:06:10 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-Lj4C1gQvNjqpGm3PO0QhvA-1; Tue, 16 Jun 2020 06:06:03 -0400
X-MC-Unique: Lj4C1gQvNjqpGm3PO0QhvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DC1F83DE70;
        Tue, 16 Jun 2020 10:05:59 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30C5C5D9D5;
        Tue, 16 Jun 2020 10:05:54 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 08/11] bpf: Add BTF whitelist support
Date:   Tue, 16 Jun 2020 12:05:09 +0200
Message-Id: <20200616100512.2168860-9-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
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

Adding support to define 'whitelist' of BTF IDs, which is
also sorted.

Following defines sorted list of BTF IDs that is accessible
within kernel code as btf_whitelist_d_path and its count is
in btf_whitelist_d_path_cnt variable.

  extern int btf_whitelist_d_path[];
  extern int btf_whitelist_d_path_cnt;

  BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
  BTF_ID(func, vfs_truncate)
  BTF_ID(func, vfs_fallocate)
  BTF_ID(func, dentry_open)
  BTF_ID(func, vfs_getattr)
  BTF_ID(func, filp_close)
  BTF_WHITELIST_END(btf_whitelist_d_path)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h   |  3 +++
 kernel/bpf/btf.c      | 13 +++++++++++++
 kernel/bpf/btf_ids.h  | 38 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c |  5 +++++
 4 files changed, 59 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e98c113a5d27..a94e85c2ec50 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -283,6 +283,7 @@ struct bpf_func_proto {
 		enum bpf_arg_type arg_type[5];
 	};
 	int *btf_id; /* BTF ids of arguments */
+	bool (*allowed)(const struct bpf_prog *prog);
 };
 
 /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
@@ -1745,6 +1746,8 @@ enum bpf_text_poke_type {
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
+bool btf_whitelist_search(int id, int list[], int cnt);
+
 extern int bpf_skb_output_btf_ids[];
 extern int bpf_seq_printf_btf_ids[];
 extern int bpf_seq_write_btf_ids[];
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6924180a19c4..feda74d232c5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -20,6 +20,7 @@
 #include <linux/btf.h>
 #include <linux/skmsg.h>
 #include <linux/perf_event.h>
+#include <linux/bsearch.h>
 #include <net/sock.h>
 
 /* BTF (BPF Type Format) is the meta data format which describes
@@ -4669,3 +4670,15 @@ u32 btf_id(const struct btf *btf)
 {
 	return btf->id;
 }
+
+static int btf_id_cmp_func(const void *a, const void *b)
+{
+	const int *pa = a, *pb = b;
+
+	return *pa - *pb;
+}
+
+bool btf_whitelist_search(int id, int list[], int cnt)
+{
+	return bsearch(&id, list, cnt, sizeof(int), btf_id_cmp_func) != NULL;
+}
diff --git a/kernel/bpf/btf_ids.h b/kernel/bpf/btf_ids.h
index 68aa5c38a37f..a90c09faa515 100644
--- a/kernel/bpf/btf_ids.h
+++ b/kernel/bpf/btf_ids.h
@@ -67,4 +67,42 @@ asm(							\
 #name ":;                                      \n"	\
 ".popsection;                                  \n");
 
+
+/*
+ * The BTF_WHITELIST_ENTRY/END macros pair defines sorted
+ * list of BTF IDs plus its members count, with following
+ * layout:
+ *
+ * BTF_WHITELIST_ENTRY(list2)
+ * BTF_ID(type1, name1)
+ * BTF_ID(type2, name2)
+ * BTF_WHITELIST_END(list)
+ *
+ * __BTF_ID__sort__list:
+ * list2_cnt:
+ * .zero 4
+ * list2:
+ * __BTF_ID__type1__name1__3:
+ * .zero 4
+ * __BTF_ID__type2__name2__4:
+ * .zero 4
+ *
+ */
+#define BTF_WHITELIST_ENTRY(name)			\
+asm(							\
+".pushsection " SECTION ",\"a\";               \n"	\
+".global __BTF_ID__sort__" #name ";            \n"	\
+"__BTF_ID__sort__" #name ":;                   \n"	\
+".global " #name "_cnt;                        \n"	\
+#name "_cnt:;                                  \n"	\
+".zero 4                                       \n"	\
+".popsection;                                  \n");	\
+BTF_ID_LIST(name)
+
+#define BTF_WHITELIST_END(name)				\
+asm(							\
+".pushsection " SECTION ",\"a\";              \n"	\
+".size __BTF_ID__sort__" #name ", .-" #name " \n"	\
+".popsection;                                 \n");
+
 #endif
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bee3da2cd945..5a9a6fd72907 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4633,6 +4633,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
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
-- 
2.25.4

