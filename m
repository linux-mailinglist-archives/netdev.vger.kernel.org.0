Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0C8689326
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjBCJJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjBCJJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:09:33 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C5F93AD5;
        Fri,  3 Feb 2023 01:09:29 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VaoDXEV_1675415365;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VaoDXEV_1675415365)
          by smtp.aliyun-inc.com;
          Fri, 03 Feb 2023 17:09:26 +0800
Message-ID: <1675415352.3250086-8-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 06/33] virtio_ring: introduce virtqueue_reset()
Date:   Fri, 3 Feb 2023 17:09:12 +0800
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
 <20230202110058.130695-7-xuanzhuo@linux.alibaba.com>
 <20230203040041-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230203040041-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 04:05:38 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Feb 02, 2023 at 07:00:31PM +0800, Xuan Zhuo wrote:
> > Introduce virtqueue_reset() to release all buffer inside vq.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/virtio/virtio_ring.c | 50 ++++++++++++++++++++++++++++++++++++
> >  include/linux/virtio.h       |  2 ++
> >  2 files changed, 52 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index e32046fd15a5..7dfce7001f9f 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2735,6 +2735,56 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
> >  }
> >  EXPORT_SYMBOL_GPL(virtqueue_resize);
> >
> > +/**
> > + * virtqueue_reset - reset the vring of vq
>
> ..., detach and recycle all unused buffers
>
> 	after all this is why we are doing this reset, right?
>
> > + * @_vq: the struct virtqueue we're talking about.
> > + * @recycle: callback for recycle the useless buffer
>
> not useless :) unused:
>
> 	callback to recycle unused buffers


I agree. Will fix.

Thanks.

>
> I know we have the same confusion in virtqueue_resize, I will fix
> that.
>
> > + *
> > + * Caller must ensure we don't call this with other virtqueue operations
> > + * at the same time (except where noted).
> > + *
> > + * Returns zero or a negative error.
> > + * 0: success.
> > + * -EBUSY: Failed to sync with device, vq may not work properly
> > + * -ENOENT: Transport or device not supported
> > + * -EPERM: Operation not permitted
> > + */
> > +int virtqueue_reset(struct virtqueue *_vq,
> > +		    void (*recycle)(struct virtqueue *vq, void *buf))
> > +{
> > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > +	struct virtio_device *vdev = vq->vq.vdev;
> > +	void *buf;
> > +	int err;
> > +
> > +	if (!vq->we_own_ring)
> > +		return -EPERM;
> > +
> > +	if (!vdev->config->disable_vq_and_reset)
> > +		return -ENOENT;
> > +
> > +	if (!vdev->config->enable_vq_after_reset)
> > +		return -ENOENT;
> > +
> > +	err = vdev->config->disable_vq_and_reset(_vq);
> > +	if (err)
> > +		return err;
> > +
> > +	while ((buf = virtqueue_detach_unused_buf(_vq)) != NULL)
> > +		recycle(_vq, buf);
> > +
> > +	if (vq->packed_ring)
> > +		virtqueue_reinit_packed(vq);
> > +	else
> > +		virtqueue_reinit_split(vq);
> > +
> > +	if (vdev->config->enable_vq_after_reset(_vq))
> > +		return -EBUSY;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_reset);
> > +
> >  /* Only available for split ring */
> >  struct virtqueue *vring_new_virtqueue(unsigned int index,
> >  				      unsigned int num,
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index 3ebb346ebb7c..3ca2edb1aef3 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -105,6 +105,8 @@ dma_addr_t virtqueue_get_used_addr(struct virtqueue *vq);
> >
> >  int virtqueue_resize(struct virtqueue *vq, u32 num,
> >  		     void (*recycle)(struct virtqueue *vq, void *buf));
> > +int virtqueue_reset(struct virtqueue *vq,
> > +		    void (*recycle)(struct virtqueue *vq, void *buf));
> >
> >  /**
> >   * struct virtio_device - representation of a device using virtio
> > --
> > 2.32.0.3.g01195cf9f
>
