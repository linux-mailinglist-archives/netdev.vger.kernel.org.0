Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51A781418
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfHEIWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 04:22:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbfHEIWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 04:22:22 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A704879705;
        Mon,  5 Aug 2019 08:22:21 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1DB55D9C0;
        Mon,  5 Aug 2019 08:22:16 +0000 (UTC)
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <e8ecb811-6653-cff4-bc11-81f4ccb0dbbf@redhat.com>
 <20190805022833-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9d81ac79-1cc4-fba0-5aad-7acd8578d957@redhat.com>
Date:   Mon, 5 Aug 2019 16:22:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805022833-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 05 Aug 2019 08:22:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/5 下午2:30, Michael S. Tsirkin wrote:
> On Mon, Aug 05, 2019 at 12:36:40PM +0800, Jason Wang wrote:
>> On 2019/8/2 下午10:27, Michael S. Tsirkin wrote:
>>> On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
>>>> On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
>>>>>> This must be a proper barrier, like a spinlock, mutex, or
>>>>>> synchronize_rcu.
>>>>> I start with synchronize_rcu() but both you and Michael raise some
>>>>> concern.
>>>> I've also idly wondered if calling synchronize_rcu() under the various
>>>> mm locks is a deadlock situation.
>>>>
>>>>> Then I try spinlock and mutex:
>>>>>
>>>>> 1) spinlock: add lots of overhead on datapath, this leads 0 performance
>>>>> improvement.
>>>> I think the topic here is correctness not performance improvement
>>> The topic is whether we should revert
>>> commit 7f466032dc9 ("vhost: access vq metadata through kernel virtual address")
>>>
>>> or keep it in. The only reason to keep it is performance.
>>
>> Maybe it's time to introduce the config option?
> Depending on CONFIG_BROKEN? I'm not sure it's a good idea.


Ok.


>>> Now as long as all this code is disabled anyway, we can experiment a
>>> bit.
>>>
>>> I personally feel we would be best served by having two code paths:
>>>
>>> - Access to VM memory directly mapped into kernel
>>> - Access to userspace
>>>
>>>
>>> Having it all cleanly split will allow a bunch of optimizations, for
>>> example for years now we planned to be able to process an incoming short
>>> packet directly on softirq path, or an outgoing on directly within
>>> eventfd.
>>
>> It's not hard consider we've already had our own accssors. But the question
>> is (as asked in another thread), do you want permanent GUP or still use MMU
>> notifiers.
>>
>> Thanks
> We want THP and NUMA to work. Both are important for performance.
>

Yes.

Thanks

