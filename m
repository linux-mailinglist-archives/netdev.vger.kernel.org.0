Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842C52E23A5
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 03:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgLXC00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 21:26:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728707AbgLXC00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 21:26:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608776699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdMJ8HnlG5riluBKSxMPivzDGvzPYrwD7jfW+dFij+4=;
        b=MssOKCuMveF3r3K5h9JFVQdW7TOg/Ohcb2eNNDPfuzyfx95nCpuzPGeAsYKOiTD4SiVjGD
        j847a025MBNffLxQ4DaYXMkzHHS/oRsK7QZQXgGeHBA4LPWYYewQ8p5ML8sy/2Vi1mP2vD
        J9x3IdRZVPInWVNQlUGkBzxd6mGqGVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-z5fT8538NHm7DeP68XxA3w-1; Wed, 23 Dec 2020 21:24:58 -0500
X-MC-Unique: z5fT8538NHm7DeP68XxA3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85A081005D4F;
        Thu, 24 Dec 2020 02:24:55 +0000 (UTC)
Received: from [10.72.13.109] (ovpn-13-109.pek2.redhat.com [10.72.13.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4130D60C04;
        Thu, 24 Dec 2020 02:24:31 +0000 (UTC)
Subject: Re: [RFC v2 00/13] Introduce VDUSE - vDPA Device in Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <c892652a-3f57-c337-8c67-084ba6d10834@redhat.com>
 <CACycT3tr-1EDeH4j0AojD+-qM5yqDUU0tQHieVUXgL7AOTHyvQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6e81f56a-0f95-248c-e88f-4190ca7f49a2@redhat.com>
Date:   Thu, 24 Dec 2020 10:24:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3tr-1EDeH4j0AojD+-qM5yqDUU0tQHieVUXgL7AOTHyvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/23 下午6:59, Yongji Xie wrote:
> On Wed, Dec 23, 2020 at 2:38 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/12/22 下午10:52, Xie Yongji wrote:
>>> This series introduces a framework, which can be used to implement
>>> vDPA Devices in a userspace program. The work consist of two parts:
>>> control path forwarding and data path offloading.
>>>
>>> In the control path, the VDUSE driver will make use of message
>>> mechnism to forward the config operation from vdpa bus driver
>>> to userspace. Userspace can use read()/write() to receive/reply
>>> those control messages.
>>>
>>> In the data path, the core is mapping dma buffer into VDUSE
>>> daemon's address space, which can be implemented in different ways
>>> depending on the vdpa bus to which the vDPA device is attached.
>>>
>>> In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
>>> bounce-buffering mechanism to achieve that.
>>
>> Rethink about the bounce buffer stuffs. I wonder instead of using kernel
>> pages with mmap(), how about just use userspace pages like what vhost did?
>>
>> It means we need a worker to do bouncing but we don't need to care about
>> annoying stuffs like page reclaiming?
>>
> Now the I/O bouncing is done in the streaming DMA mapping routines
> which can be called from interrupt context. If we put this into a
> kworker, that means we need to synchronize with a kworker in an
> interrupt context. I think it can't work.


We just need to make sure the buffer is ready before the user is trying 
to access them.

But I admit it would be tricky (require shadow virtqueue etc) which is 
probably not a good idea.

Thanks


>
> Thanks,
> Yongji
>

