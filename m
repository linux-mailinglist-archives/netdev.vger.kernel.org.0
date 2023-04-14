Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7341F6E1B7E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjDNFLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDNFL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:11:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D604A49C7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681449013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MnDvwf1R/OovgMAVg9WiYCMbtU1kpmzHDOYZjnYe0Qg=;
        b=Z9KeZOQJ4lkXYIrgGJVrUbWvTDyB10zMJoJkhQdOqdkf4tlQms74skaLPjUefAdc8wiiPa
        KdclIOIMWTGtu/4x8YnAAESS2525WEUxkqTt7nks0RSiWSjsDQjHYImp3Rs7nMQT/CVcHh
        kXxUk3+4ru5xSho74AVaE8+m0RDCuug=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-q9Y-yl8lNpmS1TmLwfpmNA-1; Fri, 14 Apr 2023 01:10:11 -0400
X-MC-Unique: q9Y-yl8lNpmS1TmLwfpmNA-1
Received: by mail-oo1-f71.google.com with SMTP id q186-20020a4a33c3000000b0053b61757527so5382230ooq.9
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681449011; x=1684041011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MnDvwf1R/OovgMAVg9WiYCMbtU1kpmzHDOYZjnYe0Qg=;
        b=Du2d58ualJjqWvgWPZUTTz1fJcMPL3zkFTmO7ZJmQq9y4R0l2SMtLGPe2Ah7v7I6Oj
         9vnjJUIdNcSt3E4aPf32awa0+kFd3cJyX8A5ExeBObP3zEiAGvEyN9ETDnKAecY1Doi9
         Bwz6ro3ZLaYNFSf2GU0UCYGpJ7IEbHUVj3rRuskfYNmjALtN6Ng6Q4545/X+gudLdhJL
         TCyAaKn23iWI+AdEYRCRT3hFdwsa2Sv2dlgeY7YSZjjHZlqEAIKupLzvWdVp8FpGOxQ5
         5nJNWlMcb4Tqnv7wsGvCelx7cVYnw7Wp9m1wHx0bhq9s4CyIR9rGqR60Dor17ATL8DCn
         tHOg==
X-Gm-Message-State: AAQBX9faHgs75fprFdg07bioBbNWULUIg/+2Fs7Dk/kfaIl5/p/wxN6g
        00AAV81VhlbuQH/YbhchT4J/rxYD+EWhCCAW9NPe/+D05hvLulCR69ratoE3qLUU79LTMM3Bl7y
        lL67inTt+5w6Ux1KbhCGDGf4FkRlGdgNW
X-Received: by 2002:a05:6870:2495:b0:177:b9c0:bcba with SMTP id s21-20020a056870249500b00177b9c0bcbamr3833506oaq.3.1681449011197;
        Thu, 13 Apr 2023 22:10:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350aAWQ/zE3JzE+BJztmF9q8RTKt9Is6pPgO3saF+6nNCza+95hIGVBIaLglcjHvYzkHy1o1BpD43DUoFBOps7+M=
X-Received: by 2002:a05:6870:2495:b0:177:b9c0:bcba with SMTP id
 s21-20020a056870249500b00177b9c0bcbamr3833491oaq.3.1681449010955; Thu, 13 Apr
 2023 22:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230413064027.13267-1-jasowang@redhat.com> <20230413064027.13267-3-jasowang@redhat.com>
 <1681370820.0675354-2-xuanzhuo@linux.alibaba.com> <CACGkMEuJuZKGMhVwFmD0ZMa7V7TdGu6qaXF24Gg67TzMbs8ANA@mail.gmail.com>
In-Reply-To: <CACGkMEuJuZKGMhVwFmD0ZMa7V7TdGu6qaXF24Gg67TzMbs8ANA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 14 Apr 2023 13:10:00 +0800
Message-ID: <CACGkMEvuFoc=8S666npEnTXuZZLMJVA8tzNAspfrTzR4L7NdgQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2 2/2] virtio-net: sleep instead of busy waiting
 for cvq command
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com, eperezma@redhat.com,
        david.marchand@redhat.com, mst@redhat.com,
        netdev <netdev@vger.kernel.org>
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

Adding netdev.

On Fri, Apr 14, 2023 at 1:09=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Thu, Apr 13, 2023 at 3:31=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > On Thu, 13 Apr 2023 14:40:27 +0800, Jason Wang <jasowang@redhat.com> wr=
ote:
> > > We used to busy waiting on the cvq command this tends to be
> > > problematic since there no way for to schedule another process which
> > > may serve for the control virtqueue. This might be the case when the
> > > control virtqueue is emulated by software. This patch switches to use
> > > completion to allow the CPU to sleep instead of busy waiting for the
> > > cvq command.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > Changes since V1:
> > > - use completion for simplicity
> > > - don't try to harden the CVQ command which requires more thought
> > > Changes since RFC:
> > > - break the device when timeout
> > > - get buffer manually since the virtio core check more_used() instead
> > > ---
> > >  drivers/net/virtio_net.c | 21 ++++++++++++++-------
> > >  1 file changed, 14 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 2e56bbf86894..d3eb8fd6c9dc 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -19,6 +19,7 @@
> > >  #include <linux/average.h>
> > >  #include <linux/filter.h>
> > >  #include <linux/kernel.h>
> > > +#include <linux/completion.h>
> > >  #include <net/route.h>
> > >  #include <net/xdp.h>
> > >  #include <net/net_failover.h>
> > > @@ -295,6 +296,8 @@ struct virtnet_info {
> > >
> > >       /* failover when STANDBY feature enabled */
> > >       struct failover *failover;
> > > +
> > > +     struct completion completion;
> > >  };
> > >
> > >  struct padded_vnet_hdr {
> > > @@ -1709,6 +1712,13 @@ static bool try_fill_recv(struct virtnet_info =
*vi, struct receive_queue *rq,
> > >       return !oom;
> > >  }
> > >
> > > +static void virtnet_cvq_done(struct virtqueue *cvq)
> > > +{
> > > +     struct virtnet_info *vi =3D cvq->vdev->priv;
> > > +
> > > +     complete(&vi->completion);
> > > +}
> > > +
> > >  static void skb_recv_done(struct virtqueue *rvq)
> > >  {
> > >       struct virtnet_info *vi =3D rvq->vdev->priv;
> > > @@ -2169,12 +2179,8 @@ static bool virtnet_send_command(struct virtne=
t_info *vi, u8 class, u8 cmd,
> > >       if (unlikely(!virtqueue_kick(vi->cvq)))
> > >               return vi->ctrl->status =3D=3D VIRTIO_NET_OK;
> > >
> > > -     /* Spin for a response, the kick causes an ioport write, trappi=
ng
> > > -      * into the hypervisor, so the request should be handled immedi=
ately.
> > > -      */
> > > -     while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> > > -            !virtqueue_is_broken(vi->cvq))
> > > -             cpu_relax();
> > > +     wait_for_completion(&vi->completion);
> > > +     virtqueue_get_buf(vi->cvq, &tmp);
> > >
> > >       return vi->ctrl->status =3D=3D VIRTIO_NET_OK;
> > >  }
> > > @@ -3672,7 +3678,7 @@ static int virtnet_find_vqs(struct virtnet_info=
 *vi)
> > >
> > >       /* Parameters for control virtqueue, if any */
> > >       if (vi->has_cvq) {
> > > -             callbacks[total_vqs - 1] =3D NULL;
> > > +             callbacks[total_vqs - 1] =3D virtnet_cvq_done;
> >
> > This depends the interrupt, right?
>
> Not necessarily, we have ISR for at last PCI:
>
> static irqreturn_t vp_interrupt(int irq, void *opaque)
> {
>         struct virtio_pci_device *vp_dev =3D opaque;
>         u8 isr;
>
>         /* reading the ISR has the effect of also clearing it so it's ver=
y
>          * important to save off the value. */
>         isr =3D ioread8(vp_dev->isr);
> ...
> }
>
> >
> > I worry that there may be some devices that may not support interruptio=
n on cvq.
>
> Is the device using INTX or MSI-X?
>
> > Although this may not be in line with SPEC, it may cause problem on the=
 devices
> > that can work normally at present.
>
> Then the implementation is buggy, it might not work for drivers other
> than Linux. Working around such buggy implementation is suboptimal.
>
> Thanks
>
> >
> > Thanks.
> >
> >
> > >               names[total_vqs - 1] =3D "control";
> > >       }
> > >
> > > @@ -4122,6 +4128,7 @@ static int virtnet_probe(struct virtio_device *=
vdev)
> > >       if (vi->has_rss || vi->has_rss_hash_report)
> > >               virtnet_init_default_rss(vi);
> > >
> > > +     init_completion(&vi->completion);
> > >       enable_rx_mode_work(vi);
> > >
> > >       /* serialize netdev register + virtio_device_ready() with ndo_o=
pen() */
> > > --
> > > 2.25.1
> > >
> >

