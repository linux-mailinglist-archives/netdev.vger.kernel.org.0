Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF44BD6E6
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 06:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfIYEAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 00:00:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfIYEAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 00:00:04 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 02DB23DFD7;
        Wed, 25 Sep 2019 04:00:04 +0000 (UTC)
Received: from [10.72.12.148] (ovpn-12-148.pek2.redhat.com [10.72.12.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83E855C21F;
        Wed, 25 Sep 2019 03:59:58 +0000 (UTC)
Subject: Re: [PATCH] vhost: It's better to use size_t for the 3rd parameter of
 vhost_exceeds_weight()
To:     "wangxu (AE)" <wangxu72@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1569224801-101248-1-git-send-email-wangxu72@huawei.com>
 <20190923040518-mutt-send-email-mst@kernel.org>
 <FCFCADD62FC0CA4FAEA05F13220975B01717A091@dggeml525-mbx.china.huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fc06afd5-0e2d-c3ae-c118-3292e16db186@redhat.com>
Date:   Wed, 25 Sep 2019 11:59:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <FCFCADD62FC0CA4FAEA05F13220975B01717A091@dggeml525-mbx.china.huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 25 Sep 2019 04:00:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/23 下午5:12, wangxu (AE) wrote:
> Hi Michael
>
> 	Thanks for your fast reply.
>
> 	As the following code, the 2nd branch of iov_iter_advance() does not check if i->count < size, when this happens, i->count -= size may cause len exceed INT_MAX, and then total_len exceed INT_MAX.
>
> 	handle_tx_copy() ->
> 		get_tx_bufs(..., &len, ...) ->
> 			init_iov_iter() ->
> 				iov_iter_advance(iter, ...) 	// has 3 branches:
> 					pipe_advance() 	 	// has checked the size: if (unlikely(i->count < size)) size = i->count;
> 					iov_iter_is_discard() ... 	// no check.


Yes, but I don't think we use ITER_DISCARD.

Thanks


> 					iterate_and_advance() 	//has checked: if (unlikely(i->count < n)) n = i->count;
> 				return iov_iter_count(iter);
>
> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> Sent: Monday, September 23, 2019 4:07 PM
> To: wangxu (AE) <wangxu72@huawei.com>
> Cc: jasowang@redhat.com; kvm@vger.kernel.org; virtualization@lists.linux-foundation.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] vhost: It's better to use size_t for the 3rd parameter of vhost_exceeds_weight()
>
> On Mon, Sep 23, 2019 at 03:46:41PM +0800, wangxu wrote:
>> From: Wang Xu <wangxu72@huawei.com>
>>
>> Caller of vhost_exceeds_weight(..., total_len) in drivers/vhost/net.c
>> usually pass size_t total_len, which may be affected by rx/tx package.
>>
>> Signed-off-by: Wang Xu <wangxu72@huawei.com>
>
> Puts a bit more pressure on the register file ...
> why do we care? Is there some way that it can exceed INT_MAX?
>
>> ---
>>   drivers/vhost/vhost.c | 4 ++--
>>   drivers/vhost/vhost.h | 7 ++++---
>>   2 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c index
>> 36ca2cf..159223a 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -412,7 +412,7 @@ static void vhost_dev_free_iovecs(struct vhost_dev
>> *dev)  }
>>   
>>   bool vhost_exceeds_weight(struct vhost_virtqueue *vq,
>> -			  int pkts, int total_len)
>> +			  int pkts, size_t total_len)
>>   {
>>   	struct vhost_dev *dev = vq->dev;
>>   
>> @@ -454,7 +454,7 @@ static size_t vhost_get_desc_size(struct
>> vhost_virtqueue *vq,
>>   
>>   void vhost_dev_init(struct vhost_dev *dev,
>>   		    struct vhost_virtqueue **vqs, int nvqs,
>> -		    int iov_limit, int weight, int byte_weight)
>> +		    int iov_limit, int weight, size_t byte_weight)
>>   {
>>   	struct vhost_virtqueue *vq;
>>   	int i;
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h index
>> e9ed272..8d80389d 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -172,12 +172,13 @@ struct vhost_dev {
>>   	wait_queue_head_t wait;
>>   	int iov_limit;
>>   	int weight;
>> -	int byte_weight;
>> +	size_t byte_weight;
>>   };
>>   
>
> This just costs extra memory, and value is never large, so I don't think this matters.
>
>> -bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int
>> total_len);
>> +bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts,
>> +			  size_t total_len);
>>   void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
>> -		    int nvqs, int iov_limit, int weight, int byte_weight);
>> +		    int nvqs, int iov_limit, int weight, size_t byte_weight);
>>   long vhost_dev_set_owner(struct vhost_dev *dev);  bool
>> vhost_dev_has_owner(struct vhost_dev *dev);  long
>> vhost_dev_check_owner(struct vhost_dev *);
>> --
>> 1.8.5.6
