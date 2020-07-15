Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF04220B50
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 13:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgGOLLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 07:11:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:26068 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729826AbgGOLKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 07:10:42 -0400
IronPort-SDR: zk0zOTlNmv5kOGhYhZLsuPWJFFToHYjzFOHmor2vIlUmjDaqga/WsKwHtB8dBexb3HzNIOtHpZ
 GYvA/x3KDNQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129211919"
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="129211919"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 04:10:40 -0700
IronPort-SDR: 6DcJAI47bbUJIfMVcs20lJlqGAVcbDvdPgVo9KMBfPj811B2oOgF3VoasSTigz79o9kk5nX6d/
 o1hCF19Rev4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="460032576"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.172.100]) ([10.249.172.100])
  by orsmga005.jf.intel.com with ESMTP; 15 Jul 2020 04:10:37 -0700
Subject: Re: [PATCH 6/7] ifcvf: replace irq_request/free with helpers in vDPA
 core.
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-6-git-send-email-lingshan.zhu@intel.com>
 <c7d4eca1-b65a-b795-dfa6-fe7658716cb1@redhat.com>
 <f6fc09e2-7a45-aaa5-2b4a-f1f963c5ce2c@intel.com>
 <09e67c20-dda1-97a2-1858-6a543c64fba6@redhat.com>
 <20200715055538-mutt-send-email-mst@kernel.org>
 <eefc2969-c91e-059e-ed4a-20ce8fa6dfe9@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <5f40e96d-c270-cc0b-e536-8cfb6d0ba7ef@intel.com>
Date:   Wed, 15 Jul 2020 19:10:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <eefc2969-c91e-059e-ed4a-20ce8fa6dfe9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/15/2020 6:04 PM, Jason Wang wrote:
>
> On 2020/7/15 下午6:01, Michael S. Tsirkin wrote:
>> On Wed, Jul 15, 2020 at 04:40:17PM +0800, Jason Wang wrote:
>>> On 2020/7/13 下午6:22, Zhu, Lingshan wrote:
>>>> On 7/13/2020 4:33 PM, Jason Wang wrote:
>>>>> On 2020/7/12 下午10:49, Zhu Lingshan wrote:
>>>>>> This commit replaced irq_request/free() with helpers in vDPA
>>>>>> core, so that it can request/free irq and setup irq offloading
>>>>>> on order.
>>>>>>
>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>> ---
>>>>>>    drivers/vdpa/ifcvf/ifcvf_main.c | 11 ++++++-----
>>>>>>    1 file changed, 6 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>> index f5a60c1..65b84e1 100644
>>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>> @@ -47,11 +47,12 @@ static void ifcvf_free_irq(struct
>>>>>> ifcvf_adapter *adapter, int queues)
>>>>>>    {
>>>>>>        struct pci_dev *pdev = adapter->pdev;
>>>>>>        struct ifcvf_hw *vf = &adapter->vf;
>>>>>> +    struct vdpa_device *vdpa = &adapter->vdpa;
>>>>>>        int i;
>>>>>>            for (i = 0; i < queues; i++)
>>>>>> -        devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>>>>>> +        vdpa_free_vq_irq(&pdev->dev, vdpa, vf->vring[i].irq, i,
>>>>>> &vf->vring[i]);
>>>>>>          ifcvf_free_irq_vectors(pdev);
>>>>>>    }
>>>>>> @@ -60,6 +61,7 @@ static int ifcvf_request_irq(struct
>>>>>> ifcvf_adapter *adapter)
>>>>>>    {
>>>>>>        struct pci_dev *pdev = adapter->pdev;
>>>>>>        struct ifcvf_hw *vf = &adapter->vf;
>>>>>> +    struct vdpa_device *vdpa = &adapter->vdpa;
>>>>>>        int vector, i, ret, irq;
>>>>>>          ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
>>>>>> @@ -73,6 +75,7 @@ static int ifcvf_request_irq(struct
>>>>>> ifcvf_adapter *adapter)
>>>>>>             pci_name(pdev));
>>>>>>        vector = 0;
>>>>>>        irq = pci_irq_vector(pdev, vector);
>>>>>> +    /* config interrupt */
>>>>> Unnecessary changes.
>>>> This is to show we did not setup this irq offloading for config
>>>> interrupt, only setup irq offloading for data vq. But can remove this
>>>> since we have config_msix_name in code to show what it is
>>> Btw, any reason for not making config interrupt work for irq 
>>> offloading? I
>>> don't see any thing that blocks this.
>>>
>>> Thanks
>> Well config accesses all go through userspace right?
>> Doing config interrupt directly would just be messy ...
>
>
> Right, so I think we need a better comment here.
Thanks, will add a better comment than just "config interrupt".
>
> Thanks
>
>
>>
>>
>
