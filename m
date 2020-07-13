Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641AD21D171
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 10:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgGMIN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 04:13:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25661 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgGMIN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 04:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594628037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDIIbeFWjeiYWcEE6x++JM/zrUI1nqU1Dw3s/3xLuXs=;
        b=BsTNOU42/P5PhLRoyQ6JuQyTv9LuPIBeMSCVnF2p9IHkk1GOIjGDQod03UTaV9XPWkaU5O
        XX7znMMQ1AdnXYw+REyXBTLTlcY6stQ6fnr8JEiecDtiehlWiK45BOhCBwhqIMNbDjqj19
        wE8LrhrxYUK/7c4sYNDqBecoTv71jmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-F44ahv7OO4y7684P9vMV4A-1; Mon, 13 Jul 2020 04:13:52 -0400
X-MC-Unique: F44ahv7OO4y7684P9vMV4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A323B107ACCA;
        Mon, 13 Jul 2020 08:13:51 +0000 (UTC)
Received: from [10.72.13.177] (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E9B86FEF3;
        Mon, 13 Jul 2020 08:13:36 +0000 (UTC)
Subject: Re: [PATCH 2/7] kvm/vfio: detect assigned device via irqbypass
 manager
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-2-git-send-email-lingshan.zhu@intel.com>
 <20200712170518-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bcb03e95-d8b9-6e19-5b0e-0119d3f43d6d@redhat.com>
Date:   Mon, 13 Jul 2020 16:13:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200712170518-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/13 上午5:06, Michael S. Tsirkin wrote:
> On Sun, Jul 12, 2020 at 10:49:21PM +0800, Zhu Lingshan wrote:
>> We used to detect assigned device via VFIO manipulated device
>> conters. This is less flexible consider VFIO is not the only
>> interface for assigned device. vDPA devices has dedicated
>> backed hardware as well. So this patch tries to detect
>> the assigned device via irqbypass manager.
>>
>> We will increase/decrease the assigned device counter in kvm/x86.
>> Both vDPA and VFIO would go through this code path.
>>
>> This code path only affect x86 for now.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>
> I think it's best to leave VFIO alone. Add appropriate APIs for VDPA,
> worry about converting existing users later.



Just to make sure I understand, did you mean:

1) introduce another bridge for vDPA

or

2) only detect vDPA via bypass manager? (we can leave VFIO code as is, 
then the assigned device counter may increase/decrease twice if VFIO use 
irq bypass manager which should be no harm).

Thanks


>
>> ---
>>   arch/x86/kvm/x86.c | 10 ++++++++--
>>   virt/kvm/vfio.c    |  2 --
>>   2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 00c88c2..20c07d3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10624,11 +10624,17 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>>   {
>>   	struct kvm_kernel_irqfd *irqfd =
>>   		container_of(cons, struct kvm_kernel_irqfd, consumer);
>> +	int ret;
>>   
>>   	irqfd->producer = prod;
>> +	kvm_arch_start_assignment(irqfd->kvm);
>> +	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
>> +					 prod->irq, irqfd->gsi, 1);
>> +
>> +	if (ret)
>> +		kvm_arch_end_assignment(irqfd->kvm);
>>   
>> -	return kvm_x86_ops.update_pi_irte(irqfd->kvm,
>> -					   prod->irq, irqfd->gsi, 1);
>> +	return ret;
>>   }
>>   
>>   void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>> index 8fcbc50..111da52 100644
>> --- a/virt/kvm/vfio.c
>> +++ b/virt/kvm/vfio.c
>> @@ -226,7 +226,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>>   		list_add_tail(&kvg->node, &kv->group_list);
>>   		kvg->vfio_group = vfio_group;
>>   
>> -		kvm_arch_start_assignment(dev->kvm);
>>   
>>   		mutex_unlock(&kv->lock);
>>   
>> @@ -254,7 +253,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>>   				continue;
>>   
>>   			list_del(&kvg->node);
>> -			kvm_arch_end_assignment(dev->kvm);
>>   #ifdef CONFIG_SPAPR_TCE_IOMMU
>>   			kvm_spapr_tce_release_vfio_group(dev->kvm,
>>   							 kvg->vfio_group);
>> -- 
>> 1.8.3.1

