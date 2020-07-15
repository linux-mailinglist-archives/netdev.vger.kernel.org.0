Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341FB220905
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgGOJmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:42:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58089 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730338AbgGOJmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 05:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594806169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVN0SUJiWNQOMGmLO1R6WOiZV8nRybRORnIp3pu3RNw=;
        b=KmSi0GUntHAji6qNUhz25b1hNpkBd9R6wd1Cbj2P0dDybv5EVcfQn+5YVVjHEfGB5KfUD7
        qnsRf9A0114NW70+WqCNbRIs2ahVg1CqU0c4QoJ2nzkQh8Ba6sUgL00JxDTX3duECO3rJD
        LEi11yfGUay3ml6UcIyBWOefp5OUHaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-JARX-4MgPmqeCi7a5jNSaA-1; Wed, 15 Jul 2020 05:42:44 -0400
X-MC-Unique: JARX-4MgPmqeCi7a5jNSaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE7201800D42;
        Wed, 15 Jul 2020 09:42:42 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3395310013D0;
        Wed, 15 Jul 2020 09:42:34 +0000 (UTC)
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
 <2bd946e3-1524-efa5-df2b-3f6da66d2069@redhat.com>
 <61c1753a-43dc-e448-6ece-13a19058e621@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c9f2ffb0-adc0-8846-9578-1f75a4374df1@redhat.com>
Date:   Wed, 15 Jul 2020 17:42:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <61c1753a-43dc-e448-6ece-13a19058e621@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/15 下午5:20, Zhu, Lingshan wrote:
>>>>
>>>> I meant something like:
>>>>
>>>> unregister();
>>>> vq->call_ctx.producer.token = ctx;
>>>> register();
>>> This is what we are doing now, or I must missed somethig:
>>> if (ctx && ctx != token) {
>>>     irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>     vq->call_ctx.producer.token = ctx;
>>>     irq_bypass_register_producer(&vq->call_ctx.producer);
>>>
>>> }
>>>
>>> It just unregister and register.
>>
>>
>> I meant there's probably no need for the check and another check and 
>> unregister before. The whole function is as simple as I suggested above.
>>
>> Thanks
> IMHO we still need the checks, this function handles three cases:
> (1)if the ctx == token, we do nothing. For this unregister and register can work, but waste of time.


But we have a more simple code and we don't care about the performance 
here since the operations is rare.


> (2)if token exists but ctx is NULL, this means user space issued an unbind, so we need to only unregister the producer.


Note that the register/unregister have a graceful check of whether or 
not there's a token.


> (3)if ctx exists and ctx!=token, this means there is a new ctx, we need to update producer by unregister and register.
>
> I think we can not simply handle all these cases by "unregister and register".


So it looks to me the functions are equivalent.

Thanks


>
> Thanks,
> BR
> Zhu Lingshan

