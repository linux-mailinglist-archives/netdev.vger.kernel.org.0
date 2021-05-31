Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950573956EA
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhEaI0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:26:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:50348 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhEaIZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:25:59 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lndDX-000FgJ-MR; Mon, 31 May 2021 10:24:11 +0200
Received: from [85.7.101.30] (helo=linux-2.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lndDX-000Gza-CF; Mon, 31 May 2021 10:24:11 +0200
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
        Casey Schaufler <casey@schaufler-ca.com>, jolsa@redhat.com
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
 <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net>
 <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net>
Date:   Mon, 31 May 2021 10:24:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26186/Sun May 30 13:11:19 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/21 8:48 PM, Paul Moore wrote:
[...]
> Daniel's patch side steps that worry by just doing the lockdown
> permission check when the BPF program is loaded, but that isn't a
> great solution if the policy changes afterward.  I was hoping there
> might be some way to perform the permission check as needed, but the
> more I look the more that appears to be difficult, if not impossible
> (once again, corrections are welcome).

Your observation is correct, will try to clarify below a bit.

> I'm now wondering if the right solution here is to make use of the LSM
> notifier mechanism.  I'm not yet entirely sure if this would work from
> a BPF perspective, but I could envision the BPF subsystem registering
> a LSM notification callback via register_blocking_lsm_notifier(), see
> if Infiniband code as an example, and then when the LSM(s) policy
> changes the BPF subsystem would get a notification and it could
> revalidate the existing BPF programs and take block/remove/whatever
> the offending BPF programs.  This obviously requires a few things
> which I'm not sure are easily done, or even possible:
> 
> 1. Somehow the BPF programs would need to be "marked" at
> load/verification time with respect to their lockdown requirements so
> that decisions can be made later.  Perhaps a flag in bpf_prog_aux?
> 
> 2. While it looks like it should be possible to iterate over all of
> the loaded BPF programs in the LSM notifier callback via
> idr_for_each(prog_idr, ...), it is not clear to me if it is possible
> to safely remove, or somehow disable, BPF programs once they have been
> loaded.  Hopefully the BPF folks can help answer that question.
> 
> 3. Disabling of BPF programs might be preferable to removing them
> entirely on LSM policy changes as it would be possible to make the
> lockdown state less restrictive at a future point in time, allowing
> for the BPF program to be executed again.  Once again, not sure if
> this is even possible.

Part of why this gets really complex/impossible is that BPF programs in
the kernel are reference counted from various sides, be it that there
are references from user space to them (fd from application, BPF fs, or
BPF links), hooks where they are attached to as well as tail call maps
where one BPF prog calls into another. There is currently also no global
infra of some sort where you could piggy back to atomically keep track of
all the references in a list or such. And the other thing is that BPF progs
have no ownership that is tied to a specific task after they have been
loaded. Meaning, once they are loaded into the kernel by an application
and attached to a specific hook, they can remain there potentially until
reboot of the node, so lifecycle of the user space application != lifecycle
of the BPF program.

It's maybe best to compare this aspect to kernel modules in the sense that
you have an application that loads it into the kernel (insmod, etc, where
you could also enforce lockdown signature check), but after that, they can
be managed by other entities as well (implicitly refcounted from kernel,
removed by other applications, etc).

My understanding of the lockdown settings are that users have options
to select/enforce a lockdown level of CONFIG_LOCK_DOWN_KERNEL_FORCE_{INTEGRITY,
CONFIDENTIALITY} at compilation time, they have a lockdown={integrity|
confidentiality} boot-time parameter, /sys/kernel/security/lockdown,
and then more fine-grained policy via 59438b46471a ("security,lockdown,selinux:
implement SELinux lockdown"). Once you have set a global policy level,
you cannot revert back to a less strict mode. So the SELinux policy is
specifically tied around tasks to further restrict applications in respect
to the global policy. I presume that would mean for those users that majority
of tasks have the confidentiality option set via SELinux with just a few
necessary using the integrity global policy. So overall the enforcing
option when BPF program is loaded is the only really sensible option to
me given only there we have the valid current task where such policy can
be enforced.

Best,
Daniel
