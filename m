Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0EE16FF81
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgBZNEN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727028AbgBZNEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:12 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-7amPEnIUNxqs-5bmvucwzg-1; Wed, 26 Feb 2020 08:04:07 -0500
X-MC-Unique: 7amPEnIUNxqs-5bmvucwzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35770A0CC2;
        Wed, 26 Feb 2020 13:04:05 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C8DB19756;
        Wed, 26 Feb 2020 13:04:01 +0000 (UTC)
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
Subject: [PATCH 04/18] bpf: Add name to struct bpf_ksym
Date:   Wed, 26 Feb 2020 14:03:31 +0100
Message-Id: <20200226130345.209469-5-jolsa@kernel.org>
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

Adding name to 'struct bpf_ksym' object to carry the name
of the symbol for bpf_prog, bpf_trampoline, bpf_dispatcher.

The current benefit is that name is now generated only when
the symbol is added to the list, so we don't need to generate
it every time it's accessed.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h    | 2 ++
 include/linux/filter.h | 6 ------
 kernel/bpf/core.c      | 8 +++++---
 kernel/events/core.c   | 9 ++++-----
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5ad8eea1cd37..e7b2e9fc256c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -18,6 +18,7 @@
 #include <linux/refcount.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/kallsyms.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -465,6 +466,7 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
 struct bpf_ksym {
 	unsigned long		 start;
 	unsigned long		 end;
+	char			 name[KSYM_NAME_LEN];
 };
 
 enum bpf_tramp_prog_type {
diff --git a/include/linux/filter.h b/include/linux/filter.h
index eafe72644282..a945c250ad53 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1062,7 +1062,6 @@ bpf_address_lookup(unsigned long addr, unsigned long *size,
 
 void bpf_prog_kallsyms_add(struct bpf_prog *fp);
 void bpf_prog_kallsyms_del(struct bpf_prog *fp);
-void bpf_get_prog_name(const struct bpf_prog *prog, char *sym);
 
 #else /* CONFIG_BPF_JIT */
 
@@ -1131,11 +1130,6 @@ static inline void bpf_prog_kallsyms_del(struct bpf_prog *fp)
 {
 }
 
-static inline void bpf_get_prog_name(const struct bpf_prog *prog, char *sym)
-{
-	sym[0] = '\0';
-}
-
 #endif /* CONFIG_BPF_JIT */
 
 void bpf_prog_kallsyms_del_all(struct bpf_prog *fp);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 39a9e4184900..a7aaa81035b1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -535,8 +535,9 @@ bpf_get_prog_addr_region(const struct bpf_prog *prog)
 	prog->aux->ksym.end   = addr + hdr->pages * PAGE_SIZE;
 }
 
-void bpf_get_prog_name(const struct bpf_prog *prog, char *sym)
+static void bpf_get_prog_name(const struct bpf_prog *prog)
 {
+	char *sym = prog->aux->ksym.name;
 	const char *end = sym + KSYM_NAME_LEN;
 	const struct btf_type *type;
 	const char *func_name;
@@ -643,6 +644,7 @@ void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 		return;
 
 	bpf_get_prog_addr_region(fp);
+	bpf_get_prog_name(fp);
 
 	spin_lock_bh(&bpf_lock);
 	bpf_prog_ksym_node_add(fp->aux);
@@ -681,7 +683,7 @@ const char *__bpf_address_lookup(unsigned long addr, unsigned long *size,
 		unsigned long symbol_start = prog->aux->ksym.start;
 		unsigned long symbol_end = prog->aux->ksym.end;
 
-		bpf_get_prog_name(prog, sym);
+		strncpy(sym, prog->aux->ksym.name, KSYM_NAME_LEN);
 
 		ret = sym;
 		if (size)
@@ -738,7 +740,7 @@ int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		if (it++ != symnum)
 			continue;
 
-		bpf_get_prog_name(aux->prog, sym);
+		strncpy(sym, aux->ksym.name, KSYM_NAME_LEN);
 
 		*value = (unsigned long)aux->prog->bpf_func;
 		*type  = BPF_SYM_ELF_TYPE;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e453589da97c..a2cfb9e5f262 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8255,23 +8255,22 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 					 enum perf_bpf_event_type type)
 {
 	bool unregister = type == PERF_BPF_EVENT_PROG_UNLOAD;
-	char sym[KSYM_NAME_LEN];
 	int i;
 
 	if (prog->aux->func_cnt == 0) {
-		bpf_get_prog_name(prog, sym);
 		perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF,
 				   (u64)(unsigned long)prog->bpf_func,
-				   prog->jited_len, unregister, sym);
+				   prog->jited_len, unregister,
+				   prog->aux->ksym.name);
 	} else {
 		for (i = 0; i < prog->aux->func_cnt; i++) {
 			struct bpf_prog *subprog = prog->aux->func[i];
 
-			bpf_get_prog_name(subprog, sym);
 			perf_event_ksymbol(
 				PERF_RECORD_KSYMBOL_TYPE_BPF,
 				(u64)(unsigned long)subprog->bpf_func,
-				subprog->jited_len, unregister, sym);
+				subprog->jited_len, unregister,
+				prog->aux->ksym.name);
 		}
 	}
 }
-- 
2.24.1

