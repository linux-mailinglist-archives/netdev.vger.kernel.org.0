Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5D37C41
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbfFFS3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:29:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44260 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729592AbfFFS3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:29:00 -0400
Received: by mail-qt1-f194.google.com with SMTP id x47so3801060qtk.11
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 11:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VSW0mHlKPnFKRiIMc3nnFOw6KKgjVB71Zu0QRJyAwqk=;
        b=X3cum8GBvZLEH2QjF9tlXgNXZ2Dn3eVu1i6aeaTmXe3QsIe073PkPFy5P7uFkh34t/
         B+XJFTMWp6zNBjDF/AlM2U+odO8KJcSfo0ffLhEyVp9Xnl6MztKVfrpt5dokDIASfQwb
         /BuczUZ4m2/AEdR7Uu21WRhgmnB2Lkn+OqD1JWCpL1CxYs7XyqNjllbLCdGgC5LEYW0k
         RCoQ5fTZbs08AZsTvg8Y4rwHobaBk4xU/thoiuaZuNoJYplZjTBw0Yd32SUS+anpglnW
         v4ElwfJHM+lL/NsjNHUnUBBCKuC3rpJaDtYOymmjGMmDNpTI/7zu7RsumSfij63F/ACd
         FiLg==
X-Gm-Message-State: APjAAAX1WYq0CDGCP76tT861YnDem50zpI5Y/jyKzGBcHh0yeXSVeBdf
        EH6jG9enupV1S/JW9w+B0X/IGQ==
X-Google-Smtp-Source: APXvYqyOMiPipyMKs3/NXaVvVmc3VOZ8tY0mlKbylPCpIe8W3cBYix2XiQCSn1D1fkmb1e6r9hnULQ==
X-Received: by 2002:ac8:35c2:: with SMTP id l2mr42039410qtb.123.1559845739028;
        Thu, 06 Jun 2019 11:28:59 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net. [100.0.197.103])
        by smtp.gmail.com with ESMTPSA id c5sm1174402qtj.27.2019.06.06.11.28.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 11:28:58 -0700 (PDT)
Date:   Thu, 6 Jun 2019 14:28:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] vhost: Don't use defined in VHOST_ARCH_CAN_ACCEL_UACCESS
 definition
Message-ID: <20190606142606-mutt-send-email-mst@kernel.org>
References: <20190606161223.67979-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606161223.67979-1-natechancellor@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 09:12:23AM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   drivers/vhost/vhost.c:2085:5: warning: macro expansion producing
>   'defined' has undefined behavior [-Wexpansion-to-defined]
>   #if VHOST_ARCH_CAN_ACCEL_UACCESS
>       ^
>   drivers/vhost/vhost.h:98:38: note: expanded from macro
>   'VHOST_ARCH_CAN_ACCEL_UACCESS'
>   #define VHOST_ARCH_CAN_ACCEL_UACCESS defined(CONFIG_MMU_NOTIFIER) && \
>                                        ^
> 
> Rework VHOST_ARCH_CAN_ACCEL_UACCESS to be defined under those conditions
> so that the meaning of the code doesn't change and clang no longer
> warns.
> 
> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Link: https://github.com/ClangBuiltLinux/linux/issues/508
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/vhost/vhost.c | 44 +++++++++++++++++++++----------------------
>  drivers/vhost/vhost.h |  7 ++++---
>  2 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index dc9301d31f12..cc56d08b4275 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -299,7 +299,7 @@ static void vhost_vq_meta_reset(struct vhost_dev *d)
>  		__vhost_vq_meta_reset(d->vqs[i]);
>  }
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  static void vhost_map_unprefetch(struct vhost_map *map)
>  {
>  	kfree(map->pages);
> @@ -483,7 +483,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>  	vq->iotlb = NULL;
>  	vq->invalidate_count = 0;
>  	__vhost_vq_meta_reset(vq);
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	vhost_reset_vq_maps(vq);
>  #endif
>  }
> @@ -635,7 +635,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>  	INIT_LIST_HEAD(&dev->read_list);
>  	INIT_LIST_HEAD(&dev->pending_list);
>  	spin_lock_init(&dev->iotlb_lock);
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	vhost_init_maps(dev);
>  #endif
>  
> @@ -726,7 +726,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  	if (err)
>  		goto err_cgroup;
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	err = mmu_notifier_register(&dev->mmu_notifier, dev->mm);
>  	if (err)
>  		goto err_mmu_notifier;
> @@ -734,7 +734,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  
>  	return 0;
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  err_mmu_notifier:
>  	vhost_dev_free_iovecs(dev);
>  #endif
> @@ -828,7 +828,7 @@ static void vhost_clear_msg(struct vhost_dev *dev)
>  	spin_unlock(&dev->iotlb_lock);
>  }
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  static void vhost_setup_uaddr(struct vhost_virtqueue *vq,
>  			      int index, unsigned long uaddr,
>  			      size_t size, bool write)
> @@ -959,12 +959,12 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  		dev->worker = NULL;
>  	}
>  	if (dev->mm) {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  		mmu_notifier_unregister(&dev->mmu_notifier, dev->mm);
>  #endif
>  		mmput(dev->mm);
>  	}
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	for (i = 0; i < dev->nvqs; i++)
>  		vhost_uninit_vq_maps(dev->vqs[i]);
>  #endif
> @@ -1196,7 +1196,7 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
>  
>  static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_used *used;
>  
> @@ -1224,7 +1224,7 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
>  				 struct vring_used_elem *head, int idx,
>  				 int count)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_used *used;
>  	size_t size;
> @@ -1252,7 +1252,7 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
>  static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
>  
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_used *used;
>  
> @@ -1278,7 +1278,7 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
>  static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
>  
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_used *used;
>  
> @@ -1342,7 +1342,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
>  static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
>  				      __virtio16 *idx)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_avail *avail;
>  
> @@ -1367,7 +1367,7 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
>  static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
>  				       __virtio16 *head, int idx)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_avail *avail;
>  
> @@ -1393,7 +1393,7 @@ static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
>  static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
>  					__virtio16 *flags)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_avail *avail;
>  
> @@ -1418,7 +1418,7 @@ static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
>  static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
>  				       __virtio16 *event)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_avail *avail;
>  
> @@ -1441,7 +1441,7 @@ static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
>  static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
>  				     __virtio16 *idx)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_used *used;
>  
> @@ -1466,7 +1466,7 @@ static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
>  static inline int vhost_get_desc(struct vhost_virtqueue *vq,
>  				 struct vring_desc *desc, int idx)
>  {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	struct vhost_map *map;
>  	struct vring_desc *d;
>  
> @@ -1825,7 +1825,7 @@ static bool iotlb_access_ok(struct vhost_virtqueue *vq,
>  	return true;
>  }
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  static void vhost_vq_map_prefetch(struct vhost_virtqueue *vq)
>  {
>  	struct vhost_map __rcu *map;
> @@ -1846,7 +1846,7 @@ int vq_meta_prefetch(struct vhost_virtqueue *vq)
>  	unsigned int num = vq->num;
>  
>  	if (!vq->iotlb) {
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  		vhost_vq_map_prefetch(vq);
>  #endif
>  		return 1;
> @@ -2061,7 +2061,7 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>  
>  	mutex_lock(&vq->mutex);
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	/* Unregister MMU notifer to allow invalidation callback
>  	 * can access vq->uaddrs[] without holding a lock.
>  	 */
> @@ -2082,7 +2082,7 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>  		BUG();
>  	}
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	vhost_setup_vq_uaddr(vq);
>  
>  	if (d->mm)
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index c5d950cf7627..d9f36c479fa7 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -95,8 +95,9 @@ struct vhost_uaddr {
>  	bool write;
>  };
>  
> -#define VHOST_ARCH_CAN_ACCEL_UACCESS defined(CONFIG_MMU_NOTIFIER) && \
> -	ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
> +#if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
> +#define VHOST_ARCH_CAN_ACCEL_UACCESS
> +#endif
>  
>  /* The virtqueue structure describes a queue attached to a device. */
>  struct vhost_virtqueue {
> @@ -109,7 +110,7 @@ struct vhost_virtqueue {
>  	struct vring_avail __user *avail;
>  	struct vring_used __user *used;
>  
> -#if VHOST_ARCH_CAN_ACCEL_UACCESS
> +#ifdef VHOST_ARCH_CAN_ACCEL_UACCESS
>  	/* Read by memory accessors, modified by meta data
>  	 * prefetching, MMU notifier and vring ioctl().
>  	 * Synchonrized through mmu_lock (writers) and RCU (writers
> -- 
> 2.22.0.rc3



I'd prefer just changing the definition.
ifdefs have a disadvantage that it's easy to get
wrong code if you forget to include a header.

I queued the below - pls confirm it works for you.


diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index c5d950cf7627..819296332913 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -95,8 +95,11 @@ struct vhost_uaddr {
 	bool write;
 };
 
-#define VHOST_ARCH_CAN_ACCEL_UACCESS defined(CONFIG_MMU_NOTIFIER) && \
-	ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
+#if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
+#define VHOST_ARCH_CAN_ACCEL_UACCESS 1
+#else
+#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
+#endif
 
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
