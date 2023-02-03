Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69DD688E9C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 05:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjBCEgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 23:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBCEgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 23:36:11 -0500
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45FC60CB9;
        Thu,  2 Feb 2023 20:36:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VanP3zA_1675398963;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VanP3zA_1675398963)
          by smtp.aliyun-inc.com;
          Fri, 03 Feb 2023 12:36:04 +0800
Message-ID: <1675398932.095303-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 19/33] virtio_net: introduce virtnet_tx_reset()
Date:   Fri, 3 Feb 2023 12:35:32 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-20-xuanzhuo@linux.alibaba.com>
 <20230202121745-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230202121745-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 12:23:56 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Feb 02, 2023 at 07:00:44PM +0800, Xuan Zhuo wrote:
> > Introduce virtnet_tx_reset() to release the buffers inside virtio ring.
> >
> > This is needed for xsk disable. When disable xsk, we need to relese the
>
> typo
>
> > buffer from xsk, so this function is needed.
> >
> > This patch reuse the virtnet_tx_resize.
>
> reuses
>
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
>
> > ---
> >  drivers/net/virtio/main.c       | 21 ++++++++++++++++++---
> >  drivers/net/virtio/virtio_net.h |  1 +
> >  2 files changed, 19 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> > index fb82035a0b7f..049a3bb9d88d 100644
> > --- a/drivers/net/virtio/main.c
> > +++ b/drivers/net/virtio/main.c
> > @@ -1806,8 +1806,8 @@ static int virtnet_rx_resize(struct virtnet_info *vi,
> >  	return err;
> >  }
> >
> > -static int virtnet_tx_resize(struct virtnet_info *vi,
> > -			     struct send_queue *sq, u32 ring_num)
> > +static int __virtnet_tx_reset(struct virtnet_info *vi,
> > +			      struct send_queue *sq, u32 ring_num)
> >  {
> >  	bool running = netif_running(vi->dev);
> >  	struct netdev_queue *txq;
> > @@ -1833,7 +1833,11 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
> >
> >  	__netif_tx_unlock_bh(txq);
> >
> > -	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
> > +	if (ring_num)
> > +		err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
> > +	else
> > +		err = virtqueue_reset(sq->vq, virtnet_sq_free_unused_buf);
> > +
> >  	if (err)
> >  		netdev_err(vi->dev, "resize tx fail: tx queue index: %d err: %d\n", qindex, err);
> >
>
> This __virtnet_tx_reset is a really weird API.
>
> Suggest just splitting the common parts:
>
> __virtnet_tx_pause
> __virtnet_tx_resume
>
> we can then implement virtnet_tx_resize and virtnet_tx_reset
> using these two.

Good idea.

Thanks.

>
>
> > @@ -1847,6 +1851,17 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
> >  	return err;
> >  }
> >
> > +static int virtnet_tx_resize(struct virtnet_info *vi,
> > +			     struct send_queue *sq, u32 ring_num)
> > +{
> > +	return __virtnet_tx_reset(vi, sq, ring_num);
> > +}
> > +
> > +int virtnet_tx_reset(struct virtnet_info *vi, struct send_queue *sq)
> > +{
> > +	return __virtnet_tx_reset(vi, sq, 0);
> > +}
> > +
> >  /*
> >   * Send command via the control virtqueue and check status.  Commands
> >   * supported by the hypervisor, as indicated by feature bits, should
> > diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
> > index af3e7e817f9e..b46f083a630a 100644
> > --- a/drivers/net/virtio/virtio_net.h
> > +++ b/drivers/net/virtio/virtio_net.h
> > @@ -273,4 +273,5 @@ int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> >  			struct net_device *dev,
> >  			unsigned int *xdp_xmit,
> >  			struct virtnet_rq_stats *stats);
> > +int virtnet_tx_reset(struct virtnet_info *vi, struct send_queue *sq);
> >  #endif
> > --
> > 2.32.0.3.g01195cf9f
>
