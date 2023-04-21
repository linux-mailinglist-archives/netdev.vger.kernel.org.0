Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689B66EA4D1
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjDUHb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDUHbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:31:24 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45150768B;
        Fri, 21 Apr 2023 00:30:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgbmRQT_1682062252;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgbmRQT_1682062252)
          by smtp.aliyun-inc.com;
          Fri, 21 Apr 2023 15:30:53 +0800
Message-ID: <1682061840.4864874-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v2 05/14] virtio_net: introduce xdp res enums
Date:   Fri, 21 Apr 2023 15:24:00 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
 <20230418065327.72281-6-xuanzhuo@linux.alibaba.com>
 <20230421025931-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230421025931-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 03:00:15 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Tue, Apr 18, 2023 at 02:53:18PM +0800, Xuan Zhuo wrote:
> > virtnet_xdp_handler() is to process all the logic related to XDP. The
> > caller only needs to care about how to deal with the buf. So this commit
> > introduces new enums:
> >
> > 1. VIRTNET_XDP_RES_PASS: make skb by the buf
> > 2. VIRTNET_XDP_RES_DROP: xdp return drop action or some error, caller
> >    should release the buf
> > 3. VIRTNET_XDP_RES_CONSUMED: xdp consumed the buf, the caller doesnot to
> >    do anything
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
>
> I am not excited about using virtio specific enums then translating
> to standard ones.


My fault, my expression is not very complete.

This is not a replacement, but just want to say, there are only three cases of
virtnet_xdp_handler. Caller only needs to handle this three cases. Instead
of paying attention to the detailed return results of XDP.

In addition, virtnet_xdp_handler returns XDP_TX, but in fact, the work of XDP_TX
is already done in Virtnet_xdp_handler. Caller does not need to do anything for
XDP_TX, giving people a feeling, XDP_TX does not need to be processed. I think
it is not good.

Thanks.



>
> > ---
> >  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++--------------
> >  1 file changed, 27 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 0fa64c314ea7..4dfdc211d355 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -301,6 +301,15 @@ struct padded_vnet_hdr {
> >  	char padding[12];
> >  };
> >
> > +enum {
> > +	/* xdp pass */
> > +	VIRTNET_XDP_RES_PASS,
> > +	/* drop packet. the caller needs to release the page. */
> > +	VIRTNET_XDP_RES_DROP,
> > +	/* packet is consumed by xdp. the caller needs to do nothing. */
> > +	VIRTNET_XDP_RES_CONSUMED,
> > +};
> > +
> >  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
> >  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
> >
> > @@ -803,14 +812,14 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> >
> >  	switch (act) {
> >  	case XDP_PASS:
> > -		return act;
> > +		return VIRTNET_XDP_RES_PASS;
> >
> >  	case XDP_TX:
> >  		stats->xdp_tx++;
> >  		xdpf = xdp_convert_buff_to_frame(xdp);
> >  		if (unlikely(!xdpf)) {
> >  			netdev_dbg(dev, "convert buff to frame failed for xdp\n");
> > -			return XDP_DROP;
> > +			return VIRTNET_XDP_RES_DROP;
> >  		}
> >
> >  		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> > @@ -818,19 +827,20 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> >  			xdp_return_frame_rx_napi(xdpf);
> >  		} else if (unlikely(err < 0)) {
> >  			trace_xdp_exception(dev, xdp_prog, act);
> > -			return XDP_DROP;
> > +			return VIRTNET_XDP_RES_DROP;
> >  		}
> > +
> >  		*xdp_xmit |= VIRTIO_XDP_TX;
> > -		return act;
> > +		return VIRTNET_XDP_RES_CONSUMED;
> >
> >  	case XDP_REDIRECT:
> >  		stats->xdp_redirects++;
> >  		err = xdp_do_redirect(dev, xdp, xdp_prog);
> >  		if (err)
> > -			return XDP_DROP;
> > +			return VIRTNET_XDP_RES_DROP;
> >
> >  		*xdp_xmit |= VIRTIO_XDP_REDIR;
> > -		return act;
> > +		return VIRTNET_XDP_RES_CONSUMED;
> >
> >  	default:
> >  		bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> > @@ -839,7 +849,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> >  		trace_xdp_exception(dev, xdp_prog, act);
> >  		fallthrough;
> >  	case XDP_DROP:
> > -		return XDP_DROP;
> > +		return VIRTNET_XDP_RES_DROP;
> >  	}
> >  }
> >
> > @@ -987,17 +997,18 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >  		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
> >
> >  		switch (act) {
> > -		case XDP_PASS:
> > +		case VIRTNET_XDP_RES_PASS:
> >  			/* Recalculate length in case bpf program changed it */
> >  			delta = orig_data - xdp.data;
> >  			len = xdp.data_end - xdp.data;
> >  			metasize = xdp.data - xdp.data_meta;
> >  			break;
> > -		case XDP_TX:
> > -		case XDP_REDIRECT:
> > +
> > +		case VIRTNET_XDP_RES_CONSUMED:
> >  			rcu_read_unlock();
> >  			goto xdp_xmit;
> > -		default:
> > +
> > +		case VIRTNET_XDP_RES_DROP:
> >  			goto err_xdp;
> >  		}
> >  	}
> > @@ -1324,18 +1335,19 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >  		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
> >
> >  		switch (act) {
> > -		case XDP_PASS:
> > +		case VIRTNET_XDP_RES_PASS:
> >  			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> >  			if (unlikely(!head_skb))
> >  				goto err_xdp_frags;
> >
> >  			rcu_read_unlock();
> >  			return head_skb;
> > -		case XDP_TX:
> > -		case XDP_REDIRECT:
> > +
> > +		case VIRTNET_XDP_RES_CONSUMED:
> >  			rcu_read_unlock();
> >  			goto xdp_xmit;
> > -		default:
> > +
> > +		case VIRTNET_XDP_RES_DROP:
> >  			break;
> >  		}
> >  err_xdp_frags:
> > --
> > 2.32.0.3.g01195cf9f
>
