Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FC07BDFC
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 12:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfGaKGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 06:06:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfGaKGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 06:06:05 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9BF5285AE;
        Wed, 31 Jul 2019 10:06:04 +0000 (UTC)
Received: from [10.72.12.118] (ovpn-12-118.pek2.redhat.com [10.72.12.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 906F15C219;
        Wed, 31 Jul 2019 10:05:59 +0000 (UTC)
Subject: Re: [PATCH V2 9/9] vhost: do not return -EAGIAN for non blocking
 invalidation too early
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-10-jasowang@redhat.com>
 <20190731095950.d6zr472megt7rgkt@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e00259ec-af5d-3c58-a936-2e1c6e1bc2b9@redhat.com>
Date:   Wed, 31 Jul 2019 18:05:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190731095950.d6zr472megt7rgkt@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 31 Jul 2019 10:06:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/31 下午5:59, Stefano Garzarella wrote:
> A little typo in the title: s/EAGIAN/EAGAIN
>
> Thanks,
> Stefano


Right, will fix if need respin or Michael can help to fix.

Thanks


>
> On Wed, Jul 31, 2019 at 04:46:55AM -0400, Jason Wang wrote:
>> Instead of returning -EAGAIN unconditionally, we'd better do that only
>> we're sure the range is overlapped with the metadata area.
>>
>> Reported-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/vhost.c | 32 +++++++++++++++++++-------------
>>   1 file changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index fc2da8a0c671..96c6aeb1871f 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -399,16 +399,19 @@ static void inline vhost_vq_sync_access(struct vhost_virtqueue *vq)
>>   	smp_mb();
>>   }
>>   
>> -static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>> -				      int index,
>> -				      unsigned long start,
>> -				      unsigned long end)
>> +static int vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>> +				     int index,
>> +				     unsigned long start,
>> +				     unsigned long end,
>> +				     bool blockable)
>>   {
>>   	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>>   	struct vhost_map *map;
>>   
>>   	if (!vhost_map_range_overlap(uaddr, start, end))
>> -		return;
>> +		return 0;
>> +	else if (!blockable)
>> +		return -EAGAIN;
>>   
>>   	spin_lock(&vq->mmu_lock);
>>   	++vq->invalidate_count;
>> @@ -423,6 +426,8 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>>   		vhost_set_map_dirty(vq, map, index);
>>   		vhost_map_unprefetch(map);
>>   	}
>> +
>> +	return 0;
>>   }
>>   
>>   static void vhost_invalidate_vq_end(struct vhost_virtqueue *vq,
>> @@ -443,18 +448,19 @@ static int vhost_invalidate_range_start(struct mmu_notifier *mn,
>>   {
>>   	struct vhost_dev *dev = container_of(mn, struct vhost_dev,
>>   					     mmu_notifier);
>> -	int i, j;
>> -
>> -	if (!mmu_notifier_range_blockable(range))
>> -		return -EAGAIN;
>> +	bool blockable = mmu_notifier_range_blockable(range);
>> +	int i, j, ret;
>>   
>>   	for (i = 0; i < dev->nvqs; i++) {
>>   		struct vhost_virtqueue *vq = dev->vqs[i];
>>   
>> -		for (j = 0; j < VHOST_NUM_ADDRS; j++)
>> -			vhost_invalidate_vq_start(vq, j,
>> -						  range->start,
>> -						  range->end);
>> +		for (j = 0; j < VHOST_NUM_ADDRS; j++) {
>> +			ret = vhost_invalidate_vq_start(vq, j,
>> +							range->start,
>> +							range->end, blockable);
>> +			if (ret)
>> +				return ret;
>> +		}
>>   	}
>>   
>>   	return 0;
>> -- 
>> 2.18.1
>>
