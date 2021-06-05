Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1064E39C7BE
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhFELMv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:12:51 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:28226 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230118AbhFELMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:12:50 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-I_u0oFeBMjqeHZaHD_7wiw-1; Sat, 05 Jun 2021 07:10:59 -0400
X-MC-Unique: I_u0oFeBMjqeHZaHD_7wiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9044107ACCD;
        Sat,  5 Jun 2021 11:10:57 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31706614FD;
        Sat,  5 Jun 2021 11:10:55 +0000 (UTC)
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
Subject: [PATCH 06/19] ftrace: Add multi direct register/unregister interface
Date:   Sat,  5 Jun 2021 13:10:21 +0200
Message-Id: <20210605111034.1810858-7-jolsa@kernel.org>
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

Adding interface to register multiple direct functions
within single call. Adding following functions:

  register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
  unregister_ftrace_direct_multi(struct ftrace_ops *ops)

The register_ftrace_direct_multi registers direct function (addr)
with all functions in ops filter. The ops filter can be updated
before with ftrace_set_filter_ip calls.

All requested functions must not have direct function currently
registered, otherwise register_ftrace_direct_multi will fail.

The unregister_ftrace_direct_multi unregisters ops related direct
functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/ftrace.h |  10 ++++
 kernel/trace/ftrace.c  | 108 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 40b493908f09..91e8d9534ad7 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -316,6 +316,8 @@ int ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 				unsigned long old_addr,
 				unsigned long new_addr);
 unsigned long ftrace_find_rec_direct(unsigned long ip);
+int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr);
+int unregister_ftrace_direct_multi(struct ftrace_ops *ops);
 #else
 # define ftrace_direct_func_count 0
 static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
@@ -346,6 +348,14 @@ static inline unsigned long ftrace_find_rec_direct(unsigned long ip)
 {
 	return 0;
 }
+int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+{
+	return -ENODEV;
+}
+int unregister_ftrace_direct_multi(struct ftrace_ops *ops)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9e584710f542..f1ebee1bfbfe 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5402,6 +5402,114 @@ int modify_ftrace_direct(unsigned long ip,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(modify_ftrace_direct);
+
+#define MULTI_FLAGS (FTRACE_OPS_FL_IPMODIFY | FTRACE_OPS_FL_DIRECT | \
+		     FTRACE_OPS_FL_SAVE_REGS)
+
+static int check_direct_multi(struct ftrace_ops *ops)
+{
+	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED))
+		return -EINVAL;
+	if ((ops->flags & MULTI_FLAGS) != MULTI_FLAGS)
+		return -EINVAL;
+	return 0;
+}
+
+int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+	struct ftrace_func_entry *entry, *new;
+	struct ftrace_hash *free_hash = NULL;
+	int err = -EBUSY, size, i;
+
+	if (ops->func || ops->trampoline)
+		return -EINVAL;
+	if (ops->flags & FTRACE_OPS_FL_ENABLED)
+		return -EINVAL;
+	if (ftrace_hash_empty(hash))
+		return -EINVAL;
+
+	mutex_lock(&direct_mutex);
+
+	/* Make sure requested entries are not already registered.. */
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			if (ftrace_find_rec_direct(entry->ip))
+				goto out_unlock;
+		}
+	}
+
+	/* ... and insert them to direct_functions hash. */
+	err = -ENOMEM;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			new = ftrace_add_rec_direct(entry->ip, addr, &free_hash);
+			if (!new)
+				goto out_remove;
+			entry->direct = addr;
+		}
+	}
+
+	ops->func = call_direct_funcs;
+	ops->flags = MULTI_FLAGS;
+	ops->trampoline = FTRACE_REGS_ADDR;
+
+	err = register_ftrace_function(ops);
+
+ out_remove:
+	if (err) {
+		for (i = 0; i < size; i++) {
+			hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+				new = __ftrace_lookup_ip(direct_functions, entry->ip);
+				if (new) {
+					remove_hash_entry(direct_functions, new);
+					kfree(new);
+				}
+			}
+		}
+	}
+
+ out_unlock:
+	mutex_unlock(&direct_mutex);
+
+	if (free_hash) {
+		synchronize_rcu_tasks();
+		free_ftrace_hash(free_hash);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(register_ftrace_direct_multi);
+
+int unregister_ftrace_direct_multi(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+	struct ftrace_func_entry *entry, *new;
+	int err, size, i;
+
+	if (check_direct_multi(ops))
+		return -EINVAL;
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return -EINVAL;
+
+	mutex_lock(&direct_mutex);
+	err = unregister_ftrace_function(ops);
+
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			new = __ftrace_lookup_ip(direct_functions, entry->ip);
+			if (new) {
+				remove_hash_entry(direct_functions, new);
+				kfree(new);
+			}
+		}
+	}
+
+	mutex_unlock(&direct_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(unregister_ftrace_direct_multi);
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 /**
-- 
2.31.1

