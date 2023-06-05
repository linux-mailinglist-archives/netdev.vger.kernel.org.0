Return-Path: <netdev+bounces-7825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C055721BCE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FA172810B7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A63538D;
	Mon,  5 Jun 2023 02:09:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F9219B;
	Mon,  5 Jun 2023 02:09:13 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9CFAD;
	Sun,  4 Jun 2023 19:09:10 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VkIIE19_1685930945;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VkIIE19_1685930945)
          by smtp.aliyun-inc.com;
          Mon, 05 Jun 2023 10:09:06 +0800
Message-ID: <1685930811.137484-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v10 07/10] virtio_ring: introduce helpers for premapped
Date: Mon, 5 Jun 2023 10:06:51 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 netdev@vger.kernel.org,
 bpf@vger.kernel.org
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
 <20230602092206.50108-8-xuanzhuo@linux.alibaba.com>
 <20230604094122-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230604094122-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Sun, 4 Jun 2023 09:45:14 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Jun 02, 2023 at 05:22:03PM +0800, Xuan Zhuo wrote:
> > This patch introduces three helpers for premapped mode.
> >
> > * virtqueue_get_buf_premapped
> > * virtqueue_detach_unused_buf_premapped
> >
> > The above helpers work like the non-premapped funcs. But a cursor is
> > passed.
> >
> > virtqueue_detach is used to get the dma info of the last buf by
> >   cursor.
>
> This isn't very clear from the description but virtqueue_detach is
> also introduced by this patch as opposed to being used.
>
>
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/virtio/virtio_ring.c | 83 ++++++++++++++++++++++++++++++++++++
> >  include/linux/virtio.h       | 10 +++++
> >  2 files changed, 93 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index cbc22daae7e1..6771b9661798 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2555,6 +2555,66 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
> >  	return virtqueue_get_buf_ctx(_vq, len, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(virtqueue_get_buf);
> > +
> > +/**
> > + * virtqueue_get_buf_premapped - get the next used buffer
> > + * @_vq: the struct virtqueue we're talking about.
> > + * @len: the length written into the buffer
> > + * @ctx: extra context for the token
> > + * @cursor: detach cursor
> > + *
> > + * If the device wrote data into the buffer, @len will be set to the
> > + * amount written.  This means you don't need to clear the buffer
> > + * beforehand to ensure there's no data leakage in the case of short
> > + * writes.
> > + *
> > + * Caller must ensure we don't call this with other virtqueue
> > + * operations at the same time (except where noted).
> > + *
> > + * This is used for the premapped vq. The cursor is passed by the dirver, that
> > + * is used for virtqueue_detach. That will be initialized by virtio core
> > + * internally.
> > + *
> > + * Returns NULL if there are no used buffers, or the "data" token
> > + * handed to virtqueue_add_*().
> > + */
> > +void *virtqueue_get_buf_premapped(struct virtqueue *_vq, unsigned int *len,
> > +				  void **ctx,
> > +				  struct virtqueue_detach_cursor *cursor)
> > +{
> > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > +
> > +	return vq->packed_ring ? virtqueue_get_buf_ctx_packed(_vq, len, ctx, cursor) :
> > +				 virtqueue_get_buf_ctx_split(_vq, len, ctx, cursor);
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_get_buf_premapped);
> > +
> > +/**
> > + * virtqueue_detach - get the dma info of last buf
>
> detach what from what then?
> I am guessing this is not the only thing this function does?
> sounds like a bad name for a function.

Let me think of a good name

>
> > + * @_vq: the struct virtqueue we're talking about.
> > + * @cursor: detach cursor
> > + * @addr: the dma address
>
> what address?  it's the 1st time you mention an address ...

Will fix.


>
> > + * @len: the length of the dma address
> > + * @dir: the direction of the dma address
> > + *
> > + * This is used for the premapped vq. The cursor is initialized by
> > + * virtqueue_get_buf_premapped or virtqueue_detach_unused_buf_premapped.
> > + *
> > + * Returns:
> > + * -EAGAIN: there are more dma info, this function should be called more.
>
> here too, pls don't return -EAGAIN not in an error case.
> something like "1" will do.

While I agree with you, -EAGAIN seems to be a commonly used method. How about we
return EAGAIN instead of -EAGAIN ?

Thanks.



>
> > + * -EINVAL: the process is done, should not call this function
> > + * 0: no more dma info
> > + */
> > +int virtqueue_detach(struct virtqueue *_vq, struct virtqueue_detach_cursor *cursor,
> > +		     dma_addr_t *addr, u32 *len, enum dma_data_direction *dir)
> > +{
> > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > +
> > +	return vq->packed_ring ? virtqueue_detach_packed(_vq, cursor, addr, len, dir) :
> > +				 virtqueue_detach_split(_vq, cursor, addr, len, dir);
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_detach);
> > +
> >  /**
> >   * virtqueue_disable_cb - disable callbacks
> >   * @_vq: the struct virtqueue we're talking about.
> > @@ -2682,6 +2742,29 @@ void *virtqueue_detach_unused_buf(struct virtqueue *_vq)
> >  }
> >  EXPORT_SYMBOL_GPL(virtqueue_detach_unused_buf);
> >
> > +/**
> > + * virtqueue_detach_unused_buf_premapped - detach first unused buffer
> > + * @_vq: the struct virtqueue we're talking about.
> > + * @cursor: detach cursor
> > + *
> > + * This is used for the premapped vq. The cursor is passed by the dirver, that
> > + * is used for virtqueue_detach. That will be initialized by virtio core
> > + * internally.
> > + *
> > + * Returns NULL or the "data" token handed to virtqueue_add_*().
> > + * This is not valid on an active queue; it is useful for device
> > + * shutdown or the reset queue.
> > + */
> > +void *virtqueue_detach_unused_buf_premapped(struct virtqueue *_vq,
> > +					    struct virtqueue_detach_cursor *cursor)
> > +{
> > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > +
> > +	return vq->packed_ring ? virtqueue_detach_unused_buf_packed(_vq, cursor) :
> > +				 virtqueue_detach_unused_buf_split(_vq, cursor);
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_detach_unused_buf_premapped);
> > +
> >  static inline bool more_used(const struct vring_virtqueue *vq)
> >  {
> >  	return vq->packed_ring ? more_used_packed(vq) : more_used_split(vq);
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index 7f137c7a9034..0a11c5b32fe5 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -3,6 +3,7 @@
> >  #define _LINUX_VIRTIO_H
> >  /* Everything a virtio driver needs to work with any particular virtio
> >   * implementation. */
> > +#include <linux/dma-mapping.h>
> >  #include <linux/types.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/spinlock.h>
> > @@ -88,6 +89,10 @@ void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
> >  void *virtqueue_get_buf_ctx(struct virtqueue *vq, unsigned int *len,
> >  			    void **ctx);
> >
> > +void *virtqueue_get_buf_premapped(struct virtqueue *_vq, unsigned int *len,
> > +				  void **ctx,
> > +				  struct virtqueue_detach_cursor *cursor);
> > +
> >  void virtqueue_disable_cb(struct virtqueue *vq);
> >
> >  bool virtqueue_enable_cb(struct virtqueue *vq);
> > @@ -101,6 +106,8 @@ bool virtqueue_poll(struct virtqueue *vq, unsigned);
> >  bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
> >
> >  void *virtqueue_detach_unused_buf(struct virtqueue *vq);
> > +void *virtqueue_detach_unused_buf_premapped(struct virtqueue *_vq,
> > +					    struct virtqueue_detach_cursor *cursor);
> >
> >  unsigned int virtqueue_get_vring_size(const struct virtqueue *vq);
> >
> > @@ -114,6 +121,9 @@ dma_addr_t virtqueue_get_used_addr(const struct virtqueue *vq);
> >  int virtqueue_resize(struct virtqueue *vq, u32 num,
> >  		     void (*recycle)(struct virtqueue *vq, void *buf));
> >
> > +int virtqueue_detach(struct virtqueue *_vq, struct virtqueue_detach_cursor *cursor,
> > +		     dma_addr_t *addr, u32 *len, enum dma_data_direction *dir);
> > +
> >  /**
> >   * struct virtio_device - representation of a device using virtio
> >   * @index: unique position on the virtio bus
> > --
> > 2.32.0.3.g01195cf9f
>

