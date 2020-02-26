Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7841516FF94
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgBZNEx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbgBZNEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:50 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-dhq2BD2yOHin9Kg5dqRh8w-1; Wed, 26 Feb 2020 08:04:46 -0500
X-MC-Unique: dhq2BD2yOHin9Kg5dqRh8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACC3A801FB5;
        Wed, 26 Feb 2020 13:04:44 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E418E19C7F;
        Wed, 26 Feb 2020 13:04:28 +0000 (UTC)
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
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/18] bpf: Add trampolines to kallsyms
Date:   Wed, 26 Feb 2020 14:03:39 +0100
Message-Id: <20200226130345.209469-13-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-1-jolsa@kernel.org>
References: <20200226130345.209469-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 kernel/bpf/trampoline.c | 38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

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
index 6b264a92064b..4b0ae976a6eb 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -5,6 +5,7 @@
 #include <linux/filter.h>
 #include <linux/ftrace.h>
 #include <linux/rbtree_latch.h>
+#include <linux/perf_event.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -96,6 +97,22 @@ bool is_bpf_image_address(unsigned long addr)
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
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -131,6 +148,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
 	tr->image = image;
+	INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
 out:
 	mutex_unlock(&trampoline_mutex);
 	return tr;
@@ -267,6 +285,14 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
 	}
 }
 
+static void bpf_trampoline_ksym_add(struct bpf_trampoline *tr)
+{
+	struct bpf_ksym *ksym = &tr->ksym;
+
+	snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu", tr->key);
+	bpf_image_ksym_add(tr->image, ksym);
+}
+
 int bpf_trampoline_link_prog(struct bpf_prog *prog)
 {
 	enum bpf_tramp_prog_type kind;
@@ -291,6 +317,10 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 			err = -EBUSY;
 			goto out;
 		}
+		/* With cnt == 0 image is not used (no symbol in kallsyms)
+		 * and will not be used for BPF_PROG_TYPE_EXT prog type,
+		 * so there's no symbol added for this case.
+		 */
 		tr->extension_prog = prog;
 		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
 					 prog->bpf_func);
@@ -311,7 +341,10 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 	if (err) {
 		hlist_del(&prog->aux->tramp_hlist);
 		tr->progs_cnt[kind]--;
+		goto out;
 	}
+	if (cnt == 0)
+		bpf_trampoline_ksym_add(tr);
 out:
 	mutex_unlock(&tr->mutex);
 	return err;
@@ -322,7 +355,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 {
 	enum bpf_tramp_prog_type kind;
 	struct bpf_trampoline *tr;
-	int err;
+	int err, cnt;
 
 	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog->expected_attach_type);
@@ -336,6 +369,9 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	}
 	hlist_del(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
+	cnt = tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT];
+	if (cnt == 0)
+		bpf_image_ksym_del(&tr->ksym);
 	err = bpf_trampoline_update(prog->aux->trampoline);
 out:
 	mutex_unlock(&tr->mutex);
-- 
2.24.1

