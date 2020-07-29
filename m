Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560F8231C99
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgG2KUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:20:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:22600 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbgG2KUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 06:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596018007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVRnlPXyWQwKHwi0fgXED1x7wx9OCCFOxUXZea3A4uU=;
        b=QAE+YvVk8l7/IZvjIF3PVTQmsTqXDreywHoA4wy0NbqxfslBlPQmVtYKhoerf6z/jTFk+Y
        o7QIsugOlQwDJeDTcf9jwkMMJVIVmvhGqtXbtidMSrlO2R7tPk3kjHyN3o1yDhEp/cHwx7
        GJH2xMUR84suzShcH6wkM4a49Kv32q4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-B2P_4DiFNnCzp-B3JwtHfw-1; Wed, 29 Jul 2020 06:20:05 -0400
X-MC-Unique: B2P_4DiFNnCzp-B3JwtHfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCF508015F4;
        Wed, 29 Jul 2020 10:20:03 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16252712FF;
        Wed, 29 Jul 2020 10:19:53 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Eli Cohen <eli@mellanox.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, shahafs@mellanox.com, parav@mellanox.com
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
 <20200728090438.GA21875@nps-server-21.mtl.labs.mlnx>
 <c87d4a5a-3106-caf2-2bc1-764677218967@redhat.com>
 <20200729095503.GD35280@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <45b7e8aa-47a9-06f6-6b72-762d504adb00@redhat.com>
Date:   Wed, 29 Jul 2020 18:19:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729095503.GD35280@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/29 下午5:55, Eli Cohen wrote:
> On Wed, Jul 29, 2020 at 05:21:53PM +0800, Jason Wang wrote:
>> On 2020/7/28 下午5:04, Eli Cohen wrote:
>>> On Tue, Jul 28, 2020 at 12:24:03PM +0800, Zhu Lingshan wrote:
>>>> +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, int qid)
>>>> +{
>>>> +	struct vhost_virtqueue *vq = &v->vqs[qid];
>>>> +	const struct vdpa_config_ops *ops = v->vdpa->config;
>>>> +	struct vdpa_device *vdpa = v->vdpa;
>>>> +	int ret, irq;
>>>> +
>>>> +	spin_lock(&vq->call_ctx.ctx_lock);
>>>> +	irq = ops->get_vq_irq(vdpa, qid);
>>>> +	if (!vq->call_ctx.ctx || irq == -EINVAL) {
>>>> +		spin_unlock(&vq->call_ctx.ctx_lock);
>>>> +		return;
>>>> +	}
>>>> +
>>> If I understand correctly, this will cause these IRQs to be forwarded
>>> directly to the VCPU, e.g. will be handled by the guest/qemu.
>>
>> Yes, if it can bypassed, the interrupt will be delivered to vCPU directly.
>>
> So, usually the network driver knows how to handle interrups for its
> devices. I assume the virtio_net driver at the guest has some default
> processing but what if the underlying hardware device (such as the case
> of vdpa) needs to take some actions?


Virtio splits the bus operations out of device operations. So did the 
driver.

The virtio-net driver depends on a transport driver to talk to the real 
device. Usually PCI is used as the transport for the device. In this 
case virtio-pci driver is in charge of dealing with irq 
allocation/free/configuration and it needs to co-operate with platform 
specific irqchip (virtualized by KVM) to finish the work like irq 
acknowledge etc.  E.g for x86, the irq offloading can only work when 
there's a hardware support of virtual irqchip (APICv) then all stuffs 
could be done without vmexits.

So no vendor specific part since the device and transport are all standard.


>   Is there an option to do bounce the
> interrupt back to the vendor specific driver in the host so it can take
> these actions?


Currently not, but even if we can do this, I'm afraid we will lose the 
performance advantage of irq bypassing.


>
>>> Does this mean that the host will not handle this interrupt? How does it
>>> work in case on level triggered interrupts?
>>
>> There's no guarantee that the KVM arch code can make sure the irq
>> bypass work for any type of irq. So if they the irq will still need
>> to be handled by host first. This means we should keep the host
>> interrupt handler as a slowpath (fallback).
>>
>>> In the case of ConnectX, I need to execute some code to acknowledge the
>>> interrupt.
>>
>> This turns out to be hard for irq bypassing to work. Is it because
>> the irq is shared or what kind of ack you need to do?
> I have an EQ which is a queue for events comming from the hardware. This
> EQ can created so it reports only completion events but I still need to
> execute code that roughly tells the device that I saw these event
> records and then arm it again so it can report more interrupts (e.g if
> more packets are received or sent). This is device specific code.


Any chance that the hardware can use MSI (which is not the case here)?

Thanks


>> Thanks
>>
>>
>>> Can you explain how this should be done?
>>>

