Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFA4347FAC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhCXRlC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Mar 2021 13:41:02 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:32922 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237215AbhCXRkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:40:42 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-BiaTXAiaOfG_77Pga_j6EA-1; Wed, 24 Mar 2021 13:40:35 -0400
X-MC-Unique: BiaTXAiaOfG_77Pga_j6EA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BC40881283;
        Wed, 24 Mar 2021 17:40:34 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 677145D9D0;
        Wed, 24 Mar 2021 17:40:31 +0000 (UTC)
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
Subject: [PATCHv2] bpf: Take module reference for trampoline in module
Date:   Wed, 24 Mar 2021 18:40:30 +0100
Message-Id: <20210324174030.2053353-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
v2 changes:
  - fixed ip_module_put to do preempt_disable/preempt_enable

 kernel/bpf/trampoline.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 1f3a4be4b175..39e4280f94e4 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -87,6 +87,26 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
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
+	preempt_disable();
+	module_put(__module_text_address(ip));
+	preempt_enable();
+}
+
 static int is_ftrace_location(void *ip)
 {
 	long addr;
@@ -108,6 +128,9 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
 	else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
+
+	if (!ret)
+		ip_module_put((unsigned long) ip);
 	return ret;
 }
 
@@ -126,6 +149,7 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
 /* first time registering */
 static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 {
+	struct module *mod;
 	void *ip = tr->func.addr;
 	int ret;
 
@@ -134,10 +158,17 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
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

