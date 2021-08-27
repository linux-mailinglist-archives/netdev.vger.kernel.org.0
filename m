Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B536C3F97D1
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 12:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbhH0KGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 06:06:51 -0400
Received: from mx314.baidu.com ([180.101.52.172]:22001 "EHLO
        njjs-sys-mailin07.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244708AbhH0KGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 06:06:50 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2021 06:06:50 EDT
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin07.njjs.baidu.com (Postfix) with ESMTP id ED2BB19480062
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 17:57:53 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id C8EE8D9932
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 17:57:53 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][RFC] net: optimise rps IPI sending
Date:   Fri, 27 Aug 2021 17:57:53 +0800
Message-Id: <1630058273-2400-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In virtualization setup, IPI sending will cause vmexit,
and is expensive so it should be avoid to send IPI one
by one in highest throughput

smp_call_function_many maybe call PV ipi to send IPI to
many cpus once

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/netdevice.h  |  2 +-
 net/core/dev.c             | 32 +++++++++++++++++++++++++-------
 net/core/sysctl_net_core.c |  9 +++++++++
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bd8d5b8e2de3..ccf9e3e7c33d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4137,7 +4137,7 @@ void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev);
 
 extern int		netdev_budget;
 extern unsigned int	netdev_budget_usecs;
-
+extern unsigned int rps_pv_send_ipi __read_mostly;
 /* Called by rtnetlink.c:rtnl_unlock() */
 void netdev_run_todo(void);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 88650791c360..e839de51b555 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -203,6 +203,8 @@ static unsigned int napi_gen_id = NR_CPUS;
 static DEFINE_READ_MOSTLY_HASHTABLE(napi_hash, 8);
 
 static DECLARE_RWSEM(devnet_rename_sem);
+unsigned int rps_pv_send_ipi __read_mostly;
+static DEFINE_PER_CPU(cpumask_var_t, rps_ipi_mask);
 
 static inline void dev_base_seq_inc(struct net *net)
 {
@@ -4529,9 +4531,9 @@ EXPORT_SYMBOL(rps_may_expire_flow);
 #endif /* CONFIG_RFS_ACCEL */
 
 /* Called from hardirq (IPI) context */
-static void rps_trigger_softirq(void *data)
+static void rps_trigger_softirq(void *data __maybe_unused)
 {
-	struct softnet_data *sd = data;
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 
 	____napi_schedule(sd, &sd->backlog);
 	sd->received_rps++;
@@ -6364,12 +6366,26 @@ EXPORT_SYMBOL(__skb_gro_checksum_complete);
 static void net_rps_send_ipi(struct softnet_data *remsd)
 {
 #ifdef CONFIG_RPS
-	while (remsd) {
-		struct softnet_data *next = remsd->rps_ipi_next;
+	if (!rps_pv_send_ipi) {
+		while (remsd) {
+			struct softnet_data *next = remsd->rps_ipi_next;
+
+			if (cpu_online(remsd->cpu))
+				smp_call_function_single_async(remsd->cpu, &remsd->csd);
+			remsd = next;
+		}
+	} else {
+		struct cpumask *tmpmask = this_cpu_cpumask_var_ptr(rps_ipi_mask);
+
+		cpumask_clear(tmpmask);
+		while (remsd) {
+			struct softnet_data *next = remsd->rps_ipi_next;
 
-		if (cpu_online(remsd->cpu))
-			smp_call_function_single_async(remsd->cpu, &remsd->csd);
-		remsd = next;
+			if (cpu_online(remsd->cpu))
+				cpumask_set_cpu(remsd->cpu, tmpmask);
+			remsd = next;
+		}
+		smp_call_function_many(tmpmask, rps_trigger_softirq, NULL, false);
 	}
 #endif
 }
@@ -11627,6 +11643,8 @@ static int __init net_dev_init(void)
 #ifdef CONFIG_RPS
 		INIT_CSD(&sd->csd, rps_trigger_softirq, sd);
 		sd->cpu = i;
+		zalloc_cpumask_var_node(&per_cpu(rps_ipi_mask, i),
+			GFP_KERNEL, cpu_to_node(i));
 #endif
 
 		init_gro_hash(&sd->backlog);
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index c8496c1142c9..dc807841d7c6 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -377,6 +377,15 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_do_rss_key,
 	},
+	{
+		.procname	= "rps_pv_send_ipi",
+		.data		= &rps_pv_send_ipi,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 #ifdef CONFIG_BPF_JIT
 	{
 		.procname	= "bpf_jit_enable",
-- 
2.33.0.69.gc420321.dirty

