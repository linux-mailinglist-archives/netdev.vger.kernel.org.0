Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EDD23C357
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 04:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgHECQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 22:16:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47246 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgHECQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 22:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596593791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIaIax/zR4vv8fiWp11anUcThIo6Y4H4WRFdeKCBt5s=;
        b=T4DvWWa2WoYt99i/67QD2/WVBaRvBU3xCG5cDjdDeMMC7qfreVYL0Hcc94Nc354akIwyvh
        bIu572HJOaRIwX4a95UG5YDTaQTN/Ob11TeqQqUR03uBKrzSr1mBTTNbdAuVMkDVxwZAH1
        RDvaEj6nUTM6+uVmgaI4L3q4PjWoMCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-AV2FqgRGPRKYsArtpv6xzg-1; Tue, 04 Aug 2020 22:16:29 -0400
X-MC-Unique: AV2FqgRGPRKYsArtpv6xzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 275A110059A2;
        Wed,  5 Aug 2020 02:16:28 +0000 (UTC)
Received: from [10.72.13.71] (ovpn-13-71.pek2.redhat.com [10.72.13.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0C3069318;
        Wed,  5 Aug 2020 02:16:18 +0000 (UTC)
Subject: Re: [PATCH V5 1/6] vhost: introduce vhost_vring_call
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <14fd2bf1-e9c1-a192-bd6c-f1ee5fd227f6@redhat.com>
Date:   Wed, 5 Aug 2020 10:16:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804052050-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/8/4 下午5:21, Michael S. Tsirkin wrote:
>>>>>    +struct vhost_vring_call {
>>>>> +    struct eventfd_ctx *ctx;
>>>>> +    struct irq_bypass_producer producer;
>>>>> +    spinlock_t ctx_lock;
>>>> It's not clear to me why we need ctx_lock here.
>>>>
>>>> Thanks
>>> Hi Jason,
>>>
>>> we use this lock to protect the eventfd_ctx and irq from race conditions,
>> We don't support irq notification from vDPA device driver in this version,
>> do we still have race condition?
>>
>> Thanks
> Jason I'm not sure what you are trying to say here.


I meant we change the API from V4 so driver won't notify us if irq is 
changed.

Then it looks to me there's no need for the ctx_lock, everyhing could be 
synchronized with vq mutex.

Thanks

>
>

