Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F611183A05
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCLT5O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:57:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54673 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727020AbgCLT5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:57:13 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-V2ElMOf-Nj-JirYlo6WjzA-1; Thu, 12 Mar 2020 15:57:08 -0400
X-MC-Unique: V2ElMOf-Nj-JirYlo6WjzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57AD4800D53;
        Thu, 12 Mar 2020 19:57:06 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 031085D9C5;
        Thu, 12 Mar 2020 19:57:01 +0000 (UTC)
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
Subject: [PATCH 10/15] bpf: Add trampolines to kallsyms
Date:   Thu, 12 Mar 2020 20:56:05 +0100
Message-Id: <20200312195610.346362-11-jolsa@kernel.org>
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

Adding trampolines to kallsyms. It's displayed as
  bpf_trampoline_<ID> [bpf]

where ID is the BTF id of the trampoline function.

Adding bpf_image_ksym_add/del functions that setup
the start/end values and call KSYMBOL perf events
handlers.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  3 +++
 kernel/bpf/trampoline.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 83920cbce24c..7edbf30cf2b2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -513,6 +513,7 @@ struct bpf_trampoline {
 	/* Executable image of trampoline */
 	void *image;
 	u64 selector;
+	struct bpf_ksym ksym;
 };
 
 #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
@@ -585,6 +586,8 @@ struct bpf_image {
 bool is_bpf_image_address(unsigned long address);
 void *bpf_image_alloc(void);
 /* Called only from JIT-enabled code, so there's no need for stubs. */
+void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
+void bpf_image_ksym_del(struct bpf_ksym *ksym);
 void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
 #else
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 221a17af1f81..36549c9afec4 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -5,6 +5,7 @@
 #include <linux/filter.h>
 #include <linux/ftrace.h>
 #include <linux/rbtree_latch.h>
+#include <linux/perf_event.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -96,6 +97,30 @@ bool is_bpf_image_address(unsigned long addr)
 	return ret;
 }
 
+void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
+{
+	ksym->start = (unsigned long) data;
+	ksym->end = ksym->start + BPF_IMAGE_SIZE;
+	bpf_ksym_add(ksym);
+	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF, ksym->start,
+			   BPF_IMAGE_SIZE, false, ksym->name);
+}
+
+void bpf_image_ksym_del(struct bpf_ksym *ksym)
+{
+	bpf_ksym_del(ksym);
+	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF, ksym->start,
+			   BPF_IMAGE_SIZE, true, ksym->name);
+}
+
+static void bpf_trampoline_ksym_add(struct bpf_trampoline *tr)
+{
+	struct bpf_ksym *ksym = &tr->ksym;
+
+	snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu", tr->key);
+	bpf_image_ksym_add(tr->image, ksym);
+}
+
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -131,6 +156,8 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
 	tr->image = image;
+	INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
+	bpf_trampoline_ksym_add(tr);
 out:
 	mutex_unlock(&trampoline_mutex);
 	return tr;
@@ -368,6 +395,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 		goto out;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
+	bpf_image_ksym_del(&tr->ksym);
 	image = container_of(tr->image, struct bpf_image, data);
 	latch_tree_erase(&image->tnode, &image_tree, &image_tree_ops);
 	/* wait for tasks to get out of trampoline before freeing it */
-- 
2.24.1

