Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866D72307AB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgG1KaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:30:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728424AbgG1KaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595932209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2eXwPZgBliCyd1sHEj5P6kwd7xBg6PnDz+mvU5GcUYk=;
        b=a0AeAKjHFFAaT3FbNrrmWOQrU5P6DOegJwUbVDFSkdqt0M5iS2Z6OWMBvSoPcSvRtmKsaZ
        rkXV39ewHfTPbGGTbBakSeMfs/e6VOIfhW4g6yB4A+PfJ++gINQF9cwWMvb6Zjlwuxok4j
        mY5c+rNcla6DYZ+v2quQhMpI/LiOsoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-hrqz5xcqMXaBppmT1Ngusg-1; Tue, 28 Jul 2020 06:30:07 -0400
X-MC-Unique: hrqz5xcqMXaBppmT1Ngusg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9FBF101C8A7;
        Tue, 28 Jul 2020 10:30:05 +0000 (UTC)
Received: from [10.72.13.242] (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E18C171F9;
        Tue, 28 Jul 2020 10:29:53 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
 <10dd83c0-f68a-ed9e-9860-45c215fc67f6@redhat.com>
 <f3e375da-3aa8-7a0c-237c-25943667a535@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a017e479-2ea5-459f-a016-011d53e09ced@redhat.com>
Date:   Tue, 28 Jul 2020 18:29:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f3e375da-3aa8-7a0c-237c-25943667a535@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/28 下午5:18, Zhu, Lingshan wrote:
>>>
>>>        * status to 0.
>>> @@ -167,6 +220,15 @@ static long vhost_vdpa_set_status(struct 
>>> vhost_vdpa *v, u8 __user *statusp)
>>>       if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
>>>           return -EINVAL;
>>>   +    /* vq irq is not expected to be changed once DRIVER_OK is set */
>>
>>
>> So this basically limit the usage of get_vq_irq() in the context 
>> vhost_vdpa_set_status() and other vDPA bus drivers' set_status(). If 
>> this is true, there's even no need to introduce any new config ops 
>> but just let set_status() to return the irqs used for the device. Or 
>> if we want this to be more generic, we need vpda's own irq manager 
>> (which should be similar to irq bypass manager). That is:
> I think there is no need for a driver to free / re-request its irqs after DRIVER_OK though it can do so. If a driver changed its irq of a vq after DRIVER_OK, the vq is still operational but will lose irq offloading that is reasonable.
> If we want set_status() return irqs, we need to record the irqs somewhere in vdpa_device,


Why, we can simply pass an array to the driver I think?

void (*set_status)(struct vdpa_device *vdev, u8 status, int *irqs);


> as we discussed in a previous thread, this may need initialize and cleanup works, so a new ops
> with proper comments (don't say they could not change irq, but highlight if irq changes, irq offloading will not work till next DRIVER_OK) could be more elegant.
> However if we really need to change irq after DRIVER_OK, I think maybe we still need vDPA vq irq allocate / free helpers, then the helpers can not be used in probe() as we discussed before, it is a step back to V3 series.


Still, it's not about whether driver may change irq after DRIVER_OK but 
implication of the assumption. If one bus ops must be called in another 
ops, it's better to just implement them in one ops.


>>
>> - bus driver can register itself as consumer
>> - vDPA device driver can register itself as producer
>> - matching via queue index
> IMHO, is it too heavy for this feature,


Do you mean LOCs? We can:

1) refactor irq bypass manager
2) invent it our own (a much simplified version compared to bypass manager)
3) enforcing them via vDPA bus

Each of the above should be not a lot of coding. I think method 3 is 
partially done in your previous series but in an implicit manner:

- bus driver that has alloc_irq/free_irq implemented could be implicitly 
treated as consumer registering
- every vDPA device driver could be treated as producer
- vdpa_devm_alloc_irq() could be treated as producer registering
- alloc_irq/free_irq is the add_producer/del_procuer

We probably just lack some synchronization with driver probe/remove.


> and how can they match if two individual adapters both have vq idx = 1.


The matching is per vDPA device.

Thanks


> Thanks!
>> - deal with registering/unregistering of consumer/producer
>>
>> So there's no need to care when or where the vDPA device driver to 
>> allocate the irq, and we don't need to care at which context the vDPA 
>> bus driver can use the irq. Either side may get notified when the 
>> other side is gone (though we only care about the gone of producer 
>> probably).
>>
>> Any thought on this?
>>
>> Thanks
>>
>>

