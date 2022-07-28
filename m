Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E29583AEF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbiG1JE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbiG1JE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:04:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3396365658
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658999095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DE+7ye1yGql++GLaeEI3m8GcZZJm0NhK1cN8F4iHjXQ=;
        b=FMLbsOzx/7NpuYdUR+aM6x/EiREVV9OQawtWKM8Xg7TIloCTZz+OS/rUEG8I1MG7HXMdC1
        ahkSeTcOlY2Rw0ZYaHT0Kk1sCCuToOwE1hZ49NorSAJ5PcasnhNLxeytSC3t490QfQWPG6
        WixxzG+pJt6DkI4GMQ4nDbo+UgqY8Z4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-455Eg0RAOWqVmM6u9bu6Mg-1; Thu, 28 Jul 2022 05:04:49 -0400
X-MC-Unique: 455Eg0RAOWqVmM6u9bu6Mg-1
Received: by mail-ed1-f70.google.com with SMTP id i5-20020a05640242c500b0043c17424381so704304edc.13
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DE+7ye1yGql++GLaeEI3m8GcZZJm0NhK1cN8F4iHjXQ=;
        b=yoqY/a+T4LOhjfk9ASXrg45LCmyJfRBL7NM7VePL9jJd8/ry/kQMzS3O54oOaEzRNz
         R3+3W+T/kFWhhwkN22hz7XmdRyCXPLFJ+g8MNZNjGiepjhn/z1mMbbMEk8CQl9lnbcaw
         y06NGB6ui7QOAazaKvBPup2Ia0i9rRC2D4soa6BDaPGXpm6P2Y2zOZE91/zNgdpJqOgP
         S0Pf7g50uS7KYncIShb7hTqVsqbXJu9VN1y0ZMbiewwX5tPZu8k3t9bSr8Cyv/yxURG0
         w06cO92p3mqGJiVifWrnvv0MdKtYFMy99MvD/3+cULWUNg0GHGG5xX5kShq5fQ26Ul0o
         Bnvw==
X-Gm-Message-State: AJIora8q0huhPMx2PwhFVDxRcbO7c22nSXQ0fFRB9TcBG9A3sebVLzp8
        FrbLrs6975Q/r2q25JAv2qrRxLn9BdUZMI2p3zX0vosDAWdjegLyqHjb17MVncWWzx2/4XwFfW9
        QsPsftkKgPUbWTPV1svbeW0w099qLrAi7
X-Received: by 2002:a05:6402:e8d:b0:43b:b989:67a7 with SMTP id h13-20020a0564020e8d00b0043bb98967a7mr26870711eda.365.1658999088585;
        Thu, 28 Jul 2022 02:04:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s1w+ifPe5brXP86zsuwWmOU7w3VBKz6YZbGZMkO1Ncvx95MYfD9EAWpCCUuuHrp8ACTACnKlnhDk4GL3uXFGk=
X-Received: by 2002:a05:6402:e8d:b0:43b:b989:67a7 with SMTP id
 h13-20020a0564020e8d00b0043bb98967a7mr26870656eda.365.1658999088045; Thu, 28
 Jul 2022 02:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-17-xuanzhuo@linux.alibaba.com> <15aa26f2-f8af-5dbd-f2b2-9270ad873412@redhat.com>
 <1658907413.1860468-2-xuanzhuo@linux.alibaba.com> <CACGkMEvxsOfiiaWWAR8P68GY1yfwgTvaAbHk1JF7pTw-o2k25w@mail.gmail.com>
 <1658992162.584327-1-xuanzhuo@linux.alibaba.com> <CACGkMEv-KYieHKXY_Qn0nfcnLMOSF=TowF5PwLKOxESL3KQ40Q@mail.gmail.com>
 <1658995783.1026692-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1658995783.1026692-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Jul 2022 17:04:36 +0800
Message-ID: <CACGkMEv6Ptn4zj_F-ww3Nay-VPmCNrXLaf5U98PvupAvo44FpA@mail.gmail.com>
Subject: Re: [PATCH v13 16/42] virtio_ring: split: introduce virtqueue_resize_split()
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        Kangjie Xu <kangjie.xu@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 4:18 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Thu, 28 Jul 2022 15:42:50 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> > On Thu, Jul 28, 2022 at 3:24 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Thu, 28 Jul 2022 10:38:51 +0800, Jason Wang <jasowang@redhat.com> =
wrote:
> > > > On Wed, Jul 27, 2022 at 3:44 PM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
> > > > >
> > > > > On Wed, 27 Jul 2022 11:12:19 +0800, Jason Wang <jasowang@redhat.c=
om> wrote:
> > > > > >
> > > > > > =E5=9C=A8 2022/7/26 15:21, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > > > virtio ring split supports resize.
> > > > > > >
> > > > > > > Only after the new vring is successfully allocated based on t=
he new num,
> > > > > > > we will release the old vring. In any case, an error is retur=
ned,
> > > > > > > indicating that the vring still points to the old vring.
> > > > > > >
> > > > > > > In the case of an error, re-initialize(virtqueue_reinit_split=
()) the
> > > > > > > virtqueue to ensure that the vring can be used.
> > > > > > >
> > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > > ---
> > > > > > >   drivers/virtio/virtio_ring.c | 34 +++++++++++++++++++++++++=
+++++++++
> > > > > > >   1 file changed, 34 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/vi=
rtio_ring.c
> > > > > > > index b6fda91c8059..58355e1ac7d7 100644
> > > > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > > > @@ -220,6 +220,7 @@ static struct virtqueue *__vring_new_virt=
queue(unsigned int index,
> > > > > > >                                            void (*callback)(s=
truct virtqueue *),
> > > > > > >                                            const char *name);
> > > > > > >   static struct vring_desc_extra *vring_alloc_desc_extra(unsi=
gned int num);
> > > > > > > +static void vring_free(struct virtqueue *_vq);
> > > > > > >
> > > > > > >   /*
> > > > > > >    * Helpers.
> > > > > > > @@ -1117,6 +1118,39 @@ static struct virtqueue *vring_create_=
virtqueue_split(
> > > > > > >     return vq;
> > > > > > >   }
> > > > > > >
> > > > > > > +static int virtqueue_resize_split(struct virtqueue *_vq, u32=
 num)
> > > > > > > +{
> > > > > > > +   struct vring_virtqueue_split vring_split =3D {};
> > > > > > > +   struct vring_virtqueue *vq =3D to_vvq(_vq);
> > > > > > > +   struct virtio_device *vdev =3D _vq->vdev;
> > > > > > > +   int err;
> > > > > > > +
> > > > > > > +   err =3D vring_alloc_queue_split(&vring_split, vdev, num,
> > > > > > > +                                 vq->split.vring_align,
> > > > > > > +                                 vq->split.may_reduce_num);
> > > > > > > +   if (err)
> > > > > > > +           goto err;
> > > > > >
> > > > > >
> > > > > > I think we don't need to do anything here?
> > > > >
> > > > > Am I missing something?
> > > >
> > > > I meant it looks to me most of the virtqueue_reinit() is unnecessar=
y.
> > > > We probably only need to reinit avail/used idx there.
> > >
> > >
> > > In this function, we can indeed remove some code.
> > >
> > > >       static void virtqueue_reinit_split(struct vring_virtqueue *vq=
)
> > > >       {
> > > >               int size, i;
> > > >
> > > >               memset(vq->split.vring.desc, 0, vq->split.queue_size_=
in_bytes);
> > > >
> > > >               size =3D sizeof(struct vring_desc_state_split) * vq->=
split.vring.num;
> > > >               memset(vq->split.desc_state, 0, size);
> > > >
> > > >               size =3D sizeof(struct vring_desc_extra) * vq->split.=
vring.num;
> > > >               memset(vq->split.desc_extra, 0, size);
> > >
> > > These memsets can be removed, and theoretically it will not cause any
> > > exceptions.
> >
> > Yes, otherwise we have bugs in detach_buf().
> >
> > >
> > > >
> > > >
> > > >
> > > >               for (i =3D 0; i < vq->split.vring.num - 1; i++)
> > > >                       vq->split.desc_extra[i].next =3D i + 1;
> > >
> > > This can also be removed, but we need to record free_head that will b=
een update
> > > inside virtqueue_init().
> >
> > We can simply keep free_head unchanged? Otherwise it's a bug somewhere =
I guess.
> >
> >
> > >
> > > >
> > > >               virtqueue_init(vq, vq->split.vring.num);
> > >
> > > There are some operations in this, which can also be skipped, such as=
 setting
> > > use_dma_api. But I think calling this function directly will be more =
convenient
> > > for maintenance.
> >
> > I don't see anything that is necessary here.
>
> These three are currently inside virtqueue_init()
>
> vq->last_used_idx =3D 0;
> vq->event_triggered =3D false;
> vq->num_added =3D 0;

Right. Let's keep it there.

(Though it's kind of strange that the last_used_idx is not initialized
at the same place with avail_idx/flags_shadow, we can optimize it on
top).

Thanks

>
> Thanks.
>
>
> >
> > >
> > >
> > > >               virtqueue_vring_init_split(&vq->split, vq);
> > >
> > > virtqueue_vring_init_split() is necessary.
> >
> > Right.
> >
> > >
> > > >       }
> > >
> > > Another method, we can take out all the variables to be reinitialized
> > > separately, and repackage them into a new function. I don=E2=80=99t t=
hink it=E2=80=99s worth
> > > it, because this path will only be reached if the memory allocation f=
ails, which
> > > is a rare occurrence. In this case, doing so will increase the cost o=
f
> > > maintenance. If you think so also, I will remove the above memset in =
the next
> > > version.
> >
> > I agree.
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > >
> > > > > >
> > > > > > > +
> > > > > > > +   err =3D vring_alloc_state_extra_split(&vring_split);
> > > > > > > +   if (err) {
> > > > > > > +           vring_free_split(&vring_split, vdev);
> > > > > > > +           goto err;
> > > > > >
> > > > > >
> > > > > > I suggest to move vring_free_split() into a dedicated error lab=
el.
> > > > >
> > > > > Will change.
> > > > >
> > > > > Thanks.
> > > > >
> > > > >
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > >
> > > > > > > +   }
> > > > > > > +
> > > > > > > +   vring_free(&vq->vq);
> > > > > > > +
> > > > > > > +   virtqueue_vring_init_split(&vring_split, vq);
> > > > > > > +
> > > > > > > +   virtqueue_init(vq, vring_split.vring.num);
> > > > > > > +   virtqueue_vring_attach_split(vq, &vring_split);
> > > > > > > +
> > > > > > > +   return 0;
> > > > > > > +
> > > > > > > +err:
> > > > > > > +   virtqueue_reinit_split(vq);
> > > > > > > +   return -ENOMEM;
> > > > > > > +}
> > > > > > > +
> > > > > > >
> > > > > > >   /*
> > > > > > >    * Packed ring specific functions - *_packed().
> > > > > >
> > > > >
> > > >
> > >
> >
>

