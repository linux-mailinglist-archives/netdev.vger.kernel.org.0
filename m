Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5435393D7C
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 09:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhE1HLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 03:11:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:43568 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhE1HLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 03:11:37 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmWd4-0004Br-Bp; Fri, 28 May 2021 09:09:58 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmWd4-000WOo-1p; Fri, 28 May 2021 09:09:58 +0200
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, jolsa@redhat.com
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
Date:   Fri, 28 May 2021 09:09:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26183/Thu May 27 13:07:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 3:37 AM, Paul Moore wrote:
> On Mon, May 17, 2021 at 5:22 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>>
>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
>> lockdown") added an implementation of the locked_down LSM hook to
>> SELinux, with the aim to restrict which domains are allowed to perform
>> operations that would breach lockdown.
>>
>> However, in several places the security_locked_down() hook is called in
>> situations where the current task isn't doing any action that would
>> directly breach lockdown, leading to SELinux checks that are basically
>> bogus.
>>
>> Since in most of these situations converting the callers such that
>> security_locked_down() is called in a context where the current task
>> would be meaningful for SELinux is impossible or very non-trivial (and
>> could lead to TOCTOU issues for the classic Lockdown LSM
>> implementation), fix this by modifying the hook to accept a struct cred
>> pointer as argument, where NULL will be interpreted as a request for a
>> "global", task-independent lockdown decision only. Then modify SELinux
>> to ignore calls with cred == NULL.
> 
> I'm not overly excited about skipping the access check when cred is
> NULL.  Based on the description and the little bit that I've dug into
> thus far it looks like using SECINITSID_KERNEL as the subject would be
> much more appropriate.  *Something* (the kernel in most of the
> relevant cases it looks like) is requesting that a potentially
> sensitive disclosure be made, and ignoring it seems like the wrong
> thing to do.  Leaving the access control intact also provides a nice
> avenue to audit these requests should users want to do that.

I think the rationale/workaround for ignoring calls with cred == NULL (or the previous
patch with the unimplemented hook) from Ondrej was two-fold, at least speaking for his
seen tracing cases:

   i) The audit events that are triggered due to calls to security_locked_down()
      can OOM kill a machine, see below details [0].

  ii) It seems to be causing a deadlock via slow_avc_audit() -> audit_log_end()
      when presumingly trying to wake up kauditd [1].

How would your suggestion above solve both i) and ii)?

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1955585 :

   I starting seeing this with F-34. When I run a container that is traced with eBPF
   to record the syscalls it is doing, auditd is flooded with messages like:

   type=AVC msg=audit(1619784520.593:282387): avc:  denied  { confidentiality } for
    pid=476 comm="auditd" lockdown_reason="use of bpf to read kernel RAM"
     scontext=system_u:system_r:auditd_t:s0 tcontext=system_u:system_r:auditd_t:s0 tclass=lockdown permissive=0

   This seems to be leading to auditd running out of space in the backlog buffer and
   eventually OOMs the machine.

   auditd running at 99% CPU presumably processing all the messages, eventually I get:
   Apr 30 12:20:42 fedora kernel: audit: backlog limit exceeded
   Apr 30 12:20:42 fedora kernel: audit: backlog limit exceeded
   Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152579 > audit_backlog_limit=64
   Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152626 > audit_backlog_limit=64
   Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152694 > audit_backlog_limit=64
   Apr 30 12:20:42 fedora kernel: audit: audit_lost=6878426 audit_rate_limit=0 audit_backlog_limit=64
   Apr 30 12:20:45 fedora kernel: oci-seccomp-bpf invoked oom-killer: gfp_mask=0x100cca(GFP_HIGHUSER_MOVABLE), order=0, oom_score_adj=-1000
   Apr 30 12:20:45 fedora kernel: CPU: 0 PID: 13284 Comm: oci-seccomp-bpf Not tainted 5.11.12-300.fc34.x86_64 #1
   Apr 30 12:20:45 fedora kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014

[1] https://lore.kernel.org/linux-audit/CANYvDQN7H5tVp47fbYcRasv4XF07eUbsDwT_eDCHXJUj43J7jQ@mail.gmail.com/ :

   Upstream kernel 5.11.0-rc7 and later was found to deadlock during a bpf_probe_read_compat()
   call within a sched_switch tracepoint. The problem is reproducible with the reg_alloc3
   testcase from SystemTap's BPF backend testsuite on x86_64 as well as the runqlat,runqslower
   tools from bcc on ppc64le. Example stack trace from [1]:

   [  730.868702] stack backtrace:
   [  730.869590] CPU: 1 PID: 701 Comm: in:imjournal Not tainted, 5.12.0-0.rc2.20210309git144c79ef3353.166.fc35.x86_64 #1
   [  730.871605] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
   [  730.873278] Call Trace:
   [  730.873770]  dump_stack+0x7f/0xa1
   [  730.874433]  check_noncircular+0xdf/0x100
   [  730.875232]  __lock_acquire+0x1202/0x1e10
   [  730.876031]  ? __lock_acquire+0xfc0/0x1e10
   [  730.876844]  lock_acquire+0xc2/0x3a0
   [  730.877551]  ? __wake_up_common_lock+0x52/0x90
   [  730.878434]  ? lock_acquire+0xc2/0x3a0
   [  730.879186]  ? lock_is_held_type+0xa7/0x120
   [  730.880044]  ? skb_queue_tail+0x1b/0x50
   [  730.880800]  _raw_spin_lock_irqsave+0x4d/0x90
   [  730.881656]  ? __wake_up_common_lock+0x52/0x90
   [  730.882532]  __wake_up_common_lock+0x52/0x90
   [  730.883375]  audit_log_end+0x5b/0x100
   [  730.884104]  slow_avc_audit+0x69/0x90
   [  730.884836]  avc_has_perm+0x8b/0xb0
   [  730.885532]  selinux_lockdown+0xa5/0xd0
   [  730.886297]  security_locked_down+0x20/0x40
   [  730.887133]  bpf_probe_read_compat+0x66/0xd0
   [  730.887983]  bpf_prog_250599c5469ac7b5+0x10f/0x820
   [  730.888917]  trace_call_bpf+0xe9/0x240
   [  730.889672]  perf_trace_run_bpf_submit+0x4d/0xc0
   [  730.890579]  perf_trace_sched_switch+0x142/0x180
   [  730.891485]  ? __schedule+0x6d8/0xb20
   [  730.892209]  __schedule+0x6d8/0xb20
   [  730.892899]  schedule+0x5b/0xc0
   [  730.893522]  exit_to_user_mode_prepare+0x11d/0x240
   [  730.894457]  syscall_exit_to_user_mode+0x27/0x70
   [  730.895361]  entry_SYSCALL_64_after_hwframe+0x44/0xae

>> Since most callers will just want to pass current_cred() as the cred
>> parameter, rename the hook to security_cred_locked_down() and provide
>> the original security_locked_down() function as a simple wrapper around
>> the new hook.
[...]
> 
>> 3. kernel/trace/bpf_trace.c:bpf_probe_read_kernel{,_str}_common()
>>       Called when a BPF program calls a helper that could leak kernel
>>       memory. The task context is not relevant here, since the program
>>       may very well be run in the context of a different task than the
>>       consumer of the data.
>>       See: https://bugzilla.redhat.com/show_bug.cgi?id=1955585
> 
> The access control check isn't so much who is consuming the data, but
> who is requesting a potential violation of a "lockdown", yes?  For
> example, the SELinux policy rule for the current lockdown check looks
> something like this:
> 
>    allow <who> <who> : lockdown { <reason> };
> 
> It seems to me that the task context is relevant here and performing
> the access control check based on the task's domain is correct.
This doesn't make much sense to me, it's /not/ the task 'requesting a potential
violation of a "lockdown"', but rather the running tracing program which is e.g.
inspecting kernel data structures around the triggered event. If I understood
you correctly, having an 'allow' check on, say, httpd would be rather odd since
things like perf/bcc/bpftrace/systemtap/etc is installing the tracing probe instead.

Meaning, if we would /not/ trace such events (like in the prior mentioned syscall
example), then there is also no call to the security_locked_down() from that same/
unmodified application.

Thanks,
Daniel
