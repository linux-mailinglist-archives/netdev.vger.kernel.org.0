Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D54F36D573
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 12:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238705AbhD1KKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 06:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238774AbhD1KKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 06:10:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619604561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tCmCVcCGcXEgbhMIg1rIIz1DwzlDEOvC3LtivSI+s+8=;
        b=IFFAIn0CkougvgKMQOKZbxKyMArZ9qLnpCkLQxxakndJ8EOdtfs14PgbIiKdokI0qjT0PE
        cge86TSAydPqkeBwhRmPpmK4O0y2oho7xkotF2dSl3Eu3flor0pVLT21cCQwHWP26yzdM1
        O8bnJ8hguoKNa0htfi29/ghAFVAxOjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-mXh6x8uYMpOqAsImOovtJw-1; Wed, 28 Apr 2021 06:09:19 -0400
X-MC-Unique: mXh6x8uYMpOqAsImOovtJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F34CF801106;
        Wed, 28 Apr 2021 10:09:17 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-25.pek2.redhat.com [10.72.12.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5A021001B2C;
        Wed, 28 Apr 2021 10:09:12 +0000 (UTC)
Subject: Re: [PATCH 1/2] vDPA/ifcvf: record virtio notify base
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
 <20210428082133.6766-2-lingshan.zhu@intel.com>
 <55217869-b456-f3bc-0b5a-6beaf34c19f8@redhat.com>
 <3243eeef-2891-5b79-29cb-bc969802c5dc@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4cee04f1-a3fc-eaf0-747a-004ca09b06c0@redhat.com>
Date:   Wed, 28 Apr 2021 18:09:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <3243eeef-2891-5b79-29cb-bc969802c5dc@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/28 下午6:00, Zhu, Lingshan 写道:
>
>
> On 4/28/2021 4:39 PM, Jason Wang wrote:
>>
>> 在 2021/4/28 下午4:21, Zhu Lingshan 写道:
>>> This commit records virtio notify base addr to implemente
>>> doorbell mapping feature
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_base.c | 1 +
>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>>>   2 files changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>>> index 1a661ab45af5..cc61a5bfc5b1 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>>> @@ -133,6 +133,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct 
>>> pci_dev *pdev)
>>> &hw->notify_off_multiplier);
>>>               hw->notify_bar = cap.bar;
>>>               hw->notify_base = get_cap_addr(hw, &cap);
>>> +            hw->notify_pa = pci_resource_start(pdev, cap.bar) + 
>>> cap.offset;
>>
>>
>> To be more generic and avoid future changes, let's use the math 
>> defined in the virtio spec.
>>
>> You may refer how it is implemented in virtio_pci vdpa driver[1].
> Are you suggesting every vq keep its own notify_pa? In this case, we 
> still need to record notify_pa in hw when init_hw, then initialize 
> vq->notify_pa accrediting to hw->notify_pa.


I meant you need to follow how virtio spec did to calculate the doorbell 
address per vq:

         cap.offset + queue_notify_off * notify_off_multiplier

Obviously, you ignore queue_notify_off and notify_off_multiplier here. 
This may bring troubles for the existing device IFCVF and future devices.

If I understand correctly, this device can be probed by virtio-pci 
driver which use the above math. There's no reason for using ad-hoc hack.

Thanks


>
> Thanks
> Zhu Lingshan
>>
>> Thanks
>>
>> [1] 
>> https://lore.kernel.org/virtualization/20210415073147.19331-5-jasowang@redhat.com/T/
>>
>>
>>> IFCVF_DBG(pdev, "hw->notify_base = %p\n",
>>>                     hw->notify_base);
>>>               break;
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> index 0111bfdeb342..bcca7c1669dd 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> @@ -98,6 +98,7 @@ struct ifcvf_hw {
>>>       char config_msix_name[256];
>>>       struct vdpa_callback config_cb;
>>>       unsigned int config_irq;
>>> +    phys_addr_t  notify_pa;
>>>   };
>>>     struct ifcvf_adapter {
>>
>

