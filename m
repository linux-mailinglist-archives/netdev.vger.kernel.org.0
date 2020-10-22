Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFE8295A0B
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895142AbgJVIWB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:01 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:38401 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895052AbgJVIV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:21:59 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-eLPBuOAuPg-LALwjrKNG-g-1; Thu, 22 Oct 2020 04:21:54 -0400
X-MC-Unique: eLPBuOAuPg-LALwjrKNG-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A63221006C9E;
        Thu, 22 Oct 2020 08:21:52 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89E4A60BFA;
        Thu, 22 Oct 2020 08:21:49 +0000 (UTC)
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
Subject: [RFC bpf-next 02/16] ftrace: Add adjust_direct_size function
Date:   Thu, 22 Oct 2020 10:21:24 +0200
Message-Id: <20201022082138.2322434-3-jolsa@kernel.org>
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

Move code for adjusting size of direct hash into separate
adjust_direct_size function. It will be used in following
patches, there's no functional change.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/ftrace.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 27e9210073d3..cb8b7a66c6af 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5055,6 +5055,27 @@ static int check_direct_ip(unsigned long ip)
 	return 0;
 }
 
+static int adjust_direct_size(int new_size, struct ftrace_hash **free_hash)
+{
+	if (ftrace_hash_empty(direct_functions) ||
+	    direct_functions->count > 2 * (1 << direct_functions->size_bits)) {
+		struct ftrace_hash *new_hash;
+		int size = ftrace_hash_empty(direct_functions) ? 0 : new_size;
+
+		if (size < 32)
+			size = 32;
+
+		new_hash = dup_hash(direct_functions, size);
+		if (!new_hash)
+			return -ENOMEM;
+
+		*free_hash = direct_functions;
+		direct_functions = new_hash;
+	}
+
+	return 0;
+}
+
 /**
  * register_ftrace_direct - Call a custom trampoline directly
  * @ip: The address of the nop at the beginning of a function
@@ -5086,22 +5107,8 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 		goto out_unlock;
 
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
+	if (adjust_direct_size(direct_functions->count + 1, &free_hash))
+		goto out_unlock;
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
-- 
2.26.2

