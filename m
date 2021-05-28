Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E92394227
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 13:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhE1Lt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 07:49:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236119AbhE1LtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 07:49:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622202464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JdNPT60WeIlr9DU58kYYVhqhWBLJtqZ96yO8cbacEw8=;
        b=Dx654HFaDRNkQkwpNSWxSH51BQjXviziKggiDlp6AhmNpNdQkZ0wgWmM7l7R8dzwQ55NQd
        bBCRSX/1d31iKeOO7bVGLtfmigBu0Cx6EMtawSf7nf/EJswGMFIqXVXNLb46Dk3jxSjkuP
        LT/uiJyhRBZntYpvh/CwWBG0nTemPl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-J-MsoSSLN76i5GJLOqfRSg-1; Fri, 28 May 2021 07:47:42 -0400
X-MC-Unique: J-MsoSSLN76i5GJLOqfRSg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37E4E802938;
        Fri, 28 May 2021 11:47:41 +0000 (UTC)
Received: from krava (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with SMTP id 291805D767;
        Fri, 28 May 2021 11:47:35 +0000 (UTC)
Date:   Fri, 28 May 2021 13:47:35 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
Message-ID: <YLDYV3ot7vroWW9o@krava>
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
 <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 11:56:02AM +0200, Daniel Borkmann wrote:

SNIP

> Ondrej / Paul / Jiri: at least for the BPF tracing case specifically (I haven't looked
> at the rest but it's also kind of independent), the attached fix should address both
> reported issues, please take a look & test.
> 
> Thanks a lot,
> Daniel

> From 5893ad528dc0a0a68933b8f2a81b18d3f539660d Mon Sep 17 00:00:00 2001
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Fri, 28 May 2021 09:16:31 +0000
> Subject: [PATCH bpf] bpf, audit, lockdown: Fix bogus SELinux lockdown permission checks
> 
> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> added an implementation of the locked_down LSM hook to SELinux, with the aim
> to restrict which domains are allowed to perform operations that would breach
> lockdown. This is indirectly also getting audit subsystem involved to report
> events. The latter is problematic, as reported by Ondrej and Serhei, since it
> can bring down the whole system via audit:
> 
>   i) The audit events that are triggered due to calls to security_locked_down()
>      can OOM kill a machine, see below details [0].
> 
>  ii) It seems to be causing a deadlock via slow_avc_audit() -> audit_log_end()
>      when presumingly trying to wake up kauditd [1].
> 
> Fix both at the same time by taking a completely different approach, that is,
> move the check into the program verification phase where we actually retrieve
> the func proto. This also reliably gets the task (current) that is trying to
> install the tracing program, e.g. bpftrace/bcc/perf/systemtap/etc, and it also
> fixes the OOM since we're moving this out of the BPF helpers which can be called
> millions of times per second.
> 
> [0] https://bugzilla.redhat.com/show_bug.cgi?id=1955585, Jakub Hrozek says:
> 
>   I starting seeing this with F-34. When I run a container that is traced with
>   BPF to record the syscalls it is doing, auditd is flooded with messages like:
> 
>   type=AVC msg=audit(1619784520.593:282387): avc:  denied  { confidentiality }
>     for pid=476 comm="auditd" lockdown_reason="use of bpf to read kernel RAM"
>       scontext=system_u:system_r:auditd_t:s0 tcontext=system_u:system_r:auditd_t:s0
>         tclass=lockdown permissive=0
> 
>   This seems to be leading to auditd running out of space in the backlog buffer
>   and eventually OOMs the machine.
> 
>   [...]
>   auditd running at 99% CPU presumably processing all the messages, eventually I get:
>   Apr 30 12:20:42 fedora kernel: audit: backlog limit exceeded
>   Apr 30 12:20:42 fedora kernel: audit: backlog limit exceeded
>   Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152579 > audit_backlog_limit=64
>   Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152626 > audit_backlog_limit=64
>   Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152694 > audit_backlog_limit=64
>   Apr 30 12:20:42 fedora kernel: audit: audit_lost=6878426 audit_rate_limit=0 audit_backlog_limit=64
>   Apr 30 12:20:45 fedora kernel: oci-seccomp-bpf invoked oom-killer: gfp_mask=0x100cca(GFP_HIGHUSER_MOVABLE), order=0, oom_score_adj=-1000
>   Apr 30 12:20:45 fedora kernel: CPU: 0 PID: 13284 Comm: oci-seccomp-bpf Not tainted 5.11.12-300.fc34.x86_64 #1
>   Apr 30 12:20:45 fedora kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
>   [...]
> 
> [1] https://lore.kernel.org/linux-audit/CANYvDQN7H5tVp47fbYcRasv4XF07eUbsDwT_eDCHXJUj43J7jQ@mail.gmail.com/,
>     Serhei Makarov says:
> 
>   Upstream kernel 5.11.0-rc7 and later was found to deadlock during a
>   bpf_probe_read_compat() call within a sched_switch tracepoint. The problem
>   is reproducible with the reg_alloc3 testcase from SystemTap's BPF backend
>   testsuite on x86_64 as well as the runqlat,runqslower tools from bcc on
>   ppc64le. Example stack trace:
> 
>   [...]
>   [  730.868702] stack backtrace:
>   [  730.869590] CPU: 1 PID: 701 Comm: in:imjournal Not tainted, 5.12.0-0.rc2.20210309git144c79ef3353.166.fc35.x86_64 #1
>   [  730.871605] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
>   [  730.873278] Call Trace:
>   [  730.873770]  dump_stack+0x7f/0xa1
>   [  730.874433]  check_noncircular+0xdf/0x100
>   [  730.875232]  __lock_acquire+0x1202/0x1e10
>   [  730.876031]  ? __lock_acquire+0xfc0/0x1e10
>   [  730.876844]  lock_acquire+0xc2/0x3a0
>   [  730.877551]  ? __wake_up_common_lock+0x52/0x90
>   [  730.878434]  ? lock_acquire+0xc2/0x3a0
>   [  730.879186]  ? lock_is_held_type+0xa7/0x120
>   [  730.880044]  ? skb_queue_tail+0x1b/0x50
>   [  730.880800]  _raw_spin_lock_irqsave+0x4d/0x90
>   [  730.881656]  ? __wake_up_common_lock+0x52/0x90
>   [  730.882532]  __wake_up_common_lock+0x52/0x90
>   [  730.883375]  audit_log_end+0x5b/0x100
>   [  730.884104]  slow_avc_audit+0x69/0x90
>   [  730.884836]  avc_has_perm+0x8b/0xb0
>   [  730.885532]  selinux_lockdown+0xa5/0xd0
>   [  730.886297]  security_locked_down+0x20/0x40
>   [  730.887133]  bpf_probe_read_compat+0x66/0xd0
>   [  730.887983]  bpf_prog_250599c5469ac7b5+0x10f/0x820
>   [  730.888917]  trace_call_bpf+0xe9/0x240
>   [  730.889672]  perf_trace_run_bpf_submit+0x4d/0xc0
>   [  730.890579]  perf_trace_sched_switch+0x142/0x180
>   [  730.891485]  ? __schedule+0x6d8/0xb20
>   [  730.892209]  __schedule+0x6d8/0xb20
>   [  730.892899]  schedule+0x5b/0xc0
>   [  730.893522]  exit_to_user_mode_prepare+0x11d/0x240
>   [  730.894457]  syscall_exit_to_user_mode+0x27/0x70
>   [  730.895361]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>   [...]
> 
> Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
> Reported-by: Jakub Hrozek <jhrozek@redhat.com>
> Reported-by: Serhei Makarov <smakarov@redhat.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Jerome Marchand <jmarchan@redhat.com>
> Cc: Frank Eigler <fche@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul Moore <paul@paul-moore.com>

found the original server and reproduced.. this patch fixes it for me 

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
>  kernel/bpf/helpers.c     |  6 ++++--
>  kernel/trace/bpf_trace.c | 36 +++++++++++++-----------------------
>  2 files changed, 17 insertions(+), 25 deletions(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 73443498d88f..6f6e090c5310 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1069,11 +1069,13 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>  	case BPF_FUNC_probe_read_user:
>  		return &bpf_probe_read_user_proto;
>  	case BPF_FUNC_probe_read_kernel:
> -		return &bpf_probe_read_kernel_proto;
> +		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
> +		       NULL : &bpf_probe_read_kernel_proto;
>  	case BPF_FUNC_probe_read_user_str:
>  		return &bpf_probe_read_user_str_proto;
>  	case BPF_FUNC_probe_read_kernel_str:
> -		return &bpf_probe_read_kernel_str_proto;
> +		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
> +		       NULL : &bpf_probe_read_kernel_str_proto;
>  	case BPF_FUNC_snprintf_btf:
>  		return &bpf_snprintf_btf_proto;
>  	case BPF_FUNC_snprintf:
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d2d7cf6cfe83..3df43d89d642 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -215,16 +215,10 @@ const struct bpf_func_proto bpf_probe_read_user_str_proto = {
>  static __always_inline int
>  bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
>  {
> -	int ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	int ret = copy_from_kernel_nofault(dst, unsafe_ptr, size);
>  
>  	if (unlikely(ret < 0))
> -		goto fail;
> -	ret = copy_from_kernel_nofault(dst, unsafe_ptr, size);
> -	if (unlikely(ret < 0))
> -		goto fail;
> -	return ret;
> -fail:
> -	memset(dst, 0, size);
> +		memset(dst, 0, size);
>  	return ret;
>  }
>  
> @@ -246,11 +240,6 @@ const struct bpf_func_proto bpf_probe_read_kernel_proto = {
>  static __always_inline int
>  bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
>  {
> -	int ret = security_locked_down(LOCKDOWN_BPF_READ);
> -
> -	if (unlikely(ret < 0))
> -		goto fail;
> -
>  	/*
>  	 * The strncpy_from_kernel_nofault() call will likely not fill the
>  	 * entire buffer, but that's okay in this circumstance as we're probing
> @@ -260,13 +249,10 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
>  	 * code altogether don't copy garbage; otherwise length of string
>  	 * is returned that can be used for bpf_perf_event_output() et al.
>  	 */
> -	ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
> -	if (unlikely(ret < 0))
> -		goto fail;
> +	int ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
>  
> -	return ret;
> -fail:
> -	memset(dst, 0, size);
> +	if (unlikely(ret < 0))
> +		memset(dst, 0, size);
>  	return ret;
>  }
>  
> @@ -1011,16 +997,20 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  	case BPF_FUNC_probe_read_user:
>  		return &bpf_probe_read_user_proto;
>  	case BPF_FUNC_probe_read_kernel:
> -		return &bpf_probe_read_kernel_proto;
> +		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
> +		       NULL : &bpf_probe_read_kernel_proto;
>  	case BPF_FUNC_probe_read_user_str:
>  		return &bpf_probe_read_user_str_proto;
>  	case BPF_FUNC_probe_read_kernel_str:
> -		return &bpf_probe_read_kernel_str_proto;
> +		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
> +		       NULL : &bpf_probe_read_kernel_str_proto;
>  #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>  	case BPF_FUNC_probe_read:
> -		return &bpf_probe_read_compat_proto;
> +		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
> +		       NULL : &bpf_probe_read_compat_proto;
>  	case BPF_FUNC_probe_read_str:
> -		return &bpf_probe_read_compat_str_proto;
> +		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
> +		       NULL : &bpf_probe_read_compat_str_proto;
>  #endif
>  #ifdef CONFIG_CGROUPS
>  	case BPF_FUNC_get_current_cgroup_id:
> -- 
> 2.27.0
> 

