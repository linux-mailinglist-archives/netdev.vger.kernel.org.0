Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE828627B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732828AbfHHNBL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 09:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732375AbfHHNBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 09:01:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 73550315C00C;
        Thu,  8 Aug 2019 13:01:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E6E9600C8;
        Thu,  8 Aug 2019 13:01:10 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4800124F2F;
        Thu,  8 Aug 2019 13:01:10 +0000 (UTC)
Date:   Thu, 8 Aug 2019 09:01:09 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org
Message-ID: <1514137898.7430705.1565269269504.JavaMail.zimbra@redhat.com>
In-Reply-To: <1000f8a3-19a9-0383-61e5-ba08ddc9fcba@redhat.com>
References: <20190807070617.23716-1-jasowang@redhat.com> <20190807070617.23716-8-jasowang@redhat.com> <20190807120738.GB1557@ziepe.ca> <ba5f375f-435a-91fd-7fca-bfab0915594b@redhat.com> <1000f8a3-19a9-0383-61e5-ba08ddc9fcba@redhat.com>
Subject: Re: [PATCH V4 7/9] vhost: do not use RCU to synchronize MMU
 notifier       with worker
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.68.5.20, 10.4.195.1]
Thread-Topic: vhost: do not use RCU to synchronize MMU notifier with worker
Thread-Index: 8bG8pspTquXH/UvMW3K+XUgVgEyz4A==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 08 Aug 2019 13:01:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> 
> On 2019/8/7 下午10:02, Jason Wang wrote:
> >
> > On 2019/8/7 下午8:07, Jason Gunthorpe wrote:
> >> On Wed, Aug 07, 2019 at 03:06:15AM -0400, Jason Wang wrote:
> >>> We used to use RCU to synchronize MMU notifier with worker. This leads
> >>> calling synchronize_rcu() in invalidate_range_start(). But on a busy
> >>> system, there would be many factors that may slow down the
> >>> synchronize_rcu() which makes it unsuitable to be called in MMU
> >>> notifier.
> >>>
> >>> So this patch switches use seqlock counter to track whether or not the
> >>> map was used. The counter was increased when vq try to start or finish
> >>> uses the map. This means, when it was even, we're sure there's no
> >>> readers and MMU notifier is synchronized. When it was odd, it means
> >>> there's a reader we need to wait it to be even again then we are
> >>> synchronized. Consider the read critical section is pretty small the
> >>> synchronization should be done very fast.
> >>>
> >>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> >>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel
> >>> virtual address")
> >>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>>   drivers/vhost/vhost.c | 141
> >>> ++++++++++++++++++++++++++----------------
> >>>   drivers/vhost/vhost.h |   7 ++-
> >>>   2 files changed, 90 insertions(+), 58 deletions(-)
> >>>
> >>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> >>> index cfc11f9ed9c9..57bfbb60d960 100644
> >>> +++ b/drivers/vhost/vhost.c
> >>> @@ -324,17 +324,16 @@ static void vhost_uninit_vq_maps(struct
> >>> vhost_virtqueue *vq)
> >>>         spin_lock(&vq->mmu_lock);
> >>>       for (i = 0; i < VHOST_NUM_ADDRS; i++) {
> >>> -        map[i] = rcu_dereference_protected(vq->maps[i],
> >>> -                  lockdep_is_held(&vq->mmu_lock));
> >>> +        map[i] = vq->maps[i];
> >>>           if (map[i]) {
> >>>               vhost_set_map_dirty(vq, map[i], i);
> >>> -            rcu_assign_pointer(vq->maps[i], NULL);
> >>> +            vq->maps[i] = NULL;
> >>>           }
> >>>       }
> >>>       spin_unlock(&vq->mmu_lock);
> >>>   -    /* No need for synchronize_rcu() or kfree_rcu() since we are
> >>> -     * serialized with memory accessors (e.g vq mutex held).
> >>> +    /* No need for synchronization since we are serialized with
> >>> +     * memory accessors (e.g vq mutex held).
> >>>        */
> >>>         for (i = 0; i < VHOST_NUM_ADDRS; i++)
> >>> @@ -362,6 +361,40 @@ static bool vhost_map_range_overlap(struct
> >>> vhost_uaddr *uaddr,
> >>>       return !(end < uaddr->uaddr || start > uaddr->uaddr - 1 +
> >>> uaddr->size);
> >>>   }
> >>>   +static void inline vhost_vq_access_map_begin(struct
> >>> vhost_virtqueue *vq)
> >>> +{
> >>> +    write_seqcount_begin(&vq->seq);
> >>> +}
> >>> +
> >>> +static void inline vhost_vq_access_map_end(struct vhost_virtqueue *vq)
> >>> +{
> >>> +    write_seqcount_end(&vq->seq);
> >>> +}
> >> The write side of a seqlock only provides write barriers. Access to
> >>
> >>     map = vq->maps[VHOST_ADDR_USED];
> >>
> >> Still needs a read side barrier, and then I think this will be no
> >> better than a normal spinlock.
> >>
> >> It also doesn't seem like this algorithm even needs a seqlock, as this
> >> is just a one bit flag
> >
> >
> > Right, so then I tend to use spinlock first for correctness.
> >
> >
> >>
> >> atomic_set_bit(using map)
> >> smp_mb__after_atomic()
> >> .. maps [...]
> >> atomic_clear_bit(using map)
> >>
> >>
> >> map = NULL;
> >> smp_mb__before_atomic();
> >> while (atomic_read_bit(using map))
> >>     relax()
> >>
> >> Again, not clear this could be faster than a spinlock when the
> >> barriers are correct...
> >
> 
> I've done some benchmark[1] on x86, and yes it looks even slower. It
> looks to me the atomic stuffs is not necessary, so in order to compare
> it better with spinlock. I tweak it a little bit through
> smp_load_acquire()/store_releaes() + mb() like:
> 

Sorry the format is messed up:

The code should be something like:

static struct vhost_map *vhost_vq_access_map_begin(struct vhost_virtqueue *vq,
                                                   unsigned int type)
{
        ++vq->counter;
        /* Ensure map was read after incresing the counter. Paired
         * with smp_mb() in vhost_vq_sync_access().
         */
        smp_mb();
        return vq->maps[type];
}

static void inline vhost_vq_access_map_end(struct vhost_virtqueue *vq)
{
 	/* Ensure all memory access through map was done before
         * reducing the counter. Paired with smp_load_acquire() in
         * vhost_vq_sync_access() */
        smp_store_release(&vq->counter, --vq->counter);
}

static void inline vhost_vq_sync_access(struct vhost_virtqueue *vq)
{
        /* Ensure new map value is visible before checking counter. */
        smp_mb();
        /* Ensure map was freed after reading counter value, paired
         * with smp_store_release() in vhost_vq_access_map_end().
         */
        while (smp_load_acquire(&vq->counter)) {
                if (need_resched())
                        schedule();
        }
}

And the benchmark result is:

         | base    | direct + atomic bitops | direct + spinlock() | direct + counter + smp_mb() | direct + RCU     |
SMAP on  | 5.0Mpps | 5.0Mpps     (+0%)      | 5.7Mpps  	(+14%)	  | 5.9Mpps  (+18%)	        | 6.2Mpps  (+24%)  |
SMAP off | 7.0Mpps | 7.0Mpps     (+0%)      | 7.0Mpps   (+0%)     | 7.5Mpps  (+7%)	        | 8.2Mpps  (+17%)  |


> 
> 
> base: normal copy_to_user()/copy_from_user() path.
> direct + atomic bitops: using direct mapping but synchronize through
> atomic bitops like you suggested above
> direct + spinlock(): using direct mapping but synchronize through spinlocks
> direct + counter + smp_mb(): using direct mapping but synchronize
> through counter + smp_mb()
> direct + RCU: using direct mapping and synchronize through RCU (buggy
> and need to be addressed by this series)
> 
> 
> So smp_mb() + counter is fastest way. And spinlock can still show some
> improvement (+14%) in the case of SMAP, but no the case when SMAP is off.
> 
> I don't have any objection to convert  to spinlock() but just want to
> know if any case that the above smp_mb() + counter looks good to you?
> 
> Thanks
> 
> 
> >
> > Yes, for next release we may want to use the idea from Michael like to
> > mitigate the impact of mb.
> >
> > https://lwn.net/Articles/775871/
> >
> > Thanks
> >
> >
> >>
> >> Jason
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
