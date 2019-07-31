Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 283F87CC01
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbfGaS36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:29:58 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:46873 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfGaS36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:29:58 -0400
Received: by mail-vs1-f67.google.com with SMTP id r3so46865534vsr.13
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 11:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mkkk66qZeM7rZbp5Mkon6w+g0XNyuUrht7AlCfpNI3c=;
        b=LvulOl8s5Ymv2KBKsOp1UvKdHx0ynr7ND3/z8wmhOW+f2n3z3Pjzb4qHeuAdLSJZXq
         AY2WDNk2hqyE5sQxWT+/0lzd8YXnuhHKq831vATWfsGcR/nBrP9fI/v5INdnc0yW4GVY
         hcaLpKV5SbK4BhMNtIxdaZ5RH3jkT0Q77akjUmqBgM7jmEs95QliISffAo+WGLvw6rmD
         c7xt3FYe28rO1yJrkA3CrNmBG87zv8Et1p02uOpzbn/q9PysQ2MMzV9p1QcWyjccz+O5
         wEKS5rXYXoegKAkk8ggn1OO/uTt7+Gm8n8qSeqcjnhys1MI4Tv8QAPLAlOdPKQhrafQL
         jdMQ==
X-Gm-Message-State: APjAAAUYxT0ocYmDhJghQX2RolF8dc6jSwf84RLbirx0OzdI4Xv8zdm1
        rsmHzJNSUTxa41jyoPp5Zmksdg==
X-Google-Smtp-Source: APXvYqxwu4JXMVRdRBatu6SdqPckIbcsvlaKORV23YoYuIEhZIrdialQkGmhyfGj2U4NpBEniTRmaA==
X-Received: by 2002:a67:c419:: with SMTP id c25mr78324215vsk.136.1564597796832;
        Wed, 31 Jul 2019 11:29:56 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id h12sm9627521uao.15.2019.07.31.11.29.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 11:29:55 -0700 (PDT)
Date:   Wed, 31 Jul 2019 14:29:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jgg@ziepe.ca,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190731132438-mutt-send-email-mst@kernel.org>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731084655.7024-8-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 04:46:53AM -0400, Jason Wang wrote:
> We used to use RCU to synchronize MMU notifier with worker. This leads
> calling synchronize_rcu() in invalidate_range_start(). But on a busy
> system, there would be many factors that may slow down the
> synchronize_rcu() which makes it unsuitable to be called in MMU
> notifier.
> 
> A solution is SRCU but its overhead is obvious with the expensive full
> memory barrier. Another choice is to use seqlock, but it doesn't
> provide a synchronization method between readers and writers. The last
> choice is to use vq mutex, but it need to deal with the worst case
> that MMU notifier must be blocked and wait for the finish of swap in.
> 
> So this patch switches use a counter to track whether or not the map
> was used. The counter was increased when vq try to start or finish
> uses the map. This means, when it was even, we're sure there's no
> readers and MMU notifier is synchronized. When it was odd, it means
> there's a reader we need to wait it to be even again then we are
> synchronized. To avoid full memory barrier, store_release +
> load_acquire on the counter is used.

Unfortunately this needs a lot of review and testing, so this can't make
rc2, and I don't think this is the kind of patch I can merge after rc3.
Subtle memory barrier tricks like this can introduce new bugs while they
are fixing old ones.





> 
> Consider the read critical section is pretty small the synchronization
> should be done very fast.
> 
> Note the patch lead about 3% PPS dropping.

Sorry what do you mean by this last sentence? This degrades performance
compared to what?

> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vhost.c | 145 ++++++++++++++++++++++++++----------------
>  drivers/vhost/vhost.h |   7 +-
>  2 files changed, 94 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index cfc11f9ed9c9..db2c81cb1e90 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -324,17 +324,16 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>  
>  	spin_lock(&vq->mmu_lock);
>  	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
> -		map[i] = rcu_dereference_protected(vq->maps[i],
> -				  lockdep_is_held(&vq->mmu_lock));
> +		map[i] = vq->maps[i];
>  		if (map[i]) {
>  			vhost_set_map_dirty(vq, map[i], i);
> -			rcu_assign_pointer(vq->maps[i], NULL);
> +			vq->maps[i] = NULL;
>  		}
>  	}
>  	spin_unlock(&vq->mmu_lock);
>  
> -	/* No need for synchronize_rcu() or kfree_rcu() since we are
> -	 * serialized with memory accessors (e.g vq mutex held).
> +	/* No need for synchronization since we are serialized with
> +	 * memory accessors (e.g vq mutex held).
>  	 */
>  
>  	for (i = 0; i < VHOST_NUM_ADDRS; i++)
> @@ -362,6 +361,44 @@ static bool vhost_map_range_overlap(struct vhost_uaddr *uaddr,
>  	return !(end < uaddr->uaddr || start > uaddr->uaddr - 1 + uaddr->size);
>  }
>  
> +static void inline vhost_vq_access_map_begin(struct vhost_virtqueue *vq)
> +{
> +	int ref = READ_ONCE(vq->ref);
> +
> +	smp_store_release(&vq->ref, ref + 1);
> +	/* Make sure ref counter is visible before accessing the map */
> +	smp_load_acquire(&vq->ref);

The map access is after this sequence, correct?

Just going by the rules in Documentation/memory-barriers.txt,
I think that this pair will not order following accesses with ref store.

Documentation/memory-barriers.txt says:


+     In addition, a RELEASE+ACQUIRE
+     pair is -not- guaranteed to act as a full memory barrier.



The guarantee that is made is this:
	after
     an ACQUIRE on a given variable, all memory accesses preceding any prior
     RELEASE on that same variable are guaranteed to be visible. 


And if we also had the reverse rule we'd end up with a full barrier,
won't we?

Cc Paul in case I missed something here. And if I'm right,
maybe we should call this out, adding

	"The opposite is not true: a prior RELEASE is not
	 guaranteed to be visible before memory accesses following
	 the subsequent ACQUIRE".



> +}
> +
> +static void inline vhost_vq_access_map_end(struct vhost_virtqueue *vq)
> +{
> +	int ref = READ_ONCE(vq->ref);
> +
> +	/* Make sure vq access is done before increasing ref counter */
> +	smp_store_release(&vq->ref, ref + 1);
> +}
> +
> +static void inline vhost_vq_sync_access(struct vhost_virtqueue *vq)
> +{
> +	int ref;
> +
> +	/* Make sure map change was done before checking ref counter */
> +	smp_mb();
> +
> +	ref = READ_ONCE(vq->ref);
> +	if (ref & 0x1) {

Please document the even/odd trick here too, not just in the commit log.

> +		/* When ref change,

changes

> we are sure no reader can see
> +		 * previous map */
> +		while (READ_ONCE(vq->ref) == ref) {


what is the below line in aid of?

> +			set_current_state(TASK_RUNNING);
> +			schedule();

                        if (need_resched())
                                schedule();

?

> +		}

On an interruptible kernel, there's a risk here is that
a task got preempted with an odd ref.
So I suspect we'll have to disable preemption when we
make ref odd.


> +	}
> +	/* Make sure ref counter was checked before any other
> +	 * operations that was dene on map. */

was dene -> were done?

> +	smp_mb();
> +}
> +
>  static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>  				      int index,
>  				      unsigned long start,
> @@ -376,16 +413,15 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>  	spin_lock(&vq->mmu_lock);
>  	++vq->invalidate_count;
>  
> -	map = rcu_dereference_protected(vq->maps[index],
> -					lockdep_is_held(&vq->mmu_lock));
> +	map = vq->maps[index];
>  	if (map) {
>  		vhost_set_map_dirty(vq, map, index);
> -		rcu_assign_pointer(vq->maps[index], NULL);
> +		vq->maps[index] = NULL;
>  	}
>  	spin_unlock(&vq->mmu_lock);
>  
>  	if (map) {
> -		synchronize_rcu();
> +		vhost_vq_sync_access(vq);
>  		vhost_map_unprefetch(map);
>  	}
>  }
> @@ -457,7 +493,7 @@ static void vhost_init_maps(struct vhost_dev *dev)
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
>  		for (j = 0; j < VHOST_NUM_ADDRS; j++)
> -			RCU_INIT_POINTER(vq->maps[j], NULL);
> +			vq->maps[j] = NULL;
>  	}
>  }
>  #endif
> @@ -655,6 +691,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>  		vq->indirect = NULL;
>  		vq->heads = NULL;
>  		vq->dev = dev;
> +		vq->ref = 0;
>  		mutex_init(&vq->mutex);
>  		spin_lock_init(&vq->mmu_lock);
>  		vhost_vq_reset(dev, vq);
> @@ -921,7 +958,7 @@ static int vhost_map_prefetch(struct vhost_virtqueue *vq,
>  	map->npages = npages;
>  	map->pages = pages;
>  
> -	rcu_assign_pointer(vq->maps[index], map);
> +	vq->maps[index] = map;
>  	/* No need for a synchronize_rcu(). This function should be
>  	 * called by dev->worker so we are serialized with all
>  	 * readers.
> @@ -1216,18 +1253,18 @@ static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
>  	struct vring_used *used;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
> +		map = vq->maps[VHOST_ADDR_USED];
>  		if (likely(map)) {
>  			used = map->addr;
>  			*((__virtio16 *)&used->ring[vq->num]) =
>  				cpu_to_vhost16(vq, vq->avail_idx);
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1245,18 +1282,18 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
>  	size_t size;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
> +		map = vq->maps[VHOST_ADDR_USED];
>  		if (likely(map)) {
>  			used = map->addr;
>  			size = count * sizeof(*head);
>  			memcpy(used->ring + idx, head, size);
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1272,17 +1309,17 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
>  	struct vring_used *used;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
> +		map = vq->maps[VHOST_ADDR_USED];
>  		if (likely(map)) {
>  			used = map->addr;
>  			used->flags = cpu_to_vhost16(vq, vq->used_flags);
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1298,17 +1335,17 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
>  	struct vring_used *used;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
> +		map = vq->maps[VHOST_ADDR_USED];
>  		if (likely(map)) {
>  			used = map->addr;
>  			used->idx = cpu_to_vhost16(vq, vq->last_used_idx);
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1362,17 +1399,17 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
>  	struct vring_avail *avail;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
> +		map = vq->maps[VHOST_ADDR_AVAIL];
>  		if (likely(map)) {
>  			avail = map->addr;
>  			*idx = avail->idx;
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1387,17 +1424,17 @@ static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
>  	struct vring_avail *avail;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
> +		map = vq->maps[VHOST_ADDR_AVAIL];
>  		if (likely(map)) {
>  			avail = map->addr;
>  			*head = avail->ring[idx & (vq->num - 1)];
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1413,17 +1450,17 @@ static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
>  	struct vring_avail *avail;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
> +		map = vq->maps[VHOST_ADDR_AVAIL];
>  		if (likely(map)) {
>  			avail = map->addr;
>  			*flags = avail->flags;
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1438,15 +1475,15 @@ static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
>  	struct vring_avail *avail;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
> +		vhost_vq_access_map_begin(vq);
> +		map = vq->maps[VHOST_ADDR_AVAIL];
>  		if (likely(map)) {
>  			avail = map->addr;
>  			*event = (__virtio16)avail->ring[vq->num];
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1461,17 +1498,17 @@ static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
>  	struct vring_used *used;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
> +		map = vq->maps[VHOST_ADDR_USED];
>  		if (likely(map)) {
>  			used = map->addr;
>  			*idx = used->idx;
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1486,17 +1523,17 @@ static inline int vhost_get_desc(struct vhost_virtqueue *vq,
>  	struct vring_desc *d;
>  
>  	if (!vq->iotlb) {
> -		rcu_read_lock();
> +		vhost_vq_access_map_begin(vq);
>  
> -		map = rcu_dereference(vq->maps[VHOST_ADDR_DESC]);
> +		map = vq->maps[VHOST_ADDR_DESC];
>  		if (likely(map)) {
>  			d = map->addr;
>  			*desc = *(d + idx);
> -			rcu_read_unlock();
> +			vhost_vq_access_map_end(vq);
>  			return 0;
>  		}
>  
> -		rcu_read_unlock();
> +		vhost_vq_access_map_end(vq);
>  	}
>  #endif
>  
> @@ -1843,13 +1880,11 @@ static bool iotlb_access_ok(struct vhost_virtqueue *vq,
>  #if VHOST_ARCH_CAN_ACCEL_UACCESS
>  static void vhost_vq_map_prefetch(struct vhost_virtqueue *vq)
>  {
> -	struct vhost_map __rcu *map;
> +	struct vhost_map *map;
>  	int i;
>  
>  	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
> -		rcu_read_lock();
> -		map = rcu_dereference(vq->maps[i]);
> -		rcu_read_unlock();
> +		map = vq->maps[i];
>  		if (unlikely(!map))
>  			vhost_map_prefetch(vq, i);
>  	}
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index a9a2a93857d2..f9e9558a529d 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -115,16 +115,17 @@ struct vhost_virtqueue {
>  #if VHOST_ARCH_CAN_ACCEL_UACCESS
>  	/* Read by memory accessors, modified by meta data
>  	 * prefetching, MMU notifier and vring ioctl().
> -	 * Synchonrized through mmu_lock (writers) and RCU (writers
> -	 * and readers).
> +	 * Synchonrized through mmu_lock (writers) and ref counters,
> +	 * see vhost_vq_access_map_begin()/vhost_vq_access_map_end().
>  	 */
> -	struct vhost_map __rcu *maps[VHOST_NUM_ADDRS];
> +	struct vhost_map *maps[VHOST_NUM_ADDRS];
>  	/* Read by MMU notifier, modified by vring ioctl(),
>  	 * synchronized through MMU notifier
>  	 * registering/unregistering.
>  	 */
>  	struct vhost_uaddr uaddrs[VHOST_NUM_ADDRS];
>  #endif
> +	int ref;

Is it important that this is signed? If not I'd do unsigned here:
even though kernel does compile with 2s complement sign overflow,
it seems cleaner not to depend on that.

>  	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
>  
>  	struct file *kick;
> -- 
> 2.18.1
