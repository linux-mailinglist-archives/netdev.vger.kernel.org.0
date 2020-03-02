Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD32175D35
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 15:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgCBOdF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Mar 2020 09:33:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727111AbgCBOdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 09:33:04 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-UKc1UFKhOXedgw80WTtedA-1; Mon, 02 Mar 2020 09:32:59 -0500
X-MC-Unique: UKc1UFKhOXedgw80WTtedA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EACC5802B8B;
        Mon,  2 Mar 2020 14:32:57 +0000 (UTC)
Received: from krava.redhat.com (ovpn-205-46.brq.redhat.com [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18B9792D2F;
        Mon,  2 Mar 2020 14:32:52 +0000 (UTC)
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
Subject: [PATCH 11/15] bpf: Add trampolines to kallsyms
Date:   Mon,  2 Mar 2020 15:31:50 +0100
Message-Id: <20200302143154.258569-12-jolsa@kernel.org>
In-Reply-To: <20200302143154.258569-1-jolsa@kernel.org>
References: <20200302143154.258569-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  3 +++
 kernel/bpf/trampoline.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 76934893bccf..c216af89254f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -502,6 +502,7 @@ struct bpf_trampoline {
 	/* Executable image of trampoline */
 	void *image;
 	u64 selector;
+	struct bpf_ksym ksym;
 };
 
 #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
@@ -573,6 +574,8 @@ struct bpf_image {
 #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
 bool is_bpf_image_address(unsigned long address);
 void *bpf_image_alloc(void);
+void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
+void bpf_image_ksym_del(struct bpf_ksym *ksym);
 /* Called only from code, so there's no need for stubs. */
 void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6b264a92064b..9212e715ac24 100644
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
@@ -356,6 +383,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 		goto out;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
+	bpf_image_ksym_del(&tr->ksym);
 	image = container_of(tr->image, struct bpf_image, data);
 	latch_tree_erase(&image->tnode, &image_tree, &image_tree_ops);
 	/* wait for tasks to get out of trampoline before freeing it */
-- 
2.24.1

