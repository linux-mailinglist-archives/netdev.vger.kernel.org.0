Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF7B241512
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 04:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgHKCyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 22:54:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23951 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726831AbgHKCyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 22:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597114444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QkQRU8e1rT0qyUbw+JJg0ZU52Alo7Rsy9OtRuJe42bU=;
        b=cviDHsbqAEfE3GQrYb2JNiXIWf4uYWB7H1CgHrMuCgRYZ2mivgaI4yvqAw3x8ClE3lFnEI
        aV37dxG8zszfPridfzngkM0KQV5VAg4aJh1UDUvfXAOXH/EDSSWv3hONceTdnd22hAgfJ5
        EuRJRNdJVF9wUaW0cFueDoni3uElqdA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-nBBoDX1iNRmQDYLbImgUYw-1; Mon, 10 Aug 2020 22:54:00 -0400
X-MC-Unique: nBBoDX1iNRmQDYLbImgUYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B44418A0F01;
        Tue, 11 Aug 2020 02:53:59 +0000 (UTC)
Received: from [10.72.13.186] (ovpn-13-186.pek2.redhat.com [10.72.13.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DAB9101E7F9;
        Tue, 11 Aug 2020 02:53:49 +0000 (UTC)
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
 <14fd2bf1-e9c1-a192-bd6c-f1ee5fd227f6@redhat.com>
 <20200810093630-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b669a4c6-f3d7-6cf0-0f7e-8058628c0138@redhat.com>
Date:   Tue, 11 Aug 2020 10:53:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810093630-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/8/10 下午9:37, Michael S. Tsirkin wrote:
> On Wed, Aug 05, 2020 at 10:16:16AM +0800, Jason Wang wrote:
>> On 2020/8/4 下午5:21, Michael S. Tsirkin wrote:
>>>>>>>     +struct vhost_vring_call {
>>>>>>> +    struct eventfd_ctx *ctx;
>>>>>>> +    struct irq_bypass_producer producer;
>>>>>>> +    spinlock_t ctx_lock;
>>>>>> It's not clear to me why we need ctx_lock here.
>>>>>>
>>>>>> Thanks
>>>>> Hi Jason,
>>>>>
>>>>> we use this lock to protect the eventfd_ctx and irq from race conditions,
>>>> We don't support irq notification from vDPA device driver in this version,
>>>> do we still have race condition?
>>>>
>>>> Thanks
>>> Jason I'm not sure what you are trying to say here.
>>
>> I meant we change the API from V4 so driver won't notify us if irq is
>> changed.
>>
>> Then it looks to me there's no need for the ctx_lock, everyhing could be
>> synchronized with vq mutex.
>>
>> Thanks
> Jason do you want to post a cleanup patch simplifying code along these
> lines?


Ling Shan promised to post a patch to fix this.

Thanks


>
> Thanks,
>
>
>>>

