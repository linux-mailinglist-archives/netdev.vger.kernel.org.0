Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19A35A1F4D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244684AbiHZDKC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Aug 2022 23:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244434AbiHZDJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:09:57 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB5E1031;
        Thu, 25 Aug 2022 20:09:49 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id C08E21008B389;
        Fri, 26 Aug 2022 11:09:42 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id A7D3B37C894;
        Fri, 26 Aug 2022 11:09:42 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lA8wrcseUiVS; Fri, 26 Aug 2022 11:09:42 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 7978A37C893;
        Fri, 26 Aug 2022 11:09:42 +0800 (CST)
Date:   Fri, 26 Aug 2022 11:09:42 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1347002628.9092578.1661483382423.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <3a184162-afdc-9103-e786-66d796389e3a@redhat.com>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-2-qtxuning1999@sjtu.edu.cn> <3a184162-afdc-9103-e786-66d796389e3a@redhat.com>
Subject: Re: [RFC v2 1/7] vhost: expose used buffers
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.166.246.247]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC104 (Mac)/8.8.15_GA_3928)
Thread-Topic: vhost: expose used buffers
Thread-Index: ELzt12WtjSRXgoL62yzDeHlxV1NK/w==
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
> Sent: Thursday, August 25, 2022 3:01:31 PM
> Subject: Re: [RFC v2 1/7] vhost: expose used buffers

> ÔÚ 2022/8/17 21:57, Guo Zhi Ð´µÀ:
>> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
>> of descriptors.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/vhost/vhost.c | 14 ++++++++++++--
>>   drivers/vhost/vhost.h |  1 +
>>   2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 40097826cff0..7b20fa5a46c3 100644
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
> 
> 
> Do we need to check whether or not the buffer is fully used before doing
> this?
> 

This is the caller / user of __vhost_add_used_n's duty to make sure all buffer is fully used.
The device will only batch if all heads are fully used.

> 
>> +	}
>>   	start = vq->last_used_idx & (vq->num - 1);
>>   	used = vq->used->ring + start;
>> -	if (vhost_put_used(vq, heads, start, count)) {
>> +	if (vhost_put_used(vq, heads, start, copy_n)) {
>>   		vq_err(vq, "Failed to write used");
>>   		return -EFAULT;
>>   	}
>> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct
>> vring_used_elem *heads,
>>   
>>   	start = vq->last_used_idx & (vq->num - 1);
>>   	n = vq->num - start;
>> -	if (n < count) {
>> +	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>>   		r = __vhost_add_used_n(vq, heads, n);
>>   		if (r < 0)
>>   			return r;
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index d9109107af08..0d5c49a30421 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -236,6 +236,7 @@ enum {
>>   	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
>>   			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
>>   			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
>> +			 (1ULL << VIRTIO_F_IN_ORDER) |
>>   			 (1ULL << VHOST_F_LOG_ALL) |
> 
> 
> Are we sure all vhost devices can support in-order (especially the SCSI)?
> 
> It looks better to start from a device specific one.
> 
> Thanks
> 
Sorry for my mistake, I will change it.

> 
>>   			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
>>   			 (1ULL << VIRTIO_F_VERSION_1)
