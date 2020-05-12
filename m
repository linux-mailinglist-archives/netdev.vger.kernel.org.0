Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22D01CEBA2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgELDlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:41:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51463 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728710AbgELDlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589254881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1WZWZXE1nGez71XEyOueHoIOeCX5yLfPNsW+lHVCAeg=;
        b=SNiOgtXExxRAN7dRFnHP9XkBNoa5av1GCYnEc5h+DQYqULM7NsQrUwydsNGzeOPzZlU47U
        bike4DRAQRhuBWgcu0bOcn7M5rF4rRCdNn6qEV44BMp4KGkq5LyUAcr1nWWeGYuXfx+Mmi
        59SyfVCU11EeZbI/YM/t+t8n2OQ8HCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-0-PIybqDMpSy_6h9ah9lWg-1; Mon, 11 May 2020 23:41:19 -0400
X-MC-Unique: 0-PIybqDMpSy_6h9ah9lWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B3C18005B7;
        Tue, 12 May 2020 03:41:18 +0000 (UTC)
Received: from [10.72.13.96] (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D00F761988;
        Tue, 12 May 2020 03:41:11 +0000 (UTC)
Subject: Re: [PATCH] ifcvf: move IRQ request/free to status change handlers
To:     Francesco Lavra <francescolavra.fl@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1589181563-38400-1-git-send-email-lingshan.zhu@intel.com>
 <22d9dcdb-e790-0a68-ba41-b9530b2bf9fd@redhat.com>
 <c1da2054-eb4c-d7dd-ca83-29e85e5cfe90@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <289e3487-7ecc-6b82-35d5-3037e34c8e31@redhat.com>
Date:   Tue, 12 May 2020 11:41:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c1da2054-eb4c-d7dd-ca83-29e85e5cfe90@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/11 下午6:18, Francesco Lavra wrote:
> On 5/11/20 11:26 AM, Jason Wang wrote:
>>
>> On 2020/5/11 下午3:19, Zhu Lingshan wrote:
>>> This commit move IRQ request and free operations from probe()
>>> to VIRTIO status change handler to comply with VIRTIO spec.
>>>
>>> VIRTIO spec 1.1, section 2.1.2 Device Requirements: Device Status Field
>>> The device MUST NOT consume buffers or send any used buffer
>>> notifications to the driver before DRIVER_OK.
>>
>>
>> My previous explanation might be wrong here. It depends on how you 
>> implement your hardware, if you hardware guarantee that no interrupt 
>> will be triggered before DRIVER_OK, then it's fine.
>>
>> And the main goal for this patch is to allocate the interrupt on demand.
>>
>>
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 119 
>>> ++++++++++++++++++++++++----------------
>>>   1 file changed, 73 insertions(+), 46 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index abf6a061..4d58bf2 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -28,6 +28,60 @@ static irqreturn_t ifcvf_intr_handler(int irq, 
>>> void *arg)
>>>       return IRQ_HANDLED;
>>>   }
>>> +static void ifcvf_free_irq_vectors(void *data)
>>> +{
>>> +    pci_free_irq_vectors(data);
>>> +}
>>> +
>>> +static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>>> +{
>>> +    struct pci_dev *pdev = adapter->pdev;
>>> +    struct ifcvf_hw *vf = &adapter->vf;
>>> +    int i;
>>> +
>>> +
>>> +    for (i = 0; i < queues; i++)
>>> +        devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>>> +
>>> +    ifcvf_free_irq_vectors(pdev);
>>> +}
>>> +
>>> +static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>>> +{
>>> +    struct pci_dev *pdev = adapter->pdev;
>>> +    struct ifcvf_hw *vf = &adapter->vf;
>>> +    int vector, i, ret, irq;
>>> +
>>> +    ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
>>> +                    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
>>> +    if (ret < 0) {
>>> +        IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>>> +        snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
>>> +             pci_name(pdev), i);
>>> +        vector = i + IFCVF_MSI_QUEUE_OFF;
>>> +        irq = pci_irq_vector(pdev, vector);
>>> +        ret = devm_request_irq(&pdev->dev, irq,
>>> +                       ifcvf_intr_handler, 0,
>>> +                       vf->vring[i].msix_name,
>>> +                       &vf->vring[i]);
>>> +        if (ret) {
>>> +            IFCVF_ERR(pdev,
>>> +                  "Failed to request irq for vq %d\n", i);
>>> +            ifcvf_free_irq(adapter, i);
>>
>>
>> I'm not sure this unwind is correct. It looks like we should loop and 
>> call devm_free_irq() for virtqueue [0, i);
>
> That's exactly what the code does: ifcvf_free_irq() contains a (i = 0; 
> i < queues; i++) loop, and here the function is called with the 
> `queues` argument set to `i`.
>

Oh right.

Thanks

