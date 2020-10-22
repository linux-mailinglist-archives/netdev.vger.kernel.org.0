Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F169295A0D
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895195AbgJVIWE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:04 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:50423 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895171AbgJVIWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:03 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-gMQl2aa5NIarZOrl5RRJDg-1; Thu, 22 Oct 2020 04:21:58 -0400
X-MC-Unique: gMQl2aa5NIarZOrl5RRJDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425641868424;
        Thu, 22 Oct 2020 08:21:56 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B46260BFA;
        Thu, 22 Oct 2020 08:21:52 +0000 (UTC)
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
Subject: [RFC bpf-next 03/16] ftrace: Add get/put_direct_func function
Date:   Thu, 22 Oct 2020 10:21:25 +0200
Message-Id: <20201022082138.2322434-4-jolsa@kernel.org>
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

Move code for managing ftrace_direct_funcs entries
into get_direct_func and put_direct_func functions.
It will be used in following patches, there's no
functional change.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/ftrace.c | 44 +++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cb8b7a66c6af..95ef7e2a6a57 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5076,6 +5076,32 @@ static int adjust_direct_size(int new_size, struct ftrace_hash **free_hash)
 	return 0;
 }
 
+static struct ftrace_direct_func *get_direct_func(unsigned long addr)
+{
+	struct ftrace_direct_func *direct;
+
+	direct = ftrace_find_direct_func(addr);
+	if (!direct) {
+		direct = kmalloc(sizeof(*direct), GFP_KERNEL);
+		if (!direct)
+			return NULL;
+		direct->addr = addr;
+		direct->count = 0;
+		list_add_rcu(&direct->next, &ftrace_direct_funcs);
+		ftrace_direct_func_count++;
+	}
+
+	return direct;
+}
+
+static void put_direct_func(struct ftrace_direct_func *direct)
+{
+	list_del_rcu(&direct->next);
+	synchronize_rcu_tasks();
+	kfree(direct);
+	ftrace_direct_func_count--;
+}
+
 /**
  * register_ftrace_direct - Call a custom trampoline directly
  * @ip: The address of the nop at the beginning of a function
@@ -5114,17 +5140,10 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	if (!entry)
 		goto out_unlock;
 
-	direct = ftrace_find_direct_func(addr);
+	direct = get_direct_func(addr);
 	if (!direct) {
-		direct = kmalloc(sizeof(*direct), GFP_KERNEL);
-		if (!direct) {
-			kfree(entry);
-			goto out_unlock;
-		}
-		direct->addr = addr;
-		direct->count = 0;
-		list_add_rcu(&direct->next, &ftrace_direct_funcs);
-		ftrace_direct_func_count++;
+		kfree(entry);
+		goto out_unlock;
 	}
 
 	entry->ip = ip;
@@ -5144,13 +5163,10 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	if (ret) {
 		kfree(entry);
 		if (!direct->count) {
-			list_del_rcu(&direct->next);
-			synchronize_rcu_tasks();
-			kfree(direct);
+			put_direct_func(direct);
 			if (free_hash)
 				free_ftrace_hash(free_hash);
 			free_hash = NULL;
-			ftrace_direct_func_count--;
 		}
 	} else {
 		direct->count++;
-- 
2.26.2

