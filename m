Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3C1D4DF0
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 09:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfJLH24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 03:28:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfJLH24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 03:28:56 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC66F307D853;
        Sat, 12 Oct 2019 07:28:55 +0000 (UTC)
Received: from [10.72.12.150] (ovpn-12-150.pek2.redhat.com [10.72.12.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B516E10013D9;
        Sat, 12 Oct 2019 07:28:51 +0000 (UTC)
Subject: Re: [PATCH RFC v1 1/2] vhost: option to fetch descriptors through an
 independent struct
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20191011134358.16912-1-mst@redhat.com>
 <20191011134358.16912-2-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3b2a6309-9d21-7172-a581-9f0f1d5c1427@redhat.com>
Date:   Sat, 12 Oct 2019 15:28:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191011134358.16912-2-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Sat, 12 Oct 2019 07:28:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/11 下午9:45, Michael S. Tsirkin wrote:
> The idea is to support multiple ring formats by converting
> to a format-independent array of descriptors.
>
> This costs extra cycles, but we gain in ability
> to fetch a batch of descriptors in one go, which
> is good for code cache locality.
>
> To simplify benchmarking, I kept the old code
> around so one can switch back and forth by
> writing into a module parameter.
> This will go away in the final submission.
>
> This patch causes a minor performance degradation,
> it's been kept as simple as possible for ease of review.
> Next patch gets us back the performance by adding batching.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/test.c  |  17 ++-
>   drivers/vhost/vhost.c | 299 +++++++++++++++++++++++++++++++++++++++++-
>   drivers/vhost/vhost.h |  16 +++
>   3 files changed, 327 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 056308008288..39a018a7af2d 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -18,6 +18,9 @@
>   #include "test.h"
>   #include "vhost.h"
>   
> +static int newcode = 0;
> +module_param(newcode, int, 0644);
> +
>   /* Max number of bytes transferred before requeueing the job.
>    * Using this limit prevents one virtqueue from starving others. */
>   #define VHOST_TEST_WEIGHT 0x80000
> @@ -58,10 +61,16 @@ static void handle_vq(struct vhost_test *n)
>   	vhost_disable_notify(&n->dev, vq);
>   
>   	for (;;) {
> -		head = vhost_get_vq_desc(vq, vq->iov,
> -					 ARRAY_SIZE(vq->iov),
> -					 &out, &in,
> -					 NULL, NULL);
> +		if (newcode)
> +			head = vhost_get_vq_desc_batch(vq, vq->iov,
> +						       ARRAY_SIZE(vq->iov),
> +						       &out, &in,
> +						       NULL, NULL);
> +		else
> +			head = vhost_get_vq_desc(vq, vq->iov,
> +						 ARRAY_SIZE(vq->iov),
> +						 &out, &in,
> +						 NULL, NULL);
>   		/* On error, stop handling until the next kick. */
>   		if (unlikely(head < 0))
>   			break;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 36ca2cf419bf..36661d6cb51f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -301,6 +301,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>   			   struct vhost_virtqueue *vq)
>   {
>   	vq->num = 1;
> +	vq->ndescs = 0;
>   	vq->desc = NULL;
>   	vq->avail = NULL;
>   	vq->used = NULL;
> @@ -369,6 +370,9 @@ static int vhost_worker(void *data)
>   
>   static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>   {
> +	kfree(vq->descs);
> +	vq->descs = NULL;
> +	vq->max_descs = 0;
>   	kfree(vq->indirect);
>   	vq->indirect = NULL;
>   	kfree(vq->log);
> @@ -385,6 +389,10 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>   
>   	for (i = 0; i < dev->nvqs; ++i) {
>   		vq = dev->vqs[i];
> +		vq->max_descs = dev->iov_limit;
> +		vq->descs = kmalloc_array(vq->max_descs,
> +					  sizeof(*vq->descs),
> +					  GFP_KERNEL);


Is iov_limit too much here? It can obviously increase the footprint. I 
guess the batching can only be done for descriptor without indirect or 
next set. Then we may batch 16 or 64.

Thanks
