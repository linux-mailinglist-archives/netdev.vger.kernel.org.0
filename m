Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC135CB2A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243413AbhDLQXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243288AbhDLQXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F41E60FD7;
        Mon, 12 Apr 2021 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244598;
        bh=U7lrLvYeZLzX0uWHc2XMXoABjhSSZOMnk8XosbBLOO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcoHbbEhN1AQi77tyBt6EzJdWysBNEabNc9Yg70IAeYoY4OupuBku+5UrAS+0w6qc
         U5/2d5ncvRE1ypt8p+/Ii2UZ272yXsFs/gq0Qg1NL+E2YTkXNPKgcvw8xueleHlnQT
         mlf05pZ35vXY9bnk00wzNR+tcGYf6vViMNfFWOFVW45fT+fC8l5Umy6pJyOEliBODm
         B/b4qypQ22TR8FUY02fd3XjrTC9McaMuBYVzqNd+6SjkxR4feJMI0d/CCfm1HSekmQ
         ENOgVmoTIf1/OCaRUm09TPeYnEeo7JvcM29OEH9nVN2dM6lVtuxQsxb0G/zDk0BVGo
         1CZgOnubebcZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 17/51] bpf: Take module reference for trampoline in module
Date:   Mon, 12 Apr 2021 12:22:22 -0400
Message-Id: <20210412162256.313524-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 861de02e5f3f2a104eecc5af1d248cb7bf8c5f75 ]

Currently module can be unloaded even if there's a trampoline
register in it. It's easily reproduced by running in parallel:

  # while :; do ./test_progs -t module_attach; done
  # while :; do rmmod bpf_testmod; sleep 0.5; done

Taking the module reference in case the trampoline's ip is
within the module code. Releasing it when the trampoline's
ip is unregistered.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210326105900.151466-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     |  2 ++
 kernel/bpf/trampoline.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 564ebf91793e..88b581b75d5b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -41,6 +41,7 @@ struct bpf_local_storage;
 struct bpf_local_storage_map;
 struct kobject;
 struct mem_cgroup;
+struct module;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -630,6 +631,7 @@ struct bpf_trampoline {
 	/* Executable image of trampoline */
 	struct bpf_tramp_image *cur_image;
 	u64 selector;
+	struct module *mod;
 };
 
 struct bpf_attach_target_info {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 986dabc3d11f..a431d7af884c 100644
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

