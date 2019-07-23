Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E2A7191F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390106AbfGWNZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfGWNZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:25:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0EC44C057F2E;
        Tue, 23 Jul 2019 13:25:24 +0000 (UTC)
Received: from [10.72.12.26] (ovpn-12-26.pek2.redhat.com [10.72.12.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C709C5B685;
        Tue, 23 Jul 2019 13:25:18 +0000 (UTC)
Subject: Re: [PATCH 4/6] vhost: reset invalidate_count in
 vhost_set_vring_num_addr()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-5-jasowang@redhat.com>
 <20190723042143-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4e52f1cb-f805-18f6-d50b-1379298de2e3@redhat.com>
Date:   Tue, 23 Jul 2019 21:25:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723042143-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 23 Jul 2019 13:25:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/23 下午5:17, Michael S. Tsirkin wrote:
> On Tue, Jul 23, 2019 at 03:57:16AM -0400, Jason Wang wrote:
>> The vhost_set_vring_num_addr() could be called in the middle of
>> invalidate_range_start() and invalidate_range_end(). If we don't reset
>> invalidate_count after the un-registering of MMU notifier, the
>> invalidate_cont will run out of sync (e.g never reach zero). This will
>> in fact disable the fast accessor path. Fixing by reset the count to
>> zero.
>>
>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/vhost.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 03666b702498..89c9f08b5146 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -2074,6 +2074,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>>   		d->has_notifier = false;
>>   	}
>>   
>> +	/* reset invalidate_count in case we are in the middle of
>> +	 * invalidate_start() and invalidate_end().
>> +	 */
>> +	vq->invalidate_count = 0;
> I think that the code is ok but the comments are not very clear:
> - we are never in the middle since we just removed the notifier


If I read the code correctly, mmu_notifier_unregister() can only 
guarantee to wait for the pending method to complete. So we can have:

invalidate_start()

mmu_notifier_unregister()

invalidate_end()


> - the result is not just disabling optimization:
>    if notifier becomes negative, then later we
>    can think it's ok to map when it isn't since
>    notifier is active.


I don't get how it could be negative, the only possible thing is to have 
a positive value.

Thanks


>
>>   	vhost_uninit_vq_maps(vq);
>>   #endif
>>   
>> -- 
>> 2.18.1
