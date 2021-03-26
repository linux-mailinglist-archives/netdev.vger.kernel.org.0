Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F82034A60B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 12:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCZK73 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Mar 2021 06:59:29 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:33164 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229969AbhCZK7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:59:16 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-pG2p-HekMX2mhPBHgeop6A-1; Fri, 26 Mar 2021 06:59:06 -0400
X-MC-Unique: pG2p-HekMX2mhPBHgeop6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F5371906813;
        Fri, 26 Mar 2021 10:59:04 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70D3B1972B;
        Fri, 26 Mar 2021 10:59:01 +0000 (UTC)
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
Subject: [PATCHv3 bpf] bpf: Take module reference for trampoline in module
Date:   Fri, 26 Mar 2021 11:59:00 +0100
Message-Id: <20210326105900.151466-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
  # while :; do rmmod bpf_testmod; sleep 0.5; done

Taking the module reference in case the trampoline's ip is
within the module code. Releasing it when the trampoline's
ip is unregistered.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 v3 changes:
   - store module pointer under bpf_trampoline struct

 include/linux/bpf.h     |  2 ++
 kernel/bpf/trampoline.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3625f019767d..fdac0534ce79 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -40,6 +40,7 @@ struct bpf_local_storage;
 struct bpf_local_storage_map;
 struct kobject;
 struct mem_cgroup;
+struct module;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -623,6 +624,7 @@ struct bpf_trampoline {
 	/* Executable image of trampoline */
 	struct bpf_tramp_image *cur_image;
 	u64 selector;
+	struct module *mod;
 };
 
 struct bpf_attach_target_info {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 1f3a4be4b175..4aa8b52adf25 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -9,6 +9,7 @@
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/rcupdate_wait.h>
+#include <linux/module.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -87,6 +88,26 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	return tr;
 }
 
+static int bpf_trampoline_module_get(struct bpf_trampoline *tr)
+{
+	struct module *mod;
+	int err = 0;
+
+	preempt_disable();
+	mod = __module_text_address((unsigned long) tr->func.addr);
+	if (mod && !try_module_get(mod))
+		err = -ENOENT;
+	preempt_enable();
+	tr->mod = mod;
+	return err;
+}
+
+static void bpf_trampoline_module_put(struct bpf_trampoline *tr)
+{
+	module_put(tr->mod);
+	tr->mod = NULL;
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
+		bpf_trampoline_module_put(tr);
 	return ret;
 }
 
@@ -134,10 +158,16 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 		return ret;
 	tr->func.ftrace_managed = ret;
 
+	if (bpf_trampoline_module_get(tr))
+		return -ENOENT;
+
 	if (tr->func.ftrace_managed)
 		ret = register_ftrace_direct((long)ip, (long)new_addr);
 	else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
+
+	if (ret)
+		bpf_trampoline_module_put(tr);
 	return ret;
 }
 
-- 
2.30.2

