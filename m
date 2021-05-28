Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC847394463
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhE1Opc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:45:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:40950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbhE1OpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:45:23 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmdLp-0006Az-6G; Fri, 28 May 2021 16:20:37 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmdLo-000B6x-Rs; Fri, 28 May 2021 16:20:36 +0200
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Jiri Olsa <jolsa@redhat.com>, andrii.nakryiko@gmail.com
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
 <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net>
 <CAFqZXNsKf5wSGmspEVEDrm4Ywar-F4kJWbBPBE+_hd1CGQ3jhg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <17eaebd3-6389-8c80-38ed-dada9d087266@iogearbox.net>
Date:   Fri, 28 May 2021 16:20:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAFqZXNsKf5wSGmspEVEDrm4Ywar-F4kJWbBPBE+_hd1CGQ3jhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26184/Fri May 28 13:05:50 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 3:42 PM, Ondrej Mosnacek wrote:
> (I'm off work today and plan to reply also to Paul's comments next
> week, but for now let me at least share a couple quick thoughts on
> Daniel's patch.)
> 
> On Fri, May 28, 2021 at 11:56 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 5/28/21 9:09 AM, Daniel Borkmann wrote:
>>> On 5/28/21 3:37 AM, Paul Moore wrote:
>>>> On Mon, May 17, 2021 at 5:22 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>>>>>
>>>>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
>>>>> lockdown") added an implementation of the locked_down LSM hook to
>>>>> SELinux, with the aim to restrict which domains are allowed to perform
>>>>> operations that would breach lockdown.
>>>>>
>>>>> However, in several places the security_locked_down() hook is called in
>>>>> situations where the current task isn't doing any action that would
>>>>> directly breach lockdown, leading to SELinux checks that are basically
>>>>> bogus.
>>>>>
>>>>> Since in most of these situations converting the callers such that
>>>>> security_locked_down() is called in a context where the current task
>>>>> would be meaningful for SELinux is impossible or very non-trivial (and
>>>>> could lead to TOCTOU issues for the classic Lockdown LSM
>>>>> implementation), fix this by modifying the hook to accept a struct cred
>>>>> pointer as argument, where NULL will be interpreted as a request for a
>>>>> "global", task-independent lockdown decision only. Then modify SELinux
>>>>> to ignore calls with cred == NULL.
>>>>
>>>> I'm not overly excited about skipping the access check when cred is
>>>> NULL.  Based on the description and the little bit that I've dug into
>>>> thus far it looks like using SECINITSID_KERNEL as the subject would be
>>>> much more appropriate.  *Something* (the kernel in most of the
>>>> relevant cases it looks like) is requesting that a potentially
>>>> sensitive disclosure be made, and ignoring it seems like the wrong
>>>> thing to do.  Leaving the access control intact also provides a nice
>>>> avenue to audit these requests should users want to do that.
>>>
>>> I think the rationale/workaround for ignoring calls with cred == NULL (or the previous
>>> patch with the unimplemented hook) from Ondrej was two-fold, at least speaking for his
>>> seen tracing cases:
>>>
>>>     i) The audit events that are triggered due to calls to security_locked_down()
>>>        can OOM kill a machine, see below details [0].
>>>
>>>    ii) It seems to be causing a deadlock via slow_avc_audit() -> audit_log_end()
>>>        when presumingly trying to wake up kauditd [1].
> 
> Actually, I wasn't aware of the deadlock... But calling an LSM hook
> [that is backed by a SELinux access check] from within a BPF helper is
> calling for all kinds of trouble, so I'm not surprised :)

Fully agree, it's just waiting to blow up in unpredictable ways.. :/

>> Ondrej / Paul / Jiri: at least for the BPF tracing case specifically (I haven't looked
>> at the rest but it's also kind of independent), the attached fix should address both
>> reported issues, please take a look & test.
> 
> Thanks, I like this solution, although there are a few gotchas:
> 
> 1. This patch creates a slight "regression" in that if someone flips
> the Lockdown LSM into lockdown mode on runtime, existing (already
> loaded) BPF programs will still be able to call the
> confidentiality-breaching helpers, while before the lockdown would
> apply also to them. Personally, I don't think it's a big deal (and I
> bet there are other existing cases where some handle kept from before
> lockdown could leak data), but I wanted to mention it in case someone
> thinks the opposite.

Yes, right, though this is nothing new either in the sense that there are
plenty of other cases with security_locked_down() that operate this way
e.g. take the open_kcore() for /proc/kcore access or the module_sig_check()
for mod signatures just to pick some random ones, same approach where the
enforcement is happen at open/load time.

> 2. IIUC. when a BPF program is rejected due to lockdown/SELinux, the
> kernel will return -EINVAL to userspace (looking at
> check_helper_call() in kernel/bpf/verifier.c; didn't have time to look
> at other callers...). It would be nicer if the error code from the
> security_locked_down() call would be passed through the call chain and
> eventually returned to the caller. It should be relatively
> straightforward to convert bpf_base_func_proto() to return a PTR_ERR()
> instead of NULL on error, but it looks like this would result in quite
> a big patch updating all the callers (and callers of callers, etc.)
> with a not-so-small chance of missing some NULL check and introducing
> a bug... I guess we could live with EINVAL-on-denied in stable kernels
> and only have the error path refactoring in -next; I'm not sure...

Right, it would return a verifier log entry with reporting to the user that
the prog is attempting to use an unavailable/unknown helper function. We do
have similar return NULL with bpf_capable() and perfmon_capable() checks.
Potentially, we could do PTR_ERR() in future where we tell if it failed due
to missing CAPs, due to lockdown or just due to helper not compiled in..

> 3. This is a bit of a shot-in-the-dark, but I suppose there might be
> some BPF programs that would be able to do something useful also when
> the read_kernel helpers return an error, yet the kernel will now
> outright refuse to load them (when the lockdown hook returns nonzero).
> I have no idea if such BPF programs realistically exist in practice,
> but perhaps it would be worth returning some dummy
> always-error-returning helper function instead of NULL from
> bpf_base_func_proto() when security_locked_down() returns an error.
> That would also resolve (2.), basically. (Then there is the question
> of what error code to use (because Lockdown LSM uses -EPERM, while
> SELinux -EACCESS), but I think always returning -EPERM from such stub
> helpers would be a viable choice.)

It would actually be harder to debug. Returning NULL at verification
time, libbpf, for example, would have a chance to probe for this. See the
feature_probes[] in libbpf's kernel_supports(), so it could provide a
meaningful warning to the user that the tracing functionality is unavailable
on the system. With returning an error from the helper, libbpf cannot check
it.. theoretically, it could but significantly more cumbersome given it
needs to attach the probe somewhere, trigger it, read out the helper result
and pass it back to libbpf user space.. not really feasible. Overall,
moving into func_proto and returning NULL is the much better approach
(and in line with the CAP check enforcement).

Thanks,
Daniel
