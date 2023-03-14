Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41C36B8A60
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjCNFcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjCNFc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:32:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1950F8FBC5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678771905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOakZAQ0JjemJWAizphBYVVMpcV7pcPHKZlLyAecItY=;
        b=SQfkpjwYz3QTZBvlGlGcsXOm148etnRIdpIjUIzUCOpaAqrZgHXkNXfSEy6WohoryjDHAF
        Kd5FPKrDT5QfccAW+SIp+gbCUHPHH9iqoI/BqwOW/w3lpiUWIgmS592V6SbTit54omit2U
        3JLfzzYm05xuNlT9qrRxcNaRTOq4PHw=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-Y0uPEtqHON-Hhg6FNe95QA-1; Tue, 14 Mar 2023 01:31:37 -0400
X-MC-Unique: Y0uPEtqHON-Hhg6FNe95QA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-177b0f40c4eso2932741fac.12
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:31:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678771897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOakZAQ0JjemJWAizphBYVVMpcV7pcPHKZlLyAecItY=;
        b=IHM4/lHUJFpbTt/3erjkPrcpn9aKchTYAl6AMwYGzN2kIN1rrhop4ZZDolPCQRO/dR
         CRu2eQpxpEd0rpPbvDxHHi8yOjvJI4C9X5iJ8MXPCN773rofYprhCoCGiVZ8I4TbSl29
         iNDwFI1iHdZYn+g5P4LDxT8nSBZvXrW1E8yUte3zyIEc8JIp0zTntg7B/q4TUdAFIQSR
         W6jmGS9RTDlU1Nhr4OYnt6U1/64N1t/Mfkym4FQh8CNL6kF5jJznRPJNlGnGaIisIOYm
         GUYbfTA1sWw9U9mWbI1V56jmJ3p03Jrgkc9kSuLIwlgitiCpHZ0wNxrnh568TEaMixmj
         TGGQ==
X-Gm-Message-State: AO0yUKWYZ2yvG1sfgnY5UYYTgd1Azo+iKl6vGatHrA2Trues75qCKKHH
        05WWvuwG5Lc1SefZSIXC+y7jkDoKuQmKgbfp823l1gVmGT4PI6K0rseCtddeqhb+hMVcU0oX3aR
        NcmAaSB7JCewRf47KYQiGLBxJXlcERIc1
X-Received: by 2002:a05:6808:143:b0:383:fef9:6cac with SMTP id h3-20020a056808014300b00383fef96cacmr12601963oie.9.1678771897151;
        Mon, 13 Mar 2023 22:31:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set9tCKmTMTA//05Xmwt8lO0T8qP9TsZu/f7e0D5UVkMX3KSKeiBkzgin/ted2gP3OO7h+LmYV5SzCywWup/8Pcs=
X-Received: by 2002:a05:6808:143:b0:383:fef9:6cac with SMTP id
 h3-20020a056808014300b00383fef96cacmr12601955oie.9.1678771896892; Mon, 13 Mar
 2023 22:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-8-sgarzare@redhat.com>
 <CACGkMEuCUBQeg0gLUjBXff=zMf-=qJqhMpdeUvTDk55Gz6tAVA@mail.gmail.com>
In-Reply-To: <CACGkMEuCUBQeg0gLUjBXff=zMf-=qJqhMpdeUvTDk55Gz6tAVA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 13:31:25 +0800
Message-ID: <CACGkMEv=MkGUUP_xv9V5q+gneLm41yKqJXoWp4cYLK8Cf95oUw@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] vdpa_sim: replace the spinlock with a mutex to
 protect the state
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

On Tue, Mar 14, 2023 at 1:29=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Thu, Mar 2, 2023 at 7:35=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
> >
> > The spinlock we use to protect the state of the simulator is sometimes
> > held for a long time (for example, when devices handle requests).
> >
> > This also prevents us from calling functions that might sleep (such as
> > kthread_flush_work() in the next patch), and thus having to release
> > and retake the lock.
> >
> > For these reasons, let's replace the spinlock with a mutex that gives
> > us more flexibility.
> >
> > Suggested-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks

Btw, though it looks fine but we'd better double confirm virtio_vdpa works =
well.

(I think so since there's transport that might sleep).

Thanks

>
> > ---
> >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  4 ++--
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 34 ++++++++++++++--------------
> >  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  4 ++--
> >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  4 ++--
> >  4 files changed, 23 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/v=
dpa_sim.h
> > index ce83f9130a5d..4774292fba8c 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> > @@ -60,8 +60,8 @@ struct vdpasim {
> >         struct kthread_worker *worker;
> >         struct kthread_work work;
> >         struct vdpasim_dev_attr dev_attr;
> > -       /* spinlock to synchronize virtqueue state */
> > -       spinlock_t lock;
> > +       /* mutex to synchronize virtqueue state */
> > +       struct mutex mutex;
> >         /* virtio config according to device type */
> >         void *config;
> >         struct vhost_iotlb *iommu;
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim.c
> > index 6feb29726c2a..a28103a67ae7 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > @@ -166,7 +166,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_a=
ttr *dev_attr,
> >         if (IS_ERR(vdpasim->worker))
> >                 goto err_iommu;
> >
> > -       spin_lock_init(&vdpasim->lock);
> > +       mutex_init(&vdpasim->mutex);
> >         spin_lock_init(&vdpasim->iommu_lock);
> >
> >         dev =3D &vdpasim->vdpa.dev;
> > @@ -275,13 +275,13 @@ static void vdpasim_set_vq_ready(struct vdpa_devi=
ce *vdpa, u16 idx, bool ready)
> >         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
> >         bool old_ready;
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >         old_ready =3D vq->ready;
> >         vq->ready =3D ready;
> >         if (vq->ready && !old_ready) {
> >                 vdpasim_queue_ready(vdpasim, idx);
> >         }
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >  }
> >
> >  static bool vdpasim_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
> > @@ -299,9 +299,9 @@ static int vdpasim_set_vq_state(struct vdpa_device =
*vdpa, u16 idx,
> >         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
> >         struct vringh *vrh =3D &vq->vring;
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >         vrh->last_avail_idx =3D state->split.avail_index;
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         return 0;
> >  }
> > @@ -398,9 +398,9 @@ static u8 vdpasim_get_status(struct vdpa_device *vd=
pa)
> >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >         u8 status;
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >         status =3D vdpasim->status;
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         return status;
> >  }
> > @@ -409,19 +409,19 @@ static void vdpasim_set_status(struct vdpa_device=
 *vdpa, u8 status)
> >  {
> >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >         vdpasim->status =3D status;
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >  }
> >
> >  static int vdpasim_reset(struct vdpa_device *vdpa)
> >  {
> >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >         vdpasim->status =3D 0;
> >         vdpasim_do_reset(vdpasim);
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         return 0;
> >  }
> > @@ -430,9 +430,9 @@ static int vdpasim_suspend(struct vdpa_device *vdpa=
)
> >  {
> >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >         vdpasim->running =3D false;
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         return 0;
> >  }
> > @@ -442,7 +442,7 @@ static int vdpasim_resume(struct vdpa_device *vdpa)
> >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >         int i;
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >         vdpasim->running =3D true;
> >
> >         if (vdpasim->pending_kick) {
> > @@ -453,7 +453,7 @@ static int vdpasim_resume(struct vdpa_device *vdpa)
> >                 vdpasim->pending_kick =3D false;
> >         }
> >
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         return 0;
> >  }
> > @@ -525,14 +525,14 @@ static int vdpasim_set_group_asid(struct vdpa_dev=
ice *vdpa, unsigned int group,
> >
> >         iommu =3D &vdpasim->iommu[asid];
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >
> >         for (i =3D 0; i < vdpasim->dev_attr.nvqs; i++)
> >                 if (vdpasim_get_vq_group(vdpa, i) =3D=3D group)
> >                         vringh_set_iotlb(&vdpasim->vqs[i].vring, iommu,
> >                                          &vdpasim->iommu_lock);
> >
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         return 0;
> >  }
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_s=
im/vdpa_sim_blk.c
> > index eb4897c8541e..568119e1553f 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> > @@ -290,7 +290,7 @@ static void vdpasim_blk_work(struct vdpasim *vdpasi=
m)
> >         bool reschedule =3D false;
> >         int i;
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >
> >         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> >                 goto out;
> > @@ -321,7 +321,7 @@ static void vdpasim_blk_work(struct vdpasim *vdpasi=
m)
> >                 }
> >         }
> >  out:
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         if (reschedule)
> >                 vdpasim_schedule_work(vdpasim);
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_s=
im/vdpa_sim_net.c
> > index e61a9ecbfafe..7ab434592bfe 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> > @@ -201,7 +201,7 @@ static void vdpasim_net_work(struct vdpasim *vdpasi=
m)
> >         u64 rx_drops =3D 0, rx_overruns =3D 0, rx_errors =3D 0, tx_erro=
rs =3D 0;
> >         int err;
> >
> > -       spin_lock(&vdpasim->lock);
> > +       mutex_lock(&vdpasim->mutex);
> >
> >         if (!vdpasim->running)
> >                 goto out;
> > @@ -264,7 +264,7 @@ static void vdpasim_net_work(struct vdpasim *vdpasi=
m)
> >         }
> >
> >  out:
> > -       spin_unlock(&vdpasim->lock);
> > +       mutex_unlock(&vdpasim->mutex);
> >
> >         u64_stats_update_begin(&net->tx_stats.syncp);
> >         net->tx_stats.pkts +=3D tx_pkts;
> > --
> > 2.39.2
> >

