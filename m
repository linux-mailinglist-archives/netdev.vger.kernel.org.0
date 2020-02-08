Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC213156526
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbgBHPmn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 10:42:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42949 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727478AbgBHPmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 10:42:43 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-SRaQa9irPK-hd9qKnJ4D-A-1; Sat, 08 Feb 2020 10:42:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 349E38010CA;
        Sat,  8 Feb 2020 15:42:36 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F37345C21B;
        Sat,  8 Feb 2020 15:42:31 +0000 (UTC)
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
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 04/14] bpf: Add name to struct bpf_ksym
Date:   Sat,  8 Feb 2020 16:41:59 +0100
Message-Id: <20200208154209.1797988-5-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: SRaQa9irPK-hd9qKnJ4D-A-1
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
 kernel/events/core.c   | 4 ++--
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e39ded33fb0c..1327b07057a8 100644
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
index 09b5939dcad3..f4f0b3ca95ae 100644
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
index 2173c23c25b4..c4b01ca30cd4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8250,7 +8250,7 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 	int i;
 
 	if (prog->aux->func_cnt == 0) {
-		bpf_get_prog_name(prog, sym);
+		strncpy(sym, prog->aux->ksym.name, KSYM_NAME_LEN);
 		perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF,
 				   (u64)(unsigned long)prog->bpf_func,
 				   prog->jited_len, unregister, sym);
@@ -8258,7 +8258,7 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 		for (i = 0; i < prog->aux->func_cnt; i++) {
 			struct bpf_prog *subprog = prog->aux->func[i];
 
-			bpf_get_prog_name(subprog, sym);
+			strncpy(sym, subprog->aux->ksym.name, KSYM_NAME_LEN);
 			perf_event_ksymbol(
 				PERF_RECORD_KSYMBOL_TYPE_BPF,
 				(u64)(unsigned long)subprog->bpf_func,
-- 
2.24.1

