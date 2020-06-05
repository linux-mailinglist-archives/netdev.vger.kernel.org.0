Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166281EF00B
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 05:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgFEDk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 23:40:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36649 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726088AbgFEDk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 23:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591328426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+XRm7Fs7zNlH2EKv4SYh8NMSzGAObCRW7/zCrf8kTM=;
        b=bMinaiappCB0rQc0Seywa3/cVkuzqVzgZOHZhSWQYCSkZ81iRslS8kNSRBSGKgQPcCx3Eu
        gHHK9CiCuq2raB5URMZCpac6lqycim7AIT742YFDBVZhE+poHPc5vekg0QfB/DIc6sNCgl
        vs8r/qfW+iKVf6IEabXSwJEbgFg5uds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-WjnfLQgyPAadytx9KbfT2Q-1; Thu, 04 Jun 2020 23:40:24 -0400
X-MC-Unique: WjnfLQgyPAadytx9KbfT2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD756100960F;
        Fri,  5 Jun 2020 03:40:23 +0000 (UTC)
Received: from [10.72.12.233] (ovpn-12-233.pek2.redhat.com [10.72.12.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3AE45C290;
        Fri,  5 Jun 2020 03:40:18 +0000 (UTC)
Subject: Re: [PATCH RFC 03/13] vhost: batching fetches
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-4-mst@redhat.com>
 <3323daa2-19ed-02de-0ff7-ab150f949fff@redhat.com>
 <20200604045830-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6c2e6cc7-27c5-445b-f252-0356ff8a83f3@redhat.com>
Date:   Fri, 5 Jun 2020 11:40:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200604045830-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/4 下午4:59, Michael S. Tsirkin wrote:
> On Wed, Jun 03, 2020 at 03:27:39PM +0800, Jason Wang wrote:
>> On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
>>> With this patch applied, new and old code perform identically.
>>>
>>> Lots of extra optimizations are now possible, e.g.
>>> we can fetch multiple heads with copy_from/to_user now.
>>> We can get rid of maintaining the log array.  Etc etc.
>>>
>>> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
>>> Signed-off-by: Eugenio Pérez<eperezma@redhat.com>
>>> Link:https://lore.kernel.org/r/20200401183118.8334-4-eperezma@redhat.com
>>> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
>>> ---
>>>    drivers/vhost/test.c  |  2 +-
>>>    drivers/vhost/vhost.c | 47 ++++++++++++++++++++++++++++++++++++++-----
>>>    drivers/vhost/vhost.h |  5 ++++-
>>>    3 files changed, 47 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
>>> index 9a3a09005e03..02806d6f84ef 100644
>>> --- a/drivers/vhost/test.c
>>> +++ b/drivers/vhost/test.c
>>> @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
>>>    	dev = &n->dev;
>>>    	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>>>    	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
>>> -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
>>> +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
>>>    		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
>>>    	f->private_data = n;
>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>> index 8f9a07282625..aca2a5b0d078 100644
>>> --- a/drivers/vhost/vhost.c
>>> +++ b/drivers/vhost/vhost.c
>>> @@ -299,6 +299,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>>    {
>>>    	vq->num = 1;
>>>    	vq->ndescs = 0;
>>> +	vq->first_desc = 0;
>>>    	vq->desc = NULL;
>>>    	vq->avail = NULL;
>>>    	vq->used = NULL;
>>> @@ -367,6 +368,11 @@ static int vhost_worker(void *data)
>>>    	return 0;
>>>    }
>>> +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
>>> +{
>>> +	return vq->max_descs - UIO_MAXIOV;
>>> +}
>> 1 descriptor does not mean 1 iov, e.g userspace may pass several 1 byte
>> length memory regions for us to translate.
>>
> Yes but I don't see the relevance. This tells us how many descriptors to
> batch, not how many IOVs.


Yes, but questions are:

- this introduce another obstacle to support more than 1K queue size
- if we support 1K queue size, does it mean we need to cache 1K 
descriptors, which seems a large stress on the cache

Thanks


>

