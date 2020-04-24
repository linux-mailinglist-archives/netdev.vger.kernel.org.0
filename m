Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E3C1B6E54
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 08:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgDXGn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 02:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726724AbgDXGn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 02:43:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC628C09B045;
        Thu, 23 Apr 2020 23:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1MergvVFLNiZNrv4L1m1fQzAhoWd9rYdl1ZrPeIZ4WM=; b=sVXoegtt473nL2/E0xsK5BCQDm
        DtpJBFjsQBuRud50XaDeGHSWIk6kpLX4jYPND/anQmlCIcQ/wzVm8lB1DB6fMtXXNwPxdMwft4MeK
        UP6yodiqT+0pGWIIC0PsWwI6LxDl+3Y17DQiaSrw8/fL7lHUIZQmmPJd7OafcS+b84dVIPv/JvYO/
        OWo3Iv53UBBGX6EyG3jDIm4EOF/Y9DLKJY/ukFihIVkf4Lo0NNKyKOVRr6wBrhpW7KmZs2dbWOhzr
        Fp+sFS0nxVzBtrvIhXTAIgca4T0CJPBtWFGsXbDv8md2LdcZS8prEX2Y8c6QRmBh+nolHjTmWKSuH
        zsx2E1uQ==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRs3z-00014y-Q9; Fri, 24 Apr 2020 06:43:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 4/5] sysctl: avoid forward declarations
Date:   Fri, 24 Apr 2020 08:43:37 +0200
Message-Id: <20200424064338.538313-5-hch@lst.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200424064338.538313-1-hch@lst.de>
References: <20200424064338.538313-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the sysctl tables to the end of the file to avoid lots of pointless
forward declarations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/sysctl.c | 3565 +++++++++++++++++++++++------------------------
 1 file changed, 1764 insertions(+), 1801 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 31b934865ebc3..511543d238794 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -176,79 +176,13 @@ enum sysctl_writes_mode {
 };
 
 static enum sysctl_writes_mode sysctl_writes_strict = SYSCTL_WRITES_STRICT;
-
-static int proc_do_cad_pid(struct ctl_table *table, int write,
-		  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int proc_taint(struct ctl_table *table, int write,
-			       void __user *buffer, size_t *lenp, loff_t *ppos);
-#ifdef CONFIG_COMPACTION
-static int proc_dointvec_minmax_warn_RT_change(struct ctl_table *table,
-					       int write, void __user *buffer,
-					       size_t *lenp, loff_t *ppos);
-#endif
-#endif
-
-#ifdef CONFIG_PRINTK
-static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos);
-#endif
-
-static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp, loff_t *ppos);
-#ifdef CONFIG_COREDUMP
-static int proc_dostring_coredump(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp, loff_t *ppos);
-#endif
-static int proc_dopipe_max_size(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp, loff_t *ppos);
-
-#ifdef CONFIG_MAGIC_SYSRQ
-static int sysrq_sysctl_handler(struct ctl_table *table, int write,
-			void __user *buffer, size_t *lenp, loff_t *ppos);
-#endif
-
-static struct ctl_table kern_table[];
-static struct ctl_table vm_table[];
-static struct ctl_table fs_table[];
-static struct ctl_table debug_table[];
-static struct ctl_table dev_table[];
+#endif /* CONFIG_PROC_SYSCTL */
 
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
     defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
 int sysctl_legacy_va_layout;
 #endif
 
-/* The default sysctl tables: */
-
-static struct ctl_table sysctl_base_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= kern_table,
-	},
-	{
-		.procname	= "vm",
-		.mode		= 0555,
-		.child		= vm_table,
-	},
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= fs_table,
-	},
-	{
-		.procname	= "debug",
-		.mode		= 0555,
-		.child		= debug_table,
-	},
-	{
-		.procname	= "dev",
-		.mode		= 0555,
-		.child		= dev_table,
-	},
-	{ }
-};
-
 #ifdef CONFIG_SCHED_DEBUG
 static int min_sched_granularity_ns = 100000;		/* 100 usecs */
 static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
@@ -265,1676 +199,12 @@ static int min_extfrag_threshold;
 static int max_extfrag_threshold = 1000;
 #endif
 
-static struct ctl_table kern_table[] = {
-	{
-		.procname	= "sched_child_runs_first",
-		.data		= &sysctl_sched_child_runs_first,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#ifdef CONFIG_SCHED_DEBUG
-	{
-		.procname	= "sched_min_granularity_ns",
-		.data		= &sysctl_sched_min_granularity,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_proc_update_handler,
-		.extra1		= &min_sched_granularity_ns,
-		.extra2		= &max_sched_granularity_ns,
-	},
-	{
-		.procname	= "sched_latency_ns",
-		.data		= &sysctl_sched_latency,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_proc_update_handler,
-		.extra1		= &min_sched_granularity_ns,
-		.extra2		= &max_sched_granularity_ns,
-	},
-	{
-		.procname	= "sched_wakeup_granularity_ns",
-		.data		= &sysctl_sched_wakeup_granularity,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_proc_update_handler,
-		.extra1		= &min_wakeup_granularity_ns,
-		.extra2		= &max_wakeup_granularity_ns,
-	},
-#ifdef CONFIG_SMP
-	{
-		.procname	= "sched_tunable_scaling",
-		.data		= &sysctl_sched_tunable_scaling,
-		.maxlen		= sizeof(enum sched_tunable_scaling),
-		.mode		= 0644,
-		.proc_handler	= sched_proc_update_handler,
-		.extra1		= &min_sched_tunable_scaling,
-		.extra2		= &max_sched_tunable_scaling,
-	},
-	{
-		.procname	= "sched_migration_cost_ns",
-		.data		= &sysctl_sched_migration_cost,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "sched_nr_migrate",
-		.data		= &sysctl_sched_nr_migrate,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#ifdef CONFIG_SCHEDSTATS
-	{
-		.procname	= "sched_schedstats",
-		.data		= NULL,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sysctl_schedstats,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SCHEDSTATS */
-#endif /* CONFIG_SMP */
-#ifdef CONFIG_NUMA_BALANCING
-	{
-		.procname	= "numa_balancing_scan_delay_ms",
-		.data		= &sysctl_numa_balancing_scan_delay,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "numa_balancing_scan_period_min_ms",
-		.data		= &sysctl_numa_balancing_scan_period_min,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "numa_balancing_scan_period_max_ms",
-		.data		= &sysctl_numa_balancing_scan_period_max,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "numa_balancing_scan_size_mb",
-		.data		= &sysctl_numa_balancing_scan_size,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "numa_balancing",
-		.data		= NULL, /* filled in by handler */
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sysctl_numa_balancing,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_NUMA_BALANCING */
-#endif /* CONFIG_SCHED_DEBUG */
-	{
-		.procname	= "sched_rt_period_us",
-		.data		= &sysctl_sched_rt_period,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_rt_handler,
-	},
-	{
-		.procname	= "sched_rt_runtime_us",
-		.data		= &sysctl_sched_rt_runtime,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= sched_rt_handler,
-	},
-	{
-		.procname	= "sched_rr_timeslice_ms",
-		.data		= &sysctl_sched_rr_timeslice,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= sched_rr_handler,
-	},
-#ifdef CONFIG_UCLAMP_TASK
-	{
-		.procname	= "sched_util_clamp_min",
-		.data		= &sysctl_sched_uclamp_util_min,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sysctl_sched_uclamp_handler,
-	},
-	{
-		.procname	= "sched_util_clamp_max",
-		.data		= &sysctl_sched_uclamp_util_max,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sysctl_sched_uclamp_handler,
-	},
-#endif
-#ifdef CONFIG_SCHED_AUTOGROUP
-	{
-		.procname	= "sched_autogroup_enabled",
-		.data		= &sysctl_sched_autogroup_enabled,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_CFS_BANDWIDTH
-	{
-		.procname	= "sched_cfs_bandwidth_slice_us",
-		.data		= &sysctl_sched_cfs_bandwidth_slice,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-	},
-#endif
-#if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_CPU_FREQ_GOV_SCHEDUTIL)
-	{
-		.procname	= "sched_energy_aware",
-		.data		= &sysctl_sched_energy_aware,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_energy_aware_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_PROVE_LOCKING
-	{
-		.procname	= "prove_locking",
-		.data		= &prove_locking,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_LOCK_STAT
-	{
-		.procname	= "lock_stat",
-		.data		= &lock_stat,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-	{
-		.procname	= "panic",
-		.data		= &panic_timeout,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#ifdef CONFIG_COREDUMP
-	{
-		.procname	= "core_uses_pid",
-		.data		= &core_uses_pid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "core_pattern",
-		.data		= core_pattern,
-		.maxlen		= CORENAME_MAX_SIZE,
-		.mode		= 0644,
-		.proc_handler	= proc_dostring_coredump,
-	},
-	{
-		.procname	= "core_pipe_limit",
-		.data		= &core_pipe_limit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_PROC_SYSCTL
-	{
-		.procname	= "tainted",
-		.maxlen 	= sizeof(long),
-		.mode		= 0644,
-		.proc_handler	= proc_taint,
-	},
-	{
-		.procname	= "sysctl_writes_strict",
-		.data		= &sysctl_writes_strict,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &neg_one,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_LATENCYTOP
-	{
-		.procname	= "latencytop",
-		.data		= &latencytop_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= sysctl_latencytop,
-	},
-#endif
-#ifdef CONFIG_BLK_DEV_INITRD
-	{
-		.procname	= "real-root-dev",
-		.data		= &real_root_dev,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-	{
-		.procname	= "print-fatal-signals",
-		.data		= &print_fatal_signals,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#ifdef CONFIG_SPARC
-	{
-		.procname	= "reboot-cmd",
-		.data		= reboot_command,
-		.maxlen		= 256,
-		.mode		= 0644,
-		.proc_handler	= proc_dostring,
-	},
-	{
-		.procname	= "stop-a",
-		.data		= &stop_a_enabled,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "scons-poweroff",
-		.data		= &scons_pwroff,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_SPARC64
-	{
-		.procname	= "tsb-ratio",
-		.data		= &sysctl_tsb_ratio,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_PARISC
-	{
-		.procname	= "soft-power",
-		.data		= &pwrsw_enabled,
-		.maxlen		= sizeof (int),
-	 	.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
-	{
-		.procname	= "unaligned-trap",
-		.data		= &unaligned_enabled,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-	{
-		.procname	= "ctrl-alt-del",
-		.data		= &C_A_D,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#ifdef CONFIG_FUNCTION_TRACER
-	{
-		.procname	= "ftrace_enabled",
-		.data		= &ftrace_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= ftrace_enable_sysctl,
-	},
-#endif
-#ifdef CONFIG_STACK_TRACER
-	{
-		.procname	= "stack_tracer_enabled",
-		.data		= &stack_tracer_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= stack_trace_sysctl,
-	},
-#endif
-#ifdef CONFIG_TRACING
-	{
-		.procname	= "ftrace_dump_on_oops",
-		.data		= &ftrace_dump_on_oops,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "traceoff_on_warning",
-		.data		= &__disable_trace_on_warning,
-		.maxlen		= sizeof(__disable_trace_on_warning),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "tracepoint_printk",
-		.data		= &tracepoint_printk,
-		.maxlen		= sizeof(tracepoint_printk),
-		.mode		= 0644,
-		.proc_handler	= tracepoint_printk_sysctl,
-	},
-#endif
-#ifdef CONFIG_KEXEC_CORE
-	{
-		.procname	= "kexec_load_disabled",
-		.data		= &kexec_load_disabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_MODULES
-	{
-		.procname	= "modprobe",
-		.data		= &modprobe_path,
-		.maxlen		= KMOD_PATH_LEN,
-		.mode		= 0644,
-		.proc_handler	= proc_dostring,
-	},
-	{
-		.procname	= "modules_disabled",
-		.data		= &modules_disabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_UEVENT_HELPER
-	{
-		.procname	= "hotplug",
-		.data		= &uevent_helper,
-		.maxlen		= UEVENT_HELPER_PATH_LEN,
-		.mode		= 0644,
-		.proc_handler	= proc_dostring,
-	},
-#endif
-#ifdef CONFIG_CHR_DEV_SG
-	{
-		.procname	= "sg-big-buff",
-		.data		= &sg_big_buff,
-		.maxlen		= sizeof (int),
-		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_BSD_PROCESS_ACCT
-	{
-		.procname	= "acct",
-		.data		= &acct_parm,
-		.maxlen		= 3*sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_MAGIC_SYSRQ
-	{
-		.procname	= "sysrq",
-		.data		= NULL,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= sysrq_sysctl_handler,
-	},
-#endif
-#ifdef CONFIG_PROC_SYSCTL
-	{
-		.procname	= "cad_pid",
-		.data		= NULL,
-		.maxlen		= sizeof (int),
-		.mode		= 0600,
-		.proc_handler	= proc_do_cad_pid,
-	},
-#endif
-	{
-		.procname	= "threads-max",
-		.data		= NULL,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= sysctl_max_threads,
-	},
-	{
-		.procname	= "random",
-		.mode		= 0555,
-		.child		= random_table,
-	},
-	{
-		.procname	= "usermodehelper",
-		.mode		= 0555,
-		.child		= usermodehelper_table,
-	},
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-	{
-		.procname	= "firmware_config",
-		.mode		= 0555,
-		.child		= firmware_config_table,
-	},
-#endif
-	{
-		.procname	= "overflowuid",
-		.data		= &overflowuid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
-	},
-	{
-		.procname	= "overflowgid",
-		.data		= &overflowgid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
-	},
-#ifdef CONFIG_S390
-	{
-		.procname	= "userprocess_debug",
-		.data		= &show_unhandled_signals,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-	{
-		.procname	= "pid_max",
-		.data		= &pid_max,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &pid_max_min,
-		.extra2		= &pid_max_max,
-	},
-	{
-		.procname	= "panic_on_oops",
-		.data		= &panic_on_oops,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "panic_print",
-		.data		= &panic_print,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-#if defined CONFIG_PRINTK
-	{
-		.procname	= "printk",
-		.data		= &console_loglevel,
-		.maxlen		= 4*sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "printk_ratelimit",
-		.data		= &printk_ratelimit_state.interval,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "printk_ratelimit_burst",
-		.data		= &printk_ratelimit_state.burst,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "printk_delay",
-		.data		= &printk_delay_msec,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &ten_thousand,
-	},
-	{
-		.procname	= "printk_devkmsg",
-		.data		= devkmsg_log_str,
-		.maxlen		= DEVKMSG_STR_MAX_SIZE,
-		.mode		= 0644,
-		.proc_handler	= devkmsg_sysctl_set_loglvl,
-	},
-	{
-		.procname	= "dmesg_restrict",
-		.data		= &dmesg_restrict,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_sysadmin,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "kptr_restrict",
-		.data		= &kptr_restrict,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_sysadmin,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
-	},
-#endif
-	{
-		.procname	= "ngroups_max",
-		.data		= &ngroups_max,
-		.maxlen		= sizeof (int),
-		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "cap_last_cap",
-		.data		= (void *)&cap_last_cap,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
-	},
-#if defined(CONFIG_LOCKUP_DETECTOR)
-	{
-		.procname       = "watchdog",
-		.data		= &watchdog_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler   = proc_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "watchdog_thresh",
-		.data		= &watchdog_thresh,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_watchdog_thresh,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &sixty,
-	},
-	{
-		.procname       = "nmi_watchdog",
-		.data		= &nmi_watchdog_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= NMI_WATCHDOG_SYSCTL_PERM,
-		.proc_handler   = proc_nmi_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "watchdog_cpumask",
-		.data		= &watchdog_cpumask_bits,
-		.maxlen		= NR_CPUS,
-		.mode		= 0644,
-		.proc_handler	= proc_watchdog_cpumask,
-	},
-#ifdef CONFIG_SOFTLOCKUP_DETECTOR
-	{
-		.procname       = "soft_watchdog",
-		.data		= &soft_watchdog_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler   = proc_soft_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "softlockup_panic",
-		.data		= &softlockup_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#ifdef CONFIG_SMP
-	{
-		.procname	= "softlockup_all_cpu_backtrace",
-		.data		= &sysctl_softlockup_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
-#endif
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
-	{
-		.procname	= "hardlockup_panic",
-		.data		= &hardlockup_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#ifdef CONFIG_SMP
-	{
-		.procname	= "hardlockup_all_cpu_backtrace",
-		.data		= &sysctl_hardlockup_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
-#endif
-#endif
-
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
-	{
-		.procname       = "unknown_nmi_panic",
-		.data           = &unknown_nmi_panic,
-		.maxlen         = sizeof (int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
-#endif
-#if defined(CONFIG_X86)
-	{
-		.procname	= "panic_on_unrecovered_nmi",
-		.data		= &panic_on_unrecovered_nmi,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "panic_on_io_nmi",
-		.data		= &panic_on_io_nmi,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
-	{
-		.procname	= "panic_on_stackoverflow",
-		.data		= &sysctl_panic_on_stackoverflow,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-	{
-		.procname	= "bootloader_type",
-		.data		= &bootloader_type,
-		.maxlen		= sizeof (int),
-		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "bootloader_version",
-		.data		= &bootloader_version,
-		.maxlen		= sizeof (int),
-		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "io_delay_type",
-		.data		= &io_delay_type,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#if defined(CONFIG_MMU)
-	{
-		.procname	= "randomize_va_space",
-		.data		= &randomize_va_space,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#if defined(CONFIG_S390) && defined(CONFIG_SMP)
-	{
-		.procname	= "spin_retry",
-		.data		= &spin_retry,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
-	{
-		.procname	= "acpi_video_flags",
-		.data		= &acpi_realmode_flags,
-		.maxlen		= sizeof (unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-#endif
-#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
-	{
-		.procname	= "ignore-unaligned-usertrap",
-		.data		= &no_unaligned_warning,
-		.maxlen		= sizeof (int),
-	 	.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_IA64
-	{
-		.procname	= "unaligned-dump-stack",
-		.data		= &unaligned_dump_stack,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_DETECT_HUNG_TASK
-	{
-		.procname	= "hung_task_panic",
-		.data		= &sysctl_hung_task_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "hung_task_check_count",
-		.data		= &sysctl_hung_task_check_count,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "hung_task_timeout_secs",
-		.data		= &sysctl_hung_task_timeout_secs,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_dohung_task_timeout_secs,
-		.extra2		= &hung_task_timeout_max,
-	},
-	{
-		.procname	= "hung_task_check_interval_secs",
-		.data		= &sysctl_hung_task_check_interval_secs,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_dohung_task_timeout_secs,
-		.extra2		= &hung_task_timeout_max,
-	},
-	{
-		.procname	= "hung_task_warnings",
-		.data		= &sysctl_hung_task_warnings,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &neg_one,
-	},
-#endif
-#ifdef CONFIG_RT_MUTEXES
-	{
-		.procname	= "max_lock_depth",
-		.data		= &max_lock_depth,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-	{
-		.procname	= "poweroff_cmd",
-		.data		= &poweroff_cmd,
-		.maxlen		= POWEROFF_CMD_PATH_LEN,
-		.mode		= 0644,
-		.proc_handler	= proc_dostring,
-	},
-#ifdef CONFIG_KEYS
-	{
-		.procname	= "keys",
-		.mode		= 0555,
-		.child		= key_sysctls,
-	},
-#endif
-#ifdef CONFIG_PERF_EVENTS
-	/*
-	 * User-space scripts rely on the existence of this file
-	 * as a feature check for perf_events being enabled.
-	 *
-	 * So it's an ABI, do not remove!
-	 */
-	{
-		.procname	= "perf_event_paranoid",
-		.data		= &sysctl_perf_event_paranoid,
-		.maxlen		= sizeof(sysctl_perf_event_paranoid),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "perf_event_mlock_kb",
-		.data		= &sysctl_perf_event_mlock,
-		.maxlen		= sizeof(sysctl_perf_event_mlock),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "perf_event_max_sample_rate",
-		.data		= &sysctl_perf_event_sample_rate,
-		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
-		.mode		= 0644,
-		.proc_handler	= perf_proc_update_handler,
-		.extra1		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "perf_cpu_time_max_percent",
-		.data		= &sysctl_perf_cpu_time_max_percent,
-		.maxlen		= sizeof(sysctl_perf_cpu_time_max_percent),
-		.mode		= 0644,
-		.proc_handler	= perf_cpu_time_max_percent_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
-	},
-	{
-		.procname	= "perf_event_max_stack",
-		.data		= &sysctl_perf_event_max_stack,
-		.maxlen		= sizeof(sysctl_perf_event_max_stack),
-		.mode		= 0644,
-		.proc_handler	= perf_event_max_stack_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &six_hundred_forty_kb,
-	},
-	{
-		.procname	= "perf_event_max_contexts_per_stack",
-		.data		= &sysctl_perf_event_max_contexts_per_stack,
-		.maxlen		= sizeof(sysctl_perf_event_max_contexts_per_stack),
-		.mode		= 0644,
-		.proc_handler	= perf_event_max_stack_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_thousand,
-	},
-#endif
-	{
-		.procname	= "panic_on_warn",
-		.data		= &panic_on_warn,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
-	{
-		.procname	= "timer_migration",
-		.data		= &sysctl_timer_migration,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= timer_migration_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_BPF_SYSCALL
-	{
-		.procname	= "unprivileged_bpf_disabled",
-		.data		= &sysctl_unprivileged_bpf_disabled,
-		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
-		.mode		= 0644,
-		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "bpf_stats_enabled",
-		.data		= &bpf_stats_enabled_key.key,
-		.maxlen		= sizeof(bpf_stats_enabled_key),
-		.mode		= 0644,
-		.proc_handler	= proc_do_static_key,
-	},
-#endif
-#if defined(CONFIG_TREE_RCU)
-	{
-		.procname	= "panic_on_rcu_stall",
-		.data		= &sysctl_panic_on_rcu_stall,
-		.maxlen		= sizeof(sysctl_panic_on_rcu_stall),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
-	{
-		.procname	= "stack_erasing",
-		.data		= NULL,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= stack_erasing_sysctl,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-	{ }
-};
-
-static struct ctl_table vm_table[] = {
-	{
-		.procname	= "overcommit_memory",
-		.data		= &sysctl_overcommit_memory,
-		.maxlen		= sizeof(sysctl_overcommit_memory),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
-	},
-	{
-		.procname	= "panic_on_oom",
-		.data		= &sysctl_panic_on_oom,
-		.maxlen		= sizeof(sysctl_panic_on_oom),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
-	},
-	{
-		.procname	= "oom_kill_allocating_task",
-		.data		= &sysctl_oom_kill_allocating_task,
-		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "oom_dump_tasks",
-		.data		= &sysctl_oom_dump_tasks,
-		.maxlen		= sizeof(sysctl_oom_dump_tasks),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "overcommit_ratio",
-		.data		= &sysctl_overcommit_ratio,
-		.maxlen		= sizeof(sysctl_overcommit_ratio),
-		.mode		= 0644,
-		.proc_handler	= overcommit_ratio_handler,
-	},
-	{
-		.procname	= "overcommit_kbytes",
-		.data		= &sysctl_overcommit_kbytes,
-		.maxlen		= sizeof(sysctl_overcommit_kbytes),
-		.mode		= 0644,
-		.proc_handler	= overcommit_kbytes_handler,
-	},
-	{
-		.procname	= "page-cluster", 
-		.data		= &page_cluster,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "dirty_background_ratio",
-		.data		= &dirty_background_ratio,
-		.maxlen		= sizeof(dirty_background_ratio),
-		.mode		= 0644,
-		.proc_handler	= dirty_background_ratio_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
-	},
-	{
-		.procname	= "dirty_background_bytes",
-		.data		= &dirty_background_bytes,
-		.maxlen		= sizeof(dirty_background_bytes),
-		.mode		= 0644,
-		.proc_handler	= dirty_background_bytes_handler,
-		.extra1		= &one_ul,
-	},
-	{
-		.procname	= "dirty_ratio",
-		.data		= &vm_dirty_ratio,
-		.maxlen		= sizeof(vm_dirty_ratio),
-		.mode		= 0644,
-		.proc_handler	= dirty_ratio_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
-	},
-	{
-		.procname	= "dirty_bytes",
-		.data		= &vm_dirty_bytes,
-		.maxlen		= sizeof(vm_dirty_bytes),
-		.mode		= 0644,
-		.proc_handler	= dirty_bytes_handler,
-		.extra1		= &dirty_bytes_min,
-	},
-	{
-		.procname	= "dirty_writeback_centisecs",
-		.data		= &dirty_writeback_interval,
-		.maxlen		= sizeof(dirty_writeback_interval),
-		.mode		= 0644,
-		.proc_handler	= dirty_writeback_centisecs_handler,
-	},
-	{
-		.procname	= "dirty_expire_centisecs",
-		.data		= &dirty_expire_interval,
-		.maxlen		= sizeof(dirty_expire_interval),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "dirtytime_expire_seconds",
-		.data		= &dirtytime_expire_interval,
-		.maxlen		= sizeof(dirtytime_expire_interval),
-		.mode		= 0644,
-		.proc_handler	= dirtytime_interval_handler,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "swappiness",
-		.data		= &vm_swappiness,
-		.maxlen		= sizeof(vm_swappiness),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
-	},
-#ifdef CONFIG_HUGETLB_PAGE
-	{
-		.procname	= "nr_hugepages",
-		.data		= NULL,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= hugetlb_sysctl_handler,
-	},
-#ifdef CONFIG_NUMA
-	{
-		.procname       = "nr_hugepages_mempolicy",
-		.data           = NULL,
-		.maxlen         = sizeof(unsigned long),
-		.mode           = 0644,
-		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-	},
-	{
-		.procname		= "numa_stat",
-		.data			= &sysctl_vm_numa_stat,
-		.maxlen			= sizeof(int),
-		.mode			= 0644,
-		.proc_handler	= sysctl_vm_numa_stat_handler,
-		.extra1			= SYSCTL_ZERO,
-		.extra2			= SYSCTL_ONE,
-	},
-#endif
-	 {
-		.procname	= "hugetlb_shm_group",
-		.data		= &sysctl_hugetlb_shm_group,
-		.maxlen		= sizeof(gid_t),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	 },
-	{
-		.procname	= "nr_overcommit_hugepages",
-		.data		= NULL,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= hugetlb_overcommit_handler,
-	},
-#endif
-	{
-		.procname	= "lowmem_reserve_ratio",
-		.data		= &sysctl_lowmem_reserve_ratio,
-		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
-		.mode		= 0644,
-		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
-	},
-	{
-		.procname	= "drop_caches",
-		.data		= &sysctl_drop_caches,
-		.maxlen		= sizeof(int),
-		.mode		= 0200,
-		.proc_handler	= drop_caches_sysctl_handler,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= &four,
-	},
-#ifdef CONFIG_COMPACTION
-	{
-		.procname	= "compact_memory",
-		.data		= &sysctl_compact_memory,
-		.maxlen		= sizeof(int),
-		.mode		= 0200,
-		.proc_handler	= sysctl_compaction_handler,
-	},
-	{
-		.procname	= "extfrag_threshold",
-		.data		= &sysctl_extfrag_threshold,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_extfrag_threshold,
-		.extra2		= &max_extfrag_threshold,
-	},
-	{
-		.procname	= "compact_unevictable_allowed",
-		.data		= &sysctl_compact_unevictable_allowed,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_warn_RT_change,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-
-#endif /* CONFIG_COMPACTION */
-	{
-		.procname	= "min_free_kbytes",
-		.data		= &min_free_kbytes,
-		.maxlen		= sizeof(min_free_kbytes),
-		.mode		= 0644,
-		.proc_handler	= min_free_kbytes_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "watermark_boost_factor",
-		.data		= &watermark_boost_factor,
-		.maxlen		= sizeof(watermark_boost_factor),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "watermark_scale_factor",
-		.data		= &watermark_scale_factor,
-		.maxlen		= sizeof(watermark_scale_factor),
-		.mode		= 0644,
-		.proc_handler	= watermark_scale_factor_sysctl_handler,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= &one_thousand,
-	},
-	{
-		.procname	= "percpu_pagelist_fraction",
-		.data		= &percpu_pagelist_fraction,
-		.maxlen		= sizeof(percpu_pagelist_fraction),
-		.mode		= 0644,
-		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-	},
-#ifdef CONFIG_MMU
-	{
-		.procname	= "max_map_count",
-		.data		= &sysctl_max_map_count,
-		.maxlen		= sizeof(sysctl_max_map_count),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-#else
-	{
-		.procname	= "nr_trim_pages",
-		.data		= &sysctl_nr_trim_pages,
-		.maxlen		= sizeof(sysctl_nr_trim_pages),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-#endif
-	{
-		.procname	= "laptop_mode",
-		.data		= &laptop_mode,
-		.maxlen		= sizeof(laptop_mode),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "block_dump",
-		.data		= &block_dump,
-		.maxlen		= sizeof(block_dump),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "vfs_cache_pressure",
-		.data		= &sysctl_vfs_cache_pressure,
-		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= SYSCTL_ZERO,
-	},
-#if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
-    defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
-	{
-		.procname	= "legacy_va_layout",
-		.data		= &sysctl_legacy_va_layout,
-		.maxlen		= sizeof(sysctl_legacy_va_layout),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= SYSCTL_ZERO,
-	},
-#endif
-#ifdef CONFIG_NUMA
-	{
-		.procname	= "zone_reclaim_mode",
-		.data		= &node_reclaim_mode,
-		.maxlen		= sizeof(node_reclaim_mode),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "min_unmapped_ratio",
-		.data		= &sysctl_min_unmapped_ratio,
-		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
-		.mode		= 0644,
-		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
-	},
-	{
-		.procname	= "min_slab_ratio",
-		.data		= &sysctl_min_slab_ratio,
-		.maxlen		= sizeof(sysctl_min_slab_ratio),
-		.mode		= 0644,
-		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
-	},
-#endif
-#ifdef CONFIG_SMP
-	{
-		.procname	= "stat_interval",
-		.data		= &sysctl_stat_interval,
-		.maxlen		= sizeof(sysctl_stat_interval),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "stat_refresh",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0600,
-		.proc_handler	= vmstat_refresh,
-	},
-#endif
-#ifdef CONFIG_MMU
-	{
-		.procname	= "mmap_min_addr",
-		.data		= &dac_mmap_min_addr,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= mmap_min_addr_handler,
-	},
-#endif
-#ifdef CONFIG_NUMA
-	{
-		.procname	= "numa_zonelist_order",
-		.data		= &numa_zonelist_order,
-		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
-		.mode		= 0644,
-		.proc_handler	= numa_zonelist_order_handler,
-	},
-#endif
-#if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
-   (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
-	{
-		.procname	= "vdso_enabled",
-#ifdef CONFIG_X86_32
-		.data		= &vdso32_enabled,
-		.maxlen		= sizeof(vdso32_enabled),
-#else
-		.data		= &vdso_enabled,
-		.maxlen		= sizeof(vdso_enabled),
-#endif
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= SYSCTL_ZERO,
-	},
-#endif
-#ifdef CONFIG_HIGHMEM
-	{
-		.procname	= "highmem_is_dirtyable",
-		.data		= &vm_highmem_is_dirtyable,
-		.maxlen		= sizeof(vm_highmem_is_dirtyable),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-#ifdef CONFIG_MEMORY_FAILURE
-	{
-		.procname	= "memory_failure_early_kill",
-		.data		= &sysctl_memory_failure_early_kill,
-		.maxlen		= sizeof(sysctl_memory_failure_early_kill),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "memory_failure_recovery",
-		.data		= &sysctl_memory_failure_recovery,
-		.maxlen		= sizeof(sysctl_memory_failure_recovery),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-	{
-		.procname	= "user_reserve_kbytes",
-		.data		= &sysctl_user_reserve_kbytes,
-		.maxlen		= sizeof(sysctl_user_reserve_kbytes),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "admin_reserve_kbytes",
-		.data		= &sysctl_admin_reserve_kbytes,
-		.maxlen		= sizeof(sysctl_admin_reserve_kbytes),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-#ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
-	{
-		.procname	= "mmap_rnd_bits",
-		.data		= &mmap_rnd_bits,
-		.maxlen		= sizeof(mmap_rnd_bits),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&mmap_rnd_bits_min,
-		.extra2		= (void *)&mmap_rnd_bits_max,
-	},
-#endif
-#ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
-	{
-		.procname	= "mmap_rnd_compat_bits",
-		.data		= &mmap_rnd_compat_bits,
-		.maxlen		= sizeof(mmap_rnd_compat_bits),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&mmap_rnd_compat_bits_min,
-		.extra2		= (void *)&mmap_rnd_compat_bits_max,
-	},
-#endif
-#ifdef CONFIG_USERFAULTFD
-	{
-		.procname	= "unprivileged_userfaultfd",
-		.data		= &sysctl_unprivileged_userfaultfd,
-		.maxlen		= sizeof(sysctl_unprivileged_userfaultfd),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-	{ }
-};
-
-static struct ctl_table fs_table[] = {
-	{
-		.procname	= "inode-nr",
-		.data		= &inodes_stat,
-		.maxlen		= 2*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_inodes,
-	},
-	{
-		.procname	= "inode-state",
-		.data		= &inodes_stat,
-		.maxlen		= 7*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_inodes,
-	},
-	{
-		.procname	= "file-nr",
-		.data		= &files_stat,
-		.maxlen		= sizeof(files_stat),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_files,
-	},
-	{
-		.procname	= "file-max",
-		.data		= &files_stat.max_files,
-		.maxlen		= sizeof(files_stat.max_files),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &zero_ul,
-		.extra2		= &long_max,
-	},
-	{
-		.procname	= "nr_open",
-		.data		= &sysctl_nr_open,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &sysctl_nr_open_min,
-		.extra2		= &sysctl_nr_open_max,
-	},
-	{
-		.procname	= "dentry-state",
-		.data		= &dentry_stat,
-		.maxlen		= 6*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_dentry,
-	},
-	{
-		.procname	= "overflowuid",
-		.data		= &fs_overflowuid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
-	},
-	{
-		.procname	= "overflowgid",
-		.data		= &fs_overflowgid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
-	},
-#ifdef CONFIG_FILE_LOCKING
-	{
-		.procname	= "leases-enable",
-		.data		= &leases_enable,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_DNOTIFY
-	{
-		.procname	= "dir-notify-enable",
-		.data		= &dir_notify_enable,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_MMU
-#ifdef CONFIG_FILE_LOCKING
-	{
-		.procname	= "lease-break-time",
-		.data		= &lease_break_time,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_AIO
-	{
-		.procname	= "aio-nr",
-		.data		= &aio_nr,
-		.maxlen		= sizeof(aio_nr),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "aio-max-nr",
-		.data		= &aio_max_nr,
-		.maxlen		= sizeof(aio_max_nr),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-#endif /* CONFIG_AIO */
-#ifdef CONFIG_INOTIFY_USER
-	{
-		.procname	= "inotify",
-		.mode		= 0555,
-		.child		= inotify_table,
-	},
-#endif	
-#ifdef CONFIG_EPOLL
-	{
-		.procname	= "epoll",
-		.mode		= 0555,
-		.child		= epoll_table,
-	},
-#endif
-#endif
-	{
-		.procname	= "protected_symlinks",
-		.data		= &sysctl_protected_symlinks,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "protected_hardlinks",
-		.data		= &sysctl_protected_hardlinks,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "protected_fifos",
-		.data		= &sysctl_protected_fifos,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
-	},
-	{
-		.procname	= "protected_regular",
-		.data		= &sysctl_protected_regular,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
-	},
-	{
-		.procname	= "suid_dumpable",
-		.data		= &suid_dumpable,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_coredump,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
-	},
-#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
-	{
-		.procname	= "binfmt_misc",
-		.mode		= 0555,
-		.child		= sysctl_mount_point,
-	},
-#endif
-	{
-		.procname	= "pipe-max-size",
-		.data		= &pipe_max_size,
-		.maxlen		= sizeof(pipe_max_size),
-		.mode		= 0644,
-		.proc_handler	= proc_dopipe_max_size,
-	},
-	{
-		.procname	= "pipe-user-pages-hard",
-		.data		= &pipe_user_pages_hard,
-		.maxlen		= sizeof(pipe_user_pages_hard),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "pipe-user-pages-soft",
-		.data		= &pipe_user_pages_soft,
-		.maxlen		= sizeof(pipe_user_pages_soft),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "mount-max",
-		.data		= &sysctl_mount_max,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-	},
-	{ }
-};
-
-static struct ctl_table debug_table[] = {
-#ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
-	{
-		.procname	= "exception-trace",
-		.data		= &show_unhandled_signals,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
-#endif
-#if defined(CONFIG_OPTPROBES)
-	{
-		.procname	= "kprobes-optimization",
-		.data		= &sysctl_kprobes_optimization,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_kprobes_optimization_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
-	{ }
-};
-
-static struct ctl_table dev_table[] = {
-	{ }
-};
-
-int __init sysctl_init(void)
-{
-	struct ctl_table_header *hdr;
-
-	hdr = register_sysctl_table(sysctl_base_table);
-	kmemleak_not_leak(hdr);
-	return 0;
-}
-
-#endif /* CONFIG_SYSCTL */
-
-/*
- * /proc/sys support
- */
-
+#endif /* CONFIG_SYSCTL */
+
+/*
+ * /proc/sys support
+ */
+
 #ifdef CONFIG_PROC_SYSCTL
 
 static int _proc_do_string(char *data, int maxlen, int write,
@@ -3307,95 +1577,1788 @@ int proc_dointvec(struct ctl_table *table, int write,
 	return -ENOSYS;
 }
 
-int proc_douintvec(struct ctl_table *table, int write,
-		  void __user *buffer, size_t *lenp, loff_t *ppos)
+int proc_douintvec(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_minmax(struct ctl_table *table, int write,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_douintvec_minmax(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_jiffies(struct ctl_table *table, int write,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_ms_jiffies(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_minmax(struct ctl_table *table, int write,
+int proc_doulongvec_minmax(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_douintvec_minmax(struct ctl_table *table, int write,
-			  void __user *buffer, size_t *lenp, loff_t *ppos)
+int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
+				      void __user *buffer,
+				      size_t *lenp, loff_t *ppos)
 {
-	return -ENOSYS;
+    return -ENOSYS;
 }
 
-int proc_dointvec_jiffies(struct ctl_table *table, int write,
-		    void __user *buffer, size_t *lenp, loff_t *ppos)
+int proc_do_large_bitmap(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
 
-int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
-		    void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
+#endif /* CONFIG_PROC_SYSCTL */
+
+#if defined(CONFIG_SYSCTL)
+int proc_do_static_key(struct ctl_table *table, int write,
+		       void __user *buffer, size_t *lenp,
+		       loff_t *ppos)
+{
+	struct static_key *key = (struct static_key *)table->data;
+	static DEFINE_MUTEX(static_key_mutex);
+	int val, ret;
+	struct ctl_table tmp = {
+		.data   = &val,
+		.maxlen = sizeof(val),
+		.mode   = table->mode,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&static_key_mutex);
+	val = static_key_enabled(key);
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret) {
+		if (val)
+			static_key_enable(key);
+		else
+			static_key_disable(key);
+	}
+	mutex_unlock(&static_key_mutex);
+	return ret;
+}
+
+static struct ctl_table kern_table[] = {
+	{
+		.procname	= "sched_child_runs_first",
+		.data		= &sysctl_sched_child_runs_first,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#ifdef CONFIG_SCHED_DEBUG
+	{
+		.procname	= "sched_min_granularity_ns",
+		.data		= &sysctl_sched_min_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_proc_update_handler,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
+	},
+	{
+		.procname	= "sched_latency_ns",
+		.data		= &sysctl_sched_latency,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_proc_update_handler,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
+	},
+	{
+		.procname	= "sched_wakeup_granularity_ns",
+		.data		= &sysctl_sched_wakeup_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_proc_update_handler,
+		.extra1		= &min_wakeup_granularity_ns,
+		.extra2		= &max_wakeup_granularity_ns,
+	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "sched_tunable_scaling",
+		.data		= &sysctl_sched_tunable_scaling,
+		.maxlen		= sizeof(enum sched_tunable_scaling),
+		.mode		= 0644,
+		.proc_handler	= sched_proc_update_handler,
+		.extra1		= &min_sched_tunable_scaling,
+		.extra2		= &max_sched_tunable_scaling,
+	},
+	{
+		.procname	= "sched_migration_cost_ns",
+		.data		= &sysctl_sched_migration_cost,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_nr_migrate",
+		.data		= &sysctl_sched_nr_migrate,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#ifdef CONFIG_SCHEDSTATS
+	{
+		.procname	= "sched_schedstats",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_schedstats,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SCHEDSTATS */
+#endif /* CONFIG_SMP */
+#ifdef CONFIG_NUMA_BALANCING
+	{
+		.procname	= "numa_balancing_scan_delay_ms",
+		.data		= &sysctl_numa_balancing_scan_delay,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "numa_balancing_scan_period_min_ms",
+		.data		= &sysctl_numa_balancing_scan_period_min,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "numa_balancing_scan_period_max_ms",
+		.data		= &sysctl_numa_balancing_scan_period_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "numa_balancing_scan_size_mb",
+		.data		= &sysctl_numa_balancing_scan_size,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "numa_balancing",
+		.data		= NULL, /* filled in by handler */
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_numa_balancing,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_SCHED_DEBUG */
+	{
+		.procname	= "sched_rt_period_us",
+		.data		= &sysctl_sched_rt_period,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_rt_handler,
+	},
+	{
+		.procname	= "sched_rt_runtime_us",
+		.data		= &sysctl_sched_rt_runtime,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sched_rt_handler,
+	},
+	{
+		.procname	= "sched_rr_timeslice_ms",
+		.data		= &sysctl_sched_rr_timeslice,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sched_rr_handler,
+	},
+#ifdef CONFIG_UCLAMP_TASK
+	{
+		.procname	= "sched_util_clamp_min",
+		.data		= &sysctl_sched_uclamp_util_min,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sched_uclamp_handler,
+	},
+	{
+		.procname	= "sched_util_clamp_max",
+		.data		= &sysctl_sched_uclamp_util_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sched_uclamp_handler,
+	},
+#endif
+#ifdef CONFIG_SCHED_AUTOGROUP
+	{
+		.procname	= "sched_autogroup_enabled",
+		.data		= &sysctl_sched_autogroup_enabled,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.procname	= "sched_cfs_bandwidth_slice_us",
+		.data		= &sysctl_sched_cfs_bandwidth_slice,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+	},
+#endif
+#if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_CPU_FREQ_GOV_SCHEDUTIL)
+	{
+		.procname	= "sched_energy_aware",
+		.data		= &sysctl_sched_energy_aware,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_energy_aware_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		.procname	= "prove_locking",
+		.data		= &prove_locking,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_LOCK_STAT
+	{
+		.procname	= "lock_stat",
+		.data		= &lock_stat,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+	{
+		.procname	= "panic",
+		.data		= &panic_timeout,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#ifdef CONFIG_COREDUMP
+	{
+		.procname	= "core_uses_pid",
+		.data		= &core_uses_pid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "core_pattern",
+		.data		= core_pattern,
+		.maxlen		= CORENAME_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= proc_dostring_coredump,
+	},
+	{
+		.procname	= "core_pipe_limit",
+		.data		= &core_pipe_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_PROC_SYSCTL
+	{
+		.procname	= "tainted",
+		.maxlen 	= sizeof(long),
+		.mode		= 0644,
+		.proc_handler	= proc_taint,
+	},
+	{
+		.procname	= "sysctl_writes_strict",
+		.data		= &sysctl_writes_strict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &neg_one,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_LATENCYTOP
+	{
+		.procname	= "latencytop",
+		.data		= &latencytop_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_latencytop,
+	},
+#endif
+#ifdef CONFIG_BLK_DEV_INITRD
+	{
+		.procname	= "real-root-dev",
+		.data		= &real_root_dev,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+	{
+		.procname	= "print-fatal-signals",
+		.data		= &print_fatal_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#ifdef CONFIG_SPARC
+	{
+		.procname	= "reboot-cmd",
+		.data		= reboot_command,
+		.maxlen		= 256,
+		.mode		= 0644,
+		.proc_handler	= proc_dostring,
+	},
+	{
+		.procname	= "stop-a",
+		.data		= &stop_a_enabled,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "scons-poweroff",
+		.data		= &scons_pwroff,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_SPARC64
+	{
+		.procname	= "tsb-ratio",
+		.data		= &sysctl_tsb_ratio,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_PARISC
+	{
+		.procname	= "soft-power",
+		.data		= &pwrsw_enabled,
+		.maxlen		= sizeof (int),
+	 	.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
+	{
+		.procname	= "unaligned-trap",
+		.data		= &unaligned_enabled,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+	{
+		.procname	= "ctrl-alt-del",
+		.data		= &C_A_D,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#ifdef CONFIG_FUNCTION_TRACER
+	{
+		.procname	= "ftrace_enabled",
+		.data		= &ftrace_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= ftrace_enable_sysctl,
+	},
+#endif
+#ifdef CONFIG_STACK_TRACER
+	{
+		.procname	= "stack_tracer_enabled",
+		.data		= &stack_tracer_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= stack_trace_sysctl,
+	},
+#endif
+#ifdef CONFIG_TRACING
+	{
+		.procname	= "ftrace_dump_on_oops",
+		.data		= &ftrace_dump_on_oops,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "traceoff_on_warning",
+		.data		= &__disable_trace_on_warning,
+		.maxlen		= sizeof(__disable_trace_on_warning),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "tracepoint_printk",
+		.data		= &tracepoint_printk,
+		.maxlen		= sizeof(tracepoint_printk),
+		.mode		= 0644,
+		.proc_handler	= tracepoint_printk_sysctl,
+	},
+#endif
+#ifdef CONFIG_KEXEC_CORE
+	{
+		.procname	= "kexec_load_disabled",
+		.data		= &kexec_load_disabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		/* only handle a transition from default "0" to "1" */
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_MODULES
+	{
+		.procname	= "modprobe",
+		.data		= &modprobe_path,
+		.maxlen		= KMOD_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= proc_dostring,
+	},
+	{
+		.procname	= "modules_disabled",
+		.data		= &modules_disabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		/* only handle a transition from default "0" to "1" */
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_UEVENT_HELPER
+	{
+		.procname	= "hotplug",
+		.data		= &uevent_helper,
+		.maxlen		= UEVENT_HELPER_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= proc_dostring,
+	},
+#endif
+#ifdef CONFIG_CHR_DEV_SG
+	{
+		.procname	= "sg-big-buff",
+		.data		= &sg_big_buff,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+	{
+		.procname	= "acct",
+		.data		= &acct_parm,
+		.maxlen		= 3*sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_MAGIC_SYSRQ
+	{
+		.procname	= "sysrq",
+		.data		= NULL,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= sysrq_sysctl_handler,
+	},
+#endif
+#ifdef CONFIG_PROC_SYSCTL
+	{
+		.procname	= "cad_pid",
+		.data		= NULL,
+		.maxlen		= sizeof (int),
+		.mode		= 0600,
+		.proc_handler	= proc_do_cad_pid,
+	},
+#endif
+	{
+		.procname	= "threads-max",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_max_threads,
+	},
+	{
+		.procname	= "random",
+		.mode		= 0555,
+		.child		= random_table,
+	},
+	{
+		.procname	= "usermodehelper",
+		.mode		= 0555,
+		.child		= usermodehelper_table,
+	},
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+	{
+		.procname	= "firmware_config",
+		.mode		= 0555,
+		.child		= firmware_config_table,
+	},
+#endif
+	{
+		.procname	= "overflowuid",
+		.data		= &overflowuid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+	{
+		.procname	= "overflowgid",
+		.data		= &overflowgid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+#ifdef CONFIG_S390
+	{
+		.procname	= "userprocess_debug",
+		.data		= &show_unhandled_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+	{
+		.procname	= "pid_max",
+		.data		= &pid_max,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &pid_max_min,
+		.extra2		= &pid_max_max,
+	},
+	{
+		.procname	= "panic_on_oops",
+		.data		= &panic_on_oops,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "panic_print",
+		.data		= &panic_print,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#if defined CONFIG_PRINTK
+	{
+		.procname	= "printk",
+		.data		= &console_loglevel,
+		.maxlen		= 4*sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "printk_ratelimit",
+		.data		= &printk_ratelimit_state.interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "printk_ratelimit_burst",
+		.data		= &printk_ratelimit_state.burst,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "printk_delay",
+		.data		= &printk_delay_msec,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &ten_thousand,
+	},
+	{
+		.procname	= "printk_devkmsg",
+		.data		= devkmsg_log_str,
+		.maxlen		= DEVKMSG_STR_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= devkmsg_sysctl_set_loglvl,
+	},
+	{
+		.procname	= "dmesg_restrict",
+		.data		= &dmesg_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "kptr_restrict",
+		.data		= &kptr_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
+	},
+#endif
+	{
+		.procname	= "ngroups_max",
+		.data		= &ngroups_max,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "cap_last_cap",
+		.data		= (void *)&cap_last_cap,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+#if defined(CONFIG_LOCKUP_DETECTOR)
+	{
+		.procname       = "watchdog",
+		.data		= &watchdog_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler   = proc_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "watchdog_thresh",
+		.data		= &watchdog_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_watchdog_thresh,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &sixty,
+	},
+	{
+		.procname       = "nmi_watchdog",
+		.data		= &nmi_watchdog_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= NMI_WATCHDOG_SYSCTL_PERM,
+		.proc_handler   = proc_nmi_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "watchdog_cpumask",
+		.data		= &watchdog_cpumask_bits,
+		.maxlen		= NR_CPUS,
+		.mode		= 0644,
+		.proc_handler	= proc_watchdog_cpumask,
+	},
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
+	{
+		.procname       = "soft_watchdog",
+		.data		= &soft_watchdog_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler   = proc_soft_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "softlockup_panic",
+		.data		= &softlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "softlockup_all_cpu_backtrace",
+		.data		= &sysctl_softlockup_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SMP */
+#endif
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	{
+		.procname	= "hardlockup_panic",
+		.data		= &hardlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "hardlockup_all_cpu_backtrace",
+		.data		= &sysctl_hardlockup_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SMP */
+#endif
+#endif
+
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
+	{
+		.procname       = "unknown_nmi_panic",
+		.data           = &unknown_nmi_panic,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
+#endif
+#if defined(CONFIG_X86)
+	{
+		.procname	= "panic_on_unrecovered_nmi",
+		.data		= &panic_on_unrecovered_nmi,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "panic_on_io_nmi",
+		.data		= &panic_on_io_nmi,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	{
+		.procname	= "panic_on_stackoverflow",
+		.data		= &sysctl_panic_on_stackoverflow,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+	{
+		.procname	= "bootloader_type",
+		.data		= &bootloader_type,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "bootloader_version",
+		.data		= &bootloader_version,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "io_delay_type",
+		.data		= &io_delay_type,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#if defined(CONFIG_MMU)
+	{
+		.procname	= "randomize_va_space",
+		.data		= &randomize_va_space,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#if defined(CONFIG_S390) && defined(CONFIG_SMP)
+	{
+		.procname	= "spin_retry",
+		.data		= &spin_retry,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
+	{
+		.procname	= "acpi_video_flags",
+		.data		= &acpi_realmode_flags,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#endif
+#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
+	{
+		.procname	= "ignore-unaligned-usertrap",
+		.data		= &no_unaligned_warning,
+		.maxlen		= sizeof (int),
+	 	.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_IA64
+	{
+		.procname	= "unaligned-dump-stack",
+		.data		= &unaligned_dump_stack,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_DETECT_HUNG_TASK
+	{
+		.procname	= "hung_task_panic",
+		.data		= &sysctl_hung_task_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "hung_task_check_count",
+		.data		= &sysctl_hung_task_check_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "hung_task_timeout_secs",
+		.data		= &sysctl_hung_task_timeout_secs,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= &hung_task_timeout_max,
+	},
+	{
+		.procname	= "hung_task_check_interval_secs",
+		.data		= &sysctl_hung_task_check_interval_secs,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= &hung_task_timeout_max,
+	},
+	{
+		.procname	= "hung_task_warnings",
+		.data		= &sysctl_hung_task_warnings,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &neg_one,
+	},
+#endif
+#ifdef CONFIG_RT_MUTEXES
+	{
+		.procname	= "max_lock_depth",
+		.data		= &max_lock_depth,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+	{
+		.procname	= "poweroff_cmd",
+		.data		= &poweroff_cmd,
+		.maxlen		= POWEROFF_CMD_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= proc_dostring,
+	},
+#ifdef CONFIG_KEYS
+	{
+		.procname	= "keys",
+		.mode		= 0555,
+		.child		= key_sysctls,
+	},
+#endif
+#ifdef CONFIG_PERF_EVENTS
+	/*
+	 * User-space scripts rely on the existence of this file
+	 * as a feature check for perf_events being enabled.
+	 *
+	 * So it's an ABI, do not remove!
+	 */
+	{
+		.procname	= "perf_event_paranoid",
+		.data		= &sysctl_perf_event_paranoid,
+		.maxlen		= sizeof(sysctl_perf_event_paranoid),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "perf_event_mlock_kb",
+		.data		= &sysctl_perf_event_mlock,
+		.maxlen		= sizeof(sysctl_perf_event_mlock),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "perf_event_max_sample_rate",
+		.data		= &sysctl_perf_event_sample_rate,
+		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
+		.mode		= 0644,
+		.proc_handler	= perf_proc_update_handler,
+		.extra1		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "perf_cpu_time_max_percent",
+		.data		= &sysctl_perf_cpu_time_max_percent,
+		.maxlen		= sizeof(sysctl_perf_cpu_time_max_percent),
+		.mode		= 0644,
+		.proc_handler	= perf_cpu_time_max_percent_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &one_hundred,
+	},
+	{
+		.procname	= "perf_event_max_stack",
+		.data		= &sysctl_perf_event_max_stack,
+		.maxlen		= sizeof(sysctl_perf_event_max_stack),
+		.mode		= 0644,
+		.proc_handler	= perf_event_max_stack_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &six_hundred_forty_kb,
+	},
+	{
+		.procname	= "perf_event_max_contexts_per_stack",
+		.data		= &sysctl_perf_event_max_contexts_per_stack,
+		.maxlen		= sizeof(sysctl_perf_event_max_contexts_per_stack),
+		.mode		= 0644,
+		.proc_handler	= perf_event_max_stack_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &one_thousand,
+	},
+#endif
+	{
+		.procname	= "panic_on_warn",
+		.data		= &panic_on_warn,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
+	{
+		.procname	= "timer_migration",
+		.data		= &sysctl_timer_migration,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= timer_migration_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_BPF_SYSCALL
+	{
+		.procname	= "unprivileged_bpf_disabled",
+		.data		= &sysctl_unprivileged_bpf_disabled,
+		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
+		.mode		= 0644,
+		/* only handle a transition from default "0" to "1" */
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "bpf_stats_enabled",
+		.data		= &bpf_stats_enabled_key.key,
+		.maxlen		= sizeof(bpf_stats_enabled_key),
+		.mode		= 0644,
+		.proc_handler	= proc_do_static_key,
+	},
+#endif
+#if defined(CONFIG_TREE_RCU)
+	{
+		.procname	= "panic_on_rcu_stall",
+		.data		= &sysctl_panic_on_rcu_stall,
+		.maxlen		= sizeof(sysctl_panic_on_rcu_stall),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
+	{
+		.procname	= "stack_erasing",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= stack_erasing_sysctl,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+	{ }
+};
 
-int proc_dointvec_ms_jiffies(struct ctl_table *table, int write,
-			     void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
+static struct ctl_table vm_table[] = {
+	{
+		.procname	= "overcommit_memory",
+		.data		= &sysctl_overcommit_memory,
+		.maxlen		= sizeof(sysctl_overcommit_memory),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
+	},
+	{
+		.procname	= "panic_on_oom",
+		.data		= &sysctl_panic_on_oom,
+		.maxlen		= sizeof(sysctl_panic_on_oom),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
+	},
+	{
+		.procname	= "oom_kill_allocating_task",
+		.data		= &sysctl_oom_kill_allocating_task,
+		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "oom_dump_tasks",
+		.data		= &sysctl_oom_dump_tasks,
+		.maxlen		= sizeof(sysctl_oom_dump_tasks),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "overcommit_ratio",
+		.data		= &sysctl_overcommit_ratio,
+		.maxlen		= sizeof(sysctl_overcommit_ratio),
+		.mode		= 0644,
+		.proc_handler	= overcommit_ratio_handler,
+	},
+	{
+		.procname	= "overcommit_kbytes",
+		.data		= &sysctl_overcommit_kbytes,
+		.maxlen		= sizeof(sysctl_overcommit_kbytes),
+		.mode		= 0644,
+		.proc_handler	= overcommit_kbytes_handler,
+	},
+	{
+		.procname	= "page-cluster", 
+		.data		= &page_cluster,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "dirty_background_ratio",
+		.data		= &dirty_background_ratio,
+		.maxlen		= sizeof(dirty_background_ratio),
+		.mode		= 0644,
+		.proc_handler	= dirty_background_ratio_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &one_hundred,
+	},
+	{
+		.procname	= "dirty_background_bytes",
+		.data		= &dirty_background_bytes,
+		.maxlen		= sizeof(dirty_background_bytes),
+		.mode		= 0644,
+		.proc_handler	= dirty_background_bytes_handler,
+		.extra1		= &one_ul,
+	},
+	{
+		.procname	= "dirty_ratio",
+		.data		= &vm_dirty_ratio,
+		.maxlen		= sizeof(vm_dirty_ratio),
+		.mode		= 0644,
+		.proc_handler	= dirty_ratio_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &one_hundred,
+	},
+	{
+		.procname	= "dirty_bytes",
+		.data		= &vm_dirty_bytes,
+		.maxlen		= sizeof(vm_dirty_bytes),
+		.mode		= 0644,
+		.proc_handler	= dirty_bytes_handler,
+		.extra1		= &dirty_bytes_min,
+	},
+	{
+		.procname	= "dirty_writeback_centisecs",
+		.data		= &dirty_writeback_interval,
+		.maxlen		= sizeof(dirty_writeback_interval),
+		.mode		= 0644,
+		.proc_handler	= dirty_writeback_centisecs_handler,
+	},
+	{
+		.procname	= "dirty_expire_centisecs",
+		.data		= &dirty_expire_interval,
+		.maxlen		= sizeof(dirty_expire_interval),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "dirtytime_expire_seconds",
+		.data		= &dirtytime_expire_interval,
+		.maxlen		= sizeof(dirtytime_expire_interval),
+		.mode		= 0644,
+		.proc_handler	= dirtytime_interval_handler,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "swappiness",
+		.data		= &vm_swappiness,
+		.maxlen		= sizeof(vm_swappiness),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &one_hundred,
+	},
+#ifdef CONFIG_HUGETLB_PAGE
+	{
+		.procname	= "nr_hugepages",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= hugetlb_sysctl_handler,
+	},
+#ifdef CONFIG_NUMA
+	{
+		.procname       = "nr_hugepages_mempolicy",
+		.data           = NULL,
+		.maxlen         = sizeof(unsigned long),
+		.mode           = 0644,
+		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
+	},
+	{
+		.procname		= "numa_stat",
+		.data			= &sysctl_vm_numa_stat,
+		.maxlen			= sizeof(int),
+		.mode			= 0644,
+		.proc_handler	= sysctl_vm_numa_stat_handler,
+		.extra1			= SYSCTL_ZERO,
+		.extra2			= SYSCTL_ONE,
+	},
+#endif
+	 {
+		.procname	= "hugetlb_shm_group",
+		.data		= &sysctl_hugetlb_shm_group,
+		.maxlen		= sizeof(gid_t),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	 },
+	{
+		.procname	= "nr_overcommit_hugepages",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= hugetlb_overcommit_handler,
+	},
+#endif
+	{
+		.procname	= "lowmem_reserve_ratio",
+		.data		= &sysctl_lowmem_reserve_ratio,
+		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
+		.mode		= 0644,
+		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+	},
+	{
+		.procname	= "drop_caches",
+		.data		= &sysctl_drop_caches,
+		.maxlen		= sizeof(int),
+		.mode		= 0200,
+		.proc_handler	= drop_caches_sysctl_handler,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= &four,
+	},
+#ifdef CONFIG_COMPACTION
+	{
+		.procname	= "compact_memory",
+		.data		= &sysctl_compact_memory,
+		.maxlen		= sizeof(int),
+		.mode		= 0200,
+		.proc_handler	= sysctl_compaction_handler,
+	},
+	{
+		.procname	= "extfrag_threshold",
+		.data		= &sysctl_extfrag_threshold,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_extfrag_threshold,
+		.extra2		= &max_extfrag_threshold,
+	},
+	{
+		.procname	= "compact_unevictable_allowed",
+		.data		= &sysctl_compact_unevictable_allowed,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_warn_RT_change,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+
+#endif /* CONFIG_COMPACTION */
+	{
+		.procname	= "min_free_kbytes",
+		.data		= &min_free_kbytes,
+		.maxlen		= sizeof(min_free_kbytes),
+		.mode		= 0644,
+		.proc_handler	= min_free_kbytes_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "watermark_boost_factor",
+		.data		= &watermark_boost_factor,
+		.maxlen		= sizeof(watermark_boost_factor),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "watermark_scale_factor",
+		.data		= &watermark_scale_factor,
+		.maxlen		= sizeof(watermark_scale_factor),
+		.mode		= 0644,
+		.proc_handler	= watermark_scale_factor_sysctl_handler,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= &one_thousand,
+	},
+	{
+		.procname	= "percpu_pagelist_fraction",
+		.data		= &percpu_pagelist_fraction,
+		.maxlen		= sizeof(percpu_pagelist_fraction),
+		.mode		= 0644,
+		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+	},
+#ifdef CONFIG_MMU
+	{
+		.procname	= "max_map_count",
+		.data		= &sysctl_max_map_count,
+		.maxlen		= sizeof(sysctl_max_map_count),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+#else
+	{
+		.procname	= "nr_trim_pages",
+		.data		= &sysctl_nr_trim_pages,
+		.maxlen		= sizeof(sysctl_nr_trim_pages),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+#endif
+	{
+		.procname	= "laptop_mode",
+		.data		= &laptop_mode,
+		.maxlen		= sizeof(laptop_mode),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "block_dump",
+		.data		= &block_dump,
+		.maxlen		= sizeof(block_dump),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "vfs_cache_pressure",
+		.data		= &sysctl_vfs_cache_pressure,
+		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+	},
+#if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
+    defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
+	{
+		.procname	= "legacy_va_layout",
+		.data		= &sysctl_legacy_va_layout,
+		.maxlen		= sizeof(sysctl_legacy_va_layout),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+	},
+#endif
+#ifdef CONFIG_NUMA
+	{
+		.procname	= "zone_reclaim_mode",
+		.data		= &node_reclaim_mode,
+		.maxlen		= sizeof(node_reclaim_mode),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "min_unmapped_ratio",
+		.data		= &sysctl_min_unmapped_ratio,
+		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
+		.mode		= 0644,
+		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &one_hundred,
+	},
+	{
+		.procname	= "min_slab_ratio",
+		.data		= &sysctl_min_slab_ratio,
+		.maxlen		= sizeof(sysctl_min_slab_ratio),
+		.mode		= 0644,
+		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &one_hundred,
+	},
+#endif
+#ifdef CONFIG_SMP
+	{
+		.procname	= "stat_interval",
+		.data		= &sysctl_stat_interval,
+		.maxlen		= sizeof(sysctl_stat_interval),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "stat_refresh",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0600,
+		.proc_handler	= vmstat_refresh,
+	},
+#endif
+#ifdef CONFIG_MMU
+	{
+		.procname	= "mmap_min_addr",
+		.data		= &dac_mmap_min_addr,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= mmap_min_addr_handler,
+	},
+#endif
+#ifdef CONFIG_NUMA
+	{
+		.procname	= "numa_zonelist_order",
+		.data		= &numa_zonelist_order,
+		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
+		.mode		= 0644,
+		.proc_handler	= numa_zonelist_order_handler,
+	},
+#endif
+#if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
+   (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
+	{
+		.procname	= "vdso_enabled",
+#ifdef CONFIG_X86_32
+		.data		= &vdso32_enabled,
+		.maxlen		= sizeof(vdso32_enabled),
+#else
+		.data		= &vdso_enabled,
+		.maxlen		= sizeof(vdso_enabled),
+#endif
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+	},
+#endif
+#ifdef CONFIG_HIGHMEM
+	{
+		.procname	= "highmem_is_dirtyable",
+		.data		= &vm_highmem_is_dirtyable,
+		.maxlen		= sizeof(vm_highmem_is_dirtyable),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+#ifdef CONFIG_MEMORY_FAILURE
+	{
+		.procname	= "memory_failure_early_kill",
+		.data		= &sysctl_memory_failure_early_kill,
+		.maxlen		= sizeof(sysctl_memory_failure_early_kill),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "memory_failure_recovery",
+		.data		= &sysctl_memory_failure_recovery,
+		.maxlen		= sizeof(sysctl_memory_failure_recovery),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+	{
+		.procname	= "user_reserve_kbytes",
+		.data		= &sysctl_user_reserve_kbytes,
+		.maxlen		= sizeof(sysctl_user_reserve_kbytes),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "admin_reserve_kbytes",
+		.data		= &sysctl_admin_reserve_kbytes,
+		.maxlen		= sizeof(sysctl_admin_reserve_kbytes),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
+	{
+		.procname	= "mmap_rnd_bits",
+		.data		= &mmap_rnd_bits,
+		.maxlen		= sizeof(mmap_rnd_bits),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= (void *)&mmap_rnd_bits_min,
+		.extra2		= (void *)&mmap_rnd_bits_max,
+	},
+#endif
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
+	{
+		.procname	= "mmap_rnd_compat_bits",
+		.data		= &mmap_rnd_compat_bits,
+		.maxlen		= sizeof(mmap_rnd_compat_bits),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= (void *)&mmap_rnd_compat_bits_min,
+		.extra2		= (void *)&mmap_rnd_compat_bits_max,
+	},
+#endif
+#ifdef CONFIG_USERFAULTFD
+	{
+		.procname	= "unprivileged_userfaultfd",
+		.data		= &sysctl_unprivileged_userfaultfd,
+		.maxlen		= sizeof(sysctl_unprivileged_userfaultfd),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+	{ }
+};
 
-int proc_doulongvec_minmax(struct ctl_table *table, int write,
-		    void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
+static struct ctl_table fs_table[] = {
+	{
+		.procname	= "inode-nr",
+		.data		= &inodes_stat,
+		.maxlen		= 2*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_inodes,
+	},
+	{
+		.procname	= "inode-state",
+		.data		= &inodes_stat,
+		.maxlen		= 7*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_inodes,
+	},
+	{
+		.procname	= "file-nr",
+		.data		= &files_stat,
+		.maxlen		= sizeof(files_stat),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_files,
+	},
+	{
+		.procname	= "file-max",
+		.data		= &files_stat.max_files,
+		.maxlen		= sizeof(files_stat.max_files),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &zero_ul,
+		.extra2		= &long_max,
+	},
+	{
+		.procname	= "nr_open",
+		.data		= &sysctl_nr_open,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &sysctl_nr_open_min,
+		.extra2		= &sysctl_nr_open_max,
+	},
+	{
+		.procname	= "dentry-state",
+		.data		= &dentry_stat,
+		.maxlen		= 6*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_dentry,
+	},
+	{
+		.procname	= "overflowuid",
+		.data		= &fs_overflowuid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+	{
+		.procname	= "overflowgid",
+		.data		= &fs_overflowgid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+#ifdef CONFIG_FILE_LOCKING
+	{
+		.procname	= "leases-enable",
+		.data		= &leases_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_DNOTIFY
+	{
+		.procname	= "dir-notify-enable",
+		.data		= &dir_notify_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_MMU
+#ifdef CONFIG_FILE_LOCKING
+	{
+		.procname	= "lease-break-time",
+		.data		= &lease_break_time,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_AIO
+	{
+		.procname	= "aio-nr",
+		.data		= &aio_nr,
+		.maxlen		= sizeof(aio_nr),
+		.mode		= 0444,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "aio-max-nr",
+		.data		= &aio_max_nr,
+		.maxlen		= sizeof(aio_max_nr),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#endif /* CONFIG_AIO */
+#ifdef CONFIG_INOTIFY_USER
+	{
+		.procname	= "inotify",
+		.mode		= 0555,
+		.child		= inotify_table,
+	},
+#endif	
+#ifdef CONFIG_EPOLL
+	{
+		.procname	= "epoll",
+		.mode		= 0555,
+		.child		= epoll_table,
+	},
+#endif
+#endif
+	{
+		.procname	= "protected_symlinks",
+		.data		= &sysctl_protected_symlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "protected_hardlinks",
+		.data		= &sysctl_protected_hardlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "protected_fifos",
+		.data		= &sysctl_protected_fifos,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
+	},
+	{
+		.procname	= "protected_regular",
+		.data		= &sysctl_protected_regular,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
+	},
+	{
+		.procname	= "suid_dumpable",
+		.data		= &suid_dumpable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_coredump,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
+	},
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+	{
+		.procname	= "binfmt_misc",
+		.mode		= 0555,
+		.child		= sysctl_mount_point,
+	},
+#endif
+	{
+		.procname	= "pipe-max-size",
+		.data		= &pipe_max_size,
+		.maxlen		= sizeof(pipe_max_size),
+		.mode		= 0644,
+		.proc_handler	= proc_dopipe_max_size,
+	},
+	{
+		.procname	= "pipe-user-pages-hard",
+		.data		= &pipe_user_pages_hard,
+		.maxlen		= sizeof(pipe_user_pages_hard),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "pipe-user-pages-soft",
+		.data		= &pipe_user_pages_soft,
+		.maxlen		= sizeof(pipe_user_pages_soft),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "mount-max",
+		.data		= &sysctl_mount_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+	},
+	{ }
+};
 
-int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
-				      void __user *buffer,
-				      size_t *lenp, loff_t *ppos)
-{
-    return -ENOSYS;
-}
+static struct ctl_table debug_table[] = {
+#ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
+	{
+		.procname	= "exception-trace",
+		.data		= &show_unhandled_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+#endif
+#if defined(CONFIG_OPTPROBES)
+	{
+		.procname	= "kprobes-optimization",
+		.data		= &sysctl_kprobes_optimization,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_kprobes_optimization_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+	{ }
+};
 
-int proc_do_large_bitmap(struct ctl_table *table, int write,
-			 void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
+static struct ctl_table dev_table[] = {
+	{ }
+};
 
-#endif /* CONFIG_PROC_SYSCTL */
+static struct ctl_table sysctl_base_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= kern_table,
+	},
+	{
+		.procname	= "vm",
+		.mode		= 0555,
+		.child		= vm_table,
+	},
+	{
+		.procname	= "fs",
+		.mode		= 0555,
+		.child		= fs_table,
+	},
+	{
+		.procname	= "debug",
+		.mode		= 0555,
+		.child		= debug_table,
+	},
+	{
+		.procname	= "dev",
+		.mode		= 0555,
+		.child		= dev_table,
+	},
+	{ }
+};
 
-#if defined(CONFIG_SYSCTL)
-int proc_do_static_key(struct ctl_table *table, int write,
-		       void __user *buffer, size_t *lenp,
-		       loff_t *ppos)
+int __init sysctl_init(void)
 {
-	struct static_key *key = (struct static_key *)table->data;
-	static DEFINE_MUTEX(static_key_mutex);
-	int val, ret;
-	struct ctl_table tmp = {
-		.data   = &val,
-		.maxlen = sizeof(val),
-		.mode   = table->mode,
-		.extra1 = SYSCTL_ZERO,
-		.extra2 = SYSCTL_ONE,
-	};
-
-	if (write && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	struct ctl_table_header *hdr;
 
-	mutex_lock(&static_key_mutex);
-	val = static_key_enabled(key);
-	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
-	if (write && !ret) {
-		if (val)
-			static_key_enable(key);
-		else
-			static_key_disable(key);
-	}
-	mutex_unlock(&static_key_mutex);
-	return ret;
+	hdr = register_sysctl_table(sysctl_base_table);
+	kmemleak_not_leak(hdr);
+	return 0;
 }
-#endif
+#endif /* CONFIG_SYSCTL */
 /*
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
-- 
2.26.1

