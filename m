Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCC922082E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgGOJGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:06:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23946 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgGOJGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 05:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594804011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkT/mfOztj7MXzinVB5YZHkTYz0nQ/PoAvfbNJ/41g4=;
        b=FZw5vcMzqAEqgTKRv6K9HRq7ey4GojczCebM6X/8VWldX5MLz57RWfN7Y6OdHtMdwbX2NS
        QPVvmsNixl0ebCnIESUgDrT3SevJq60X/xWBC3tYFM1cYfRZTerGwp5XKRNUOKS7pnkH1/
        N8SmoBtoFLm2z4EHRhvhkXPxhc0Uqo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-_nHiHvUkObuB9D03Lhv-BA-1; Wed, 15 Jul 2020 05:06:50 -0400
X-MC-Unique: _nHiHvUkObuB9D03Lhv-BA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65C5B1087;
        Wed, 15 Jul 2020 09:06:48 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1EAA74F71;
        Wed, 15 Jul 2020 09:06:38 +0000 (UTC)
Subject: Re: [PATCH 3/7] vhost_vdpa: implement IRQ offloading functions in
 vhost_vdpa
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-3-git-send-email-lingshan.zhu@intel.com>
 <3fb9ecfc-a325-69b5-f5b7-476a5683a324@redhat.com>
 <e06f9706-441f-0d7a-c8c0-cd43a26c5296@intel.com>
 <f352a1d1-6732-3237-c85e-ffca085195ff@redhat.com>
 <8f52ee3a-7a08-db14-9194-8085432481a4@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2bd946e3-1524-efa5-df2b-3f6da66d2069@redhat.com>
Date:   Wed, 15 Jul 2020 17:06:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8f52ee3a-7a08-db14-9194-8085432481a4@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/15 下午4:56, Zhu, Lingshan wrote:
>
>
> On 7/15/2020 4:51 PM, Jason Wang wrote:
>>
>> On 2020/7/13 下午5:47, Zhu, Lingshan wrote:
>>>
>>>
>>> On 7/13/2020 4:22 PM, Jason Wang wrote:
>>>>
>>>> On 2020/7/12 下午10:49, Zhu Lingshan wrote:
>>>>> This patch introduce a set of functions for setup/unsetup
>>>>> and update irq offloading respectively by register/unregister
>>>>> and re-register the irq_bypass_producer.
>>>>>
>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>> ---
>>>>>   drivers/vhost/vdpa.c | 69 
>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>   1 file changed, 69 insertions(+)
>>>>>
>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>> index 2fcc422..92683e4 100644
>>>>> --- a/drivers/vhost/vdpa.c
>>>>> +++ b/drivers/vhost/vdpa.c
>>>>> @@ -115,6 +115,63 @@ static irqreturn_t vhost_vdpa_config_cb(void 
>>>>> *private)
>>>>>       return IRQ_HANDLED;
>>>>>   }
>>>>>   +static void vhost_vdpa_setup_vq_irq(struct vdpa_device *dev, 
>>>>> int qid, int irq)
>>>>> +{
>>>>> +    struct vhost_vdpa *v = vdpa_get_drvdata(dev);
>>>>> +    struct vhost_virtqueue *vq = &v->vqs[qid];
>>>>> +    int ret;
>>>>> +
>>>>> +    vq_err(vq, "setup irq bypass for vq %d with irq = %d\n", qid, 
>>>>> irq);
>>>>> +    spin_lock(&vq->call_ctx.ctx_lock);
>>>>> +    if (!vq->call_ctx.ctx)
>>>>> +        return;
>>>>> +
>>>>> +    vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>>> +    vq->call_ctx.producer.irq = irq;
>>>>> +    ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>>>>> +    spin_unlock(&vq->call_ctx.ctx_lock);
>>>>> +
>>>>> +    if (unlikely(ret))
>>>>> +        vq_err(vq,
>>>>> +        "irq bypass producer (token %p registration fails: %d\n",
>>>>> +        vq->call_ctx.producer.token, ret);
>>>>
>>>>
>>>> Not sure this deserves a vq_err(), irq will be relayed through 
>>>> eventfd if irq bypass manager can't work.
>>> OK, I see vq_err() will eventfd_signal err_ctx than just print a 
>>> message, will remove all vq_err().
>>>>
>>>>
>>>>> +}
>>>>> +
>>>>> +static void vhost_vdpa_unsetup_vq_irq(struct vdpa_device *dev, 
>>>>> int qid)
>>>>> +{
>>>>> +    struct vhost_vdpa *v = vdpa_get_drvdata(dev);
>>>>> +    struct vhost_virtqueue *vq = &v->vqs[qid];
>>>>> +
>>>>> +    spin_lock(&vq->call_ctx.ctx_lock);
>>>>> + irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>> +    spin_unlock(&vq->call_ctx.ctx_lock);
>>>>> +
>>>>> +    vq_err(vq, "unsetup irq bypass for vq %d\n", qid);
>>>>
>>>>
>>>> Why call vq_err() here?
>>>>
>>>>
>>>>> +}
>>>>> +
>>>>> +static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
>>>>> +{
>>>>> +    struct eventfd_ctx *ctx;
>>>>> +    void *token;
>>>>> +
>>>>> +    spin_lock(&vq->call_ctx.ctx_lock);
>>>>> +    ctx = vq->call_ctx.ctx;
>>>>> +    token = vq->call_ctx.producer.token;
>>>>> +    if (ctx == token)
>>>>> +        return;
>>>>
>>>>
>>>> Need do unlock here.
>>> sure!
>>>>
>>>>
>>>>> +
>>>>> +    if (!ctx && token)
>>>>> + irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>> +
>>>>> +    if (ctx && ctx != token) {
>>>>> + irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>> +        vq->call_ctx.producer.token = ctx;
>>>>> + irq_bypass_register_producer(&vq->call_ctx.producer);
>>>>> +    }
>>>>> +
>>>>> +    spin_unlock(&vq->call_ctx.ctx_lock);
>>>>
>>>>
>>>> This should be rare so I'd use simple codes just do unregister and 
>>>> register.
>>>
>>> do you mean remove "if (ctx && ctx != token)"? I think this could be 
>>> useful, we should only update it when ctx!=NULL and ctx!= existing 
>>> token.
>>>
>>
>> I meant something like:
>>
>> unregister();
>> vq->call_ctx.producer.token = ctx;
>> register();
> This is what we are doing now, or I must missed somethig:
> if (ctx && ctx != token) {
> 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> 	vq->call_ctx.producer.token = ctx;
> 	irq_bypass_register_producer(&vq->call_ctx.producer);
>
> }
>
> It just unregister and register.


I meant there's probably no need for the check and another check and 
unregister before. The whole function is as simple as I suggested above.

Thanks


>
> Thanks,
> BR
> Zhu Lingshan

