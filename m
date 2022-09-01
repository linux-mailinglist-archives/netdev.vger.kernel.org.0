Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B11D5A8DF8
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiIAGIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiIAGIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:08:16 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F917111AFE;
        Wed, 31 Aug 2022 23:08:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VNxI5.W_1662012491;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VNxI5.W_1662012491)
          by smtp.aliyun-inc.com;
          Thu, 01 Sep 2022 14:08:12 +0800
Message-ID: <1662012423.9200838-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC v3 5/7] virtio: unmask F_NEXT flag in desc_extra
Date:   Thu, 1 Sep 2022 14:07:03 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        jasowang@redhat.com, sgarzare@redhat.com, mst@redhat.com
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
 <20220901055434.824-6-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220901055434.824-6-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Sep 2022 13:54:32 +0800, Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
> We didn't unmask F_NEXT flag in desc_extra in the end of a chain,
> unmask it so that we can access desc_extra to get next information.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/virtio/virtio_ring.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index a5ec724c01d8..00aa4b7a49c2 100644
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

Wondering if this is necessary? When setting flags, NEXT is not included.

>  	}
>
>  	/* We're using some buffers from the free list. */
> @@ -685,7 +687,6 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  			     void **ctx)
>  {
>  	unsigned int i, j;
> -	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
>
>  	/* Clear data ptr. */
>  	vq->split.desc_state[head].data = NULL;
> @@ -693,7 +694,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  	/* Put back on free list: unmap first-level descriptors and find end */
>  	i = head;
>
> -	while (vq->split.vring.desc[i].flags & nextflag) {
> +	while (vq->split.desc_extra[i].flags & VRING_DESC_F_NEXT) {
>  		vring_unmap_one_split(vq, i);
>  		i = vq->split.desc_extra[i].next;
>  		vq->vq.num_free++;
> --
> 2.17.1
>
