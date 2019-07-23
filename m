Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476017190A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390144AbfGWNTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33513 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729452AbfGWNTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:19:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC6C981F19;
        Tue, 23 Jul 2019 13:19:33 +0000 (UTC)
Received: from [10.72.12.26] (ovpn-12-26.pek2.redhat.com [10.72.12.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F409660BEC;
        Tue, 23 Jul 2019 13:19:28 +0000 (UTC)
Subject: Re: [PATCH 5/6] vhost: mark dirty pages during map uninit
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-6-jasowang@redhat.com>
 <20190723041702-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a670cd0d-581d-1aba-41bd-c643c19f9604@redhat.com>
Date:   Tue, 23 Jul 2019 21:19:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723041702-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 23 Jul 2019 13:19:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/23 下午5:17, Michael S. Tsirkin wrote:
> On Tue, Jul 23, 2019 at 03:57:17AM -0400, Jason Wang wrote:
>> We don't mark dirty pages if the map was teared down outside MMU
>> notifier. This will lead untracked dirty pages. Fixing by marking
>> dirty pages during map uninit.
>>
>> Reported-by: Michael S. Tsirkin<mst@redhat.com>
>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
>>   drivers/vhost/vhost.c | 22 ++++++++++++++++------
>>   1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 89c9f08b5146..5b8821d00fe4 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -306,6 +306,18 @@ static void vhost_map_unprefetch(struct vhost_map *map)
>>   	kfree(map);
>>   }
>>   
>> +static void vhost_set_map_dirty(struct vhost_virtqueue *vq,
>> +				struct vhost_map *map, int index)
>> +{
>> +	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>> +	int i;
>> +
>> +	if (uaddr->write) {
>> +		for (i = 0; i < map->npages; i++)
>> +			set_page_dirty(map->pages[i]);
>> +	}
>> +}
>> +
>>   static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>>   {
>>   	struct vhost_map *map[VHOST_NUM_ADDRS];
>> @@ -315,8 +327,10 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>>   	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
>>   		map[i] = rcu_dereference_protected(vq->maps[i],
>>   				  lockdep_is_held(&vq->mmu_lock));
>> -		if (map[i])
>> +		if (map[i]) {
>> +			vhost_set_map_dirty(vq, map[i], i);
>>   			rcu_assign_pointer(vq->maps[i], NULL);
>> +		}
>>   	}
>>   	spin_unlock(&vq->mmu_lock);
>>   
>> @@ -354,7 +368,6 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>>   {
>>   	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>>   	struct vhost_map *map;
>> -	int i;
>>   
>>   	if (!vhost_map_range_overlap(uaddr, start, end))
>>   		return;
>> @@ -365,10 +378,7 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>>   	map = rcu_dereference_protected(vq->maps[index],
>>   					lockdep_is_held(&vq->mmu_lock));
>>   	if (map) {
>> -		if (uaddr->write) {
>> -			for (i = 0; i < map->npages; i++)
>> -				set_page_dirty(map->pages[i]);
>> -		}
>> +		vhost_set_map_dirty(vq, map, index);
>>   		rcu_assign_pointer(vq->maps[index], NULL);
>>   	}
>>   	spin_unlock(&vq->mmu_lock);
> OK and the reason it's safe is because the invalidate counter
> got incremented so we know page will not get mapped again.
>
> But we*do*  need to wait for page not to be mapped.
> And if that means waiting for VQ processing to finish,
> then I worry that is a very log time.
>

I'm not sure I get you here. If we don't have such map, we will fall 
back to normal uaccess helper. And in the memory accessor, the rcu 
critical section is pretty small.

Thanks



