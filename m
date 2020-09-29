Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534DE27D198
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgI2OlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:41:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729460AbgI2OlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601390464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l0ySg0110w8OW3invBGriU5wyED1HKE44VPvaG4UaUQ=;
        b=Ymfq6FE3n2XN+KJ1topJKR8EveicYSu2SaZGCNVG74hRhLqK+zeLZlMJ4MGPbYZBzCynT5
        kPqAl6nUvclnO4DH/wW/dXiQZpFLRis4ZD/Ujd2T+3Ika/4OHa+9PvM2km7WOJW8Lq/ZvS
        /BRMGoMn0rp31Wwx7aHNJaxjPD5EkVU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-ysnOAZ_GPS2UjR4K6seCUA-1; Tue, 29 Sep 2020 10:40:58 -0400
X-MC-Unique: ysnOAZ_GPS2UjR4K6seCUA-1
Received: by mail-qt1-f197.google.com with SMTP id m13so3115131qtu.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 07:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l0ySg0110w8OW3invBGriU5wyED1HKE44VPvaG4UaUQ=;
        b=TMtkHfuXL4IS/ZkKmW8NGmbBSkpPkHaf0dvikcnsNOjQ3Mjw6j++LYzc03AaSxYNdd
         6wcVJom7u/lSAPKEf0XM8xTH1GfSSKZsnlJcNUrLMsCSqRrwRPSAD3HQZr6U/3hX7+bg
         LGEFgMQ8IzDNpeAzfSuPXhj5V26vU3aiYO1lMa9Vdp/wY/LElFb4yNWNqVarygIj2p48
         0cmu6eE+UUZ48HfTbTke3HSAXSfXaEjkHvoTQnIpE/cowioZYUj3GLJXRNIMH9PCPEd/
         c7t/YCmMnjGYtLo+0Syk7ru11Nqb+j5J9S4XZfhmvOWB24sXPv7NTnDVTiMRIPZ6Omfo
         nB8A==
X-Gm-Message-State: AOAM533iSU6yk82dcYuScJWUigA90iZkJxB0eIeE0+xIBRpze9CRzQ6A
        VBEjYv8hYpO3Q6/BbRlRmmAbOITqggu9Gf/QGC50k7BUhLqJ8rqjt3Q23lGKGCVQapfFARyrwGc
        fas1r7x25/TNrMUJB7gY5tLsXSgAehtG2
X-Received: by 2002:a05:620a:b1a:: with SMTP id t26mr4681277qkg.353.1601390456420;
        Tue, 29 Sep 2020 07:40:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGXRiKbOouJmxqcaB852zvTvNt3brwJyM0RvvbA+jNO5LTY2XthmJfteBTC1EPfiJm02VqdiHjaCBPFS/38Hw=
X-Received: by 2002:a05:620a:b1a:: with SMTP id t26mr4681238qkg.353.1601390456048;
 Tue, 29 Sep 2020 07:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200924032125.18619-1-jasowang@redhat.com> <20200924032125.18619-14-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-14-jasowang@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 29 Sep 2020 16:40:19 +0200
Message-ID: <CAJaqyWf5tP9DtSc1JP_c4iOkHeVhnEm=kpW4Cv3cMLXfm71h0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 13/24] vhost-vdpa: introduce ASID based IOTLB
To:     Jason Wang <jasowang@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Miller <rob.miller@broadcom.com>,
        lingshan.zhu@intel.com, Harpreet Singh Anand <hanand@xilinx.com>,
        mhabets@solarflare.com, eli@mellanox.com,
        Adrian Moreno Zapata <amorenoz@redhat.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 5:24 AM Jason Wang <jasowang@redhat.com> wrote:
>
> This patch introduces the support of ASID based IOTLB by tagging IOTLB
> with a unique ASID. This is a must for supporting ASID based vhost
> IOTLB API by the following patches.
>
> IOTLB were stored in a hlist and new IOTLB will be allocated when a
> new ASID is seen via IOTLB API and destoryed when there's no mapping
> associated with an ASID.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 94 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 72 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 6552987544d7..1ba7e95619b5 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -34,13 +34,21 @@ enum {
>
>  #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
>
> +#define VHOST_VDPA_IOTLB_BUCKETS 16
> +
> +struct vhost_vdpa_as {
> +       struct hlist_node hash_link;
> +       struct vhost_iotlb iotlb;
> +       u32 id;
> +};
> +
>  struct vhost_vdpa {
>         struct vhost_dev vdev;
>         struct iommu_domain *domain;
>         struct vhost_virtqueue *vqs;
>         struct completion completion;
>         struct vdpa_device *vdpa;
> -       struct vhost_iotlb *iotlb;
> +       struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
>         struct device dev;
>         struct cdev cdev;
>         atomic_t opened;
> @@ -49,12 +57,64 @@ struct vhost_vdpa {
>         int minor;
>         struct eventfd_ctx *config_ctx;
>         int in_batch;
> +       int used_as;

Hi!

The variable `used_as` is not used anywhere outside this commit, and
in this commit is only tracking the number os AS added, not being able
to query it or using it by limiting them or anything like that.

If I'm right, could we consider deleting it? Or am I missing some usage of it?

I smoke tested all the series deleting that variable and everything
seems right to me.

Thanks!

>  };
>
>  static DEFINE_IDA(vhost_vdpa_ida);
>
>  static dev_t vhost_vdpa_major;
>
> +static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
> +       struct vhost_vdpa_as *as;
> +
> +       hlist_for_each_entry(as, head, hash_link)
> +               if (as->id == asid)
> +                       return as;
> +
> +       return NULL;
> +}
> +
> +static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
> +       struct vhost_vdpa_as *as;
> +
> +       if (asid_to_as(v, asid))
> +               return NULL;
> +
> +       as = kmalloc(sizeof(*as), GFP_KERNEL);
> +       if (!as)
> +               return NULL;
> +
> +       vhost_iotlb_init(&as->iotlb, 0, 0);
> +       as->id = asid;
> +       hlist_add_head(&as->hash_link, head);
> +       ++v->used_as;
> +
> +       return as;
> +}
> +
> +static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct vhost_vdpa_as *as = asid_to_as(v, asid);
> +
> +       /* Remove default address space is not allowed */
> +       if (asid == 0)
> +               return -EINVAL;
> +
> +       if (!as)
> +               return -EINVAL;
> +
> +       hlist_del(&as->hash_link);
> +       vhost_iotlb_reset(&as->iotlb);
> +       kfree(as);
> +       --v->used_as;
> +
> +       return 0;
> +}
> +
>  static void handle_vq_kick(struct vhost_work *work)
>  {
>         struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> @@ -513,15 +573,6 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
>         }
>  }
>
> -static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
> -{
> -       struct vhost_iotlb *iotlb = v->iotlb;
> -
> -       vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
> -       kfree(v->iotlb);
> -       v->iotlb = NULL;
> -}
> -
>  static int perm_to_iommu_flags(u32 perm)
>  {
>         int flags = 0;
> @@ -681,7 +732,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>         struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>         struct vdpa_device *vdpa = v->vdpa;
>         const struct vdpa_config_ops *ops = vdpa->config;
> -       struct vhost_iotlb *iotlb = v->iotlb;
> +       struct vhost_vdpa_as *as = asid_to_as(v, 0);
> +       struct vhost_iotlb *iotlb = &as->iotlb;
>         int r = 0;
>
>         if (asid != 0)
> @@ -775,6 +827,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
>  {
>         vhost_dev_cleanup(&v->vdev);
>         kfree(v->vdev.vqs);
> +       vhost_vdpa_remove_as(v, 0);
>  }
>
>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
> @@ -807,23 +860,18 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>         vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>                        vhost_vdpa_process_iotlb_msg);
>
> -       dev->iotlb = vhost_iotlb_alloc(0, 0);
> -       if (!dev->iotlb) {
> -               r = -ENOMEM;
> -               goto err_init_iotlb;
> -       }
> +       if (!vhost_vdpa_alloc_as(v, 0))
> +               goto err_alloc_as;
>
>         r = vhost_vdpa_alloc_domain(v);
>         if (r)
> -               goto err_alloc_domain;
> +               goto err_alloc_as;
>
>         filep->private_data = v;
>
>         return 0;
>
> -err_alloc_domain:
> -       vhost_vdpa_iotlb_free(v);
> -err_init_iotlb:
> +err_alloc_as:
>         vhost_vdpa_cleanup(v);
>  err:
>         atomic_dec(&v->opened);
> @@ -851,7 +899,6 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>         filep->private_data = NULL;
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> -       vhost_vdpa_iotlb_free(v);
>         vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
>         vhost_vdpa_clean_irq(v);
> @@ -950,7 +997,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>         const struct vdpa_config_ops *ops = vdpa->config;
>         struct vhost_vdpa *v;
>         int minor;
> -       int r;
> +       int i, r;
>
>         /* Only support 1 address space */
>         if (vdpa->ngroups != 1)
> @@ -1002,6 +1049,9 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>         init_completion(&v->completion);
>         vdpa_set_drvdata(vdpa, v);
>
> +       for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
> +               INIT_HLIST_HEAD(&v->as[i]);
> +
>         return 0;
>
>  err:
> --
> 2.20.1
>

