Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6B4D2CAB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbiCIKA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiCIKAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:00:55 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7FF16F970;
        Wed,  9 Mar 2022 01:59:55 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6jAtL._1646819988;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6jAtL._1646819988)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:59:49 +0800
Message-ID: <1646819926.6046128-13-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 21/26] virtio: add helper virtio_find_vqs_ctx_size()
Date:   Wed, 9 Mar 2022 17:58:46 +0800
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
 <20220308123518.33800-22-xuanzhuo@linux.alibaba.com>
 <f1fb522d-74ce-a642-7768-deaad76aeddc@redhat.com>
In-Reply-To: <f1fb522d-74ce-a642-7768-deaad76aeddc@redhat.com>
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

On Wed, 9 Mar 2022 17:04:12 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:35, Xuan Zhuo =E5=86=99=E9=81=93:
> > Introduce helper virtio_find_vqs_ctx_size() to call find_vqs and specify
> > the maximum size of each vq ring.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   include/linux/virtio_config.h | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_confi=
g.h
> > index 5157524d8036..921d8610db0c 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -233,6 +233,18 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev=
, unsigned nvqs,
> >   				      desc, NULL);
> >   }
> >
> > +static inline
> > +int virtio_find_vqs_ctx_size(struct virtio_device *vdev, u32 nvqs,
> > +				 struct virtqueue *vqs[],
> > +				 vq_callback_t *callbacks[],
> > +				 const char * const names[],
> > +				 const bool *ctx, struct irq_affinity *desc,
> > +				 u32 sizes[])
> > +{
> > +	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> > +				      desc, sizes);
> > +}
>
>
> Do we need to convert all the open coded direct call to find_vqs() other
> than net?


Do you mean calling find_vqs without a helper? The kernel doesn't do that
anymore.

Thanks.


>
> Thanks
>
>
> > +
> >   /**
> >    * virtio_reset_vq - reset a queue individually
> >    * @vq: the virtqueue
>
