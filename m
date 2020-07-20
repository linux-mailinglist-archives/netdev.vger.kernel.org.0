Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5C22567B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 06:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgGTETy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 00:19:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbgGTETx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 00:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595218792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04wRZDzfAbjzY24AOQSUyoqCb/wNOPZL7NBzxLPbzVc=;
        b=Th5aOFzFuuITP3XQy8b+7s/gwxOp6ibKciGcBdhxuaggEZQQIIZ2LvVSBlyk9mb7L3LwMk
        +LtKXIAnzx2+UUHUn2LCKtxC/u1OwLylpLp8ZC/YeR4gdxjfCVdGrCk3SM+zZ55M62tzAo
        5Dd8oSA5qMCTdp7oeLthLSl3r+5WyIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-9KzyVAvVO_aogPSdmTB61Q-1; Mon, 20 Jul 2020 00:19:51 -0400
X-MC-Unique: 9KzyVAvVO_aogPSdmTB61Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FF53107ACCA;
        Mon, 20 Jul 2020 04:19:49 +0000 (UTC)
Received: from [10.72.13.139] (ovpn-13-139.pek2.redhat.com [10.72.13.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B12925C1B2;
        Mon, 20 Jul 2020 04:19:38 +0000 (UTC)
Subject: Re: [PATCH V2 2/6] kvm: detect assigned device via irqbypass manager
To:     Alex Williamson <alex.williamson@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-3-git-send-email-lingshan.zhu@intel.com>
 <20200717120821.3c2a56db@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c46dc561-610e-e992-8bb9-e7286a560971@redhat.com>
Date:   Mon, 20 Jul 2020 12:19:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717120821.3c2a56db@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/18 上午2:08, Alex Williamson wrote:
> On Thu, 16 Jul 2020 19:23:45 +0800
> Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
>> vDPA devices has dedicated backed hardware like
>> passthrough-ed devices. Then it is possible to setup irq
>> offloading to vCPU for vDPA devices. Thus this patch tries to
>> manipulated assigned device counters via irqbypass manager.
>>
>> We will increase/decrease the assigned device counter in kvm/x86.
>> Both vDPA and VFIO would go through this code path.
>>
>> This code path only affect x86 for now.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
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
>
> Why isn't there a matching end-assignment in the del_producer path?  It
> seems this only goes one-way, what happens when a device is
> hot-unplugged from the VM or the device interrupt configuration changes.
> This will still break vfio if it's not guaranteed to be symmetric.
> Thanks,
>
> Alex


Yes, we need add logic in the del_producer path.

Thanks


