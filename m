Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5E1689307
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjBCJCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjBCJCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:02:10 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FAA92C03;
        Fri,  3 Feb 2023 01:02:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VaoDUkj_1675414924;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VaoDUkj_1675414924)
          by smtp.aliyun-inc.com;
          Fri, 03 Feb 2023 17:02:04 +0800
Message-ID: <1675414906.6582208-6-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 16/33] virtio_net: introduce virtnet_xdp_handler() to seprate the logic of run xdp
Date:   Fri, 3 Feb 2023 17:01:46 +0800
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
 <20230202110058.130695-17-xuanzhuo@linux.alibaba.com>
 <20230203035416-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230203035416-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 03:55:26 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Feb 02, 2023 at 07:00:41PM +0800, Xuan Zhuo wrote:
> > At present, we have two long similar logic to perform XDP Progs. And in
> > the implementation of XSK, we will have this need.
> >
> > Therefore, this PATCH separates the code of executing XDP, which is
> > conducive to later maintenance and facilitates subsequent XSK for reuse.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> So you first add a new function then move users over.
> This means that it's hard during review to make sure
> nothing is lost in translation.
> Do the refactoring in a single patch instead.

I agree.

Thanks.

>
> > ---
> >  drivers/net/virtio/main.c       | 53 +++++++++++++++++++++++++++++++++
> >  drivers/net/virtio/virtio_net.h | 11 +++++++
> >  2 files changed, 64 insertions(+)
> >
> > diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> > index 5683cb576474..9d4b84b23ef7 100644
> > --- a/drivers/net/virtio/main.c
> > +++ b/drivers/net/virtio/main.c
> > @@ -478,6 +478,59 @@ static int virtnet_xdp_xmit(struct net_device *dev,
> >  	return ret;
> >  }
> >
> > +int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> > +			struct net_device *dev,
> > +			unsigned int *xdp_xmit,
> > +			struct virtnet_rq_stats *stats)
> > +{
> > +	struct xdp_frame *xdpf;
> > +	int err;
> > +	u32 act;
> > +
> > +	act = bpf_prog_run_xdp(xdp_prog, xdp);
> > +	stats->xdp_packets++;
> > +
> > +	switch (act) {
> > +	case XDP_PASS:
> > +		return VIRTNET_XDP_RES_PASS;
> > +
> > +	case XDP_TX:
> > +		stats->xdp_tx++;
> > +		xdpf = xdp_convert_buff_to_frame(xdp);
> > +		if (unlikely(!xdpf))
> > +			return VIRTNET_XDP_RES_DROP;
> > +
> > +		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> > +		if (unlikely(!err)) {
> > +			xdp_return_frame_rx_napi(xdpf);
> > +		} else if (unlikely(err < 0)) {
> > +			trace_xdp_exception(dev, xdp_prog, act);
> > +			return VIRTNET_XDP_RES_DROP;
> > +		}
> > +
> > +		*xdp_xmit |= VIRTIO_XDP_TX;
> > +		return VIRTNET_XDP_RES_CONSUMED;
> > +
> > +	case XDP_REDIRECT:
> > +		stats->xdp_redirects++;
> > +		err = xdp_do_redirect(dev, xdp, xdp_prog);
> > +		if (err)
> > +			return VIRTNET_XDP_RES_DROP;
> > +
> > +		*xdp_xmit |= VIRTIO_XDP_REDIR;
> > +		return VIRTNET_XDP_RES_CONSUMED;
> > +
> > +	default:
> > +		bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> > +		fallthrough;
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(dev, xdp_prog, act);
> > +		fallthrough;
> > +	case XDP_DROP:
> > +		return VIRTNET_XDP_RES_DROP;
> > +	}
> > +}
> > +
> >  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> >  {
> >  	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
> > diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
> > index 8bf31429ae28..af3e7e817f9e 100644
> > --- a/drivers/net/virtio/virtio_net.h
> > +++ b/drivers/net/virtio/virtio_net.h
> > @@ -22,6 +22,12 @@
> >  #include <net/net_failover.h>
> >  #include <net/xdp_sock_drv.h>
> >
> > +enum {
> > +	VIRTNET_XDP_RES_PASS,
> > +	VIRTNET_XDP_RES_DROP,
> > +	VIRTNET_XDP_RES_CONSUMED,
> > +};
> > +
> >  #define VIRTIO_XDP_FLAG	BIT(0)
> >
> >  struct virtnet_info {
> > @@ -262,4 +268,9 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> >  		stats->packets++;
> >  	}
> >  }
> > +
> > +int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> > +			struct net_device *dev,
> > +			unsigned int *xdp_xmit,
> > +			struct virtnet_rq_stats *stats);
> >  #endif
> > --
> > 2.32.0.3.g01195cf9f
>
