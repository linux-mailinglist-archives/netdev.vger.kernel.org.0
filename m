Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D25718FB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390106AbfGWNQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbfGWNQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:16:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F07623082AF2;
        Tue, 23 Jul 2019 13:16:25 +0000 (UTC)
Received: from [10.72.12.26] (ovpn-12-26.pek2.redhat.com [10.72.12.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E01A35D9C5;
        Tue, 23 Jul 2019 13:16:16 +0000 (UTC)
Subject: Re: [PATCH 6/6] vhost: don't do synchronize_rcu() in
 vhost_uninit_vq_maps()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-7-jasowang@redhat.com>
 <20190723041144-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f2074bc7-6d67-14fa-4f58-91e9c5a9cc12@redhat.com>
Date:   Tue, 23 Jul 2019 21:16:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723041144-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 23 Jul 2019 13:16:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/23 下午5:16, Michael S. Tsirkin wrote:
> On Tue, Jul 23, 2019 at 03:57:18AM -0400, Jason Wang wrote:
>> There's no need for RCU synchronization in vhost_uninit_vq_maps()
>> since we've already serialized with readers (memory accessors). This
>> also avoid the possible userspace DOS through ioctl() because of the
>> possible high latency caused by synchronize_rcu().
>>
>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> I agree synchronize_rcu in both mmu notifiers and ioctl
> is a problem we must fix.
>
>> ---
>>   drivers/vhost/vhost.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 5b8821d00fe4..a17df1f4069a 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -334,7 +334,9 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>>   	}
>>   	spin_unlock(&vq->mmu_lock);
>>   
>> -	synchronize_rcu();
>> +	/* No need for synchronize_rcu() or kfree_rcu() since we are
>> +	 * serialized with memory accessors (e.g vq mutex held).
>> +	 */
>>   
>>   	for (i = 0; i < VHOST_NUM_ADDRS; i++)
>>   		if (map[i])
>> -- 
>> 2.18.1
> .. however we can not RCU with no synchronization in sight.
> Sometimes there are hacks like using a lock/unlock
> pair instead of sync, but here no one bothers.
>
> specifically notifiers call reset vq maps which calls
> uninit vq maps which is not under any lock.


Notifier did this:

         if (map) {
                 if (uaddr->write) {
                         for (i = 0; i < map->npages; i++)
set_page_dirty(map->pages[i]);
}
                 rcu_assign_pointer(vq->maps[index], NULL);
}
spin_unlock(&vq->mmu_lock);

         if (map) {
synchronize_rcu();
vhost_map_unprefetch(map);
         }

So it indeed have a synchronize_rcu() there.

Thanks


>
> You will get use after free when map is then accessed.
>
> If you always have a lock then just take that lock
> and no need for RCU.
>
