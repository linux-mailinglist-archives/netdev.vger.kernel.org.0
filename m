Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BDD10C2F2
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 04:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfK1Dms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 22:42:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43267 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727258AbfK1Dmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 22:42:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574912565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oNpXXUPzEf7y4T1D/GmnsHSNzKOeTG0HJ+r3KP23ESE=;
        b=YNrhUU2J2GyX6jKGmmnIZqj8dOvtrEuKkjTxXDz3XbAqHFQhG50GUPAnVBOsG2k4KQyhic
        v+Pt+7AOMLxIWwtJlrdhmDBIZz8jJOQ56PDZBYSJqRxecYbEm2TWFzqxox6N+2reuUfdAy
        FRWuuafKlsuHvv9Sx/6eCoC56+xMLjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-hKnZHYPxOGS8eP4RC3ZEfg-1; Wed, 27 Nov 2019 22:42:43 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B324410054E3;
        Thu, 28 Nov 2019 03:42:41 +0000 (UTC)
Received: from [10.72.12.231] (ovpn-12-231.pek2.redhat.com [10.72.12.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 460A15D6D0;
        Thu, 28 Nov 2019 03:41:59 +0000 (UTC)
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        qemu-devel@nongnu.org, Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        kvm@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126123514.3bdf6d6f@cakuba.netronome.com>
 <48cec928-871f-3f50-e99f-c6a6d124cf4c@redhat.com>
 <20191127114913.0363a0e8@cakuba.netronome.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <285af7e2-6a4d-b20c-0aeb-165e3cd4309d@redhat.com>
Date:   Thu, 28 Nov 2019 11:41:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191127114913.0363a0e8@cakuba.netronome.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: hKnZHYPxOGS8eP4RC3ZEfg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/28 =E4=B8=8A=E5=8D=883:49, Jakub Kicinski wrote:
> On Wed, 27 Nov 2019 10:59:37 +0800, Jason Wang wrote:
>> On 2019/11/27 =E4=B8=8A=E5=8D=884:35, Jakub Kicinski wrote:
>>> On Tue, 26 Nov 2019 19:07:26 +0900, Prashant Bhole wrote:
>>>> Note: This RFC has been sent to netdev as well as qemu-devel lists
>>>>
>>>> This series introduces XDP offloading from virtio_net. It is based on
>>>> the following work by Jason Wang:
>>>> https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net
>>>>
>>>> Current XDP performance in virtio-net is far from what we can achieve
>>>> on host. Several major factors cause the difference:
>>>> - Cost of virtualization
>>>> - Cost of virtio (populating virtqueue and context switching)
>>>> - Cost of vhost, it needs more optimization
>>>> - Cost of data copy
>>>> Because of above reasons there is a need of offloading XDP program to
>>>> host. This set is an attempt to implement XDP offload from the guest.
>>> This turns the guest kernel into a uAPI proxy.
>>>
>>> BPF uAPI calls related to the "offloaded" BPF objects are forwarded
>>> to the hypervisor, they pop up in QEMU which makes the requested call
>>> to the hypervisor kernel. Today it's the Linux kernel tomorrow it may
>>> be someone's proprietary "SmartNIC" implementation.
>>>
>>> Why can't those calls be forwarded at the higher layer? Why do they
>>> have to go through the guest kernel?
>>
>> I think doing forwarding at higher layer have the following issues:
>>
>> - Need a dedicated library (probably libbpf) but application may choose
>>    to do eBPF syscall directly
>> - Depends on guest agent to work
> This can be said about any user space functionality.


Yes but the feature may have too much unnecessary dependencies:=20
dedicated library, guest agent, host agent etc. This can only work for=20
some specific setups and will lead vendor specific implementations.


>
>> - Can't work for virtio-net hardware, since it still requires a hardware
>> interface for carrying=C2=A0 offloading information
> The HW virtio-net presumably still has a PF and hopefully reprs for
> VFs, so why can't it attach the program there?


Then you still need a interface for carrying such information? It will=20
work like assuming we had a virtio-net VF with reprs:

libbpf(guest) -> guest agent -> host agent -> libbpf(host) -> BPF=20
syscall -> VF reprs/PF drvier -> VF/PF reprs -> virtio-net VF

Still need a vendor specific way for passing eBPF commands from driver=20
to reprs/PF, and possibility, it could still be a virtio interface there.

In this proposal it will work out of box as simple as:

libbpf(guest) -> guest kernel -> virtio-net driver -> virtio-net VF

If the request comes from host (e.g flow offloading, configuration etc),=20
VF reprs make perfect fit. But if the request comes from guest, having=20
much longer journey looks quite like a burden (dependencies, bugs etc) .

What's more important, we can not assume the how virtio-net HW is=20
structured, it could even not a SRIOV or PCI card.


>
>> - Implement at the level of kernel may help for future extension like
>>    BPF object pinning and eBPF helper etc.
> No idea what you mean by this.


My understanding is, we should narrow the gap between non-offloaded eBPF=20
program and offloaded eBPF program. Making maps or progs to be visible=20
to kernel may help to persist a unified API e.g object pinning through=20
sysfs, tracepoint, debug etc.


>
>> Basically, this series is trying to have an implementation of
>> transporting eBPF through virtio, so it's not necessarily a guest to
>> host but driver and device. For device, it could be either a virtual one
>> (as done in qemu) or a real hardware.
> SmartNIC with a multi-core 64bit ARM CPUs is as much of a host as
> is the x86 hypervisor side. This set turns the kernel into a uAPI
> forwarder.


Not necessarily, as what has been done by NFP, driver filter out the=20
features that is not supported, and the bpf object is still visible in=20
the kernel (and see above comment).


>
> 3 years ago my answer to this proposal would have been very different.
> Today after all the CPU bugs it seems like the SmartNICs (which are
> just another CPU running proprietary code) may just take off..
>

That's interesting but vendor may choose to use FPGA other than SoC in=20
this case. Anyhow discussion like this is somehow out of the scope of=20
the series.


>>> If kernel performs no significant work (or "adds value", pardon the
>>> expression), and problem can easily be solved otherwise we shouldn't
>>> do the work of maintaining the mechanism.
>> My understanding is that it should not be much difference compared to
>> other offloading technology.
> I presume you mean TC offloads? In virtualization there is inherently a
> hypervisor which will receive the request, be it an IO hub/SmartNIC or
> the traditional hypervisor on the same CPU.
>
> The ACL/routing offloads differ significantly, because it's either the
> driver that does all the HW register poking directly or the complexity
> of programming a rule into a HW table is quite low.
>
> Same is true for the NFP BPF offload, BTW, the driver does all the
> heavy lifting and compiles the final machine code image.


Yes and this series benefit from the infrastructure invented from NFP.=20
But I'm not sure this is a good point since, technically the machine=20
code could be generated by smart NIC as well.


>
> You can't say verifying and JITing BPF code into machine code entirely
> in the hypervisor is similarly simple.


Yes and that's why we choose to do in on the device (host) to simplify=20
things.


>
> So no, there is a huge difference.
>

>>> The approach of kernel generating actual machine code which is then
>>> loaded into a sandbox on the hypervisor/SmartNIC is another story.
>> We've considered such way, but actual machine code is not as portable as
>> eBPF bytecode consider we may want:
>>
>> - Support migration
>> - Further offload the program to smart NIC (e.g through macvtap
>>    passthrough mode etc).
> You can re-JIT or JIT for SmartNIC..? Having the BPF bytecode does not
> guarantee migration either,


Yes, but it's more portable than machine code.


> if the environment is expected to be
> running different version of HW and SW.


Right, we plan to have feature negotiation.


> But yes, JITing in the guest
> kernel when you don't know what to JIT for may be hard,


Yes.


> I was just
> saying that I don't mean to discourage people from implementing
> sandboxes which run JITed code on SmartNICs. My criticism is (as
> always?) against turning the kernel into a one-to-one uAPI forwarder
> into unknown platform code.


We have FUSE and I think it's not only the forwarder, and we may do much=20
more work on top in the future. For unknown platform code, I'm not sure=20
why we need care about that. There's no way for us to prevent such=20
implementation and if we try to formalize it through a specification=20
(virtio spec and probably eBPF spec), it may help actually.


>
> For cloud use cases I believe the higher layer should solve this.
>

Technically possible, but have lots of drawbacks.

Thanks

