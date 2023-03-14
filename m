Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4123D6B8A63
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCNFck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCNFci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:32:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC74925972
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678771913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jyUBoPolIWIdJ1iODF+bsaf4nIiYQ/NV9Gc2xnehBsk=;
        b=MOPz/eDmssAJaIIP3b6q7OQJOVP4pF8jVM0p1fBgi+jtW1s0Kwpkqm3oDIkScpIznEkj8G
        SBJj/aieC9S0S5qd3qvhxvWkr1AanIJlHonvfLUvg46MrsEh1VgGBi/K8pC/+EAO+tST4N
        /1+zlP9ZwBctp9sszVw2xAaClPAQIzE=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-v8kWmcdON3COI92sVhgn8w-1; Tue, 14 Mar 2023 01:31:50 -0400
X-MC-Unique: v8kWmcdON3COI92sVhgn8w-1
Received: by mail-ot1-f72.google.com with SMTP id y15-20020a0568301d8f00b006942b6e66d8so7052318oti.13
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678771909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyUBoPolIWIdJ1iODF+bsaf4nIiYQ/NV9Gc2xnehBsk=;
        b=ldTB4nGnFl/9movWE6BnWa4fdDJKSj8Mao78j1fjPnlJ51/11xygmGVEcgV69UZSCf
         COfX7r+X1rgHgUasAQCizDb2YOhnf6M7dMESTw9zZMw0N8PKyzZxVpf1WE3KUuV67x5u
         bZCyK2JTUtBCF1nuygVUjFpLE2PnZQ11eMBXVtJ5ngGRlK/qv4zYUqVrIvx5sn4BNY6M
         teRKrimpBLadd7BR7Y+F1AXLitznD6LoOQIKJ4dG5z8t69KTtPwaQtwBwxeVs058eSRk
         DYGwIeEG+BHSsOk6E3onbMMDf05T03Yjk5CBOHn7SKTbJScpQeGqzGXuhRGgpNSAq09e
         aaSw==
X-Gm-Message-State: AO0yUKX8reDMrjmuhzCNl4kPV/CTfYDhnHOQaMZBqRXI3lDGbGs2AV2+
        BYLToLIrrPEgjUEOXEMdhmMZCA1D/jMGSEmF2aTCoOXSdlr6eAWhL7QATck9jtZfP8nqOSZcwdx
        QFwr/RdxfNmsGiAxQFZIC0aZQeR7Mc42r
X-Received: by 2002:a05:6870:1110:b0:17a:adbe:2ba4 with SMTP id 16-20020a056870111000b0017aadbe2ba4mr206961oaf.9.1678771909520;
        Mon, 13 Mar 2023 22:31:49 -0700 (PDT)
X-Google-Smtp-Source: AK7set/6fO95dK426XWuh5jUuIFpmqvpj5E0M3mNetmj/iPdAKEwidMc3TkD2je67h5nibAYAxs+plvrkjI57ZStLJc=
X-Received: by 2002:a05:6870:1110:b0:17a:adbe:2ba4 with SMTP id
 16-20020a056870111000b0017aadbe2ba4mr206950oaf.9.1678771909283; Mon, 13 Mar
 2023 22:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-7-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-7-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 13:31:38 +0800
Message-ID: <CACGkMEt8VY-udr=5e9SUJ+Wt+TBVvfPgWuMUDC550VybtSngVQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] vdpa_sim: use kthread worker
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 2, 2023 at 7:35=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> Let's use our own kthread to run device jobs.
> This allows us more flexibility, especially we can attach the kthread
> to the user address space when vDPA uses user's VA.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks



> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.h |  3 ++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 17 ++++++++++++-----
>  2 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdp=
a_sim.h
> index acee20faaf6a..ce83f9130a5d 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -57,7 +57,8 @@ struct vdpasim_dev_attr {
>  struct vdpasim {
>         struct vdpa_device vdpa;
>         struct vdpasim_virtqueue *vqs;
> -       struct work_struct work;
> +       struct kthread_worker *worker;
> +       struct kthread_work work;
>         struct vdpasim_dev_attr dev_attr;
>         /* spinlock to synchronize virtqueue state */
>         spinlock_t lock;
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index a6ee830efc38..6feb29726c2a 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -11,8 +11,8 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> +#include <linux/kthread.h>
>  #include <linux/slab.h>
> -#include <linux/sched.h>
>  #include <linux/dma-map-ops.h>
>  #include <linux/vringh.h>
>  #include <linux/vdpa.h>
> @@ -116,7 +116,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>  static const struct vdpa_config_ops vdpasim_config_ops;
>  static const struct vdpa_config_ops vdpasim_batch_config_ops;
>
> -static void vdpasim_work_fn(struct work_struct *work)
> +static void vdpasim_work_fn(struct kthread_work *work)
>  {
>         struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
>
> @@ -159,7 +159,13 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_at=
tr *dev_attr,
>
>         vdpasim =3D vdpa_to_sim(vdpa);
>         vdpasim->dev_attr =3D *dev_attr;
> -       INIT_WORK(&vdpasim->work, vdpasim_work_fn);
> +
> +       kthread_init_work(&vdpasim->work, vdpasim_work_fn);
> +       vdpasim->worker =3D kthread_create_worker(0, "vDPA sim worker: %s=
",
> +                                               dev_attr->name);
> +       if (IS_ERR(vdpasim->worker))
> +               goto err_iommu;
> +
>         spin_lock_init(&vdpasim->lock);
>         spin_lock_init(&vdpasim->iommu_lock);
>
> @@ -212,7 +218,7 @@ EXPORT_SYMBOL_GPL(vdpasim_create);
>
>  void vdpasim_schedule_work(struct vdpasim *vdpasim)
>  {
> -       schedule_work(&vdpasim->work);
> +       kthread_queue_work(vdpasim->worker, &vdpasim->work);
>  }
>  EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
>
> @@ -612,7 +618,8 @@ static void vdpasim_free(struct vdpa_device *vdpa)
>         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
>         int i;
>
> -       cancel_work_sync(&vdpasim->work);
> +       kthread_cancel_work_sync(&vdpasim->work);
> +       kthread_destroy_worker(vdpasim->worker);
>
>         for (i =3D 0; i < vdpasim->dev_attr.nvqs; i++) {
>                 vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
> --
> 2.39.2
>

