Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB56D18B0
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCaHgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCaHgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:36:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2683A199B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680248128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P11Gyi3r00PUIBmbioHAgjpL8ZU8yZOiM0XiaPfoh4Y=;
        b=RaWCkf3vYPe4M9NxP7wIEiaegj24LS8IYhkUcPy3FeBbwRHhgA8prV31aO3POZKXVdNhKy
        TGA7Z3NdpwQcSBxKsSZsuJGS+RZv9mPoZQ9X0T1jAVJkJhGJpZQehckiS3E1cSPzSdFSUy
        /GeLNcxB0rZ+0GFj9YTeHKKxPDwsWes=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-33_ggFtoMYalxZjL2xtPmA-1; Fri, 31 Mar 2023 03:35:26 -0400
X-MC-Unique: 33_ggFtoMYalxZjL2xtPmA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-17a03f26ff8so11025392fac.8
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680248126; x=1682840126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P11Gyi3r00PUIBmbioHAgjpL8ZU8yZOiM0XiaPfoh4Y=;
        b=iqyM+e0S4JuQ1LAyhnWtPX0rg8YYq5j1QD333vHUdzLeTtN2836kWC7m3+dAg5aw67
         6pMJu3fiRwQ1VO9Bib8HNhK3G33drFcFedv9pQJniFdDcfkn/gdfklkrX0UzGWR0aiGD
         ftvEieArcOmLWCQ12HAMafeMF1eb+pBvrfBoPpMZDEE9wy/WfyakYmkk6eNjD7v5Sjyi
         0CBIFlnR2454YLeOFfQ1TxEBohsucsQJAPlujcsyvP9SL02VdGV0iXPz9Q7lTw+mVSXZ
         cLMId9MylYbfgfcZoowzKGzIHS7qhLilvWNqP7U2PCj+qekLRHCJLw3BBFU5X0RqqC+L
         uE3A==
X-Gm-Message-State: AO0yUKWJgXIO7QEqDiNXgtgnzCWq3U6Cylx/LwLn593UfIYiRbkMNnB/
        tllwF3KSjZBDv9QbpQ7hjJpUu8C7NztTzCe95naIZ4nBQBHDAd1HzafBmxNQbuKTjIh7EcXJ1KJ
        PZSREO6N963tGHesXcr8XZTMZ5a7IXXUz
X-Received: by 2002:a54:4710:0:b0:384:4e2d:81ea with SMTP id k16-20020a544710000000b003844e2d81eamr7673650oik.9.1680248125810;
        Fri, 31 Mar 2023 00:35:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set8tQXxUQD0cWyHy91AVO3Vq78TqztTDk6R6A4wfzzu5CJr0V4y0uFTy3T3PDVnAjM21BOjdPbfDdz4Qwa9y8eg=
X-Received: by 2002:a54:4710:0:b0:384:4e2d:81ea with SMTP id
 k16-20020a544710000000b003844e2d81eamr7673639oik.9.1680248125518; Fri, 31 Mar
 2023 00:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
 <20230330015412-mutt-send-email-mst@kernel.org> <1680247317.9193828-3-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1680247317.9193828-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 31 Mar 2023 15:35:14 +0800
Message-ID: <CACGkMEt2M3zaytjOmhTuSx6wnerZBrVoQxgbUuAv0WmUu50Hiw@mail.gmail.com>
Subject: Re: [PATCH 00/16] virtio-net: split virtio-net.c
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
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

On Fri, Mar 31, 2023 at 3:31=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> On Thu, 30 Mar 2023 02:17:43 -0400, "Michael S. Tsirkin" <mst@redhat.com>=
 wrote:
> > On Tue, Mar 28, 2023 at 05:28:31PM +0800, Xuan Zhuo wrote:
> > > Considering the complexity of virtio-net.c and the new features we wa=
nt
> > > to add, it is time to split virtio-net.c into multiple independent
> > > module files.
> > >
> > > This is beneficial to the maintenance and adding new functions.
> > >
> > > And AF_XDP support will be added later, then a separate xsk.c file wi=
ll
> > > be added.
> > >
> > > This patchset split virtio-net.c into these parts:
> > >
> > > * virtnet.c:         virtio net device ops (napi, tx, rx, device ops,=
 ...)
> > > * virtnet_common.c:  virtio net common code
> > > * virtnet_ethtool.c: virtio net ethtool callbacks
> > > * virtnet_ctrl.c:    virtio net ctrl queue command APIs
> > > * virtnet_virtio.c:  virtio net virtio callbacks/ops (driver register=
, virtio probe, virtio free, ...)
> > >
> > > Please review.
> > >
> > > Thanks.
> >
> >
> > I don't feel this is an improvement as presented, will need more work
> > to make code placement more logical.
>
> Yes, this does need some time and energy. But I think this always need to=
 do,
> just when to do it. I think it is currently an opportunity.
>
>
> >
> > For example where do I find code to update rq stats?
> > Rx data path should be virtnet.c?
> > No it's in virtnet_ethtool.c because rq stats can be
> > accessed by ethtool.
>
> That's what I do.
>
> > A bunch of stuff seems to be in headers just because of technicalities.
> > virtio common seems to be a dumping ground with no guiding principle at
> > all.
>
> Yes, I agree, with the development of time, common will indeed become a d=
umping
> group. This is something we should pay attention to after this.
>
>
> > drivers/net/virtio/virtnet_virtio.c is weird with
> > virt repeated three times in the path.
>
> Any good idea.
>
> >
> > These things only get murkier with time, at the point of reorg
> > I would expect very logical placement, since
> > without clear guiding rule finding where something is becomes harder bu=
t
> > more importantly we'll now get endless heartburn about where does each =
new
> > function go.
> >
> >
> > The reorg is unfortunately not free - for example git log --follow will
> > no longer easily match virtio because --follow works with exactly one
> > path.
>
> One day we will face this problem.
>
> > It's now also extra work to keep headers self-consistent.
>
> Can we make it simpler, first complete the split.
>
>
> > So it better be a big improvement to be worth it.
>
>
> Or about split, do you have any better thoughts? Or do you think we have =
always
> been like this and make Virtio-Net more and more complicated?

My feeling is that maybe it's worth it to start using a separate file
for xsk support.

Thanks

>
>
> Thanks.
>
> >
> >
> >
> >
> > > Xuan Zhuo (16):
> > >   virtio_net: add a separate directory for virtio-net
> > >   virtio_net: move struct to header file
> > >   virtio_net: add prefix to the struct inside header file
> > >   virtio_net: separating cpu-related funs
> > >   virtio_net: separate virtnet_ctrl_set_queues()
> > >   virtio_net: separate virtnet_ctrl_set_mac_address()
> > >   virtio_net: remove lock from virtnet_ack_link_announce()
> > >   virtio_net: separating the APIs of cq
> > >   virtio_net: introduce virtnet_rq_update_stats()
> > >   virtio_net: separating the funcs of ethtool
> > >   virtio_net: introduce virtnet_dev_rx_queue_group()
> > >   virtio_net: introduce virtnet_get_netdev()
> > >   virtio_net: prepare for virtio
> > >   virtio_net: move virtnet_[en/dis]able_delayed_refill to header file
> > >   virtio_net: add APIs to register/unregister virtio driver
> > >   virtio_net: separating the virtio code
> > >
> > >  MAINTAINERS                                   |    2 +-
> > >  drivers/net/Kconfig                           |    8 +-
> > >  drivers/net/Makefile                          |    2 +-
> > >  drivers/net/virtio/Kconfig                    |   11 +
> > >  drivers/net/virtio/Makefile                   |   10 +
> > >  .../net/{virtio_net.c =3D> virtio/virtnet.c}    | 2368 ++-----------=
----
> > >  drivers/net/virtio/virtnet.h                  |  213 ++
> > >  drivers/net/virtio/virtnet_common.c           |  138 +
> > >  drivers/net/virtio/virtnet_common.h           |   14 +
> > >  drivers/net/virtio/virtnet_ctrl.c             |  272 ++
> > >  drivers/net/virtio/virtnet_ctrl.h             |   45 +
> > >  drivers/net/virtio/virtnet_ethtool.c          |  578 ++++
> > >  drivers/net/virtio/virtnet_ethtool.h          |    8 +
> > >  drivers/net/virtio/virtnet_virtio.c           |  880 ++++++
> > >  drivers/net/virtio/virtnet_virtio.h           |    8 +
> > >  15 files changed, 2366 insertions(+), 2191 deletions(-)
> > >  create mode 100644 drivers/net/virtio/Kconfig
> > >  create mode 100644 drivers/net/virtio/Makefile
> > >  rename drivers/net/{virtio_net.c =3D> virtio/virtnet.c} (50%)
> > >  create mode 100644 drivers/net/virtio/virtnet.h
> > >  create mode 100644 drivers/net/virtio/virtnet_common.c
> > >  create mode 100644 drivers/net/virtio/virtnet_common.h
> > >  create mode 100644 drivers/net/virtio/virtnet_ctrl.c
> > >  create mode 100644 drivers/net/virtio/virtnet_ctrl.h
> > >  create mode 100644 drivers/net/virtio/virtnet_ethtool.c
> > >  create mode 100644 drivers/net/virtio/virtnet_ethtool.h
> > >  create mode 100644 drivers/net/virtio/virtnet_virtio.c
> > >  create mode 100644 drivers/net/virtio/virtnet_virtio.h
> > >
> > > --
> > > 2.32.0.3.g01195cf9f
> >
>

