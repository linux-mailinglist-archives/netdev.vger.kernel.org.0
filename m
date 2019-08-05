Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67888141E
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfHEIYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 04:24:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfHEIYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 04:24:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5938630923D0;
        Mon,  5 Aug 2019 08:24:33 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AC761000323;
        Mon,  5 Aug 2019 08:24:28 +0000 (UTC)
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <e8ecb811-6653-cff4-bc11-81f4ccb0dbbf@redhat.com>
 <494ac30d-b750-52c8-b927-16cd4b9414c4@redhat.com>
 <20190805023106-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <86444f93-e507-cfd9-598b-51466bb02354@redhat.com>
Date:   Mon, 5 Aug 2019 16:24:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805023106-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 05 Aug 2019 08:24:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/5 下午2:40, Michael S. Tsirkin wrote:
> On Mon, Aug 05, 2019 at 12:41:45PM +0800, Jason Wang wrote:
>> On 2019/8/5 下午12:36, Jason Wang wrote:
>>> On 2019/8/2 下午10:27, Michael S. Tsirkin wrote:
>>>> On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
>>>>> On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
>>>>>>> This must be a proper barrier, like a spinlock, mutex, or
>>>>>>> synchronize_rcu.
>>>>>> I start with synchronize_rcu() but both you and Michael raise some
>>>>>> concern.
>>>>> I've also idly wondered if calling synchronize_rcu() under the various
>>>>> mm locks is a deadlock situation.
>>>>>
>>>>>> Then I try spinlock and mutex:
>>>>>>
>>>>>> 1) spinlock: add lots of overhead on datapath, this leads 0
>>>>>> performance
>>>>>> improvement.
>>>>> I think the topic here is correctness not performance improvement
>>>> The topic is whether we should revert
>>>> commit 7f466032dc9 ("vhost: access vq metadata through kernel
>>>> virtual address")
>>>>
>>>> or keep it in. The only reason to keep it is performance.
>>>
>>> Maybe it's time to introduce the config option?
>>
>> Or does it make sense if I post a V3 with:
>>
>> - introduce config option and disable the optimization by default
>>
>> - switch from synchronize_rcu() to vhost_flush_work(), but the rest are the
>> same
>>
>> This can give us some breath to decide which way should go for next release?
>>
>> Thanks
> As is, with preempt enabled?  Nope I don't think blocking an invalidator
> on swap IO is ok, so I don't believe this stuff is going into this
> release at this point.
>
> So it's more a question of whether it's better to revert and apply a clean
> patch on top, or just keep the code around but disabled with an ifdef as is.
> I'm open to both options, and would like your opinion on this.


Then I prefer to leave current code (VHOST_ARCH_CAN_ACCEL to 0) as is. 
This can also save efforts on rebasing packed virtqueues.

Thanks


>
>>>
>>>> Now as long as all this code is disabled anyway, we can experiment a
>>>> bit.
>>>>
>>>> I personally feel we would be best served by having two code paths:
>>>>
>>>> - Access to VM memory directly mapped into kernel
>>>> - Access to userspace
>>>>
>>>>
>>>> Having it all cleanly split will allow a bunch of optimizations, for
>>>> example for years now we planned to be able to process an incoming short
>>>> packet directly on softirq path, or an outgoing on directly within
>>>> eventfd.
>>>
>>> It's not hard consider we've already had our own accssors. But the
>>> question is (as asked in another thread), do you want permanent GUP or
>>> still use MMU notifiers.
>>>
>>> Thanks
>>>
>>> _______________________________________________
>>> Virtualization mailing list
>>> Virtualization@lists.linux-foundation.org
>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
