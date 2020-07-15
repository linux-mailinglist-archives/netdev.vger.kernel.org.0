Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE09A220790
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgGOIkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:40:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38273 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729373AbgGOIkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594802434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/F7UB0C20VNqw+FeXrj3A9Z7I7KbYpRyx/C6DjbnOzc=;
        b=Q3FnEqywEU8RdMNsW7Yr4SsSZbTX4gRLH9Cq62Stiedz/UC+jjbIHW5rUGwxZNbYg43rba
        ebZK6ehpPmOJ4J4RiyPGus22UuL37whOnBZPR3kUAmQ4k+qu/fluAaMsujPmG59cFTo6Qg
        KH/dhLPDyw81ne2TprKJLMrt5A/wI8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-O8TVwaXDN4uNsMsEh9Ji-w-1; Wed, 15 Jul 2020 04:40:30 -0400
X-MC-Unique: O8TVwaXDN4uNsMsEh9Ji-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C046410CE780;
        Wed, 15 Jul 2020 08:40:28 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A7B372E63;
        Wed, 15 Jul 2020 08:40:18 +0000 (UTC)
Subject: Re: [PATCH 6/7] ifcvf: replace irq_request/free with helpers in vDPA
 core.
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-6-git-send-email-lingshan.zhu@intel.com>
 <c7d4eca1-b65a-b795-dfa6-fe7658716cb1@redhat.com>
 <f6fc09e2-7a45-aaa5-2b4a-f1f963c5ce2c@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <09e67c20-dda1-97a2-1858-6a543c64fba6@redhat.com>
Date:   Wed, 15 Jul 2020 16:40:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f6fc09e2-7a45-aaa5-2b4a-f1f963c5ce2c@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/13 下午6:22, Zhu, Lingshan wrote:
>
>
> On 7/13/2020 4:33 PM, Jason Wang wrote:
>>
>> On 2020/7/12 下午10:49, Zhu Lingshan wrote:
>>> This commit replaced irq_request/free() with helpers in vDPA
>>> core, so that it can request/free irq and setup irq offloading
>>> on order.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 11 ++++++-----
>>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index f5a60c1..65b84e1 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -47,11 +47,12 @@ static void ifcvf_free_irq(struct ifcvf_adapter 
>>> *adapter, int queues)
>>>   {
>>>       struct pci_dev *pdev = adapter->pdev;
>>>       struct ifcvf_hw *vf = &adapter->vf;
>>> +    struct vdpa_device *vdpa = &adapter->vdpa;
>>>       int i;
>>>           for (i = 0; i < queues; i++)
>>> -        devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>>> +        vdpa_free_vq_irq(&pdev->dev, vdpa, vf->vring[i].irq, i, 
>>> &vf->vring[i]);
>>>         ifcvf_free_irq_vectors(pdev);
>>>   }
>>> @@ -60,6 +61,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter 
>>> *adapter)
>>>   {
>>>       struct pci_dev *pdev = adapter->pdev;
>>>       struct ifcvf_hw *vf = &adapter->vf;
>>> +    struct vdpa_device *vdpa = &adapter->vdpa;
>>>       int vector, i, ret, irq;
>>>         ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
>>> @@ -73,6 +75,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter 
>>> *adapter)
>>>            pci_name(pdev));
>>>       vector = 0;
>>>       irq = pci_irq_vector(pdev, vector);
>>> +    /* config interrupt */
>>
>>
>> Unnecessary changes.
> This is to show we did not setup this irq offloading for config 
> interrupt, only setup irq offloading for data vq. But can remove this 
> since we have config_msix_name in code to show what it is


Btw, any reason for not making config interrupt work for irq offloading? 
I don't see any thing that blocks this.

Thanks


> Thanks BR Zhu Lingshan
>>

