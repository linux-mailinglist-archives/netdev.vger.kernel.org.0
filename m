Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68295336BEA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCKGOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:14:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhCKGNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615443213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O9dIFx5T4B5wQEwSmY/A6qMcWPDW41QAG6OtpF0Rp64=;
        b=OEmBVMboLLBGPCjTcsuRU8tLDXe7ddsx8bVFxx2P44JFlprfDmyfuA/3mru/NiXyOHTQrD
        znFDsbtZgyUnkG9kKxXcSR6P5jarNav05VnCtCZVcw5vgqBLY2kubf8sXWfeIdDSmm9jX+
        jBmrKRZM3Sm/QB7vLQTYoorLjCWUmg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-WCvA8jlCO1WyXxzT1CSOpQ-1; Thu, 11 Mar 2021 01:13:29 -0500
X-MC-Unique: WCvA8jlCO1WyXxzT1CSOpQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 345071858F17;
        Thu, 11 Mar 2021 06:13:28 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D63A5945D;
        Thu, 11 Mar 2021 06:13:21 +0000 (UTC)
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_vendor_id returns a device
 specific vendor id
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-2-lingshan.zhu@intel.com>
 <ff5fc8f9-f886-bd2a-60cc-771c628c6c4b@redhat.com>
 <5f2d915f-e1b0-c9eb-9fc8-4b64f5d8cd0f@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <05e3fbc9-be49-a208-19a4-85f891323312@redhat.com>
Date:   Thu, 11 Mar 2021 14:13:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <5f2d915f-e1b0-c9eb-9fc8-4b64f5d8cd0f@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/11 12:21 下午, Zhu Lingshan wrote:
>
>
> On 3/11/2021 11:23 AM, Jason Wang wrote:
>>
>> On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
>>> In this commit, ifcvf_get_vendor_id() will return
>>> a device specific vendor id of the probed pci device
>>> than a hard code.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index fa1af301cf55..e501ee07de17 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -324,7 +324,10 @@ static u32 ifcvf_vdpa_get_device_id(struct 
>>> vdpa_device *vdpa_dev)
>>>     static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>>>   {
>>> -    return IFCVF_SUBSYS_VENDOR_ID;
>>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>> +    struct pci_dev *pdev = adapter->pdev;
>>> +
>>> +    return pdev->subsystem_vendor;
>>>   }
>>
>>
>> While at this, I wonder if we can do something similar in 
>> get_device_id() if it could be simple deduced from some simple math 
>> from the pci device id?
>>
>> Thanks
> Hi Jason,
>
> IMHO, this implementation is just some memory read ops, I think other 
> implementations may not save many cpu cycles, an if cost at least 
> three cpu cycles.
>
> Thanks!


Well, I meant whehter you can deduce virtio device id from 
pdev->subsystem_device.

Thanks


>>
>>
>>>     static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>>
>

