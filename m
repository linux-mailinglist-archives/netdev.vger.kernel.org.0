Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9AD221DD5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgGPIGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:06:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45895 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725921AbgGPIGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594886804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d5dhBqOnsrkp+ck3vhLEOg3slEAzg8AwB2Xf50MijXU=;
        b=Sj9yk514UYvUH68EtAKh9pU+JzfYul1Y4Tm6B3imaoulqNX5RQ4Sa/hIRjQ5iqugWetn7a
        owJAC0d+Sze/PCG8/WlBWnvRr5lkPsWuMwJw1BKWYD04/UHvi5KhnnTAOKGDlBkSWrDGLz
        N8MYW1KPAZHCOxSwDjmhjGXWDZhsuQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-Asf4430XNjmlKVUWtpP1mw-1; Thu, 16 Jul 2020 04:06:40 -0400
X-MC-Unique: Asf4430XNjmlKVUWtpP1mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECD0B800FF1;
        Thu, 16 Jul 2020 08:06:38 +0000 (UTC)
Received: from [10.72.12.131] (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD9302DE69;
        Thu, 16 Jul 2020 08:06:25 +0000 (UTC)
Subject: Re: [PATCH 0/7] *** IRQ offloading for vDPA ***
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex williamson <alex.williamson@redhat.com>,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        dan daly <dan.daly@intel.com>
References: <1594565524-3394-1-git-send-email-lingshan.zhu@intel.com>
 <70244d80-08a4-da91-3226-7bfd2019467e@redhat.com>
 <97032c51-3265-c94a-9ce1-f42fcc6d3075@intel.com>
 <77318609-85ef-f169-2a1e-500473976d84@redhat.com>
 <29ab6da8-ed8e-6b91-d658-f3d240543b29@intel.com>
 <1e91d9dd-d787-beff-2c14-9c76ffc3b285@redhat.com>
 <a319cba3-8b3d-8968-0fb7-48a1d34042bf@intel.com>
 <67c4c41d-9e95-2270-4acb-6f04668c34fa@redhat.com>
 <20200716021435-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <918ef7c7-852e-6c0a-ed0d-fac3fa6752e4@redhat.com>
Date:   Thu, 16 Jul 2020 16:06:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716021435-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/16 下午2:15, Michael S. Tsirkin wrote:
> On Thu, Jul 16, 2020 at 12:20:09PM +0800, Jason Wang wrote:
>> On 2020/7/16 下午12:13, Zhu, Lingshan wrote:
>>> On 7/16/2020 12:02 PM, Jason Wang wrote:
>>>> On 2020/7/16 上午11:59, Zhu, Lingshan wrote:
>>>>> On 7/16/2020 10:59 AM, Jason Wang wrote:
>>>>>> On 2020/7/16 上午9:39, Zhu, Lingshan wrote:
>>>>>>> On 7/15/2020 9:43 PM, Jason Wang wrote:
>>>>>>>> On 2020/7/12 下午10:52, Zhu Lingshan wrote:
>>>>>>>>> Hi All,
>>>>>>>>>
>>>>>>>>> This series intends to implement IRQ offloading for
>>>>>>>>> vhost_vdpa.
>>>>>>>>>
>>>>>>>>> By the feat of irq forwarding facilities like posted
>>>>>>>>> interrupt on X86, irq bypass can  help deliver
>>>>>>>>> interrupts to vCPU directly.
>>>>>>>>>
>>>>>>>>> vDPA devices have dedicated hardware backends like VFIO
>>>>>>>>> pass-throughed devices. So it would be possible to setup
>>>>>>>>> irq offloading(irq bypass) for vDPA devices and gain
>>>>>>>>> performance improvements.
>>>>>>>>>
>>>>>>>>> In my testing, with this feature, we can save 0.1ms
>>>>>>>>> in a ping between two VFs on average.
>>>>>>>> Hi Lingshan:
>>>>>>>>
>>>>>>>> During the virtio-networking meeting, Michael spots
>>>>>>>> two possible issues:
>>>>>>>>
>>>>>>>> 1) do we need an new uAPI to stop the irq offloading?
>>>>>>>> 2) can interrupt lost during the eventfd ctx?
>>>>>>>>
>>>>>>>> For 1) I think we probably not, we can allocate an
>>>>>>>> independent eventfd which does not map to MSIX. So
>>>>>>>> the consumer can't match the producer and we
>>>>>>>> fallback to eventfd based irq.
>>>>>>> Hi Jason,
>>>>>>>
>>>>>>> I wonder why we need to stop irq offloading, but if we
>>>>>>> need to do so, maybe a new uAPI would be more intuitive
>>>>>>> to me,
>>>>>>> but why and who(user? qemu?) shall initialize this
>>>>>>> process, based on what kinda of basis to make the
>>>>>>> decision?
>>>>>> The reason is we may want to fallback to software datapath
>>>>>> for some reason (e.g software assisted live migration). In
>>>>>> this case we need intercept device write to used ring so we
>>>>>> can not offloading virtqueue interrupt in this case.
>>>>> so add a VHOST_VDPA_STOP_IRQ_OFFLOADING? Then do we need a
>>>>> VHOST_VDPA_START_IRQ_OFFLOADING, then let userspace fully
>>>>> control this? Or any better approaches?
>>>> Probably not, it's as simple as allocating another eventfd (but not
>>>> irqfd), and pass it to vhost-vdpa. Then the offloading is disabled
>>>> since it doesn't have a consumer.
>>> OK, sounds like QEMU work, no need to take care in this series, right?
>> That's my understanding.
>>
>> Thanks
> Let's confirm a switch happens atomically so each interrupt
> is sent either to eventfd to guest directly though.


I think it's safe since:

1) we don't alloc/free interrupt during the eventfd change
2) The irte is modified automatically through cmpxchg_double() in 
modify_irte(), so the interrupt is either remapping to eventfd or pi 
descriptor

Thanks


>

