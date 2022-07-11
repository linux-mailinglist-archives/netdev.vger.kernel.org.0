Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68E5562BE7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiGAGnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGAGnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:43:39 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB931913;
        Thu, 30 Jun 2022 23:43:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VHzJr.6_1656657809;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHzJr.6_1656657809)
          by smtp.aliyun-inc.com;
          Fri, 01 Jul 2022 14:43:30 +0800
Message-ID: <1656657725.7418885-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 02/40] virtio: struct virtio_config_ops add callbacks for queue_reset
Date:   Fri, 1 Jul 2022 14:42:05 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-3-xuanzhuo@linux.alibaba.com>
 <20220701022728-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220701022728-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Jul 2022 02:28:46 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Jun 29, 2022 at 02:56:18PM +0800, Xuan Zhuo wrote:
> > reset can be divided into the following four steps (example):
> >  1. transport: notify the device to reset the queue
> >  2. vring:     recycle the buffer submitted
> >  3. vring:     reset/resize the vring (may re-alloc)
> >  4. transport: mmap vring to device, and enable the queue
> >
> > In order to support queue reset, add two callbacks(reset_vq,
> > enable_reset_vq) in struct virtio_config_ops to implement steps 1 and 4.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  include/linux/virtio_config.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > index b47c2e7ed0ee..ded51b0d4823 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -78,6 +78,16 @@ struct virtio_shm_region {
> >   * @set_vq_affinity: set the affinity for a virtqueue (optional).
> >   * @get_vq_affinity: get the affinity for a virtqueue (optional).
> >   * @get_shm_region: get a shared memory region based on the index.
> > + * @reset_vq: reset a queue individually (optional).
> > + *	vq: the virtqueue
> > + *	Returns 0 on success or error status
> > + *	reset_vq will guarantee that the callbacks are disabled and synchronized.
> > + *	Except for the callback, the caller should guarantee that the vring is
> > + *	not accessed by any functions of virtqueue.
> > + * @enable_reset_vq: enable a reset queue
> > + *	vq: the virtqueue
> > + *	Returns 0 on success or error status
> > + *	If reset_vq is set, then enable_reset_vq must also be set.
> >   */
> >  typedef void vq_callback_t(struct virtqueue *);
> >  struct virtio_config_ops {
> > @@ -104,6 +114,8 @@ struct virtio_config_ops {
> >  			int index);
> >  	bool (*get_shm_region)(struct virtio_device *vdev,
> >  			       struct virtio_shm_region *region, u8 id);
> > +	int (*reset_vq)(struct virtqueue *vq);
> > +	int (*enable_reset_vq)(struct virtqueue *vq);
> >  };
>
> The names need some tweaking.
> I came up with
>  	int (*disable_vq_and_reset)(struct virtqueue *vq);
>  	int (*enable_vq_after_reset)(struct virtqueue *vq);

OK, I will use these two names in the next version.

Hope Jason likes it too.

Thanks.


>
>
> >  /* If driver didn't advertise the feature, it will never appear. */
> > --
> > 2.31.0
>
