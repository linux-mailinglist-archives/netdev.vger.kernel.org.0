Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939D2227617
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgGUCwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:52:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37601 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728493AbgGUCwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:52:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595299926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AVfhEPEFhV0AVMrKjgxaKndxZmacnTOsvGyzEG28+sU=;
        b=AvwV6Pv8LEfK1a50BDsw8oA5KwVPBGYUdaPORONBIZPpM+4alCdefEzxygeQmzMk1pKa1y
        IcK7J5Cn0EjB29mJD8BWB5jDB/ONClOfDeXn8178xIxvlRNB4g4VZrIvWVoS2ENN2xl5Y7
        geit21YBAVHjKsk6xL/cNlgrjIPjThk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-HQQh50hVOI2WstCvI9GlYA-1; Mon, 20 Jul 2020 22:52:03 -0400
X-MC-Unique: HQQh50hVOI2WstCvI9GlYA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F53C107ACCA;
        Tue, 21 Jul 2020 02:52:01 +0000 (UTC)
Received: from [10.72.13.146] (ovpn-13-146.pek2.redhat.com [10.72.13.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA88373FCF;
        Tue, 21 Jul 2020 02:51:45 +0000 (UTC)
Subject: Re: [PATCH V2 3/6] vDPA: implement IRQ offloading helpers in vDPA
 core
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-4-git-send-email-lingshan.zhu@intel.com>
 <ab4644cc-9668-a909-4dea-5416aacf7221@redhat.com>
 <45b2cc93-6ae1-47c7-aae6-01afdab1094b@intel.com>
 <625c08af-a81f-d834-bb41-538c3dc9acb4@redhat.com>
 <8c9adead-d3a0-374e-e817-3cb5a44c4bda@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8d12231e-aabe-317e-0afb-d680b866304b@redhat.com>
Date:   Tue, 21 Jul 2020 10:51:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8c9adead-d3a0-374e-e817-3cb5a44c4bda@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/21 上午10:02, Zhu, Lingshan wrote:
>
>
> On 7/20/2020 5:40 PM, Jason Wang wrote:
>>
>> On 2020/7/20 下午5:07, Zhu, Lingshan wrote:
>>>>>
>>>>> +}
>>>>> +
>>>>> +static void vdpa_unsetup_irq(struct vdpa_device *vdev, int qid)
>>>>> +{
>>>>> +    struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
>>>>> +
>>>>> +    if (drv->unsetup_vq_irq)
>>>>> +        drv->unsetup_vq_irq(vdev, qid);
>>>>
>>>>
>>>> Do you need to check the existence of drv before calling 
>>>> unset_vq_irq()?
>>> Yes, we should check this when we take the releasing path into account.
>>>>
>>>> And how can this synchronize with driver releasing and binding?
>>> Will add an vdpa_unsetup_irq() call in vhsot_vdpa_release().
>>> For binding, I think it is a new dev bound to the the driver,
>>> it should go through the vdpa_setup_irq() routine. or if it is
>>> a device re-bind to vhost_vdpa, I think we have cleaned up
>>> irq_bypass_producer for it as we would call vhdpa_unsetup_irq()
>>> in the release function.
>>
>>
>> I meant can the following things happen?
>>
>> 1) some vDPA device driver probe the hardware and call 
>> vdpa_request_irq() in its PCI probe function.
>> 2) vDPA device is probed by vhost-vDPA
>>
>> Then irq bypass can't work since we when vdpa_unsetup_irq() is 
>> called, there's no driver bound. Or is there a requirement that 
>> vdap_request/free_irq() must be called somewhere (e.g in the 
>> set_status bus operations)? If yes, we need document those requirements.
> vdpa_unseup_irq is only called when we want to unregister the producer,


Typo, I meant vdpa_setup_irq().

Thanks


>   now we have two code path using it: free_irq and relaase(). I agree we can document this requirements for the helpers, these functions can only be called through status changes(DRIVER_OK and !DRIVER_OK).
>
> Thanks,
> BR
> Zhu Lingshan
>>
>> Thanks
>>

