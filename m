Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20594AD291
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 08:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbiBHH4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 02:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiBHH4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 02:56:19 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33288C0401EF;
        Mon,  7 Feb 2022 23:56:17 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0V3vbOI4_1644306973;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V3vbOI4_1644306973)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 15:56:14 +0800
Message-ID: <1644306673.8360631-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v3 00/17] virtio pci support VIRTIO_F_RING_RESET
Date:   Tue, 8 Feb 2022 15:51:13 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>
Cc:     "Jesper Dangaard Brouer" <hawk@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "virtualization" <virtualization@lists.linux-foundation.org>,
        "Jakub Kicinski" <kuba@kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Jason Wang" <jasowang@redhat.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEspyHTmcSaq9fgpU88VCZGzu21Khp9H+fqL-pb5GLdEpA@mail.gmail.com>
 <1644213739.5846965-1-xuanzhuo@linux.alibaba.com>
 <7d1e2d5b-a9a1-cbb7-4d80-89df1cb7bf15@redhat.com>
 <1644290085.868939-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644290085.868939-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Feb 2022 11:14:45 +0800, Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> On Tue, 8 Feb 2022 10:59:48 +0800, Jason Wang <jasowang@redhat.com> wrote:
> >
> > =E5=9C=A8 2022/2/7 =E4=B8=8B=E5=8D=882:02, Xuan Zhuo =E5=86=99=E9=81=93:
> > > On Mon, 7 Feb 2022 11:39:36 +0800, Jason Wang <jasowang@redhat.com> w=
rote:
> > >> On Wed, Jan 26, 2022 at 3:35 PM Xuan Zhuo <xuanzhuo@linux.alibaba.co=
m> wrote:
> > >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > >>> The virtio spec already supports the virtio queue reset function. T=
his patch set
> > >>> is to add this function to the kernel. The relevant virtio spec inf=
ormation is
> > >>> here:
> > >>>
> > >>>      https://github.com/oasis-tcs/virtio-spec/issues/124
> > >>>
> > >>> Also regarding MMIO support for queue reset, I plan to support it a=
fter this
> > >>> patch is passed.
> > >>>
> > >>> #14-#17 is the disable/enable function of rx/tx pair implemented by=
 virtio-net
> > >>> using the new helper.
> > >> One thing that came to mind is the steering. E.g if we disable an RX,
> > >> should we stop steering packets to that queue?

Regarding this spec, if there are multiple queues disabled at the same time=
, it
will be a troublesome problem for the backend to select the queue, so I wan=
t to
directly define that only one queue is allowed to reset at the same time, d=
o you
think this is appropriate?

In terms of the implementation of backend queue reselection, it would be mo=
re
convenient to implement if we drop packets directly. Do you think we must
implement this reselection function?

Thanks.

> > > Yes, we should reselect a queue.
> > >
> > > Thanks.
> >
> >
> > Maybe a spec patch for that?
>
> Yes, I also realized this. Although virtio-net's disable/enable is implem=
ented
> based on queue reset, virtio-net still has to define its own flag and def=
ine
> some more detailed implementations.
>
> I'll think about it and post a spec patch.
>
> Thanks.
>
> >
> > Thanks
> >
> >
> > >
> > >> Thanks
> > >>
> > >>> This function is not currently referenced by other
> > >>> functions. It is more to show the usage of the new helper, I not su=
re if they
> > >>> are going to be merged together.
> > >>>
> > >>> Please review. Thanks.
> > >>>
> > >>> v3:
> > >>>    1. keep vq, irq unreleased
> > >>>
> > >>> Xuan Zhuo (17):
> > >>>    virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
> > >>>    virtio: queue_reset: add VIRTIO_F_RING_RESET
> > >>>    virtio: queue_reset: struct virtio_config_ops add callbacks for
> > >>>      queue_reset
> > >>>    virtio: queue_reset: add helper
> > >>>    vritio_ring: queue_reset: extract the release function of the vq=
 ring
> > >>>    virtio_ring: queue_reset: split: add __vring_init_virtqueue()
> > >>>    virtio_ring: queue_reset: split: support enable reset queue
> > >>>    virtio_ring: queue_reset: packed: support enable reset queue
> > >>>    virtio_ring: queue_reset: add vring_reset_virtqueue()
> > >>>    virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
> > >>>      option functions
> > >>>    virtio_pci: queue_reset: release vq by vp_dev->vqs
> > >>>    virtio_pci: queue_reset: setup_vq use vring_setup_virtqueue()
> > >>>    virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
> > >>>    virtio_net: virtnet_tx_timeout() fix style
> > >>>    virtio_net: virtnet_tx_timeout() stop ref sq->vq
> > >>>    virtio_net: split free_unused_bufs()
> > >>>    virtio_net: support pair disable/enable
> > >>>
> > >>>   drivers/net/virtio_net.c               | 220 ++++++++++++++++++++=
++---
> > >>>   drivers/virtio/virtio_pci_common.c     |  62 ++++---
> > >>>   drivers/virtio/virtio_pci_common.h     |  11 +-
> > >>>   drivers/virtio/virtio_pci_legacy.c     |   5 +-
> > >>>   drivers/virtio/virtio_pci_modern.c     | 120 +++++++++++++-
> > >>>   drivers/virtio/virtio_pci_modern_dev.c |  28 ++++
> > >>>   drivers/virtio/virtio_ring.c           | 144 +++++++++++-----
> > >>>   include/linux/virtio.h                 |   1 +
> > >>>   include/linux/virtio_config.h          |  75 ++++++++-
> > >>>   include/linux/virtio_pci_modern.h      |   2 +
> > >>>   include/linux/virtio_ring.h            |  42 +++--
> > >>>   include/uapi/linux/virtio_config.h     |   7 +-
> > >>>   include/uapi/linux/virtio_pci.h        |   2 +
> > >>>   13 files changed, 618 insertions(+), 101 deletions(-)
> > >>>
> > >>> --
> > >>> 2.31.0
> > >>>
> >
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
