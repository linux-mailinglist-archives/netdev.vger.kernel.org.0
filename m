Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0224D4A06
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243091AbiCJOV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243817AbiCJOSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:18:24 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2981E166E31;
        Thu, 10 Mar 2022 06:14:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6onflR_1646921659;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6onflR_1646921659)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Mar 2022 22:14:20 +0800
Message-ID: <1646921388.7015996-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 09/26] virtio_ring: split: implement virtqueue_reset_vring_split()
Date:   Thu, 10 Mar 2022 22:09:48 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-10-xuanzhuo@linux.alibaba.com>
 <20220310015418-mutt-send-email-mst@kernel.org>
 <1646896623.3794115-2-xuanzhuo@linux.alibaba.com>
 <20220310025930-mutt-send-email-mst@kernel.org>
 <1646900056.7775025-1-xuanzhuo@linux.alibaba.com>
 <20220310071335-mutt-send-email-mst@kernel.org>
 <1646915610.3936472-1-xuanzhuo@linux.alibaba.com>
 <20220310080212-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220310080212-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 08:04:27 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Mar 10, 2022 at 08:33:30PM +0800, Xuan Zhuo wrote:
> > On Thu, 10 Mar 2022 07:17:09 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Thu, Mar 10, 2022 at 04:14:16PM +0800, Xuan Zhuo wrote:
> > > > On Thu, 10 Mar 2022 03:07:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > On Thu, Mar 10, 2022 at 03:17:03PM +0800, Xuan Zhuo wrote:
> > > > > > On Thu, 10 Mar 2022 02:00:39 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > > > On Tue, Mar 08, 2022 at 08:35:01PM +0800, Xuan Zhuo wrote:
> > > > > > > > virtio ring supports reset.
> > > > > > > >
> > > > > > > > Queue reset is divided into several stages.
> > > > > > > >
> > > > > > > > 1. notify device queue reset
> > > > > > > > 2. vring release
> > > > > > > > 3. attach new vring
> > > > > > > > 4. notify device queue re-enable
> > > > > > > >
> > > > > > > > After the first step is completed, the vring reset operation can be
> > > > > > > > performed. If the newly set vring num does not change, then just reset
> > > > > > > > the vq related value.
> > > > > > > >
> > > > > > > > Otherwise, the vring will be released and the vring will be reallocated.
> > > > > > > > And the vring will be attached to the vq. If this process fails, the
> > > > > > > > function will exit, and the state of the vq will be the vring release
> > > > > > > > state. You can call this function again to reallocate the vring.
> > > > > > > >
> > > > > > > > In addition, vring_align, may_reduce_num are necessary for reallocating
> > > > > > > > vring, so they are retained when creating vq.
> > > > > > > >
> > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > ---
> > > > > > > >  drivers/virtio/virtio_ring.c | 69 ++++++++++++++++++++++++++++++++++++
> > > > > > > >  1 file changed, 69 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > > > > > > index e0422c04c903..148fb1fd3d5a 100644
> > > > > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > > > > @@ -158,6 +158,12 @@ struct vring_virtqueue {
> > > > > > > >  			/* DMA address and size information */
> > > > > > > >  			dma_addr_t queue_dma_addr;
> > > > > > > >  			size_t queue_size_in_bytes;
> > > > > > > > +
> > > > > > > > +			/* The parameters for creating vrings are reserved for
> > > > > > > > +			 * creating new vrings when enabling reset queue.
> > > > > > > > +			 */
> > > > > > > > +			u32 vring_align;
> > > > > > > > +			bool may_reduce_num;
> > > > > > > >  		} split;
> > > > > > > >
> > > > > > > >  		/* Available for packed ring */
> > > > > > > > @@ -217,6 +223,12 @@ struct vring_virtqueue {
> > > > > > > >  #endif
> > > > > > > >  };
> > > > > > > >
> > > > > > > > +static void vring_free(struct virtqueue *vq);
> > > > > > > > +static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> > > > > > > > +					 struct virtio_device *vdev);
> > > > > > > > +static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> > > > > > > > +					  struct virtio_device *vdev,
> > > > > > > > +					  struct vring vring);
> > > > > > > >
> > > > > > > >  /*
> > > > > > > >   * Helpers.
> > > > > > > > @@ -1012,6 +1024,8 @@ static struct virtqueue *vring_create_virtqueue_split(
> > > > > > > >  		return NULL;
> > > > > > > >  	}
> > > > > > > >
> > > > > > > > +	to_vvq(vq)->split.vring_align = vring_align;
> > > > > > > > +	to_vvq(vq)->split.may_reduce_num = may_reduce_num;
> > > > > > > >  	to_vvq(vq)->split.queue_dma_addr = vring.dma_addr;
> > > > > > > >  	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
> > > > > > > >  	to_vvq(vq)->we_own_ring = true;
> > > > > > > > @@ -1019,6 +1033,59 @@ static struct virtqueue *vring_create_virtqueue_split(
> > > > > > > >  	return vq;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static int virtqueue_reset_vring_split(struct virtqueue *_vq, u32 num)
> > > > > > > > +{
> > > > > > > > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > > > > > > > +	struct virtio_device *vdev = _vq->vdev;
> > > > > > > > +	struct vring_split vring;
> > > > > > > > +	int err;
> > > > > > > > +
> > > > > > > > +	if (num > _vq->num_max)
> > > > > > > > +		return -E2BIG;
> > > > > > > > +
> > > > > > > > +	switch (vq->vq.reset) {
> > > > > > > > +	case VIRTIO_VQ_RESET_STEP_NONE:
> > > > > > > > +		return -ENOENT;
> > > > > > > > +
> > > > > > > > +	case VIRTIO_VQ_RESET_STEP_VRING_ATTACH:
> > > > > > > > +	case VIRTIO_VQ_RESET_STEP_DEVICE:
> > > > > > > > +		if (vq->split.vring.num == num || !num)
> > > > > > > > +			break;
> > > > > > > > +
> > > > > > > > +		vring_free(_vq);
> > > > > > > > +
> > > > > > > > +		fallthrough;
> > > > > > > > +
> > > > > > > > +	case VIRTIO_VQ_RESET_STEP_VRING_RELEASE:
> > > > > > > > +		if (!num)
> > > > > > > > +			num = vq->split.vring.num;
> > > > > > > > +
> > > > > > > > +		err = vring_create_vring_split(&vring, vdev,
> > > > > > > > +					       vq->split.vring_align,
> > > > > > > > +					       vq->weak_barriers,
> > > > > > > > +					       vq->split.may_reduce_num, num);
> > > > > > > > +		if (err)
> > > > > > > > +			return -ENOMEM;
> > > > > > > > +
> > > > > > > > +		err = __vring_virtqueue_attach_split(vq, vdev, vring.vring);
> > > > > > > > +		if (err) {
> > > > > > > > +			vring_free_queue(vdev, vring.queue_size_in_bytes,
> > > > > > > > +					 vring.queue,
> > > > > > > > +					 vring.dma_addr);
> > > > > > > > +			return -ENOMEM;
> > > > > > > > +		}
> > > > > > > > +
> > > > > > > > +		vq->split.queue_dma_addr = vring.dma_addr;
> > > > > > > > +		vq->split.queue_size_in_bytes = vring.queue_size_in_bytes;
> > > > > > > > +	}
> > > > > > > > +
> > > > > > > > +	__vring_virtqueue_init_split(vq, vdev);
> > > > > > > > +	vq->we_own_ring = true;
> > > > > > > > +	vq->vq.reset = VIRTIO_VQ_RESET_STEP_VRING_ATTACH;
> > > > > > > > +
> > > > > > > > +	return 0;
> > > > > > > > +}
> > > > > > > > +
> > > > > > >
> > > > > > > I kind of dislike this state machine.
> > > > > > >
> > > > > > > Hacks like special-casing num = 0 to mean "reset" are especially
> > > > > > > confusing.
> > > > > >
> > > > > > I'm removing it. I'll say in the function description that this function is
> > > > > > currently only called when vq has been reset. I'm no longer checking it based on
> > > > > > state.
> > > > > >
> > > > > > >
> > > > > > > And as Jason points out, when we want a resize then yes this currently
> > > > > > > implies reset but that is an implementation detail.
> > > > > > >
> > > > > > > There should be a way to just make these cases separate functions
> > > > > > > and then use them to compose consistent external APIs.
> > > > > >
> > > > > > Yes, virtqueue_resize_split() is fine for ethtool -G.
> > > > > >
> > > > > > But in the case of AF_XDP, just execute reset to free the buffer. The name
> > > > > > virtqueue_reset_vring_split() I think can cover both cases. Or we use two apis
> > > > > > to handle both scenarios?
> > > > > >
> > > > > > Or can anyone think of a better name. ^_^
> > > > > >
> > > > > > Thanks.
> > > > >
> > > > >
> > > > > I'd say resize should be called resize and reset should be called reset.
> > > >
> > > >
> > > > OK, I'll change it to resize here.
> > > >
> > > > But I want to know that when I implement virtio-net to support AF_XDP, its
> > > > requirement is to release all submitted buffers. Then should I add a new api
> > > > such as virtqueue_reset_vring()?
> > >
> > > Sounds like a reasonable name.
> > >
> > > > >
> > > > > The big issue is a sane API for resize. Ideally it would resubmit
> > > > > buffers which did not get used. Question is what to do
> > > > > about buffers which don't fit (if ring has been downsized)?
> > > > > Maybe a callback that will handle them?
> > > > > And then what? Queue them up and readd later? Drop?
> > > > > If we drop we should drop from the head not the tail ...
> > > >
> > > > It's a good idea, let's implement it later.
> > > >
> > > > Thanks.
> > >
> > > Well ... not sure how you are going to support resize
> > > if you don't know what to do with buffers that were
> > > in the ring.
> >
> > The current solution is to call virtqueue_detach_unused_buf() to release buffers
> > before resize ring.
> >
> > Thanks.
>
> This requires basically a richer api:
> - stop
> - detach
> - resize
> - start

Yes, that's how it is currently implemented.

>
> with a callback you would just have a resize, and the fact
> it resets internally becomes an implementation detail.


I think, I understand what you mean, we encapsulate the following code into a
function as an external interface.

int virtqueue_resize(vq, callback)
{
	err = virtqueue_reset(sq->vq);
	if (err) {
		netif_start_subqueue(vi->dev, qindex);
		goto err;
	}

	/* detach */
	while ((buf = virtqueue_detach_unused_buf(sq->vq)) != NULL) {
		callback(vq, buf);
	}

	err = virtqueue_resize(sq->vq, ring_num);
	if (err)
		goto err;

	err = virtqueue_enable_resetq(sq->vq);
	if (err)
		goto err;
}

Thanks.

>
> --
> MST
>
