Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E30239AA81
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 20:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFCSyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 14:54:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:47420 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCSys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 14:54:48 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1losSg-000AtU-96; Thu, 03 Jun 2021 20:52:58 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1losSf-00099V-SP; Thu, 03 Jun 2021 20:52:57 +0200
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, jolsa@redhat.com,
        ast@kernel.org, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, torvalds@linux-foundation.org
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
 <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net>
 <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net>
 <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
 <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net>
 <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net>
Date:   Thu, 3 Jun 2021 20:52:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26190/Thu Jun  3 13:09:15 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/21 5:13 PM, Paul Moore wrote:
[...]
> Help me out here, is your answer that the access check can only be
> done at BPF program load time?  That isn't really a solution from a
> SELinux perspective as far as I'm concerned.

That is the current answer. The unfortunate irony is that 59438b46471a
("security,lockdown,selinux: implement SELinux lockdown") broke this in
the first place. W/o the SELinux hook implementation it would have been
working just fine at runtime, but given it's UAPI since quite a while
now, that ship has sailed.

> I understand the ideas I've tossed out aren't practical from a BPF
> perspective, but it would be nice if we could find something that does
> work.  Surely you BPF folks can think of some way to provide a
> runtime, not load time, check?

I did run this entire discussion by both of the other BPF co-maintainers
(Alexei, Andrii, CC'ed) and together we did further brainstorming on the
matter on how we could solve this, but couldn't find a sensible & clean
solution so far.

You could potentially track the programs in the sec blob and iff they have
been JITed fix up the jump targets via text_poke to a dummy handler for
those requiring it and such, but that's just entirely fragile, horrid and
broken.

Given users are actively hitting issues with already released kernels in
the wild, we concluded to fix the majority of the damage caused by commit
59438b46471a [concerning BPF at least, the rest done by Ondrej as I understand]
with the below fix that is shipping to Linus. This is a step in the right
direction for moving things forward regardless. With the hook at load
it's also not doing anything that is off with respect to the remainder
of lockdown hooks, so solving a policy change can be looked at from a
more broader/general scope given same applies to other users, too, iff
it's indeed the case that it turns out to be feasible. Anyway, I've
reflected an overall summary of the discussions also in the commit msg.

Thanks,
Daniel

---

[PATCH] bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks

Commit 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
added an implementation of the locked_down LSM hook to SELinux, with the aim
to restrict which domains are allowed to perform operations that would breach
lockdown. This is indirectly also getting audit subsystem involved to report
events. The latter is problematic, as reported by Ondrej and Serhei, since it
can bring down the whole system via audit:

   1) The audit events that are triggered due to calls to security_locked_down()
      can OOM kill a machine, see below details [0].

   2) It also seems to be causing a deadlock via avc_has_perm()/slow_avc_audit()
      when trying to wake up kauditd, for example, when using trace_sched_switch()
      tracepoint, see details in [1]. Triggering this was not via some hypothetical
      corner case, but with existing tools like runqlat & runqslower from bcc, for
      example, which make use of this tracepoint. Rough call sequence goes like:

      rq_lock(rq) -> -------------------------+
        trace_sched_switch() ->               |
          bpf_prog_xyz() ->                   +-> deadlock
            selinux_lockdown() ->             |
              audit_log_end() ->              |
                wake_up_interruptible() ->    |
                  try_to_wake_up() ->         |
                    rq_lock(rq) --------------+

What's worse is that the intention of 59438b46471a to further restrict lockdown
settings for specific applications in respect to the global lockdown policy is
completely broken for BPF. The SELinux policy rule for the current lockdown check
looks something like this:

   allow <who> <who> : lockdown { <reason> };

However, this doesn't match with the 'current' task where the security_locked_down()
is executed, example: httpd does a syscall. There is a tracing program attached
to the syscall which triggers a BPF program to run, which ends up doing a
bpf_probe_read_kernel{,_str}() helper call. The selinux_lockdown() hook does
the permission check against 'current', that is, httpd in this example. httpd
has literally zero relation to this tracing program, and it would be nonsensical
having to write an SELinux policy rule against httpd to let the tracing helper
pass. The policy in this case needs to be against the entity that is installing
the BPF program. For example, if bpftrace would generate a histogram of syscall
counts by user space application:

   bpftrace -e 'tracepoint:raw_syscalls:sys_enter { @[comm] = count(); }'

bpftrace would then go and generate a BPF program from this internally. One way
of doing it [for the sake of the example] could be to call bpf_get_current_task()
helper and then access current->comm via one of bpf_probe_read_kernel{,_str}()
helpers. So the program itself has nothing to do with httpd or any other random
app doing a syscall here. The BPF program _explicitly initiated_ the lockdown
check. The allow/deny policy belongs in the context of bpftrace: meaning, you
want to grant bpftrace access to use these helpers, but other tracers on the
system like my_random_tracer _not_.

Therefore fix all three issues at the same time by taking a completely different
approach for the security_locked_down() hook, that is, move the check into the
program verification phase where we actually retrieve the BPF func proto. This
also reliably gets the task (current) that is trying to install the BPF tracing
program, e.g. bpftrace/bcc/perf/systemtap/etc, and it also fixes the OOM since
we're moving this out of the BPF helper's fast-path which can be called several
millions of times per second.

The check is then also in line with other security_locked_down() hooks in the
system where the enforcement is performed at open/load time, for example,
open_kcore() for /proc/kcore access or module_sig_check() for module signatures
just to pick few random ones. What's out of scope in the fix as well as in
other security_locked_down() hook locations /outside/ of BPF subsystem is that
if the lockdown policy changes on the fly there is no retrospective action.
This requires a different discussion, potentially complex infrastructure, and
it's also not clear whether this can be solved generically. Either way, it is
out of scope for a suitable stable fix which this one is targeting. Note that
the breakage is specifically on 59438b46471a where it started to rely on 'current'
as UAPI behavior, and _not_ earlier infrastructure such as 9d1f8be5cf42 ("bpf:
Restrict bpf when kernel lockdown is in confidentiality mode").

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1955585, Jakub Hrozek says:

   I starting seeing this with F-34. When I run a container that is traced with
   BPF to record the syscalls it is doing, auditd is flooded with messages like:

   type=AVC msg=audit(1619784520.593:282387): avc:  denied  { confidentiality }
     for pid=476 comm="auditd" lockdown_reason="use of bpf to read kernel RAM"
       scontext=system_u:system_r:auditd_t:s0 tcontext=system_u:system_r:auditd_t:s0
         tclass=lockdown permissive=0

   This seems to be leading to auditd running out of space in the backlog buffer
   and eventually OOMs the machine.

   [...]
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
   [...]

[1] https://lore.kernel.org/linux-audit/CANYvDQN7H5tVp47fbYcRasv4XF07eUbsDwT_eDCHXJUj43J7jQ@mail.gmail.com/,
     Serhei Makarov says:

   Upstream kernel 5.11.0-rc7 and later was found to deadlock during a
   bpf_probe_read_compat() call within a sched_switch tracepoint. The problem
   is reproducible with the reg_alloc3 testcase from SystemTap's BPF backend
   testsuite on x86_64 as well as the runqlat, runqslower tools from bcc on
   ppc64le. Example stack trace:

   [...]
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
   [...]

Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Reported-by: Jakub Hrozek <jhrozek@redhat.com>
Reported-by: Serhei Makarov <smakarov@redhat.com>
Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Frank Eigler <fche@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/bpf/01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net
---
  kernel/bpf/helpers.c     |  7 +++++--
  kernel/trace/bpf_trace.c | 32 ++++++++++++--------------------
  2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 73443498d88f..a2f1f15ce432 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -14,6 +14,7 @@
  #include <linux/jiffies.h>
  #include <linux/pid_namespace.h>
  #include <linux/proc_ns.h>
+#include <linux/security.h>

  #include "../../lib/kstrtox.h"

@@ -1069,11 +1070,13 @@ bpf_base_func_proto(enum bpf_func_id func_id)
  	case BPF_FUNC_probe_read_user:
  		return &bpf_probe_read_user_proto;
  	case BPF_FUNC_probe_read_kernel:
-		return &bpf_probe_read_kernel_proto;
+		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		       NULL : &bpf_probe_read_kernel_proto;
  	case BPF_FUNC_probe_read_user_str:
  		return &bpf_probe_read_user_str_proto;
  	case BPF_FUNC_probe_read_kernel_str:
-		return &bpf_probe_read_kernel_str_proto;
+		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		       NULL : &bpf_probe_read_kernel_str_proto;
  	case BPF_FUNC_snprintf_btf:
  		return &bpf_snprintf_btf_proto;
  	case BPF_FUNC_snprintf:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d2d7cf6cfe83..7a52bc172841 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -215,16 +215,11 @@ const struct bpf_func_proto bpf_probe_read_user_str_proto = {
  static __always_inline int
  bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
  {
-	int ret = security_locked_down(LOCKDOWN_BPF_READ);
+	int ret;

-	if (unlikely(ret < 0))
-		goto fail;
  	ret = copy_from_kernel_nofault(dst, unsafe_ptr, size);
  	if (unlikely(ret < 0))
-		goto fail;
-	return ret;
-fail:
-	memset(dst, 0, size);
+		memset(dst, 0, size);
  	return ret;
  }

@@ -246,10 +241,7 @@ const struct bpf_func_proto bpf_probe_read_kernel_proto = {
  static __always_inline int
  bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
  {
-	int ret = security_locked_down(LOCKDOWN_BPF_READ);
-
-	if (unlikely(ret < 0))
-		goto fail;
+	int ret;

  	/*
  	 * The strncpy_from_kernel_nofault() call will likely not fill the
@@ -262,11 +254,7 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
  	 */
  	ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
  	if (unlikely(ret < 0))
-		goto fail;
-
-	return ret;
-fail:
-	memset(dst, 0, size);
+		memset(dst, 0, size);
  	return ret;
  }

@@ -1011,16 +999,20 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
  	case BPF_FUNC_probe_read_user:
  		return &bpf_probe_read_user_proto;
  	case BPF_FUNC_probe_read_kernel:
-		return &bpf_probe_read_kernel_proto;
+		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		       NULL : &bpf_probe_read_kernel_proto;
  	case BPF_FUNC_probe_read_user_str:
  		return &bpf_probe_read_user_str_proto;
  	case BPF_FUNC_probe_read_kernel_str:
-		return &bpf_probe_read_kernel_str_proto;
+		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		       NULL : &bpf_probe_read_kernel_str_proto;
  #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
  	case BPF_FUNC_probe_read:
-		return &bpf_probe_read_compat_proto;
+		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		       NULL : &bpf_probe_read_compat_proto;
  	case BPF_FUNC_probe_read_str:
-		return &bpf_probe_read_compat_str_proto;
+		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		       NULL : &bpf_probe_read_compat_str_proto;
  #endif
  #ifdef CONFIG_CGROUPS
  	case BPF_FUNC_get_current_cgroup_id:
-- 
2.21.0

