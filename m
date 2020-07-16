Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFAF221A6D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgGPC75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:59:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728080AbgGPC74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594868394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dE5m+Um8h+2SUjIIhar0TzsMcMWhB03b3rA1FsH9hrY=;
        b=DsmsZN4F3bEU+yxcrSnXzfyr5eqnLgDERDAstumaRs/OMyRTjJvSgJMcEGRka5yd91ql5O
        kFZ3hP3TVLj5n7XAc6ge6QpqOsJ5HlWA9opD0oPdi+GNiLWdNSa0Y2523HeUqaQnsRNwsA
        Y/RCt/0Mwxw6261g+b/Ts1CIv0ABDRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-ZEAagCr5PK2jvEWyxvMe5g-1; Wed, 15 Jul 2020 22:59:52 -0400
X-MC-Unique: ZEAagCr5PK2jvEWyxvMe5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 333A8800FF1;
        Thu, 16 Jul 2020 02:59:51 +0000 (UTC)
Received: from [10.72.12.131] (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 975DD5C1BD;
        Thu, 16 Jul 2020 02:59:39 +0000 (UTC)
Subject: Re: [PATCH 0/7] *** IRQ offloading for vDPA ***
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565524-3394-1-git-send-email-lingshan.zhu@intel.com>
 <70244d80-08a4-da91-3226-7bfd2019467e@redhat.com>
 <97032c51-3265-c94a-9ce1-f42fcc6d3075@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <77318609-85ef-f169-2a1e-500473976d84@redhat.com>
Date:   Thu, 16 Jul 2020 10:59:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <97032c51-3265-c94a-9ce1-f42fcc6d3075@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/16 上午9:39, Zhu, Lingshan wrote:
>
>
> On 7/15/2020 9:43 PM, Jason Wang wrote:
>>
>> On 2020/7/12 下午10:52, Zhu Lingshan wrote:
>>> Hi All,
>>>
>>> This series intends to implement IRQ offloading for
>>> vhost_vdpa.
>>>
>>> By the feat of irq forwarding facilities like posted
>>> interrupt on X86, irq bypass can  help deliver
>>> interrupts to vCPU directly.
>>>
>>> vDPA devices have dedicated hardware backends like VFIO
>>> pass-throughed devices. So it would be possible to setup
>>> irq offloading(irq bypass) for vDPA devices and gain
>>> performance improvements.
>>>
>>> In my testing, with this feature, we can save 0.1ms
>>> in a ping between two VFs on average.
>>
>>
>> Hi Lingshan:
>>
>> During the virtio-networking meeting, Michael spots two possible issues:
>>
>> 1) do we need an new uAPI to stop the irq offloading?
>> 2) can interrupt lost during the eventfd ctx?
>>
>> For 1) I think we probably not, we can allocate an independent 
>> eventfd which does not map to MSIX. So the consumer can't match the 
>> producer and we fallback to eventfd based irq.
> Hi Jason,
>
> I wonder why we need to stop irq offloading, but if we need to do so, maybe a new uAPI would be more intuitive to me,
> but why and who(user? qemu?) shall initialize this process, based on what kinda of basis to make the decision?


The reason is we may want to fallback to software datapath for some 
reason (e.g software assisted live migration). In this case we need 
intercept device write to used ring so we can not offloading virtqueue 
interrupt in this case.


>> For 2) it looks to me guest should deal with the irq synchronization 
>> when mask or unmask MSIX vectors.
> Agreed!


It's better to double check for this.

Thanks


>
> Thanks,
> BR
> Zhu Lingshan
>>
>> What's your thought?
>>
>> Thanks
>>
>>
>>>
>>>
>>> Zhu Lingshan (7):
>>>    vhost: introduce vhost_call_ctx
>>>    kvm/vfio: detect assigned device via irqbypass manager
>>>    vhost_vdpa: implement IRQ offloading functions in vhost_vdpa
>>>    vDPA: implement IRQ offloading helpers in vDPA core
>>>    virtio_vdpa: init IRQ offloading function pointers to NULL.
>>>    ifcvf: replace irq_request/free with helpers in vDPA core.
>>>    irqbypass: do not start consumer or producer when failed to connect
>>>
>>>   arch/x86/kvm/x86.c              | 10 ++++--
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 11 +++---
>>>   drivers/vdpa/vdpa.c             | 46 +++++++++++++++++++++++++
>>>   drivers/vhost/Kconfig           |  1 +
>>>   drivers/vhost/vdpa.c            | 75 
>>> +++++++++++++++++++++++++++++++++++++++--
>>>   drivers/vhost/vhost.c           | 22 ++++++++----
>>>   drivers/vhost/vhost.h           |  9 ++++-
>>>   drivers/virtio/virtio_vdpa.c    |  2 ++
>>>   include/linux/vdpa.h            | 11 ++++++
>>>   virt/kvm/vfio.c                 |  2 --
>>>   virt/lib/irqbypass.c            | 16 +++++----
>>>   11 files changed, 181 insertions(+), 24 deletions(-)
>>>
>>

