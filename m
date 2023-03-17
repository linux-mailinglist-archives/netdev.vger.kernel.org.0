Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3AE6BDF19
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCQCyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjCQCyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:54:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFCB8C5AA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 19:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679021640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pluPJppzyDIalsAhWTuVYAgpoH+EOIPdAql9Fm4Aly4=;
        b=H43zQUOda5nBYzv35rZtyy1dnFpk41nvmtKjgk/evjMS2yrsf9BDYk00yB5+C1MSkV0rWc
        0CHmQm+xQMIBllkLPpRiO+r6NXmv6lKsP/n2iQ81rpd3WkxaCwbhMSerj5wWRrsQNMsshB
        BUZd+xye5DY/CF5ud6TX2cLVHvDty3w=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-p3kM1xi1OpiWvdvg9QdsHA-1; Thu, 16 Mar 2023 22:53:59 -0400
X-MC-Unique: p3kM1xi1OpiWvdvg9QdsHA-1
Received: by mail-ot1-f72.google.com with SMTP id e1-20020a05683013c100b0069a4bd47d92so1641626otq.22
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 19:53:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679021638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pluPJppzyDIalsAhWTuVYAgpoH+EOIPdAql9Fm4Aly4=;
        b=revMh1m6c8xbf9DGsrSL1upWZjFZ2DMwms8CGZufgQwgO8eeoAO1rTw5uHpadFRrCj
         5KkcUkiVmHViJhQkbuYBz6sWXF6NueJ88bbR/GUL9b2tuBVWBwjZfsR+DWaGz4acsp5f
         gDV8kHFxgM8NzioRpzR48MCCwkU6dVBrfLxUMiedua7+UPWPnk7JP/RIz6D4JV4p93Q/
         cR+J86/B7VQkKs1gVWmJjgk+gYSVWr8ITpg4ZjrLYAEqg1p8uE93ewF7aa5qpwxHq+5x
         wYMSqXg7XZ5BLypedOk57xNYwn/hsHzvnoSDYM0qCAFsjwZYYl9zYPLPKSglid+79GvY
         xyOA==
X-Gm-Message-State: AO0yUKXudHra3/6TxvT+t3kQwB0fupEmfFhEkyNeDhZ3ERWVJFqb6oQJ
        ihyj0SPmoHZURgBJ5K7UtZ4+JYOQXdXJFa1tpSLsqcS5qsAmZvKbc/BIDDu/T5T7jbfRBJeql8J
        BZiUjxtuKT+hdtEpscWdfKIDANlL8qTLg
X-Received: by 2002:aca:1c16:0:b0:384:4e2d:81ea with SMTP id c22-20020aca1c16000000b003844e2d81eamr2776115oic.9.1679021638295;
        Thu, 16 Mar 2023 19:53:58 -0700 (PDT)
X-Google-Smtp-Source: AK7set+849Y/hFmNDYNF8806XrLyc9rDXov7KzdFCtBv3JEm0nLxl0tEOAUOsVLOVSlupFcT+oPluS67vy9TZ2zVgXw=
X-Received: by 2002:aca:1c16:0:b0:384:4e2d:81ea with SMTP id
 c22-20020aca1c16000000b003844e2d81eamr2776113oic.9.1679021638009; Thu, 16 Mar
 2023 19:53:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-5-sgarzare@redhat.com>
 <CAJaqyWdeEzKnYuX-c348vVg0PpUH4y-e1dSLhRvYem=MEDKE=Q@mail.gmail.com> <CAGxU2F7GZxMwLNsAebaPx61MoePYYmFS1q66An-EDhq4u+a9ng@mail.gmail.com>
In-Reply-To: <CAGxU2F7GZxMwLNsAebaPx61MoePYYmFS1q66An-EDhq4u+a9ng@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Mar 2023 10:53:46 +0800
Message-ID: <CACGkMEtjO+Y2WFGkiVGOmdaydhiUjqXwW_XCqXQOYJfoH=tzUg@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] vringh: support VA with iotlb
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Eugenio Perez Martin <eperezma@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
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

On Fri, Mar 17, 2023 at 12:07=E2=80=AFAM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> On Fri, Mar 3, 2023 at 3:39=E2=80=AFPM Eugenio Perez Martin <eperezma@red=
hat.com> wrote:
> >
> > On Thu, Mar 2, 2023 at 12:35 PM Stefano Garzarella <sgarzare@redhat.com=
> wrote:
> > >
> > > vDPA supports the possibility to use user VA in the iotlb messages.
> > > So, let's add support for user VA in vringh to use it in the vDPA
> > > simulators.
> > >
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >
> > > Notes:
> > >     v2:
> > >     - replace kmap_atomic() with kmap_local_page() [see previous patc=
h]
> > >     - fix cast warnings when build with W=3D1 C=3D1
> > >
> > >  include/linux/vringh.h            |   5 +-
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
> > >  drivers/vhost/vringh.c            | 247 ++++++++++++++++++++++++----=
--
> > >  4 files changed, 205 insertions(+), 53 deletions(-)
> > >
>
> [...]
>
> >
> > It seems to me iotlb_translate_va and iotlb_translate_pa are very
> > similar, their only difference is that the argument is that iov is
> > iovec instead of bio_vec. And how to fill it, obviously.
> >
> > It would be great to merge both functions, only differing with a
> > conditional on vrh->use_va, or generics, or similar. Or, if following
> > the style of the rest of vringh code, to provide a callback to fill
> > iovec (although I like conditional more).
> >
> > However I cannot think of an easy way to perform that without long
> > macros or type erasure.
>
> Thank you for pushing me :-)
> I finally managed to avoid code duplication (partial patch attached,
> but not yet fully tested).
>
> @Jason: with this refactoring I removed copy_to_va/copy_to_pa, so I
> also avoided getu16_iotlb_va/pa.
>
> I will send the full patch in v3, but I would like to get your opinion
> first ;-)

Fine with me.

Thanks

>
>
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 0ba3ef809e48..71dd67700e36 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1096,8 +1096,7 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>
>  static int iotlb_translate(const struct vringh *vrh,
>                            u64 addr, u64 len, u64 *translated,
> -                          struct bio_vec iov[],
> -                          int iov_size, u32 perm)
> +                          void *iov, int iov_size, bool iovec, u32 perm)
>  {
>         struct vhost_iotlb_map *map;
>         struct vhost_iotlb *iotlb =3D vrh->iotlb;
> @@ -1107,7 +1106,7 @@ static int iotlb_translate(const struct vringh *vrh=
,
>         spin_lock(vrh->iotlb_lock);
>
>         while (len > s) {
> -               u64 size, pa, pfn;
> +               u64 size;
>
>                 if (unlikely(ret >=3D iov_size)) {
>                         ret =3D -ENOBUFS;
> @@ -1124,10 +1123,22 @@ static int iotlb_translate(const struct vringh *v=
rh,
>                 }
>
>                 size =3D map->size - addr + map->start;
> -               pa =3D map->addr + addr - map->start;
> -               pfn =3D pa >> PAGE_SHIFT;
> -               bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, s=
ize),
> -                             pa & (PAGE_SIZE - 1));
> +               if (iovec) {
> +                       struct iovec *iovec =3D iov;
> +
> +                       iovec[ret].iov_len =3D min(len - s, size);
> +                       iovec[ret].iov_base =3D (void __user *)(unsigned =
long)
> +                                             (map->addr + addr - map->st=
art);
> +               } else {
> +                       u64 pa =3D map->addr + addr - map->start;
> +                       u64 pfn =3D pa >> PAGE_SHIFT;
> +                       struct bio_vec *bvec =3D iov;
> +
> +                       bvec_set_page(&bvec[ret], pfn_to_page(pfn),
> +                                     min(len - s, size),
> +                                     pa & (PAGE_SIZE - 1));
> +               }
> +
>                 s +=3D size;
>                 addr +=3D size;
>                 ++ret;
> @@ -1141,26 +1152,38 @@ static int iotlb_translate(const struct vringh *v=
rh,
>         return ret;
>  }
>
> +#define IOTLB_IOV_SIZE 16
> +
>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>                                   void *src, size_t len)
>  {
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> +               union {
> +                       struct iovec iovec[IOTLB_IOV_SIZE];
> +                       struct bio_vec bvec[IOTLB_IOV_SIZE];
> +               } iov;
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
>                 ret =3D iotlb_translate(vrh, (u64)(uintptr_t)src,
>                                       len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_RO)=
;
> +                                     &iov, IOTLB_IOV_SIZE, vrh->use_va,
> +                                     VHOST_MAP_RO);
>                 if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> +                       ret =3D IOTLB_IOV_SIZE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       iov_iter_init(&iter, ITER_SOURCE, iov.iovec, ret,
> +                                     translated);
> +               } else {
> +                       iov_iter_bvec(&iter, ITER_SOURCE, iov.bvec, ret,
> +                                     translated);
> +               }
>
>                 ret =3D copy_from_iter(dst, translated, &iter);
>                 if (ret < 0)
> @@ -1180,20 +1203,30 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> +               union {
> +                       struct iovec iovec[IOTLB_IOV_SIZE];
> +                       struct bio_vec bvec[IOTLB_IOV_SIZE];
> +               } iov;
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
>                 ret =3D iotlb_translate(vrh, (u64)(uintptr_t)dst,
>                                       len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_WO)=
;
> +                                     &iov, IOTLB_IOV_SIZE, vrh->use_va,
> +                                     VHOST_MAP_WO);
>                 if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> +                       ret =3D IOTLB_IOV_SIZE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       iov_iter_init(&iter, ITER_DEST, iov.iovec, ret,
> +                                     translated);
> +               } else {
> +                       iov_iter_bvec(&iter, ITER_DEST, iov.bvec, ret,
> +                                     translated);
> +               }
>
>                 ret =3D copy_to_iter(src, translated, &iter);
>                 if (ret < 0)
> @@ -1210,20 +1243,32 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>  static inline int getu16_iotlb(const struct vringh *vrh,
>                                u16 *val, const __virtio16 *p)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *from;
> +       union {
> +               struct iovec iovec;
> +               struct bio_vec bvec;
> +       } iov;
> +       __virtio16 tmp;
>         int ret;
>
>         /* Atomic read is needed for getu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_RO);
> +       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
> +                             NULL, &iov, 1, vrh->use_va, VHOST_MAP_RO);
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       from =3D kaddr + iov.bv_offset;
> -       *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_local(kaddr);
> +       if (vrh->use_va) {
> +               ret =3D __get_user(tmp, (__virtio16 __user *)iov.iovec.io=
v_base);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               void *kaddr =3D kmap_local_page(iov.bvec.bv_page);
> +               void *from =3D kaddr + iov.bvec.bv_offset;
> +
> +               tmp =3D READ_ONCE(*(__virtio16 *)from);
> +               kunmap_local(kaddr);
> +       }
> +
> +       *val =3D vringh16_to_cpu(vrh, tmp);
>
>         return 0;
>  }
> @@ -1231,20 +1276,32 @@ static inline int getu16_iotlb(const struct vring=
h *vrh,
>  static inline int putu16_iotlb(const struct vringh *vrh,
>                                __virtio16 *p, u16 val)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *to;
> +       union {
> +               struct iovec iovec;
> +               struct bio_vec bvec;
> +       } iov;
> +       __virtio16 tmp;
>         int ret;
>
>         /* Atomic write is needed for putu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_WO);
> +       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
> +                             NULL, &iov, 1, vrh->use_va, VHOST_MAP_RO);
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
> +               ret =3D __put_user(tmp, (__virtio16 __user *)iov.iovec.io=
v_base);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               void *kaddr =3D kmap_local_page(iov.bvec.bv_page);
> +               void *to =3D kaddr + iov.bvec.bv_offset;
> +
> +               WRITE_ONCE(*(__virtio16 *)to, tmp);
> +               kunmap_local(kaddr);
> +       }
>
>         return 0;
>  }
>

