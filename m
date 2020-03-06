Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21A717BA24
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 11:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCFKZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 05:25:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:35300 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgCFKZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 05:25:08 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jAAAB-0006HL-0B; Fri, 06 Mar 2020 11:25:03 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jAAAA-000VG3-Me; Fri, 06 Mar 2020 11:25:02 +0100
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com> <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp> <87h7z44l3z.fsf@toke.dk>
 <20200304154757.3tydkiteg3vekyth@ast-mbp> <874kv33x60.fsf@toke.dk>
 <20200305163444.6e3w3u3a5ufphwhp@ast-mbp>
 <473a3e8a-03ea-636c-f054-3c960bf0fdbd@iogearbox.net>
 <20200305225027.nazs3gtlcw3gjjvn@ast-mbp>
 <7b674384-1131-59d4-ee2f-5a17824c1eca@iogearbox.net> <878skd3mw4.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <374e23b6-572a-8dac-88cb-855069535917@iogearbox.net>
Date:   Fri, 6 Mar 2020 11:25:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <878skd3mw4.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25742/Thu Mar  5 15:10:18 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/20 9:31 AM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 3/5/20 11:50 PM, Alexei Starovoitov wrote:
>>> On Thu, Mar 05, 2020 at 11:34:18PM +0100, Daniel Borkmann wrote:
>>>> On 3/5/20 5:34 PM, Alexei Starovoitov wrote:
>>>>> On Thu, Mar 05, 2020 at 11:37:11AM +0100, Toke Høiland-Jørgensen wrote:
>>>>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>>>>> On Wed, Mar 04, 2020 at 08:47:44AM +0100, Toke Høiland-Jørgensen wrote:
>>>> [...]
>>>>>> Anyway, what I was trying to express:
>>>>>>
>>>>>>> Still that doesn't mean that pinned link is 'immutable'.
>>>>>>
>>>>>> I don't mean 'immutable' in the sense that it cannot be removed ever.
>>>>>> Just that we may end up in a situation where an application can see a
>>>>>> netdev with an XDP program attached, has the right privileges to modify
>>>>>> it, but can't because it can't find the pinned bpf_link. Right? Or am I
>>>>>> misunderstanding your proposal?
>>>>>>
>>>>>> Amending my example from before, this could happen by:
>>>>>>
>>>>>> 1. Someone attaches a program to eth0, and pins the bpf_link to
>>>>>>       /sys/fs/bpf/myprog
>>>>>>
>>>>>> 2. eth0 is moved to a different namespace which mounts a new sysfs at
>>>>>>       /sys
>>>>>>
>>>>>> 3. Inside that namespace, /sys/fs/bpf/myprog is no longer accessible, so
>>>>>>       xdp-loader can't get access to the original bpf_link; but the XDP
>>>>>>       program is still attached to eth0.
>>>>>
>>>>> The key to decide is whether moving netdev across netns should be allowed
>>>>> when xdp attached. I think it should be denied. Even when legacy xdp
>>>>> program is attached, since it will confuse user space managing part.
>>>>
>>>> There are perfectly valid use cases where this is done already today (minus
>>>> bpf_link), for example, consider an orchestrator that is setting up the BPF
>>>> program on the device, moving to the newly created application pod during
>>>> the CNI call in k8s, such that the new pod does not have the /sys/fs/bpf/
>>>> mount instance and if unprivileged cannot remove the BPF prog from the dev
>>>> either. We do something like this in case of ipvlan, meaning, we attach a
>>>> rootlet prog that calls into single slot of a tail call map, move it to the
>>>> application pod, and only out of Cilium's own pod and it's pod-local bpf fs
>>>> instance we manage the pinned tail call map to update the main programs in
>>>> that single slot w/o having to switch any netns later on.
>>>
>>> Right. You mentioned this use case before, but I managed to forget about it.
>>> Totally makes sense for prog to stay attached to netdev when it's moved.
>>> I think pod manager would also prefer that pod is not able to replace
>>> xdp prog from inside the container. It sounds to me that steps 1,2,3 above
>>> is exactly the desired behavior. Otherwise what stops some application
>>> that started in a pod to override it?
>>
>> Generally, yes, and it shouldn't need to care nor see what is happening in
>> /sys/fs/bpf/ from the orchestrator at least (or could potentially have its
>> own private mount under /sys/fs/bpf/ or elsewhere). Ideally, the behavior
>> should be that orchestrator does all the setup out of its own namespace,
>> then moves everything over to the newly created target namespace and e.g.
>> only if the pod has the capable(cap_sys_admin) permissions, it could mess
>> around with anything attached there, or via similar model as done in [0]
>> when there is a master device.
> 
> Yup, I can see how this can be a reasonable use case where you *would*
> want the locking. However, my concern is that there should be a way for
> an admin to recover from this (say, if it happens by mistake, or a
> misbehaving application). Otherwise, I fear we'll end up with support
> cases where the only answer is "try rebooting", which is obviously not
> ideal.

I'm not quite sure I follow the concern, if you're an admin and have the right
permissions, then you should be able to introspect and change settings like with
anything else there is today.

>> Last time I looked, there is a down/up cycle on the dev upon netns
>> migration and it flushes e.g. attached qdiscs afaik, so there are
>> limitations that still need to be addressed. Not sure atm if same is
>> happening to XDP right now.
> 
> XDP programs will stay attached. devmaps (for redirect) have a notifier
> that will remove devices when they move out of a namespace. Not sure if
> there are any other issues with netns moves somewhere.
> 
>> In this regards veth devices are a bit nicer to work with since
>> everything can be attached on hostns ingress w/o needing to worry on
>> the peer dev in the pod's netns.
> 
> Presumably the XDP EGRESS hook that David Ahern is working on will make
> this doable for XDP on veth as well?

I'm not sure I see a use-case for XDP egress for Cilium yet, but maybe I'm still
lacking a clear picture on why one should use it. We currently use various
layers where we orchestrate our BPF programs from the agent. XDP/rx on the phys
nic on the one end, BPF sock progs attached to cgroups on the other end of the
spectrum. The processing in between on virtual devices is mainly tc/BPF-based
since everything is skb based anyway and more flexible also with interaction
with the rest of the stack. There is also not this pain of having to linearize
all the skbs, but at least there's a path to tackle that.

Thanks,
Daniel
