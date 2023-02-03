Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552ED6892D7
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjBCIzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjBCIzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:55:51 -0500
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0287C1D928;
        Fri,  3 Feb 2023 00:55:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VaoDSAa_1675414545;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VaoDSAa_1675414545)
          by smtp.aliyun-inc.com;
          Fri, 03 Feb 2023 16:55:46 +0800
Message-ID: <1675414526.084923-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 29/33] virtio_net: xsk: tx: support tx
Date:   Fri, 3 Feb 2023 16:55:26 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-30-xuanzhuo@linux.alibaba.com>
 <Y9zIPdKmTvXqyuYS@boxer>
In-Reply-To: <Y9zIPdKmTvXqyuYS@boxer>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 09:39:25 +0100, Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> On Thu, Feb 02, 2023 at 07:00:54PM +0800, Xuan Zhuo wrote:
> > The driver's tx napi is very important for XSK. It is responsible for
> > obtaining data from the XSK queue and sending it out.
> >
> > At the beginning, we need to trigger tx napi.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio/main.c |  12 +++-
> >  drivers/net/virtio/xsk.c  | 146 ++++++++++++++++++++++++++++++++++++++
> >  drivers/net/virtio/xsk.h  |   2 +
> >  3 files changed, 159 insertions(+), 1 deletion(-)
> >
>
> (...)
>
> > +static int virtnet_xsk_xmit_batch(struct send_queue *sq,
> > +				  struct xsk_buff_pool *pool,
> > +				  unsigned int budget,
> > +				  struct virtnet_sq_stats *stats)
> > +{
> > +	int ret = XSK_XMIT_NO_BUDGET;
> > +	struct xdp_desc desc;
> > +	int err, packet = 0;
> > +
> > +	while (budget-- > 0) {
> > +		if (sq->vq->num_free < 2) {
> > +			__free_old_xmit(sq, true, stats);
> > +			if (sq->vq->num_free < 2) {
> > +				ret = XSK_XMIT_DEV_BUSY;
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (!xsk_tx_peek_desc(pool, &desc)) {
>
> anything that stopped from using xsk_tx_peek_release_desc_batch() ?


Great!

Will fix.

Thanks.


>
> > +			ret = XSK_XMIT_DONE;
> > +			break;
> > +		}
> > +
> > +		err = virtnet_xsk_xmit_one(sq, pool, &desc);
> > +		if (unlikely(err)) {
> > +			ret = XSK_XMIT_DEV_BUSY;
> > +			break;
> > +		}
> > +
> > +		++packet;
> > +
> > +		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
> > +			++stats->kicks;
> > +	}
> > +
> > +	if (packet) {
> > +		stats->xdp_tx += packet;
> > +
> > +		xsk_tx_release(pool);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
> > +		      int budget)
> > +{
> > +	struct virtnet_sq_stats stats = {};
> > +	bool busy;
> > +	int ret;
> > +
> > +	__free_old_xmit(sq, true, &stats);
> > +
> > +	if (xsk_uses_need_wakeup(pool))
> > +		xsk_set_tx_need_wakeup(pool);
> > +
> > +	ret = virtnet_xsk_xmit_batch(sq, pool, budget, &stats);
> > +	switch (ret) {
> > +	case XSK_XMIT_DONE:
> > +		/* xsk tx qeueu has been consumed done. should complete napi. */
> > +		busy = false;
> > +		break;
> > +
> > +	case XSK_XMIT_NO_BUDGET:
> > +		/* reach the budget limit. should let napi run again. */
> > +		busy = true;
> > +		break;
> > +
> > +	case XSK_XMIT_DEV_BUSY:
> > +		/* sq vring is full, should complete napi. wait for tx napi been
> > +		 * triggered by interrupt.
> > +		 */
> > +		busy = false;
> > +		break;
> > +	}
> > +
> > +	virtnet_xsk_check_queue(sq);
> > +
> > +	u64_stats_update_begin(&sq->stats.syncp);
> > +	sq->stats.packets += stats.packets;
> > +	sq->stats.bytes += stats.bytes;
> > +	sq->stats.kicks += stats.kicks;
> > +	sq->stats.xdp_tx += stats.xdp_tx;
> > +	u64_stats_update_end(&sq->stats.syncp);
> > +
> > +	return busy;
> > +}
> > +
> >  static int virtnet_rq_bind_xsk_pool(struct virtnet_info *vi, struct receive_queue *rq,
> >  				    struct xsk_buff_pool *pool, struct net_device *dev)
> >  {
> > diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
> > index ad684c812091..15f1540a5803 100644
> > --- a/drivers/net/virtio/xsk.h
> > +++ b/drivers/net/virtio/xsk.h
> > @@ -20,4 +20,6 @@ static inline u32 ptr_to_xsk(void *ptr)
> >  }
> >
> >  int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
> > +bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
> > +		      int budget);
> >  #endif
> > --
> > 2.32.0.3.g01195cf9f
> >
