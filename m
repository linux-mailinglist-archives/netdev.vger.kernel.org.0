Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589921F11C8
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 05:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgFHDgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 23:36:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48360 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728996AbgFHDgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 23:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591587358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+iuslj2NkA9AsSp4gCUbTEgravqmEYd45b4226klfw=;
        b=HPRkfPhcKtiJVAl8ElhseDgXeQ0hEPMR8sl2u4qpHrf+xv6evNOVkSNp2gzG8v3T/u8y1W
        kZj78a/aRAFBbSHKO2U/txrY8ORX1KXZtDQLFR4hh0h9GZOYmJyL+nuTgxOStKFS86rj+r
        EVhDFoZY/RO5ht4RIJ2fbgvidtEh7b8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-e59_DPlKOFSrX1a8uR0vBA-1; Sun, 07 Jun 2020 23:35:54 -0400
X-MC-Unique: e59_DPlKOFSrX1a8uR0vBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 826D31005512;
        Mon,  8 Jun 2020 03:35:53 +0000 (UTC)
Received: from [10.72.13.71] (ovpn-13-71.pek2.redhat.com [10.72.13.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E73F768AE;
        Mon,  8 Jun 2020 03:35:42 +0000 (UTC)
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
 <6c2e6cc7-27c5-445b-f252-0356ff8a83f3@redhat.com>
 <20200607095219-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0d791fe6-8fbe-ddcc-07fa-efbd4fac5ea4@redhat.com>
Date:   Mon, 8 Jun 2020 11:35:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200607095219-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/7 下午9:57, Michael S. Tsirkin wrote:
> On Fri, Jun 05, 2020 at 11:40:17AM +0800, Jason Wang wrote:
>> On 2020/6/4 下午4:59, Michael S. Tsirkin wrote:
>>> On Wed, Jun 03, 2020 at 03:27:39PM +0800, Jason Wang wrote:
>>>> On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
>>>>> With this patch applied, new and old code perform identically.
>>>>>
>>>>> Lots of extra optimizations are now possible, e.g.
>>>>> we can fetch multiple heads with copy_from/to_user now.
>>>>> We can get rid of maintaining the log array.  Etc etc.
>>>>>
>>>>> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
>>>>> Signed-off-by: Eugenio Pérez<eperezma@redhat.com>
>>>>> Link:https://lore.kernel.org/r/20200401183118.8334-4-eperezma@redhat.com
>>>>> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
>>>>> ---
>>>>>     drivers/vhost/test.c  |  2 +-
>>>>>     drivers/vhost/vhost.c | 47 ++++++++++++++++++++++++++++++++++++++-----
>>>>>     drivers/vhost/vhost.h |  5 ++++-
>>>>>     3 files changed, 47 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
>>>>> index 9a3a09005e03..02806d6f84ef 100644
>>>>> --- a/drivers/vhost/test.c
>>>>> +++ b/drivers/vhost/test.c
>>>>> @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
>>>>>     	dev = &n->dev;
>>>>>     	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>>>>>     	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
>>>>> -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
>>>>> +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
>>>>>     		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
>>>>>     	f->private_data = n;
>>>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>>>> index 8f9a07282625..aca2a5b0d078 100644
>>>>> --- a/drivers/vhost/vhost.c
>>>>> +++ b/drivers/vhost/vhost.c
>>>>> @@ -299,6 +299,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>>>>     {
>>>>>     	vq->num = 1;
>>>>>     	vq->ndescs = 0;
>>>>> +	vq->first_desc = 0;
>>>>>     	vq->desc = NULL;
>>>>>     	vq->avail = NULL;
>>>>>     	vq->used = NULL;
>>>>> @@ -367,6 +368,11 @@ static int vhost_worker(void *data)
>>>>>     	return 0;
>>>>>     }
>>>>> +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
>>>>> +{
>>>>> +	return vq->max_descs - UIO_MAXIOV;
>>>>> +}
>>>> 1 descriptor does not mean 1 iov, e.g userspace may pass several 1 byte
>>>> length memory regions for us to translate.
>>>>
>>> Yes but I don't see the relevance. This tells us how many descriptors to
>>> batch, not how many IOVs.
>> Yes, but questions are:
>>
>> - this introduce another obstacle to support more than 1K queue size
>> - if we support 1K queue size, does it mean we need to cache 1K descriptors,
>> which seems a large stress on the cache
>>
>> Thanks
>>
>>
> Still don't understand the relevance. We support up to 1K descriptors
> per buffer just for IOV since we always did. This adds 64 more
> descriptors - is that a big deal?


If I understanding correctly, for net, the code tries to batch 
descriptors for at last one packet.

If we allow 1K queue size then we allow a packet that consists of 1K 
descriptors. Then we need to cache 1K descriptors.

Thanks

