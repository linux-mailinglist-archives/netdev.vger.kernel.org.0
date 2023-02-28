Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954BD6A5657
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjB1KIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjB1KId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:08:33 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC678C651;
        Tue, 28 Feb 2023 02:08:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VcixL24_1677578908;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VcixL24_1677578908)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 18:08:28 +0800
Message-ID: <1677578798.8465447-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v2] virtio-net: Fix probe of virtio-net on kvmtool
Date:   Tue, 28 Feb 2023 18:06:38 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, rbradford@rivosinc.com
References: <20230223-virtio-net-kvmtool-v2-1-8ec93511e67f@rivosinc.com>
 <CACGkMEu8JtT9_0YcbmfWCGxbrB1GHnesnspFYgaeVrb2x3o3oQ@mail.gmail.com>
In-Reply-To: <CACGkMEu8JtT9_0YcbmfWCGxbrB1GHnesnspFYgaeVrb2x3o3oQ@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 11:11:37 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Fri, Feb 24, 2023 at 3:38 AM Rob Bradford via B4 Relay
> <devnull+rbradford.rivosinc.com@kernel.org> wrote:
> >
> > From: Rob Bradford <rbradford@rivosinc.com>
> >
> > kvmtool does not support the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature
> > but does advertise the VIRTIO_NET_F_GUEST_TSO{4,6} features. Check that
> > the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is present before setting
> > the NETIF_F_GRO_HW feature bit as otherwise

Here are settings for dev->features and dev->hw_features.


> > an attempt will be made to
> > program the virtio-net device using the ctrl queue which will fail.
> >
> > This resolves the following error when running on kvmtool:

Can you talk about it in detail what it did?

Thanks.

> >
> > [    1.865992] net eth0: Fail to set guest offload.
> > [    1.872491] virtio_net virtio2 eth0: set_features() failed (-22); wanted 0x0000000000134829, left 0x0080000000134829
> >
> > Signed-off-by: Rob Bradford <rbradford@rivosinc.com>
> > ---
> > Changes in v2:
> > - Use parentheses to group logical OR of features
> > - Link to v1:
> >   https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v1-1-fc23d29b9d7a@rivosinc.com
> > ---
> >  drivers/net/virtio_net.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 61e33e4dd0cd..f8341d1a4ccd 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3780,10 +3780,9 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         }
> >         if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
> >                 dev->features |= NETIF_F_RXCSUM;
> > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > -           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > -               dev->features |= NETIF_F_GRO_HW;
> > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > +       if ((virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > +           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6)) &&
> > +           virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> >                 dev->hw_features |= NETIF_F_GRO_HW;
>
> Does this mean we won't have NETIF_F_GRO_HW when only TSO4/TSO6 are
> supported but not GUEST_OFFLOADS?
>
> Is this intended?
>
> Thanks
>
> >
> >         dev->vlan_features = dev->features;
> >
> > ---
> > base-commit: c39cea6f38eefe356d64d0bc1e1f2267e282cdd3
> > change-id: 20230223-virtio-net-kvmtool-87f37515be22
> >
> > Best regards,
> > --
> > Rob Bradford <rbradford@rivosinc.com>
> >
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
