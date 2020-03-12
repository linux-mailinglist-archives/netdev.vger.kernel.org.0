Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7031839FD
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCLT45 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:56:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726810AbgCLT45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:56:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-gtkdpjTwOACrhaN1BXBxHA-1; Thu, 12 Mar 2020 15:56:54 -0400
X-MC-Unique: gtkdpjTwOACrhaN1BXBxHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15A4ADB61;
        Thu, 12 Mar 2020 19:56:52 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAAE65DA7B;
        Thu, 12 Mar 2020 19:56:44 +0000 (UTC)
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
Subject: [PATCH 07/15] bpf: Add bpf_ksym_find function
Date:   Thu, 12 Mar 2020 20:56:02 +0100
Message-Id: <20200312195610.346362-8-jolsa@kernel.org>
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

Adding bpf_ksym_find function that is used bpf bpf address
lookup functions:
  __bpf_address_lookup
  is_bpf_text_address

while keeping bpf_prog_kallsyms_find to be used only for lookup
of bpf_prog objects (will happen in following changes).

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/core.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index df0caa4bc9cc..6b58c2f1c9c0 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -668,19 +668,27 @@ static struct bpf_prog *bpf_prog_kallsyms_find(unsigned long addr)
 	       NULL;
 }
 
+static struct bpf_ksym *bpf_ksym_find(unsigned long addr)
+{
+	struct latch_tree_node *n;
+
+	n = latch_tree_find((void *)addr, &bpf_tree, &bpf_tree_ops);
+	return n ? container_of(n, struct bpf_ksym, tnode) : NULL;
+}
+
 const char *__bpf_address_lookup(unsigned long addr, unsigned long *size,
 				 unsigned long *off, char *sym)
 {
-	struct bpf_prog *prog;
+	struct bpf_ksym *ksym;
 	char *ret = NULL;
 
 	rcu_read_lock();
-	prog = bpf_prog_kallsyms_find(addr);
-	if (prog) {
-		unsigned long symbol_start = prog->aux->ksym.start;
-		unsigned long symbol_end = prog->aux->ksym.end;
+	ksym = bpf_ksym_find(addr);
+	if (ksym) {
+		unsigned long symbol_start = ksym->start;
+		unsigned long symbol_end = ksym->end;
 
-		strncpy(sym, prog->aux->ksym.name, KSYM_NAME_LEN);
+		strncpy(sym, ksym->name, KSYM_NAME_LEN);
 
 		ret = sym;
 		if (size)
@@ -698,7 +706,7 @@ bool is_bpf_text_address(unsigned long addr)
 	bool ret;
 
 	rcu_read_lock();
-	ret = bpf_prog_kallsyms_find(addr) != NULL;
+	ret = bpf_ksym_find(addr) != NULL;
 	rcu_read_unlock();
 
 	return ret;
-- 
2.24.1

