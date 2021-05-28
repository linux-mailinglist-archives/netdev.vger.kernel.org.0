Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53059394260
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhE1MQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:16:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:44424 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbhE1MPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:15:52 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmb4p-000BDI-9H; Fri, 28 May 2021 13:54:55 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmb4o-000HiG-Tf; Fri, 28 May 2021 13:54:54 +0200
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Jiri Olsa <jolsa@redhat.com>
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
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
 <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net> <YLDYV3ot7vroWW9o@krava>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e8a118dc-6b10-fefd-a9e1-75367f9b74a5@iogearbox.net>
Date:   Fri, 28 May 2021 13:54:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YLDYV3ot7vroWW9o@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26183/Thu May 27 13:07:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:47 PM, Jiri Olsa wrote:
> On Fri, May 28, 2021 at 11:56:02AM +0200, Daniel Borkmann wrote:
> 
>> Ondrej / Paul / Jiri: at least for the BPF tracing case specifically (I haven't looked
>> at the rest but it's also kind of independent), the attached fix should address both
>> reported issues, please take a look & test.
>>
>> Thanks a lot,
>> Daniel
> 
>>  From 5893ad528dc0a0a68933b8f2a81b18d3f539660d Mon Sep 17 00:00:00 2001
>> From: Daniel Borkmann <daniel@iogearbox.net>
>> Date: Fri, 28 May 2021 09:16:31 +0000
>> Subject: [PATCH bpf] bpf, audit, lockdown: Fix bogus SELinux lockdown permission checks
>>
>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
>> added an implementation of the locked_down LSM hook to SELinux, with the aim
>> to restrict which domains are allowed to perform operations that would breach
>> lockdown. This is indirectly also getting audit subsystem involved to report
>> events. The latter is problematic, as reported by Ondrej and Serhei, since it
>> can bring down the whole system via audit:
>>
>>    i) The audit events that are triggered due to calls to security_locked_down()
>>       can OOM kill a machine, see below details [0].
>>
>>   ii) It seems to be causing a deadlock via slow_avc_audit() -> audit_log_end()
>>       when presumingly trying to wake up kauditd [1].
>>
>> Fix both at the same time by taking a completely different approach, that is,
>> move the check into the program verification phase where we actually retrieve
>> the func proto. This also reliably gets the task (current) that is trying to
>> install the tracing program, e.g. bpftrace/bcc/perf/systemtap/etc, and it also
>> fixes the OOM since we're moving this out of the BPF helpers which can be called
>> millions of times per second.
>>
>> [0] https://bugzilla.redhat.com/show_bug.cgi?id=1955585, Jakub Hrozek says:
>>
>>    I starting seeing this with F-34. When I run a container that is traced with
>>    BPF to record the syscalls it is doing, auditd is flooded with messages like:
>>
>>    type=AVC msg=audit(1619784520.593:282387): avc:  denied  { confidentiality }
>>      for pid=476 comm="auditd" lockdown_reason="use of bpf to read kernel RAM"
>>        scontext=system_u:system_r:auditd_t:s0 tcontext=system_u:system_r:auditd_t:s0
>>          tclass=lockdown permissive=0
>>
>>    This seems to be leading to auditd running out of space in the backlog buffer
>>    and eventually OOMs the machine.
>>
>>    [...]
>>    auditd running at 99% CPU presumably processing all the messages, eventually I get:
>>    Apr 30 12:20:42 fedora kernel: audit: backlog limit exceeded
>>    Apr 30 12:20:42 fedora kernel: audit: backlog limit exceeded
>>    Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152579 > audit_backlog_limit=64
>>    Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152626 > audit_backlog_limit=64
>>    Apr 30 12:20:42 fedora kernel: audit: audit_backlog=2152694 > audit_backlog_limit=64
>>    Apr 30 12:20:42 fedora kernel: audit: audit_lost=6878426 audit_rate_limit=0 audit_backlog_limit=64
>>    Apr 30 12:20:45 fedora kernel: oci-seccomp-bpf invoked oom-killer: gfp_mask=0x100cca(GFP_HIGHUSER_MOVABLE), order=0, oom_score_adj=-1000
>>    Apr 30 12:20:45 fedora kernel: CPU: 0 PID: 13284 Comm: oci-seccomp-bpf Not tainted 5.11.12-300.fc34.x86_64 #1
>>    Apr 30 12:20:45 fedora kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
>>    [...]
>>
>> [1] https://lore.kernel.org/linux-audit/CANYvDQN7H5tVp47fbYcRasv4XF07eUbsDwT_eDCHXJUj43J7jQ@mail.gmail.com/,
>>      Serhei Makarov says:
>>
>>    Upstream kernel 5.11.0-rc7 and later was found to deadlock during a
>>    bpf_probe_read_compat() call within a sched_switch tracepoint. The problem
>>    is reproducible with the reg_alloc3 testcase from SystemTap's BPF backend
>>    testsuite on x86_64 as well as the runqlat,runqslower tools from bcc on
>>    ppc64le. Example stack trace:
>>
>>    [...]
>>    [  730.868702] stack backtrace:
>>    [  730.869590] CPU: 1 PID: 701 Comm: in:imjournal Not tainted, 5.12.0-0.rc2.20210309git144c79ef3353.166.fc35.x86_64 #1
>>    [  730.871605] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
>>    [  730.873278] Call Trace:
>>    [  730.873770]  dump_stack+0x7f/0xa1
>>    [  730.874433]  check_noncircular+0xdf/0x100
>>    [  730.875232]  __lock_acquire+0x1202/0x1e10
>>    [  730.876031]  ? __lock_acquire+0xfc0/0x1e10
>>    [  730.876844]  lock_acquire+0xc2/0x3a0
>>    [  730.877551]  ? __wake_up_common_lock+0x52/0x90
>>    [  730.878434]  ? lock_acquire+0xc2/0x3a0
>>    [  730.879186]  ? lock_is_held_type+0xa7/0x120
>>    [  730.880044]  ? skb_queue_tail+0x1b/0x50
>>    [  730.880800]  _raw_spin_lock_irqsave+0x4d/0x90
>>    [  730.881656]  ? __wake_up_common_lock+0x52/0x90
>>    [  730.882532]  __wake_up_common_lock+0x52/0x90
>>    [  730.883375]  audit_log_end+0x5b/0x100
>>    [  730.884104]  slow_avc_audit+0x69/0x90
>>    [  730.884836]  avc_has_perm+0x8b/0xb0
>>    [  730.885532]  selinux_lockdown+0xa5/0xd0
>>    [  730.886297]  security_locked_down+0x20/0x40
>>    [  730.887133]  bpf_probe_read_compat+0x66/0xd0
>>    [  730.887983]  bpf_prog_250599c5469ac7b5+0x10f/0x820
>>    [  730.888917]  trace_call_bpf+0xe9/0x240
>>    [  730.889672]  perf_trace_run_bpf_submit+0x4d/0xc0
>>    [  730.890579]  perf_trace_sched_switch+0x142/0x180
>>    [  730.891485]  ? __schedule+0x6d8/0xb20
>>    [  730.892209]  __schedule+0x6d8/0xb20
>>    [  730.892899]  schedule+0x5b/0xc0
>>    [  730.893522]  exit_to_user_mode_prepare+0x11d/0x240
>>    [  730.894457]  syscall_exit_to_user_mode+0x27/0x70
>>    [  730.895361]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>    [...]
>>
>> Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
>> Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
>> Reported-by: Jakub Hrozek <jhrozek@redhat.com>
>> Reported-by: Serhei Makarov <smakarov@redhat.com>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Stephen Smalley <sds@tycho.nsa.gov>
>> Cc: Jerome Marchand <jmarchan@redhat.com>
>> Cc: Frank Eigler <fche@redhat.com>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Paul Moore <paul@paul-moore.com>
> 
> found the original server and reproduced.. this patch fixes it for me
> 
> Tested-by: Jiri Olsa <jolsa@redhat.com>

Thanks Jiri! If Paul is fine with this as well, I can later route this fix via
bpf tree.

Best,
Daniel
