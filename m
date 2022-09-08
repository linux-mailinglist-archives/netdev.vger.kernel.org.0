Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EAE5B1761
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiIHInv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Sep 2022 04:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiIHInt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:43:49 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594BCA1D5E;
        Thu,  8 Sep 2022 01:43:47 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 2116E1007FEC5;
        Thu,  8 Sep 2022 16:43:43 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id B80A537C842;
        Thu,  8 Sep 2022 16:43:43 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OyaMGIvmIgAn; Thu,  8 Sep 2022 16:43:43 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 8AF6E37C840;
        Thu,  8 Sep 2022 16:43:43 +0800 (CST)
Date:   Thu, 8 Sep 2022 16:43:43 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1852578160.165892.1662626623503.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <dcf40392-26a7-b4f1-ad2c-44fac99fb330@redhat.com>
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn> <20220901055434.824-2-qtxuning1999@sjtu.edu.cn> <dcf40392-26a7-b4f1-ad2c-44fac99fb330@redhat.com>
Subject: Re: [RFC v3 1/7] vhost: expose used buffers
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.162.206.161]
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - GC104 (Mac)/8.8.15_GA_3928)
Thread-Topic: vhost: expose used buffers
Thread-Index: fByL794dn6QpX8lgbNrQBzAr5HjJEQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "jasowang" <jasowang@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "eperezma" <eperezma@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael
> Tsirkin" <mst@redhat.com>
> Cc: "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Wednesday, September 7, 2022 12:21:06 PM
> Subject: Re: [RFC v3 1/7] vhost: expose used buffers

> ÔÚ 2022/9/1 13:54, Guo Zhi Ð´µÀ:
>> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
>> of descriptors.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/vhost/vhost.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 40097826cff0..26862c8bf751 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -2376,10 +2376,20 @@ static int __vhost_add_used_n(struct vhost_virtqueue
>> *vq,
>>   	vring_used_elem_t __user *used;
>>   	u16 old, new;
>>   	int start;
>> +	int copy_n = count;
>>   
>> +	/**
>> +	 * If in order feature negotiated, devices can notify the use of a batch of
>> buffers to
>> +	 * the driver by only writing out a single used ring entry with the id
>> corresponding
>> +	 * to the head entry of the descriptor chain describing the last buffer in the
>> batch.
>> +	 */
>> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>> +		copy_n = 1;
>> +		heads = &heads[count - 1];
>> +	}
> 
> 
> Would it better to have a dedicated helper like
> vhost_add_used_in_order() here?
> 
That would be much more convenient and clear to implement. 
I think have a dedicated function for in order feature in vhost is better.

> 
> 
>>   	start = vq->last_used_idx & (vq->num - 1);
>>   	used = vq->used->ring + start;
>> -	if (vhost_put_used(vq, heads, start, count)) {
>> +	if (vhost_put_used(vq, heads, start, copy_n)) {
>>   		vq_err(vq, "Failed to write used");
>>   		return -EFAULT;
>>   	}
>> @@ -2388,7 +2398,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>>   		smp_wmb();
>>   		/* Log used ring entry write. */
>>   		log_used(vq, ((void __user *)used - (void __user *)vq->used),
>> -			 count * sizeof *used);
>> +			 copy_n * sizeof(*used));
>>   	}
>>   	old = vq->last_used_idx;
>>   	new = (vq->last_used_idx += count);
>> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct
>> vring_used_elem *heads,
>>   
>>   	start = vq->last_used_idx & (vq->num - 1);
>>   	n = vq->num - start;
>> -	if (n < count) {
>> +	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> 
> 
> This seems strange, any reason for this? (Actually if we support
> in-order we only need one used slot which fit for the case here)
> 
> Thanks
> 
If in order feature negotiated, even the count is larger than n,
we don't need to call __vhost_add_used_n again, because in order 
only use one slot.

Thanks
> 
>>   		r = __vhost_add_used_n(vq, heads, n);
>>   		if (r < 0)
>>   			return r;
