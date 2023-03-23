Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6056C6B60
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjCWOpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjCWOpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:45:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E4C23A65
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 07:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679582652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrVA7uU+nRMqFw4cOUV9tVLaScyoHsXz3KJEw/B4yIU=;
        b=iykAq50kKmPFl06b9WG734W/TkQf4eIEAI145ViXa4gtD9RCQ7IlXwleULZ9YE1I2qmUp9
        GBiLxMZ/NCJy76nVFkz6n4DPf/3FJWmFqp/DLKGVX7+pO2z8HatkVeHXH7ddnC6nBmBPyj
        xTqxg0cfd8FQYmDKzupI7Ur+AWG+MNA=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-WEitqCQWNbGkC2lVdXGkxQ-1; Thu, 23 Mar 2023 10:44:11 -0400
X-MC-Unique: WEitqCQWNbGkC2lVdXGkxQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-541888850d4so224933737b3.21
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 07:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679582650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NrVA7uU+nRMqFw4cOUV9tVLaScyoHsXz3KJEw/B4yIU=;
        b=bcD+Tpk65WSmp1domV0urx/C4mvoehiC7RJpchJqakNkqaEpUp3yFNXivfsbXaQh6o
         tdMA+7HTOohKyGnhtsz5JXIPQ1ay9HCqzz+Gof0CVtUGuWDeg5ZbQQKrFmc1behB4BaL
         RS1l27NXWWR1lblhk1T75hhmQ8la9BnYf5hFvx3wXaehhadhlRrtsk4zlw0Iu/AhnOi4
         BRARsSxBJp9Rk3N814Gzx4wTL1CHUzV+X56f3otctH8UavvlTGRsH09ENSyetHD8BxgR
         y9JM2jfBI4vP6m3kMa4YOoaXarzbeUO0Edu8Yw1Zq4qOCN9xcCKH+jIZyV1MrPH9+N7Q
         71AQ==
X-Gm-Message-State: AAQBX9eTm5DCrQSn2Q2/VPnKNi2XZW6k1dep2OuWaf5o30UiiQb7vY99
        0TdxA3eNe086b9j1YPmhG0806kJyAhqOiyPrtZXiXhvHg+BpVPTw5ueQ1pGA8yjGgVXn6+CHeX0
        dnaz528bAhBgd2uHdNS4czJ5Kpbo0xiH5
X-Received: by 2002:a25:b001:0:b0:b70:ad30:dacc with SMTP id q1-20020a25b001000000b00b70ad30daccmr1906302ybf.2.1679582650465;
        Thu, 23 Mar 2023 07:44:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yp90qJTyafDDZI8Zx6KKeaVqtRTbdnVnhZPzCnb/pi2s126PXUI5QEyJvtGxI/gRHywVjAEr2ZJillufAyOvY=
X-Received: by 2002:a25:b001:0:b0:b70:ad30:dacc with SMTP id
 q1-20020a25b001000000b00b70ad30daccmr1906287ybf.2.1679582650156; Thu, 23 Mar
 2023 07:44:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154228.182769-1-sgarzare@redhat.com> <20230321154228.182769-5-sgarzare@redhat.com>
 <CAJaqyWcCwwu1UJ968A=s30GCezjLcwWKDhCFMsQ2EcGGgkiz7g@mail.gmail.com> <20230323104638.67hbwwbk7ayp4psq@sgarzare-redhat>
In-Reply-To: <20230323104638.67hbwwbk7ayp4psq@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 23 Mar 2023 15:43:34 +0100
Message-ID: <CAJaqyWfSor5PKZn0iAOthCkeGDBc7+rjVXuSHMy1LWY+fV5o7A@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] vringh: support VA with iotlb
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:46=E2=80=AFAM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> On Thu, Mar 23, 2023 at 09:09:14AM +0100, Eugenio Perez Martin wrote:
> >On Tue, Mar 21, 2023 at 4:43=E2=80=AFPM Stefano Garzarella <sgarzare@red=
hat.com> wrote:
> >>
> >> vDPA supports the possibility to use user VA in the iotlb messages.
> >> So, let's add support for user VA in vringh to use it in the vDPA
> >> simulators.
> >>
> >> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> ---
> >>
> >> Notes:
> >>     v3:
> >>     - refactored avoiding code duplication [Eugenio]
> >>     v2:
> >>     - replace kmap_atomic() with kmap_local_page() [see previous patch=
]
> >>     - fix cast warnings when build with W=3D1 C=3D1
> >>
> >>  include/linux/vringh.h            |   5 +-
> >>  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
> >>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
> >>  drivers/vhost/vringh.c            | 153 +++++++++++++++++++++++------=
-
> >>  4 files changed, 127 insertions(+), 37 deletions(-)
> >>
> >> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> >> index 1991a02c6431..d39b9f2dcba0 100644
> >> --- a/include/linux/vringh.h
> >> +++ b/include/linux/vringh.h
> >> @@ -32,6 +32,9 @@ struct vringh {
> >>         /* Can we get away with weak barriers? */
> >>         bool weak_barriers;
> >>
> >> +       /* Use user's VA */
> >> +       bool use_va;
> >> +
> >>         /* Last available index we saw (ie. where we're up to). */
> >>         u16 last_avail_idx;
> >>
> >> @@ -279,7 +282,7 @@ void vringh_set_iotlb(struct vringh *vrh, struct v=
host_iotlb *iotlb,
> >>                       spinlock_t *iotlb_lock);
> >>
> >>  int vringh_init_iotlb(struct vringh *vrh, u64 features,
> >> -                     unsigned int num, bool weak_barriers,
> >> +                     unsigned int num, bool weak_barriers, bool use_v=
a,
> >>                       struct vring_desc *desc,
> >>                       struct vring_avail *avail,
> >>                       struct vring_used *used);
> >> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net=
/mlx5_vnet.c
> >> index 520646ae7fa0..dfd0e000217b 100644
> >> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> >> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> >> @@ -2537,7 +2537,7 @@ static int setup_cvq_vring(struct mlx5_vdpa_dev =
*mvdev)
> >>
> >>         if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
> >>                 err =3D vringh_init_iotlb(&cvq->vring, mvdev->actual_f=
eatures,
> >> -                                       MLX5_CVQ_MAX_ENT, false,
> >> +                                       MLX5_CVQ_MAX_ENT, false, false=
,
> >>                                         (struct vring_desc *)(uintptr_=
t)cvq->desc_addr,
> >>                                         (struct vring_avail *)(uintptr=
_t)cvq->driver_addr,
> >>                                         (struct vring_used *)(uintptr_=
t)cvq->device_addr);
> >> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/=
vdpa_sim.c
> >> index eea23c630f7c..47cdf2a1f5b8 100644
> >> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >> @@ -60,7 +60,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpa=
sim, unsigned int idx)
> >>         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
> >>         uint16_t last_avail_idx =3D vq->vring.last_avail_idx;
> >>
> >> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true=
,
> >> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true=
, false,
> >>                           (struct vring_desc *)(uintptr_t)vq->desc_add=
r,
> >>                           (struct vring_avail *)
> >>                           (uintptr_t)vq->driver_addr,
> >> @@ -92,7 +92,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim=
,
> >>         vq->cb =3D NULL;
> >>         vq->private =3D NULL;
> >>         vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_feat=
ures,
> >> -                         VDPASIM_QUEUE_MAX, false, NULL, NULL, NULL);
> >> +                         VDPASIM_QUEUE_MAX, false, false, NULL, NULL,=
 NULL);
> >>
> >>         vq->vring.notify =3D NULL;
> >>  }
> >> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> >> index 0ba3ef809e48..72c88519329a 100644
> >> --- a/drivers/vhost/vringh.c
> >> +++ b/drivers/vhost/vringh.c
> >> @@ -1094,10 +1094,18 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
> >>
> >>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
> >>
> >> +struct iotlb_vec {
> >> +       union {
> >> +               struct iovec *iovec;
> >> +               struct bio_vec *bvec;
> >> +       } iov;
> >> +       size_t count;
> >> +       bool is_iovec;
> >> +};
> >> +
> >>  static int iotlb_translate(const struct vringh *vrh,
> >>                            u64 addr, u64 len, u64 *translated,
> >> -                          struct bio_vec iov[],
> >> -                          int iov_size, u32 perm)
> >> +                          struct iotlb_vec *ivec, u32 perm)
> >>  {
> >>         struct vhost_iotlb_map *map;
> >>         struct vhost_iotlb *iotlb =3D vrh->iotlb;
> >> @@ -1107,9 +1115,9 @@ static int iotlb_translate(const struct vringh *=
vrh,
> >>         spin_lock(vrh->iotlb_lock);
> >>
> >>         while (len > s) {
> >> -               u64 size, pa, pfn;
> >> +               u64 size;
> >>
> >> -               if (unlikely(ret >=3D iov_size)) {
> >> +               if (unlikely(ret >=3D ivec->count)) {
> >>                         ret =3D -ENOBUFS;
> >>                         break;
> >>                 }
> >> @@ -1124,10 +1132,22 @@ static int iotlb_translate(const struct vringh=
 *vrh,
> >>                 }
> >>
> >>                 size =3D map->size - addr + map->start;
> >> -               pa =3D map->addr + addr - map->start;
> >> -               pfn =3D pa >> PAGE_SHIFT;
> >> -               bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s=
, size),
> >> -                             pa & (PAGE_SIZE - 1));
> >> +               if (ivec->is_iovec) {
> >> +                       struct iovec *iovec =3D ivec->iov.iovec;
> >> +
> >> +                       iovec[ret].iov_len =3D min(len - s, size);
> >> +                       iovec[ret].iov_base =3D (void __user *)(unsign=
ed long)
> >
> >s/unsigned long/uintptr_t ?
> >
>
> yep, good catch!
>
> As I wrote to Jason, I think I'll take it out of the if and just declare
> an uintptr_t variable, since I'm using it also in the else branch.
>
> >
> >
> >> +                                             (map->addr + addr - map-=
>start);
> >> +               } else {
> >> +                       u64 pa =3D map->addr + addr - map->start;
> >> +                       u64 pfn =3D pa >> PAGE_SHIFT;
> >> +                       struct bio_vec *bvec =3D ivec->iov.bvec;
> >> +
> >> +                       bvec_set_page(&bvec[ret], pfn_to_page(pfn),
> >> +                                     min(len - s, size),
> >> +                                     pa & (PAGE_SIZE - 1));
> >> +               }
> >> +
> >>                 s +=3D size;
> >>                 addr +=3D size;
> >>                 ++ret;
> >> @@ -1141,26 +1161,42 @@ static int iotlb_translate(const struct vringh=
 *vrh,
> >>         return ret;
> >>  }
> >>
> >> +#define IOTLB_IOV_SIZE 16
> >
> >I'm fine with defining here, but maybe it is better to isolate the
> >change in a previous patch or reuse another well known macro?
>
> Yep, good point!
>
> Do you have any well known macro to suggest?
>

Not really, 16 seems like a convenience value here actually :). Maybe
replace _SIZE with _STRIDE or similar?

I keep the Acked-by even if the final name is IOTLB_IOV_SIZE though.

Thanks!

