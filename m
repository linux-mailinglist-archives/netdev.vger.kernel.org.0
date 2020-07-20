Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE16D2258CD
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgGTHkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:40:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:37388 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgGTHkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 03:40:52 -0400
IronPort-SDR: ZOcKE1l2L5QxAIyfrvx45+4eMEveSbbMKolgkIS1+EkT717c+Kmde9jXY9A3E7qLVC6rdOpU7P
 PdVlyitKHQxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="147367459"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="147367459"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 00:40:51 -0700
IronPort-SDR: r3apDs/M39y8U9qBqfznT76nBN59T7vgMnEp2Hgn/vsSE549zA+3c4uipxC7uEpVe9OlSlcM0P
 7Z6nwkPCwFpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="361945020"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.29.73]) ([10.255.29.73])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2020 00:40:47 -0700
Subject: Re: [PATCH V2 2/6] kvm: detect assigned device via irqbypass manager
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-3-git-send-email-lingshan.zhu@intel.com>
 <f8e0ced4-2883-e022-8fd0-1224987ebef1@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <d58a86b7-b7de-65d8-dbd8-174c4f305d8f@intel.com>
Date:   Mon, 20 Jul 2020 15:40:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <f8e0ced4-2883-e022-8fd0-1224987ebef1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/17/2020 12:01 PM, Jason Wang wrote:
>
> On 2020/7/16 下午7:23, Zhu Lingshan wrote:
>> vDPA devices has dedicated backed hardware like
>> passthrough-ed devices. Then it is possible to setup irq
>> offloading to vCPU for vDPA devices. Thus this patch tries to
>> manipulated assigned device counters via irqbypass manager.
>
>
> This part needs some tweak, e.g why assigned device could be detected 
> through this way.
>
>
>>
>> We will increase/decrease the assigned device counter in kvm/x86.
>
>
> And you need explain why we don't need similar thing in other arch.
>
> Thanks
OK Thanks!
>
>
>> Both vDPA and VFIO would go through this code path.
>>
>> This code path only affect x86 for now.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 00c88c2..20c07d3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10624,11 +10624,17 @@ int kvm_arch_irq_bypass_add_producer(struct 
>> irq_bypass_consumer *cons,
>>   {
>>       struct kvm_kernel_irqfd *irqfd =
>>           container_of(cons, struct kvm_kernel_irqfd, consumer);
>> +    int ret;
>>         irqfd->producer = prod;
>> +    kvm_arch_start_assignment(irqfd->kvm);
>> +    ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
>> +                     prod->irq, irqfd->gsi, 1);
>> +
>> +    if (ret)
>> +        kvm_arch_end_assignment(irqfd->kvm);
>>   -    return kvm_x86_ops.update_pi_irte(irqfd->kvm,
>> -                       prod->irq, irqfd->gsi, 1);
>> +    return ret;
>>   }
>>     void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer 
>> *cons,
>
