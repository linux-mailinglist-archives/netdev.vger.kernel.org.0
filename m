Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7900F6D1904
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjCaHve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjCaHvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:51:05 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFF712D;
        Fri, 31 Mar 2023 00:49:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vf1TRG3_1680248994;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vf1TRG3_1680248994)
          by smtp.aliyun-inc.com;
          Fri, 31 Mar 2023 15:49:55 +0800
Message-ID: <1680248880.8897254-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 00/16] virtio-net: split virtio-net.c
Date:   Fri, 31 Mar 2023 15:48:00 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
 <20230330015412-mutt-send-email-mst@kernel.org>
 <1680247317.9193828-3-xuanzhuo@linux.alibaba.com>
 <CACGkMEt2M3zaytjOmhTuSx6wnerZBrVoQxgbUuAv0WmUu50Hiw@mail.gmail.com>
In-Reply-To: <CACGkMEt2M3zaytjOmhTuSx6wnerZBrVoQxgbUuAv0WmUu50Hiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 15:35:14 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Fri, Mar 31, 2023 at 3:31=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > On Thu, 30 Mar 2023 02:17:43 -0400, "Michael S. Tsirkin" <mst@redhat.co=
m> wrote:
> > > On Tue, Mar 28, 2023 at 05:28:31PM +0800, Xuan Zhuo wrote:
> > > > Considering the complexity of virtio-net.c and the new features we =
want
> > > > to add, it is time to split virtio-net.c into multiple independent
> > > > module files.
> > > >
> > > > This is beneficial to the maintenance and adding new functions.
> > > >
> > > > And AF_XDP support will be added later, then a separate xsk.c file =
will
> > > > be added.
> > > >
> > > > This patchset split virtio-net.c into these parts:
> > > >
> > > > * virtnet.c:         virtio net device ops (napi, tx, rx, device op=
s, ...)
> > > > * virtnet_common.c:  virtio net common code
> > > > * virtnet_ethtool.c: virtio net ethtool callbacks
> > > > * virtnet_ctrl.c:    virtio net ctrl queue command APIs
> > > > * virtnet_virtio.c:  virtio net virtio callbacks/ops (driver regist=
er, virtio probe, virtio free, ...)
> > > >
> > > > Please review.
> > > >
> > > > Thanks.
> > >
> > >
> > > I don't feel this is an improvement as presented, will need more work
> > > to make code placement more logical.
> >
> > Yes, this does need some time and energy. But I think this always need =
to do,
> > just when to do it. I think it is currently an opportunity.
> >
> >
> > >
> > > For example where do I find code to update rq stats?
> > > Rx data path should be virtnet.c?
> > > No it's in virtnet_ethtool.c because rq stats can be
> > > accessed by ethtool.
> >
> > That's what I do.
> >
> > > A bunch of stuff seems to be in headers just because of technicalitie=
s.
> > > virtio common seems to be a dumping ground with no guiding principle =
at
> > > all.
> >
> > Yes, I agree, with the development of time, common will indeed become a=
 dumping
> > group. This is something we should pay attention to after this.
> >
> >
> > > drivers/net/virtio/virtnet_virtio.c is weird with
> > > virt repeated three times in the path.
> >
> > Any good idea.
> >
> > >
> > > These things only get murkier with time, at the point of reorg
> > > I would expect very logical placement, since
> > > without clear guiding rule finding where something is becomes harder =
but
> > > more importantly we'll now get endless heartburn about where does eac=
h new
> > > function go.
> > >
> > >
> > > The reorg is unfortunately not free - for example git log --follow wi=
ll
> > > no longer easily match virtio because --follow works with exactly one
> > > path.
> >
> > One day we will face this problem.
> >
> > > It's now also extra work to keep headers self-consistent.
> >
> > Can we make it simpler, first complete the split.
> >
> >
> > > So it better be a big improvement to be worth it.
> >
> >
> > Or about split, do you have any better thoughts? Or do you think we hav=
e always
> > been like this and make Virtio-Net more and more complicated?
>
> My feeling is that maybe it's worth it to start using a separate file
> for xsk support.

I agree.

@Michael at this point, what is your thought?


Thanks.


>
> Thanks
>
> >
> >
> > Thanks.
> >
> > >
> > >
> > >
> > >
> > > > Xuan Zhuo (16):
> > > >   virtio_net: add a separate directory for virtio-net
> > > >   virtio_net: move struct to header file
> > > >   virtio_net: add prefix to the struct inside header file
> > > >   virtio_net: separating cpu-related funs
> > > >   virtio_net: separate virtnet_ctrl_set_queues()
> > > >   virtio_net: separate virtnet_ctrl_set_mac_address()
> > > >   virtio_net: remove lock from virtnet_ack_link_announce()
> > > >   virtio_net: separating the APIs of cq
> > > >   virtio_net: introduce virtnet_rq_update_stats()
> > > >   virtio_net: separating the funcs of ethtool
> > > >   virtio_net: introduce virtnet_dev_rx_queue_group()
> > > >   virtio_net: introduce virtnet_get_netdev()
> > > >   virtio_net: prepare for virtio
> > > >   virtio_net: move virtnet_[en/dis]able_delayed_refill to header fi=
le
> > > >   virtio_net: add APIs to register/unregister virtio driver
> > > >   virtio_net: separating the virtio code
> > > >
> > > >  MAINTAINERS                                   |    2 +-
> > > >  drivers/net/Kconfig                           |    8 +-
> > > >  drivers/net/Makefile                          |    2 +-
> > > >  drivers/net/virtio/Kconfig                    |   11 +
> > > >  drivers/net/virtio/Makefile                   |   10 +
> > > >  .../net/{virtio_net.c =3D> virtio/virtnet.c}    | 2368 ++---------=
------
> > > >  drivers/net/virtio/virtnet.h                  |  213 ++
> > > >  drivers/net/virtio/virtnet_common.c           |  138 +
> > > >  drivers/net/virtio/virtnet_common.h           |   14 +
> > > >  drivers/net/virtio/virtnet_ctrl.c             |  272 ++
> > > >  drivers/net/virtio/virtnet_ctrl.h             |   45 +
> > > >  drivers/net/virtio/virtnet_ethtool.c          |  578 ++++
> > > >  drivers/net/virtio/virtnet_ethtool.h          |    8 +
> > > >  drivers/net/virtio/virtnet_virtio.c           |  880 ++++++
> > > >  drivers/net/virtio/virtnet_virtio.h           |    8 +
> > > >  15 files changed, 2366 insertions(+), 2191 deletions(-)
> > > >  create mode 100644 drivers/net/virtio/Kconfig
> > > >  create mode 100644 drivers/net/virtio/Makefile
> > > >  rename drivers/net/{virtio_net.c =3D> virtio/virtnet.c} (50%)
> > > >  create mode 100644 drivers/net/virtio/virtnet.h
> > > >  create mode 100644 drivers/net/virtio/virtnet_common.c
> > > >  create mode 100644 drivers/net/virtio/virtnet_common.h
> > > >  create mode 100644 drivers/net/virtio/virtnet_ctrl.c
> > > >  create mode 100644 drivers/net/virtio/virtnet_ctrl.h
> > > >  create mode 100644 drivers/net/virtio/virtnet_ethtool.c
> > > >  create mode 100644 drivers/net/virtio/virtnet_ethtool.h
> > > >  create mode 100644 drivers/net/virtio/virtnet_virtio.c
> > > >  create mode 100644 drivers/net/virtio/virtnet_virtio.h
> > > >
> > > > --
> > > > 2.32.0.3.g01195cf9f
> > >
> >
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
