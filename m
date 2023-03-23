Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8260D6C655B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjCWKl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCWKlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:41:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DD81CAE9
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679567837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EpnQQ3G7hcvDGrM22xg98YnMqqv0RfyTzwV5l3OM/5c=;
        b=T8vGbZJ6q6HsqG+HFEcAD2d7/Rn9guAwGxu1mDJawJV37J+JpKwxiw25YtR8/x9amzvdUG
        y5CMdlBcSk96wUphPJWzRSGnCeZNZ5WCOgVZUqyfrOXZ6x4kV5joej8QYcY5EJkuzya19f
        ro3WUS/HfvWGhenKQMFbIcKJsliCgrg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-Gf7t3lfJPoSJZbtYQZgTUg-1; Thu, 23 Mar 2023 06:37:16 -0400
X-MC-Unique: Gf7t3lfJPoSJZbtYQZgTUg-1
Received: by mail-wm1-f69.google.com with SMTP id k29-20020a05600c1c9d00b003ee3a8d547eso3762377wms.2
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:37:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679567834;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EpnQQ3G7hcvDGrM22xg98YnMqqv0RfyTzwV5l3OM/5c=;
        b=AyBiA6h7rdqbNetXw7ZN+3o7BQxTywuAdlWGUGOg09fKzZTHoebZ4olW+zhz/HC4ZL
         pJJmIf361eeSVhzzsy75be9LQr1M5fYuYWQ6wIqGZfquC6ASJjpeGXIsj2rJmFQw4snb
         q0MgpCskgXfuoX3cGWMDITh3MeliH8yyHcsDDscAJGNUozKWkQaZSZyRxQIqx1QaD1FA
         wxLi9HCB8bYoaGJhGrl/qF9zBQdv/wiR0ia5KXDp8ozd2+gU4wymmkMECPxGmocmgP6g
         dMqJH74g5a90Yxew6iuwrIcM++tJrvhn1PT1ChQtog/zOmRnDVbcXwjgmnb43qNjtIvU
         BYGQ==
X-Gm-Message-State: AO0yUKXsssCH1Il+0z6rCOkkW1XGtsHNLfK11y8aoEw9rtS75DppQ0VW
        ZWSuRTIboWK//bZnwzZ4mg9lMZBgPCu5kLTTQnk3lhT7WSoGdnwSW1/qKLQ59hvVpwF2mYeIeuh
        lkhJtNtdwZ4080aKG
X-Received: by 2002:a05:600c:2256:b0:3ee:5754:f14b with SMTP id a22-20020a05600c225600b003ee5754f14bmr2034975wmm.3.1679567834564;
        Thu, 23 Mar 2023 03:37:14 -0700 (PDT)
X-Google-Smtp-Source: AK7set+gpzAA7wqFypGZYurRSrxux98xhwtHxoigh9D6yMe4Wr4EW4I56QepTLL6+hAsj2ePNI94IA==
X-Received: by 2002:a05:600c:2256:b0:3ee:5754:f14b with SMTP id a22-20020a05600c225600b003ee5754f14bmr2034963wmm.3.1679567834201;
        Thu, 23 Mar 2023 03:37:14 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id z21-20020a1cf415000000b003ee3e075d1csm1483544wma.22.2023.03.23.03.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 03:37:13 -0700 (PDT)
Date:   Thu, 23 Mar 2023 11:37:11 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/8] vringh: support VA with iotlb
Message-ID: <20230323103711.sobptckmgr22lwxj@sgarzare-redhat>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154228.182769-5-sgarzare@redhat.com>
 <CACGkMEs3G+O3Jo7yNPSOZ9wiEbq_nudU9HrVNzhqtkGoRVesYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEs3G+O3Jo7yNPSOZ9wiEbq_nudU9HrVNzhqtkGoRVesYA@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:36:28AM +0800, Jason Wang wrote:
>On Tue, Mar 21, 2023 at 11:43 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> vDPA supports the possibility to use user VA in the iotlb messages.
>> So, let's add support for user VA in vringh to use it in the vDPA
>> simulators.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> Notes:
>>     v3:
>>     - refactored avoiding code duplication [Eugenio]
>>     v2:
>>     - replace kmap_atomic() with kmap_local_page() [see previous patch]
>>     - fix cast warnings when build with W=1 C=1
>>
>>  include/linux/vringh.h            |   5 +-
>>  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
>>  drivers/vhost/vringh.c            | 153 +++++++++++++++++++++++-------
>>  4 files changed, 127 insertions(+), 37 deletions(-)
>>
>> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
>> index 1991a02c6431..d39b9f2dcba0 100644
>> --- a/include/linux/vringh.h
>> +++ b/include/linux/vringh.h
>> @@ -32,6 +32,9 @@ struct vringh {
>>         /* Can we get away with weak barriers? */
>>         bool weak_barriers;
>>
>> +       /* Use user's VA */
>> +       bool use_va;
>> +
>>         /* Last available index we saw (ie. where we're up to). */
>>         u16 last_avail_idx;
>>
>> @@ -279,7 +282,7 @@ void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb,
>>                       spinlock_t *iotlb_lock);
>>
>>  int vringh_init_iotlb(struct vringh *vrh, u64 features,
>> -                     unsigned int num, bool weak_barriers,
>> +                     unsigned int num, bool weak_barriers, bool use_va,
>>                       struct vring_desc *desc,
>>                       struct vring_avail *avail,
>>                       struct vring_used *used);
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index 520646ae7fa0..dfd0e000217b 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -2537,7 +2537,7 @@ static int setup_cvq_vring(struct mlx5_vdpa_dev *mvdev)
>>
>>         if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
>>                 err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
>> -                                       MLX5_CVQ_MAX_ENT, false,
>> +                                       MLX5_CVQ_MAX_ENT, false, false,
>
>To avoid those changes, would it be better to introduce
>vringh_init_iotlb_va() so vringh_init_iotlb() can stick to pa.

Okay, I don't have a strong opinion, I'll add vringh_init_iotlb_va().

>
>>                                         (struct vring_desc *)(uintptr_t)cvq->desc_addr,
>>                                         (struct vring_avail *)(uintptr_t)cvq->driver_addr,
>>                                         (struct vring_used *)(uintptr_t)cvq->device_addr);
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> index eea23c630f7c..47cdf2a1f5b8 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> @@ -60,7 +60,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
>>         struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>>         uint16_t last_avail_idx = vq->vring.last_avail_idx;
>>
>> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
>> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, false,
>>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>>                           (struct vring_avail *)
>>                           (uintptr_t)vq->driver_addr,
>> @@ -92,7 +92,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim,
>>         vq->cb = NULL;
>>         vq->private = NULL;
>>         vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_features,
>> -                         VDPASIM_QUEUE_MAX, false, NULL, NULL, NULL);
>> +                         VDPASIM_QUEUE_MAX, false, false, NULL, NULL, NULL);
>>
>>         vq->vring.notify = NULL;
>>  }
>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>> index 0ba3ef809e48..72c88519329a 100644
>> --- a/drivers/vhost/vringh.c
>> +++ b/drivers/vhost/vringh.c
>> @@ -1094,10 +1094,18 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>>
>>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>>
>> +struct iotlb_vec {
>> +       union {
>> +               struct iovec *iovec;
>> +               struct bio_vec *bvec;
>> +       } iov;
>> +       size_t count;
>> +       bool is_iovec;
>
>I wonder if this is needed (if vringh is passed to every iotlb_vec helper).

Yep, I can use vringh->use_va.

>
>> +};
>> +
>>  static int iotlb_translate(const struct vringh *vrh,
>>                            u64 addr, u64 len, u64 *translated,
>> -                          struct bio_vec iov[],
>> -                          int iov_size, u32 perm)
>> +                          struct iotlb_vec *ivec, u32 perm)
>>  {
>>         struct vhost_iotlb_map *map;
>>         struct vhost_iotlb *iotlb = vrh->iotlb;
>> @@ -1107,9 +1115,9 @@ static int iotlb_translate(const struct vringh *vrh,
>>         spin_lock(vrh->iotlb_lock);
>>
>>         while (len > s) {
>> -               u64 size, pa, pfn;
>> +               u64 size;
>>
>> -               if (unlikely(ret >= iov_size)) {
>> +               if (unlikely(ret >= ivec->count)) {
>>                         ret = -ENOBUFS;
>>                         break;
>>                 }
>> @@ -1124,10 +1132,22 @@ static int iotlb_translate(const struct vringh *vrh,
>>                 }
>>
>>                 size = map->size - addr + map->start;
>> -               pa = map->addr + addr - map->start;
>> -               pfn = pa >> PAGE_SHIFT;
>> -               bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, size),
>> -                             pa & (PAGE_SIZE - 1));
>> +               if (ivec->is_iovec) {
>> +                       struct iovec *iovec = ivec->iov.iovec;
>> +
>> +                       iovec[ret].iov_len = min(len - s, size);
>> +                       iovec[ret].iov_base = (void __user *)(unsigned long)
>> +                                             (map->addr + addr - map->start);
>
>map->addr - map->start to avoid overflow?

Right, it was pre-existing, but I'll fix since I'm here (also in the
else branch).
And since it's duplicate code, I'll declare it outside!

>
>> +               } else {
>> +                       u64 pa = map->addr + addr - map->start;
>> +                       u64 pfn = pa >> PAGE_SHIFT;
>> +                       struct bio_vec *bvec = ivec->iov.bvec;
>> +
>> +                       bvec_set_page(&bvec[ret], pfn_to_page(pfn),
>> +                                     min(len - s, size),
>> +                                     pa & (PAGE_SIZE - 1));
>> +               }
>> +
>>                 s += size;
>>                 addr += size;
>>                 ++ret;
>> @@ -1141,26 +1161,42 @@ static int iotlb_translate(const struct vringh *vrh,
>>         return ret;
>>  }
>>
>> +#define IOTLB_IOV_SIZE 16
>> +
>>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>>                                   void *src, size_t len)
>>  {
>> +       struct iotlb_vec ivec;
>> +       union {
>> +               struct iovec iovec[IOTLB_IOV_SIZE];
>> +               struct bio_vec bvec[IOTLB_IOV_SIZE];
>> +       } iov;
>>         u64 total_translated = 0;
>>
>> +       ivec.iov.iovec = iov.iovec;
>
>ivc.iov = iov ?

I tried, but they are both anonymous unions, so I cannot assign them.

Also, this inner union I need to allocate space in the stack to hold
both arrays, while the union in iotlb_vec to carry both pointers.

I don't know whether to add a third field (e.g. `void *raw`) to both and
assign it.

>
>Others look good.

Thanks,
Stefano

