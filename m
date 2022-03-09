Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9934D2BF1
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiCIJ3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiCIJ3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:29:09 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90D4C6235;
        Wed,  9 Mar 2022 01:28:09 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6j5umZ_1646818083;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6j5umZ_1646818083)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:28:04 +0800
Message-ID: <1646818039.8335996-8-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 14/26] virtio: add helper for queue reset
Date:   Wed, 9 Mar 2022 17:27:19 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-15-xuanzhuo@linux.alibaba.com>
 <fda406d7-3ed9-7c62-0f26-4058a63e73a9@redhat.com>
In-Reply-To: <fda406d7-3ed9-7c62-0f26-4058a63e73a9@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 16:48:28 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:35, Xuan Zhuo =E5=86=99=E9=81=93:
> > Add helper for virtio queue reset.
> >
> > * virtio_reset_vq(): reset a queue individually
> > * virtio_enable_resetq(): enable a reset queue
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   include/linux/virtio_config.h | 40 +++++++++++++++++++++++++++++++++++
> >   1 file changed, 40 insertions(+)
> >
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_confi=
g.h
> > index d51906b1389f..0b81fbe17c85 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -230,6 +230,46 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev=
, unsigned nvqs,
> >   				      desc);
> >   }
> >
> > +/**
> > + * virtio_reset_vq - reset a queue individually
> > + * @vq: the virtqueue
> > + *
> > + * returns 0 on success or error status
> > + *
> > + * The api process of reset under normal circumstances:
> > + *	1. virtio_reset_vq()              - notify the device to reset the =
queue
> > + *	2. virtqueue_detach_unused_buf()  - recycle the buffer submitted
> > + *	3. virtqueue_reset_vring()        - reset the vring (may re-alloc)
> > + *	4. virtio_enable_resetq()         - mmap vring to device, and enabl=
e the queue
> > + *
> > + * Caller should guarantee that the vring is not accessed by any funct=
ions
> > + * of virtqueue.
> > + */
> > +static inline
> > +int virtio_reset_vq(struct virtqueue *vq)
> > +{
>
>
> It looks to me the prefix "virtio" is used for the device specific
> operations.
>
> I wonder if it's better to rename this as virtqueue_reste() and move it
> to virtio_ring.c?

Call vq->vdev->config->reset_vq in virtio_ring.c?

If it fits, I think it's fine.

Thanks.

>
> Thanks
>
>
> > +	if (!vq->vdev->config->reset_vq)
> > +		return -ENOENT;
> > +
> > +	return vq->vdev->config->reset_vq(vq);
> > +}
> > +
> > +/**
> > + * virtio_enable_resetq - enable a reset queue
> > + * @vq: the virtqueue
> > + *
> > + * returns 0 on success or error status
> > + *
> > + */
> > +static inline
> > +int virtio_enable_resetq(struct virtqueue *vq)
> > +{
> > +	if (!vq->vdev->config->enable_reset_vq)
> > +		return -ENOENT;
> > +
> > +	return vq->vdev->config->enable_reset_vq(vq);
> > +}
> > +
> >   /**
> >    * virtio_device_ready - enable vq use in probe function
> >    * @vdev: the device
>
