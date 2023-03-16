Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4356E6BC94C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCPIjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjCPIjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:39:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9495118A8C
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678955911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dzJh6sIVhiyeFQIKCjTmdWjn+gxrNuoUiWPXBqU+VHc=;
        b=HWG4WZoxDJtPmL79ut6DEC8To/Wbe/Fd/x0DaaUO2cu9ECIXGRd7wdBEK/N2CG4/tIcaID
        yXFVx1aGsO4TInttT2jmXX5rkSNIMoa+WOQlnAbAIYvtjitt3Di+A3AiDieEVGMXS08leG
        oyu3Ngy0j9O5U0kZ1+OGHlznPtEDFow=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-kXmbfvNQOuGhsj9qvX9XPQ-1; Thu, 16 Mar 2023 04:38:30 -0400
X-MC-Unique: kXmbfvNQOuGhsj9qvX9XPQ-1
Received: by mail-wm1-f72.google.com with SMTP id j13-20020a05600c190d00b003ed26189f44so2278985wmq.8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678955908;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dzJh6sIVhiyeFQIKCjTmdWjn+gxrNuoUiWPXBqU+VHc=;
        b=C6HPJ6BQo/jZJs1ToMhE67eVYYYjgE+PNE5rdwF5MW73P82TjeAJFbeVvw71zt5RpQ
         CAMqYo+212nUYVW9m6oVdDGH5iLAR7kYGQPNRQXJPB1WwocfX3sugIUMZ3ygqDpZuImp
         fuzD5ce3GUfpyZ+1vl+OQDvGNuAGrPkC919JUtDzQW1RC76pNEL493YHF+6rEjat3Q30
         9+MZE+RUxRym3MVcUmbpIHKoaxIR6CKrcG4DH0DNothqL9/D7fpohmaCV52lD4+Ad7S5
         chrnO/FqdMD/Gm/xT57s3Y95kZTeV3E7bwm1DErilmq7Iw+awav+cwWMKMLuFLs6F+yU
         gbkQ==
X-Gm-Message-State: AO0yUKXmjGCc4gPH/GUf+dpJlxWcyRWnO+TkiWd/mNY1RyU3NCshh2OR
        ht+VkgwXQkReX5pqUXYl1BF0zYDT6nZxfawq9eDh0oAIw+62JhVreeUNln5gvZrHj/n7jq/ojoj
        ctin1MC47v7wrkCfK
X-Received: by 2002:a5d:6304:0:b0:2ce:a13b:76b4 with SMTP id i4-20020a5d6304000000b002cea13b76b4mr3730841wru.24.1678955908599;
        Thu, 16 Mar 2023 01:38:28 -0700 (PDT)
X-Google-Smtp-Source: AK7set+XWpF24aY7eonF1LBR7DCOh17PTZr5Eke9UGKmTA/J2Y6eMkhHwpioi0MF9qnMf6V3Qo8aGw==
X-Received: by 2002:a5d:6304:0:b0:2ce:a13b:76b4 with SMTP id i4-20020a5d6304000000b002cea13b76b4mr3730825wru.24.1678955908276;
        Thu, 16 Mar 2023 01:38:28 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d550a000000b002c706c754fesm6539517wrv.32.2023.03.16.01.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 01:38:27 -0700 (PDT)
Date:   Thu, 16 Mar 2023 09:38:25 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/8] vringh: support VA with iotlb
Message-ID: <20230316083825.wslrk7abt4nts4us@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-5-sgarzare@redhat.com>
 <CACGkMEui+-8JcTOsF+=b3W7oduMLsaL3Y7upUDmAMu4zPcrQTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEui+-8JcTOsF+=b3W7oduMLsaL3Y7upUDmAMu4zPcrQTg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 12:53:57PM +0800, Jason Wang wrote:
>On Thu, Mar 2, 2023 at 7:35 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> vDPA supports the possibility to use user VA in the iotlb messages.
>> So, let's add support for user VA in vringh to use it in the vDPA
>> simulators.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> Notes:
>>     v2:
>>     - replace kmap_atomic() with kmap_local_page() [see previous patch]
>>     - fix cast warnings when build with W=1 C=1
>>
>>  include/linux/vringh.h            |   5 +-
>>  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
>>  drivers/vhost/vringh.c            | 247 ++++++++++++++++++++++++------
>>  4 files changed, 205 insertions(+), 53 deletions(-)
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
>> index 3a0e721aef05..babc8dd171a6 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -2537,7 +2537,7 @@ static int setup_cvq_vring(struct mlx5_vdpa_dev *mvdev)
>>
>>         if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
>>                 err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
>> -                                       MLX5_CVQ_MAX_ENT, false,
>> +                                       MLX5_CVQ_MAX_ENT, false, false,
>>                                         (struct vring_desc *)(uintptr_t)cvq->desc_addr,
>>                                         (struct vring_avail *)(uintptr_t)cvq->driver_addr,
>>                                         (struct vring_used *)(uintptr_t)cvq->device_addr);
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> index 6a0a65814626..481eb156658b 100644
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
>> @@ -81,7 +81,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim,
>>         vq->cb = NULL;
>>         vq->private = NULL;
>>         vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_features,
>> -                         VDPASIM_QUEUE_MAX, false, NULL, NULL, NULL);
>> +                         VDPASIM_QUEUE_MAX, false, false, NULL, NULL, NULL);
>>
>>         vq->vring.notify = NULL;
>>  }
>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>> index 0ba3ef809e48..61c79cea44ca 100644
>> --- a/drivers/vhost/vringh.c
>> +++ b/drivers/vhost/vringh.c
>> @@ -1094,15 +1094,99 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>>
>>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>>
>> -static int iotlb_translate(const struct vringh *vrh,
>> -                          u64 addr, u64 len, u64 *translated,
>> -                          struct bio_vec iov[],
>> -                          int iov_size, u32 perm)
>> +static int iotlb_translate_va(const struct vringh *vrh,
>> +                             u64 addr, u64 len, u64 *translated,
>> +                             struct iovec iov[],
>> +                             int iov_size, u32 perm)
>>  {
>>         struct vhost_iotlb_map *map;
>>         struct vhost_iotlb *iotlb = vrh->iotlb;
>> +       u64 s = 0, last = addr + len - 1;
>>         int ret = 0;
>> +
>> +       spin_lock(vrh->iotlb_lock);
>> +
>> +       while (len > s) {
>> +               u64 size;
>> +
>> +               if (unlikely(ret >= iov_size)) {
>> +                       ret = -ENOBUFS;
>> +                       break;
>> +               }
>> +
>> +               map = vhost_iotlb_itree_first(iotlb, addr, last);
>> +               if (!map || map->start > addr) {
>> +                       ret = -EINVAL;
>> +                       break;
>> +               } else if (!(map->perm & perm)) {
>> +                       ret = -EPERM;
>> +                       break;
>> +               }
>> +
>> +               size = map->size - addr + map->start;
>> +               iov[ret].iov_len = min(len - s, size);
>> +               iov[ret].iov_base = (void __user *)(unsigned long)
>> +                                   (map->addr + addr - map->start);
>> +               s += size;
>> +               addr += size;
>> +               ++ret;
>> +       }
>> +
>> +       spin_unlock(vrh->iotlb_lock);
>> +
>> +       if (translated)
>> +               *translated = min(len, s);
>> +
>> +       return ret;
>> +}
>> +
>> +static inline int copy_from_va(const struct vringh *vrh, void *dst, void *src,
>> +                              u64 len, u64 *translated)
>> +{
>> +       struct iovec iov[16];
>> +       struct iov_iter iter;
>> +       int ret;
>> +
>> +       ret = iotlb_translate_va(vrh, (u64)(uintptr_t)src, len, translated, iov,
>> +                                ARRAY_SIZE(iov), VHOST_MAP_RO);
>> +       if (ret == -ENOBUFS)
>> +               ret = ARRAY_SIZE(iov);
>> +       else if (ret < 0)
>> +               return ret;
>> +
>> +       iov_iter_init(&iter, ITER_SOURCE, iov, ret, *translated);
>> +
>> +       return copy_from_iter(dst, *translated, &iter);
>> +}
>> +
>> +static inline int copy_to_va(const struct vringh *vrh, void *dst, void *src,
>> +                            u64 len, u64 *translated)
>> +{
>> +       struct iovec iov[16];
>> +       struct iov_iter iter;
>> +       int ret;
>> +
>> +       ret = iotlb_translate_va(vrh, (u64)(uintptr_t)dst, len, translated, iov,
>> +                                ARRAY_SIZE(iov), VHOST_MAP_WO);
>> +       if (ret == -ENOBUFS)
>> +               ret = ARRAY_SIZE(iov);
>> +       else if (ret < 0)
>> +               return ret;
>> +
>> +       iov_iter_init(&iter, ITER_DEST, iov, ret, *translated);
>> +
>> +       return copy_to_iter(src, *translated, &iter);
>> +}
>> +
>> +static int iotlb_translate_pa(const struct vringh *vrh,
>> +                             u64 addr, u64 len, u64 *translated,
>> +                             struct bio_vec iov[],
>> +                             int iov_size, u32 perm)
>> +{
>> +       struct vhost_iotlb_map *map;
>> +       struct vhost_iotlb *iotlb = vrh->iotlb;
>>         u64 s = 0, last = addr + len - 1;
>> +       int ret = 0;
>>
>>         spin_lock(vrh->iotlb_lock);
>>
>> @@ -1141,28 +1225,61 @@ static int iotlb_translate(const struct vringh *vrh,
>>         return ret;
>>  }
>>
>> +static inline int copy_from_pa(const struct vringh *vrh, void *dst, void *src,
>> +                              u64 len, u64 *translated)
>> +{
>> +       struct bio_vec iov[16];
>> +       struct iov_iter iter;
>> +       int ret;
>> +
>> +       ret = iotlb_translate_pa(vrh, (u64)(uintptr_t)src, len, translated, iov,
>> +                                ARRAY_SIZE(iov), VHOST_MAP_RO);
>> +       if (ret == -ENOBUFS)
>> +               ret = ARRAY_SIZE(iov);
>> +       else if (ret < 0)
>> +               return ret;
>> +
>> +       iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, *translated);
>> +
>> +       return copy_from_iter(dst, *translated, &iter);
>> +}
>> +
>> +static inline int copy_to_pa(const struct vringh *vrh, void *dst, void *src,
>> +                            u64 len, u64 *translated)
>> +{
>> +       struct bio_vec iov[16];
>> +       struct iov_iter iter;
>> +       int ret;
>> +
>> +       ret = iotlb_translate_pa(vrh, (u64)(uintptr_t)dst, len, translated, iov,
>> +                                ARRAY_SIZE(iov), VHOST_MAP_WO);
>> +       if (ret == -ENOBUFS)
>> +               ret = ARRAY_SIZE(iov);
>> +       else if (ret < 0)
>> +               return ret;
>> +
>> +       iov_iter_bvec(&iter, ITER_DEST, iov, ret, *translated);
>> +
>> +       return copy_to_iter(src, *translated, &iter);
>> +}
>> +
>>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>>                                   void *src, size_t len)
>>  {
>>         u64 total_translated = 0;
>>
>>         while (total_translated < len) {
>> -               struct bio_vec iov[16];
>> -               struct iov_iter iter;
>>                 u64 translated;
>>                 int ret;
>>
>> -               ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
>> -                                     len - total_translated, &translated,
>> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_RO);
>> -               if (ret == -ENOBUFS)
>> -                       ret = ARRAY_SIZE(iov);
>> -               else if (ret < 0)
>> -                       return ret;
>> -
>> -               iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
>> +               if (vrh->use_va) {
>> +                       ret = copy_from_va(vrh, dst, src,
>> +                                          len - total_translated, &translated);
>> +               } else {
>> +                       ret = copy_from_pa(vrh, dst, src,
>> +                                          len - total_translated, &translated);
>> +               }
>>
>> -               ret = copy_from_iter(dst, translated, &iter);
>>                 if (ret < 0)
>>                         return ret;
>>
>> @@ -1180,22 +1297,17 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
>>         u64 total_translated = 0;
>>
>>         while (total_translated < len) {
>> -               struct bio_vec iov[16];
>> -               struct iov_iter iter;
>>                 u64 translated;
>>                 int ret;
>>
>> -               ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
>> -                                     len - total_translated, &translated,
>> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_WO);
>> -               if (ret == -ENOBUFS)
>> -                       ret = ARRAY_SIZE(iov);
>> -               else if (ret < 0)
>> -                       return ret;
>> -
>> -               iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
>> +               if (vrh->use_va) {
>> +                       ret = copy_to_va(vrh, dst, src,
>> +                                        len - total_translated, &translated);
>> +               } else {
>> +                       ret = copy_to_pa(vrh, dst, src,
>> +                                        len - total_translated, &translated);
>> +               }
>>
>> -               ret = copy_to_iter(src, translated, &iter);
>>                 if (ret < 0)
>>                         return ret;
>>
>> @@ -1210,20 +1322,37 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
>>  static inline int getu16_iotlb(const struct vringh *vrh,
>>                                u16 *val, const __virtio16 *p)
>>  {
>> -       struct bio_vec iov;
>> -       void *kaddr, *from;
>>         int ret;
>>
>>         /* Atomic read is needed for getu16 */
>> -       ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
>> -                             &iov, 1, VHOST_MAP_RO);
>> -       if (ret < 0)
>> -               return ret;
>> +       if (vrh->use_va) {
>> +               struct iovec iov;
>> +               __virtio16 tmp;
>> +
>> +               ret = iotlb_translate_va(vrh, (u64)(uintptr_t)p, sizeof(*p),
>> +                                        NULL, &iov, 1, VHOST_MAP_RO);
>> +               if (ret < 0)
>> +                       return ret;
>
>Nit: since we have copy_to_va/copy_to_pa variants, let's introduce
>getu16_iotlb_va/pa variants?

Yep!

>
>>
>> -       kaddr = kmap_local_page(iov.bv_page);
>> -       from = kaddr + iov.bv_offset;
>> -       *val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
>> -       kunmap_local(kaddr);
>> +               ret = __get_user(tmp, (__virtio16 __user *)iov.iov_base);
>> +               if (ret)
>> +                       return ret;
>> +
>> +               *val = vringh16_to_cpu(vrh, tmp);
>> +       } else {
>> +               struct bio_vec iov;
>> +               void *kaddr, *from;
>> +
>> +               ret = iotlb_translate_pa(vrh, (u64)(uintptr_t)p, sizeof(*p),
>> +                                        NULL, &iov, 1, VHOST_MAP_RO);
>> +               if (ret < 0)
>> +                       return ret;
>> +
>> +               kaddr = kmap_local_page(iov.bv_page);
>
>If we decide to have a use_va switch, is kmap_local_page() still required here?
>

I think yes. This is related to the email where Fabio clarified for us,
right?

>Other looks good.

Thanks,
Stefano

