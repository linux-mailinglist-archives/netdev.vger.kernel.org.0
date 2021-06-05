Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9E739C7C2
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFELMz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:12:55 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:31233 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbhFELMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:12:54 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-a52GMLvgOl-UWBA_EKHSEQ-1; Sat, 05 Jun 2021 07:11:03 -0400
X-MC-Unique: a52GMLvgOl-UWBA_EKHSEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFFEF107ACCD;
        Sat,  5 Jun 2021 11:11:00 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3709C2B0B1;
        Sat,  5 Jun 2021 11:10:58 +0000 (UTC)
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
Subject: [PATCH 07/19] ftrace: Add multi direct modify interface
Date:   Sat,  5 Jun 2021 13:10:22 +0200
Message-Id: <20210605111034.1810858-8-jolsa@kernel.org>
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

Adding interface to modify registered direct function
for ftrace_ops. Adding following function:

   modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)

The function changes the currently registered direct
function for all attached functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/ftrace.h |  6 ++++++
 kernel/trace/ftrace.c  | 43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 91e8d9534ad7..7f63615ea2b1 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -318,6 +318,8 @@ int ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 unsigned long ftrace_find_rec_direct(unsigned long ip);
 int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr);
 int unregister_ftrace_direct_multi(struct ftrace_ops *ops);
+int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr);
+
 #else
 # define ftrace_direct_func_count 0
 static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
@@ -356,6 +358,10 @@ int unregister_ftrace_direct_multi(struct ftrace_ops *ops)
 {
 	return -ENODEV;
 }
+int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1ebee1bfbfe..82fbfa05e311 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5510,6 +5510,49 @@ int unregister_ftrace_direct_multi(struct ftrace_ops *ops)
 	return err;
 }
 EXPORT_SYMBOL_GPL(unregister_ftrace_direct_multi);
+
+int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+	struct ftrace_func_entry *entry, *iter;
+	int i, size;
+	int err;
+
+	if (check_direct_multi(ops))
+		return -EINVAL;
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return -EINVAL;
+
+	mutex_lock(&direct_mutex);
+	mutex_lock(&ftrace_lock);
+
+	/*
+	 * Shutdown the ops, change 'direct' pointer for each
+	 * ops entry in direct_functions hash and startup the
+	 * ops back again.
+	 */
+	err = ftrace_shutdown(ops, 0);
+	if (err)
+		goto out_unlock;
+
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(iter, &hash->buckets[i], hlist) {
+			entry = __ftrace_lookup_ip(direct_functions, iter->ip);
+			if (!entry)
+				continue;
+			entry->direct = addr;
+		}
+	}
+
+	err = ftrace_startup(ops, 0);
+
+ out_unlock:
+	mutex_unlock(&ftrace_lock);
+	mutex_unlock(&direct_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(modify_ftrace_direct_multi);
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 /**
-- 
2.31.1

