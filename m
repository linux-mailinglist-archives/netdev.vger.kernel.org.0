Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F536892AF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjBCIvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCIvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:51:08 -0500
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0E122DD9;
        Fri,  3 Feb 2023 00:51:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VaoDQSb_1675414258;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VaoDQSb_1675414258)
          by smtp.aliyun-inc.com;
          Fri, 03 Feb 2023 16:50:59 +0800
Message-ID: <1675414156.9460502-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 24/33] virtio_net: xsk: stop disable tx napi
Date:   Fri, 3 Feb 2023 16:49:16 +0800
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
 <20230202110058.130695-25-xuanzhuo@linux.alibaba.com>
 <20230202122445-mutt-send-email-mst@kernel.org>
 <1675394682.9569418-1-xuanzhuo@linux.alibaba.com>
 <20230203032945-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230203032945-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 03:33:41 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Feb 03, 2023 at 11:24:42AM +0800, Xuan Zhuo wrote:
> > On Thu, 2 Feb 2023 12:25:59 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Thu, Feb 02, 2023 at 07:00:49PM +0800, Xuan Zhuo wrote:
> > > > Since xsk's TX queue is consumed by TX NAPI, if sq is bound to xsk, then
> > > > we must stop tx napi from being disabled.
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >  drivers/net/virtio/main.c | 9 ++++++++-
> > > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> > > > index ed79e750bc6c..232cf151abff 100644
> > > > --- a/drivers/net/virtio/main.c
> > > > +++ b/drivers/net/virtio/main.c
> > > > @@ -2728,8 +2728,15 @@ static int virtnet_set_coalesce(struct net_device *dev,
> > > >  		return ret;
> > > >
> > > >  	if (update_napi) {
> > > > -		for (i = 0; i < vi->max_queue_pairs; i++)
> > > > +		for (i = 0; i < vi->max_queue_pairs; i++) {
> > > > +			/* xsk xmit depend on the tx napi. So if xsk is active,
> > >
> > > depends.
> > >
> > > > +			 * prevent modifications to tx napi.
> > > > +			 */
> > > > +			if (rtnl_dereference(vi->sq[i].xsk.pool))
> > > > +				continue;
> > > > +
> > > >  			vi->sq[i].napi.weight = napi_weight;
> > >
> > > I don't get it.
> > > changing napi weight does not work then.
> > > why is this ok?
> >
> >
> > static void skb_xmit_done(struct virtqueue *vq)
> > {
> > 	struct virtnet_info *vi = vq->vdev->priv;
> > 	struct napi_struct *napi = &vi->sq[vq2txq(vq)].napi;
> >
> > 	/* Suppress further interrupts. */
> > 	virtqueue_disable_cb(vq);
> >
> > 	if (napi->weight)
> > 		virtqueue_napi_schedule(napi, vq);
> > 	else
> > 		/* We were probably waiting for more output buffers. */
> > 		netif_wake_subqueue(vi->dev, vq2txq(vq));
> > }
> >
> >
> > If the weight is 0, tx napi will not be triggered again.
> >
> > Thanks.
>
> This needs more thought then. First ignoring what user is requesting is
> not nice.

Maybe we should return an error.

>Second what if napi is first disabled and then xsk enabled?


static int virtnet_xsk_pool_enable(struct net_device *dev,
				   struct xsk_buff_pool *pool,
				   u16 qid)
{
	struct virtnet_info *vi = netdev_priv(dev);
	struct receive_queue *rq;
	struct send_queue *sq;
	int err;

	if (qid >= vi->curr_queue_pairs)
		return -EINVAL;

	sq = &vi->sq[qid];
	rq = &vi->rq[qid];

	/* xsk zerocopy depend on the tx napi.
	 *
	 * All xsk packets are actually consumed and sent out from the xsk tx
	 * queue under the tx napi mechanism.
	 */
->	if (!sq->napi.weight)
		return -EPERM;

Thanks.


>
>
> > >
> > >
> > > > +		}
> > > >  	}
> > > >
> > > >  	return ret;
> > > > --
> > > > 2.32.0.3.g01195cf9f
> > >
>
