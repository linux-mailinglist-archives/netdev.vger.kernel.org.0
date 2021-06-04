Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3C339BF41
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhFDSEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:04:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:34066 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhFDSEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:04:30 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lpE9V-000Frm-JT; Fri, 04 Jun 2021 20:02:37 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lpE9V-000LkL-7b; Fri, 04 Jun 2021 20:02:37 +0200
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
        kuba@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
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
 <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net>
 <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c59743f6-0000-1b15-bc16-ff761b443aef@iogearbox.net>
Date:   Fri, 4 Jun 2021 20:02:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26191/Fri Jun  4 13:07:45 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/21 6:50 AM, Paul Moore wrote:
> On Thu, Jun 3, 2021 at 2:53 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
[...]
>> I did run this entire discussion by both of the other BPF co-maintainers
>> (Alexei, Andrii, CC'ed) and together we did further brainstorming on the
>> matter on how we could solve this, but couldn't find a sensible & clean
>> solution so far.
> 
> Before I jump into the patch below I just want to say that I
> appreciate you looking into solutions on the BPF side of things.
> However, I voted "no" on this patch previously and since you haven't
> really changed it, my "no"/NACK vote remains, at least until we
> exhaust a few more options.

Just to set the record straight, you previously did neither ACK nor NACK it. And
again, as summarized earlier, this patch is _fixing_ the majority of the damage
caused by 59438b46471a for at least the BPF side of things where users run into this,
Ondrej the rest. Everything else can be discussed on top, and so far it seems there
is no clean solution in front of us either, not even speaking of one that is small
and suitable for _stable_ trees. Let me reiterate where we are: it's not that the
original implementation in 9d1f8be5cf42 ("bpf: Restrict bpf when kernel lockdown is
in confidentiality mode") was broken, it's that the later added _SELinux_ locked_down
hook implementation that is broken, and not other LSMs. Now you're trying to retrofittingly
ask us for hacks at all costs just because of /a/ broken LSM implementation. Maybe
another avenue is to just swallow the pill and revert 59438b46471a since it made
assumptions that don't work /generally/. And the use case for an application runtime
policy change in particular in case of lockdown where users only have 3 choices is
extremely tiny/rare, if it's not then something is very wrong in your deployment.
Let me ask you this ... are you also planning to address *all* the other cases inside
the kernel? If your answer is no, then this entire discussion is pointless.

>> [PATCH] bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks
>>
>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
>> added an implementation of the locked_down LSM hook to SELinux, with the aim
>> to restrict which domains are allowed to perform operations that would breach
>> lockdown. This is indirectly also getting audit subsystem involved to report
>> events. The latter is problematic, as reported by Ondrej and Serhei, since it
>> can bring down the whole system via audit:
>>
>>     1) The audit events that are triggered due to calls to security_locked_down()
>>        can OOM kill a machine, see below details [0].
>>
>>     2) It also seems to be causing a deadlock via avc_has_perm()/slow_avc_audit()
>>        when trying to wake up kauditd, for example, when using trace_sched_switch()
>>        tracepoint, see details in [1]. Triggering this was not via some hypothetical
>>        corner case, but with existing tools like runqlat & runqslower from bcc, for
>>        example, which make use of this tracepoint. Rough call sequence goes like:
>>
>>        rq_lock(rq) -> -------------------------+
>>          trace_sched_switch() ->               |
>>            bpf_prog_xyz() ->                   +-> deadlock
>>              selinux_lockdown() ->             |
>>                audit_log_end() ->              |
>>                  wake_up_interruptible() ->    |
>>                    try_to_wake_up() ->         |
>>                      rq_lock(rq) --------------+
> 
> Since BPF is a bit of chaotic nightmare in the sense that it basically
> out-of-tree kernel code that can be called from anywhere and do pretty
> much anything; it presents quite the challenge for those of us worried
> about LSM access controls.

There is no need to generalize ... for those worried, BPF subsystem has LSM access
controls for the syscall since 2017 via afdb09c720b6 ("security: bpf: Add LSM hooks
for bpf object related syscall").

[...]
> So let's look at this from a different angle.  Let's look at the two
> problems you mention above.
> 
> If we start with the runqueue deadlock we see the main problem is that
> audit_log_end() pokes the kauditd_wait waitqueue to ensure the
> kauditd_thread thread wakes up and processes the audit queue.  The
> audit_log_start() function does something similar, but it is
> conditional on a number of factors and isn't as likely to be hit.  If
> we relocate these kauditd wakeup calls we can remove the deadlock in
> trace_sched_switch().  In the case of CONFIG_AUDITSYSCALL=y we can
> probably just move the wakeup to __audit_syscall_exit() and in the
> case of CONFIG_AUDITSYSCALL=n we can likely just change the
> wait_event_freezable() call in kauditd_thread to a
> wait_event_freezable_timeout() call with a HZ timeout (the audit
> stream will be much less on these systems anyway so a queue overflow
> is much less likely).  I'm building a kernel with these changes now, I
> should have something to test when I wake up tomorrow morning.  It
> might even provide a bit of a performance boost as we would only be
> calling a wakeup function once for each syscall.

As other SELinux developers like Ondrej already pointed out to you in
this thread:

   Actually, I wasn't aware of the deadlock... But calling an LSM hook
   [that is backed by a SELinux access check] from within a BPF helper
   is calling for all kinds of trouble, so I'm not surprised

This is _generally_ a bad idea since it will potentially blow up in
random ways. A _simple_ on/off switch like lockdown_is_locked_down()
did was okayish (maybe modulo the pr_notice() which should rather have
been a pr_notice_ratelimited() when this is potentially called Mio
of times per sec worst case), but everything else is, again, just
asking for trouble now and/or in future when folks extend the SELinux
backend implementation or add a locked_down hook to other LSMs. That
59438b46471a was missing it was the first proof of exactly this, and
other LSMs will run into the same. Similarly for relying on 'current'
given it works on /some/ of the security_locked_down() call-sites /but
not others/. No matter from which angle you look at it, calling a LSM
hook from a helper is just plain broken.

> The other issue is related to security_locked_down() and using the
> right subject for the access control check.  As has been pointed out
> several times in this thread, the current code uses the current() task
> as the subject, which is arguably incorrect for many of the BPF helper
> functions.  In the case of BPF, we have talked about using the
> credentials of the task which loaded the BPF program instead of
> current(), and that does make a certain amount of sense.  Such an
> approach should make the security policy easier to develop and
> rationalize, leading to a significant decrease in audit records coming
> from LSM access denials.  The question is how to implement such a
> change.  The current SELinux security_bpf_prog_alloc() hook causes the
> newly loaded BPF program to inherit the subject context from the task
> which loads the BPF program; if it is possible to reference the
> bpf_prog struct, or really just the associated bpf_prog_aux->security
> blob, from inside a security_bpf_locked_down() function we use that
> subject information to perform the access check.  BPF folks, is there
> a way to get that information from within a BPF kernel helper
> function?  If it isn't currently possible, could it be made possible
> (or something similar)?

While this could be a potential avenue, the problem here is that BPF
helpers have neither access to the prog struct nor to bpf_prog_aux. As
I mentioned earlier, potentially you could go and fix up JITed images
for those progs where the credentials of the loading task require this
when policy suddenly changes to a more stricter level. I'm not a fan
of this though because of the fragility involved here.

Again, the problem is not limited to BPF at all. kprobes is doing register-
time hooks which are equivalent to the one of BPF. Anything in run-time
trying to prevent probe_read_kernel by kprobes or BPF is broken by design.

Thanks,
Daniel
