Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CD01BD4ED
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgD2GpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgD2GpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:45:22 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE58CC03C1AD;
        Tue, 28 Apr 2020 23:45:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Bpt53PpVz9sSy;
        Wed, 29 Apr 2020 16:45:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588142718;
        bh=3cMRdLL9NxF4buj+57KowqZUgvkJHk/Zf4rhGSm4NDg=;
        h=Date:From:To:Cc:Subject:From;
        b=dUKnaEFo8k+w1MYkeApOzlBgyLSM9LyOF9J5JG89pi8xZVypitag3ErY96jeNIrbP
         KLKBcFIaoJe88CHKUsCR+KaiGslWlJsAV06JsgEw60OP4kISJltHY+Wzm+L6dioX9d
         7TZC0PBfDhS6W67y31ZNhCtWWOksPtEL0IsuuZtfYoEVH7wIhnQeo0vhab0JBsTw4b
         B+g28z05Q+0ZzVGm2AJYzQzREk/exTjBn1mvy0uN2zO9r87bj0ep1aUoXPRptY95wQ
         UkfH+LiLrQT6FCP6U0D/y6lzajI89QVbvQGxCWHnsILX6V6ZoOClUMMeLbpf0SrfLr
         CiXgQJwLGAhKA==
Date:   Wed, 29 Apr 2020 16:45:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: linux-next: manual merge of the akpm-current tree with the bpf-next
 tree
Message-ID: <20200429164507.35ac444b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/X_RG1RvHA.J/zrQZKg=Sl=/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/X_RG1RvHA.J/zrQZKg=Sl=/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  kernel/sysctl.c

between commit:

  f461d2dcd511 ("sysctl: avoid forward declarations")

from the bpf-next tree and commits:

  0fe73f87ba37 ("parisc: add sysctl file interface panic_on_stackoverflow")
  631b6d13906c ("kernel/hung_task.c: introduce sysctl to print all traces w=
hen a hung task is detected")
  0defdd249368 ("panic: add sysctl to dump all CPUs backtraces on oops even=
t")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/sysctl.c
index e961286d0e14,d6e728e3e99f..000000000000
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@@ -1576,1732 -3376,89 +1576,1756 @@@ int proc_do_large_bitmap(struct ctl_=
tab
  	return -ENOSYS;
  }
 =20
 -int proc_dointvec_minmax(struct ctl_table *table, int write,
 -		    void __user *buffer, size_t *lenp, loff_t *ppos)
 +#endif /* CONFIG_PROC_SYSCTL */
 +
 +#if defined(CONFIG_SYSCTL)
 +int proc_do_static_key(struct ctl_table *table, int write,
 +		       void *buffer, size_t *lenp, loff_t *ppos)
  {
 -	return -ENOSYS;
 +	struct static_key *key =3D (struct static_key *)table->data;
 +	static DEFINE_MUTEX(static_key_mutex);
 +	int val, ret;
 +	struct ctl_table tmp =3D {
 +		.data   =3D &val,
 +		.maxlen =3D sizeof(val),
 +		.mode   =3D table->mode,
 +		.extra1 =3D SYSCTL_ZERO,
 +		.extra2 =3D SYSCTL_ONE,
 +	};
 +
 +	if (write && !capable(CAP_SYS_ADMIN))
 +		return -EPERM;
 +
 +	mutex_lock(&static_key_mutex);
 +	val =3D static_key_enabled(key);
 +	ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 +	if (write && !ret) {
 +		if (val)
 +			static_key_enable(key);
 +		else
 +			static_key_disable(key);
 +	}
 +	mutex_unlock(&static_key_mutex);
 +	return ret;
  }
 =20
 -int proc_douintvec_minmax(struct ctl_table *table, int write,
 -			  void __user *buffer, size_t *lenp, loff_t *ppos)
 -{
 -	return -ENOSYS;
 -}
 +static struct ctl_table kern_table[] =3D {
 +	{
 +		.procname	=3D "sched_child_runs_first",
 +		.data		=3D &sysctl_sched_child_runs_first,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#ifdef CONFIG_SCHED_DEBUG
 +	{
 +		.procname	=3D "sched_min_granularity_ns",
 +		.data		=3D &sysctl_sched_min_granularity,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_proc_update_handler,
 +		.extra1		=3D &min_sched_granularity_ns,
 +		.extra2		=3D &max_sched_granularity_ns,
 +	},
 +	{
 +		.procname	=3D "sched_latency_ns",
 +		.data		=3D &sysctl_sched_latency,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_proc_update_handler,
 +		.extra1		=3D &min_sched_granularity_ns,
 +		.extra2		=3D &max_sched_granularity_ns,
 +	},
 +	{
 +		.procname	=3D "sched_wakeup_granularity_ns",
 +		.data		=3D &sysctl_sched_wakeup_granularity,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_proc_update_handler,
 +		.extra1		=3D &min_wakeup_granularity_ns,
 +		.extra2		=3D &max_wakeup_granularity_ns,
 +	},
 +#ifdef CONFIG_SMP
 +	{
 +		.procname	=3D "sched_tunable_scaling",
 +		.data		=3D &sysctl_sched_tunable_scaling,
 +		.maxlen		=3D sizeof(enum sched_tunable_scaling),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_proc_update_handler,
 +		.extra1		=3D &min_sched_tunable_scaling,
 +		.extra2		=3D &max_sched_tunable_scaling,
 +	},
 +	{
 +		.procname	=3D "sched_migration_cost_ns",
 +		.data		=3D &sysctl_sched_migration_cost,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "sched_nr_migrate",
 +		.data		=3D &sysctl_sched_nr_migrate,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#ifdef CONFIG_SCHEDSTATS
 +	{
 +		.procname	=3D "sched_schedstats",
 +		.data		=3D NULL,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_schedstats,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif /* CONFIG_SCHEDSTATS */
 +#endif /* CONFIG_SMP */
 +#ifdef CONFIG_NUMA_BALANCING
 +	{
 +		.procname	=3D "numa_balancing_scan_delay_ms",
 +		.data		=3D &sysctl_numa_balancing_scan_delay,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "numa_balancing_scan_period_min_ms",
 +		.data		=3D &sysctl_numa_balancing_scan_period_min,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "numa_balancing_scan_period_max_ms",
 +		.data		=3D &sysctl_numa_balancing_scan_period_max,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "numa_balancing_scan_size_mb",
 +		.data		=3D &sysctl_numa_balancing_scan_size,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "numa_balancing",
 +		.data		=3D NULL, /* filled in by handler */
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_numa_balancing,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif /* CONFIG_NUMA_BALANCING */
 +#endif /* CONFIG_SCHED_DEBUG */
 +	{
 +		.procname	=3D "sched_rt_period_us",
 +		.data		=3D &sysctl_sched_rt_period,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_rt_handler,
 +	},
 +	{
 +		.procname	=3D "sched_rt_runtime_us",
 +		.data		=3D &sysctl_sched_rt_runtime,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_rt_handler,
 +	},
 +	{
 +		.procname	=3D "sched_rr_timeslice_ms",
 +		.data		=3D &sysctl_sched_rr_timeslice,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_rr_handler,
 +	},
 +#ifdef CONFIG_UCLAMP_TASK
 +	{
 +		.procname	=3D "sched_util_clamp_min",
 +		.data		=3D &sysctl_sched_uclamp_util_min,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_sched_uclamp_handler,
 +	},
 +	{
 +		.procname	=3D "sched_util_clamp_max",
 +		.data		=3D &sysctl_sched_uclamp_util_max,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_sched_uclamp_handler,
 +	},
 +#endif
 +#ifdef CONFIG_SCHED_AUTOGROUP
 +	{
 +		.procname	=3D "sched_autogroup_enabled",
 +		.data		=3D &sysctl_sched_autogroup_enabled,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_CFS_BANDWIDTH
 +	{
 +		.procname	=3D "sched_cfs_bandwidth_slice_us",
 +		.data		=3D &sysctl_sched_cfs_bandwidth_slice,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_CPU_FREQ_GOV_SCHEDUTIL)
 +	{
 +		.procname	=3D "sched_energy_aware",
 +		.data		=3D &sysctl_sched_energy_aware,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sched_energy_aware_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_PROVE_LOCKING
 +	{
 +		.procname	=3D "prove_locking",
 +		.data		=3D &prove_locking,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_LOCK_STAT
 +	{
 +		.procname	=3D "lock_stat",
 +		.data		=3D &lock_stat,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +	{
 +		.procname	=3D "panic",
 +		.data		=3D &panic_timeout,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#ifdef CONFIG_COREDUMP
 +	{
 +		.procname	=3D "core_uses_pid",
 +		.data		=3D &core_uses_pid,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "core_pattern",
 +		.data		=3D core_pattern,
 +		.maxlen		=3D CORENAME_MAX_SIZE,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dostring_coredump,
 +	},
 +	{
 +		.procname	=3D "core_pipe_limit",
 +		.data		=3D &core_pipe_limit,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_PROC_SYSCTL
 +	{
 +		.procname	=3D "tainted",
 +		.maxlen 	=3D sizeof(long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_taint,
 +	},
 +	{
 +		.procname	=3D "sysctl_writes_strict",
 +		.data		=3D &sysctl_writes_strict,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &neg_one,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_LATENCYTOP
 +	{
 +		.procname	=3D "latencytop",
 +		.data		=3D &latencytop_enabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_latencytop,
 +	},
 +#endif
 +#ifdef CONFIG_BLK_DEV_INITRD
 +	{
 +		.procname	=3D "real-root-dev",
 +		.data		=3D &real_root_dev,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +	{
 +		.procname	=3D "print-fatal-signals",
 +		.data		=3D &print_fatal_signals,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#ifdef CONFIG_SPARC
 +	{
 +		.procname	=3D "reboot-cmd",
 +		.data		=3D reboot_command,
 +		.maxlen		=3D 256,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dostring,
 +	},
 +	{
 +		.procname	=3D "stop-a",
 +		.data		=3D &stop_a_enabled,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "scons-poweroff",
 +		.data		=3D &scons_pwroff,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_SPARC64
 +	{
 +		.procname	=3D "tsb-ratio",
 +		.data		=3D &sysctl_tsb_ratio,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_PARISC
 +	{
 +		.procname	=3D "soft-power",
 +		.data		=3D &pwrsw_enabled,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
 +	{
 +		.procname	=3D "unaligned-trap",
 +		.data		=3D &unaligned_enabled,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +	{
 +		.procname	=3D "ctrl-alt-del",
 +		.data		=3D &C_A_D,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#ifdef CONFIG_FUNCTION_TRACER
 +	{
 +		.procname	=3D "ftrace_enabled",
 +		.data		=3D &ftrace_enabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D ftrace_enable_sysctl,
 +	},
 +#endif
 +#ifdef CONFIG_STACK_TRACER
 +	{
 +		.procname	=3D "stack_tracer_enabled",
 +		.data		=3D &stack_tracer_enabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D stack_trace_sysctl,
 +	},
 +#endif
 +#ifdef CONFIG_TRACING
 +	{
 +		.procname	=3D "ftrace_dump_on_oops",
 +		.data		=3D &ftrace_dump_on_oops,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "traceoff_on_warning",
 +		.data		=3D &__disable_trace_on_warning,
 +		.maxlen		=3D sizeof(__disable_trace_on_warning),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "tracepoint_printk",
 +		.data		=3D &tracepoint_printk,
 +		.maxlen		=3D sizeof(tracepoint_printk),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D tracepoint_printk_sysctl,
 +	},
 +#endif
 +#ifdef CONFIG_KEXEC_CORE
 +	{
 +		.procname	=3D "kexec_load_disabled",
 +		.data		=3D &kexec_load_disabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		/* only handle a transition from default "0" to "1" */
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ONE,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_MODULES
 +	{
 +		.procname	=3D "modprobe",
 +		.data		=3D &modprobe_path,
 +		.maxlen		=3D KMOD_PATH_LEN,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dostring,
 +	},
 +	{
 +		.procname	=3D "modules_disabled",
 +		.data		=3D &modules_disabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		/* only handle a transition from default "0" to "1" */
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ONE,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_UEVENT_HELPER
 +	{
 +		.procname	=3D "hotplug",
 +		.data		=3D &uevent_helper,
 +		.maxlen		=3D UEVENT_HELPER_PATH_LEN,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dostring,
 +	},
 +#endif
 +#ifdef CONFIG_CHR_DEV_SG
 +	{
 +		.procname	=3D "sg-big-buff",
 +		.data		=3D &sg_big_buff,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_BSD_PROCESS_ACCT
 +	{
 +		.procname	=3D "acct",
 +		.data		=3D &acct_parm,
 +		.maxlen		=3D 3*sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_MAGIC_SYSRQ
 +	{
 +		.procname	=3D "sysrq",
 +		.data		=3D NULL,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysrq_sysctl_handler,
 +	},
 +#endif
 +#ifdef CONFIG_PROC_SYSCTL
 +	{
 +		.procname	=3D "cad_pid",
 +		.data		=3D NULL,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D proc_do_cad_pid,
 +	},
 +#endif
 +	{
 +		.procname	=3D "threads-max",
 +		.data		=3D NULL,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_max_threads,
 +	},
 +	{
 +		.procname	=3D "random",
 +		.mode		=3D 0555,
 +		.child		=3D random_table,
 +	},
 +	{
 +		.procname	=3D "usermodehelper",
 +		.mode		=3D 0555,
 +		.child		=3D usermodehelper_table,
 +	},
 +#ifdef CONFIG_FW_LOADER_USER_HELPER
 +	{
 +		.procname	=3D "firmware_config",
 +		.mode		=3D 0555,
 +		.child		=3D firmware_config_table,
 +	},
 +#endif
 +	{
 +		.procname	=3D "overflowuid",
 +		.data		=3D &overflowuid,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &minolduid,
 +		.extra2		=3D &maxolduid,
 +	},
 +	{
 +		.procname	=3D "overflowgid",
 +		.data		=3D &overflowgid,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &minolduid,
 +		.extra2		=3D &maxolduid,
 +	},
 +#ifdef CONFIG_S390
 +	{
 +		.procname	=3D "userprocess_debug",
 +		.data		=3D &show_unhandled_signals,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
++#ifdef CONFIG_SMP
++	{
++		.procname	=3D "oops_all_cpu_backtrace",
++		.data		=3D &sysctl_oops_all_cpu_backtrace,
++		.maxlen		=3D sizeof(int),
++		.mode		=3D 0644,
++		.proc_handler	=3D proc_dointvec_minmax,
++		.extra1		=3D SYSCTL_ZERO,
++		.extra2		=3D SYSCTL_ONE,
++	},
++#endif /* CONFIG_SMP */
 +	{
 +		.procname	=3D "pid_max",
 +		.data		=3D &pid_max,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &pid_max_min,
 +		.extra2		=3D &pid_max_max,
 +	},
 +	{
 +		.procname	=3D "panic_on_oops",
 +		.data		=3D &panic_on_oops,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "panic_print",
 +		.data		=3D &panic_print,
 +		.maxlen		=3D sizeof(unsigned long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +#if defined CONFIG_PRINTK
 +	{
 +		.procname	=3D "printk",
 +		.data		=3D &console_loglevel,
 +		.maxlen		=3D 4*sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "printk_ratelimit",
 +		.data		=3D &printk_ratelimit_state.interval,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_jiffies,
 +	},
 +	{
 +		.procname	=3D "printk_ratelimit_burst",
 +		.data		=3D &printk_ratelimit_state.burst,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "printk_delay",
 +		.data		=3D &printk_delay_msec,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &ten_thousand,
 +	},
 +	{
 +		.procname	=3D "printk_devkmsg",
 +		.data		=3D devkmsg_log_str,
 +		.maxlen		=3D DEVKMSG_STR_MAX_SIZE,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D devkmsg_sysctl_set_loglvl,
 +	},
 +	{
 +		.procname	=3D "dmesg_restrict",
 +		.data		=3D &dmesg_restrict,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax_sysadmin,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "kptr_restrict",
 +		.data		=3D &kptr_restrict,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax_sysadmin,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &two,
 +	},
 +#endif
 +	{
 +		.procname	=3D "ngroups_max",
 +		.data		=3D &ngroups_max,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "cap_last_cap",
 +		.data		=3D (void *)&cap_last_cap,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#if defined(CONFIG_LOCKUP_DETECTOR)
 +	{
 +		.procname       =3D "watchdog",
 +		.data		=3D &watchdog_user_enabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler   =3D proc_watchdog,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "watchdog_thresh",
 +		.data		=3D &watchdog_thresh,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_watchdog_thresh,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &sixty,
 +	},
 +	{
 +		.procname       =3D "nmi_watchdog",
 +		.data		=3D &nmi_watchdog_user_enabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D NMI_WATCHDOG_SYSCTL_PERM,
 +		.proc_handler   =3D proc_nmi_watchdog,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "watchdog_cpumask",
 +		.data		=3D &watchdog_cpumask_bits,
 +		.maxlen		=3D NR_CPUS,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_watchdog_cpumask,
 +	},
 +#ifdef CONFIG_SOFTLOCKUP_DETECTOR
 +	{
 +		.procname       =3D "soft_watchdog",
 +		.data		=3D &soft_watchdog_user_enabled,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler   =3D proc_soft_watchdog,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "softlockup_panic",
 +		.data		=3D &softlockup_panic,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#ifdef CONFIG_SMP
 +	{
 +		.procname	=3D "softlockup_all_cpu_backtrace",
 +		.data		=3D &sysctl_softlockup_all_cpu_backtrace,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif /* CONFIG_SMP */
 +#endif
 +#ifdef CONFIG_HARDLOCKUP_DETECTOR
 +	{
 +		.procname	=3D "hardlockup_panic",
 +		.data		=3D &hardlockup_panic,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#ifdef CONFIG_SMP
 +	{
 +		.procname	=3D "hardlockup_all_cpu_backtrace",
 +		.data		=3D &sysctl_hardlockup_all_cpu_backtrace,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif /* CONFIG_SMP */
 +#endif
 +#endif
 +
 +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 +	{
 +		.procname       =3D "unknown_nmi_panic",
 +		.data           =3D &unknown_nmi_panic,
 +		.maxlen         =3D sizeof (int),
 +		.mode           =3D 0644,
 +		.proc_handler   =3D proc_dointvec,
 +	},
 +#endif
- #if defined(CONFIG_X86)
+=20
 -int proc_dointvec_jiffies(struct ctl_table *table, int write,
 -		    void __user *buffer, size_t *lenp, loff_t *ppos)
 -{
 -	return -ENOSYS;
 -}
++#if (defined(CONFIG_X86_32) || defined(CONFIG_PARISC)) && \
++	defined(CONFIG_DEBUG_STACKOVERFLOW)
 +	{
- 		.procname	=3D "panic_on_unrecovered_nmi",
- 		.data		=3D &panic_on_unrecovered_nmi,
++		.procname	=3D "panic_on_stackoverflow",
++		.data		=3D &sysctl_panic_on_stackoverflow,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
++#endif
++#if defined(CONFIG_X86)
 +	{
- 		.procname	=3D "panic_on_io_nmi",
- 		.data		=3D &panic_on_io_nmi,
++		.procname	=3D "panic_on_unrecovered_nmi",
++		.data		=3D &panic_on_unrecovered_nmi,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
- #ifdef CONFIG_DEBUG_STACKOVERFLOW
 +	{
- 		.procname	=3D "panic_on_stackoverflow",
- 		.data		=3D &sysctl_panic_on_stackoverflow,
++		.procname	=3D "panic_on_io_nmi",
++		.data		=3D &panic_on_io_nmi,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
- #endif
 +	{
 +		.procname	=3D "bootloader_type",
 +		.data		=3D &bootloader_type,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "bootloader_version",
 +		.data		=3D &bootloader_version,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "io_delay_type",
 +		.data		=3D &io_delay_type,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#if defined(CONFIG_MMU)
 +	{
 +		.procname	=3D "randomize_va_space",
 +		.data		=3D &randomize_va_space,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#if defined(CONFIG_S390) && defined(CONFIG_SMP)
 +	{
 +		.procname	=3D "spin_retry",
 +		.data		=3D &spin_retry,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
 +	{
 +		.procname	=3D "acpi_video_flags",
 +		.data		=3D &acpi_realmode_flags,
 +		.maxlen		=3D sizeof (unsigned long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +#endif
 +#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
 +	{
 +		.procname	=3D "ignore-unaligned-usertrap",
 +		.data		=3D &no_unaligned_warning,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_IA64
 +	{
 +		.procname	=3D "unaligned-dump-stack",
 +		.data		=3D &unaligned_dump_stack,
 +		.maxlen		=3D sizeof (int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_DETECT_HUNG_TASK
++#ifdef CONFIG_SMP
++	{
++		.procname	=3D "hung_task_all_cpu_backtrace",
++		.data		=3D &sysctl_hung_task_all_cpu_backtrace,
++		.maxlen		=3D sizeof(int),
++		.mode		=3D 0644,
++		.proc_handler	=3D proc_dointvec_minmax,
++		.extra1		=3D SYSCTL_ZERO,
++		.extra2		=3D SYSCTL_ONE,
++	},
++#endif /* CONFIG_SMP */
 +	{
 +		.procname	=3D "hung_task_panic",
 +		.data		=3D &sysctl_hung_task_panic,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "hung_task_check_count",
 +		.data		=3D &sysctl_hung_task_check_count,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "hung_task_timeout_secs",
 +		.data		=3D &sysctl_hung_task_timeout_secs,
 +		.maxlen		=3D sizeof(unsigned long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dohung_task_timeout_secs,
 +		.extra2		=3D &hung_task_timeout_max,
 +	},
 +	{
 +		.procname	=3D "hung_task_check_interval_secs",
 +		.data		=3D &sysctl_hung_task_check_interval_secs,
 +		.maxlen		=3D sizeof(unsigned long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dohung_task_timeout_secs,
 +		.extra2		=3D &hung_task_timeout_max,
 +	},
 +	{
 +		.procname	=3D "hung_task_warnings",
 +		.data		=3D &sysctl_hung_task_warnings,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &neg_one,
 +	},
 +#endif
 +#ifdef CONFIG_RT_MUTEXES
 +	{
 +		.procname	=3D "max_lock_depth",
 +		.data		=3D &max_lock_depth,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +	{
 +		.procname	=3D "poweroff_cmd",
 +		.data		=3D &poweroff_cmd,
 +		.maxlen		=3D POWEROFF_CMD_PATH_LEN,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dostring,
 +	},
 +#ifdef CONFIG_KEYS
 +	{
 +		.procname	=3D "keys",
 +		.mode		=3D 0555,
 +		.child		=3D key_sysctls,
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
 +		.procname	=3D "perf_event_paranoid",
 +		.data		=3D &sysctl_perf_event_paranoid,
 +		.maxlen		=3D sizeof(sysctl_perf_event_paranoid),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "perf_event_mlock_kb",
 +		.data		=3D &sysctl_perf_event_mlock,
 +		.maxlen		=3D sizeof(sysctl_perf_event_mlock),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "perf_event_max_sample_rate",
 +		.data		=3D &sysctl_perf_event_sample_rate,
 +		.maxlen		=3D sizeof(sysctl_perf_event_sample_rate),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D perf_proc_update_handler,
 +		.extra1		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "perf_cpu_time_max_percent",
 +		.data		=3D &sysctl_perf_cpu_time_max_percent,
 +		.maxlen		=3D sizeof(sysctl_perf_cpu_time_max_percent),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D perf_cpu_time_max_percent_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &one_hundred,
 +	},
 +	{
 +		.procname	=3D "perf_event_max_stack",
 +		.data		=3D &sysctl_perf_event_max_stack,
 +		.maxlen		=3D sizeof(sysctl_perf_event_max_stack),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D perf_event_max_stack_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &six_hundred_forty_kb,
 +	},
 +	{
 +		.procname	=3D "perf_event_max_contexts_per_stack",
 +		.data		=3D &sysctl_perf_event_max_contexts_per_stack,
 +		.maxlen		=3D sizeof(sysctl_perf_event_max_contexts_per_stack),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D perf_event_max_stack_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &one_thousand,
 +	},
 +#endif
 +	{
 +		.procname	=3D "panic_on_warn",
 +		.data		=3D &panic_on_warn,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
 +	{
 +		.procname	=3D "timer_migration",
 +		.data		=3D &sysctl_timer_migration,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D timer_migration_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_BPF_SYSCALL
 +	{
 +		.procname	=3D "unprivileged_bpf_disabled",
 +		.data		=3D &sysctl_unprivileged_bpf_disabled,
 +		.maxlen		=3D sizeof(sysctl_unprivileged_bpf_disabled),
 +		.mode		=3D 0644,
 +		/* only handle a transition from default "0" to "1" */
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ONE,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "bpf_stats_enabled",
 +		.data		=3D &bpf_stats_enabled_key.key,
 +		.maxlen		=3D sizeof(bpf_stats_enabled_key),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_do_static_key,
 +	},
 +#endif
 +#if defined(CONFIG_TREE_RCU)
 +	{
 +		.procname	=3D "panic_on_rcu_stall",
 +		.data		=3D &sysctl_panic_on_rcu_stall,
 +		.maxlen		=3D sizeof(sysctl_panic_on_rcu_stall),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
 +	{
 +		.procname	=3D "stack_erasing",
 +		.data		=3D NULL,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D stack_erasing_sysctl,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +	{ }
 +};
 =20
 -int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
 -		    void __user *buffer, size_t *lenp, loff_t *ppos)
 -{
 -	return -ENOSYS;
 -}
 +static struct ctl_table vm_table[] =3D {
 +	{
 +		.procname	=3D "overcommit_memory",
 +		.data		=3D &sysctl_overcommit_memory,
 +		.maxlen		=3D sizeof(sysctl_overcommit_memory),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &two,
 +	},
 +	{
 +		.procname	=3D "panic_on_oom",
 +		.data		=3D &sysctl_panic_on_oom,
 +		.maxlen		=3D sizeof(sysctl_panic_on_oom),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &two,
 +	},
 +	{
 +		.procname	=3D "oom_kill_allocating_task",
 +		.data		=3D &sysctl_oom_kill_allocating_task,
 +		.maxlen		=3D sizeof(sysctl_oom_kill_allocating_task),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "oom_dump_tasks",
 +		.data		=3D &sysctl_oom_dump_tasks,
 +		.maxlen		=3D sizeof(sysctl_oom_dump_tasks),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +	{
 +		.procname	=3D "overcommit_ratio",
 +		.data		=3D &sysctl_overcommit_ratio,
 +		.maxlen		=3D sizeof(sysctl_overcommit_ratio),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D overcommit_ratio_handler,
 +	},
 +	{
 +		.procname	=3D "overcommit_kbytes",
 +		.data		=3D &sysctl_overcommit_kbytes,
 +		.maxlen		=3D sizeof(sysctl_overcommit_kbytes),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D overcommit_kbytes_handler,
 +	},
 +	{
 +		.procname	=3D "page-cluster",
 +		.data		=3D &page_cluster,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "dirty_background_ratio",
 +		.data		=3D &dirty_background_ratio,
 +		.maxlen		=3D sizeof(dirty_background_ratio),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D dirty_background_ratio_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &one_hundred,
 +	},
 +	{
 +		.procname	=3D "dirty_background_bytes",
 +		.data		=3D &dirty_background_bytes,
 +		.maxlen		=3D sizeof(dirty_background_bytes),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D dirty_background_bytes_handler,
 +		.extra1		=3D &one_ul,
 +	},
 +	{
 +		.procname	=3D "dirty_ratio",
 +		.data		=3D &vm_dirty_ratio,
 +		.maxlen		=3D sizeof(vm_dirty_ratio),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D dirty_ratio_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &one_hundred,
 +	},
 +	{
 +		.procname	=3D "dirty_bytes",
 +		.data		=3D &vm_dirty_bytes,
 +		.maxlen		=3D sizeof(vm_dirty_bytes),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D dirty_bytes_handler,
 +		.extra1		=3D &dirty_bytes_min,
 +	},
 +	{
 +		.procname	=3D "dirty_writeback_centisecs",
 +		.data		=3D &dirty_writeback_interval,
 +		.maxlen		=3D sizeof(dirty_writeback_interval),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D dirty_writeback_centisecs_handler,
 +	},
 +	{
 +		.procname	=3D "dirty_expire_centisecs",
 +		.data		=3D &dirty_expire_interval,
 +		.maxlen		=3D sizeof(dirty_expire_interval),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "dirtytime_expire_seconds",
 +		.data		=3D &dirtytime_expire_interval,
 +		.maxlen		=3D sizeof(dirtytime_expire_interval),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D dirtytime_interval_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "swappiness",
 +		.data		=3D &vm_swappiness,
 +		.maxlen		=3D sizeof(vm_swappiness),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &one_hundred,
 +	},
 +#ifdef CONFIG_HUGETLB_PAGE
 +	{
 +		.procname	=3D "nr_hugepages",
 +		.data		=3D NULL,
 +		.maxlen		=3D sizeof(unsigned long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D hugetlb_sysctl_handler,
 +	},
 +#ifdef CONFIG_NUMA
 +	{
 +		.procname       =3D "nr_hugepages_mempolicy",
 +		.data           =3D NULL,
 +		.maxlen         =3D sizeof(unsigned long),
 +		.mode           =3D 0644,
 +		.proc_handler   =3D &hugetlb_mempolicy_sysctl_handler,
 +	},
 +	{
 +		.procname		=3D "numa_stat",
 +		.data			=3D &sysctl_vm_numa_stat,
 +		.maxlen			=3D sizeof(int),
 +		.mode			=3D 0644,
 +		.proc_handler	=3D sysctl_vm_numa_stat_handler,
 +		.extra1			=3D SYSCTL_ZERO,
 +		.extra2			=3D SYSCTL_ONE,
 +	},
 +#endif
 +	 {
 +		.procname	=3D "hugetlb_shm_group",
 +		.data		=3D &sysctl_hugetlb_shm_group,
 +		.maxlen		=3D sizeof(gid_t),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	 },
 +	{
 +		.procname	=3D "nr_overcommit_hugepages",
 +		.data		=3D NULL,
 +		.maxlen		=3D sizeof(unsigned long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D hugetlb_overcommit_handler,
 +	},
 +#endif
 +	{
 +		.procname	=3D "lowmem_reserve_ratio",
 +		.data		=3D &sysctl_lowmem_reserve_ratio,
 +		.maxlen		=3D sizeof(sysctl_lowmem_reserve_ratio),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D lowmem_reserve_ratio_sysctl_handler,
 +	},
 +	{
 +		.procname	=3D "drop_caches",
 +		.data		=3D &sysctl_drop_caches,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0200,
 +		.proc_handler	=3D drop_caches_sysctl_handler,
 +		.extra1		=3D SYSCTL_ONE,
 +		.extra2		=3D &four,
 +	},
 +#ifdef CONFIG_COMPACTION
 +	{
 +		.procname	=3D "compact_memory",
 +		.data		=3D &sysctl_compact_memory,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0200,
 +		.proc_handler	=3D sysctl_compaction_handler,
 +	},
 +	{
 +		.procname	=3D "extfrag_threshold",
 +		.data		=3D &sysctl_extfrag_threshold,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &min_extfrag_threshold,
 +		.extra2		=3D &max_extfrag_threshold,
 +	},
 +	{
 +		.procname	=3D "compact_unevictable_allowed",
 +		.data		=3D &sysctl_compact_unevictable_allowed,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax_warn_RT_change,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 =20
 -int proc_dointvec_ms_jiffies(struct ctl_table *table, int write,
 -			     void __user *buffer, size_t *lenp, loff_t *ppos)
 -{
 -	return -ENOSYS;
 -}
 +#endif /* CONFIG_COMPACTION */
 +	{
 +		.procname	=3D "min_free_kbytes",
 +		.data		=3D &min_free_kbytes,
 +		.maxlen		=3D sizeof(min_free_kbytes),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D min_free_kbytes_sysctl_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "watermark_boost_factor",
 +		.data		=3D &watermark_boost_factor,
 +		.maxlen		=3D sizeof(watermark_boost_factor),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "watermark_scale_factor",
 +		.data		=3D &watermark_scale_factor,
 +		.maxlen		=3D sizeof(watermark_scale_factor),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D watermark_scale_factor_sysctl_handler,
 +		.extra1		=3D SYSCTL_ONE,
 +		.extra2		=3D &one_thousand,
 +	},
 +	{
 +		.procname	=3D "percpu_pagelist_fraction",
 +		.data		=3D &percpu_pagelist_fraction,
 +		.maxlen		=3D sizeof(percpu_pagelist_fraction),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D percpu_pagelist_fraction_sysctl_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +#ifdef CONFIG_MMU
 +	{
 +		.procname	=3D "max_map_count",
 +		.data		=3D &sysctl_max_map_count,
 +		.maxlen		=3D sizeof(sysctl_max_map_count),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +#else
 +	{
 +		.procname	=3D "nr_trim_pages",
 +		.data		=3D &sysctl_nr_trim_pages,
 +		.maxlen		=3D sizeof(sysctl_nr_trim_pages),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +#endif
 +	{
 +		.procname	=3D "laptop_mode",
 +		.data		=3D &laptop_mode,
 +		.maxlen		=3D sizeof(laptop_mode),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_jiffies,
 +	},
 +	{
 +		.procname	=3D "block_dump",
 +		.data		=3D &block_dump,
 +		.maxlen		=3D sizeof(block_dump),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "vfs_cache_pressure",
 +		.data		=3D &sysctl_vfs_cache_pressure,
 +		.maxlen		=3D sizeof(sysctl_vfs_cache_pressure),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +#if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
 +    defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
 +	{
 +		.procname	=3D "legacy_va_layout",
 +		.data		=3D &sysctl_legacy_va_layout,
 +		.maxlen		=3D sizeof(sysctl_legacy_va_layout),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +#endif
 +#ifdef CONFIG_NUMA
 +	{
 +		.procname	=3D "zone_reclaim_mode",
 +		.data		=3D &node_reclaim_mode,
 +		.maxlen		=3D sizeof(node_reclaim_mode),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +	{
 +		.procname	=3D "min_unmapped_ratio",
 +		.data		=3D &sysctl_min_unmapped_ratio,
 +		.maxlen		=3D sizeof(sysctl_min_unmapped_ratio),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_min_unmapped_ratio_sysctl_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &one_hundred,
 +	},
 +	{
 +		.procname	=3D "min_slab_ratio",
 +		.data		=3D &sysctl_min_slab_ratio,
 +		.maxlen		=3D sizeof(sysctl_min_slab_ratio),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_min_slab_ratio_sysctl_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &one_hundred,
 +	},
 +#endif
 +#ifdef CONFIG_SMP
 +	{
 +		.procname	=3D "stat_interval",
 +		.data		=3D &sysctl_stat_interval,
 +		.maxlen		=3D sizeof(sysctl_stat_interval),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_jiffies,
 +	},
 +	{
 +		.procname	=3D "stat_refresh",
 +		.data		=3D NULL,
 +		.maxlen		=3D 0,
 +		.mode		=3D 0600,
 +		.proc_handler	=3D vmstat_refresh,
 +	},
 +#endif
 +#ifdef CONFIG_MMU
 +	{
 +		.procname	=3D "mmap_min_addr",
 +		.data		=3D &dac_mmap_min_addr,
 +		.maxlen		=3D sizeof(unsigned long),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D mmap_min_addr_handler,
 +	},
 +#endif
 +#ifdef CONFIG_NUMA
 +	{
 +		.procname	=3D "numa_zonelist_order",
 +		.data		=3D &numa_zonelist_order,
 +		.maxlen		=3D NUMA_ZONELIST_ORDER_LEN,
 +		.mode		=3D 0644,
 +		.proc_handler	=3D numa_zonelist_order_handler,
 +	},
 +#endif
 +#if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
 +   (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 +	{
 +		.procname	=3D "vdso_enabled",
 +#ifdef CONFIG_X86_32
 +		.data		=3D &vdso32_enabled,
 +		.maxlen		=3D sizeof(vdso32_enabled),
 +#else
 +		.data		=3D &vdso_enabled,
 +		.maxlen		=3D sizeof(vdso_enabled),
 +#endif
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +		.extra1		=3D SYSCTL_ZERO,
 +	},
 +#endif
 +#ifdef CONFIG_HIGHMEM
 +	{
 +		.procname	=3D "highmem_is_dirtyable",
 +		.data		=3D &vm_highmem_is_dirtyable,
 +		.maxlen		=3D sizeof(vm_highmem_is_dirtyable),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +#ifdef CONFIG_MEMORY_FAILURE
 +	{
 +		.procname	=3D "memory_failure_early_kill",
 +		.data		=3D &sysctl_memory_failure_early_kill,
 +		.maxlen		=3D sizeof(sysctl_memory_failure_early_kill),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "memory_failure_recovery",
 +		.data		=3D &sysctl_memory_failure_recovery,
 +		.maxlen		=3D sizeof(sysctl_memory_failure_recovery),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +	{
 +		.procname	=3D "user_reserve_kbytes",
 +		.data		=3D &sysctl_user_reserve_kbytes,
 +		.maxlen		=3D sizeof(sysctl_user_reserve_kbytes),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +	{
 +		.procname	=3D "admin_reserve_kbytes",
 +		.data		=3D &sysctl_admin_reserve_kbytes,
 +		.maxlen		=3D sizeof(sysctl_admin_reserve_kbytes),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +#ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
 +	{
 +		.procname	=3D "mmap_rnd_bits",
 +		.data		=3D &mmap_rnd_bits,
 +		.maxlen		=3D sizeof(mmap_rnd_bits),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D (void *)&mmap_rnd_bits_min,
 +		.extra2		=3D (void *)&mmap_rnd_bits_max,
 +	},
 +#endif
 +#ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
 +	{
 +		.procname	=3D "mmap_rnd_compat_bits",
 +		.data		=3D &mmap_rnd_compat_bits,
 +		.maxlen		=3D sizeof(mmap_rnd_compat_bits),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D (void *)&mmap_rnd_compat_bits_min,
 +		.extra2		=3D (void *)&mmap_rnd_compat_bits_max,
 +	},
 +#endif
 +#ifdef CONFIG_USERFAULTFD
 +	{
 +		.procname	=3D "unprivileged_userfaultfd",
 +		.data		=3D &sysctl_unprivileged_userfaultfd,
 +		.maxlen		=3D sizeof(sysctl_unprivileged_userfaultfd),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +	{ }
 +};
 =20
 -int proc_doulongvec_minmax(struct ctl_table *table, int write,
 -		    void __user *buffer, size_t *lenp, loff_t *ppos)
 -{
 -	return -ENOSYS;
 -}
 +static struct ctl_table fs_table[] =3D {
 +	{
 +		.procname	=3D "inode-nr",
 +		.data		=3D &inodes_stat,
 +		.maxlen		=3D 2*sizeof(long),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_nr_inodes,
 +	},
 +	{
 +		.procname	=3D "inode-state",
 +		.data		=3D &inodes_stat,
 +		.maxlen		=3D 7*sizeof(long),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_nr_inodes,
 +	},
 +	{
 +		.procname	=3D "file-nr",
 +		.data		=3D &files_stat,
 +		.maxlen		=3D sizeof(files_stat),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_nr_files,
 +	},
 +	{
 +		.procname	=3D "file-max",
 +		.data		=3D &files_stat.max_files,
 +		.maxlen		=3D sizeof(files_stat.max_files),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +		.extra1		=3D &zero_ul,
 +		.extra2		=3D &long_max,
 +	},
 +	{
 +		.procname	=3D "nr_open",
 +		.data		=3D &sysctl_nr_open,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &sysctl_nr_open_min,
 +		.extra2		=3D &sysctl_nr_open_max,
 +	},
 +	{
 +		.procname	=3D "dentry-state",
 +		.data		=3D &dentry_stat,
 +		.maxlen		=3D 6*sizeof(long),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_nr_dentry,
 +	},
 +	{
 +		.procname	=3D "overflowuid",
 +		.data		=3D &fs_overflowuid,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &minolduid,
 +		.extra2		=3D &maxolduid,
 +	},
 +	{
 +		.procname	=3D "overflowgid",
 +		.data		=3D &fs_overflowgid,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D &minolduid,
 +		.extra2		=3D &maxolduid,
 +	},
 +#ifdef CONFIG_FILE_LOCKING
 +	{
 +		.procname	=3D "leases-enable",
 +		.data		=3D &leases_enable,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_DNOTIFY
 +	{
 +		.procname	=3D "dir-notify-enable",
 +		.data		=3D &dir_notify_enable,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_MMU
 +#ifdef CONFIG_FILE_LOCKING
 +	{
 +		.procname	=3D "lease-break-time",
 +		.data		=3D &lease_break_time,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec,
 +	},
 +#endif
 +#ifdef CONFIG_AIO
 +	{
 +		.procname	=3D "aio-nr",
 +		.data		=3D &aio_nr,
 +		.maxlen		=3D sizeof(aio_nr),
 +		.mode		=3D 0444,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +	{
 +		.procname	=3D "aio-max-nr",
 +		.data		=3D &aio_max_nr,
 +		.maxlen		=3D sizeof(aio_max_nr),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +#endif /* CONFIG_AIO */
 +#ifdef CONFIG_INOTIFY_USER
 +	{
 +		.procname	=3D "inotify",
 +		.mode		=3D 0555,
 +		.child		=3D inotify_table,
 +	},
 +#endif=09
 +#ifdef CONFIG_EPOLL
 +	{
 +		.procname	=3D "epoll",
 +		.mode		=3D 0555,
 +		.child		=3D epoll_table,
 +	},
 +#endif
 +#endif
 +	{
 +		.procname	=3D "protected_symlinks",
 +		.data		=3D &sysctl_protected_symlinks,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "protected_hardlinks",
 +		.data		=3D &sysctl_protected_hardlinks,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +	{
 +		.procname	=3D "protected_fifos",
 +		.data		=3D &sysctl_protected_fifos,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &two,
 +	},
 +	{
 +		.procname	=3D "protected_regular",
 +		.data		=3D &sysctl_protected_regular,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0600,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &two,
 +	},
 +	{
 +		.procname	=3D "suid_dumpable",
 +		.data		=3D &suid_dumpable,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax_coredump,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &two,
 +	},
 +#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 +	{
 +		.procname	=3D "binfmt_misc",
 +		.mode		=3D 0555,
 +		.child		=3D sysctl_mount_point,
 +	},
 +#endif
 +	{
 +		.procname	=3D "pipe-max-size",
 +		.data		=3D &pipe_max_size,
 +		.maxlen		=3D sizeof(pipe_max_size),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dopipe_max_size,
 +	},
 +	{
 +		.procname	=3D "pipe-user-pages-hard",
 +		.data		=3D &pipe_user_pages_hard,
 +		.maxlen		=3D sizeof(pipe_user_pages_hard),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +	{
 +		.procname	=3D "pipe-user-pages-soft",
 +		.data		=3D &pipe_user_pages_soft,
 +		.maxlen		=3D sizeof(pipe_user_pages_soft),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_doulongvec_minmax,
 +	},
 +	{
 +		.procname	=3D "mount-max",
 +		.data		=3D &sysctl_mount_max,
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec_minmax,
 +		.extra1		=3D SYSCTL_ONE,
 +	},
 +	{ }
 +};
 =20
 -int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 -				      void __user *buffer,
 -				      size_t *lenp, loff_t *ppos)
 -{
 -    return -ENOSYS;
 -}
 +static struct ctl_table debug_table[] =3D {
 +#ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
 +	{
 +		.procname	=3D "exception-trace",
 +		.data		=3D &show_unhandled_signals,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_dointvec
 +	},
 +#endif
 +#if defined(CONFIG_OPTPROBES)
 +	{
 +		.procname	=3D "kprobes-optimization",
 +		.data		=3D &sysctl_kprobes_optimization,
 +		.maxlen		=3D sizeof(int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D proc_kprobes_optimization_handler,
 +		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D SYSCTL_ONE,
 +	},
 +#endif
 +	{ }
 +};
 =20
 -int proc_do_large_bitmap(struct ctl_table *table, int write,
 -			 void __user *buffer, size_t *lenp, loff_t *ppos)
 -{
 -	return -ENOSYS;
 -}
 +static struct ctl_table dev_table[] =3D {
 +	{ }
 +};
 =20
 -#endif /* CONFIG_PROC_SYSCTL */
 +static struct ctl_table sysctl_base_table[] =3D {
 +	{
 +		.procname	=3D "kernel",
 +		.mode		=3D 0555,
 +		.child		=3D kern_table,
 +	},
 +	{
 +		.procname	=3D "vm",
 +		.mode		=3D 0555,
 +		.child		=3D vm_table,
 +	},
 +	{
 +		.procname	=3D "fs",
 +		.mode		=3D 0555,
 +		.child		=3D fs_table,
 +	},
 +	{
 +		.procname	=3D "debug",
 +		.mode		=3D 0555,
 +		.child		=3D debug_table,
 +	},
 +	{
 +		.procname	=3D "dev",
 +		.mode		=3D 0555,
 +		.child		=3D dev_table,
 +	},
 +	{ }
 +};
 =20
 -#if defined(CONFIG_SYSCTL)
 -int proc_do_static_key(struct ctl_table *table, int write,
 -		       void __user *buffer, size_t *lenp,
 -		       loff_t *ppos)
 +int __init sysctl_init(void)
  {
 -	struct static_key *key =3D (struct static_key *)table->data;
 -	static DEFINE_MUTEX(static_key_mutex);
 -	int val, ret;
 -	struct ctl_table tmp =3D {
 -		.data   =3D &val,
 -		.maxlen =3D sizeof(val),
 -		.mode   =3D table->mode,
 -		.extra1 =3D SYSCTL_ZERO,
 -		.extra2 =3D SYSCTL_ONE,
 -	};
 -
 -	if (write && !capable(CAP_SYS_ADMIN))
 -		return -EPERM;
 +	struct ctl_table_header *hdr;
 =20
 -	mutex_lock(&static_key_mutex);
 -	val =3D static_key_enabled(key);
 -	ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 -	if (write && !ret) {
 -		if (val)
 -			static_key_enable(key);
 -		else
 -			static_key_disable(key);
 -	}
 -	mutex_unlock(&static_key_mutex);
 -	return ret;
 +	hdr =3D register_sysctl_table(sysctl_base_table);
 +	kmemleak_not_leak(hdr);
 +	return 0;
  }
 -#endif
 +#endif /* CONFIG_SYSCTL */
  /*
   * No sense putting this after each symbol definition, twice,
   * exception granted :-)

--Sig_/X_RG1RvHA.J/zrQZKg=Sl=/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6pInQACgkQAVBC80lX
0GyAbwf9HX0E5Z0SsM0/I1M4e1B0sVjucy7BPq32z/4iOcAzHoyP+BwQU8fJ0m95
6hmlxvaNXJHLXFyW7smUYHZ1g+e4jK2P+4gOKFB+gFwSztKogM6B0KLkXTZU5zLv
kTnT31OV2yRyV/EES6dTiS8AtOl1r7kdHJ4dGc7ndF1MMfgrYHQNgUJd5Ua3hvUk
9gLHYPCrO3fpEZI3Ma5D926FkbR8Zs0F7GPrWk+/7a3+a//Eew8Zx5csR7nJ3UAE
7rXGeEWzYjpsK49sp7g4BM3IyQ4vtaS2yddnxq11MV7cNCDYCIoOf1FznqxrKWvS
lvnrw1U6UxNC9ewBdhPskv5gP+QC/A==
=xHYk
-----END PGP SIGNATURE-----

--Sig_/X_RG1RvHA.J/zrQZKg=Sl=/--
