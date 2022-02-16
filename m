Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFF84B8258
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiBPHx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:53:29 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiBPHx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:53:28 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9220988B1B;
        Tue, 15 Feb 2022 23:53:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4cQ30u_1644997965;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4cQ30u_1644997965)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 15:52:46 +0800
Message-ID: <1644997568.827981-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v5 20/22] virtio_net: set the default max ring num
Date:   Wed, 16 Feb 2022 15:46:08 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
 <20220214081416.117695-21-xuanzhuo@linux.alibaba.com>
 <CACGkMEvZvhSb0veCynEHN3EfFu_FwbCAb8w1b0Oi3LDc=ffNaw@mail.gmail.com>
In-Reply-To: <CACGkMEvZvhSb0veCynEHN3EfFu_FwbCAb8w1b0Oi3LDc=ffNaw@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 12:14:31 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Mon, Feb 14, 2022 at 4:14 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > Sets the default maximum ring num based on virtio_set_max_ring_num().
> >
> > The default maximum ring num is 1024.
>
> Having a default value is pretty useful, I see 32K is used by default for IFCVF.
>
> Rethink this, how about having a different default value based on the speed?
>
> Without SPEED_DUPLEX, we use 1024. Otherwise
>
> 10g 4096
> 40g 8192

We can define different default values of tx and rx by the way. This way I can
just use it in the new interface of find_vqs().

without SPEED_DUPLEX:  tx 512 rx 1024

Thanks.


>
> etc.
>
> (The number are just copied from the 10g/40g default parameter from
> other vendors)
>
> Thanks
>
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio_net.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index a4ffd7cdf623..77e61fe0b2ce 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -35,6 +35,8 @@ module_param(napi_tx, bool, 0644);
> >  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> >  #define GOOD_COPY_LEN  128
> >
> > +#define VIRTNET_DEFAULT_MAX_RING_NUM 1024
> > +
> >  #define VIRTNET_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
> >
> >  /* Amount of XDP headroom to prepend to packets for use by xdp_adjust_head */
> > @@ -3045,6 +3047,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> >                         ctx[rxq2vq(i)] = true;
> >         }
> >
> > +       virtio_set_max_ring_num(vi->vdev, VIRTNET_DEFAULT_MAX_RING_NUM);
> > +
> >         ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> >                                   names, ctx, NULL);
> >         if (ret)
> > --
> > 2.31.0
> >
>
