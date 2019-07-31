Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6094F7C37F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388311AbfGaN3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388237AbfGaN3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 09:29:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F304781F13;
        Wed, 31 Jul 2019 13:29:36 +0000 (UTC)
Received: from [10.72.12.118] (ovpn-12-118.pek2.redhat.com [10.72.12.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B5E35C1B5;
        Wed, 31 Jul 2019 13:29:29 +0000 (UTC)
Subject: Re: [PATCH V2 4/9] vhost: reset invalidate_count in
 vhost_set_vring_num_addr()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-5-jasowang@redhat.com> <20190731124124.GD3946@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <31ef9ed4-d74a-3454-a57d-fa843a3a802b@redhat.com>
Date:   Wed, 31 Jul 2019 21:29:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190731124124.GD3946@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 31 Jul 2019 13:29:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/31 下午8:41, Jason Gunthorpe wrote:
> On Wed, Jul 31, 2019 at 04:46:50AM -0400, Jason Wang wrote:
>> The vhost_set_vring_num_addr() could be called in the middle of
>> invalidate_range_start() and invalidate_range_end(). If we don't reset
>> invalidate_count after the un-registering of MMU notifier, the
>> invalidate_cont will run out of sync (e.g never reach zero). This will
>> in fact disable the fast accessor path. Fixing by reset the count to
>> zero.
>>
>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Did Michael report this as well?


Correct me if I was wrong. I think it's point 4 described in 
https://lkml.org/lkml/2019/7/21/25.

Thanks


>
>> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>   drivers/vhost/vhost.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 2a3154976277..2a7217c33668 100644
>> +++ b/drivers/vhost/vhost.c
>> @@ -2073,6 +2073,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>>   		d->has_notifier = false;
>>   	}
>>   
>> +	/* reset invalidate_count in case we are in the middle of
>> +	 * invalidate_start() and invalidate_end().
>> +	 */
>> +	vq->invalidate_count = 0;
>>   	vhost_uninit_vq_maps(vq);
>>   #endif
>>   
