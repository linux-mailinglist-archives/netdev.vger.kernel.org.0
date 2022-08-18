Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A092C597BFD
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242794AbiHRDJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239681AbiHRDJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:09:55 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A958179601;
        Wed, 17 Aug 2022 20:09:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VMYsNDR_1660792190;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VMYsNDR_1660792190)
          by smtp.aliyun-inc.com;
          Thu, 18 Aug 2022 11:09:51 +0800
Message-ID: <1660791937.681257-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC v2 5/7] virtio: unmask F_NEXT flag in desc_extra
Date:   Thu, 18 Aug 2022 11:05:37 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        jasowang@redhat.com, sgarzare@redhat.com, mst@redhat.com
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
 <20220817135718.2553-6-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220817135718.2553-6-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 21:57:16 +0800, Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
> We didn't unmask F_NEXT flag in desc_extra in the end of a chain,
> unmask it so that we can access desc_extra to get next information.

I think we should state the purpose of this.

>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/virtio/virtio_ring.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index a5ec724c01d8..1c1b3fa376a2 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -567,7 +567,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	}
>  	/* Last one doesn't continue. */
>  	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
> -	if (!indirect && vq->use_dma_api)
> +	if (!indirect)
>  		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
>  			~VRING_DESC_F_NEXT;
>
> @@ -584,6 +584,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  					 total_sg * sizeof(struct vring_desc),
>  					 VRING_DESC_F_INDIRECT,
>  					 false);
> +		vq->split.desc_extra[head & (vq->split.vring.num - 1)].flags &=
> +			~VRING_DESC_F_NEXT;

This seems unnecessary.

>  	}
>
>  	/* We're using some buffers from the free list. */
> @@ -693,7 +695,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  	/* Put back on free list: unmap first-level descriptors and find end */
>  	i = head;
>
> -	while (vq->split.vring.desc[i].flags & nextflag) {
> +	while (vq->split.desc_extra[i].flags & nextflag) {

nextflag is __virtio16

You can use VRING_DESC_F_NEXT directly.

Thanks.

>  		vring_unmap_one_split(vq, i);
>  		i = vq->split.desc_extra[i].next;
>  		vq->vq.num_free++;
> --
> 2.17.1
>
