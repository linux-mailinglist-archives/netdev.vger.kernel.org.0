Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BCF32DFE4
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhCEDFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:05:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhCEDFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:05:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NyeZ19kifPGrNPSu9tsx+U9SHlXSaVFqXfzKSyjA9QU=;
        b=YxScW7OW5tMBG6f7L5d2S4CpSakIw154kHKhBMMDJNl/Jcvcf/ZCMlUz3CARg0Cc9lBQhU
        Iiq9z6ChScuevoFqKBRcyM3Y6kvKKUwHkXWGFj8LqVEROlDcRfbF87bvG2N8p4jgKBgM1U
        Mc993Uk2151l3TV/oU49l1UlERY9670=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-3LT2sfD5N0eNx-b62H3FiQ-1; Thu, 04 Mar 2021 22:05:00 -0500
X-MC-Unique: 3LT2sfD5N0eNx-b62H3FiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C35F1084C83;
        Fri,  5 Mar 2021 03:04:57 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-196.pek2.redhat.com [10.72.13.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ECCC60C0F;
        Fri,  5 Mar 2021 03:04:44 +0000 (UTC)
Subject: Re: [RFC v4 10/11] vduse: Introduce a workqueue for irq injection
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com>
 <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com>
Date:   Fri, 5 Mar 2021 11:04:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/4 4:58 下午, Yongji Xie wrote:
> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/2/23 7:50 下午, Xie Yongji wrote:
>>> This patch introduces a workqueue to support injecting
>>> virtqueue's interrupt asynchronously. This is mainly
>>> for performance considerations which makes sure the push()
>>> and pop() for used vring can be asynchronous.
>>
>> Do you have pref numbers for this patch?
>>
> No, I can do some tests for it if needed.
>
> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be useless
> if we call irq callback in ioctl context. Something like:
>
> virtqueue_push();
> virtio_notify();
>      ioctl()
> -------------------------------------------------
>          irq_cb()
>              virtqueue_get_buf()
>
> The used vring is always empty each time we call virtqueue_push() in
> userspace. Not sure if it is what we expected.


I'm not sure I get the issue.

THe used ring should be filled by virtqueue_push() which is done by 
userspace before?

Thanks


>
> Thanks,
> Yongji
>

