Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55BAE4A6
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfIJH2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfIJH2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 03:28:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A41AF81F2F;
        Tue, 10 Sep 2019 07:28:33 +0000 (UTC)
Received: from [10.72.12.188] (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23B5660BF3;
        Tue, 10 Sep 2019 07:28:28 +0000 (UTC)
Subject: Re: [RFC PATCH untested] vhost: block speculation of translated
 descriptors
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20190908110521.4031-1-mst@redhat.com>
 <db4d77d7-c467-935d-b4ae-1da7635e9b6b@redhat.com>
 <20190909104355-mutt-send-email-mst@kernel.org>
 <9ab48e0f-50a9-bed4-1801-73c37a7da27c@redhat.com>
 <20190910024814-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bb71974e-a8b3-4cc4-f3e1-e48118469b78@redhat.com>
Date:   Tue, 10 Sep 2019 15:28:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910024814-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 10 Sep 2019 07:28:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/10 下午2:48, Michael S. Tsirkin wrote:
> On Tue, Sep 10, 2019 at 09:52:10AM +0800, Jason Wang wrote:
>> On 2019/9/9 下午10:45, Michael S. Tsirkin wrote:
>>> On Mon, Sep 09, 2019 at 03:19:55PM +0800, Jason Wang wrote:
>>>> On 2019/9/8 下午7:05, Michael S. Tsirkin wrote:
>>>>> iovec addresses coming from vhost are assumed to be
>>>>> pre-validated, but in fact can be speculated to a value
>>>>> out of range.
>>>>>
>>>>> Userspace address are later validated with array_index_nospec so we can
>>>>> be sure kernel info does not leak through these addresses, but vhost
>>>>> must also not leak userspace info outside the allowed memory table to
>>>>> guests.
>>>>>
>>>>> Following the defence in depth principle, make sure
>>>>> the address is not validated out of node range.
>>>>>
>>>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>>>> ---
>>>>>     drivers/vhost/vhost.c | 4 +++-
>>>>>     1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>>>> index 5dc174ac8cac..0ee375fb7145 100644
>>>>> --- a/drivers/vhost/vhost.c
>>>>> +++ b/drivers/vhost/vhost.c
>>>>> @@ -2072,7 +2072,9 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>>>>>     		size = node->size - addr + node->start;
>>>>>     		_iov->iov_len = min((u64)len - s, size);
>>>>>     		_iov->iov_base = (void __user *)(unsigned long)
>>>>> -			(node->userspace_addr + addr - node->start);
>>>>> +			(node->userspace_addr +
>>>>> +			 array_index_nospec(addr - node->start,
>>>>> +					    node->size));
>>>>>     		s += size;
>>>>>     		addr += size;
>>>>>     		++ret;
>>>> I've tried this on Kaby Lake smap off metadata acceleration off using
>>>> testpmd (virtio-user) + vhost_net. I don't see obvious performance
>>>> difference with TX PPS.
>>>>
>>>> Thanks
>>> Should I push this to Linus right now then? It's a security thing so
>>> maybe we better do it ASAP ... what's your opinion?
>>
>> Yes, you can.
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>
> And should I include
>
> Tested-by: Jason Wang <jasowang@redhat.com>
>
> ?


Yes.

Thanks


>
>>
