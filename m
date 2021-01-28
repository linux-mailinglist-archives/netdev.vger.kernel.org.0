Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B9306C47
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhA1EdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:33:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231261AbhA1Ecu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:32:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611808284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9NCZe85xmzeU0w+bJ6oE1HvmZ9MVGIS2YzFczMlWDrw=;
        b=Uxw/rJYS4Bla7ayXGVGoPI6cblHzatw7MofRh+wWmEz3LRP3RkEg4u3JaQgL+zshKmVQTP
        kx2IRQZqqq/oomsrIKwjCTF49Eoi5kNc/sjPlc0j8Pp8imKYqPWZu8fm/KPzC1SKeEeMWn
        XfWkP20yofFDPTUIAxhgCv4MRqadZw0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-rl1Hd8ASP-Cc1ju6c1ceNg-1; Wed, 27 Jan 2021 23:31:20 -0500
X-MC-Unique: rl1Hd8ASP-Cc1ju6c1ceNg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D323801FCC;
        Thu, 28 Jan 2021 04:31:18 +0000 (UTC)
Received: from [10.72.12.167] (ovpn-12-167.pek2.redhat.com [10.72.12.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A1685C1BB;
        Thu, 28 Jan 2021 04:31:03 +0000 (UTC)
Subject: Re: [RFC v3 01/11] eventfd: track eventfd_signal() recursion depth
 separately in different cases
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-2-xieyongji@bytedance.com>
 <e8a2cc15-80f5-01e0-75ec-ea6281fda0eb@redhat.com>
 <CACycT3sN0+dg-NubAK+N-DWf3UDXwWh=RyRX-qC9fwdg3QaLWA@mail.gmail.com>
 <6a5f0186-c2e3-4603-9826-50d5c68a3fda@redhat.com>
 <CACycT3sqDgccOfNcY_FNcHDqJ2DeMbigdFuHYm9DxWWMjkL7CQ@mail.gmail.com>
 <b5c9f2d4-5b95-4552-3886-f5cbcb7de232@redhat.com>
 <CACycT3u6Ayf_X8Mv4EvF+B=B4OzFSK8ygvJMRnO6CDgYF13Qnw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9226c594-e045-544d-4e46-c4c3c9c573a9@redhat.com>
Date:   Thu, 28 Jan 2021 12:31:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3u6Ayf_X8Mv4EvF+B=B4OzFSK8ygvJMRnO6CDgYF13Qnw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/28 上午11:52, Yongji Xie wrote:
> On Thu, Jan 28, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/1/27 下午5:11, Yongji Xie wrote:
>>> On Wed, Jan 27, 2021 at 11:38 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/1/20 下午2:52, Yongji Xie wrote:
>>>>> On Wed, Jan 20, 2021 at 12:24 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> On 2021/1/19 下午12:59, Xie Yongji wrote:
>>>>>>> Now we have a global percpu counter to limit the recursion depth
>>>>>>> of eventfd_signal(). This can avoid deadlock or stack overflow.
>>>>>>> But in stack overflow case, it should be OK to increase the
>>>>>>> recursion depth if needed. So we add a percpu counter in eventfd_ctx
>>>>>>> to limit the recursion depth for deadlock case. Then it could be
>>>>>>> fine to increase the global percpu counter later.
>>>>>> I wonder whether or not it's worth to introduce percpu for each eventfd.
>>>>>>
>>>>>> How about simply check if eventfd_signal_count() is greater than 2?
>>>>>>
>>>>> It can't avoid deadlock in this way.
>>>> I may miss something but the count is to avoid recursive eventfd call.
>>>> So for VDUSE what we suffers is e.g the interrupt injection path:
>>>>
>>>> userspace write IRQFD -> vq->cb() -> another IRQFD.
>>>>
>>>> It looks like increasing EVENTFD_WAKEUP_DEPTH should be sufficient?
>>>>
>>> Actually I mean the deadlock described in commit f0b493e ("io_uring:
>>> prevent potential eventfd recursion on poll"). It can break this bug
>>> fix if we just increase EVENTFD_WAKEUP_DEPTH.
>>
>> Ok, so can wait do something similar in that commit? (using async stuffs
>> like wq).
>>
> We can do that. But it will reduce the performance. Because the
> eventfd recursion will be triggered every time kvm kick eventfd in
> vhost-vdpa cases:
>
> KVM write KICKFD -> ops->kick_vq -> VDUSE write KICKFD
>
> Thanks,
> Yongji


Right, I think in the future we need to find a way to let KVM to wakeup 
VDUSE directly.

Havn't had a deep thought but it might work like irq bypass manager.

Thanks


