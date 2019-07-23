Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F6971933
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390219AbfGWNaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfGWNaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:30:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBE8881F10;
        Tue, 23 Jul 2019 13:30:04 +0000 (UTC)
Received: from [10.72.12.26] (ovpn-12-26.pek2.redhat.com [10.72.12.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 521E019C58;
        Tue, 23 Jul 2019 13:29:59 +0000 (UTC)
Subject: Re: [PATCH 2/6] vhost: validate MMU notifier registration
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-3-jasowang@redhat.com>
 <20190723042428-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <682a0a87-4fb5-1b85-fe8d-736115f6ab2b@redhat.com>
Date:   Tue, 23 Jul 2019 21:30:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723042428-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 23 Jul 2019 13:30:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/23 下午5:17, Michael S. Tsirkin wrote:
> On Tue, Jul 23, 2019 at 03:57:14AM -0400, Jason Wang wrote:
>> The return value of mmu_notifier_register() is not checked in
>> vhost_vring_set_num_addr(). This will cause an out of sync between mm
>> and MMU notifier thus a double free. To solve this, introduce a
>> boolean flag to track whether MMU notifier is registered and only do
>> unregistering when it was true.
>>
>> Reported-and-tested-by:
>> syzbot+e58112d71f77113ddb7b@syzkaller.appspotmail.com
>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Right. This fixes the bug.
> But it's not great that simple things like
> setting vq address put pressure on memory allocator.
> Also, if we get a single during processing
> notifier register will fail, disabling optimization permanently.


Yes, but do we really care about this case. E.g we even fail for -ENOMEM 
for set owner.


>
> In fact, see below:
>
>
>> ---
>>   drivers/vhost/vhost.c | 19 +++++++++++++++----
>>   drivers/vhost/vhost.h |  1 +
>>   2 files changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 34c0d970bcbc..058191d5efad 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -630,6 +630,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>>   	dev->iov_limit = iov_limit;
>>   	dev->weight = weight;
>>   	dev->byte_weight = byte_weight;
>> +	dev->has_notifier = false;
>>   	init_llist_head(&dev->work_list);
>>   	init_waitqueue_head(&dev->wait);
>>   	INIT_LIST_HEAD(&dev->read_list);
>> @@ -731,6 +732,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>>   	if (err)
>>   		goto err_mmu_notifier;
>>   #endif
>> +	dev->has_notifier = true;
>>   
>>   	return 0;
>>   
> I just noticed that set owner now fails if we get a signal.
> Userspace could retry in theory but it does not:
> this is userspace abi breakage since it used to only
> fail on invalid input.


Well, at least kthread_create() and vhost_dev_alloc_iovecs() will 
allocate memory.

Thanks


>
>> @@ -960,7 +962,11 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>>   	}
>>   	if (dev->mm) {
>>   #if VHOST_ARCH_CAN_ACCEL_UACCESS
>> -		mmu_notifier_unregister(&dev->mmu_notifier, dev->mm);
>> +		if (dev->has_notifier) {
>> +			mmu_notifier_unregister(&dev->mmu_notifier,
>> +						dev->mm);
>> +			dev->has_notifier = false;
>> +		}
>>   #endif
>>   		mmput(dev->mm);
>>   	}
>> @@ -2065,8 +2071,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>>   	/* Unregister MMU notifer to allow invalidation callback
>>   	 * can access vq->uaddrs[] without holding a lock.
>>   	 */
>> -	if (d->mm)
>> +	if (d->has_notifier) {
>>   		mmu_notifier_unregister(&d->mmu_notifier, d->mm);
>> +		d->has_notifier = false;
>> +	}
>>   
>>   	vhost_uninit_vq_maps(vq);
>>   #endif
>> @@ -2086,8 +2094,11 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>>   	if (r == 0)
>>   		vhost_setup_vq_uaddr(vq);
>>   
>> -	if (d->mm)
>> -		mmu_notifier_register(&d->mmu_notifier, d->mm);
>> +	if (d->mm) {
>> +		r = mmu_notifier_register(&d->mmu_notifier, d->mm);
>> +		if (!r)
>> +			d->has_notifier = true;
>> +	}
>>   #endif
>>   
>>   	mutex_unlock(&vq->mutex);
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index 819296332913..a62f56a4cf72 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -214,6 +214,7 @@ struct vhost_dev {
>>   	int iov_limit;
>>   	int weight;
>>   	int byte_weight;
>> +	bool has_notifier;
>>   };
>>   
>>   bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
>> -- 
>> 2.18.1
