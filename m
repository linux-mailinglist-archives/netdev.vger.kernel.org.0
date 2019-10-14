Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC7D5956
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 03:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbfJNBnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 21:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729444AbfJNBnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 21:43:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E17F7883837;
        Mon, 14 Oct 2019 01:43:31 +0000 (UTC)
Received: from [10.72.12.117] (ovpn-12-117.pek2.redhat.com [10.72.12.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44BCC5D6A3;
        Mon, 14 Oct 2019 01:43:26 +0000 (UTC)
Subject: Re: [PATCH RFC v1 1/2] vhost: option to fetch descriptors through an
 independent struct
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20191011134358.16912-1-mst@redhat.com>
 <20191011134358.16912-2-mst@redhat.com>
 <3b2a6309-9d21-7172-a581-9f0f1d5c1427@redhat.com>
 <20191012162445-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fea337ec-7c09-508b-3efa-b75afd6fe33b@redhat.com>
Date:   Mon, 14 Oct 2019 09:43:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012162445-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Mon, 14 Oct 2019 01:43:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/13 上午4:27, Michael S. Tsirkin wrote:
> On Sat, Oct 12, 2019 at 03:28:49PM +0800, Jason Wang wrote:
>> On 2019/10/11 下午9:45, Michael S. Tsirkin wrote:
>>> The idea is to support multiple ring formats by converting
>>> to a format-independent array of descriptors.
>>>
>>> This costs extra cycles, but we gain in ability
>>> to fetch a batch of descriptors in one go, which
>>> is good for code cache locality.
>>>
>>> To simplify benchmarking, I kept the old code
>>> around so one can switch back and forth by
>>> writing into a module parameter.
>>> This will go away in the final submission.
>>>
>>> This patch causes a minor performance degradation,
>>> it's been kept as simple as possible for ease of review.
>>> Next patch gets us back the performance by adding batching.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>    drivers/vhost/test.c  |  17 ++-
>>>    drivers/vhost/vhost.c | 299 +++++++++++++++++++++++++++++++++++++++++-
>>>    drivers/vhost/vhost.h |  16 +++
>>>    3 files changed, 327 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
>>> index 056308008288..39a018a7af2d 100644
>>> --- a/drivers/vhost/test.c
>>> +++ b/drivers/vhost/test.c
>>> @@ -18,6 +18,9 @@
>>>    #include "test.h"
>>>    #include "vhost.h"
>>> +static int newcode = 0;
>>> +module_param(newcode, int, 0644);
>>> +
>>>    /* Max number of bytes transferred before requeueing the job.
>>>     * Using this limit prevents one virtqueue from starving others. */
>>>    #define VHOST_TEST_WEIGHT 0x80000
>>> @@ -58,10 +61,16 @@ static void handle_vq(struct vhost_test *n)
>>>    	vhost_disable_notify(&n->dev, vq);
>>>    	for (;;) {
>>> -		head = vhost_get_vq_desc(vq, vq->iov,
>>> -					 ARRAY_SIZE(vq->iov),
>>> -					 &out, &in,
>>> -					 NULL, NULL);
>>> +		if (newcode)
>>> +			head = vhost_get_vq_desc_batch(vq, vq->iov,
>>> +						       ARRAY_SIZE(vq->iov),
>>> +						       &out, &in,
>>> +						       NULL, NULL);
>>> +		else
>>> +			head = vhost_get_vq_desc(vq, vq->iov,
>>> +						 ARRAY_SIZE(vq->iov),
>>> +						 &out, &in,
>>> +						 NULL, NULL);
>>>    		/* On error, stop handling until the next kick. */
>>>    		if (unlikely(head < 0))
>>>    			break;
>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>> index 36ca2cf419bf..36661d6cb51f 100644
>>> --- a/drivers/vhost/vhost.c
>>> +++ b/drivers/vhost/vhost.c
>>> @@ -301,6 +301,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>>    			   struct vhost_virtqueue *vq)
>>>    {
>>>    	vq->num = 1;
>>> +	vq->ndescs = 0;
>>>    	vq->desc = NULL;
>>>    	vq->avail = NULL;
>>>    	vq->used = NULL;
>>> @@ -369,6 +370,9 @@ static int vhost_worker(void *data)
>>>    static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>>>    {
>>> +	kfree(vq->descs);
>>> +	vq->descs = NULL;
>>> +	vq->max_descs = 0;
>>>    	kfree(vq->indirect);
>>>    	vq->indirect = NULL;
>>>    	kfree(vq->log);
>>> @@ -385,6 +389,10 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>>>    	for (i = 0; i < dev->nvqs; ++i) {
>>>    		vq = dev->vqs[i];
>>> +		vq->max_descs = dev->iov_limit;
>>> +		vq->descs = kmalloc_array(vq->max_descs,
>>> +					  sizeof(*vq->descs),
>>> +					  GFP_KERNEL);
>>
>> Is iov_limit too much here? It can obviously increase the footprint. I guess
>> the batching can only be done for descriptor without indirect or next set.
>> Then we may batch 16 or 64.
>>
>> Thanks
> Yes, next patch only batches up to 64.  But we do need iov_limit because
> guest can pass a long chain of scatter/gather.
> We already have iovecs in a huge array so this does not look like
> a big deal. If we ever teach the code to avoid the huge
> iov arrays by handling huge s/g lists piece by piece,
> we can make the desc array smaller at the same point.
>

Another possible issue, if we try to batch descriptor chain when we've 
already batched some descriptors, we may reach the limit then some of 
the descriptors might need re-read.

Or we may need circular index (head, tail) in this case?

Thanks


