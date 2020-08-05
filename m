Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788DD23C54B
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 07:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgHEFyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 01:54:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56956 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEFyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 01:54:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596606840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dfDQG4tby0nd+utieNRaPsFTAyk7GxdbToWcw/3rz4=;
        b=HfN9lhAt93AAh1wOUz8jjomqOJY34N+Cy28ZYjYePadnA4UD8athPp25kp5BDMGEmfpoPc
        tNKaRGfdbzMGyRjYP1DoIop9ic0ODeilNBRtPHyX55uUTPj6b6xyum3QjXb1kYWeiGRiun
        a4NqNdqQIgb6kq+GLIYThnTFPiREdus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-xFmTAAppM6e3bePnSZYNjw-1; Wed, 05 Aug 2020 01:53:56 -0400
X-MC-Unique: xFmTAAppM6e3bePnSZYNjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B3DB102C7ED;
        Wed,  5 Aug 2020 05:53:55 +0000 (UTC)
Received: from [10.72.12.225] (ovpn-12-225.pek2.redhat.com [10.72.12.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77FF75C1BD;
        Wed,  5 Aug 2020 05:53:45 +0000 (UTC)
Subject: Re: [PATCH V5 1/6] vhost: introduce vhost_vring_call
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-2-lingshan.zhu@intel.com>
 <5e646141-ca8d-77a5-6f41-d30710d91e6d@redhat.com>
 <d51dd4e3-7513-c771-104c-b61f9ee70f30@intel.com>
 <156b8d71-6870-c163-fdfa-35bf4701987d@redhat.com>
 <20200804052050-mutt-send-email-mst@kernel.org>
 <14fd2bf1-e9c1-a192-bd6c-f1ee5fd227f6@redhat.com>
 <bf10cde9-db86-a1ac-e2a8-363735e49afb@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <aa18c90f-a315-7d40-cdb7-812b98a9c4f4@redhat.com>
Date:   Wed, 5 Aug 2020 13:53:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bf10cde9-db86-a1ac-e2a8-363735e49afb@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/8/5 下午1:49, Zhu, Lingshan wrote:
>
>
> On 8/5/2020 10:16 AM, Jason Wang wrote:
>>
>> On 2020/8/4 下午5:21, Michael S. Tsirkin wrote:
>>>>>>>    +struct vhost_vring_call {
>>>>>>> +    struct eventfd_ctx *ctx;
>>>>>>> +    struct irq_bypass_producer producer;
>>>>>>> +    spinlock_t ctx_lock;
>>>>>> It's not clear to me why we need ctx_lock here.
>>>>>>
>>>>>> Thanks
>>>>> Hi Jason,
>>>>>
>>>>> we use this lock to protect the eventfd_ctx and irq from race 
>>>>> conditions,
>>>> We don't support irq notification from vDPA device driver in this 
>>>> version,
>>>> do we still have race condition?
>>>>
>>>> Thanks
>>> Jason I'm not sure what you are trying to say here.
>>
>>
>> I meant we change the API from V4 so driver won't notify us if irq is 
>> changed.
>>
>> Then it looks to me there's no need for the ctx_lock, everyhing could 
>> be synchronized with vq mutex.
>>
>> Thanks
> from V4 to V5, there are only some minor improvements and bug fix, get_vq_irq() almost stays untouched, mutex can work for this, however I see the vq mutex is used in many scenarios.
> We only use this lock to protect the producer information, can this help to get less coupling, defensive code for less bugs?


I think not, vq mutex is used to protect all vq related data structure, 
introducing another one will increase the complexity.

Thanks


>
> Thanks
>>
>>>
>>>
>>

