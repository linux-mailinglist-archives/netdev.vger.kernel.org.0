Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AA8584CA4
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiG2HcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbiG2HcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:32:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 593D97B37F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659079938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2q2utn2CzeOeojEKg/tCXnqvan/YkCeq0ehI4nAHW8=;
        b=b2kqK5R7LopoSA/5QsjfaqrxfxKY0mSuJ8Ob9UCp+eBRUtSTfy7+yxUb5eorOF2Wq3qVZT
        k9FT+i7cfDF286IyUS7TDs6KHZQfjh+ny+ABun0yGooxoRuxAGZwEmSuXfb8nn5FmKQB2Y
        CE9x+u8OdD8UDza39btCHh8AsY/HMco=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-FZiw-x9dPVCHPe1oL7HY8A-1; Fri, 29 Jul 2022 03:32:16 -0400
X-MC-Unique: FZiw-x9dPVCHPe1oL7HY8A-1
Received: by mail-lj1-f198.google.com with SMTP id bx35-20020a05651c19a300b0025e0c4331c6so731740ljb.13
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S2q2utn2CzeOeojEKg/tCXnqvan/YkCeq0ehI4nAHW8=;
        b=ysRACkz/6iLJhiMDRCh0LiaYm2kpM1AiOlEMMt6oNyoUQbQfxfFC7gKMQwyA5EWHgl
         twD4T+cFtKjCBk1FNmGD6JlhKwRmUTyjDHOykSx5pEeWCXM6NyID4XKyUQXXxJootbvE
         wwb47K9m8PmhxXGevRTLkfpq32uYf+qvzrUz7MEmDG9EBefZRDCjEryR/A+RNn5r80cb
         QM26SbzDQ77tnL3BaOzQhiucsHrQK4TO/NhaP/aUYYcdP6p3n3I9A3tY/td8t+oST7iD
         kO6X11lvE8t1rPc4x9H89AHtKTh5X38tG1JDHwhlFYbzZaVunznr0OBHi60vqlmrkMcU
         ajOQ==
X-Gm-Message-State: AJIora9yzojb0JiYGn9BsQBz8y1V7fbAjXijXKYsaVI12OVGL54kJrFH
        FjWK7xx1RewSevUFQ29Z3U4p5kEssCuxqHJQnfTMiJn1pq8bViFekQkGX9b2gm+m9OitiAUVwCa
        CQJr6eOm5JqeBBhW/Z+sDwOG0UdooV7yG
X-Received: by 2002:a19:9145:0:b0:48a:7ee4:5eac with SMTP id y5-20020a199145000000b0048a7ee45eacmr849957lfj.641.1659079934547;
        Fri, 29 Jul 2022 00:32:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR724Z9TIFD4TBShsFS+WI+wVQDzXpDufX5nXFkZ8Tvp62c/qrPU4I1gK/YFs9x7sodZ+Vk2IgowAFkA5+mh0bs=
X-Received: by 2002:a19:9145:0:b0:48a:7ee4:5eac with SMTP id
 y5-20020a199145000000b0048a7ee45eacmr849942lfj.641.1659079934017; Fri, 29 Jul
 2022 00:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
 <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn> <16a232ad-e0a1-fd4c-ae3e-27db168daacb@redhat.com>
 <2a8838c4-2e6f-6de7-dcdc-572699ff3dc9@sjtu.edu.cn>
In-Reply-To: <2a8838c4-2e6f-6de7-dcdc-572699ff3dc9@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 29 Jul 2022 15:32:02 +0800
Message-ID: <CACGkMEuwgZRt=J_2i-XugMZtcG-xZ7ZF1RpTjmErT5+RCcZ1OQ@mail.gmail.com>
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     eperezma <eperezma@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 4:26 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> On 2022/7/26 15:36, Jason Wang wrote:
>
>
> =E5=9C=A8 2022/7/21 16:43, Guo Zhi =E5=86=99=E9=81=93:
>
> Device may not use descriptors in order, for example, NIC and SCSI may
> not call __vhost_add_used_n with buffers in order.  It's the task of
> __vhost_add_used_n to order them.
>
>
>
> I'm not sure this is ture. Having ooo descriptors is probably by design t=
o have better performance.
>
> This might be obvious for device that may have elevator or QOS stuffs.
>
> I suspect the right thing to do here is, for the device that can't perfor=
m better in the case of IN_ORDER, let's simply not offer IN_ORDER (zerocopy=
 or scsi). And for the device we know it can perform better, non-zercopy et=
hernet device we can do that.
>
>
>   This commit reorder the buffers using
> vq->heads, only the batch is begin from the expected start point and is
> continuous can the batch be exposed to driver.  And only writing out a
> single used ring for a batch of descriptors, according to VIRTIO 1.1
> spec.
>
>
>
> So this sounds more like a "workaround" of the device that can't consume =
buffer in order, I suspect it can help in performance.
>
> More below.
>
>
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
>   drivers/vhost/vhost.h |  3 +++
>   2 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826c..e2e77e29f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>       vq->used_flags =3D 0;
>       vq->log_used =3D false;
>       vq->log_addr =3D -1ull;
> +    vq->next_used_head_idx =3D 0;
>       vq->private_data =3D NULL;
>       vq->acked_features =3D 0;
>       vq->acked_backend_features =3D 0;
> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *=
dev)
>                         GFP_KERNEL);
>           if (!vq->indirect || !vq->log || !vq->heads)
>               goto err_nomem;
> +
> +        memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
>       }
>       return 0;
>   @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virt=
queue *vq,
>                   unsigned count)
>   {
>       vring_used_elem_t __user *used;
> +    struct vring_desc desc;
>       u16 old, new;
>       int start;
> +    int begin, end, i;
> +    int copy_n =3D count;
> +
> +    if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>
>
>
> How do you guarantee that ids of heads are contiguous?
>
> There is no need to be contiguous for ids of heads.
>
> For example, I have three buffer { .id =3D 0, 15}, {.id =3D 20, 30} {.id =
=3D 15, 20} for vhost_add_used_n. Then I will let the vq->heads[0].len=3D15=
. vq->heads[15].len=3D5, vq->heads[20].len=3D10 as reorder. Once I found th=
ere is no hold in the batched descriptors. I will expose them to driver.

So spec said:

"If VIRTIO_F_IN_ORDER has been negotiated, driver uses descriptors in
ring order: starting from offset 0 in the table, and wrapping around
at the end of the table."

And

"VIRTIO_F_IN_ORDER(35)This feature indicates that all buffers are used
by the device in the same order in which they have been made
available."

This means your example is not an IN_ORDER device.

The driver should submit buffers (assuming each buffer have one
descriptor) in order {id =3D 0, 15}, {id =3D 1, 30} and {id =3D 2, 20}.

And even if it is submitted in order, we can not use a batch because:

"The skipped buffers (for which no used ring entry was written) are
assumed to have been used (read or written) by the device completely."

This means for TX we are probably ok, but for rx, unless we know the
buffers were written completely, we can't write them in a batch.

I'd suggest to do cross testing for this series:

1) testing vhost IN_ORDER support with DPDK virtio PMD
2) testing virtio IN_ORDER with DPDK vhost-user via testpmd

Thanks


>
>
> +        /* calculate descriptor chain length for each used buffer */
>
>
>
> I'm a little bit confused about this comment, we have heads[i].len for th=
is?
>
> Maybe I should not use vq->heads, some misleading.
>
>
> +        for (i =3D 0; i < count; i++) {
> +            begin =3D heads[i].id;
> +            end =3D begin;
> +            vq->heads[begin].len =3D 0;
>
>
>
> Does this work for e.g RX virtqueue?
>
>
> +            do {
> +                vq->heads[begin].len +=3D 1;
> +                if (unlikely(vhost_get_desc(vq, &desc, end))) {
>
>
>
> Let's try hard to avoid more userspace copy here, it's the source of perf=
ormance regression.
>
> Thanks
>
>
> +                    vq_err(vq, "Failed to get descriptor: idx %d addr %p=
\n",
> +                           end, vq->desc + end);
> +                    return -EFAULT;
> +                }
> +            } while ((end =3D next_desc(vq, &desc)) !=3D -1);
> +        }
> +
> +        count =3D 0;
> +        /* sort and batch continuous used ring entry */
> +        while (vq->heads[vq->next_used_head_idx].len !=3D 0) {
> +            count++;
> +            i =3D vq->next_used_head_idx;
> +            vq->next_used_head_idx =3D (vq->next_used_head_idx +
> +                          vq->heads[vq->next_used_head_idx].len)
> +                          % vq->num;
> +            vq->heads[i].len =3D 0;
> +        }
> +        /* only write out a single used ring entry with the id correspon=
ding
> +         * to the head entry of the descriptor chain describing the last=
 buffer
> +         * in the batch.
> +         */
> +        heads[0].id =3D i;
> +        copy_n =3D 1;
> +    }
>         start =3D vq->last_used_idx & (vq->num - 1);
>       used =3D vq->used->ring + start;
> -    if (vhost_put_used(vq, heads, start, count)) {
> +    if (vhost_put_used(vq, heads, start, copy_n)) {
>           vq_err(vq, "Failed to write used");
>           return -EFAULT;
>       }
> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, st=
ruct vring_used_elem *heads,
>         start =3D vq->last_used_idx & (vq->num - 1);
>       n =3D vq->num - start;
> -    if (n < count) {
> +    if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>           r =3D __vhost_add_used_n(vq, heads, n);
>           if (r < 0)
>               return r;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index d9109107a..7b2c0fbb5 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
>       bool log_used;
>       u64 log_addr;
>   +    /* Sort heads in order */
> +    u16 next_used_head_idx;
> +
>       struct iovec iov[UIO_MAXIOV];
>       struct iovec iotlb_iov[64];
>       struct iovec *indirect;
>
>
>

