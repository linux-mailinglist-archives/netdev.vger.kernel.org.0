Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADEBAD37D
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbfIIHQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46753 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387412AbfIIHQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 03:16:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 467BD2F366A;
        Mon,  9 Sep 2019 07:16:29 +0000 (UTC)
Received: from [10.72.12.61] (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0208D5D9D6;
        Mon,  9 Sep 2019 07:16:04 +0000 (UTC)
Subject: Re: [PATCH 1/2] Revert "vhost: access vq metadata through kernel
 virtual address"
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jgg@mellanox.com, aarcange@redhat.com, jglisse@redhat.com,
        linux-mm@kvack.org
References: <20190905122736.19768-1-jasowang@redhat.com>
 <20190905122736.19768-2-jasowang@redhat.com>
 <20190906094332-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6d0b968f-87c3-99a0-fcc6-a696d383b47c@redhat.com>
Date:   Mon, 9 Sep 2019 15:16:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906094332-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 09 Sep 2019 07:16:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/6 下午9:46, Michael S. Tsirkin wrote:
> On Thu, Sep 05, 2019 at 08:27:35PM +0800, Jason Wang wrote:
>> It was reported that metadata acceleration introduces several issues,
>> so this patch reverts commit ff466032dc9e5a61217f22ea34b2df932786bbfc,
>> 73f628ec9e6bcc45b77c53fe6d0c0ec55eaf82af and
>> 0b4a7092ffe568a55bf8f3cefdf79ff666586d91.
>>
>> We will rework it on the next version.
>>
>> Cc: Jason Gunthorpe <jgg@mellanox.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> I am confused by the above.
> What I see upstream is 7f466032dc.
>
> commit 7f466032dc9e5a61217f22ea34b2df932786bbfc
> Author: Jason Wang <jasowang@redhat.com>
> Date:   Fri May 24 04:12:18 2019 -0400
>
>      vhost: access vq metadata through kernel virtual address
>
> so this is what I reverted.
>
> Pls take a look, and let me know if you see issues.
>
> Thanks!


Yes, my fault.

Thanks


>> ---
>>   drivers/vhost/vhost.c | 515 +-----------------------------------------
>>   drivers/vhost/vhost.h |  41 ----
>>   2 files changed, 3 insertions(+), 553 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 0536f8526359..791562e03fe0 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -298,160 +298,6 @@ static void vhost_vq_meta_reset(struct vhost_dev *d)
>>   		__vhost_vq_meta_reset(d->vqs[i]);
>>   }
>>   
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -static void vhost_map_unprefetch(struct vhost_map *map)
>> -{
>> -	kfree(map->pages);
>> -	map->pages = NULL;
>> -	map->npages = 0;
>> -	map->addr = NULL;
>> -}
>> -
>> -static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>> -{
>> -	struct vhost_map *map[VHOST_NUM_ADDRS];
>> -	int i;
>> -
>> -	spin_lock(&vq->mmu_lock);
>> -	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
>> -		map[i] = rcu_dereference_protected(vq->maps[i],
>> -				  lockdep_is_held(&vq->mmu_lock));
>> -		if (map[i])
>> -			rcu_assign_pointer(vq->maps[i], NULL);
>> -	}
>> -	spin_unlock(&vq->mmu_lock);
>> -
>> -	synchronize_rcu();
>> -
>> -	for (i = 0; i < VHOST_NUM_ADDRS; i++)
>> -		if (map[i])
>> -			vhost_map_unprefetch(map[i]);
>> -
>> -}
>> -
>> -static void vhost_reset_vq_maps(struct vhost_virtqueue *vq)
>> -{
>> -	int i;
>> -
>> -	vhost_uninit_vq_maps(vq);
>> -	for (i = 0; i < VHOST_NUM_ADDRS; i++)
>> -		vq->uaddrs[i].size = 0;
>> -}
>> -
>> -static bool vhost_map_range_overlap(struct vhost_uaddr *uaddr,
>> -				     unsigned long start,
>> -				     unsigned long end)
>> -{
>> -	if (unlikely(!uaddr->size))
>> -		return false;
>> -
>> -	return !(end < uaddr->uaddr || start > uaddr->uaddr - 1 + uaddr->size);
>> -}
>> -
>> -static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>> -				      int index,
>> -				      unsigned long start,
>> -				      unsigned long end)
>> -{
>> -	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>> -	struct vhost_map *map;
>> -	int i;
>> -
>> -	if (!vhost_map_range_overlap(uaddr, start, end))
>> -		return;
>> -
>> -	spin_lock(&vq->mmu_lock);
>> -	++vq->invalidate_count;
>> -
>> -	map = rcu_dereference_protected(vq->maps[index],
>> -					lockdep_is_held(&vq->mmu_lock));
>> -	if (map) {
>> -		if (uaddr->write) {
>> -			for (i = 0; i < map->npages; i++)
>> -				set_page_dirty(map->pages[i]);
>> -		}
>> -		rcu_assign_pointer(vq->maps[index], NULL);
>> -	}
>> -	spin_unlock(&vq->mmu_lock);
>> -
>> -	if (map) {
>> -		synchronize_rcu();
>> -		vhost_map_unprefetch(map);
>> -	}
>> -}
>> -
>> -static void vhost_invalidate_vq_end(struct vhost_virtqueue *vq,
>> -				    int index,
>> -				    unsigned long start,
>> -				    unsigned long end)
>> -{
>> -	if (!vhost_map_range_overlap(&vq->uaddrs[index], start, end))
>> -		return;
>> -
>> -	spin_lock(&vq->mmu_lock);
>> -	--vq->invalidate_count;
>> -	spin_unlock(&vq->mmu_lock);
>> -}
>> -
>> -static int vhost_invalidate_range_start(struct mmu_notifier *mn,
>> -					const struct mmu_notifier_range *range)
>> -{
>> -	struct vhost_dev *dev = container_of(mn, struct vhost_dev,
>> -					     mmu_notifier);
>> -	int i, j;
>> -
>> -	if (!mmu_notifier_range_blockable(range))
>> -		return -EAGAIN;
>> -
>> -	for (i = 0; i < dev->nvqs; i++) {
>> -		struct vhost_virtqueue *vq = dev->vqs[i];
>> -
>> -		for (j = 0; j < VHOST_NUM_ADDRS; j++)
>> -			vhost_invalidate_vq_start(vq, j,
>> -						  range->start,
>> -						  range->end);
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>> -static void vhost_invalidate_range_end(struct mmu_notifier *mn,
>> -				       const struct mmu_notifier_range *range)
>> -{
>> -	struct vhost_dev *dev = container_of(mn, struct vhost_dev,
>> -					     mmu_notifier);
>> -	int i, j;
>> -
>> -	for (i = 0; i < dev->nvqs; i++) {
>> -		struct vhost_virtqueue *vq = dev->vqs[i];
>> -
>> -		for (j = 0; j < VHOST_NUM_ADDRS; j++)
>> -			vhost_invalidate_vq_end(vq, j,
>> -						range->start,
>> -						range->end);
>> -	}
>> -}
>> -
>> -static const struct mmu_notifier_ops vhost_mmu_notifier_ops = {
>> -	.invalidate_range_start = vhost_invalidate_range_start,
>> -	.invalidate_range_end = vhost_invalidate_range_end,
>> -};
>> -
>> -static void vhost_init_maps(struct vhost_dev *dev)
>> -{
>> -	struct vhost_virtqueue *vq;
>> -	int i, j;
>> -
>> -	dev->mmu_notifier.ops = &vhost_mmu_notifier_ops;
>> -
>> -	for (i = 0; i < dev->nvqs; ++i) {
>> -		vq = dev->vqs[i];
>> -		for (j = 0; j < VHOST_NUM_ADDRS; j++)
>> -			RCU_INIT_POINTER(vq->maps[j], NULL);
>> -	}
>> -}
>> -#endif
>> -
>>   static void vhost_vq_reset(struct vhost_dev *dev,
>>   			   struct vhost_virtqueue *vq)
>>   {
>> @@ -480,11 +326,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>   	vq->busyloop_timeout = 0;
>>   	vq->umem = NULL;
>>   	vq->iotlb = NULL;
>> -	vq->invalidate_count = 0;
>>   	__vhost_vq_meta_reset(vq);
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	vhost_reset_vq_maps(vq);
>> -#endif
>>   }
>>   
>>   static int vhost_worker(void *data)
>> @@ -634,9 +476,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>>   	INIT_LIST_HEAD(&dev->read_list);
>>   	INIT_LIST_HEAD(&dev->pending_list);
>>   	spin_lock_init(&dev->iotlb_lock);
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	vhost_init_maps(dev);
>> -#endif
>> +
>>   
>>   	for (i = 0; i < dev->nvqs; ++i) {
>>   		vq = dev->vqs[i];
>> @@ -645,7 +485,6 @@ void vhost_dev_init(struct vhost_dev *dev,
>>   		vq->heads = NULL;
>>   		vq->dev = dev;
>>   		mutex_init(&vq->mutex);
>> -		spin_lock_init(&vq->mmu_lock);
>>   		vhost_vq_reset(dev, vq);
>>   		if (vq->handle_kick)
>>   			vhost_poll_init(&vq->poll, vq->handle_kick,
>> @@ -725,18 +564,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>>   	if (err)
>>   		goto err_cgroup;
>>   
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	err = mmu_notifier_register(&dev->mmu_notifier, dev->mm);
>> -	if (err)
>> -		goto err_mmu_notifier;
>> -#endif
>> -
>>   	return 0;
>> -
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -err_mmu_notifier:
>> -	vhost_dev_free_iovecs(dev);
>> -#endif
>>   err_cgroup:
>>   	kthread_stop(worker);
>>   	dev->worker = NULL;
>> @@ -827,107 +655,6 @@ static void vhost_clear_msg(struct vhost_dev *dev)
>>   	spin_unlock(&dev->iotlb_lock);
>>   }
>>   
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -static void vhost_setup_uaddr(struct vhost_virtqueue *vq,
>> -			      int index, unsigned long uaddr,
>> -			      size_t size, bool write)
>> -{
>> -	struct vhost_uaddr *addr = &vq->uaddrs[index];
>> -
>> -	addr->uaddr = uaddr;
>> -	addr->size = size;
>> -	addr->write = write;
>> -}
>> -
>> -static void vhost_setup_vq_uaddr(struct vhost_virtqueue *vq)
>> -{
>> -	vhost_setup_uaddr(vq, VHOST_ADDR_DESC,
>> -			  (unsigned long)vq->desc,
>> -			  vhost_get_desc_size(vq, vq->num),
>> -			  false);
>> -	vhost_setup_uaddr(vq, VHOST_ADDR_AVAIL,
>> -			  (unsigned long)vq->avail,
>> -			  vhost_get_avail_size(vq, vq->num),
>> -			  false);
>> -	vhost_setup_uaddr(vq, VHOST_ADDR_USED,
>> -			  (unsigned long)vq->used,
>> -			  vhost_get_used_size(vq, vq->num),
>> -			  true);
>> -}
>> -
>> -static int vhost_map_prefetch(struct vhost_virtqueue *vq,
>> -			       int index)
>> -{
>> -	struct vhost_map *map;
>> -	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>> -	struct page **pages;
>> -	int npages = DIV_ROUND_UP(uaddr->size, PAGE_SIZE);
>> -	int npinned;
>> -	void *vaddr, *v;
>> -	int err;
>> -	int i;
>> -
>> -	spin_lock(&vq->mmu_lock);
>> -
>> -	err = -EFAULT;
>> -	if (vq->invalidate_count)
>> -		goto err;
>> -
>> -	err = -ENOMEM;
>> -	map = kmalloc(sizeof(*map), GFP_ATOMIC);
>> -	if (!map)
>> -		goto err;
>> -
>> -	pages = kmalloc_array(npages, sizeof(struct page *), GFP_ATOMIC);
>> -	if (!pages)
>> -		goto err_pages;
>> -
>> -	err = EFAULT;
>> -	npinned = __get_user_pages_fast(uaddr->uaddr, npages,
>> -					uaddr->write, pages);
>> -	if (npinned > 0)
>> -		release_pages(pages, npinned);
>> -	if (npinned != npages)
>> -		goto err_gup;
>> -
>> -	for (i = 0; i < npinned; i++)
>> -		if (PageHighMem(pages[i]))
>> -			goto err_gup;
>> -
>> -	vaddr = v = page_address(pages[0]);
>> -
>> -	/* For simplicity, fallback to userspace address if VA is not
>> -	 * contigious.
>> -	 */
>> -	for (i = 1; i < npinned; i++) {
>> -		v += PAGE_SIZE;
>> -		if (v != page_address(pages[i]))
>> -			goto err_gup;
>> -	}
>> -
>> -	map->addr = vaddr + (uaddr->uaddr & (PAGE_SIZE - 1));
>> -	map->npages = npages;
>> -	map->pages = pages;
>> -
>> -	rcu_assign_pointer(vq->maps[index], map);
>> -	/* No need for a synchronize_rcu(). This function should be
>> -	 * called by dev->worker so we are serialized with all
>> -	 * readers.
>> -	 */
>> -	spin_unlock(&vq->mmu_lock);
>> -
>> -	return 0;
>> -
>> -err_gup:
>> -	kfree(pages);
>> -err_pages:
>> -	kfree(map);
>> -err:
>> -	spin_unlock(&vq->mmu_lock);
>> -	return err;
>> -}
>> -#endif
>> -
>>   void vhost_dev_cleanup(struct vhost_dev *dev)
>>   {
>>   	int i;
>> @@ -957,16 +684,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>>   		kthread_stop(dev->worker);
>>   		dev->worker = NULL;
>>   	}
>> -	if (dev->mm) {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -		mmu_notifier_unregister(&dev->mmu_notifier, dev->mm);
>> -#endif
>> +	if (dev->mm)
>>   		mmput(dev->mm);
>> -	}
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	for (i = 0; i < dev->nvqs; i++)
>> -		vhost_uninit_vq_maps(dev->vqs[i]);
>> -#endif
>>   	dev->mm = NULL;
>>   }
>>   EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
>> @@ -1195,26 +914,6 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
>>   
>>   static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_used *used;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
>> -		if (likely(map)) {
>> -			used = map->addr;
>> -			*((__virtio16 *)&used->ring[vq->num]) =
>> -				cpu_to_vhost16(vq, vq->avail_idx);
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->avail_idx),
>>   			      vhost_avail_event(vq));
>>   }
>> @@ -1223,27 +922,6 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
>>   				 struct vring_used_elem *head, int idx,
>>   				 int count)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_used *used;
>> -	size_t size;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
>> -		if (likely(map)) {
>> -			used = map->addr;
>> -			size = count * sizeof(*head);
>> -			memcpy(used->ring + idx, head, size);
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_copy_to_user(vq, vq->used->ring + idx, head,
>>   				  count * sizeof(*head));
>>   }
>> @@ -1251,25 +929,6 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
>>   static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
>>   
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_used *used;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
>> -		if (likely(map)) {
>> -			used = map->addr;
>> -			used->flags = cpu_to_vhost16(vq, vq->used_flags);
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->used_flags),
>>   			      &vq->used->flags);
>>   }
>> @@ -1277,25 +936,6 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
>>   static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
>>   
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_used *used;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
>> -		if (likely(map)) {
>> -			used = map->addr;
>> -			used->idx = cpu_to_vhost16(vq, vq->last_used_idx);
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->last_used_idx),
>>   			      &vq->used->idx);
>>   }
>> @@ -1341,50 +981,12 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
>>   static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
>>   				      __virtio16 *idx)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_avail *avail;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
>> -		if (likely(map)) {
>> -			avail = map->addr;
>> -			*idx = avail->idx;
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_get_avail(vq, *idx, &vq->avail->idx);
>>   }
>>   
>>   static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
>>   				       __virtio16 *head, int idx)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_avail *avail;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
>> -		if (likely(map)) {
>> -			avail = map->addr;
>> -			*head = avail->ring[idx & (vq->num - 1)];
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_get_avail(vq, *head,
>>   			       &vq->avail->ring[idx & (vq->num - 1)]);
>>   }
>> @@ -1392,98 +994,24 @@ static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
>>   static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
>>   					__virtio16 *flags)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_avail *avail;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
>> -		if (likely(map)) {
>> -			avail = map->addr;
>> -			*flags = avail->flags;
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_get_avail(vq, *flags, &vq->avail->flags);
>>   }
>>   
>>   static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
>>   				       __virtio16 *event)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_avail *avail;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
>> -		if (likely(map)) {
>> -			avail = map->addr;
>> -			*event = (__virtio16)avail->ring[vq->num];
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_get_avail(vq, *event, vhost_used_event(vq));
>>   }
>>   
>>   static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
>>   				     __virtio16 *idx)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_used *used;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
>> -		if (likely(map)) {
>> -			used = map->addr;
>> -			*idx = used->idx;
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_get_used(vq, *idx, &vq->used->idx);
>>   }
>>   
>>   static inline int vhost_get_desc(struct vhost_virtqueue *vq,
>>   				 struct vring_desc *desc, int idx)
>>   {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	struct vhost_map *map;
>> -	struct vring_desc *d;
>> -
>> -	if (!vq->iotlb) {
>> -		rcu_read_lock();
>> -
>> -		map = rcu_dereference(vq->maps[VHOST_ADDR_DESC]);
>> -		if (likely(map)) {
>> -			d = map->addr;
>> -			*desc = *(d + idx);
>> -			rcu_read_unlock();
>> -			return 0;
>> -		}
>> -
>> -		rcu_read_unlock();
>> -	}
>> -#endif
>> -
>>   	return vhost_copy_from_user(vq, desc, vq->desc + idx, sizeof(*desc));
>>   }
>>   
>> @@ -1824,32 +1352,12 @@ static bool iotlb_access_ok(struct vhost_virtqueue *vq,
>>   	return true;
>>   }
>>   
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -static void vhost_vq_map_prefetch(struct vhost_virtqueue *vq)
>> -{
>> -	struct vhost_map __rcu *map;
>> -	int i;
>> -
>> -	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
>> -		rcu_read_lock();
>> -		map = rcu_dereference(vq->maps[i]);
>> -		rcu_read_unlock();
>> -		if (unlikely(!map))
>> -			vhost_map_prefetch(vq, i);
>> -	}
>> -}
>> -#endif
>> -
>>   int vq_meta_prefetch(struct vhost_virtqueue *vq)
>>   {
>>   	unsigned int num = vq->num;
>>   
>> -	if (!vq->iotlb) {
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -		vhost_vq_map_prefetch(vq);
>> -#endif
>> +	if (!vq->iotlb)
>>   		return 1;
>> -	}
>>   
>>   	return iotlb_access_ok(vq, VHOST_ACCESS_RO, (u64)(uintptr_t)vq->desc,
>>   			       vhost_get_desc_size(vq, num), VHOST_ADDR_DESC) &&
>> @@ -2060,16 +1568,6 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>>   
>>   	mutex_lock(&vq->mutex);
>>   
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	/* Unregister MMU notifer to allow invalidation callback
>> -	 * can access vq->uaddrs[] without holding a lock.
>> -	 */
>> -	if (d->mm)
>> -		mmu_notifier_unregister(&d->mmu_notifier, d->mm);
>> -
>> -	vhost_uninit_vq_maps(vq);
>> -#endif
>> -
>>   	switch (ioctl) {
>>   	case VHOST_SET_VRING_NUM:
>>   		r = vhost_vring_set_num(d, vq, argp);
>> @@ -2081,13 +1579,6 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>>   		BUG();
>>   	}
>>   
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	vhost_setup_vq_uaddr(vq);
>> -
>> -	if (d->mm)
>> -		mmu_notifier_register(&d->mmu_notifier, d->mm);
>> -#endif
>> -
>>   	mutex_unlock(&vq->mutex);
>>   
>>   	return r;
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index 42a8c2a13ab1..e9ed2722b633 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -12,9 +12,6 @@
>>   #include <linux/virtio_config.h>
>>   #include <linux/virtio_ring.h>
>>   #include <linux/atomic.h>
>> -#include <linux/pagemap.h>
>> -#include <linux/mmu_notifier.h>
>> -#include <asm/cacheflush.h>
>>   
>>   struct vhost_work;
>>   typedef void (*vhost_work_fn_t)(struct vhost_work *work);
>> @@ -83,24 +80,6 @@ enum vhost_uaddr_type {
>>   	VHOST_NUM_ADDRS = 3,
>>   };
>>   
>> -struct vhost_map {
>> -	int npages;
>> -	void *addr;
>> -	struct page **pages;
>> -};
>> -
>> -struct vhost_uaddr {
>> -	unsigned long uaddr;
>> -	size_t size;
>> -	bool write;
>> -};
>> -
>> -#if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
>> -#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
>> -#else
>> -#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
>> -#endif
>> -
>>   /* The virtqueue structure describes a queue attached to a device. */
>>   struct vhost_virtqueue {
>>   	struct vhost_dev *dev;
>> @@ -111,22 +90,7 @@ struct vhost_virtqueue {
>>   	struct vring_desc __user *desc;
>>   	struct vring_avail __user *avail;
>>   	struct vring_used __user *used;
>> -
>> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -	/* Read by memory accessors, modified by meta data
>> -	 * prefetching, MMU notifier and vring ioctl().
>> -	 * Synchonrized through mmu_lock (writers) and RCU (writers
>> -	 * and readers).
>> -	 */
>> -	struct vhost_map __rcu *maps[VHOST_NUM_ADDRS];
>> -	/* Read by MMU notifier, modified by vring ioctl(),
>> -	 * synchronized through MMU notifier
>> -	 * registering/unregistering.
>> -	 */
>> -	struct vhost_uaddr uaddrs[VHOST_NUM_ADDRS];
>> -#endif
>>   	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
>> -
>>   	struct file *kick;
>>   	struct eventfd_ctx *call_ctx;
>>   	struct eventfd_ctx *error_ctx;
>> @@ -181,8 +145,6 @@ struct vhost_virtqueue {
>>   	bool user_be;
>>   #endif
>>   	u32 busyloop_timeout;
>> -	spinlock_t mmu_lock;
>> -	int invalidate_count;
>>   };
>>   
>>   struct vhost_msg_node {
>> @@ -196,9 +158,6 @@ struct vhost_msg_node {
>>   
>>   struct vhost_dev {
>>   	struct mm_struct *mm;
>> -#ifdef CONFIG_MMU_NOTIFIER
>> -	struct mmu_notifier mmu_notifier;
>> -#endif
>>   	struct mutex mutex;
>>   	struct vhost_virtqueue **vqs;
>>   	int nvqs;
>> -- 
>> 2.19.1
