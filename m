Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8AD58640D
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 08:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiHAG1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 02:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239818AbiHAG1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 02:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D52613CE5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659335264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UyyYryD7QGgOS3XQPZyq6yB64pJtotrkijoRHszU24s=;
        b=NC11EgtDcpYwTqwdW5Z75q4pstlDo5xdo9YKp+vRmdpleQ2DbzZ35lZ1sVBgtDOQHYNJfl
        kpl1hWMR7aEXh/7YeXPCdhP/6UAltmGh6wBUoVLflaKKwd/hWhVP8Xvo6t6ZFRtLFW85h5
        ybkTCTKtoMJheBz9BE515KQA2qrL9WQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-3ZeVB35uO2WeBi3o5hSbAQ-1; Mon, 01 Aug 2022 02:27:42 -0400
X-MC-Unique: 3ZeVB35uO2WeBi3o5hSbAQ-1
Received: by mail-lf1-f70.google.com with SMTP id a19-20020a19f813000000b0048a7379e38bso3070348lff.5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UyyYryD7QGgOS3XQPZyq6yB64pJtotrkijoRHszU24s=;
        b=B/t4kT/5o2DHVClzrnNA8L6nbhLP5MEVyJwhxZQjLxWPE5rDF6h+3rWP+NajU7kvhN
         du178fp4Gy1XeMhLiI9LVUMFO1xHXJUAIa/Ygf0RjFS4FuCE9EnfLcl+3sKtaWcBQsLs
         f62ZlQRgOUSRQZ3bq9lr/gRyzJjEYpKF9/Xc92xB5y/bssfxQc2nASuoCb1H4h6bHhm9
         uNVE4DENUnovvBpiPdPBRVoc5iQzqbaxnz6jS0VfRBE/IKCHN0s7T6S+pMB6qIbC0Gks
         oI5xU0yzO1p/C8xO99Jt8jk5GGv/RL/wMH7bR7E6zB9NRGIkBssF7lTHTM696H/Q+5wg
         UpXg==
X-Gm-Message-State: ACgBeo0BbhbE9t/+IxkwR32ep/U0uD7JbavtWB/plqJmzWFNcP8GN6br
        tPhH9gK2q+dmqI2ugCyXOp8aiyE7WY/9+YrCQI1kqxgjFwxvqkfjnhe5yC64w6shMyk4Rtuapkq
        eo2Xn9/6y25KLWEAXHHm2YaDjOj7iO/7S
X-Received: by 2002:ac2:43b0:0:b0:48b:1eb:d1e5 with SMTP id t16-20020ac243b0000000b0048b01ebd1e5mr272787lfl.641.1659335261113;
        Sun, 31 Jul 2022 23:27:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7kLCPxnca4MZdlMlO6mFwl8I9LgAWtroXVyXQq60uRjcCEDVvYfqEqtkyly+cwNyUmf+jb+aYHvUNOq8R+JIA=
X-Received: by 2002:ac2:43b0:0:b0:48b:1eb:d1e5 with SMTP id
 t16-20020ac243b0000000b0048b01ebd1e5mr272773lfl.641.1659335260842; Sun, 31
 Jul 2022 23:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-17-xuanzhuo@linux.alibaba.com> <15aa26f2-f8af-5dbd-f2b2-9270ad873412@redhat.com>
 <1658907413.1860468-2-xuanzhuo@linux.alibaba.com> <CACGkMEvxsOfiiaWWAR8P68GY1yfwgTvaAbHk1JF7pTw-o2k25w@mail.gmail.com>
 <1658992162.584327-1-xuanzhuo@linux.alibaba.com> <CACGkMEv-KYieHKXY_Qn0nfcnLMOSF=TowF5PwLKOxESL3KQ40Q@mail.gmail.com>
 <1658995783.1026692-1-xuanzhuo@linux.alibaba.com> <CACGkMEv6Ptn4zj_F-ww3Nay-VPmCNrXLaf5U98PvupAvo44FpA@mail.gmail.com>
 <1659001321.5738833-2-xuanzhuo@linux.alibaba.com> <CACGkMEvcRxbqJ01sjC50muW3cQJiJKUJW+67QrsOP662FCgi0g@mail.gmail.com>
 <1659334300.4209104-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1659334300.4209104-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 1 Aug 2022 14:27:29 +0800
Message-ID: <CACGkMEu=PSnZWKbG8jQW2ZfoZAjOOGXkMvwrx5X+=fCFzEQqiw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 2:13 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote=
:
>
> On Mon, 1 Aug 2022 12:49:12 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Thu, Jul 28, 2022 at 7:27 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Thu, 28 Jul 2022 17:04:36 +0800, Jason Wang <jasowang@redhat.com> =
wrote:
> > > > On Thu, Jul 28, 2022 at 4:18 PM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
> > > > >
> > > > > On Thu, 28 Jul 2022 15:42:50 +0800, Jason Wang <jasowang@redhat.c=
om> wrote:
> > > > > > On Thu, Jul 28, 2022 at 3:24 PM Xuan Zhuo <xuanzhuo@linux.aliba=
ba.com> wrote:
> > > > > > >
> > > > > > > On Thu, 28 Jul 2022 10:38:51 +0800, Jason Wang <jasowang@redh=
at.com> wrote:
> > > > > > > > On Wed, Jul 27, 2022 at 3:44 PM Xuan Zhuo <xuanzhuo@linux.a=
libaba.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, 27 Jul 2022 11:12:19 +0800, Jason Wang <jasowang@=
redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > =E5=9C=A8 2022/7/26 15:21, Xuan Zhuo =E5=86=99=E9=81=93=
:
> > > > > > > > > > > virtio ring split supports resize.
> > > > > > > > > > >
> > > > > > > > > > > Only after the new vring is successfully allocated ba=
sed on the new num,
> > > > > > > > > > > we will release the old vring. In any case, an error =
is returned,
> > > > > > > > > > > indicating that the vring still points to the old vri=
ng.
> > > > > > > > > > >
> > > > > > > > > > > In the case of an error, re-initialize(virtqueue_rein=
it_split()) the
> > > > > > > > > > > virtqueue to ensure that the vring can be used.
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > > > ---
> > > > > > > > > > >   drivers/virtio/virtio_ring.c | 34 +++++++++++++++++=
+++++++++++++++++
> > > > > > > > > > >   1 file changed, 34 insertions(+)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/v=
irtio/virtio_ring.c
> > > > > > > > > > > index b6fda91c8059..58355e1ac7d7 100644
> > > > > > > > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > > > > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > > > > > > > @@ -220,6 +220,7 @@ static struct virtqueue *__vring_=
new_virtqueue(unsigned int index,
> > > > > > > > > > >                                            void (*cal=
lback)(struct virtqueue *),
> > > > > > > > > > >                                            const char=
 *name);
> > > > > > > > > > >   static struct vring_desc_extra *vring_alloc_desc_ex=
tra(unsigned int num);
> > > > > > > > > > > +static void vring_free(struct virtqueue *_vq);
> > > > > > > > > > >
> > > > > > > > > > >   /*
> > > > > > > > > > >    * Helpers.
> > > > > > > > > > > @@ -1117,6 +1118,39 @@ static struct virtqueue *vring=
_create_virtqueue_split(
> > > > > > > > > > >     return vq;
> > > > > > > > > > >   }
> > > > > > > > > > >
> > > > > > > > > > > +static int virtqueue_resize_split(struct virtqueue *=
_vq, u32 num)
> > > > > > > > > > > +{
> > > > > > > > > > > +   struct vring_virtqueue_split vring_split =3D {};
> > > > > > > > > > > +   struct vring_virtqueue *vq =3D to_vvq(_vq);
> > > > > > > > > > > +   struct virtio_device *vdev =3D _vq->vdev;
> > > > > > > > > > > +   int err;
> > > > > > > > > > > +
> > > > > > > > > > > +   err =3D vring_alloc_queue_split(&vring_split, vde=
v, num,
> > > > > > > > > > > +                                 vq->split.vring_ali=
gn,
> > > > > > > > > > > +                                 vq->split.may_reduc=
e_num);
> > > > > > > > > > > +   if (err)
> > > > > > > > > > > +           goto err;
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > I think we don't need to do anything here?
> > > > > > > > >
> > > > > > > > > Am I missing something?
> > > > > > > >
> > > > > > > > I meant it looks to me most of the virtqueue_reinit() is un=
necessary.
> > > > > > > > We probably only need to reinit avail/used idx there.
> > > > > > >
> > > > > > >
> > > > > > > In this function, we can indeed remove some code.
> > > > > > >
> > > > > > > >       static void virtqueue_reinit_split(struct vring_virtq=
ueue *vq)
> > > > > > > >       {
> > > > > > > >               int size, i;
> > > > > > > >
> > > > > > > >               memset(vq->split.vring.desc, 0, vq->split.que=
ue_size_in_bytes);
> > > > > > > >
> > > > > > > >               size =3D sizeof(struct vring_desc_state_split=
) * vq->split.vring.num;
> > > > > > > >               memset(vq->split.desc_state, 0, size);
> > > > > > > >
> > > > > > > >               size =3D sizeof(struct vring_desc_extra) * vq=
->split.vring.num;
> > > > > > > >               memset(vq->split.desc_extra, 0, size);
> > > > > > >
> > > > > > > These memsets can be removed, and theoretically it will not c=
ause any
> > > > > > > exceptions.
> > > > > >
> > > > > > Yes, otherwise we have bugs in detach_buf().
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > >               for (i =3D 0; i < vq->split.vring.num - 1; i+=
+)
> > > > > > > >                       vq->split.desc_extra[i].next =3D i + =
1;
> > > > > > >
> > > > > > > This can also be removed, but we need to record free_head tha=
t will been update
> > > > > > > inside virtqueue_init().
> > > > > >
> > > > > > We can simply keep free_head unchanged? Otherwise it's a bug so=
mewhere I guess.
> > > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > >               virtqueue_init(vq, vq->split.vring.num);
> > > > > > >
> > > > > > > There are some operations in this, which can also be skipped,=
 such as setting
> > > > > > > use_dma_api. But I think calling this function directly will =
be more convenient
> > > > > > > for maintenance.
> > > > > >
> > > > > > I don't see anything that is necessary here.
> > > > >
> > > > > These three are currently inside virtqueue_init()
> > > > >
> > > > > vq->last_used_idx =3D 0;
> > > > > vq->event_triggered =3D false;
> > > > > vq->num_added =3D 0;
> > > >
> > > > Right. Let's keep it there.
> > > >
> > > > (Though it's kind of strange that the last_used_idx is not initiali=
zed
> > > > at the same place with avail_idx/flags_shadow, we can optimize it o=
n
> > > > top).
> > >
> > > I put free_head =3D 0 in the attach function, it is only necessary to=
 set
> > > free_head =3D 0 when a new state/extra is attached.
> >
> > Ok, so I meant I tend to keep it to make this series converge soon :)
>
>
> Ok, other than this, and what we discussed, no more fixes will be added.
>
> Thanks.

Ack

Thanks

>
>
> >
> > We can do optimization on top anyhow.
> >
> > Thanks
> >
> > >
> > > In this way, when we call virtqueue_init(), we don't have to worry ab=
out
> > > free_head being modified.
> > >
> > > Rethinking this problem, I think virtqueue_init() can be rewritten an=
d some
> > > variables that will not change are removed from it. (use_dma_api, eve=
nt,
> > > weak_barriers)
> > >
> > > +static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
> > > +{
> > > +       vq->vq.num_free =3D num;
> > > +
> > > +       if (vq->packed_ring)
> > > +               vq->last_used_idx =3D 0 | (1 << VRING_PACKED_EVENT_F_=
WRAP_CTR);
> > > +       else
> > > +               vq->last_used_idx =3D 0;
> > > +
> > > +       vq->event_triggered =3D false;
> > > +       vq->num_added =3D 0;
> > > +
> > > +#ifdef DEBUG
> > > +       vq->in_use =3D false;
> > > +       vq->last_add_time_valid =3D false;
> > > +#endif
> > > +}
> > > +
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Thanks.
> > > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > >               virtqueue_vring_init_split(&vq->split, vq);
> > > > > > >
> > > > > > > virtqueue_vring_init_split() is necessary.
> > > > > >
> > > > > > Right.
> > > > > >
> > > > > > >
> > > > > > > >       }
> > > > > > >
> > > > > > > Another method, we can take out all the variables to be reini=
tialized
> > > > > > > separately, and repackage them into a new function. I don=E2=
=80=99t think it=E2=80=99s worth
> > > > > > > it, because this path will only be reached if the memory allo=
cation fails, which
> > > > > > > is a rare occurrence. In this case, doing so will increase th=
e cost of
> > > > > > > maintenance. If you think so also, I will remove the above me=
mset in the next
> > > > > > > version.
> > > > > >
> > > > > > I agree.
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > >
> > > > > > > Thanks.
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > >
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > +
> > > > > > > > > > > +   err =3D vring_alloc_state_extra_split(&vring_spli=
t);
> > > > > > > > > > > +   if (err) {
> > > > > > > > > > > +           vring_free_split(&vring_split, vdev);
> > > > > > > > > > > +           goto err;
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > I suggest to move vring_free_split() into a dedicated e=
rror label.
> > > > > > > > >
> > > > > > > > > Will change.
> > > > > > > > >
> > > > > > > > > Thanks.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > +   }
> > > > > > > > > > > +
> > > > > > > > > > > +   vring_free(&vq->vq);
> > > > > > > > > > > +
> > > > > > > > > > > +   virtqueue_vring_init_split(&vring_split, vq);
> > > > > > > > > > > +
> > > > > > > > > > > +   virtqueue_init(vq, vring_split.vring.num);
> > > > > > > > > > > +   virtqueue_vring_attach_split(vq, &vring_split);
> > > > > > > > > > > +
> > > > > > > > > > > +   return 0;
> > > > > > > > > > > +
> > > > > > > > > > > +err:
> > > > > > > > > > > +   virtqueue_reinit_split(vq);
> > > > > > > > > > > +   return -ENOMEM;
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > >
> > > > > > > > > > >   /*
> > > > > > > > > > >    * Packed ring specific functions - *_packed().
> > > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > > >
> > >
> >
>

