Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BAC39C7BA
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFELMq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:12:46 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:44718 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230118AbhFELMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:12:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-XAGNN3y7OmmpP6l2y-Mz6Q-1; Sat, 05 Jun 2021 07:10:47 -0400
X-MC-Unique: XAGNN3y7OmmpP6l2y-Mz6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DFBF1927800;
        Sat,  5 Jun 2021 11:10:45 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC6DA614FD;
        Sat,  5 Jun 2021 11:10:42 +0000 (UTC)
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
Subject: [PATCH 02/19] x86/ftrace: Remove fault protection code in prepare_ftrace_return
Date:   Sat,  5 Jun 2021 13:10:17 +0200
Message-Id: <20210605111034.1810858-3-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="US-ASCII"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Removing the fault protection code when writing return_hooker
to stack. As Steven noted:

> That protection was there from the beginning due to being "paranoid",
> considering ftrace was bricking network cards. But that protection
> would not have even protected against that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/kernel/ftrace.c | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b3ce3b4a2a2..c555624da989 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -625,12 +625,10 @@ int ftrace_disable_ftrace_graph_caller(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
-void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
+void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
 			   unsigned long frame_pointer)
 {
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
-	unsigned long old;
-	int faulted;
 
 	/*
 	 * When resuming from suspend-to-ram, this function can be indirectly
@@ -650,37 +648,7 @@ void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-	/*
-	 * Protect against fault, even if it shouldn't
-	 * happen. This tool is too much intrusive to
-	 * ignore such a protection.
-	 */
-	asm volatile(
-		"1: " _ASM_MOV " (%[parent]), %[old]\n"
-		"2: " _ASM_MOV " %[return_hooker], (%[parent])\n"
-		"   movl $0, %[faulted]\n"
-		"3:\n"
-
-		".section .fixup, \"ax\"\n"
-		"4: movl $1, %[faulted]\n"
-		"   jmp 3b\n"
-		".previous\n"
-
-		_ASM_EXTABLE(1b, 4b)
-		_ASM_EXTABLE(2b, 4b)
-
-		: [old] "=&r" (old), [faulted] "=r" (faulted)
-		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
-		: "memory"
-	);
-
-	if (unlikely(faulted)) {
-		ftrace_graph_stop();
-		WARN_ON(1);
-		return;
-	}
-
-	if (function_graph_enter(old, self_addr, frame_pointer, parent))
-		*parent = old;
+	if (!function_graph_enter(*parent, ip, frame_pointer, parent))
+		*parent = return_hooker;
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
2.31.1

