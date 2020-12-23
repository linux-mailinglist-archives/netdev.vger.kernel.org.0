Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2191F2E1B68
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 12:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgLWLHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 06:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgLWLHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 06:07:18 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FE9C06179C
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 03:06:37 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id dk8so15886019edb.1
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 03:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8r9lkR1ewmktO6f8Rf77A8AbHLVrP1WsFddPoMLwGkw=;
        b=bMkg1xZT185KrHJXJFsW/EwmINi0UDjOk+dHKWE4lvYcn4hImVnrFp92fISdt0aYa5
         b2+nuINy3rNZkuQYVBtbBj72q6+GigRtLd96X1RKIN9f2mmdmo1nMIzkT9bn6jY8qop2
         0hKrf3owwfznx4wOfzMah97m1pCEhsyYCgLzEcjQ7dJ192Rt6+tdfusLkUdW4kS94HRA
         Y59W/khhqjC9Q9epm1emX7cVly6JUlIBpszp891dJYSR9ciybbrHN/Z5FO3mAiFKlIcr
         Pc7S+KrculE7i0JM+aucUbcORBSuH8QIfILEDRVyLkTn4mBGLY83ZsKvxafNn9r1GJRV
         TyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8r9lkR1ewmktO6f8Rf77A8AbHLVrP1WsFddPoMLwGkw=;
        b=Y6lu4NTpMnxvUxMokhlT55EueI5YZkSIy9pSCSTXCIpSGWFcgMsuYnfjMFqkrcV0Za
         oz6CWM6y7hv8qBZNMf5kfLiKlZfRN/dg/icDdgiNyCPLmzoQtt8maBqf+vfw3Y3mPHzf
         fzTt6z2It4LCXCx6hdEEOvZZZzXPwuwO9f2J4Ug42q6q3wtzPDoDFqxpLO3fVbRTJbOn
         MRPLOWkA4UnO2nVIBpd2oyU5pfr1id4pNX6Io7TqFgsD14pQkXdhbXXh6CaYx1tKvsJE
         MzwrApOIxsV4jZhT9BTg/RT1IOHnEkPTINjEonSETqGnghlxuMFTbrosGIs42JScgOUI
         4wwQ==
X-Gm-Message-State: AOAM532A7u3KIZ7v+VgNZ1SVbTa8f8KmBsGjulIeHw7zsNjydZ0Q4w8P
        woqIuaOCjsPdMjEscXcJer1X6F4fSVyqR4/tL9Jj
X-Google-Smtp-Source: ABdhPJyG19aAoEETogPYctEYJMED3IJISC+VgMuC0/oXotW9zb5O3R9AOF2iGjGgp5V5nFuNWEulpmdJHswyJmZvyJ4=
X-Received: by 2002:a05:6402:407:: with SMTP id q7mr24171337edv.312.1608721596404;
 Wed, 23 Dec 2020 03:06:36 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-9-xieyongji@bytedance.com>
 <5b36bc51-1e19-2b59-6287-66aed435c8ed@redhat.com>
In-Reply-To: <5b36bc51-1e19-2b59-6287-66aed435c8ed@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 23 Dec 2020 19:06:25 +0800
Message-ID: <CACycT3tP8mgj043idjJW3BF12qmOhmHzYz8X5FyL8t5MbwLysw@mail.gmail.com>
Subject: Re: [RFC v2 08/13] vdpa: Introduce process_iotlb_msg() in vdpa_config_ops
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 4:37 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> > This patch introduces a new method in the vdpa_config_ops to
> > support processing the raw vhost memory mapping message in the
> > vDPA device driver.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/vhost/vdpa.c | 5 ++++-
> >   include/linux/vdpa.h | 7 +++++++
> >   2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 448be7875b6d..ccbb391e38be 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -728,6 +728,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhos=
t_dev *dev,
> >       if (r)
> >               return r;
> >
> > +     if (ops->process_iotlb_msg)
> > +             return ops->process_iotlb_msg(vdpa, msg);
> > +
> >       switch (msg->type) {
> >       case VHOST_IOTLB_UPDATE:
> >               r =3D vhost_vdpa_process_iotlb_update(v, msg);
> > @@ -770,7 +773,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdp=
a *v)
> >       int ret;
> >
> >       /* Device want to do DMA by itself */
> > -     if (ops->set_map || ops->dma_map)
> > +     if (ops->set_map || ops->dma_map || ops->process_iotlb_msg)
> >               return 0;
> >
> >       bus =3D dma_dev->bus;
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index 656fe264234e..7bccedf22f4b 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -5,6 +5,7 @@
> >   #include <linux/kernel.h>
> >   #include <linux/device.h>
> >   #include <linux/interrupt.h>
> > +#include <linux/vhost_types.h>
> >   #include <linux/vhost_iotlb.h>
> >   #include <net/genetlink.h>
> >
> > @@ -172,6 +173,10 @@ struct vdpa_iova_range {
> >    *                          @vdev: vdpa device
> >    *                          Returns the iova range supported by
> >    *                          the device.
> > + * @process_iotlb_msg:               Process vhost memory mapping mess=
age (optional)
> > + *                           Only used for VDUSE device now
> > + *                           @vdev: vdpa device
> > + *                           @msg: vhost memory mapping message
> >    * @set_map:                        Set device memory mapping (option=
al)
> >    *                          Needed for device that using device
> >    *                          specific DMA translation (on-chip IOMMU)
> > @@ -240,6 +245,8 @@ struct vdpa_config_ops {
> >       struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev=
);
> >
> >       /* DMA ops */
> > +     int (*process_iotlb_msg)(struct vdpa_device *vdev,
> > +                              struct vhost_iotlb_msg *msg);
> >       int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotl=
b);
> >       int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> >                      u64 pa, u32 perm);
>
>
> Is there any reason that it can't be done via dma_map/dma_unmap or set_ma=
p?
>

To get the shmfd, we need the vma rather than physical address. And
it's not necessary to pin the user pages in VDUSE case.

Thanks,
Yongji
