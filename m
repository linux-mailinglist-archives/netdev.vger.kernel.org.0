Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79EE7C372
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfGaN22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfGaN21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 09:28:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB32081F18;
        Wed, 31 Jul 2019 13:28:26 +0000 (UTC)
Received: from [10.72.12.118] (ovpn-12-118.pek2.redhat.com [10.72.12.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C57C560BEC;
        Wed, 31 Jul 2019 13:28:21 +0000 (UTC)
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com> <20190731123935.GC3946@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
Date:   Wed, 31 Jul 2019 21:28:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190731123935.GC3946@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 31 Jul 2019 13:28:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/31 下午8:39, Jason Gunthorpe wrote:
> On Wed, Jul 31, 2019 at 04:46:53AM -0400, Jason Wang wrote:
>> We used to use RCU to synchronize MMU notifier with worker. This leads
>> calling synchronize_rcu() in invalidate_range_start(). But on a busy
>> system, there would be many factors that may slow down the
>> synchronize_rcu() which makes it unsuitable to be called in MMU
>> notifier.
>>
>> A solution is SRCU but its overhead is obvious with the expensive full
>> memory barrier. Another choice is to use seqlock, but it doesn't
>> provide a synchronization method between readers and writers. The last
>> choice is to use vq mutex, but it need to deal with the worst case
>> that MMU notifier must be blocked and wait for the finish of swap in.
>>
>> So this patch switches use a counter to track whether or not the map
>> was used. The counter was increased when vq try to start or finish
>> uses the map. This means, when it was even, we're sure there's no
>> readers and MMU notifier is synchronized. When it was odd, it means
>> there's a reader we need to wait it to be even again then we are
>> synchronized.
> You just described a seqlock.


Kind of, see my explanation below.


>
> We've been talking about providing this as some core service from mmu
> notifiers because nearly every use of this API needs it.


That would be very helpful.


>
> IMHO this gets the whole thing backwards, the common pattern is to
> protect the 'shadow pte' data with a seqlock (usually open coded),
> such that the mmu notififer side has the write side of that lock and
> the read side is consumed by the thread accessing or updating the SPTE.


Yes, I've considered something like that. But the problem is, mmu 
notifier (writer) need to wait for the vhost worker to finish the read 
before it can do things like setting dirty pages and unmapping page.  It 
looks to me seqlock doesn't provide things like this.  Or are you 
suggesting that taking writer seq lock in vhost worker and busy wait for 
seqcount to be even in MMU notifier (something similar to what this 
patch did)? I don't do this because e.g:


write_seqcount_begin()

map = vq->map[X]

write or read through map->addr directly

write_seqcount_end()


There's no rmb() in write_seqcount_begin(), so map could be read before 
write_seqcount_begin(), but it looks to me now that this doesn't harm at 
all, maybe we can try this way.


>
>
>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>   drivers/vhost/vhost.c | 145 ++++++++++++++++++++++++++----------------
>>   drivers/vhost/vhost.h |   7 +-
>>   2 files changed, 94 insertions(+), 58 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index cfc11f9ed9c9..db2c81cb1e90 100644
>> +++ b/drivers/vhost/vhost.c
>> @@ -324,17 +324,16 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>>   
>>   	spin_lock(&vq->mmu_lock);
>>   	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
>> -		map[i] = rcu_dereference_protected(vq->maps[i],
>> -				  lockdep_is_held(&vq->mmu_lock));
>> +		map[i] = vq->maps[i];
>>   		if (map[i]) {
>>   			vhost_set_map_dirty(vq, map[i], i);
>> -			rcu_assign_pointer(vq->maps[i], NULL);
>> +			vq->maps[i] = NULL;
>>   		}
>>   	}
>>   	spin_unlock(&vq->mmu_lock);
>>   
>> -	/* No need for synchronize_rcu() or kfree_rcu() since we are
>> -	 * serialized with memory accessors (e.g vq mutex held).
>> +	/* No need for synchronization since we are serialized with
>> +	 * memory accessors (e.g vq mutex held).
>>   	 */
>>   
>>   	for (i = 0; i < VHOST_NUM_ADDRS; i++)
>> @@ -362,6 +361,44 @@ static bool vhost_map_range_overlap(struct vhost_uaddr *uaddr,
>>   	return !(end < uaddr->uaddr || start > uaddr->uaddr - 1 + uaddr->size);
>>   }
>>   
>> +static void inline vhost_vq_access_map_begin(struct vhost_virtqueue *vq)
>> +{
>> +	int ref = READ_ONCE(vq->ref);
> Is a lock/single threaded supposed to be held for this?


Yes, only vhost worker kthread can accept this.


>
>> +
>> +	smp_store_release(&vq->ref, ref + 1);
>> +	/* Make sure ref counter is visible before accessing the map */
>> +	smp_load_acquire(&vq->ref);
> release/acquire semantics are intended to protect blocks of related
> data, so reading something with acquire and throwing away the result
> is nonsense.


Actually I want to use smp_mb() here, so I admit it's a trick that even 
won't work. But now I think I can just use write_seqcount_begin() here.


>
>> +}
>> +
>> +static void inline vhost_vq_access_map_end(struct vhost_virtqueue *vq)
>> +{
>> +	int ref = READ_ONCE(vq->ref);
> If the write to vq->ref is not locked this algorithm won't work, if it
> is locked the READ_ONCE is not needed.


Yes.


>
>> +	/* Make sure vq access is done before increasing ref counter */
>> +	smp_store_release(&vq->ref, ref + 1);
>> +}
>> +
>> +static void inline vhost_vq_sync_access(struct vhost_virtqueue *vq)
>> +{
>> +	int ref;
>> +
>> +	/* Make sure map change was done before checking ref counter */
>> +	smp_mb();
> This is probably smp_rmb after reading ref, and if you are setting ref
> with smp_store_release then this should be smp_load_acquire() without
> an explicit mb.


We had something like:

spin_lock();

vq->maps[index] = NULL;

spin_unlock();

vhost_vq_sync_access(vq);

we need to make sure the read of ref is done after setting 
vq->maps[index] to NULL. It looks to me neither smp_load_acquire() nor 
smp_store_release() can help in this case.


>
>> +	ref = READ_ONCE(vq->ref);
>> +	if (ref & 0x1) {
>> +		/* When ref change, we are sure no reader can see
>> +		 * previous map */
>> +		while (READ_ONCE(vq->ref) == ref) {
>> +			set_current_state(TASK_RUNNING);
>> +			schedule();
>> +		}
>> +	}
> This is basically read_seqcount_begin()' with a schedule instead of
> cpu_relax


Yes it is.


>
>
>> +	/* Make sure ref counter was checked before any other
>> +	 * operations that was dene on map. */
>> +	smp_mb();
> should be in a smp_load_acquire()


Right, if we use smp_load_acquire() to load the counter.


>
>> +}
>> +
>>   static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>>   				      int index,
>>   				      unsigned long start,
>> @@ -376,16 +413,15 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>>   	spin_lock(&vq->mmu_lock);
>>   	++vq->invalidate_count;
>>   
>> -	map = rcu_dereference_protected(vq->maps[index],
>> -					lockdep_is_held(&vq->mmu_lock));
>> +	map = vq->maps[index];
>>   	if (map) {
>>   		vhost_set_map_dirty(vq, map, index);
>> -		rcu_assign_pointer(vq->maps[index], NULL);
>> +		vq->maps[index] = NULL;
>>   	}
>>   	spin_unlock(&vq->mmu_lock);
>>   
>>   	if (map) {
>> -		synchronize_rcu();
>> +		vhost_vq_sync_access(vq);
> What prevents racing with vhost_vq_access_map_end here?


vhost_vq_access_map_end() uses smp_store_release() for the counter. Is 
this not sufficient?


>
>>   		vhost_map_unprefetch(map);
>>   	}
>>   }
> Overall I don't like it.
>
> We are trying to get rid of these botique mmu notifier patterns in
> drivers.


I agree, so do you think we can take write lock in vhost worker then 
wait for the counter to be even in MMU notifier? It looks much cleaner 
than this patch.

Thanks


>
> Jason
