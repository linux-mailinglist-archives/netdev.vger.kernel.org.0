Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BF56A99B2
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 15:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCCOkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 09:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCCOk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 09:40:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A048D10439
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 06:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677854376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4GTysewRqQoKsnDtqdmn4Tnz7qNNotoxcaP+Ln9Jb3g=;
        b=TWO45/wzPrqQCWzLal0CbzrKq14ht0FH+IOZF7rVBrpYMSle2cVJQ0v2fYPqKpLv8h9GX/
        V6pydfMS3pJz/DhDRFPs1hbNGOw8t67SRyzUb6eFu+QQBcMGSlx58zUBj8p8EpApSrZYbt
        sExm/jHWSTTaR5ADNxydGXD55j4J6lM=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-6BZme_enMpezpECNmILjAA-1; Fri, 03 Mar 2023 09:39:35 -0500
X-MC-Unique: 6BZme_enMpezpECNmILjAA-1
Received: by mail-yb1-f200.google.com with SMTP id w192-20020a25dfc9000000b009fe14931caaso2565055ybg.7
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 06:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677854374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4GTysewRqQoKsnDtqdmn4Tnz7qNNotoxcaP+Ln9Jb3g=;
        b=huu+aGRgCho7KHt6mlBvuNsoPT+ZazR647gzY7Jh5Z9NOWiWnnR2uPBXSZUrmjX/ue
         vd3I1ro5oth3LZmO4LMROrgHDpa8Rt4iXIe0R+ZNe9p1WHuMKKU7nypBeq8841c9wav/
         1XhZwEEhVTdact6ikoZmJd/uJCbu9qrtV7/ZwUETUi37nZ9f2JOawsYwf3C480Ariq6P
         kzAxsY74ckpB/yraM05h+4D/fgk2Ojx2UHUJm0WSZvU7iwHnolqd54Vq43AhdIu4sSfx
         nSaweW7QiAONBcaSlN1cdK1fw/Jfjlvk6oXvhPJOetUlKlr6bIfblC4+W5onGioY1/Wp
         N5aA==
X-Gm-Message-State: AO0yUKUauozYP2enpOvvAaRofQtHdy5/IxZuZFZYTjb3HpHYV6f0Kict
        QoM+TR685wmyfS1Oatfg+8WszlVC+y1bJwE0hHlitWU9gnPSVry0AbuREkOK6hslztAYs2OotUr
        rAUQofNf8AKVbYRuF5vhRU4Hza/3XA7JA
X-Received: by 2002:a25:9c05:0:b0:a6f:b653:9f18 with SMTP id c5-20020a259c05000000b00a6fb6539f18mr961502ybo.2.1677854374511;
        Fri, 03 Mar 2023 06:39:34 -0800 (PST)
X-Google-Smtp-Source: AK7set8v8BMH/nNheHi26FoEQgI67NwvADf6o4wAKYCWDUoeC4ipL22TLsABIBpjuyz+fpPhBP02lFbsQKg5eFr9EPI=
X-Received: by 2002:a25:9c05:0:b0:a6f:b653:9f18 with SMTP id
 c5-20020a259c05000000b00a6fb6539f18mr961490ybo.2.1677854374116; Fri, 03 Mar
 2023 06:39:34 -0800 (PST)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-5-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-5-sgarzare@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 3 Mar 2023 15:38:57 +0100
Message-ID: <CAJaqyWdeEzKnYuX-c348vVg0PpUH4y-e1dSLhRvYem=MEDKE=Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] vringh: support VA with iotlb
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 2, 2023 at 12:35 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> vDPA supports the possibility to use user VA in the iotlb messages.
> So, let's add support for user VA in vringh to use it in the vDPA
> simulators.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v2:
>     - replace kmap_atomic() with kmap_local_page() [see previous patch]
>     - fix cast warnings when build with W=3D1 C=3D1
>
>  include/linux/vringh.h            |   5 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
>  drivers/vhost/vringh.c            | 247 ++++++++++++++++++++++++------
>  4 files changed, 205 insertions(+), 53 deletions(-)
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
> index 3a0e721aef05..babc8dd171a6 100644
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
>                                         (struct vring_desc *)(uintptr_t)c=
vq->desc_addr,
>                                         (struct vring_avail *)(uintptr_t)=
cvq->driver_addr,
>                                         (struct vring_used *)(uintptr_t)c=
vq->device_addr);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 6a0a65814626..481eb156658b 100644
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
> @@ -81,7 +81,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim,
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
> index 0ba3ef809e48..61c79cea44ca 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1094,15 +1094,99 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>
>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>
> -static int iotlb_translate(const struct vringh *vrh,
> -                          u64 addr, u64 len, u64 *translated,
> -                          struct bio_vec iov[],
> -                          int iov_size, u32 perm)
> +static int iotlb_translate_va(const struct vringh *vrh,
> +                             u64 addr, u64 len, u64 *translated,
> +                             struct iovec iov[],
> +                             int iov_size, u32 perm)
>  {
>         struct vhost_iotlb_map *map;
>         struct vhost_iotlb *iotlb =3D vrh->iotlb;
> +       u64 s =3D 0, last =3D addr + len - 1;
>         int ret =3D 0;
> +
> +       spin_lock(vrh->iotlb_lock);
> +
> +       while (len > s) {
> +               u64 size;
> +
> +               if (unlikely(ret >=3D iov_size)) {
> +                       ret =3D -ENOBUFS;
> +                       break;
> +               }
> +
> +               map =3D vhost_iotlb_itree_first(iotlb, addr, last);
> +               if (!map || map->start > addr) {
> +                       ret =3D -EINVAL;
> +                       break;
> +               } else if (!(map->perm & perm)) {
> +                       ret =3D -EPERM;
> +                       break;
> +               }
> +
> +               size =3D map->size - addr + map->start;
> +               iov[ret].iov_len =3D min(len - s, size);
> +               iov[ret].iov_base =3D (void __user *)(unsigned long)
> +                                   (map->addr + addr - map->start);
> +               s +=3D size;
> +               addr +=3D size;
> +               ++ret;
> +       }
> +
> +       spin_unlock(vrh->iotlb_lock);
> +
> +       if (translated)
> +               *translated =3D min(len, s);
> +
> +       return ret;
> +}

It seems to me iotlb_translate_va and iotlb_translate_pa are very
similar, their only difference is that the argument is that iov is
iovec instead of bio_vec. And how to fill it, obviously.

It would be great to merge both functions, only differing with a
conditional on vrh->use_va, or generics, or similar. Or, if following
the style of the rest of vringh code, to provide a callback to fill
iovec (although I like conditional more).

However I cannot think of an easy way to perform that without long
macros or type erasure.

> +
> +static inline int copy_from_va(const struct vringh *vrh, void *dst, void=
 *src,
> +                              u64 len, u64 *translated)
> +{
> +       struct iovec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)src, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_RO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_init(&iter, ITER_SOURCE, iov, ret, *translated);
> +
> +       return copy_from_iter(dst, *translated, &iter);

Maybe a good baby step for DRY is to return the iov_iter in
copy_from/to_va/pa here?

But I'm ok with this version too.

Acked-by: Eugenio P=C3=A9rez Martin <eperezma@redhat.com>

> +}
> +
> +static inline int copy_to_va(const struct vringh *vrh, void *dst, void *=
src,
> +                            u64 len, u64 *translated)
> +{
> +       struct iovec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)dst, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_WO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_init(&iter, ITER_DEST, iov, ret, *translated);
> +
> +       return copy_to_iter(src, *translated, &iter);
> +}
> +
> +static int iotlb_translate_pa(const struct vringh *vrh,
> +                             u64 addr, u64 len, u64 *translated,
> +                             struct bio_vec iov[],
> +                             int iov_size, u32 perm)
> +{
> +       struct vhost_iotlb_map *map;
> +       struct vhost_iotlb *iotlb =3D vrh->iotlb;
>         u64 s =3D 0, last =3D addr + len - 1;
> +       int ret =3D 0;
>
>         spin_lock(vrh->iotlb_lock);
>
> @@ -1141,28 +1225,61 @@ static int iotlb_translate(const struct vringh *v=
rh,
>         return ret;
>  }
>
> +static inline int copy_from_pa(const struct vringh *vrh, void *dst, void=
 *src,
> +                              u64 len, u64 *translated)
> +{
> +       struct bio_vec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)src, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_RO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, *translated);
> +
> +       return copy_from_iter(dst, *translated, &iter);
> +}
> +
> +static inline int copy_to_pa(const struct vringh *vrh, void *dst, void *=
src,
> +                            u64 len, u64 *translated)
> +{
> +       struct bio_vec iov[16];
> +       struct iov_iter iter;
> +       int ret;
> +
> +       ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)dst, len, transla=
ted, iov,
> +                                ARRAY_SIZE(iov), VHOST_MAP_WO);
> +       if (ret =3D=3D -ENOBUFS)
> +               ret =3D ARRAY_SIZE(iov);
> +       else if (ret < 0)
> +               return ret;
> +
> +       iov_iter_bvec(&iter, ITER_DEST, iov, ret, *translated);
> +
> +       return copy_to_iter(src, *translated, &iter);
> +}
> +
>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>                                   void *src, size_t len)
>  {
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> -               struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
> -               ret =3D iotlb_translate(vrh, (u64)(uintptr_t)src,
> -                                     len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_RO)=
;
> -               if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> -               else if (ret < 0)
> -                       return ret;
> -
> -               iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       ret =3D copy_from_va(vrh, dst, src,
> +                                          len - total_translated, &trans=
lated);
> +               } else {
> +                       ret =3D copy_from_pa(vrh, dst, src,
> +                                          len - total_translated, &trans=
lated);
> +               }
>
> -               ret =3D copy_from_iter(dst, translated, &iter);
>                 if (ret < 0)
>                         return ret;
>
> @@ -1180,22 +1297,17 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> -               struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
> -               ret =3D iotlb_translate(vrh, (u64)(uintptr_t)dst,
> -                                     len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_WO)=
;
> -               if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> -               else if (ret < 0)
> -                       return ret;
> -
> -               iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       ret =3D copy_to_va(vrh, dst, src,
> +                                        len - total_translated, &transla=
ted);
> +               } else {
> +                       ret =3D copy_to_pa(vrh, dst, src,
> +                                        len - total_translated, &transla=
ted);
> +               }
>
> -               ret =3D copy_to_iter(src, translated, &iter);
>                 if (ret < 0)
>                         return ret;
>
> @@ -1210,20 +1322,37 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>  static inline int getu16_iotlb(const struct vringh *vrh,
>                                u16 *val, const __virtio16 *p)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *from;
>         int ret;
>
>         /* Atomic read is needed for getu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_RO);
> -       if (ret < 0)
> -               return ret;
> +       if (vrh->use_va) {
> +               struct iovec iov;
> +               __virtio16 tmp;
> +
> +               ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)p, sizeof=
(*p),
> +                                        NULL, &iov, 1, VHOST_MAP_RO);
> +               if (ret < 0)
> +                       return ret;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       from =3D kaddr + iov.bv_offset;
> -       *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_local(kaddr);
> +               ret =3D __get_user(tmp, (__virtio16 __user *)iov.iov_base=
);
> +               if (ret)
> +                       return ret;
> +
> +               *val =3D vringh16_to_cpu(vrh, tmp);
> +       } else {
> +               struct bio_vec iov;
> +               void *kaddr, *from;
> +
> +               ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)p, sizeof=
(*p),
> +                                        NULL, &iov, 1, VHOST_MAP_RO);
> +               if (ret < 0)
> +                       return ret;
> +
> +               kaddr =3D kmap_local_page(iov.bv_page);
> +               from =3D kaddr + iov.bv_offset;
> +               *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)fr=
om));
> +               kunmap_local(kaddr);
> +       }
>
>         return 0;
>  }
> @@ -1231,20 +1360,37 @@ static inline int getu16_iotlb(const struct vring=
h *vrh,
>  static inline int putu16_iotlb(const struct vringh *vrh,
>                                __virtio16 *p, u16 val)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *to;
>         int ret;
>
>         /* Atomic write is needed for putu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_WO);
> -       if (ret < 0)
> -               return ret;
> +       if (vrh->use_va) {
> +               struct iovec iov;
> +               __virtio16 tmp;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       to =3D kaddr + iov.bv_offset;
> -       WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -       kunmap_local(kaddr);
> +               ret =3D iotlb_translate_va(vrh, (u64)(uintptr_t)p, sizeof=
(*p),
> +                                        NULL, &iov, 1, VHOST_MAP_RO);
> +               if (ret < 0)
> +                       return ret;
> +
> +               tmp =3D cpu_to_vringh16(vrh, val);
> +
> +               ret =3D __put_user(tmp, (__virtio16 __user *)iov.iov_base=
);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               struct bio_vec iov;
> +               void *kaddr, *to;
> +
> +               ret =3D iotlb_translate_pa(vrh, (u64)(uintptr_t)p, sizeof=
(*p), NULL,
> +                                        &iov, 1, VHOST_MAP_WO);
> +               if (ret < 0)
> +                       return ret;
> +
> +               kaddr =3D kmap_local_page(iov.bv_page);
> +               to =3D kaddr + iov.bv_offset;
> +               WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> +               kunmap_local(kaddr);
> +       }
>
>         return 0;
>  }
> @@ -1306,6 +1452,7 @@ static inline int putused_iotlb(const struct vringh=
 *vrh,
>   * @features: the feature bits for this ring.
>   * @num: the number of elements.
>   * @weak_barriers: true if we only need memory barriers, not I/O.
> + * @use_va: true if IOTLB contains user VA
>   * @desc: the userpace descriptor pointer.
>   * @avail: the userpace avail pointer.
>   * @used: the userpace used pointer.
> @@ -1313,11 +1460,13 @@ static inline int putused_iotlb(const struct vrin=
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

