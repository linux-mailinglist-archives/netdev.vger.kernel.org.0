Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A60115FE8
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 01:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfLHAEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 19:04:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLHAEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 19:04:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA71315449D81;
        Sat,  7 Dec 2019 16:04:13 -0800 (PST)
Date:   Sat, 07 Dec 2019 16:04:13 -0800 (PST)
Message-Id: <20191207.160413.1238774755333289186.davem@davemloft.net>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
CC:     ast@kernel.org, daniel@iogearbox.net, tglx@linutronix.de
Subject: [RFC v1 PATCH 2/7] bpf: Add basic RT local locking for invocation
 of BPF programs.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 16:04:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


For now simply surround every invocation of BPF programs with a call
to the locking primitive.

The next step will be pulling the local lock out to the necessary
areas of the various call sites.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/filter.h | 23 ++++++++++++++++++++++-
 kernel/bpf/core.c      |  5 +++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1b1e8b8f88da..1f4a782b6184 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -21,6 +21,7 @@
 #include <linux/kallsyms.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/locallock.h>
 
 #include <net/sch_generic.h>
 
@@ -559,7 +560,20 @@ struct sk_filter {
 
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
-#define BPF_PROG_RUN(prog, ctx)	({				\
+#ifdef CONFIG_PREEMPT_RT_FULL
+DECLARE_LOCAL_IRQ_LOCK(bpf_invoke_lock);
+#define bpf_prog_lock() local_lock(bpf_invoke_lock)
+#define bpf_prog_unlock() local_unlock(bpf_invoke_lock)
+#else
+#define bpf_prog_lock() preempt_disable()
+#define bpf_prog_unlock() preempt_enable()
+#endif
+
+/* We cannot migrate off of the current cpu because BPF programs
+ * access per-cpu maps and other per-cpu data structures which are
+ * shared between BPF program execution and kernel execution.
+ */
+#define __BPF_PROG_RUN(prog, ctx)	({			\
 	u32 ret;						\
 	cant_sleep();						\
 	if (static_branch_unlikely(&bpf_stats_enabled_key)) {	\
@@ -576,6 +590,13 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 	}							\
 	ret; })
 
+#define BPF_PROG_RUN(prog, ctx)	({				\
+	u32 ret;						\
+	bpf_prog_lock();					\
+	ret = __BPF_PROG_RUN(prog, ctx);			\
+	bpf_prog_unlock();					\
+	ret; })
+
 #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN
 
 struct bpf_skb_data_end {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 49e32acad7d8..6e97bfb9f24a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2217,6 +2217,11 @@ int __weak bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 EXPORT_SYMBOL(bpf_stats_enabled_key);
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+DEFINE_LOCAL_IRQ_LOCK(bpf_invoke_lock);
+EXPORT_SYMBOL(bpf_invoke_lock);
+#endif
+
 /* All definitions of tracepoints related to BPF. */
 #define CREATE_TRACE_POINTS
 #include <linux/bpf_trace.h>
-- 
2.20.1

