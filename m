Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCDA295A12
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895251AbgJVIWT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:19 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:34022 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2894766AbgJVIWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:18 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-6hIyeFD-Niup_JfvA99kwg-1; Thu, 22 Oct 2020 04:22:13 -0400
X-MC-Unique: 6hIyeFD-Niup_JfvA99kwg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06B6B186DD37;
        Thu, 22 Oct 2020 08:22:11 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6C5C60BFA;
        Thu, 22 Oct 2020 08:22:07 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFC bpf-next 06/16] ftrace: Add unregister_ftrace_direct_ips function
Date:   Thu, 22 Oct 2020 10:21:28 +0200
Message-Id: <20201022082138.2322434-7-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding unregister_ftrace_direct_ips function that allows
to unregister array of ip addresses and trampolines for
direct filter. the interface is:

  int unregister_ftrace_direct_ips(unsigned long *ips,
                                   unsigned long *addrs,
                                   int count);

It wil be used in following patches to unregister bpf
trampolines in batch mode.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/ftrace.h |  2 ++
 kernel/trace/ftrace.c  | 51 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9ed52755667a..24525473043e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -293,6 +293,8 @@ int ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 unsigned long ftrace_find_rec_direct(unsigned long ip);
 int register_ftrace_direct_ips(unsigned long *ips, unsigned long *addrs,
 			       int count);
+int unregister_ftrace_direct_ips(unsigned long *ips, unsigned long *addrs,
+				 int count);
 #else
 # define ftrace_direct_func_count 0
 static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 770bcd1a245a..15a13e6c1f31 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5374,6 +5374,57 @@ int unregister_ftrace_direct(unsigned long ip, unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(unregister_ftrace_direct);
 
+int unregister_ftrace_direct_ips(unsigned long *ips, unsigned long *addrs,
+				 int count)
+{
+	struct ftrace_direct_func *direct;
+	struct ftrace_func_entry *entry;
+	int i, del = 0, ret = -ENODEV;
+
+	mutex_lock(&direct_mutex);
+
+	for (i = 0; i < count; i++) {
+		entry = find_direct_entry(&ips[i], NULL);
+		if (!entry)
+			goto out_unlock;
+		del++;
+	}
+
+	if (direct_functions->count - del == 0)
+		unregister_ftrace_function(&direct_ops);
+
+	ret = ftrace_set_filter_ips(&direct_ops, ips, count, 1);
+
+	WARN_ON(ret);
+
+	for (i = 0; i < count; i++) {
+		entry = __ftrace_lookup_ip(direct_functions, ips[i]);
+		if (WARN_ON(!entry))
+			continue;
+
+		remove_hash_entry(direct_functions, entry);
+
+		direct = ftrace_find_direct_func(addrs[i]);
+		if (!WARN_ON(!direct)) {
+			/* This is the good path (see the ! before WARN) */
+			direct->count--;
+			WARN_ON(direct->count < 0);
+			if (!direct->count) {
+				list_del_rcu(&direct->next);
+				synchronize_rcu_tasks();
+				kfree(direct);
+				kfree(entry);
+				ftrace_direct_func_count--;
+			}
+		}
+	}
+ out_unlock:
+	mutex_unlock(&direct_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_ftrace_direct_ips);
+
 static struct ftrace_ops stub_ops = {
 	.func		= ftrace_stub,
 };
-- 
2.26.2

