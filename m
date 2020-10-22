Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA48295A09
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895098AbgJVIV7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:21:59 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:32529 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895065AbgJVIV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:21:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-ZLP9DZhuMCaTUgbcWPi4aw-1; Thu, 22 Oct 2020 04:21:51 -0400
X-MC-Unique: ZLP9DZhuMCaTUgbcWPi4aw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 333C9846375;
        Thu, 22 Oct 2020 08:21:49 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1659F60BFA;
        Thu, 22 Oct 2020 08:21:45 +0000 (UTC)
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
Subject: [RFC bpf-next 01/16] ftrace: Add check_direct_entry function
Date:   Thu, 22 Oct 2020 10:21:23 +0200
Message-Id: <20201022082138.2322434-2-jolsa@kernel.org>
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

Move code that checks on valid direct ip into separate
check_direct_entry function. It will be used in following
patches, there's no functional change.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/ftrace.c | 55 +++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8185f7240095..27e9210073d3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5025,6 +5025,36 @@ struct ftrace_direct_func *ftrace_find_direct_func(unsigned long addr)
 	return NULL;
 }
 
+static int check_direct_ip(unsigned long ip)
+{
+	struct dyn_ftrace *rec;
+
+	/* See if there's a direct function at @ip already */
+	if (ftrace_find_rec_direct(ip))
+		return -EBUSY;
+
+	rec = lookup_rec(ip, ip);
+	if (!rec)
+		return -ENODEV;
+
+	/*
+	 * Check if the rec says it has a direct call but we didn't
+	 * find one earlier?
+	 */
+	if (WARN_ON(rec->flags & FTRACE_FL_DIRECT))
+		return -ENODEV;
+
+	/* Make sure the ip points to the exact record */
+	if (ip != rec->ip) {
+		ip = rec->ip;
+		/* Need to check this ip for a direct. */
+		if (ftrace_find_rec_direct(ip))
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 /**
  * register_ftrace_direct - Call a custom trampoline directly
  * @ip: The address of the nop at the beginning of a function
@@ -5047,35 +5077,14 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	struct ftrace_direct_func *direct;
 	struct ftrace_func_entry *entry;
 	struct ftrace_hash *free_hash = NULL;
-	struct dyn_ftrace *rec;
 	int ret = -EBUSY;
 
 	mutex_lock(&direct_mutex);
 
-	/* See if there's a direct function at @ip already */
-	if (ftrace_find_rec_direct(ip))
-		goto out_unlock;
-
-	ret = -ENODEV;
-	rec = lookup_rec(ip, ip);
-	if (!rec)
-		goto out_unlock;
-
-	/*
-	 * Check if the rec says it has a direct call but we didn't
-	 * find one earlier?
-	 */
-	if (WARN_ON(rec->flags & FTRACE_FL_DIRECT))
+	ret = check_direct_ip(ip);
+	if (ret)
 		goto out_unlock;
 
-	/* Make sure the ip points to the exact record */
-	if (ip != rec->ip) {
-		ip = rec->ip;
-		/* Need to check this ip for a direct. */
-		if (ftrace_find_rec_direct(ip))
-			goto out_unlock;
-	}
-
 	ret = -ENOMEM;
 	if (ftrace_hash_empty(direct_functions) ||
 	    direct_functions->count > 2 * (1 << direct_functions->size_bits)) {
-- 
2.26.2

