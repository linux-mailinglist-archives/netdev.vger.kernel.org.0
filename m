Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5908139C7BF
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhFELMw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:12:52 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:30655 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhFELMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:12:50 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-l4h8A3QKMq-RhYGJ235PZQ-1; Sat, 05 Jun 2021 07:10:57 -0400
X-MC-Unique: l4h8A3QKMq-RhYGJ235PZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D450C801817;
        Sat,  5 Jun 2021 11:10:55 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 289BE2B0B1;
        Sat,  5 Jun 2021 11:10:51 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH 05/19] ftrace: Add ftrace_add_rec_direct function
Date:   Sat,  5 Jun 2021 13:10:20 +0200
Message-Id: <20210605111034.1810858-6-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the code that adds (ip, addr) tuple to direct_functions
hash in new ftrace_add_rec_direct function. It will be used in
following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/ftrace.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2e8a3fde7104..9e584710f542 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2388,6 +2388,39 @@ unsigned long ftrace_find_rec_direct(unsigned long ip)
 	return entry->direct;
 }
 
+static struct ftrace_func_entry*
+ftrace_add_rec_direct(unsigned long ip, unsigned long addr,
+		      struct ftrace_hash **free_hash)
+{
+	struct ftrace_func_entry *entry;
+
+	if (ftrace_hash_empty(direct_functions) ||
+	    direct_functions->count > 2 * (1 << direct_functions->size_bits)) {
+		struct ftrace_hash *new_hash;
+		int size = ftrace_hash_empty(direct_functions) ? 0 :
+			direct_functions->count + 1;
+
+		if (size < 32)
+			size = 32;
+
+		new_hash = dup_hash(direct_functions, size);
+		if (!new_hash)
+			return NULL;
+
+		*free_hash = direct_functions;
+		direct_functions = new_hash;
+	}
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return NULL;
+
+	entry->ip = ip;
+	entry->direct = addr;
+	__add_hash_entry(direct_functions, entry);
+	return entry;
+}
+
 static void call_direct_funcs(unsigned long ip, unsigned long pip,
 			      struct ftrace_ops *ops, struct ftrace_regs *fregs)
 {
@@ -5105,27 +5138,6 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	}
 
 	ret = -ENOMEM;
-	if (ftrace_hash_empty(direct_functions) ||
-	    direct_functions->count > 2 * (1 << direct_functions->size_bits)) {
-		struct ftrace_hash *new_hash;
-		int size = ftrace_hash_empty(direct_functions) ? 0 :
-			direct_functions->count + 1;
-
-		if (size < 32)
-			size = 32;
-
-		new_hash = dup_hash(direct_functions, size);
-		if (!new_hash)
-			goto out_unlock;
-
-		free_hash = direct_functions;
-		direct_functions = new_hash;
-	}
-
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		goto out_unlock;
-
 	direct = ftrace_find_direct_func(addr);
 	if (!direct) {
 		direct = ftrace_alloc_direct_func(addr);
@@ -5135,9 +5147,9 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 		}
 	}
 
-	entry->ip = ip;
-	entry->direct = addr;
-	__add_hash_entry(direct_functions, entry);
+	entry = ftrace_add_rec_direct(ip, addr, &free_hash);
+	if (!entry)
+		goto out_unlock;
 
 	ret = ftrace_set_filter_ip(&direct_ops, ip, 0, 0);
 	if (ret)
-- 
2.31.1

