Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC7E6A99BA
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 15:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjCCOmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 09:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjCCOl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 09:41:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5316438B5F
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 06:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677854461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=npG840B2CWbytow6GiT2dpSNf/ra003xD6Hbov44E5k=;
        b=afOEjaci/eIOeoULCBKgF78XZVAle/HHbap81KHvTAyh4A7ZMPBL0JEKcldVkC1XcLo0gl
        rJsNDeTAGlZsKAyYQHHlAMba32Nif0i2Dr1RG/jdO7+0mzYkW+QMoDr56/HrVfRn3kA+jg
        vePCIzhc+lPe2KEnmVB7yZQmXZkVQ/M=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-_8dNs6VUOsyJdV0EMcVEPQ-1; Fri, 03 Mar 2023 09:40:59 -0500
X-MC-Unique: _8dNs6VUOsyJdV0EMcVEPQ-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-536bf649e70so26623427b3.0
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 06:40:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677854459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npG840B2CWbytow6GiT2dpSNf/ra003xD6Hbov44E5k=;
        b=qoO0jz/EnDHqW0H3SWrilBxzaU53LwSe8uUoYIsxsqhdIWumaHaxQxdUS6YBOkJVJX
         Vg2uiqWLLpaVTVXyCDjIQ9UzH3SCEqNGnXtZBn1/kW/KLe21QTQIMyJk/Da6um8phuMB
         Q5HtlUv3vjmhbbOYeuldRnQkyyEgiYDUWbjluzzrCpSsu706LYSE9ruQseAdrzQnqVjU
         pTaKTG4qUDH1Q5WayYgVM+leCX2Y88Mm0MRR2F4PWrZ9ir3dKUSZBsrw77BCKhVM6wVb
         8WUUpxP8zsyafix+Ts3M2BZaMAsjXsA4kXBi949C23eXaetjDlTDYlj3wwb9pZE59lra
         QUVA==
X-Gm-Message-State: AO0yUKXW+GyE97rpj8MvWOlgW5SQkuAz9Iaic7rSsYOvCCTnDexEKhuz
        xzdJGdZCIN6I84XEo0VW7Zbm1elDVj/yMD/5YSnU2dwga0R8CQxDGspLfgbu04z0m7IxTvSLtPq
        cNpfcNHF1vb7almvPIJBHzbML959VnLUB
X-Received: by 2002:a81:ac21:0:b0:534:2d49:7912 with SMTP id k33-20020a81ac21000000b005342d497912mr1082726ywh.6.1677854459087;
        Fri, 03 Mar 2023 06:40:59 -0800 (PST)
X-Google-Smtp-Source: AK7set/3HdlAnj8H7lBeFLCOfIZvwPna5/7sZl5yd4f2J0klMCuKHZHk13uLuPEHUw5dpUvtCyDYBFF+POUh2WBPcU4=
X-Received: by 2002:a81:ac21:0:b0:534:2d49:7912 with SMTP id
 k33-20020a81ac21000000b005342d497912mr1082713ywh.6.1677854458709; Fri, 03 Mar
 2023 06:40:58 -0800 (PST)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-6-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-6-sgarzare@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 3 Mar 2023 15:40:22 +0100
Message-ID: <CAJaqyWd+_wEAtfUhVfgAPLvr_3dm5pQghpdFhys5Maniwkhv1g@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] vdpa_sim: make devices agnostic for work management
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
> Let's move work management inside the vdpa_sim core.
> This way we can easily change how we manage the works, without
> having to change the devices each time.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Eugenio P=C3=A9rez Martin <eperezma@redhat.com>

> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  3 ++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 17 +++++++++++++++--
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  6 ++----
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  6 ++----
>  4 files changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdp=
a_sim.h
> index 144858636c10..acee20faaf6a 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -45,7 +45,7 @@ struct vdpasim_dev_attr {
>         u32 ngroups;
>         u32 nas;
>
> -       work_func_t work_fn;
> +       void (*work_fn)(struct vdpasim *vdpasim);
>         void (*get_config)(struct vdpasim *vdpasim, void *config);
>         void (*set_config)(struct vdpasim *vdpasim, const void *config);
>         int (*get_stats)(struct vdpasim *vdpasim, u16 idx,
> @@ -78,6 +78,7 @@ struct vdpasim {
>
>  struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *attr,
>                                const struct vdpa_dev_set_config *config);
> +void vdpasim_schedule_work(struct vdpasim *vdpasim);
>
>  /* TODO: cross-endian support */
>  static inline bool vdpasim_is_little_endian(struct vdpasim *vdpasim)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 481eb156658b..a6ee830efc38 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -116,6 +116,13 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim=
)
>  static const struct vdpa_config_ops vdpasim_config_ops;
>  static const struct vdpa_config_ops vdpasim_batch_config_ops;
>
> +static void vdpasim_work_fn(struct work_struct *work)
> +{
> +       struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
> +
> +       vdpasim->dev_attr.work_fn(vdpasim);
> +}
> +
>  struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
>                                const struct vdpa_dev_set_config *config)
>  {
> @@ -152,7 +159,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_att=
r *dev_attr,
>
>         vdpasim =3D vdpa_to_sim(vdpa);
>         vdpasim->dev_attr =3D *dev_attr;
> -       INIT_WORK(&vdpasim->work, dev_attr->work_fn);
> +       INIT_WORK(&vdpasim->work, vdpasim_work_fn);
>         spin_lock_init(&vdpasim->lock);
>         spin_lock_init(&vdpasim->iommu_lock);
>
> @@ -203,6 +210,12 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_at=
tr *dev_attr,
>  }
>  EXPORT_SYMBOL_GPL(vdpasim_create);
>
> +void vdpasim_schedule_work(struct vdpasim *vdpasim)
> +{
> +       schedule_work(&vdpasim->work);
> +}
> +EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
> +
>  static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
>                                   u64 desc_area, u64 driver_area,
>                                   u64 device_area)
> @@ -237,7 +250,7 @@ static void vdpasim_kick_vq(struct vdpa_device *vdpa,=
 u16 idx)
>         }
>
>         if (vq->ready)
> -               schedule_work(&vdpasim->work);
> +               vdpasim_schedule_work(vdpasim);
>  }
>
>  static void vdpasim_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_blk.c
> index 5117959bed8a..eb4897c8541e 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -11,7 +11,6 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> -#include <linux/sched.h>
>  #include <linux/blkdev.h>
>  #include <linux/vringh.h>
>  #include <linux/vdpa.h>
> @@ -286,9 +285,8 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vd=
pasim,
>         return handled;
>  }
>
> -static void vdpasim_blk_work(struct work_struct *work)
> +static void vdpasim_blk_work(struct vdpasim *vdpasim)
>  {
> -       struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
>         bool reschedule =3D false;
>         int i;
>
> @@ -326,7 +324,7 @@ static void vdpasim_blk_work(struct work_struct *work=
)
>         spin_unlock(&vdpasim->lock);
>
>         if (reschedule)
> -               schedule_work(&vdpasim->work);
> +               vdpasim_schedule_work(vdpasim);
>  }
>
>  static void vdpasim_blk_get_config(struct vdpasim *vdpasim, void *config=
)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_net.c
> index 862f405362de..e61a9ecbfafe 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -11,7 +11,6 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> -#include <linux/sched.h>
>  #include <linux/etherdevice.h>
>  #include <linux/vringh.h>
>  #include <linux/vdpa.h>
> @@ -192,9 +191,8 @@ static void vdpasim_handle_cvq(struct vdpasim *vdpasi=
m)
>         u64_stats_update_end(&net->cq_stats.syncp);
>  }
>
> -static void vdpasim_net_work(struct work_struct *work)
> +static void vdpasim_net_work(struct vdpasim *vdpasim)
>  {
> -       struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
>         struct vdpasim_virtqueue *txq =3D &vdpasim->vqs[1];
>         struct vdpasim_virtqueue *rxq =3D &vdpasim->vqs[0];
>         struct vdpasim_net *net =3D sim_to_net(vdpasim);
> @@ -260,7 +258,7 @@ static void vdpasim_net_work(struct work_struct *work=
)
>                 vdpasim_net_complete(rxq, write);
>
>                 if (tx_pkts > 4) {
> -                       schedule_work(&vdpasim->work);
> +                       vdpasim_schedule_work(vdpasim);
>                         goto out;
>                 }
>         }
> --
> 2.39.2
>

