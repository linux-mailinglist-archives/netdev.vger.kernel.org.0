Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D88657FA43
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiGYH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiGYH3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:29:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30BCE12608
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658734151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7V73Urf85bEAl0pJImVws1FSD2o2Nh9wuLCajEhv1dQ=;
        b=Gjv6jeTjD5uidh1vbHcCCmYQVVcCMY6V0dZ+3axcTLjuaUjTvJfNk8Hii8ZGnwrIKwiwMF
        0L/D1HGFsBeOFjS7r5oo6zsMN1H+PbuMpxnueSDoUiwuCMenqjJ6WjHrb5luB01Q/65N5L
        7kA5AMR6QFKk/7ZrfM1RCqYti2/Xikc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-v6ZTD_rpOjisvR4NIWNHFA-1; Mon, 25 Jul 2022 03:29:08 -0400
X-MC-Unique: v6ZTD_rpOjisvR4NIWNHFA-1
Received: by mail-lj1-f198.google.com with SMTP id r4-20020a2e80c4000000b0025e05dbef18so709163ljg.6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7V73Urf85bEAl0pJImVws1FSD2o2Nh9wuLCajEhv1dQ=;
        b=4q7w9CcmjYbQ9UzlPhk8Xs3dBx+UcIUCgV3Ybmfp3V/Nbzs1PQpz3+zn7dh8veYy8p
         Dd7NNG4qkXkdoIGVPo77iUs+gom1dmoXJcyaoBjUSWh8szUS/GLPmqm0z9QeHkqqe0sT
         j46k3GMgVeinG+hKLHFIOJXK0lVWlCKxc2zP1qHE6nH+fsBlXWWdEmVCwZrrvuCqkdyd
         UTYWX52hr3g7ZrkS7swC2IQheo6Qjt2qc9oMlhibulPOLoY75XdJH0jFg3fDenl5OoBo
         82V8vKDr7IOtcJmyWbZFi2c5CwlGyVVyElI91X2BbpRj+FuY8/JFxufHgDUJQhV6hvbk
         Yr2w==
X-Gm-Message-State: AJIora/nYGyC/z5oosN/jVJfw6vVBi3cQBdeVW4c9PkBtNheOj1cMO/t
        uqUW8wXziHhVJs1psTciaxOrvk+BZJ0IT9Z82PE+6iZkdls9FPdmi9K0QI1r5q+hnTKckdnngNP
        xxvgQ+4GS6hgbdRwcqF7UHNLQAmrKP4Nr
X-Received: by 2002:a05:6512:3f0e:b0:48a:5edd:99b2 with SMTP id y14-20020a0565123f0e00b0048a5edd99b2mr3893770lfa.124.1658734147157;
        Mon, 25 Jul 2022 00:29:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vSilpMwka+2TIjWzkO9OCXsrSScPIWOm9X8cfPvK1yqV+F7/YxylSd832Ayyg4Jn4Euf9+iYQrDan3aN009eg=
X-Received: by 2002:a05:6512:3f0e:b0:48a:5edd:99b2 with SMTP id
 y14-20020a0565123f0e00b0048a5edd99b2mr3893759lfa.124.1658734146714; Mon, 25
 Jul 2022 00:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-39-xuanzhuo@linux.alibaba.com> <726a5056-789a-b445-a2c6-879008ad270a@redhat.com>
 <1658731116.1695666-1-xuanzhuo@linux.alibaba.com> <CACGkMEvsAyR5uRprobv-bQYPOKKOM4sZzQ-Vw5ZiETMjiCkdRQ@mail.gmail.com>
 <1658733700.3892667-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1658733700.3892667-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 25 Jul 2022 15:28:55 +0800
Message-ID: <CACGkMEvsS_QVbq3iCG8hvHuKrp9ObTy3jPUn75zPk-bSHd7tzA@mail.gmail.com>
Subject: Re: [PATCH v12 38/40] virtio_net: support rx queue resize
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 3:23 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Mon, 25 Jul 2022 14:57:11 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> > On Mon, Jul 25, 2022 at 2:43 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Thu, 21 Jul 2022 17:25:59 +0800, Jason Wang <jasowang@redhat.com> =
wrote:
> > > >
> > > > =E5=9C=A8 2022/7/20 11:04, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > This patch implements the resize function of the rx queues.
> > > > > Based on this function, it is possible to modify the ring num of =
the
> > > > > queue.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >   drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
> > > > >   1 file changed, 22 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index fe4dc43c05a1..1115a8b59a08 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -278,6 +278,8 @@ struct padded_vnet_hdr {
> > > > >     char padding[12];
> > > > >   };
> > > > >
> > > > > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > > +
> > > > >   static bool is_xdp_frame(void *ptr)
> > > > >   {
> > > > >     return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > > > @@ -1846,6 +1848,26 @@ static netdev_tx_t start_xmit(struct sk_bu=
ff *skb, struct net_device *dev)
> > > > >     return NETDEV_TX_OK;
> > > > >   }
> > > > >
> > > > > +static int virtnet_rx_resize(struct virtnet_info *vi,
> > > > > +                        struct receive_queue *rq, u32 ring_num)
> > > > > +{
> > > > > +   int err, qindex;
> > > > > +
> > > > > +   qindex =3D rq - vi->rq;
> > > > > +
> > > > > +   napi_disable(&rq->napi);
> > > >
> > > >
> > > > We need to disable refill work as well. So this series might need
> > > > rebasing on top of
> > > >
> > > > https://lore.kernel.org/netdev/20220704074859.16912-1-jasowang@redh=
at.com/
> > >
> > > I understand that your patch is used to solve the situation where dev=
 is
> > > destoryed but refill work is running.
> > >
> > > And is there such a possibility here?
> >
> > E.g the refill work runs in parallel with this function?
>
> napi_disable enables lock-like functionality. So I think it's safe.
>

Ok, right, since there will be a napi_enable() soon afterwards.

So

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> Thanks.
>
> >
> > Thanks
> >
> > > Or is there any other scenario that I'm
> > > not expecting?
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > I will send a new version (probably tomorrow).
> > > >
> > > > Thanks
> > > >
> > > >
> > > > > +
> > > > > +   err =3D virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_un=
used_buf);
> > > > > +   if (err)
> > > > > +           netdev_err(vi->dev, "resize rx fail: rx queue index: =
%d err: %d\n", qindex, err);
> > > > > +
> > > > > +   if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > > > > +           schedule_delayed_work(&vi->refill, 0);
> > > > > +
> > > > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > > > +   return err;
> > > > > +}
> > > > > +
> > > > >   /*
> > > > >    * Send command via the control virtqueue and check status.  Co=
mmands
> > > > >    * supported by the hypervisor, as indicated by feature bits, s=
hould
> > > >
> > >
> >
>

