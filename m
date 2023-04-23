Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990D86EBDEF
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjDWIWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDWIWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 04:22:18 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB34610C6
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 01:22:15 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-52019617020so3285849a12.3
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 01:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682238135; x=1684830135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AsVqFxCnqnJj6X0Ne966CP4b3PoHHtGOf7X6eWIUjQM=;
        b=Tb/B346e9/yJe3ib/AD+cCfT8dBiYza4ku/jwFqGwo74dVP1bpMIoBGZynuvEOKG4S
         pQcCoPGJTostQastCdpOR3UmE251+CdP0QlPb885nFLmdHjZ+OpA20MIvTI8Yo9LZTlh
         DgZU2E4PAlupns0wf7CTY9QGnwA5G3ehQ2Is4AVq9aiK7BrvTVaARL7m6oqGrS0Cs//k
         OS070RKMfh6MqXo1w7Xo3Jo+b21Q71z97y3ijLzmdX7mH1PWWzufUnMcBpe6apy+Mrgy
         iBRpzgQ+JdZO95o4IA9hHsuH5QgyJ0qWiTxyp412sXis3Npzvp+n2epKUwutOQkLC5XH
         wUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682238135; x=1684830135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AsVqFxCnqnJj6X0Ne966CP4b3PoHHtGOf7X6eWIUjQM=;
        b=F29uDQ666ltj6n77NplH2022udYcv4jXWhQGieervf/TMdu0C5RwDk8Vq7JXr4a8rI
         Krso1fFdJbgca1O0A/x9YBtQi7nuv8hNLRbcIjywuDHd2t9I4i/B84djpoYtzh1aU/as
         Zjxp++OfRcw92ci8UPNMmWVIiZw1lVbUF9UOeYSuxSSwbbQHtmxy1XwZb+YnJqzfHB3o
         Q4WXahRZLaZQuQmR4CEMplphLj9qQOxBjHX+ZDGGPH6ilMKEcgJAVU06F1kAK9XY59tS
         2xmiDlAY45VB5o3qcJUKaIcpa7t3CO8wIIyTQC+ukC6njnP9PmAPPlUKQ2B6Gvwt+x1B
         05+A==
X-Gm-Message-State: AAQBX9c+5Qqc0hYXhzFDybWCujbatG+suh9H0V0Kgx7GLav8wgQMCLW+
        2s3OzrjBlqBd9NIP5cNUv4fDrrymUwoQJG7uzzSn
X-Google-Smtp-Source: AKy350Y0cppnvzh+iIVajhTfZc/f8jqQq53obY80h8SaBPrHRovT6pzLOUPuQ563V4RBQW0br3Wx1AER7E1Wd3DLNL4=
X-Received: by 2002:a17:902:fa0b:b0:1a6:d8a3:3346 with SMTP id
 la11-20020a170902fa0b00b001a6d8a33346mr9686473plb.31.1682238135103; Sun, 23
 Apr 2023 01:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <CACGkMEuiHqPkqYk1ZG3RZXLjm+EM3bmR0v1T1yH-ADEazOwTMA@mail.gmail.com>
 <d7530c13-f1a1-311e-7d5e-8e65f3bc2e50@redhat.com> <CACGkMEuWpHokhwvJ5cF41_C=ezqFhoOyUOposdZ5+==A642OmQ@mail.gmail.com>
 <88a24206-b576-efc6-1bce-7f5075024c63@redhat.com> <CACGkMEuZpk8QcrUQSOxqt6j3F9Ge-HdSs5-18FayMMQmH3Tcmg@mail.gmail.com>
In-Reply-To: <CACGkMEuZpk8QcrUQSOxqt6j3F9Ge-HdSs5-18FayMMQmH3Tcmg@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Sun, 23 Apr 2023 16:22:00 +0800
Message-ID: <CACycT3sbn=DSf0qW5RchV=FauDdn2eoMLEkRGAU3wXZZJwDsrw@mail.gmail.com>
Subject: Re: [RFC 0/2] vduse: add support for networking devices
To:     Jason Wang <jasowang@redhat.com>
Cc:     Maxime Coquelin <maxime.coquelin@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Marchand <david.marchand@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, xuanzhuo@linux.alibaba.com,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 2:31=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Fri, Apr 21, 2023 at 10:28=E2=80=AFPM Maxime Coquelin
> <maxime.coquelin@redhat.com> wrote:
> >
> >
> >
> > On 4/21/23 07:51, Jason Wang wrote:
> > > On Thu, Apr 20, 2023 at 10:16=E2=80=AFPM Maxime Coquelin
> > > <maxime.coquelin@redhat.com> wrote:
> > >>
> > >>
> > >>
> > >> On 4/20/23 06:34, Jason Wang wrote:
> > >>> On Wed, Apr 19, 2023 at 9:43=E2=80=AFPM Maxime Coquelin
> > >>> <maxime.coquelin@redhat.com> wrote:
> > >>>>
> > >>>> This small series enables virtio-net device type in VDUSE.
> > >>>> With it, basic operation have been tested, both with
> > >>>> virtio-vdpa and vhost-vdpa using DPDK Vhost library series
> > >>>> adding VDUSE support [0] using split rings layout.
> > >>>>
> > >>>> Control queue support (and so multiqueue) has also been
> > >>>> tested, but require a Kernel series from Jason Wang
> > >>>> relaxing control queue polling [1] to function reliably.
> > >>>>
> > >>>> Other than that, we have identified a few gaps:
> > >>>>
> > >>>> 1. Reconnection:
> > >>>>    a. VDUSE_VQ_GET_INFO ioctl() returns always 0 for avail
> > >>>>       index, even after the virtqueue has already been
> > >>>>       processed. Is that expected? I have tried instead to
> > >>>>       get the driver's avail index directly from the avail
> > >>>>       ring, but it does not seem reliable as I sometimes get
> > >>>>       "id %u is not a head!\n" warnings. Also such solution
> > >>>>       would not be possible with packed ring, as we need to
> > >>>>       know the wrap counters values.
> > >>>
> > >>> Looking at the codes, it only returns the value that is set via
> > >>> set_vq_state(). I think it is expected to be called before the
> > >>> datapath runs.
> > >>>
> > >>> So when bound to virtio-vdpa, it is expected to return 0. But we ne=
ed
> > >>> to fix the packed virtqueue case, I wonder if we need to call
> > >>> set_vq_state() explicitly in virtio-vdpa before starting the device=
.
> > >>>
> > >>> When bound to vhost-vdpa, Qemu will call VHOST_SET_VRING_BASE which
> > >>> will end up a call to set_vq_state(). Unfortunately, it doesn't
> > >>> support packed ring which needs some extension.
> > >>>
> > >>>>
> > >>>>    b. Missing IOCTLs: it would be handy to have new IOCTLs to
> > >>>>       query Virtio device status,
> > >>>
> > >>> What's the use case of this ioctl? It looks to me userspace is
> > >>> notified on each status change now:
> > >>>
> > >>> static int vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> > >>> {
> > >>>           struct vduse_dev_msg msg =3D { 0 };
> > >>>
> > >>>           msg.req.type =3D VDUSE_SET_STATUS;
> > >>>           msg.req.s.status =3D status;
> > >>>
> > >>>           return vduse_dev_msg_sync(dev, &msg);
> > >>> }
> > >>
> > >> The idea was to be able to query the status at reconnect time, and
> > >> neither having to assume its value nor having to store its value in =
a
> > >> file (the status could change while the VDUSE application is stopped=
,
> > >> but maybe it would receive the notification at reconnect).
> > >
> > > I see.
> > >
> > >>
> > >> I will prototype using a tmpfs file to save needed information, and =
see
> > >> if it works.
> > >
> > > It might work but then the API is not self contained. Maybe it's
> > > better to have a dedicated ioctl.
> > >
> > >>
> > >>>> and retrieve the config
> > >>>>       space set at VDUSE_CREATE_DEV time.
> > >>>
> > >>> In order to be safe, VDUSE avoids writable config space. Otherwise
> > >>> drivers could block on config writing forever. That's why we don't =
do
> > >>> it now.
> > >>
> > >> The idea was not to make the config space writable, but just to be a=
ble
> > >> to fetch what was filled at VDUSE_CREATE_DEV time.
> > >>
> > >> With the tmpfs file, we can avoid doing that and just save the confi=
g
> > >> space there.
> > >
> > > Same as the case for status.
> >
> > I have cooked a DPDK patch to support reconnect with a tmpfs file as
> > suggested by Yongji:
> >
> > https://gitlab.com/mcoquelin/dpdk-next-virtio/-/commit/53913f2b1155b02c=
44d5d3d298aafd357e7a8c48
>
> This seems tricky, for example for status:
>
> dev->log->status =3D dev->status;
>
> What if we crash here?
>

The message will be re-sent by the kernel if it's not replied. But I
think it would be better if we can restore it via some ioctl.

Thanks,
Yongji
