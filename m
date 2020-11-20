Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA62BB8A0
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgKTV4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:56:42 -0500
Received: from www62.your-server.de ([213.133.104.62]:44886 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgKTV4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 16:56:41 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kgEOQ-00012s-UT; Fri, 20 Nov 2020 22:56:35 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kgEOQ-0007GK-Mr; Fri, 20 Nov 2020 22:56:34 +0100
Subject: Re: [kuba@kernel.org: Re: [PATCH net-next v2 0/3] net: introduce
 rps_default_mask]
To:     marcel@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20201119162527.GB9877@fuller.cnet>
 <CA+aaKfCMa1sOa6bMXFAaP6Wb=5ZgoAcnZAaP9aBmWwOzaAtcHw@mail.gmail.com>
 <CA+aaKfD_6qdNVRgr2TdDeuOau1UCFzRqWRB8iM-_GHV7mMrcsg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6e43ea1e-b166-f60e-9dd1-e907108a3b12@iogearbox.net>
Date:   Fri, 20 Nov 2020 22:56:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+aaKfD_6qdNVRgr2TdDeuOau1UCFzRqWRB8iM-_GHV7mMrcsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25994/Fri Nov 20 14:09:26 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 6:39 PM, Marcel Apfelbaum wrote:
> +netdev
> [Sorry for the second email, I failed to set the text-only mode]
> On Fri, Nov 20, 2020 at 7:30 PM Marcel Apfelbaum <mapfelba@redhat.com> wrote:
[...]
>>> ---------- Forwarded message ----------
>>> From: Jakub Kicinski <kuba@kernel.org>
>>> To: Paolo Abeni <pabeni@redhat.com>
>>> Cc: Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>, Daniel Borkmann <daniel@iogearbox.net>
>>> Bcc:
>>> Date: Wed, 4 Nov 2020 11:42:26 -0800
>>> Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
>>> On Wed, 04 Nov 2020 18:36:08 +0100 Paolo Abeni wrote:
>>>> On Tue, 2020-11-03 at 08:52 -0800, Jakub Kicinski wrote:
>>>>> On Tue, 03 Nov 2020 16:22:07 +0100 Paolo Abeni wrote:
>>>>>> The relevant use case is an host running containers (with the related
>>>>>> orchestration tools) in a RT environment. Virtual devices (veths, ovs
>>>>>> ports, etc.) are created by the orchestration tools at run-time.
>>>>>> Critical processes are allowed to send packets/generate outgoing, it gets a network-interface
>>>> upstart job just as it does on a real host.
>>>>
>>>>>> network traffic - but any interrupt is moved away from the related
>>>>>> cores, so that usual incoming network traffic processing does not
>>>>>> happen there.
>>>>>>
>>>>>> Still an xmit operation on a virtual devices may be transmitted via ovs
>>>>>> or veth, with the relevant forwarding operation happening in a softirq
>>>>>> on the same CPU originating the packet.
>>>>>>
>>>>>> RPS is configured (even) on such virtual devices to move away the
>>>>>> forwarding from the relevant CPUs.
>>>>>>
>>>>>> As Saeed noted, such configuration could be possibly performed via some
>>>>>> user-space daemon monitoring network devices and network namespaces
>>>>>> creation. That will be anyway prone to some race: the orchestation tool
>>>>>> may create and enable the netns and virtual devices before the daemon
>>>>>> has properly set the RPS mask.
>>>>>>
>>>>>> In the latter scenario some packet forwarding could still slip in the
>>>>>> relevant CPU, causing measurable latency. In all non RT scenarios the
>>>>>> above will be likely irrelevant, but in the RT context that is not
>>>>>> acceptable - e.g. it causes in real environments latency above the
>>>>>> defined limits, while the proposed patches avoid the issue.
>>>>>>
>>>>>> Do you see any other simple way to avoid the above race?
>>>>>>
>>>>>> Please let me know if the above answers your doubts,
>>>>>
>>>>> Thanks, that makes it clearer now.
>>>>>
>>>>> Depending on how RT-aware your container management is it may or may not
>>>>> be the right place to configure this, as it creates the veth interface.
>>>>> Presumably it's the container management which does the placement of
>>>>> the tasks to cores, why is it not setting other attributes, like RPS?
>>
>> The CPU isolation is done statically at system boot by setting Linux kernel parameters,
>> So the container management component, in this case the Machine Configuration Operator (for Openshift)
>> or the K8s counterpart can't really help. (actually they would help if a global RPS mask would exist)
>>
>> I tried to tweak the rps_cpus mask using the container management stack, but there
>> is no sane way to do it, please let me get a little into the details.
>>
>> The k8s orchestration component that deals with injecting the network device(s) into the
>> container is CNI, which is interface based and implemented by a lot of plugins, making it
>> hardly feasible to go over all the existing plugins and change them. Also what about
>> the 3rd party ones?
>>
>> Writing a new CNI plugin and chain it into the existing one is also not an option AFAIK,
>> they work at the network level and do not have access to sysfs (they handle the network namespaces).
>> Even if it would be possible (I don't have a deep CNI understanding), it will require a cluster global configuration
>> that is actually needed only for some of the cluster nodes.

CNI chaining would be ugly, agree, but in a typical setting you'd have the CNI plugin
itself which is responsible to set up the Pod for communication to the outside world;
part of it would be creation of devices and moving them into the target netns, and
then you also typically have an agent running in kube-system namespace in the hostns
to which the CNI plugin talks to via IPC e.g. to set up IPAM and other state. Such
agent usually sets up all sort of knobs for the networking layer upon bootstrap.
Assuming you have a cluster where only some of the nodes have RT kernel, these would
likely have special node annotations in K8s so you could select them to run certain
workloads on it.. couldn't such agent be taught to be RT-aware and set up all the
needed knobs? Agree it's a bit ugly to change the relevant CNI plugins to be RT-aware,
but what if you also need other settings in future aside from RPS mask for RT? At some
point you'd likely end up having to extend these anyway, no?

>> Another approach is to set the RPS configuration from the inside(of the container),
>> but the /sys mount is read only for unprivileged containers, so we lose again.
>>
>> That leaves us with a host daemon hack:
>> Since the virtual network devices are created in the host namespace and
>> then "moved" into the container, we can listen to some udev event
>> and write to the rps_cpus file after the virtual netdev is created and before
>> it is moved (as stated above, the work is done by a CNI plugin implementation).
>> That is of course extremely racy and not a valid solution.
>>
>>>> The container orchestration is quite complex, and I'm unsure isolation
>>>> and networking configuration are performed (or can be performed) by the
>>>> same precess (without an heavy refactor).
>>>>
>>>> On the flip hand, the global rps mask knob looked quite
>>>> straightforward to me.
>>>
>>> I understand, but I can't shake the feeling this is a hack.
>>>
>>> Whatever sets the CPU isolation should take care of the RPS settings.
>>
>> Sadly it can't be done, please see above.
>>
>>>> Possibly I can reduce the amount of new code introduced by this
>>>> patchset removing some code duplication
>>>> between rps_default_mask_sysctl() and flow_limit_cpu_sysctl(). Would
>>>> that make this change more acceptable? Or should I drop this
>>>> altogether?
>>>
>>> I'm leaning towards drop altogether, unless you can get some
>>> support/review tags from other netdev developers. So far it
>>> appears we only got a down vote from Saeed.
>>
>> Any solution that will allow the user space to avoid the
>> network soft IRQs on specific CPUs would be welcome.
>>
>> The proposed global mask is a solution, maybe there other ways?
>>
>> Thanks,
>> Marcel
> 

