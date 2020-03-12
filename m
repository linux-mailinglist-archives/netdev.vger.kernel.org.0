Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A408183A00
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgCLT5F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:57:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30604 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgCLT5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:57:04 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Y_-efEgtMQ-mgotKQmtRlQ-1; Thu, 12 Mar 2020 15:57:00 -0400
X-MC-Unique: Y_-efEgtMQ-mgotKQmtRlQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F20AA8018C9;
        Thu, 12 Mar 2020 19:56:57 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D96B5D9C5;
        Thu, 12 Mar 2020 19:56:52 +0000 (UTC)
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
Subject: [PATCH 08/15] bpf: Add prog flag to struct bpf_ksym object
Date:   Thu, 12 Mar 2020 20:56:03 +0100
Message-Id: <20200312195610.346362-9-jolsa@kernel.org>
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

Adding 'prog' bool flag to 'struct bpf_ksym' to mark that
this object belongs to bpf_prog object.

This change allows having bpf_prog objects together with
other types (trampolines and dispatchers) in the single
bpf_tree. It's used when searching for bpf_prog exception
tables by the bpf_prog_ksym_find function, where we need
to get the bpf_prog pointer.

From now we can safely add bpf_ksym support for trampoline
or dispatcher objects, because we can differentiate them
from bpf_prog objects.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  1 +
 kernel/bpf/core.c   | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c5afff03b0f4..739ec3f562bf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -478,6 +478,7 @@ struct bpf_ksym {
 	char			 name[KSYM_NAME_LEN];
 	struct list_head	 lnode;
 	struct latch_tree_node	 tnode;
+	bool			 prog;
 };
 
 enum bpf_tramp_prog_type {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 6b58c2f1c9c0..92577a81122a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -642,6 +642,7 @@ void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 
 	bpf_prog_ksym_set_addr(fp);
 	bpf_prog_ksym_set_name(fp);
+	fp->aux->ksym.prog = true;
 
 	spin_lock_bh(&bpf_lock);
 	bpf_prog_ksym_node_add(fp->aux);
@@ -658,16 +659,6 @@ void bpf_prog_kallsyms_del(struct bpf_prog *fp)
 	spin_unlock_bh(&bpf_lock);
 }
 
-static struct bpf_prog *bpf_prog_kallsyms_find(unsigned long addr)
-{
-	struct latch_tree_node *n;
-
-	n = latch_tree_find((void *)addr, &bpf_tree, &bpf_tree_ops);
-	return n ?
-	       container_of(n, struct bpf_prog_aux, ksym.tnode)->prog :
-	       NULL;
-}
-
 static struct bpf_ksym *bpf_ksym_find(unsigned long addr)
 {
 	struct latch_tree_node *n;
@@ -712,13 +703,22 @@ bool is_bpf_text_address(unsigned long addr)
 	return ret;
 }
 
+static struct bpf_prog *bpf_prog_ksym_find(unsigned long addr)
+{
+	struct bpf_ksym *ksym = bpf_ksym_find(addr);
+
+	return ksym && ksym->prog ?
+	       container_of(ksym, struct bpf_prog_aux, ksym)->prog :
+	       NULL;
+}
+
 const struct exception_table_entry *search_bpf_extables(unsigned long addr)
 {
 	const struct exception_table_entry *e = NULL;
 	struct bpf_prog *prog;
 
 	rcu_read_lock();
-	prog = bpf_prog_kallsyms_find(addr);
+	prog = bpf_prog_ksym_find(addr);
 	if (!prog)
 		goto out;
 	if (!prog->aux->num_exentries)
-- 
2.24.1

