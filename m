Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AA220A81A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436629AbgFYWNz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 18:13:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436623AbgFYWNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:13:55 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-_Co-Te7bPKmbezZsOlJ7qg-1; Thu, 25 Jun 2020 18:13:47 -0400
X-MC-Unique: _Co-Te7bPKmbezZsOlJ7qg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36B498015FB;
        Thu, 25 Jun 2020 22:13:45 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78FA17B612;
        Thu, 25 Jun 2020 22:13:41 +0000 (UTC)
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
Subject: [PATCH v4 bpf-next 08/14] bpf: Add BTF_SET_START/END macros
Date:   Fri, 26 Jun 2020 00:12:58 +0200
Message-Id: <20200625221304.2817194-9-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-1-jolsa@kernel.org>
References: <20200625221304.2817194-1-jolsa@kernel.org>
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

Adding support to define sorted set of BTF ID values.

Following defines sorted set of BTF ID values:

  BTF_SET_START(btf_whitelist_d_path)
  BTF_ID(func, vfs_truncate)
  BTF_ID(func, vfs_fallocate)
  BTF_ID(func, dentry_open)
  BTF_ID(func, vfs_getattr)
  BTF_ID(func, filp_close)
  BTF_SET_END(btf_whitelist_d_path)

It defines following 'struct btf_id_set' variable to access
values and count:

  struct btf_id_set btf_whitelist_d_path;

Adding 'allowed' callback to struct bpf_func_proto, to allow
verifier the check on allowed callers.

Adding btf_id_set_contains, which will be used by allowed
callbacks to verify the caller's BTF ID value is within
allowed set.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  4 ++++
 include/linux/btf_ids.h | 39 +++++++++++++++++++++++++++++++++++++++
 kernel/bpf/btf.c        | 14 ++++++++++++++
 kernel/bpf/verifier.c   |  5 +++++
 4 files changed, 62 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c0fd1f3037dd..9efd0c23147d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -294,6 +294,7 @@ struct bpf_func_proto {
 						    * for this argument.
 						    */
 	int *ret_btf_id; /* return value btf_id */
+	bool (*allowed)(const struct bpf_prog *prog);
 };
 
 /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
@@ -1771,4 +1772,7 @@ enum bpf_text_poke_type {
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
+struct btf_id_set;
+bool btf_id_set_contains(struct btf_id_set *set, u32 id);
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index f7f9dc4d9a9f..5eb8983ee0a0 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -66,4 +66,43 @@ asm(							\
 __BTF_ID_LIST(name)					\
 extern int name[];
 
+struct btf_id_set {
+	u32 cnt;
+	u32 ids[];
+};
+
+/*
+ * The BTF_SET_START/END macros pair defines sorted list of
+ * BTF IDs plus its members count, with following layout:
+ *
+ * BTF_SET_START(list)
+ * BTF_ID(type1, name1)
+ * BTF_ID(type2, name2)
+ * BTF_SET_END(list)
+ *
+ * __BTF_ID__set__list:
+ * .zero 4
+ * list:
+ * __BTF_ID__type1__name1__3:
+ * .zero 4
+ * __BTF_ID__type2__name2__4:
+ * .zero 4
+ *
+ */
+#define BTF_SET_START(name)				\
+__BTF_ID_LIST(name)					\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
+".local __BTF_ID__set__" #name ";              \n"	\
+"__BTF_ID__set__" #name ":;                    \n"	\
+".zero 4                                       \n"	\
+".popsection;                                  \n");	\
+
+#define BTF_SET_END(name)				\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";      \n"	\
+".size __BTF_ID__set__" #name ", .-" #name "  \n"	\
+".popsection;                                 \n");	\
+extern struct btf_id_set name;
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f87e5f1dc64d..201fe564bb84 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -21,6 +21,8 @@
 #include <linux/btf_ids.h>
 #include <linux/skmsg.h>
 #include <linux/perf_event.h>
+#include <linux/bsearch.h>
+#include <linux/btf_ids.h>
 #include <net/sock.h>
 
 /* BTF (BPF Type Format) is the meta data format which describes
@@ -4712,3 +4714,15 @@ u32 btf_id(const struct btf *btf)
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
+bool btf_id_set_contains(struct btf_id_set *set, u32 id)
+{
+	return bsearch(&id, set->ids, set->cnt, sizeof(int), btf_id_cmp_func) != NULL;
+}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index da7351184295..b6f583e3e24f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4708,6 +4708,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
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

