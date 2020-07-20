Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA57225BE2
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgGTJkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:40:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33612 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726520AbgGTJkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 05:40:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595238046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XRNrRgwLLLMF30OdZNuJ7/SKYD2BOTDMSbZ1OQlAfhU=;
        b=NAGAr09yUy7KM7r6zbZc1beByn9/7/cSWRL1eRg8l1NxZIfAzfSgJ6eoXT3Eu1clcxJgyJ
        OAbyWHfAyJRmVxB1pHA9DKoFzb5Fqp/z4QmQyv+66nCOgO59wXbfikgsdonVsjbcen8SgU
        LQDzqxfb2i4IIDK4uOnUP/HaY8ZTJgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-s-3AwpSQO0eLnoo6P8H9bg-1; Mon, 20 Jul 2020 05:40:42 -0400
X-MC-Unique: s-3AwpSQO0eLnoo6P8H9bg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81191108B;
        Mon, 20 Jul 2020 09:40:40 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 015BF5D9DD;
        Mon, 20 Jul 2020 09:40:31 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <625c08af-a81f-d834-bb41-538c3dc9acb4@redhat.com>
Date:   Mon, 20 Jul 2020 17:40:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <45b2cc93-6ae1-47c7-aae6-01afdab1094b@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/20 下午5:07, Zhu, Lingshan wrote:
>>>
>>> +}
>>> +
>>> +static void vdpa_unsetup_irq(struct vdpa_device *vdev, int qid)
>>> +{
>>> +    struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
>>> +
>>> +    if (drv->unsetup_vq_irq)
>>> +        drv->unsetup_vq_irq(vdev, qid);
>>
>>
>> Do you need to check the existence of drv before calling unset_vq_irq()?
> Yes, we should check this when we take the releasing path into account.
>>
>> And how can this synchronize with driver releasing and binding?
> Will add an vdpa_unsetup_irq() call in vhsot_vdpa_release().
> For binding, I think it is a new dev bound to the the driver,
> it should go through the vdpa_setup_irq() routine. or if it is
> a device re-bind to vhost_vdpa, I think we have cleaned up
> irq_bypass_producer for it as we would call vhdpa_unsetup_irq()
> in the release function.


I meant can the following things happen?

1) some vDPA device driver probe the hardware and call 
vdpa_request_irq() in its PCI probe function.
2) vDPA device is probed by vhost-vDPA

Then irq bypass can't work since we when vdpa_unsetup_irq() is called, 
there's no driver bound. Or is there a requirement that 
vdap_request/free_irq() must be called somewhere (e.g in the set_status 
bus operations)? If yes, we need document those requirements.

Thanks

