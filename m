Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4753989CF
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFBMmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:42:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:46128 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhFBMmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:42:21 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1loQAj-000D4R-Ns; Wed, 02 Jun 2021 14:40:33 +0200
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1loQAj-000MyV-DJ; Wed, 02 Jun 2021 14:40:33 +0200
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
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net>
 <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net>
Date:   Wed, 2 Jun 2021 14:40:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26189/Wed Jun  2 13:10:34 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 10:47 PM, Paul Moore wrote:
> On Mon, May 31, 2021 at 4:24 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 5/29/21 8:48 PM, Paul Moore wrote:
>> [...]
>>> Daniel's patch side steps that worry by just doing the lockdown
>>> permission check when the BPF program is loaded, but that isn't a
>>> great solution if the policy changes afterward.  I was hoping there
>>> might be some way to perform the permission check as needed, but the
>>> more I look the more that appears to be difficult, if not impossible
>>> (once again, corrections are welcome).
>>
>> Your observation is correct, will try to clarify below a bit.
>>
>>> I'm now wondering if the right solution here is to make use of the LSM
>>> notifier mechanism.  I'm not yet entirely sure if this would work from
>>> a BPF perspective, but I could envision the BPF subsystem registering
>>> a LSM notification callback via register_blocking_lsm_notifier(), see
>>> if Infiniband code as an example, and then when the LSM(s) policy
>>> changes the BPF subsystem would get a notification and it could
>>> revalidate the existing BPF programs and take block/remove/whatever
>>> the offending BPF programs.  This obviously requires a few things
>>> which I'm not sure are easily done, or even possible:
>>>
>>> 1. Somehow the BPF programs would need to be "marked" at
>>> load/verification time with respect to their lockdown requirements so
>>> that decisions can be made later.  Perhaps a flag in bpf_prog_aux?
>>>
>>> 2. While it looks like it should be possible to iterate over all of
>>> the loaded BPF programs in the LSM notifier callback via
>>> idr_for_each(prog_idr, ...), it is not clear to me if it is possible
>>> to safely remove, or somehow disable, BPF programs once they have been
>>> loaded.  Hopefully the BPF folks can help answer that question.
>>>
>>> 3. Disabling of BPF programs might be preferable to removing them
>>> entirely on LSM policy changes as it would be possible to make the
>>> lockdown state less restrictive at a future point in time, allowing
>>> for the BPF program to be executed again.  Once again, not sure if
>>> this is even possible.
>>
>> Part of why this gets really complex/impossible is that BPF programs in
>> the kernel are reference counted from various sides, be it that there
>> are references from user space to them (fd from application, BPF fs, or
>> BPF links), hooks where they are attached to as well as tail call maps
>> where one BPF prog calls into another. There is currently also no global
>> infra of some sort where you could piggy back to atomically keep track of
>> all the references in a list or such. And the other thing is that BPF progs
>> have no ownership that is tied to a specific task after they have been
>> loaded. Meaning, once they are loaded into the kernel by an application
>> and attached to a specific hook, they can remain there potentially until
>> reboot of the node, so lifecycle of the user space application != lifecycle
>> of the BPF program.
> 
> I don't think the disjoint lifecycle or lack of task ownership is a
> deal breaker from a LSM perspective as the LSMs can stash whatever
> info they need in the security pointer during the program allocation
> hook, e.g. selinux_bpf_prog_alloc() saves the security domain which
> allocates/loads the BPF program.
> 
> The thing I'm worried about would be the case where a LSM policy
> change requires that an existing BPF program be removed or disabled.
> I'm guessing based on the refcounting that there is not presently a
> clean way to remove a BPF program from the system, but is this
> something we could resolve?  If we can't safely remove a BPF program
> from the system, can we replace/swap it with an empty/NULL BPF
> program?

Removing progs would somehow mean destroying those references from an
async event and then /safely/ guaranteeing that nothing is accessing
them anymore. But then if policy changes once more where they would
be allowed again we would need to revert back to the original state,
which brings us to your replace/swap question with an empty/null prog.
It's not feasible either, because there are different BPF program types
and they can have different return code semantics that lead to subsequent
actions. If we were to replace them with an empty/NULL program, then
essentially this will get us into an undefined system state given it's
unclear what should be a default policy for each program type, etc.
Just to pick one simple example, outside of tracing, that comes to mind:
say, you attached a program with tc to a given device ingress hook. That
program implements firewalling functionality, and potentially deep down
in that program there is functionality to record/sample packets along
with some meta data. Part of what is exported to the ring buffer to the
user space reader may be a struct net_device field that is otherwise not
available (or at least not yet), hence it's probe-read with mentioned
helpers. If you were now to change the SELinux policy for that tc loader
application, and therefore replace/swap the progs in the kernel that were
loaded with it (given tc's lockdown policy was recorded in their sec blob)
with an empty/NULL program, then either you say allow-all or drop-all,
but either way, you break the firewalling functionality completely by
locking yourself out of the machine or letting everything through. There
is no sane way where we could reason about the context/internals of a
given program where it would be safe to replace with a simple empty/NULL
prog.

Best,
Daniel
