Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7BC306B5D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhA1DG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:06:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhA1DG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 22:06:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611803100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZtvGjwvPJQPTd5iszx1z5cgMmarf/C6MBn65XN9DRzU=;
        b=U/Fp2NoCkI6yeq6CNly09sbU/OX/oWM6yNobWO3+lgVPeldnCVkWXnMMe2gtYuKc86HtP+
        p0IIfzXFaBrx4nm/F4dct0nO1ZYAwSYSAHAaCNuIMHfqTP1+BUv0lTgnuNE5QXLHpWgr5E
        nBvITbN7i73V6pxYRkqs1gMfzpCWmHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-jvgTJUraNSKs0lUfxy9d5A-1; Wed, 27 Jan 2021 22:04:58 -0500
X-MC-Unique: jvgTJUraNSKs0lUfxy9d5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDBA1107ACE3;
        Thu, 28 Jan 2021 03:04:55 +0000 (UTC)
Received: from [10.72.12.167] (ovpn-12-167.pek2.redhat.com [10.72.12.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D36235D9E3;
        Thu, 28 Jan 2021 03:04:43 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b5c9f2d4-5b95-4552-3886-f5cbcb7de232@redhat.com>
Date:   Thu, 28 Jan 2021 11:04:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3sqDgccOfNcY_FNcHDqJ2DeMbigdFuHYm9DxWWMjkL7CQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/27 下午5:11, Yongji Xie wrote:
> On Wed, Jan 27, 2021 at 11:38 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/1/20 下午2:52, Yongji Xie wrote:
>>> On Wed, Jan 20, 2021 at 12:24 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/1/19 下午12:59, Xie Yongji wrote:
>>>>> Now we have a global percpu counter to limit the recursion depth
>>>>> of eventfd_signal(). This can avoid deadlock or stack overflow.
>>>>> But in stack overflow case, it should be OK to increase the
>>>>> recursion depth if needed. So we add a percpu counter in eventfd_ctx
>>>>> to limit the recursion depth for deadlock case. Then it could be
>>>>> fine to increase the global percpu counter later.
>>>> I wonder whether or not it's worth to introduce percpu for each eventfd.
>>>>
>>>> How about simply check if eventfd_signal_count() is greater than 2?
>>>>
>>> It can't avoid deadlock in this way.
>>
>> I may miss something but the count is to avoid recursive eventfd call.
>> So for VDUSE what we suffers is e.g the interrupt injection path:
>>
>> userspace write IRQFD -> vq->cb() -> another IRQFD.
>>
>> It looks like increasing EVENTFD_WAKEUP_DEPTH should be sufficient?
>>
> Actually I mean the deadlock described in commit f0b493e ("io_uring:
> prevent potential eventfd recursion on poll"). It can break this bug
> fix if we just increase EVENTFD_WAKEUP_DEPTH.


Ok, so can wait do something similar in that commit? (using async stuffs 
like wq).

Thanks


>
> Thanks,
> Yongji
>

