Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202C6346AE3
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhCWVQQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Mar 2021 17:16:16 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:20430 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233526AbhCWVPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 17:15:43 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-NruRWxZxN6yMSEb7UuawiQ-1; Tue, 23 Mar 2021 17:15:38 -0400
X-MC-Unique: NruRWxZxN6yMSEb7UuawiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D988180FCA5;
        Tue, 23 Mar 2021 21:15:36 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0276559466;
        Tue, 23 Mar 2021 21:15:33 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH bpf] bpf: Take module reference for ip in module code
Date:   Tue, 23 Mar 2021 22:15:33 +0100
Message-Id: <20210323211533.1931242-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently module can be unloaded even if there's a trampoline
register in it. It's easily reproduced by running in parallel:

  # while :; do ./test_progs -t module_attach; done
  # while :; do ./test_progs -t fentry_test; done

Taking the module reference in case the trampoline's ip is
within the module code. Releasing it when the trampoline's
ip is unregistered.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/trampoline.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 1f3a4be4b175..f6cb179842b2 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -87,6 +87,27 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	return tr;
 }
 
+static struct module *ip_module_get(unsigned long ip)
+{
+	struct module *mod;
+	int err = 0;
+
+	preempt_disable();
+	mod = __module_text_address(ip);
+	if (mod && !try_module_get(mod))
+		err = -ENOENT;
+	preempt_enable();
+	return err ? ERR_PTR(err) : mod;
+}
+
+static void ip_module_put(unsigned long ip)
+{
+	struct module *mod = __module_text_address(ip);
+
+	if (mod)
+		module_put(mod);
+}
+
 static int is_ftrace_location(void *ip)
 {
 	long addr;
@@ -108,6 +129,9 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
 	else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
+
+	if (!ret)
+		ip_module_put((unsigned long) ip);
 	return ret;
 }
 
@@ -126,6 +150,7 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
 /* first time registering */
 static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 {
+	struct module *mod;
 	void *ip = tr->func.addr;
 	int ret;
 
@@ -134,10 +159,17 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 		return ret;
 	tr->func.ftrace_managed = ret;
 
+	mod = ip_module_get((unsigned long) ip);
+	if (IS_ERR(mod))
+		return -ENOENT;
+
 	if (tr->func.ftrace_managed)
 		ret = register_ftrace_direct((long)ip, (long)new_addr);
 	else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
+
+	if (ret)
+		module_put(mod);
 	return ret;
 }
 
-- 
2.30.2

