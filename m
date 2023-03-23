Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A171B6C5D5E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCWDnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjCWDnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:43:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1190279A4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679542941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XUIZFR6eucu+OIs0TWLjII9inPt9aJzgG/Q5lo//Jeo=;
        b=FfzrE4pSdn/a7HGHtI3S96yiaJHGeblolExLDi+JyaHkqn+M0KIAtMGS3Mei39R5hXBqwl
        Efc7+jlgr11cywXw53gigNa/desWjn2Ph/tpLh+7DBT6hk943cOd1t8mlW6k0iqEmCnBPo
        EpqqNtz3LBVVLv/smRBt5zuHnIeyDQ0=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-_uqsrLLJPs2xCPQaJuXb8w-1; Wed, 22 Mar 2023 23:42:19 -0400
X-MC-Unique: _uqsrLLJPs2xCPQaJuXb8w-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-176347f3b28so10807680fac.23
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679542939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XUIZFR6eucu+OIs0TWLjII9inPt9aJzgG/Q5lo//Jeo=;
        b=XoxV0h0r1uSWlAP5rcXHTC6FXhSU+E+kCYAvQ7+WRaDHICaIYtXQdOxwKVo0319dHD
         34JD4yZsmXksmVcn4IF0K0gXWRg9yRKOwtHjIm72i/F14f90NjFykwiz14eP3R8wujAU
         KVj0naABR2rj7jXTGiHIsWkSV3vJNofBudyC0JgJ0ydRX+vsUAZzbAqgzXdZp1xI9WCv
         9U1MShclWhaLuJ41B2q6uHni88DW6ghSvLeo7wZFM4YdKdpOlRjyZ5IWIUSpfxfgXjmY
         8HzdWGSjolj0/hB14DoPE4GPyThzPNtBngoKcB4jQvdGYzePICsdzVTL1fKhyl7QSjUo
         I0mA==
X-Gm-Message-State: AO0yUKWpB6Fc6KNTpuDrEnVDDt2d3CUeKdBmFVt3Okb8TGGaUl6sFN/q
        Dosf6p17DKbjp1AUFjqVCKkXQaQRn7c9z/Vx5tgoQoY/KbS3bBZ0mJAXiXcykm+9CsZ3JyR3nFa
        ap9rk9e8oIxdlyNHG6d5V+COWR1VwvuxL
X-Received: by 2002:a05:6808:1a1d:b0:383:fef9:6cac with SMTP id bk29-20020a0568081a1d00b00383fef96cacmr1819910oib.9.1679542938861;
        Wed, 22 Mar 2023 20:42:18 -0700 (PDT)
X-Google-Smtp-Source: AK7set/mXp63nDLW0b7iGBzyRXlYGsaP/rHpglo4tTf5G/0Ar5AWw4s9TVxEiIat3siEObH+eUeSB9APmekJJ290fu0=
X-Received: by 2002:a05:6808:1a1d:b0:383:fef9:6cac with SMTP id
 bk29-20020a0568081a1d00b00383fef96cacmr1819900oib.9.1679542938572; Wed, 22
 Mar 2023 20:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154228.182769-1-sgarzare@redhat.com> <20230321154804.184577-1-sgarzare@redhat.com>
 <20230321154804.184577-4-sgarzare@redhat.com>
In-Reply-To: <20230321154804.184577-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 11:42:07 +0800
Message-ID: <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
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

On Tue, Mar 21, 2023 at 11:48=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> The new "use_va" module parameter (default: true) is used in
> vdpa_alloc_device() to inform the vDPA framework that the device
> supports VA.
>
> vringh is initialized to use VA only when "use_va" is true and the
> user's mm has been bound. So, only when the bus supports user VA
> (e.g. vhost-vdpa).
>
> vdpasim_mm_work_fn work is used to serialize the binding to a new
> address space when the .bind_mm callback is invoked, and unbinding
> when the .unbind_mm callback is invoked.
>
> Call mmget_not_zero()/kthread_use_mm() inside the worker function
> to pin the address space only as long as needed, following the
> documentation of mmget() in include/linux/sched/mm.h:
>
>   * Never use this function to pin this address space for an
>   * unbounded/indefinite amount of time.

I wonder if everything would be simplified if we just allow the parent
to advertise whether or not it requires the address space.

Then when vhost-vDPA probes the device it can simply advertise
use_work as true so vhost core can use get_task_mm() in this case?

Thanks

>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v3:
>     - called mmget_not_zero() before kthread_use_mm() [Jason]
>       As the documentation of mmget() in include/linux/sched/mm.h says:
>
>       * Never use this function to pin this address space for an
>       * unbounded/indefinite amount of time.
>
>       I moved mmget_not_zero/kthread_use_mm inside the worker function,
>       this way we pin the address space only as long as needed.
>       This is similar to what vfio_iommu_type1_dma_rw_chunk() does in
>       drivers/vfio/vfio_iommu_type1.c
>     - simplified the mm bind/unbind [Jason]
>     - renamed vdpasim_worker_change_mm_sync() [Jason]
>     - fix commit message (s/default: false/default: true)
>     v2:
>     - `use_va` set to true by default [Eugenio]
>     - supported the new unbind_mm callback [Jason]
>     - removed the unbind_mm call in vdpasim_do_reset() [Jason]
>     - avoided to release the lock while call kthread_flush_work() since w=
e
>       are now using a mutex to protect the device state
>
>  drivers/vdpa/vdpa_sim/vdpa_sim.h |  1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 80 +++++++++++++++++++++++++++++++-
>  2 files changed, 79 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdp=
a_sim.h
> index 4774292fba8c..3a42887d05d9 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -59,6 +59,7 @@ struct vdpasim {
>         struct vdpasim_virtqueue *vqs;
>         struct kthread_worker *worker;
>         struct kthread_work work;
> +       struct mm_struct *mm_bound;
>         struct vdpasim_dev_attr dev_attr;
>         /* mutex to synchronize virtqueue state */
>         struct mutex mutex;
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index ab4cfb82c237..23c891cdcd54 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -35,10 +35,44 @@ module_param(max_iotlb_entries, int, 0444);
>  MODULE_PARM_DESC(max_iotlb_entries,
>                  "Maximum number of iotlb entries for each address space.=
 0 means unlimited. (default: 2048)");
>
> +static bool use_va =3D true;
> +module_param(use_va, bool, 0444);
> +MODULE_PARM_DESC(use_va, "Enable/disable the device's ability to use VA"=
);
> +
>  #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>  #define VDPASIM_QUEUE_MAX 256
>  #define VDPASIM_VENDOR_ID 0
>
> +struct vdpasim_mm_work {
> +       struct kthread_work work;
> +       struct vdpasim *vdpasim;
> +       struct mm_struct *mm_to_bind;
> +       int ret;
> +};
> +
> +static void vdpasim_mm_work_fn(struct kthread_work *work)
> +{
> +       struct vdpasim_mm_work *mm_work =3D
> +               container_of(work, struct vdpasim_mm_work, work);
> +       struct vdpasim *vdpasim =3D mm_work->vdpasim;
> +
> +       mm_work->ret =3D 0;
> +
> +       //TODO: should we attach the cgroup of the mm owner?
> +       vdpasim->mm_bound =3D mm_work->mm_to_bind;
> +}
> +
> +static void vdpasim_worker_change_mm_sync(struct vdpasim *vdpasim,
> +                                         struct vdpasim_mm_work *mm_work=
)
> +{
> +       struct kthread_work *work =3D &mm_work->work;
> +
> +       kthread_init_work(work, vdpasim_mm_work_fn);
> +       kthread_queue_work(vdpasim->worker, work);
> +
> +       kthread_flush_work(work);
> +}
> +
>  static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
>  {
>         return container_of(vdpa, struct vdpasim, vdpa);
> @@ -59,8 +93,10 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasi=
m, unsigned int idx)
>  {
>         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
>         uint16_t last_avail_idx =3D vq->vring.last_avail_idx;
> +       bool va_enabled =3D use_va && vdpasim->mm_bound;
>
> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, f=
alse,
> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
> +                         va_enabled,
>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>                           (struct vring_avail *)
>                           (uintptr_t)vq->driver_addr,
> @@ -130,8 +166,20 @@ static const struct vdpa_config_ops vdpasim_batch_co=
nfig_ops;
>  static void vdpasim_work_fn(struct kthread_work *work)
>  {
>         struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
> +       struct mm_struct *mm =3D vdpasim->mm_bound;
> +
> +       if (mm) {
> +               if (!mmget_not_zero(mm))
> +                       return;
> +               kthread_use_mm(mm);
> +       }
>
>         vdpasim->dev_attr.work_fn(vdpasim);
> +
> +       if (mm) {
> +               kthread_unuse_mm(mm);
> +               mmput(mm);
> +       }
>  }
>
>  struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
> @@ -162,7 +210,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_att=
r *dev_attr,
>         vdpa =3D __vdpa_alloc_device(NULL, ops,
>                                    dev_attr->ngroups, dev_attr->nas,
>                                    dev_attr->alloc_size,
> -                                  dev_attr->name, false);
> +                                  dev_attr->name, use_va);
>         if (IS_ERR(vdpa)) {
>                 ret =3D PTR_ERR(vdpa);
>                 goto err_alloc;
> @@ -582,6 +630,30 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,=
 unsigned int asid,
>         return ret;
>  }
>
> +static int vdpasim_bind_mm(struct vdpa_device *vdpa, struct mm_struct *m=
m)
> +{
> +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> +       struct vdpasim_mm_work mm_work;
> +
> +       mm_work.vdpasim =3D vdpasim;
> +       mm_work.mm_to_bind =3D mm;
> +
> +       vdpasim_worker_change_mm_sync(vdpasim, &mm_work);
> +
> +       return mm_work.ret;
> +}
> +
> +static void vdpasim_unbind_mm(struct vdpa_device *vdpa)
> +{
> +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> +       struct vdpasim_mm_work mm_work;
> +
> +       mm_work.vdpasim =3D vdpasim;
> +       mm_work.mm_to_bind =3D NULL;
> +
> +       vdpasim_worker_change_mm_sync(vdpasim, &mm_work);
> +}
> +
>  static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
>                            u64 iova, u64 size,
>                            u64 pa, u32 perm, void *opaque)
> @@ -678,6 +750,8 @@ static const struct vdpa_config_ops vdpasim_config_op=
s =3D {
>         .set_group_asid         =3D vdpasim_set_group_asid,
>         .dma_map                =3D vdpasim_dma_map,
>         .dma_unmap              =3D vdpasim_dma_unmap,
> +       .bind_mm                =3D vdpasim_bind_mm,
> +       .unbind_mm              =3D vdpasim_unbind_mm,
>         .free                   =3D vdpasim_free,
>  };
>
> @@ -712,6 +786,8 @@ static const struct vdpa_config_ops vdpasim_batch_con=
fig_ops =3D {
>         .get_iova_range         =3D vdpasim_get_iova_range,
>         .set_group_asid         =3D vdpasim_set_group_asid,
>         .set_map                =3D vdpasim_set_map,
> +       .bind_mm                =3D vdpasim_bind_mm,
> +       .unbind_mm              =3D vdpasim_unbind_mm,
>         .free                   =3D vdpasim_free,
>  };
>
> --
> 2.39.2
>

