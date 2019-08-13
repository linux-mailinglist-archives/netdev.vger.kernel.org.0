Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E44888B279
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfHMIbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbfHMIbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 04:31:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 640B2309266A;
        Tue, 13 Aug 2019 08:31:16 +0000 (UTC)
Received: from [10.72.12.191] (ovpn-12-191.pek2.redhat.com [10.72.12.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1FEF1001B28;
        Tue, 13 Aug 2019 08:31:08 +0000 (UTC)
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <20190812130252.GE24457@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
Date:   Tue, 13 Aug 2019 16:31:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812130252.GE24457@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 13 Aug 2019 08:31:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/12 下午9:02, Jason Gunthorpe wrote:
> On Mon, Aug 12, 2019 at 05:49:08AM -0400, Michael S. Tsirkin wrote:
>> On Mon, Aug 12, 2019 at 10:44:51AM +0800, Jason Wang wrote:
>>> On 2019/8/11 上午1:52, Michael S. Tsirkin wrote:
>>>> On Fri, Aug 09, 2019 at 01:48:42AM -0400, Jason Wang wrote:
>>>>> Hi all:
>>>>>
>>>>> This series try to fix several issues introduced by meta data
>>>>> accelreation series. Please review.
>>>>>
>>>>> Changes from V4:
>>>>> - switch to use spinlock synchronize MMU notifier with accessors
>>>>>
>>>>> Changes from V3:
>>>>> - remove the unnecessary patch
>>>>>
>>>>> Changes from V2:
>>>>> - use seqlck helper to synchronize MMU notifier with vhost worker
>>>>>
>>>>> Changes from V1:
>>>>> - try not use RCU to syncrhonize MMU notifier with vhost worker
>>>>> - set dirty pages after no readers
>>>>> - return -EAGAIN only when we find the range is overlapped with
>>>>>     metadata
>>>>>
>>>>> Jason Wang (9):
>>>>>     vhost: don't set uaddr for invalid address
>>>>>     vhost: validate MMU notifier registration
>>>>>     vhost: fix vhost map leak
>>>>>     vhost: reset invalidate_count in vhost_set_vring_num_addr()
>>>>>     vhost: mark dirty pages during map uninit
>>>>>     vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
>>>>>     vhost: do not use RCU to synchronize MMU notifier with worker
>>>>>     vhost: correctly set dirty pages in MMU notifiers callback
>>>>>     vhost: do not return -EAGAIN for non blocking invalidation too early
>>>>>
>>>>>    drivers/vhost/vhost.c | 202 +++++++++++++++++++++++++-----------------
>>>>>    drivers/vhost/vhost.h |   6 +-
>>>>>    2 files changed, 122 insertions(+), 86 deletions(-)
>>>> This generally looks more solid.
>>>>
>>>> But this amounts to a significant overhaul of the code.
>>>>
>>>> At this point how about we revert 7f466032dc9e5a61217f22ea34b2df932786bbfc
>>>> for this release, and then re-apply a corrected version
>>>> for the next one?
>>>
>>> If possible, consider we've actually disabled the feature. How about just
>>> queued those patches for next release?
>>>
>>> Thanks
>> Sorry if I was unclear. My idea is that
>> 1. I revert the disabled code
>> 2. You send a patch readding it with all the fixes squashed
>> 3. Maybe optimizations on top right away?
>> 4. We queue *that* for next and see what happens.
>>
>> And the advantage over the patchy approach is that the current patches
>> are hard to review. E.g.  it's not reasonable to ask RCU guys to review
>> the whole of vhost for RCU usage but it's much more reasonable to ask
>> about a specific patch.
> I think there are other problems here too, I don't like that the use
> of mmu notifiers is so different from every other driver, or that GUP
> is called under spinlock.


What kind of issues do you see? Spinlock is to synchronize GUP with MMU 
notifier in this series.

Btw, back to the original question. May I know why synchronize_rcu() is 
not suitable? Consider:

- MMU notifier are allowed to sleep
- MMU notifier could be preempted

If you mean something that prevents RCU grace period from running. I'm 
afraid MMU notifier is not the only victim.  But it should be no more 
worse than some one is holding a lock for very long time. If the only 
concern is the preemption of vhost kthread, I can switch to use 
rcu_read_lock_bh() instead.

Thanks


>
> So I favor the revert and try again approach as well. It is hard to
> get a clear picture with these endless bug fix patches
>
> Jason


Ok.

Thanks

