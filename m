Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5D46C5D51
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjCWDhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjCWDhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:37:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614C772B9
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679542603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYWL/gT2cHjHsxDtXChuzSZbhQ4WI0HpSX8QiGBjdWk=;
        b=aDo8t37I5aTw/9aQhMu6+i7CCnErMmYyVTF0XUcQa2xrIQ+VHYKA+72V9HBCOVAK9lFSfx
        ZDy6oQ8i9SttJUTWiOpb1KY6Co5vTWqIznDB7QxBYMbUfZ2KKTkr08OQRnrcgI9o903FwK
        4o1UoYtC9ZnkrPbnWfTyWPTO854cweI=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-eg0NqRHxOzGbTeSB_94Gyg-1; Wed, 22 Mar 2023 23:36:42 -0400
X-MC-Unique: eg0NqRHxOzGbTeSB_94Gyg-1
Received: by mail-oo1-f70.google.com with SMTP id c83-20020a4a4f56000000b0053b4b212346so3371240oob.10
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:36:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679542600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DYWL/gT2cHjHsxDtXChuzSZbhQ4WI0HpSX8QiGBjdWk=;
        b=0obBIi3H2M37CCj9UMDzFdPdrlnkb8EOcQ0uFF7QynplDGBkoyf/19NTnfpkFlx6el
         eTel4xOL2Q7JV+boaCxZRnALaN3SqgaJm2K19+b3NEBcZI7f2/u9I7JCkMILUNq1x5ed
         PtutckmwsdWazUiPk54TXkyrgi83swu20qoQEmEVKsq8F6k0HYBvs8TkfOW5t5/pBPWR
         1T2dxtLmwrsyRKIMOmWzoI01SNA86qZZZyzSpOJ4J1XYjcj/rn8NFKvkxZDYQSxgTSji
         bXt5OHPEEB9qHi8oSvw7iIiftqPkzSM/xc1MUD5JG9c7IIA/3nhbB6gFiExS5TeBw8JZ
         sVEg==
X-Gm-Message-State: AAQBX9eCtYaxpB1kuDth20LWujSx2a/rVaVrKAHnbD5/IPOQKLrDCDoe
        c5AXZJQ+aUqPO77nfqXmieg1kCSh+v7SL8sxvl7u+QX9VKnLAxw4ENse4eMUUUmuiaUh6uAEaYm
        33cH7jESEjI5ezQ34RutenIiBAByDHM13
X-Received: by 2002:a05:6871:6c97:b0:17e:7674:8df0 with SMTP id zj23-20020a0568716c9700b0017e76748df0mr651036oab.9.1679542600549;
        Wed, 22 Mar 2023 20:36:40 -0700 (PDT)
X-Google-Smtp-Source: AK7set9aTQ5oDLn0xB1QcdTM8TBhuwxleMPdT5m0AWpwVQHYGY0hcMC2Ce9UPuXDZHCAuSVkI4e12QEot/hncqsMqGU=
X-Received: by 2002:a05:6871:6c97:b0:17e:7674:8df0 with SMTP id
 zj23-20020a0568716c9700b0017e76748df0mr651023oab.9.1679542600062; Wed, 22 Mar
 2023 20:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154228.182769-1-sgarzare@redhat.com> <20230321154228.182769-5-sgarzare@redhat.com>
In-Reply-To: <20230321154228.182769-5-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 11:36:28 +0800
Message-ID: <CACGkMEs3G+O3Jo7yNPSOZ9wiEbq_nudU9HrVNzhqtkGoRVesYA@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] vringh: support VA with iotlb
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Mar 21, 2023 at 11:43=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> vDPA supports the possibility to use user VA in the iotlb messages.
> So, let's add support for user VA in vringh to use it in the vDPA
> simulators.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v3:
>     - refactored avoiding code duplication [Eugenio]
>     v2:
>     - replace kmap_atomic() with kmap_local_page() [see previous patch]
>     - fix cast warnings when build with W=3D1 C=3D1
>
>  include/linux/vringh.h            |   5 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
>  drivers/vhost/vringh.c            | 153 +++++++++++++++++++++++-------
>  4 files changed, 127 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 1991a02c6431..d39b9f2dcba0 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -32,6 +32,9 @@ struct vringh {
>         /* Can we get away with weak barriers? */
>         bool weak_barriers;
>
> +       /* Use user's VA */
> +       bool use_va;
> +
>         /* Last available index we saw (ie. where we're up to). */
>         u16 last_avail_idx;
>
> @@ -279,7 +282,7 @@ void vringh_set_iotlb(struct vringh *vrh, struct vhos=
t_iotlb *iotlb,
>                       spinlock_t *iotlb_lock);
>
>  int vringh_init_iotlb(struct vringh *vrh, u64 features,
> -                     unsigned int num, bool weak_barriers,
> +                     unsigned int num, bool weak_barriers, bool use_va,
>                       struct vring_desc *desc,
>                       struct vring_avail *avail,
>                       struct vring_used *used);
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 520646ae7fa0..dfd0e000217b 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2537,7 +2537,7 @@ static int setup_cvq_vring(struct mlx5_vdpa_dev *mv=
dev)
>
>         if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
>                 err =3D vringh_init_iotlb(&cvq->vring, mvdev->actual_feat=
ures,
> -                                       MLX5_CVQ_MAX_ENT, false,
> +                                       MLX5_CVQ_MAX_ENT, false, false,

To avoid those changes, would it be better to introduce
vringh_init_iotlb_va() so vringh_init_iotlb() can stick to pa.

>                                         (struct vring_desc *)(uintptr_t)c=
vq->desc_addr,
>                                         (struct vring_avail *)(uintptr_t)=
cvq->driver_addr,
>                                         (struct vring_used *)(uintptr_t)c=
vq->device_addr);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index eea23c630f7c..47cdf2a1f5b8 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -60,7 +60,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim=
, unsigned int idx)
>         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
>         uint16_t last_avail_idx =3D vq->vring.last_avail_idx;
>
> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, f=
alse,
>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>                           (struct vring_avail *)
>                           (uintptr_t)vq->driver_addr,
> @@ -92,7 +92,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim,
>         vq->cb =3D NULL;
>         vq->private =3D NULL;
>         vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_feature=
s,
> -                         VDPASIM_QUEUE_MAX, false, NULL, NULL, NULL);
> +                         VDPASIM_QUEUE_MAX, false, false, NULL, NULL, NU=
LL);
>
>         vq->vring.notify =3D NULL;
>  }
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 0ba3ef809e48..72c88519329a 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1094,10 +1094,18 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>
>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>
> +struct iotlb_vec {
> +       union {
> +               struct iovec *iovec;
> +               struct bio_vec *bvec;
> +       } iov;
> +       size_t count;
> +       bool is_iovec;

I wonder if this is needed (if vringh is passed to every iotlb_vec helper).

> +};
> +
>  static int iotlb_translate(const struct vringh *vrh,
>                            u64 addr, u64 len, u64 *translated,
> -                          struct bio_vec iov[],
> -                          int iov_size, u32 perm)
> +                          struct iotlb_vec *ivec, u32 perm)
>  {
>         struct vhost_iotlb_map *map;
>         struct vhost_iotlb *iotlb =3D vrh->iotlb;
> @@ -1107,9 +1115,9 @@ static int iotlb_translate(const struct vringh *vrh=
,
>         spin_lock(vrh->iotlb_lock);
>
>         while (len > s) {
> -               u64 size, pa, pfn;
> +               u64 size;
>
> -               if (unlikely(ret >=3D iov_size)) {
> +               if (unlikely(ret >=3D ivec->count)) {
>                         ret =3D -ENOBUFS;
>                         break;
>                 }
> @@ -1124,10 +1132,22 @@ static int iotlb_translate(const struct vringh *v=
rh,
>                 }
>
>                 size =3D map->size - addr + map->start;
> -               pa =3D map->addr + addr - map->start;
> -               pfn =3D pa >> PAGE_SHIFT;
> -               bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, s=
ize),
> -                             pa & (PAGE_SIZE - 1));
> +               if (ivec->is_iovec) {
> +                       struct iovec *iovec =3D ivec->iov.iovec;
> +
> +                       iovec[ret].iov_len =3D min(len - s, size);
> +                       iovec[ret].iov_base =3D (void __user *)(unsigned =
long)
> +                                             (map->addr + addr - map->st=
art);

map->addr - map->start to avoid overflow?

> +               } else {
> +                       u64 pa =3D map->addr + addr - map->start;
> +                       u64 pfn =3D pa >> PAGE_SHIFT;
> +                       struct bio_vec *bvec =3D ivec->iov.bvec;
> +
> +                       bvec_set_page(&bvec[ret], pfn_to_page(pfn),
> +                                     min(len - s, size),
> +                                     pa & (PAGE_SIZE - 1));
> +               }
> +
>                 s +=3D size;
>                 addr +=3D size;
>                 ++ret;
> @@ -1141,26 +1161,42 @@ static int iotlb_translate(const struct vringh *v=
rh,
>         return ret;
>  }
>
> +#define IOTLB_IOV_SIZE 16
> +
>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>                                   void *src, size_t len)
>  {
> +       struct iotlb_vec ivec;
> +       union {
> +               struct iovec iovec[IOTLB_IOV_SIZE];
> +               struct bio_vec bvec[IOTLB_IOV_SIZE];
> +       } iov;
>         u64 total_translated =3D 0;
>
> +       ivec.iov.iovec =3D iov.iovec;

ivc.iov =3D iov ?

Others look good.

Thanks

> +       ivec.count =3D IOTLB_IOV_SIZE;
> +       ivec.is_iovec =3D vrh->use_va;
> +
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
>                 ret =3D iotlb_translate(vrh, (u64)(uintptr_t)src,
>                                       len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_RO)=
;
> +                                     &ivec, VHOST_MAP_RO);
>                 if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> +                       ret =3D IOTLB_IOV_SIZE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
> +               if (ivec.is_iovec) {
> +                       iov_iter_init(&iter, ITER_SOURCE, ivec.iov.iovec,=
 ret,
> +                                     translated);
> +               } else {
> +                       iov_iter_bvec(&iter, ITER_SOURCE, ivec.iov.bvec, =
ret,
> +                                     translated);
> +               }
>
>                 ret =3D copy_from_iter(dst, translated, &iter);
>                 if (ret < 0)
> @@ -1177,23 +1213,37 @@ static inline int copy_from_iotlb(const struct vr=
ingh *vrh, void *dst,
>  static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
>                                 void *src, size_t len)
>  {
> +       struct iotlb_vec ivec;
> +       union {
> +               struct iovec iovec[IOTLB_IOV_SIZE];
> +               struct bio_vec bvec[IOTLB_IOV_SIZE];
> +       } iov;
>         u64 total_translated =3D 0;
>
> +       ivec.iov.iovec =3D iov.iovec;
> +       ivec.count =3D IOTLB_IOV_SIZE;
> +       ivec.is_iovec =3D vrh->use_va;
> +
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
>                 ret =3D iotlb_translate(vrh, (u64)(uintptr_t)dst,
>                                       len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_WO)=
;
> +                                     &ivec, VHOST_MAP_WO);
>                 if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> +                       ret =3D IOTLB_IOV_SIZE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
> +               if (ivec.is_iovec) {
> +                       iov_iter_init(&iter, ITER_DEST, ivec.iov.iovec, r=
et,
> +                                     translated);
> +               } else {
> +                       iov_iter_bvec(&iter, ITER_DEST, ivec.iov.bvec, re=
t,
> +                                     translated);
> +               }
>
>                 ret =3D copy_to_iter(src, translated, &iter);
>                 if (ret < 0)
> @@ -1210,20 +1260,37 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>  static inline int getu16_iotlb(const struct vringh *vrh,
>                                u16 *val, const __virtio16 *p)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *from;
> +       struct iotlb_vec ivec;
> +       union {
> +               struct iovec iovec[1];
> +               struct bio_vec bvec[1];
> +       } iov;
> +       __virtio16 tmp;
>         int ret;
>
> +       ivec.iov.iovec =3D iov.iovec;
> +       ivec.count =3D 1;
> +       ivec.is_iovec =3D vrh->use_va;
> +
>         /* Atomic read is needed for getu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_RO);
> +       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
> +                             NULL, &ivec, VHOST_MAP_RO);
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       from =3D kaddr + iov.bv_offset;
> -       *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_local(kaddr);
> +       if (ivec.is_iovec) {
> +               ret =3D __get_user(tmp, (__virtio16 __user *)ivec.iov.iov=
ec[0].iov_base);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               void *kaddr =3D kmap_local_page(ivec.iov.bvec[0].bv_page)=
;
> +               void *from =3D kaddr + ivec.iov.bvec[0].bv_offset;
> +
> +               tmp =3D READ_ONCE(*(__virtio16 *)from);
> +               kunmap_local(kaddr);
> +       }
> +
> +       *val =3D vringh16_to_cpu(vrh, tmp);
>
>         return 0;
>  }
> @@ -1231,20 +1298,37 @@ static inline int getu16_iotlb(const struct vring=
h *vrh,
>  static inline int putu16_iotlb(const struct vringh *vrh,
>                                __virtio16 *p, u16 val)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *to;
> +       struct iotlb_vec ivec;
> +       union {
> +               struct iovec iovec;
> +               struct bio_vec bvec;
> +       } iov;
> +       __virtio16 tmp;
>         int ret;
>
> +       ivec.iov.iovec =3D &iov.iovec;
> +       ivec.count =3D 1;
> +       ivec.is_iovec =3D vrh->use_va;
> +
>         /* Atomic write is needed for putu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_WO);
> +       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
> +                             NULL, &ivec, VHOST_MAP_RO);
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       to =3D kaddr + iov.bv_offset;
> -       WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -       kunmap_local(kaddr);
> +       tmp =3D cpu_to_vringh16(vrh, val);
> +
> +       if (ivec.is_iovec) {
> +               ret =3D __put_user(tmp, (__virtio16 __user *)ivec.iov.iov=
ec[0].iov_base);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               void *kaddr =3D kmap_local_page(ivec.iov.bvec[0].bv_page)=
;
> +               void *to =3D kaddr + ivec.iov.bvec[0].bv_offset;
> +
> +               WRITE_ONCE(*(__virtio16 *)to, tmp);
> +               kunmap_local(kaddr);
> +       }
>
>         return 0;
>  }
> @@ -1306,6 +1390,7 @@ static inline int putused_iotlb(const struct vringh=
 *vrh,
>   * @features: the feature bits for this ring.
>   * @num: the number of elements.
>   * @weak_barriers: true if we only need memory barriers, not I/O.
> + * @use_va: true if IOTLB contains user VA
>   * @desc: the userpace descriptor pointer.
>   * @avail: the userpace avail pointer.
>   * @used: the userpace used pointer.
> @@ -1313,11 +1398,13 @@ static inline int putused_iotlb(const struct vrin=
gh *vrh,
>   * Returns an error if num is invalid.
>   */
>  int vringh_init_iotlb(struct vringh *vrh, u64 features,
> -                     unsigned int num, bool weak_barriers,
> +                     unsigned int num, bool weak_barriers, bool use_va,
>                       struct vring_desc *desc,
>                       struct vring_avail *avail,
>                       struct vring_used *used)
>  {
> +       vrh->use_va =3D use_va;
> +
>         return vringh_init_kern(vrh, features, num, weak_barriers,
>                                 desc, avail, used);
>  }
> --
> 2.39.2
>

