Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D603B6C8016
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjCXOkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjCXOkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:40:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE85173A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 07:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679668796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMmYpV/LQ/c9lboloM+FB9+ISpjrbEj6iQBO9Iln0u8=;
        b=TMmv+pUynGECVILW0ZwRqCJ3jlbTWjhDxfDSOAaz9Rf8cQefyXaQNOLpwBALbe88oVDXHe
        y1bBcUiAIXIKP0eiTfsjMJ4U9lnkNDquVRQNxZ9Fh0Imqt/O6RnpjHdjczv3Ziq/CipT0y
        HkgL34OQVNneyz+1eKQAnVAVQCQqcXc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-7erIVuC0OcyajROgqEOPKw-1; Fri, 24 Mar 2023 10:39:55 -0400
X-MC-Unique: 7erIVuC0OcyajROgqEOPKw-1
Received: by mail-ed1-f69.google.com with SMTP id r19-20020a50aad3000000b005002e950cd3so3546519edc.11
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 07:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679668793;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TMmYpV/LQ/c9lboloM+FB9+ISpjrbEj6iQBO9Iln0u8=;
        b=feAdJkmgaIBjWnqmpqelddLLHegDgyAxPF0GPXm4d/1zbdjovDNWfl06BROk/c89kw
         GPxX+NyCpRGJkvn3YxHR0oJCBlD1YUexULYFN+uFBedc/LFDDthcEa8mhabQu2wxvwe6
         pxmUBjxj1amkvsQ0dz4w43YJrb3wJVbfOUQxSf6y0qV8BKVeqSdqaihFeBD39K/WXbUO
         aEMyiFvhOqgVUuRvvSyYt0sIvHHBagDSfRoBxOqv24uTBxl352QJwlqys8E5WH+rtzFj
         3IWs0UcRK/4k8mtoJpH3QW9zykT1R2Kc4FnEX6OYTLZkDcyER+RVNm+PBKlBm3TCyyTt
         iM3A==
X-Gm-Message-State: AAQBX9fQ8d6PDxOg7NeuBFiIUJffgj/vkD2zBzxbN5VwVb7zsryWGZL7
        9LfsIpCjILlXi9kp9nzrGETsi6xdc7z1esrr5VozzHimzNEgENWQ059Fn7KLrmFsJc30+bieevY
        eK43R/jFghh40IbIWNi29C3ss
X-Received: by 2002:a17:906:e112:b0:933:1b05:8851 with SMTP id gj18-20020a170906e11200b009331b058851mr2845607ejb.16.1679668793612;
        Fri, 24 Mar 2023 07:39:53 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y4yRoRccUD6nI6QABMFjTLkWl/XWytdR65GGNlDWyNT8S11dQr5KKX4NxzjLSJru2A56ABJA==
X-Received: by 2002:a17:906:e112:b0:933:1b05:8851 with SMTP id gj18-20020a170906e11200b009331b058851mr2845585ejb.16.1679668793333;
        Fri, 24 Mar 2023 07:39:53 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090630c400b0092b5384d6desm10339713ejb.153.2023.03.24.07.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 07:39:52 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:39:50 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/8] vringh: support VA with iotlb
Message-ID: <xjhkyuurmxoispl2ndpeq4w3zsivq56lq4siw3cv3k5ucf7i43@e2ydqxiyxglc>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154228.182769-5-sgarzare@redhat.com>
 <CAJaqyWcCwwu1UJ968A=s30GCezjLcwWKDhCFMsQ2EcGGgkiz7g@mail.gmail.com>
 <20230323104638.67hbwwbk7ayp4psq@sgarzare-redhat>
 <CAJaqyWfSor5PKZn0iAOthCkeGDBc7+rjVXuSHMy1LWY+fV5o7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWfSor5PKZn0iAOthCkeGDBc7+rjVXuSHMy1LWY+fV5o7A@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 03:43:34PM +0100, Eugenio Perez Martin wrote:
>On Thu, Mar 23, 2023 at 11:46 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Thu, Mar 23, 2023 at 09:09:14AM +0100, Eugenio Perez Martin wrote:
>> >On Tue, Mar 21, 2023 at 4:43 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >>
>> >> vDPA supports the possibility to use user VA in the iotlb messages.
>> >> So, let's add support for user VA in vringh to use it in the vDPA
>> >> simulators.
>> >>
>> >> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> >> ---
>> >>
>> >> Notes:
>> >>     v3:
>> >>     - refactored avoiding code duplication [Eugenio]
>> >>     v2:
>> >>     - replace kmap_atomic() with kmap_local_page() [see previous patch]
>> >>     - fix cast warnings when build with W=1 C=1
>> >>
>> >>  include/linux/vringh.h            |   5 +-
>> >>  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
>> >>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
>> >>  drivers/vhost/vringh.c            | 153 +++++++++++++++++++++++-------
>> >>  4 files changed, 127 insertions(+), 37 deletions(-)
>> >>
>> >> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
>> >> index 1991a02c6431..d39b9f2dcba0 100644
>> >> --- a/include/linux/vringh.h
>> >> +++ b/include/linux/vringh.h
>> >> @@ -32,6 +32,9 @@ struct vringh {
>> >>         /* Can we get away with weak barriers? */
>> >>         bool weak_barriers;
>> >>
>> >> +       /* Use user's VA */
>> >> +       bool use_va;
>> >> +
>> >>         /* Last available index we saw (ie. where we're up to). */
>> >>         u16 last_avail_idx;
>> >>
>> >> @@ -279,7 +282,7 @@ void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb,
>> >>                       spinlock_t *iotlb_lock);
>> >>
>> >>  int vringh_init_iotlb(struct vringh *vrh, u64 features,
>> >> -                     unsigned int num, bool weak_barriers,
>> >> +                     unsigned int num, bool weak_barriers, bool use_va,
>> >>                       struct vring_desc *desc,
>> >>                       struct vring_avail *avail,
>> >>                       struct vring_used *used);
>> >> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> >> index 520646ae7fa0..dfd0e000217b 100644
>> >> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> >> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> >> @@ -2537,7 +2537,7 @@ static int setup_cvq_vring(struct mlx5_vdpa_dev *mvdev)
>> >>
>> >>         if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
>> >>                 err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
>> >> -                                       MLX5_CVQ_MAX_ENT, false,
>> >> +                                       MLX5_CVQ_MAX_ENT, false, false,
>> >>                                         (struct vring_desc *)(uintptr_t)cvq->desc_addr,
>> >>                                         (struct vring_avail *)(uintptr_t)cvq->driver_addr,
>> >>                                         (struct vring_used *)(uintptr_t)cvq->device_addr);
>> >> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> >> index eea23c630f7c..47cdf2a1f5b8 100644
>> >> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> >> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> >> @@ -60,7 +60,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
>> >>         struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>> >>         uint16_t last_avail_idx = vq->vring.last_avail_idx;
>> >>
>> >> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
>> >> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, false,
>> >>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>> >>                           (struct vring_avail *)
>> >>                           (uintptr_t)vq->driver_addr,
>> >> @@ -92,7 +92,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim,
>> >>         vq->cb = NULL;
>> >>         vq->private = NULL;
>> >>         vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_features,
>> >> -                         VDPASIM_QUEUE_MAX, false, NULL, NULL, NULL);
>> >> +                         VDPASIM_QUEUE_MAX, false, false, NULL, NULL, NULL);
>> >>
>> >>         vq->vring.notify = NULL;
>> >>  }
>> >> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>> >> index 0ba3ef809e48..72c88519329a 100644
>> >> --- a/drivers/vhost/vringh.c
>> >> +++ b/drivers/vhost/vringh.c
>> >> @@ -1094,10 +1094,18 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>> >>
>> >>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>> >>
>> >> +struct iotlb_vec {
>> >> +       union {
>> >> +               struct iovec *iovec;
>> >> +               struct bio_vec *bvec;
>> >> +       } iov;
>> >> +       size_t count;
>> >> +       bool is_iovec;
>> >> +};
>> >> +
>> >>  static int iotlb_translate(const struct vringh *vrh,
>> >>                            u64 addr, u64 len, u64 *translated,
>> >> -                          struct bio_vec iov[],
>> >> -                          int iov_size, u32 perm)
>> >> +                          struct iotlb_vec *ivec, u32 perm)
>> >>  {
>> >>         struct vhost_iotlb_map *map;
>> >>         struct vhost_iotlb *iotlb = vrh->iotlb;
>> >> @@ -1107,9 +1115,9 @@ static int iotlb_translate(const struct vringh *vrh,
>> >>         spin_lock(vrh->iotlb_lock);
>> >>
>> >>         while (len > s) {
>> >> -               u64 size, pa, pfn;
>> >> +               u64 size;
>> >>
>> >> -               if (unlikely(ret >= iov_size)) {
>> >> +               if (unlikely(ret >= ivec->count)) {
>> >>                         ret = -ENOBUFS;
>> >>                         break;
>> >>                 }
>> >> @@ -1124,10 +1132,22 @@ static int iotlb_translate(const struct vringh *vrh,
>> >>                 }
>> >>
>> >>                 size = map->size - addr + map->start;
>> >> -               pa = map->addr + addr - map->start;
>> >> -               pfn = pa >> PAGE_SHIFT;
>> >> -               bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, size),
>> >> -                             pa & (PAGE_SIZE - 1));
>> >> +               if (ivec->is_iovec) {
>> >> +                       struct iovec *iovec = ivec->iov.iovec;
>> >> +
>> >> +                       iovec[ret].iov_len = min(len - s, size);
>> >> +                       iovec[ret].iov_base = (void __user *)(unsigned long)
>> >
>> >s/unsigned long/uintptr_t ?
>> >
>>
>> yep, good catch!
>>
>> As I wrote to Jason, I think I'll take it out of the if and just declare
>> an uintptr_t variable, since I'm using it also in the else branch.
>>
>> >
>> >
>> >> +                                             (map->addr + addr - map->start);
>> >> +               } else {
>> >> +                       u64 pa = map->addr + addr - map->start;
>> >> +                       u64 pfn = pa >> PAGE_SHIFT;
>> >> +                       struct bio_vec *bvec = ivec->iov.bvec;
>> >> +
>> >> +                       bvec_set_page(&bvec[ret], pfn_to_page(pfn),
>> >> +                                     min(len - s, size),
>> >> +                                     pa & (PAGE_SIZE - 1));
>> >> +               }
>> >> +
>> >>                 s += size;
>> >>                 addr += size;
>> >>                 ++ret;
>> >> @@ -1141,26 +1161,42 @@ static int iotlb_translate(const struct vringh *vrh,
>> >>         return ret;
>> >>  }
>> >>
>> >> +#define IOTLB_IOV_SIZE 16
>> >
>> >I'm fine with defining here, but maybe it is better to isolate the
>> >change in a previous patch or reuse another well known macro?
>>
>> Yep, good point!
>>
>> Do you have any well known macro to suggest?
>>
>
>Not really, 16 seems like a convenience value here actually :). Maybe
>replace _SIZE with _STRIDE or similar?

Ack, I will add IOTLB_IOV_STRIDE in a preparation patch before this
one.

>
>I keep the Acked-by even if the final name is IOTLB_IOV_SIZE though.

Thanks,
I changed a bit this patch following Jason's and your suggestions.

I'd like an explicit Acked-by on the next version if it is okay with 
you.

Thanks,
Stefano

