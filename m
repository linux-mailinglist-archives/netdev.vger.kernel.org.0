Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985C86DD1EF
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 07:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjDKFmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 01:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjDKFms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 01:42:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CB82D50
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681191714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4bDRARzkF1gI/5ulEGpZGNsH6UfiOpQWPqUWlQsIBA=;
        b=WiGaDJ7kbZPmyfrgvndmiSJoU6w7rmKDpodaxseg0ZNXqYKWVY/5P3KWiGIPh0MHkvj2C4
        4k6MbOJ4n/GkjkP7f19uKkOePythYeS5wZgCbiiEJQjhNqKin9kWIu84LU6uhpHrIe5AmV
        dOcyRZIolIEb+hsbMqVONX1hABd+Lnk=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540--FLX-nbCMK6KB8Y-It7DuQ-1; Tue, 11 Apr 2023 01:41:53 -0400
X-MC-Unique: -FLX-nbCMK6KB8Y-It7DuQ-1
Received: by mail-oo1-f71.google.com with SMTP id 188-20020a4a00c5000000b005255baa8dfbso2300477ooh.23
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681191712; x=1683783712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F4bDRARzkF1gI/5ulEGpZGNsH6UfiOpQWPqUWlQsIBA=;
        b=LgzeuLkiuc86CpKZ8tCUt5vhGrNQXNZ2nhWVWjp6G/OGKIw3lEq1pRBigOXNeGlNKN
         UfofSuMNeJSnphFg5ABZRWYeuMJx7YCzMpNifYaXbkEJWsKEbUx9bV17DgR/BR6dzR1H
         7rKjkZoaIYSg7KW0qjpSPP83dSIU/6PZErW1utMASaL0L7OI0GVXv2yKG4kJKWn5d06s
         O4BQArhj5s0vHp6hTToK8AChmzKUtQGCMckeDZ/6JHg5mzoC632vJPmUJFggKjk5iBbe
         xTMnbu1EMBGa6KlDKSdhbwf+2UoqCo+nMs4AMpsLmA4smgNIRt+71KDljcKVn2kRG9/F
         gzAA==
X-Gm-Message-State: AAQBX9f3P5DHg6J34vRZz9ILuvPFogn+NnN+SdPARDNZMLG1Ka9Dyr9R
        zPZe4wPi0AJn2jPUsu/TkhuQEEla4RWqiK8HOMzlzRDcyJhbd6WcqujHP0n8vQnlVmMryVm+Y08
        3gIusG1DP7X31itd770ScbOx8VVQUtMf+9da5pxUKjwlLcg==
X-Received: by 2002:a05:6808:915:b0:389:50f2:4aa6 with SMTP id w21-20020a056808091500b0038950f24aa6mr3485406oih.9.1681191712437;
        Mon, 10 Apr 2023 22:41:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350ba79FFjguMP41m14aWnC03kxojFyfpXzYkG9oPN7/mMj3q5qfv4prTvfI8vurRSKAoUOOE20KPuCvEVg5CpGI=
X-Received: by 2002:a05:6808:915:b0:389:50f2:4aa6 with SMTP id
 w21-20020a056808091500b0038950f24aa6mr3485398oih.9.1681191711952; Mon, 10 Apr
 2023 22:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230404131326.44403-1-sgarzare@redhat.com> <20230404131716.45855-1-sgarzare@redhat.com>
In-Reply-To: <20230404131716.45855-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 Apr 2023 13:41:41 +0800
Message-ID: <CACGkMEu_AL7M-szVsp9WmUZDQtD0p8t=XF=D+sxsLP=a5gny4Q@mail.gmail.com>
Subject: Re: [PATCH v5 5/9] vringh: support VA with iotlb
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

On Tue, Apr 4, 2023 at 9:17=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> vDPA supports the possibility to use user VA in the iotlb messages.
> So, let's add support for user VA in vringh to use it in the vDPA
> simulators.
>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>
> Notes:
>     v5:
>     - s/userpace/userspace/ in the vringh_init_iotlb_va doc [Simon]
>     v4:
>     - used uintptr_t for `io_addr` [Eugenio]
>     - added `io_addr` and `io_len` variables in iotlb_translate
>     - avoided overflow doing `map->addr - map->start + addr` [Jason]
>     - removed `is_iovec` field from struct iotlb_vec [Jason]
>     - added vringh_init_iotlb_va() [Jason]
>     v3:
>     - refactored avoiding code duplication [Eugenio]
>     v2:
>     - replace kmap_atomic() with kmap_local_page() [see previous patch]
>     - fix cast warnings when build with W=3D1 C=3D1
>
>  include/linux/vringh.h |   9 +++
>  drivers/vhost/vringh.c | 171 +++++++++++++++++++++++++++++++++--------
>  2 files changed, 148 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 1991a02c6431..b4edfadf5479 100644
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
> @@ -284,6 +287,12 @@ int vringh_init_iotlb(struct vringh *vrh, u64 featur=
es,
>                       struct vring_avail *avail,
>                       struct vring_used *used);
>
> +int vringh_init_iotlb_va(struct vringh *vrh, u64 features,
> +                        unsigned int num, bool weak_barriers,
> +                        struct vring_desc *desc,
> +                        struct vring_avail *avail,
> +                        struct vring_used *used);
> +
>  int vringh_getdesc_iotlb(struct vringh *vrh,
>                          struct vringh_kiov *riov,
>                          struct vringh_kiov *wiov,
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 4aee230f7622..ab95160dcdd9 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1094,10 +1094,17 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>
>  #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>
> +struct iotlb_vec {
> +       union {
> +               struct iovec *iovec;
> +               struct bio_vec *bvec;
> +       } iov;
> +       size_t count;
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
> @@ -1107,9 +1114,11 @@ static int iotlb_translate(const struct vringh *vr=
h,
>         spin_lock(vrh->iotlb_lock);
>
>         while (len > s) {
> -               u64 size, pa, pfn;
> +               uintptr_t io_addr;
> +               size_t io_len;
> +               u64 size;
>
> -               if (unlikely(ret >=3D iov_size)) {
> +               if (unlikely(ret >=3D ivec->count)) {
>                         ret =3D -ENOBUFS;
>                         break;
>                 }
> @@ -1124,10 +1133,22 @@ static int iotlb_translate(const struct vringh *v=
rh,
>                 }
>
>                 size =3D map->size - addr + map->start;
> -               pa =3D map->addr + addr - map->start;
> -               pfn =3D pa >> PAGE_SHIFT;
> -               bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, s=
ize),
> -                             pa & (PAGE_SIZE - 1));
> +               io_len =3D min(len - s, size);
> +               io_addr =3D map->addr - map->start + addr;
> +
> +               if (vrh->use_va) {
> +                       struct iovec *iovec =3D ivec->iov.iovec;
> +
> +                       iovec[ret].iov_len =3D io_len;
> +                       iovec[ret].iov_base =3D (void __user *)io_addr;
> +               } else {
> +                       u64 pfn =3D io_addr >> PAGE_SHIFT;
> +                       struct bio_vec *bvec =3D ivec->iov.bvec;
> +
> +                       bvec_set_page(&bvec[ret], pfn_to_page(pfn), io_le=
n,
> +                                     io_addr & (PAGE_SIZE - 1));
> +               }
> +
>                 s +=3D size;
>                 addr +=3D size;
>                 ++ret;
> @@ -1146,23 +1167,36 @@ static int iotlb_translate(const struct vringh *v=
rh,
>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>                                   void *src, size_t len)
>  {
> +       struct iotlb_vec ivec;
> +       union {
> +               struct iovec iovec[IOTLB_IOV_STRIDE];
> +               struct bio_vec bvec[IOTLB_IOV_STRIDE];
> +       } iov;
>         u64 total_translated =3D 0;
>
> +       ivec.iov.iovec =3D iov.iovec;
> +       ivec.count =3D IOTLB_IOV_STRIDE;
> +
>         while (total_translated < len) {
> -               struct bio_vec iov[IOTLB_IOV_STRIDE];
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
> +                       ret =3D IOTLB_IOV_STRIDE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
> +               if (vrh->use_va) {
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
> @@ -1179,23 +1213,36 @@ static inline int copy_from_iotlb(const struct vr=
ingh *vrh, void *dst,
>  static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
>                                 void *src, size_t len)
>  {
> +       struct iotlb_vec ivec;
> +       union {
> +               struct iovec iovec[IOTLB_IOV_STRIDE];
> +               struct bio_vec bvec[IOTLB_IOV_STRIDE];
> +       } iov;
>         u64 total_translated =3D 0;
>
> +       ivec.iov.iovec =3D iov.iovec;
> +       ivec.count =3D IOTLB_IOV_STRIDE;
> +
>         while (total_translated < len) {
> -               struct bio_vec iov[IOTLB_IOV_STRIDE];
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
> +                       ret =3D IOTLB_IOV_STRIDE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
> +               if (vrh->use_va) {
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
> @@ -1212,20 +1259,36 @@ static inline int copy_to_iotlb(const struct vrin=
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
> +       if (vrh->use_va) {
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
> @@ -1233,20 +1296,36 @@ static inline int getu16_iotlb(const struct vring=
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
> +       if (vrh->use_va) {
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
> @@ -1320,11 +1399,39 @@ int vringh_init_iotlb(struct vringh *vrh, u64 fea=
tures,
>                       struct vring_avail *avail,
>                       struct vring_used *used)
>  {
> +       vrh->use_va =3D false;
> +
>         return vringh_init_kern(vrh, features, num, weak_barriers,
>                                 desc, avail, used);
>  }
>  EXPORT_SYMBOL(vringh_init_iotlb);
>
> +/**
> + * vringh_init_iotlb_va - initialize a vringh for a ring with IOTLB cont=
aining
> + *                        user VA.
> + * @vrh: the vringh to initialize.
> + * @features: the feature bits for this ring.
> + * @num: the number of elements.
> + * @weak_barriers: true if we only need memory barriers, not I/O.
> + * @desc: the userspace descriptor pointer.
> + * @avail: the userspace avail pointer.
> + * @used: the userspace used pointer.
> + *
> + * Returns an error if num is invalid.
> + */
> +int vringh_init_iotlb_va(struct vringh *vrh, u64 features,
> +                        unsigned int num, bool weak_barriers,
> +                        struct vring_desc *desc,
> +                        struct vring_avail *avail,
> +                        struct vring_used *used)
> +{
> +       vrh->use_va =3D true;
> +
> +       return vringh_init_kern(vrh, features, num, weak_barriers,
> +                               desc, avail, used);
> +}
> +EXPORT_SYMBOL(vringh_init_iotlb_va);
> +
>  /**
>   * vringh_set_iotlb - initialize a vringh for a ring with IOTLB.
>   * @vrh: the vring
> --
> 2.39.2
>

